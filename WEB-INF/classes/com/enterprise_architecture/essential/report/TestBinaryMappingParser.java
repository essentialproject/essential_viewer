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
 * 04.05.2007	JP	1st coding
 */
package com.enterprise_architecture.essential.report;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Test the BinaryMappingParser
 * @author Jason Powell
 *
 */
public class TestBinaryMappingParser {

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
	    	  BinaryMappingParser aParser = new BinaryMappingParser();
	    	  
	    	  xr.setContentHandler(aParser);

	    	  // Parse the file...
	    	  xr.parse( new InputSource(
	    			  new FileReader( "C:\\development_projects\\eclipse_wtp_workspace\\essential_architecture\\WebContent\\buscap_to_actor_mapping_result.xml" )) );

	    	  //Print out values
	    	  System.out.println(aParser.getHeading());
	    	  Iterator xListIter = aParser.getXLabels().iterator();
	    	  String anXLabel;
	    	  System.out.println("PRINTING COLUMN LABELS");
	    	  while(xListIter.hasNext()) {
	    		  anXLabel = (String) xListIter.next(); 
	    		  System.out.println(anXLabel);
	    	  }
	   
	    	  
	    	  System.out.println("PRINTING MAPPING TABLE");
	    	  HashMap<String, HashMap<String, BinaryMappingCellBean>> mappingTable = aParser.getMappingTable();
	    	  Set yLabels = mappingTable.keySet();
	    	  Iterator yListIter = yLabels.iterator();
	    	  String aYLabel;
	    	  Set xLabels;
	    	  HashMap<String, BinaryMappingCellBean> tableRow;
	    	  BinaryMappingCellBean cellBean;
	    	  while(yListIter.hasNext()) {
	    		  aYLabel = (String) yListIter.next();
	    		  System.out.println("PRINTING ROW:" + aYLabel);
	    		  tableRow = mappingTable.get(aYLabel);
	    		  xLabels = tableRow.keySet();
	    		  xListIter = xLabels.iterator();
	    		  while(xListIter.hasNext()) {
	    			  anXLabel = (String) xListIter.next();
	    			  cellBean = tableRow.get(anXLabel);
	    			  System.out.println("PRINTING CELL FOR COLUMN:" + anXLabel);
	    			  System.out.println("Colour: " + cellBean.getColour());
	    			  System.out.println("Subtitle: " + cellBean.getSubTitle());
	    			  System.out.println("Description: " + cellBean.getSubDescription());
	    			  System.out.println("Link: " + cellBean.getLink());
	    		  }
	    		  System.out.println();
	    		
	    	  }
	    	  
	    	  System.out.println("No of rows: " + aParser.getMappingTable().size());
	    	  
	      }
	      catch (Exception ex)
	      {
	    	  System.out.println("Error: " + ex.toString());
	    	  ex.printStackTrace();
	      }
	    	  
	}

}
