/**
 * Copyright (c)2020 Enterprise Architecture Solutions ltd.
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
 * 27.03.2020	JWC	First coding
 */
package com.enterprise_architecture.essential.report.security;


import com.enterprise_architecture.essential.report.ReportAPIServlet;

/**
 * Secure version of the ReportAPIServlet. Receives requests to the Secure (Cloud) Essential
 * Viewer and applies security policies to those requests 
 * 
 * @author Jonathan Carter
 *
 */
public class SecureReportAPIServlet extends ReportAPIServlet 
{

	/**
	 * Default serial version ID
	 */
	private static final long serialVersionUID = 1L;
	
	/** Initialise the instance of the class. No override action
	 * 
	 */
	public SecureReportAPIServlet()
	{
		super();		
	}
	
	/**
	 * Tidy up any open resources before destroying the servlet
	 * In particular the Neo4J driver
	 */
	@Override
	public void destroy()
	{
		ViewerSecurityManager aSecurityManager = (ViewerSecurityManager) getServletContext().getAttribute(SecureEssentialViewerEngine.VIEWER_SECURITY_MANAGER_SINGLETON_VARNAME);
		if(aSecurityManager != null)
		{
			aSecurityManager.closeResources();
		}
	}
	
	/**
	 * Create a secure implementation of the Report API Engine
	 * @return an instance of an implementation of the Report API Engine that applies security
	 * @see com.enterprise_architecture.essential.report.security.SecureReportAPIEngine
	 */
	@Override
	protected SecureReportAPIEngine getReportAPIEngine()
	{
		SecureReportAPIEngine anEngine = new SecureReportAPIEngine(getServletContext());
		return anEngine;
	}
	
	/**
	 * Create a secure implementation of the Essential Viewer Engine
	 * @return an instance of an implementation of Essential Viewer Engine that applies security
	 * @see com.enterprise_architecture.essential.report.security.SecureEssentialViewerEngine
	 */
	@Override
	protected SecureEssentialViewerEngine getViewerEngine()
	{
		SecureEssentialViewerEngine anEngine = new SecureEssentialViewerEngine(getServletContext());		
		return anEngine;
	}


}
