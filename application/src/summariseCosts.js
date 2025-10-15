const MS_PER_DAY = 24 * 60 * 60 * 1000;
const BASE_CURRENCY_FALLBACK = 'GBP';

const toMinorUnits = (value) => Math.round(value * 100);
const minorToNumber = (minor) => minor / 100;

const round2 = (value) => Math.round((value + Number.EPSILON) * 100) / 100;

const parseISODate = (value) => {
	if (!value) {
		return null;
	}
	const date = new Date(value);
	if (Number.isNaN(date.getTime())) {
		return null;
	}
	return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()));
};

const isValidDate = (value) => value instanceof Date && !Number.isNaN(value.getTime());

const daysBetweenInclusive = (start, end) => {
	if (end < start) {
		return 0;
	}
	return Math.floor((end.getTime() - start.getTime()) / MS_PER_DAY) + 1;
};

const getProrationDetails = (start, end, periodStart, periodEnd) => {
	const startDate = parseISODate(start);
	const endDate = parseISODate(end);
	const periodDays = daysBetweenInclusive(periodStart, periodEnd);

	if (!periodDays) {
		return { factor: 0, overlapDays: 0, periodDays: 0, effectiveStart: null, effectiveEnd: null };
	}

	if (startDate && endDate && endDate < startDate) {
		return { factor: 0, overlapDays: 0, periodDays, effectiveStart: null, effectiveEnd: null };
	}

	const effectiveStart = (startDate && startDate > periodStart) ? startDate : periodStart;
	const effectiveEndCandidate = (endDate && endDate < periodEnd) ? endDate : periodEnd;

	if (effectiveEndCandidate < effectiveStart) {
		return { factor: 0, overlapDays: 0, periodDays, effectiveStart: null, effectiveEnd: null };
	}

	const effectiveEnd = effectiveEndCandidate;
	const overlapDays = daysBetweenInclusive(effectiveStart, effectiveEnd);

	return {
		factor: overlapDays / periodDays,
		overlapDays,
		periodDays,
		effectiveStart,
		effectiveEnd
	};
};

const getProrationFactor = (start, end, periodStart, periodEnd) => {
	const details = getProrationDetails(start, end, periodStart, periodEnd);
	return details.periodDays > 0 ? details.overlapDays / details.periodDays : 0;
};

const normaliseAnnual = (amountMinor, frequency) => {
	switch (frequency) {
		case 'annual':
			return amountMinor;
		case 'quarterly':
			return amountMinor * 4;
		case 'monthly':
			return amountMinor * 12;
		case 'adhoc':
			return 0;
		default:
			throw new Error(`Unknown frequency '${frequency}'`);
	}
};

const convertCurrencyMinor = (amountMinor, fromCurrency, toCurrency, exchangeRates, baseCurrency) => {
	const from = (fromCurrency || baseCurrency).toUpperCase();
	const to = (toCurrency || baseCurrency).toUpperCase();
	if (from === to) {
		return amountMinor;
	}
	const fromRate = exchangeRates[from];
	const toRate = exchangeRates[to];
	if (!Number.isFinite(fromRate) || fromRate <= 0 || !Number.isFinite(toRate) || toRate <= 0) {
		const missing = [];
		if (!Number.isFinite(fromRate) || fromRate <= 0) missing.push(from);
		if (!Number.isFinite(toRate) || toRate <= 0) missing.push(to);
		throw new Error(`Missing exchange rate(s): ${missing.join(', ')}`);
	}
	const amountInBase = (amountMinor / 100) / fromRate;
	const amountInTarget = amountInBase * toRate;
	return Math.round(amountInTarget * 100);
};

const getCurrentYearPeriod = () => {
	const now = new Date();
	const start = new Date(Date.UTC(now.getUTCFullYear(), 0, 1));
	const end = new Date(Date.UTC(now.getUTCFullYear(), 11, 31));
	return { start, end };
};

const ensureRates = (costs, exchangeRates, baseCurrency, targetCurrency) => {
	const required = new Set([baseCurrency, targetCurrency]);
	costs.forEach((cost) => {
		if (cost.currency) {
			required.add(cost.currency.toUpperCase());
		}
	});
	const missing = Array.from(required).filter((code) => {
		const rate = exchangeRates[code];
		return !Number.isFinite(rate) || rate <= 0;
	});
	if (missing.length) {
		throw new Error(`Missing exchange rate(s): ${missing.join(', ')}`);
	}
};

const summariseCosts = (costs, exchangeRates, options = {}) => {
	const {
		targetCurrency,
		periodStart,
		periodEnd,
		includeAdhoc = false,
		baseCurrency: providedBaseCurrency
	} = options;

	const baseCurrency = (providedBaseCurrency || BASE_CURRENCY_FALLBACK).toUpperCase();
	const target = (targetCurrency || baseCurrency).toUpperCase();

	const rates = { ...exchangeRates };
	if (!Number.isFinite(rates[baseCurrency]) || rates[baseCurrency] <= 0) {
		rates[baseCurrency] = 1;
	}

	const periodBounds = (() => {
		const defaults = getCurrentYearPeriod();
		const start = periodStart ? parseISODate(periodStart) : defaults.start;
		const end = periodEnd ? parseISODate(periodEnd) : defaults.end;
		if (!isValidDate(start) || !isValidDate(end) || end < start) {
			throw new Error('Invalid reporting period');
		}
		return { start, end };
	})();

	ensureRates(costs, rates, baseCurrency, target);

	let totalAnnualMinor = 0;
	let totalAdhocMinor = 0;
	const breakdown = [];

	costs.forEach((cost) => {
		const {
			factor,
			overlapDays,
			periodDays
		} = getProrationDetails(
			cost.startDate,
			cost.endDate,
			periodBounds.start,
			periodBounds.end
		);

		const amountMinor = toMinorUnits(cost.amount);
		const currency = (cost.currency || baseCurrency).toUpperCase();
		const isRecurring = cost.frequency !== 'adhoc';
		let annualMinorTarget = 0;

		if (isRecurring && overlapDays > 0 && periodDays > 0) {
			const annualMinor = normaliseAnnual(amountMinor, cost.frequency);
			const proratedMinor = Math.round(annualMinor * factor);
			annualMinorTarget = convertCurrencyMinor(proratedMinor, currency, target, rates, baseCurrency);
			totalAnnualMinor += annualMinorTarget;
		}

		if (!isRecurring && includeAdhoc && overlapDays > 0) {
			const adhocMinor = convertCurrencyMinor(amountMinor, currency, target, rates, baseCurrency);
			totalAdhocMinor += adhocMinor;
			breakdown.push({
				id: cost.id,
				annual: 0,
				monthly: 0,
				included: true
			});
			return;
		}

		const monthlyMinor = isRecurring ? Math.round(annualMinorTarget / 12) : 0;
		breakdown.push({
			id: cost.id,
			annual: round2(minorToNumber(annualMinorTarget)),
			monthly: round2(minorToNumber(monthlyMinor)),
			included: isRecurring && overlapDays > 0
		});
	});

	const summary = {
		currency: target,
		totals: {
			annual: round2(minorToNumber(totalAnnualMinor)),
			monthly: round2(minorToNumber(Math.round(totalAnnualMinor / 12)))
		},
		breakdown
	};

	if (includeAdhoc) {
		summary.totals.adhoc = round2(minorToNumber(totalAdhocMinor));
	}

	return summary;
};

module.exports = {
	summariseCosts,
	getProrationFactor
};
