/**
 * Copyright (c)2012-2019 Enterprise Architecture Solutions ltd. and the Essential Project
 * contributors.
 * This file is part of Essential Architecture Manager, 
 * the Essential Architecture Meta Model and The Essential Project.
 *
 * Essential Architecture Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Essential Architecture Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Essential Architecture Manager.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * 25.06.2012	JWC	First implementation of shared Essential Language Service
 * 28.06.2019	JWC Added use of log4J
 * 
 */
package com.enterprise_architecture.essential.report;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Class to manage the cookie that is used by the Essential Viewer Engine to configure the users' 
 * chosen display language.
 * Uses a number of Servlet Context Parameters that are provided by the calling servlets that use this
 * class, as follows:
 * <ul>
 * <li>i18n - the selected IETF language flag, e.g. en-gb</li>
 * <li>currentPage - the URL of the current page that was being viewed when the language was selected. 
 * This is used by the EssentialLanguageService to return the user to that page once the language selection has
 * been recorded - and is then applied to the currentPage.</li>
 * </ul>
 * The service also uses Servlet Context parameters that are set in <tt>web.xml</tt>:
 * <ul>
 * <li>i18nCookieName - the name of the Cookie to set. REQUIRED</li>
 * <li>i18nDefault - the default IETF language selection. If no value is set by the user, this value will be used in the users' Cookie.</li>
 * <li>i18nCookieDomain - the domain value to be used by the Cookie. Can be used when hosting Essential Viewer across multiple
 * servers and you wish the users' language choice to apply across all Essential Viewer servers in a domain. Leave this empty if no domain setting is required. OPTIONAL</li>
 * <li>cookieTimeout - the time in seconds that the Cookie remains valid on the users' browser</li>
 * </ul>
 * @author Jonathan W. Carter <info@enterprise-architecture.com>
 *
 */
public class EssentialLanguageCookie 
{
	/**
	 * Servlet Context parameter for the default i18n language code
	 */
	private static final String DEFAULT_I18N_PARAM = "i18nDefault";
	
	/**
	 * Servlet Context parameter for the language cookie name
	 */
	private static final String COOKIE_NAME_PARAM = "i18nCookieName";
	
	/**
	 * Servlet Context parameter for the language cookie domain
	 */
	private static final String COOKIE_DOMAIN_PARAM = "i18nCookieDomain";
	
	/**
	 * Servlet Context parameter for the language cookie timeout / max age
	 */
	private static final String COOKIE_MAX_AGE_PARAM = "cookieTimeout";
	
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(EssentialLanguageCookie.class);	
	
	/**
	 * Cookie path value;  equals /
	 */
	private static final String COOKIE_PATH = "/";
	
	/**
	 * Field to hold the default i18n language. Controlled by a servlet context parameter
	 */
	private String itsI18NDefault = "en-gb";

	/**
	 * Field to hold the language cookie name. Controlled by a servlet context parameter
	 */
	private String itsCookieName = "essential_viewer.i18n";
	
	/**
	 * Field to hold the language cookie domain. Defaults to empty string and ontrolled by a servlet context parameter
	 */
	private String itsCookieDomain = "";
	
	/**
	 * Field to hold the maximum cookie age / timeout. Controlled by a servlet context parameter
	 */
	private int itsCookieMaxAge = 31536000;
	
	/**
	 * Define the regular expression that describes a valid language code
	 */
	private String itsValidValuePattern = "^[A-Za-z]{1,8}(-[A-Za-z0-9]{1,8})*$";
	
	/**
	 * Default - and only constructor for the EssentialLanguageCookie.
	 * Create new instance and pick up configuration from servlet context
	 * @param theServletContext context that contains the configuration parameters.
	 */
	public EssentialLanguageCookie(ServletContext theServletContext)
	{
		// Get the parameters from the web.xml
		itsI18NDefault = theServletContext.getInitParameter(DEFAULT_I18N_PARAM);
		itsCookieName = theServletContext.getInitParameter(COOKIE_NAME_PARAM);
		itsCookieDomain = theServletContext.getInitParameter(COOKIE_DOMAIN_PARAM);
		itsCookieMaxAge = Integer.valueOf(theServletContext.getInitParameter(COOKIE_MAX_AGE_PARAM));
	}
	
	/**
	 * Set the requested language in the cookie and save the user's selection
	 * @param theRequest the request from the user
	 * @param theResponse the response to the user, in which the cookie will be saved
	 * @param theLanguageCode the selected language code.
	 */
	public void setLanguage(HttpServletRequest theRequest, HttpServletResponse theResponse, String theLanguageCode)
	{
		// If the language code is empty or null, set to default
		if(theLanguageCode == null || theLanguageCode.length() == 0)
		{
			theLanguageCode = itsI18NDefault;
		}
		
		// Get the i18n cookie from the request.
		Cookie[] aCookieList = theRequest.getCookies();
		Cookie anI18n = null;
		boolean isFound = false;
		if(aCookieList != null)
		{
			for (int i = 0; i < aCookieList.length; i++)
			{
				anI18n = aCookieList[i];
				String aCookieName = anI18n.getName();
				if (aCookieName.equals(itsCookieName))
				{
					isFound = true;
					break;
				}
			}
		}
		
		// Make sure that a valid language code has been supplied
		String aValidLanguageCode = getLanguageCode(theLanguageCode);
		
		// If it's not there, create it.
		if(!isFound || (anI18n == null))
		{
			anI18n = new Cookie(itsCookieName, aValidLanguageCode);
		}
				
		// Save theLanguageCode in the cookie		
		anI18n.setValue(aValidLanguageCode);
		anI18n.setMaxAge(itsCookieMaxAge);
		anI18n.setPath(COOKIE_PATH);
		anI18n.setSecure(true);
		// Set HTTPOnly=true when we move to Servlet 3.0 
		//anI18n.setHttpOnly(true);
		if(itsCookieDomain.length() > 0)
		{
			anI18n.setDomain(itsCookieDomain);
		}
			
		// Save the cookie in the response.
		theResponse.addCookie(anI18n);
	}

	/**
	 * Find the user's selected language code from the language cookie
	 * @param theRequest the user request containing the language cookie
	 * @return the selected i18n language code. 
	 */
	public String getLanguage(HttpServletRequest theRequest, HttpServletResponse theResponse)
	{
		String anI18NCode = "";
		
		// Get the cookie from the request
		Cookie[] aCookieList = theRequest.getCookies();
		Cookie anI18n = null;
		boolean isFound = false;
		if(aCookieList != null)
		{
			for (int i = 0; i < aCookieList.length; i++)
			{
				anI18n = aCookieList[i];
				String aCookieName = anI18n.getName();
				if (aCookieName.equals(itsCookieName))
				{
					isFound = true;
					break;
				}
			}
		}
		
		// If it's not there, create it and set to default value
		if(!isFound || (anI18n == null))
		{
			anI18n = new Cookie(itsCookieName, itsI18NDefault);
			anI18n.setMaxAge(itsCookieMaxAge);
			anI18n.setPath(COOKIE_PATH);
			if(itsCookieDomain.length() > 0)
			{
				anI18n.setDomain(itsCookieDomain);
			}
			
			// Save the cookie in the response.
			theResponse.addCookie(anI18n);
		}
				
		// Get theLanguageCode in the cookie
		anI18NCode = anI18n.getValue();
				
		return anI18NCode;
	}
	
	/**
	 * @return the itsI18NDefault
	 */
	public String getItsI18NDefault() {
		return itsI18NDefault;
	}

	/**
	 * @param itsI18NDefault the itsI18NDefault to set
	 */
	public void setItsI18NDefault(String itsI18NDefault) {
		this.itsI18NDefault = itsI18NDefault;
	}

	/**
	 * @return the itsCookieName
	 */
	public String getItsCookieName() {
		return itsCookieName;
	}

	/**
	 * @param itsCookieName the itsCookieName to set
	 */
	public void setItsCookieName(String itsCookieName) {
		this.itsCookieName = itsCookieName;
	}

	/**
	 * @return the itsCookieDomain
	 */
	public String getItsCookieDomain() {
		return itsCookieDomain;
	}

	/**
	 * @param itsCookieDomain the itsCookieDomain to set
	 */
	public void setItsCookieDomain(String itsCookieDomain) {
		this.itsCookieDomain = itsCookieDomain;
	}

	/**
	 * @return the itsCookieMaxAge
	 */
	public int getItsCookieMaxAge() {
		return itsCookieMaxAge;
	}

	/**
	 * @param itsCookieMaxAge the itsCookieMaxAge to set
	 */
	public void setItsCookieMaxAge(int itsCookieMaxAge) {
		this.itsCookieMaxAge = itsCookieMaxAge;
	}
	
	/**
	 * Get a 'safe', validated language code from the requested LanguageSetting
	 * @param theLanguageSetting
	 * @return the safe, validated language code
	 */
	private String getLanguageCode(String theLanguageSetting)
	{
		String aLanguageSetting = itsI18NDefault;

		// Debug
		itsLog.debug("EssentialLanguageCookie.getLanguageCode() ===> theLanguageSetting: {}", theLanguageSetting);
		itsLog.debug("EssentialLanguageCookie.getLanguageCode() ===> aLanguageSetting: {}", aLanguageSetting);
		
		// Valid pattern is aa-bb, nothing else is a valid code		
		if(theLanguageSetting.matches(itsValidValuePattern))
		{
			aLanguageSetting = theLanguageSetting;
		}
		else
		{
			// If theLanguageSetting doesn't match the pattern, log this and return default setting
			// as the language setting is otherwise broken
			itsLog.error("EssentialLanguageCookie.getLanguageCode() ===> invalid language code specified to Viewer. Using default setting instead");
		}
		// Debug
		itsLog.debug("EssentialLanguageCookie.getLanguageCode() ===> aLanguageSetting: {}", aLanguageSetting);		
		return aLanguageSetting;
	}
}
