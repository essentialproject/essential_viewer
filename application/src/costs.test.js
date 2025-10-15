const assert = require('assert').strict;
const {
	summariseCosts,
	getProrationFactor
} = require('./summariseCosts');

const baseRates = {
	GBP: 1,
	EUR: 1.16,
	USD: 1.3
};

const periodOptions = {
	periodStart: '2024-01-01',
	periodEnd: '2024-12-31',
	baseCurrency: 'GBP'
};

const almostEqual = (actual, expected, tolerance = 0.01) => {
	assert.ok(
		Math.abs(actual - expected) <= tolerance,
		`Expected ${expected}, received ${actual}`
	);
};

const testQuarterlyCost = () => {
	const costs = [
		{ id: 'quarterly', amount: 250, frequency: 'quarterly', currency: 'GBP' }
	];
	const summary = summariseCosts(costs, baseRates, periodOptions);
	almostEqual(summary.totals.annual, 1000);
	almostEqual(summary.totals.monthly, 83.33);
	assert.equal(summary.currency, 'GBP');
};

const testMonthlyEuroCost = () => {
	const costs = [
		{
			id: 'monthly-eur',
			amount: 100,
			frequency: 'monthly',
			currency: 'EUR',
			startDate: '2024-03-01',
			endDate: '2024-12-31'
		}
	];
	const summary = summariseCosts(costs, baseRates, periodOptions);
	almostEqual(summary.totals.annual, 862.07);
	almostEqual(summary.totals.monthly, 71.84);
};

const testAnnualUsdCost = () => {
	const costs = [
		{
			id: 'annual-usd',
			amount: 1200,
			frequency: 'annual',
			currency: 'USD',
			startDate: '2024-07-01',
			endDate: '2024-12-31'
		}
	];
	const summary = summariseCosts(costs, baseRates, periodOptions);
	almostEqual(summary.totals.annual, 461.54);
	almostEqual(summary.totals.monthly, 38.46);
};

const testAdhocCost = () => {
	const costs = [
		{
			id: 'adhoc',
			amount: 500,
			frequency: 'adhoc',
			currency: 'GBP',
			startDate: '2024-05-15'
		}
	];

	const excluded = summariseCosts(costs, baseRates, periodOptions);
	assert.equal(excluded.totals.annual, 0);
	assert.equal(excluded.totals.monthly, 0);
	assert.equal(excluded.totals.adhoc, undefined);

	const included = summariseCosts(costs, baseRates, {
		...periodOptions,
		includeAdhoc: true
	});
	assert.equal(included.totals.annual, 0);
	assert.equal(included.totals.monthly, 0);
	assert.equal(included.totals.adhoc, 500);
};

const testMissingExchangeRate = () => {
	const costs = [
		{ id: 'yen', amount: 1000, frequency: 'annual', currency: 'JPY' }
	];
	assert.throws(
		() => summariseCosts(costs, baseRates, periodOptions),
		/Missing exchange rate\(s\): JPY/
	);
};

const testTargetCurrencyConversion = () => {
	const costs = [
		{ id: 'gbp', amount: 1200, frequency: 'annual', currency: 'GBP' }
	];
	const summary = summariseCosts(costs, baseRates, {
		...periodOptions,
		targetCurrency: 'USD'
	});
	almostEqual(summary.totals.annual, 1560); // 1200 GBP * 1.3 USD
	almostEqual(summary.totals.monthly, 130);
	assert.equal(summary.currency, 'USD');
};

const testProrationFactor = () => {
	const periodStart = new Date(Date.UTC(2024, 0, 1));
	const periodEnd = new Date(Date.UTC(2024, 11, 31));
	const factor = getProrationFactor('2024-07-01', '2024-12-31', periodStart, periodEnd);
	almostEqual(factor, 0.5, 0.02); // allow slight tolerance for leap considerations
};

const run = () => {
	testQuarterlyCost();
	testMonthlyEuroCost();
	testAnnualUsdCost();
	testAdhocCost();
	testMissingExchangeRate();
	testTargetCurrencyConversion();
	testProrationFactor();
	console.log('All cost summarisation tests passed.');
};

try {
	run();
} catch (error) {
	console.error('Test failure:', error);
	process.exitCode = 1;
}
