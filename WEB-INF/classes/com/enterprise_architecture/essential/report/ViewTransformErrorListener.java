/**
 * Copyright (c)2011-2012 Enterprise Architecture Solutions ltd. and the Essential Project
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
 * 10.11.2011	JWC	First coding
 * 02.02.2012	JWC	Added method to record error messages that have been reported.
 */
package com.enterprise_architecture.essential.report;

import java.util.ArrayList;

import javax.xml.transform.ErrorListener;
import javax.xml.transform.TransformerException;

/**
 * Error Listener class for capturing errors encountered by the XML Transformer during load of the XSL
 * or the transform of the XML. Create a new instance of this class for each Transformer instance to ensure
 * that it is thread-safe. E.g. Create a local instance of this class in the Servlet request methods.<br/>
 * This class listens to recoverable errors, fatal errors and warnings and saves them in a String list.  
 * 
 * @author Jonathan Carter
 * @see com.enterprise_architecture.essential.report.ReportServlet
 * @see com.enterprise_architecture.essential.report.EssentialViewerEngine 
 * @since 2.2
 * @version 2.3
 */
public class ViewTransformErrorListener implements ErrorListener 
{
	/**
	 * Constant value that defines the prefix that is added to warning messages that are received
	 */
	public static final String WARNING_PREFIX = "Warning: ";
	
	/**
	 * Constant value that defines the prefix that is added to warning messages that are received
	 */
	public static final String ERROR_PREFIX = "Error: ";
	
	/**
	 * Constant value that defines the prefix that is added to warning messages that are received
	 */
	public static final String FATAL_PREFIX = "Fatal Error: ";
	
	/** 
	 * The initial size of the error list
	 */
	private static final int ERROR_LIST_INITIAL_SIZE = 5;
	
	/**
	 * An ArrayList containing each of the errors, fatal errors and warnings that are received.
	 */
	private ArrayList<String> itsTransformErrorList;
	
	/**
	 * Default constructor - initialise the error message handler.
	 */
	public ViewTransformErrorListener()
	{
		itsTransformErrorList = new ArrayList<String>(ERROR_LIST_INITIAL_SIZE);
	}
	
	/**
	 * Get any error messages that has been raised by the Transformer.
	 * @return the itsTransformError containing the list of received error messages. If no error has been raised, empty list.
	 */
	public ArrayList<String> getItsTransformError() 
	{
		return itsTransformErrorList;
	}

	/**
	 * Set the error message list that is being managed by this class.
	 * @param theTransformErrorList the error message list to use
	 */
	public void setItsTransformError(ArrayList<String> theTransformErrorList) 
	{
		itsTransformErrorList.clear();
		itsTransformErrorList.addAll(theTransformErrorList);
	}
	
	/**
	 * Record that the reported errors have been reported and remove them from 
	 * the current list of errors.
	 * @param theReportedErrors the set of reported error messages
	 * @since version 2.3
	 */
	public void reportedErrors(ArrayList<String> theReportedErrors)
	{
		itsTransformErrorList.removeAll(theReportedErrors);
	}

	/**
	 * Receive a new error, warning or fatal error message and add it to the list that 
	 * have been received.
	 * @param theMessage the new error, fatal error or warning message to receive.
	 */
	public void receiveMessage(String theMessage)
	{
		itsTransformErrorList.add(theMessage);
	}
	
	/**
	 * Listen for any non-fatal (recoverable) error messages raised by the Transformer and save them in itsTransformErrorMessage.
	 * @param exception the error that is raised by the XML Parser / XSLT transformer
	 * @throws TransformerException
	 * @since 2.2
	 */
	public void error(TransformerException exception)
			throws TransformerException 
	{
		// Find the reported error
		String anError = ERROR_PREFIX + exception.getMessageAndLocation();
		receiveMessage(anError);
	}

	/**
	 * Listen for any fatal error messages raised by the Transformer and save them in itsTransformErrorMessage.
	 * @param exception the error that is raised by the XML Parser / XSLT transformer.
	 * @throws TransformerException
	 * @since 2.2
	 */
	public void fatalError(TransformerException exception)
			throws TransformerException 
	{
		// Find the reported error
		String anError = FATAL_PREFIX + exception.getMessageAndLocation();		
		receiveMessage(anError);	
	}

	/**
	 * Listen for any warning messages reported by the Transformer and save them in itsTransformErrorMessage.
	 * @param exception the exception that is raised by the XML Parser / XSLT transformer.
	 * @throws TransformerException
	 * @since 2.2
	 */
	public void warning(TransformerException exception)
			throws TransformerException 
	{
		// Find the reported error
		String anError = WARNING_PREFIX + exception.getMessageAndLocation();
		receiveMessage(anError);		
	}

}
