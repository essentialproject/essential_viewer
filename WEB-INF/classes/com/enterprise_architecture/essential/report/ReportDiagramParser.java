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
 * 15.01.2007	JWC	1st coding.
 * 16.04.2007	JWC	Added an optional parent node to the node structure.
 */
package com.enterprise_architecture.essential.report;

import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.util.ArrayList;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.*;
import org.xml.sax.helpers.*;


/**
 * Parser for diagram reports. <br>
 * Parses XML documents conforming to the reportDiagram.xsd schema into
 * a set of nodes and a set of arcs connecting those nodes. <br>
 * Nodes can be of various types, as can Arcs.<br>
 * Inner classes are defined for the Node and Arc types. In version 1.1, an optional
 * parent node can be defined for a Node type, to indicate containment.
 * @author Jonathan W. Carter <jonathan.carter@e-asolutions.com>
 * @version 1.1
 * @since version 1.0
 * 
 */
public class ReportDiagramParser extends DefaultHandler
{
	private ArrayList itsNodes;
	private ArrayList itsArcs;
	private ReportDiagramNodeBean itsCurrentNode;
	private ReportDiagramArcBean itsCurrentArc;
	private String itsCurrentElement;
	private String itsCurrentCharacters;
	
	/**
	 * Initialise the attributes of the parser.
	 */
	public ReportDiagramParser()
	{
		itsNodes = new ArrayList();
		itsArcs = new ArrayList();
		itsCurrentNode = null;
		itsCurrentArc = null;
		itsCurrentElement = new String();
		itsCurrentCharacters = new String();
	}
	
	/**
	 * Handle the startDocument event.
	 */
	public void startDocument( ) throws SAXException 
	{
	   //   System.out.println( "SAX Event: START DOCUMENT" );
	}

	/**
	 * Handle the endDocument event.
	 */
	public void endDocument( ) throws SAXException 
	{
	    //  System.out.println( "SAX Event: END DOCUMENT" );
	}

	/** 
	 * Handle the startElement tag.<br>
	 * On a node tag, create a new ReportDiagramNodeBean;<br>
	 * On an arc tag, create a new ReportDiagramArcBean;
	 */
	public void startElement(String namespaceURI,
	              			String localName,
	              			String qName,
	              			Attributes attr ) throws SAXException 
   {
		// Reset characters
		itsCurrentCharacters = new String();

		if(localName.equals("node")) 
		{
			// create a new Node object
			itsCurrentNode = new ReportDiagramNodeBean();
			itsNodes.add(itsCurrentNode);
			itsCurrentElement = "NODE";
		}
		if(localName.equals("nodeName")) 
		{
			//set the current element
			itsCurrentElement = "NODENAME";
		}
		if(localName.equals("nodeLabel")) 
		{
			//set the current element
			itsCurrentElement = "NODELABEL";
		}
		if(localName.equals("nodeType")) 
		{
			//set the current element
			itsCurrentElement = "NODETYPE";
		}
		if(localName.equals("parentNode"))
		{
			// set the current element
			itsCurrentElement = "PARENTNODE";
		}
		if(localName.equals("arc")) 
		{
			//set the current element
			itsCurrentElement = "ARC";
			itsCurrentArc = new ReportDiagramArcBean();
			itsArcs.add(itsCurrentArc);
		}
		if(localName.equals("arcLabel")) 
		{
			//set the current element
			itsCurrentElement = "ARCLABEL";
		}
		if(localName.equals("fromNode")) 
		{
			//set the current element
			itsCurrentElement = "FROMNODE";
		}
		if(localName.equals("toNode")) 
		{
			//set the current element
			itsCurrentElement = "TONODE";
		}
		if(localName.equals("arcType")) 
		{
			//set the current element
			itsCurrentElement = "ARCTYPE";
		}
   	}

	/**
	 * Handle the endElement event and store the element value. 
	 */
	public void endElement(String namespaceURI,
           				   String localName,
           				   String qName ) throws SAXException 
    {
	   
		// This is where you set the element value

		// Capture the current Node details
		if(itsCurrentElement.equals("NODENAME")) 
		{
			itsCurrentNode.setItsName(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("NODELABEL")) 
		{
			itsCurrentNode.setItsLabel(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("NODETYPE")) 
		{
			itsCurrentNode.setItsType(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("PARENTNODE"))
		{
			itsCurrentNode.setItsParentNode(itsCurrentCharacters);
		}
		
		// Capture arc details
		if(itsCurrentElement.equals("ARCLABEL")) 
		{
			itsCurrentArc.setItsArcLabel(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("FROMNODE")) 
		{
			itsCurrentArc.setItsFromNode(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("TONODE")) 
		{
			itsCurrentArc.setItsToNode(itsCurrentCharacters);
		}
		if(itsCurrentElement.equals("ARCTYPE")) 
		{
			itsCurrentArc.setItsArcType(itsCurrentCharacters);
		}
		
		// Reset the element string.
		itsCurrentElement = new String(); 
		itsCurrentCharacters = new String();
		//   System.out.println( "SAX Event: END ELEMENT[ " + localName + " ]" );
    }

	/**
    * Process the characters that have been read and store them
    * in the working memory of characters.
    */
	public void characters( char[] ch, int start, int length )
							throws SAXException 
	{
		String aCharacterStream;

		aCharacterStream = new String(ch, start, length);
		aCharacterStream = aCharacterStream.trim();
		itsCurrentCharacters = itsCurrentCharacters.concat(aCharacterStream);
	}
   
	
	/**
	 * @return the itsArcs
	 */
	public ArrayList getItsArcs() 
	{
		return itsArcs;
	}

	/**
	 * @param theArcs the itsArcs to set
	 */
	public void setItsArcs(ArrayList theArcs) 
	{
		itsArcs = theArcs;
	}

	/**
	 * @return the itsNodes
	 */
	public ArrayList getItsNodes() 
	{
		return itsNodes;
	}

	/**
	 * @param theNodes the itsNodes to set
	 */
	public void setItsNodes(ArrayList theNodes) 
	{
		itsNodes = theNodes;
	}

}

