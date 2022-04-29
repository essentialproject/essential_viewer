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
 * 15.01.2007	JWC	1st coding
 */
package com.enterprise_architecture.essential.report;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.Iterator;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Test the ReportDiagramParser
 * @author Jonathan W. Carter
 *
 */
public class TestReportDiagramParser {

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// TODO Auto-generated method stub
		// Read in the sample XML
	      try 
	      {
	    	  // Create SAX 2 parser...
	    	  //XMLReader xr = XMLReaderFactory.createXMLReader();
	    	  // JWC 9.3.2006 Try this approach to remove need for System property
	    	  XMLReader xr = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");

	    	  // Set the ContentHandler...
	    	  ReportDiagramParser aParser = new ReportDiagramParser();
	    	  
	    	  xr.setContentHandler(aParser);

	    	  // Parse the file...
	    	  xr.parse( new InputSource(
	    			  new FileReader( "testReportDiagramProperFormat.xml" )) );

	    	  // Print out the nodes.
	    	  printNodes(aParser.getItsNodes());
	    	  
	    	  // Print out the arcs
	    	  printArcs(aParser.getItsArcs());
	    	  
	    	  // Test the NodesArcsService now.
	    	  System.out.println("Testing the NodesArcsService:");
	    	  NodesArcsService aService = new NodesArcsService("eas_integration_v1.5_Instance_69",
	    			  										   "param1",
	    			  										   "docroot/reportXML.xml",
	    			  										   "docroot/ProcessFlowXML.xsl");
	    	  // Print the results
	    	  printNodes(aService.getItsNodes());
	    	  printArcs(aService.getItsArcs());
	    	  
	    	  int anIndex = aService.getNodeIndex("eas_integration_v1.5_Instance_72");
	    	  System.out.println("Index of eas_integration_v1.5_Instance_72 is " + anIndex);
	    	  aService.layoutNodesForProcess();
	    	  printNodes(aService.getItsNodes());
	    	  
	      }
	      catch (Exception ex)
	      {
	    	  System.out.println("Error: " + ex.toString());
	    	  ex.printStackTrace();
	      }
	    	  
	}
	
	private static void printNodes(ArrayList theNodes)
	{
		Iterator aListIt = theNodes.iterator();
		while(aListIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aListIt.next();
			if(aNode != null)
			{
				System.out.println("\nNode:");
				System.out.println("Name: " + aNode.getItsName());
				System.out.println("Label: " + aNode.getItsLabel());
				System.out.println("Type: " + aNode.getItsType());
				System.out.println("Parent: " + aNode.getItsParentNode());
			}
		}
	}
	
	private static void printArcs(ArrayList theArcs)
	{
		Iterator anArcListIt = theArcs.iterator();
		while(anArcListIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcListIt.next();
			if(anArc != null)
			{
				System.out.println("\nArc:");
				System.out.println("From: " + anArc.getItsFromNode());
				System.out.println("To: " + anArc.getItsToNode());
				System.out.println("Label: " + anArc.getItsArcLabel());
				System.out.println("Type: " + anArc.getItsArcType());
			}
		}
  	  
	}

}
