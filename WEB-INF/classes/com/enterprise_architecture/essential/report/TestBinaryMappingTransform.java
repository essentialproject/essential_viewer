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
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Test the BinaryMappingParser
 * @author Jason Powell
 *
 */
public class TestBinaryMappingTransform {

	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		// TODO Auto-generated method stub
		// Read in the sample XML
//		 Create the SourceStream to the XSLT and get a transformer.
		TransformerFactory transFormFactory = TransformerFactory.newInstance();

		try
		{
			Transformer transformer = transFormFactory.newTransformer(new StreamSource("C:\\development_projects\\eclipse_wtp_workspace\\essential_architecture\\WebContent\\buscap_to_actor_mapping.xsl"));
			transformer.setParameter("param1", "eas_repository_v1.0_Instance_21");
			transformer.setParameter("param2", "eas_repository_v1.0_Instance_20000");
	
			// Create a writer for the results
			StringWriter aResultXML = new StringWriter();
			
			// parse the document, looking for theInstance.
			transformer.transform(new StreamSource("C:\\development_projects\\eclipse_wtp_workspace\\essential_architecture\\WebContent\\reportXML.xml"), new StreamResult(aResultXML));
			
			System.out.println("TRANSFORMATION COMPLETE");
			
//			 Open a file to save to.
			try
			{
				FileWriter aFile = new FileWriter("C:\\development_projects\\eclipse_wtp_workspace\\essential_architecture\\WebContent\\buscap_to_actor_mapping_result.xml");
							
				// Write the XML document
				aFile.write(aResultXML.toString());
				
				// Close the file
				aFile.close();
			}
			catch (IOException ioEx)
			{
				System.err.println("Exception opening/writing EA repository source file");
				System.err.println(ioEx.getMessage());
				ioEx.printStackTrace(new PrintWriter(System.err));
			}
			}
	      catch (Exception ex)
	      {
	    	  System.out.println("Error: " + ex.toString());
	    	  ex.printStackTrace();
	      }
	    	  
	}

}
