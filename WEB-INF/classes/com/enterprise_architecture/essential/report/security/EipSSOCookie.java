/**
 * Copyright (c)2015-2016 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 02.04.2015	JWC	First implementation of shared EIP Single Sign On Cookie
 * 31.07.2015	JWC Reworked the Cookie domain to support local and server-based hostnames
 * 
 */
package com.enterprise_architecture.essential.report.security;

import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Class to manage the cookie that is used by the Secure Essential Viewer Engine to find a user session
 * from the EIP data management application.
 * @author Jonathan W. Carter <info@enterprise-architecture.com>
 *
 */
public class EipSSOCookie 
{
	
	/**
	 * Cookie path value;  equals /
	 */
	private static final String COOKIE_PATH = "/";
	
	/**
	 * Field to hold the default i18n language. Controlled by a servlet context parameter
	 */
	private String itsAccountID = "";

	/**
	 * Field to hold the language cookie name. Controlled by a servlet context parameter
	 */
	private String itsCookieName = "eip.session.token";
	
	/**
	 * Field to hold the language cookie domain. Defaults to empty string and ontrolled by a servlet context parameter
	 */
	private String itsCookieDomain = "";
	
	/**
	 * Field to hold the maximum cookie age / timeout. Controlled by a servlet context parameter
	 */
	private int itsCookieMaxAge = 3600;
	
	/**
	 * Default - and only constructor for the EssentialLanguageCookie.
	 * @param theServletContext context that contains the configuration parameters.
	 */
	public EipSSOCookie(ServletContext theServletContext)
	{
		// Get the parameters from the web.xml
	}
	
	/**
	 * Set the requested account token in the cookie
	 * @param theRequest the request from the user
	 * @param theResponse the response to the user, in which the cookie will be saved
	 * @param theAccoutID the ID of the user account.
	 */
	public void setAccountID(HttpServletRequest theRequest, HttpServletResponse theResponse, String theAccountID, String theDomain)
	{
		// If the account ID is empty or null, set to default
		if(theAccountID != null || theAccountID.length() != 0)
		{
			// Get the account ID cookie from the request.
			Cookie[] aCookieList = theRequest.getCookies();
			Cookie anAccount = null;
			boolean isFound = false;
			if(aCookieList != null)
			{
				for (int i = 0; i < aCookieList.length; i++)
				{
					anAccount = aCookieList[i];
					String aCookieName = anAccount.getName();
					if (aCookieName.equals(itsCookieName))
					{
						isFound = true;
						break;
					}
				}
			}
			
			// If it's not there, create it.
			if(!isFound || (anAccount == null))
			{
				anAccount = new Cookie(itsCookieName, theAccountID);
			}
					
			// Save account ID in the cookie		
			anAccount.setValue(theAccountID);
			anAccount.setMaxAge(itsCookieMaxAge);
			anAccount.setPath(COOKIE_PATH);			
			String aCookieDomain = buildCookieDomain(theDomain);
			
			// TRACE - Cookie Domain
			//System.out.println("EipSSOCookie.setAccountID: Cookie domain set to:" + aCookieDomain);
			
			if(theDomain.length() > 0)
			{
				setItsCookieDomain(aCookieDomain);
				anAccount.setDomain(aCookieDomain);
			}
				
			// Save the cookie in the response.
			theResponse.addCookie(anAccount);

		}
		
	}

	/**
	 * Find the user's account ID from the account token cookie
	 * @param theRequest the user request containing the account token cookie
	 * @return the user account ID from the token. 
	 */
	public String getAccountID(HttpServletRequest theRequest)
	{
		String anAccountID = null;
		
		// Get the cookie from the request
		Cookie[] aCookieList = theRequest.getCookies();
		Cookie anAccount = null;
		boolean isFound = false;
		if(aCookieList != null)
		{
			for (int i = 0; i < aCookieList.length; i++)
			{
				anAccount = aCookieList[i];
				String aCookieName = anAccount.getName();
				if (aCookieName.equals(itsCookieName))
				{
					isFound = true;
					break;
				}
			}
		}
		
		if(isFound)
		{
			// Get the account ID in the cookie
			anAccountID = anAccount.getValue();	
		}
				
		return anAccountID;
	}
	
	/**
	 * Remove the Single Sign On account token from the Cookie.
	 * @param theRequest the request from the user
	 * @param theResponse the response, from which the Cookie will be removed
	 * @param theDomain the domain scope for the cookie - limited to a tenant domain
	 */
	public void removeAccountID(HttpServletRequest theRequest, HttpServletResponse theResponse, String theDomain)
	{
		// Get the account ID cookie from the request.
		Cookie[] aCookieList = theRequest.getCookies();
		Cookie anAccount = null;
		boolean isFound = false;
		if(aCookieList != null)
		{
			for (int i = 0; i < aCookieList.length; i++)
			{
				anAccount = aCookieList[i];
				String aCookieName = anAccount.getName();
				if (aCookieName.equals(itsCookieName))
				{
					isFound = true;
					break;
				}
			}
		}
		// TRACE - Cookie Domain
		//System.out.println("EipSSOCookie.removeAccountID: Cookie domain set to: " + theDomain);
		// TRACE - Cookie Domain
		String aCookieDomain = buildCookieDomain(theDomain);		
		//System.out.println("EipSSOCookie.removeAccountID/buildCookieDomain set to: " + aCookieDomain);
					
		// If it's found, remove it.
		if(isFound && anAccount != null)
		{
			// Reset the cookie		
			anAccount.setValue(null);
			anAccount.setMaxAge(0);
			anAccount.setPath(COOKIE_PATH);
			if(aCookieDomain.length() > 0)
			{
				setItsCookieDomain(aCookieDomain);
				anAccount.setDomain(aCookieDomain);	
			}
			
			// Save the cookie in the response.
			theResponse.addCookie(anAccount);
			
		}		
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
	 * Build the correct Cookie domain specifier from the supplied domain.
	 * Handles localhost / specific host plus SAAS deployment
	 * @param theDomain the supplied server domain of the web application
	 * @return a corrected Cookie domain for the Cookie.setDomain() operation.
	 */
	protected String buildCookieDomain(String theDomain)
	{
		String aCorrectedDomain = "";
		
		// Read theDomain and reduce to 2-part domain or less
		int aLastDomainLevel = theDomain.lastIndexOf(".");
		if(aLastDomainLevel < 0)
		{
			// No dot - specific host supplied
			aCorrectedDomain = "." + theDomain;
			return aCorrectedDomain;
		}
		else
		{
			String aDomainString = theDomain.substring(0, aLastDomainLevel -1);
			int aTopLevelDomainStart = aDomainString.lastIndexOf(".");
			if(aTopLevelDomainStart > 0)
			{
				aCorrectedDomain = theDomain.substring(aTopLevelDomainStart);
			}
			else
			{
				aCorrectedDomain = "." + theDomain;
			}
		}
		
		return aCorrectedDomain;
	}
}
