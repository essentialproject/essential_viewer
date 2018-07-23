/**
 * Copyright (c)2007-2008 Enterprise Architecture Solutions ltd.
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
 * 04.05.2008	JP	first release
 * 27.04.2009	JWC	Javadoc typo fixed
 */
package com.enterprise_architecture.essential.report;

import java.util.HashMap;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
// import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Manage the creation of contained in a report that maps data along a y-axis to data
 * on an x-axis.<br>
 * Access to the cells that make up the mapping table in the report is
 * provided by this service.
 * <br>Usage:
 * <br>Specify the instances in the repository that is used to determine the x and y axes,
 * an XSLT that constructs an XML document from these instances, conforming to 
 * <tt>binaryMapping.xsd</tt>. The XML document is parsed, and interfaces are provided
 * to access the Java objects for the cells in the rsulting mapping table - in readiness
 * for rendering.
 * <br> Example:<br>
 * <i>xInstance is e.g. an instance of a parent Business_Capability; xParamName
 * is the name of the parameter used in the XSLT to refer to xInstance;
 * yInstance is e.g. an instance of a parent Actor;
 * yParamName is the name of the parameter used in the XSLT to refer to yInstance;
 * aRepository is the XML representation of the repository; and anXSLT is
 * the XLST that gets the required data out of the repository for this process
 * </i>
 * <tt>
 * 
 * BinaryMappingService aBinaryMappingService = new BinaryMappingService(xInstance,
 * 														   xParamName, yInstance
 * 														   yParamName, aRepository, 
 * 														   anXLST);
 * HashMap mappingTable = aBinaryMappingService.getMappingTable();
 * ArrayList xHeadings = aBinaryMappingService.getXHeadings();
 * String getHeading = aBinaryMappingService.getHeading();
 * String getSubHeading = aBinaryMappingService.getSubHeading();
 * ...
 * </tt>
 * Alternatively, a Properties object can be sent to the constructor to pass a 
 * variable number of parameters to the XSL.
 * @author Jason Powell <jason.powell@e-asoltuions.com>
 * @since version 1.0
 * @version 1.0
 *
 */

public class BinaryMappingService {
	private String heading;
	private String subHeading;
	private String introText;
	private String greenLabel;
	private String amberLabel;
	private String redLabel;
	private float firstColumnWidth;
	private float mappingColumnWidth;
	
	private ArrayList<String> xHeadings;
	private HashMap<String, ArrayList<BinaryMappingCellBean>> mappingTable;
	
	private String xXSLTVarName = "param1"; // default name.
	private String yXSLTVarName = "param2"; // default name.
	
	/**
	 * Default constructor. The ArrayList of cells is initialised to 
	 * an empty HashMap.
	 *
	 */
	public BinaryMappingService()
	{
		xHeadings = new ArrayList<String>();
		mappingTable = new HashMap<String, ArrayList<BinaryMappingCellBean>>();
		
	}
	
	/**
	 * Convenience constructor that takes the name of the required repository
	 * instance that is to be reported on and the name of the XSLT file to use
	 * in order to gather the required data for the report.
	 * @param anXInstance the name of the required repository instance, e.g.  
	 * a Business_Process instance, to be used in the 'x' axis.
	 * @param anXInstanceParamName the name of the parameter used by the XSLT to
	 * find the specified instance.
	 * @param aYInstance the name of the required repository instance, e.g.  
	 * a Business_Process instance, to be used in the 'y' axis.
	 * @param aYInstanceParamName the name of the parameter used by the XSLT to
	 * find the specified instance.
	 * @param theRepository the name of the file that holds the repository.
	 * @param theXSLT the name of the XSLT file to use to select the information
	 * for the report. The REAL filename must be provided - get this from the
	 * ServletContext if invoking this from a Servlet or JSP.
	 */
	public BinaryMappingService(String anXInstance, 
							String anXInstanceParamName,
							String aYInstance, 
							String aYInstanceParamName,
							String theRepository, 
							String theXSLT)
	{
		xHeadings = new ArrayList<String>();
		mappingTable = new HashMap<String, ArrayList<BinaryMappingCellBean>>();
		
		// Call the method to initialise the service.
		Properties anXSLParamList = new Properties();
		anXSLParamList.setProperty(anXInstanceParamName, anXInstance);
		anXSLParamList.setProperty(aYInstanceParamName, aYInstance);

		this.getReportData(anXSLParamList, theRepository, theXSLT);
	}
	
	/**
	 * Convenience constructor that takes the name of the required repository
	 * instance that is to be reported on and the name of the XSLT file to use
	 * in order to gather the required data for the report.
	 * @param anXSLParamList the list of parameters sent to the call of the XSL stylesheet
	 * @param theRepository the name of the file that holds the repository.
	 * @param theXSLT the name of the XSLT file to use to select the information
	 * for the report. The REAL filename must be provided - get this from the
	 * ServletContext if invoking this from a Servlet or JSP.
	 */
	public BinaryMappingService(Properties anXSLParamList, 
							String theRepository, 
							String theXSLT) {
		xHeadings = new ArrayList<String>();
		mappingTable = new HashMap<String, ArrayList<BinaryMappingCellBean>>();
		
		this.getReportData(anXSLParamList, theRepository, theXSLT);
	}
	
	
	
	

	/**
	 * Find the data for the specified repository instance using the specified
	 * XSLT.
	 * @param theXSLParams the set of parameters that should be passed to the XSLT
	 * , such as the name of the required repository instance, e.g. a
	 * Business_Process instance. The parameter name is the Properties key and the
	 * parameter value is the Properties value
	 * @param theRepository the repository for the model that is being reported on.
	 * @param theXSLT an InputStream referring the XSLT document that is to be
	 * used to find the data from the repository.
	 */
	public void getReportData(Properties theXSLParams, InputStream theRepository, InputStream theXSLT)
	{
		// Create the SourceStream to the XSLT and get a transformer.
		TransformerFactory transFormFactory = TransformerFactory.newInstance();

		try
		{
			Transformer transformer = transFormFactory.newTransformer(new StreamSource(theXSLT));
			
			// Set the parameter that the XSLT requires.
			Enumeration aParamList = theXSLParams.propertyNames();
			while(aParamList.hasMoreElements())
			{
				String aParamKey = (String)aParamList.nextElement();
				String aParamValue = theXSLParams.getProperty(aParamKey);
				transformer.setParameter(aParamKey, aParamValue);
			}
	
			// Create a writer for the results
			StringWriter aResultXML = new StringWriter();
			
			// parse the document, looking for theInstance.
			transformer.transform(new StreamSource(theRepository), new StreamResult(aResultXML));
			
			System.out.println("TRANSFORMATION COMPLETE");
			this.saveReportSource("C:\\development_projects\\eclipse_wtp_workspace\\essential_architecture\\WebContent\\buscap_to_actor_mapping_result2.xml", aResultXML.toString());
			
			// Read the XML from the returned string.
	    	XMLReader xr = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");

	    	// Set the ContentHandler...
	    	BinaryMappingParser aParser = new BinaryMappingParser();
	    	  
	    	xr.setContentHandler(aParser);

	    	// Parse the XML
	    	xr.parse(new InputSource(new StringReader(aResultXML.toString())));	
	    	
	    	
	    	// Now get the required values from the parser
	    	this.xHeadings = aParser.getXLabels();
	    	Collections.sort(this.xHeadings);
	    	
	    	this.mappingTable = this.createMapOfArrays(this.xHeadings, aParser.getMappingTable());
	    	this.printMappingTable();
	    	
	    	this.heading = aParser.getHeading();
	    	this.subHeading = aParser.getSubHeading();
	    	this.introText = aParser.getIntroText();
	    	this.greenLabel = aParser.getGreenLabel();
	    	this.amberLabel = aParser.getAmberLabel();
	    	this.redLabel = aParser.getRedLabel();
	    	this.firstColumnWidth = 100 / (this.xHeadings.size() + 2) * 2; //the first column is twice the width of the others
	    	this.mappingColumnWidth = 100 / (this.xHeadings.size() + 2);
		}
		catch(TransformerException transEx)
		{
			System.err.println("Parsing error, finding " + theXSLParams + " exception:");
			System.err.println(transEx.toString());
		}
		catch(TransformerFactoryConfigurationError transConfigErr)
		{
			System.err.println("Parsing error, finding " + theXSLParams + " exception:");
			System.err.println(transConfigErr.toString());

		}
		catch(SAXException saxEx)
		{
			System.err.println("Parsing error, finding " + theXSLParams + " exception:");
			System.err.println(saxEx.toString());			
		}
		catch(IOException ioEx)
		{
			System.err.println("Parsing error, finding " + theXSLParams + " exception:");
			System.err.println(ioEx.toString());
		}
	}
	
	/**
	 * Alternative method that allows a filename to be used to specify the 
	 * required XSLT document. The REAL FILENAME must be used - get this
	 * from the servlet context before invoking this method.<br>
	 * Find the data for the specified repository instance using the specified
	 * XSLT.
	 * @param theXSLParams the set of parameters that should be passed to the XSLT
	 * , such as the name of the required repository instance, e.g. a
	 * Business_Process instance. The parameter name is the Properties key and the
	 * parameter value is the Properties value.
	 * @param theRepository the name of the file that holds the repository.
	 * @param theXSLTFilename an InputStream referring the XSLT document that is to be
	 * used to find the data from the repository.
	 */
	public void getReportData(Properties theXSLParams, String theRepository, String theXSLTFilename)
	{
		try
		{
			// Build a stream to the repository and the XSLTFile
			FileInputStream aRepos = new FileInputStream(theRepository);
			FileInputStream anXSLT = new FileInputStream(theXSLTFilename);
			
			// System.out.println("XSL File: " + theXSLTFilename);
			
			// call the InputStream-based method.
			getReportData(theXSLParams, aRepos, anXSLT);
		}
		catch(Exception ex)
		{
			System.err.println("Error reading files. Params: " + theXSLParams);
			System.err.println("Repository: " + theRepository);
			System.err.println("XSLT: " + theXSLTFilename);
			System.err.println(ex.toString());
		}
	}
	
	private HashMap<String, ArrayList<BinaryMappingCellBean>> createMapOfArrays(ArrayList headings, HashMap<String, HashMap<String, BinaryMappingCellBean>> map) {
		HashMap<String, ArrayList<BinaryMappingCellBean>> mapOfArrays = new HashMap<String, ArrayList<BinaryMappingCellBean>>();
		
		BinaryMappingCellBean emptyCell = new BinaryMappingCellBean();
		emptyCell.setColour(BinaryMappingCellBean.EMPTY);
		Set<String> rowLabels = map.keySet();
		Iterator<String> rowLabelIter = rowLabels.iterator();
		HashMap<String, BinaryMappingCellBean> aRow;
		String rowLabel, columnLabel;
		ArrayList<BinaryMappingCellBean> rowArray;
		BinaryMappingCellBean aCell;
		Iterator<String> columnLabelIter;
		while(rowLabelIter.hasNext()) {
			rowLabel = rowLabelIter.next();
			aRow = map.get(rowLabel);
			rowArray = new ArrayList<BinaryMappingCellBean>();
			columnLabelIter = this.xHeadings.iterator();
			while(columnLabelIter.hasNext()) {
				columnLabel = columnLabelIter.next();
				aCell = aRow.get(columnLabel);
				if(aCell == null) {
					aCell = emptyCell;
				}
				rowArray.add(aCell);
			}
			mapOfArrays.put(rowLabel, rowArray);
		}
		
		return mapOfArrays;
	}

	/**
	 * @return the amberLabel
	 */
	public String getAmberLabel() {
		return amberLabel;
	}

	/**
	 * @param amberLabel the amberLabel to set
	 */
	public void setAmberLabel(String amberLabel) {
		this.amberLabel = amberLabel;
	}

	/**
	 * @return the greenLabel
	 */
	public String getGreenLabel() {
		return greenLabel;
	}

	/**
	 * @param greenLabel the greenLabel to set
	 */
	public void setGreenLabel(String greenLabel) {
		this.greenLabel = greenLabel;
	}

	/**
	 * @return the heading
	 */
	public String getHeading() {
		return heading;
	}

	/**
	 * @param heading the heading to set
	 */
	public void setHeading(String heading) {
		this.heading = heading;
	}

	/**
	 * @return the introText
	 */
	public String getIntroText() {
		return introText;
	}

	/**
	 * @param introText the introText to set
	 */
	public void setIntroText(String introText) {
		this.introText = introText;
	}

	/**
	 * @return the mappingTable
	 */
	public HashMap<String, ArrayList<BinaryMappingCellBean>> getMappingTable() {
		return mappingTable;
	}

	/**
	 * @param mappingTable the mappingTable to set
	 */
	public void setMappingTable(
			HashMap<String, ArrayList<BinaryMappingCellBean>> mappingTable) {
		this.mappingTable = mappingTable;
	}

	/**
	 * @return the redLabel
	 */
	public String getRedLabel() {
		return redLabel;
	}

	/**
	 * @param redLabel the redLabel to set
	 */
	public void setRedLabel(String redLabel) {
		this.redLabel = redLabel;
	}

	/**
	 * @return the subHeading
	 */
	public String getSubHeading() {
		return subHeading;
	}

	/**
	 * @param subHeading the subHeading to set
	 */
	public void setSubHeading(String subHeading) {
		this.subHeading = subHeading;
	}
	
	/**
	 * @return the xHeadings
	 */
	public ArrayList<String> getHeadings() {
		return xHeadings;
	}

	/**
	 * @return the xHeadings
	 */
	public ArrayList<String> getXHeadings() {
		return xHeadings;
	}

	/**
	 * @param headings the xHeadings to set
	 */
	public void setXHeadings(ArrayList<String> headings) {
		xHeadings = headings;
	}
	
	
	protected synchronized boolean saveReportSource(String fileName, String theReportSource)
	{
		boolean isSuccess = false;
		
		// Open a file to save to.
		try
		{
			FileWriter aFile = new FileWriter(fileName);
						
			// Write the XML document
			aFile.write(theReportSource);
			
			// Close the file
			aFile.close();
			isSuccess = true;
		}
		catch (IOException ioEx)
		{
			System.err.println("Exception opening/writing EA repository source file");
			System.err.println(ioEx.getMessage());
			ioEx.printStackTrace(new PrintWriter(System.err));
		}
		
		return isSuccess;
	}
	
	protected void printMappingTable() {
	  System.out.println("PRINTING MAPPING TABLE");
	  Iterator xListIter = this.xHeadings.iterator();
  	  Set yLabels = this.mappingTable.keySet();
  	  Iterator yListIter = yLabels.iterator();
  	  String aYLabel, anXLabel;
  	  Set xLabels;
  	  ArrayList<BinaryMappingCellBean> tableRow;
  	  BinaryMappingCellBean cellBean;
  	  while(yListIter.hasNext()) {
  		  aYLabel = (String) yListIter.next();
  		  System.out.println("PRINTING ROW:" + aYLabel);
  		  tableRow = mappingTable.get(aYLabel);
  		  for(int i=0;i<this.xHeadings.size();i++) {
  			  cellBean = tableRow.get(i);
  			  System.out.println("PRINTING CELL FOR COLUMN:" + xHeadings.get(i));
  			  System.out.println(cellBean.getColour());
  			  System.out.println(cellBean.getSubTitle());
  			  System.out.println(cellBean.getSubDescription());
  		  }
  		  System.out.println();
  		
  	  }
  	  
  	  System.out.println("No of rows: " + this.getMappingTable().size());
  	  
	}

	/**
	 * @return the firstColumnWidth
	 */
	public float getFirstColumnWidth() {
		return firstColumnWidth;
	}

	/**
	 * @return the mappingColumnWidth
	 */
	public float getMappingColumnWidth() {
		return mappingColumnWidth;
	}
}
