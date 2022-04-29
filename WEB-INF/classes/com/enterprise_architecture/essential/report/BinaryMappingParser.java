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
 * 04.05.2007	JP	1st coding.
 */
package com.enterprise_architecture.essential.report;

import java.util.ArrayList;
import java.util.HashMap;

import org.xml.sax.*;
import org.xml.sax.helpers.*;


/**
 * Parser for binary mapping table data. <br>
 * Parses XML documents conforming to the binaryMapping.xsd schema into
 * a hashmap of hashmaps that contain cell data<br>
 * An inner class is defined for the mapping cells (BinaryMappingCellBean).
 * @author Jason Powell <jason.powell@e-asolutions.com>
 * @version 1.0
 * @since version 1.0
 * 
 */
public class BinaryMappingParser extends DefaultHandler
{
	private String heading;
	private String subHeading;
	private String introText;
	private String greenLabel;
	private String amberLabel;
	private String redLabel;
	
	private ArrayList<String> xLabels;
	private HashMap<String, HashMap<String, BinaryMappingCellBean>> mappingTable;
	private HashMap<String, BinaryMappingCellBean> currentRow;
	private BinaryMappingCellBean currentCell;
	
	private String itsCurrentCharacters;
	
	/**
	 * Initialise the attributes of the parser.
	 */
	public BinaryMappingParser()
	{
		xLabels = new ArrayList<String>();
		mappingTable = new HashMap<String, HashMap<String, BinaryMappingCellBean>>();
		currentRow = new HashMap<String, BinaryMappingCellBean>();
		currentCell = null;
		
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
		
		//create a new cell for the mapping table
		if(localName.equals("Mapping"))
		{
			currentCell = new BinaryMappingCellBean();
		}
   	}

	/**
	 * Handle the endElement event and store the element value. 
	 */
	public void endElement(String namespaceURI,
           				   String localName,
           				   String qName ) throws SAXException 
    {
	   
		// This is where you assign element values to local attributes of this class

		// Capture general page details
		if(localName.equals("Heading")) 
		{
			this.heading = itsCurrentCharacters;
		}
		if(localName.equals("Sub_Heading")) 
		{
			this.subHeading = itsCurrentCharacters;
		}
		if(localName.equals("Intro_Text")) 
		{
			this.introText = itsCurrentCharacters;
		}
		if(localName.equals("Green_Label")) 
		{
			this.greenLabel = itsCurrentCharacters;
		}
		if(localName.equals("Amber_Label")) 
		{
			this.amberLabel = itsCurrentCharacters;
		}
		if(localName.equals("Red_Label")) 
		{
			this.redLabel = itsCurrentCharacters;
		}
		if(localName.equals("X_Key"))
		{
			xLabels.add(itsCurrentCharacters);
		}
		
		// Capture the mapping table details
		if(localName.equals("Row_Name")) 
		{
			currentRow = new HashMap<String, BinaryMappingCellBean>();
			mappingTable.put(itsCurrentCharacters, currentRow);
		}
		//add the current cell to the current row hashmap keyed to the X_Value element
		if((localName.equals("X_Name") && currentCell!=null)) 
		{
			currentRow.put(itsCurrentCharacters, currentCell);
		}
		if((localName.equals("Colour") && currentCell!=null)) 
		{
			if(itsCurrentCharacters.equals("Green")) {
				currentCell.setColour(BinaryMappingCellBean.GREEN_COLOUR);
			} else
			if(itsCurrentCharacters.equals("Amber")) {
				currentCell.setColour(BinaryMappingCellBean.AMBER_COLOUR);
			} else
			if(itsCurrentCharacters.equals("Red")) {
				currentCell.setColour(BinaryMappingCellBean.RED_COLOUR);
			}
		}
		if(localName.equals("Sub_Title")) 
		{
			currentCell.setSubTitle(this.itsCurrentCharacters);
		}
		if(localName.equals("Sub_Desc")) 
		{
			currentCell.setSubDescription(this.itsCurrentCharacters);
		}
		
		if(localName.equals("Link")) 
		{
			currentCell.setLink(this.itsCurrentCharacters);
		}
		
		// Reset the characters string.
		itsCurrentCharacters = new String();
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
	public HashMap<String, HashMap<String, BinaryMappingCellBean>> getMappingTable() {
		return mappingTable;
	}

	/**
	 * @param mappingTable the mappingTable to set
	 */
	public void setMappingTable(HashMap<String, HashMap<String, BinaryMappingCellBean>> mappingTable) {
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
	 * @return the xLabels
	 */
	public ArrayList<String> getXLabels() {
		return xLabels;
	}

	/**
	 * @param labels the xLabels to set
	 */
	public void setXLabels(ArrayList<String> labels) {
		xLabels = labels;
	}
}

