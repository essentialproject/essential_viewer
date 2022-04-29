/**
 * Copyright (c)2007-2019 Enterprise Architecture Solutions ltd.
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
 * 17.01.2007	JWC	1st coding.
 * 16.04.2007	JWC	Added helpers for managing nodes contained within nodes.
 * 17.04.2007	JWC Added another form of contructor that allows variable numbers
 * 					of parameters to be sent to the XSL.
 * 21.04.2007	JWC	Added a layout algorithm to arrange nodes in rows and
 * 					columns.
 * 28.06.2019	JWC Added use of log4J
 */
package com.enterprise_architecture.essential.report;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

/**
 * Manage the creation of the report data for creating a Nodes and Arcs graphical
 * report.<br>
 * Access to the list of Nodes and the list of Arcs that make up the report is
 * provided by this service. In addition, a set of helper methods for navigating
 * the nodes and arcs is provided.
 * <br>Usage:
 * <br>Specify the instance in the repository for which the report is required and
 * an XSLT that constructs an XML report for this instance, conforming to 
 * <tt>reportDiagram.xsd</tt>. The XML report is parsed, and interfaces are provided
 * to access the Java objects for the Nodes and Arcs in the diagram - in readiness
 * for rendering.
 * <br> Example:<br>
 * <i>aRepositoryInstance is e.g. an instance of a Business Process; anInstanceParamName
 * is the name of the parameter used in the XSLT to refer to aRepositoryInstance;
 * aRepository is the XML representation of the repository; and anXSLT is
 * the XLST that gets the required data out of the repository for this process
 * </i>
 * <tt>
 * 
 * NodesArcsService aNodeArcService = new NodesArcsService(aRepositoryInstance,
 * 														   anInstanceParamName,
 * 														   aRepository, 
 * 														   anXLST);
 * ArrayList aNodeList = aNodeArcService.getNodes();
 * ArrayList anArcList = aNodeArcService.getArcs();
 * ...
 * </tt>
 * Alternatively, a Properties object can be sent to the constructor to pass a 
 * variable number of parameters to the XSL.
 * @author Jonathan W. Carter <jonathan.carter@e-asoltuions.com>
 * @since version 1.0
 * @version 1.1
 *
 */
public class NodesArcsService 
{
	/**
	 * Logger for the current class
	 */
	private static final Logger itsLog = LoggerFactory.getLogger(NodesArcsService.class);	
	
	private ArrayList itsNodes = null;
	private ArrayList itsArcs = null;
	private ArrayList itsUsedNodes = null;
	private String itsInstanceXSLTVarName = "param1"; // default name.
	private ArcIteration itsCurrentArc = null;
	
	
	/**
	 * Default constructor. The list of nodes and arcs are both initialised to 
	 * empty ArrayLists.
	 *
	 */
	public NodesArcsService()
	{
		itsNodes = new ArrayList();
		itsArcs = new ArrayList();
		itsUsedNodes = new ArrayList();
		itsCurrentArc = new ArcIteration();
	}
	
	/**
	 * Convenience constructor that takes the name of the required repository
	 * instance that is to be reported on and the name of the XSLT file to use
	 * in order to gather the required data for the report.
	 * @param theInstance the name of the required repository instance, e.g.  
	 * a Business_Process instance.
	 * @param theInstanceParamName the name of the parameter used by the XSLT to
	 * find the specified instance.
	 * @param theRepository the name of the file that holds the repository.
	 * @param theXSLT the name of the XSLT file to use to select the information
	 * for the report. The REAL filename must be provided - get this from the
	 * ServletContext if invoking this from a Servlet or JSP.
	 */
	public NodesArcsService(String theInstance, 
							String theInstanceParamName, 
							String theRepository, 
							String theXSLT)
	{
		itsNodes = new ArrayList();
		itsArcs = new ArrayList();
		itsUsedNodes = new ArrayList();
		itsCurrentArc = new ArcIteration();
		
		// Call the method to initialise the service.
		Properties anXSLParamList = new Properties();
		anXSLParamList.setProperty(theInstanceParamName, theInstance);

		findReportData(anXSLParamList, theRepository, theXSLT);
	}
	
	/**
	 * Convenience constructor that takes the name of the required repository
	 * instance that is to be reported on and the name of the XSLT file to use
	 * in order to gather the required data for the report.
	 * @param theXSLParameters the list of parameters that are to be sent to the XSLT. 
	 * The Properties key is the XSL parameter name and the Properties value is the 
	 * XSL parameter value.
	 * @param theRepository the name of the file that holds the repository.
	 * @param theXSLT the name of the XSLT file to use to select the information
	 * for the report. The REAL filename must be provided - get this from the
	 * ServletContext if invoking this from a Servlet or JSP.
	 */
	public NodesArcsService(Properties theXSLParameters,
							String theRepository,
							String theXSLT)
	{
		itsNodes = new ArrayList();
		itsArcs = new ArrayList();
		itsUsedNodes = new ArrayList();
		itsCurrentArc = new ArcIteration();
		
		// Call the method to initialise the service.
		findReportData(theXSLParameters, theRepository, theXSLT);
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
	public void findReportData(Properties theXSLParams, InputStream theRepository, InputStream theXSLT)
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
			
			// Un-comment the following for trace and debugging.
			//System.out.println("NodesArcsService resulting transformed XML, pre-parse: ");
			//System.out.println(aResultXML);
			
			// Read the XML from the returned string.
	    	XMLReader xr = XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");

	    	// Set the ContentHandler...
	    	ReportDiagramParser aParser = new ReportDiagramParser();
	    	  
	    	xr.setContentHandler(aParser);

	    	// Parse the XML
	    	xr.parse(new InputSource(new StringReader(aResultXML.toString())));	
	    	
	    	// Now get the Nodes and Arcs
	    	itsNodes = aParser.getItsNodes();
	    	itsArcs = aParser.getItsArcs();
		}
		catch(TransformerException transEx)
		{
			itsLog.error("Parsing error, finding {} exception: {}", theXSLParams, transEx);			
		}
		catch(TransformerFactoryConfigurationError transConfigErr)
		{
			itsLog.error("Parsing error, finding {} exception: {}", theXSLParams, transConfigErr);			
		}
		catch(SAXException saxEx)
		{
			itsLog.error("Parsing error, finding {} exception: {}", theXSLParams, saxEx);					
		}
		catch(IOException ioEx)
		{
			itsLog.error("Parsing error, finding {} exception: {}", theXSLParams, ioEx);			
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
	public void findReportData(Properties theXSLParams, String theRepository, String theXSLTFilename)
	{
		try
		{
			// Build a stream to the repository and the XSLTFile
			FileInputStream aRepos = new FileInputStream(theRepository);
			FileInputStream anXSLT = new FileInputStream(theXSLTFilename);
			
			// call the InputStream-based method.
			findReportData(theXSLParams, aRepos, anXSLT);
		}
		catch(Exception ex)
		{
			itsLog.error("Error reading files. Params: {} | Repository: {} | XSLT: {} | Exception: {}", theXSLParams, theRepository, theXSLTFilename, ex);
		}
	}

	/**
	 * @return the set of Nodes
	 */
	public ArrayList getItsNodes() 
	{
		return itsNodes;
	}

	/**
	 * @return the set of Arcs
	 */
	public ArrayList getItsArcs()
	{
		return itsArcs;
	}
	
	/**
	* Find the index of the specified node step in the 
	* node list. This method is often used to help draw arcs between FROM and TO
	* nodes.
	* @param theNodeName the name of the node to find
	* @return the index of the first matching node in the current nodelist.
	*/
	public int getNodeIndex(String theNodeName)
	{
		// Create a shell of a Node to match - only the name is used in matching.
		ReportDiagramNodeBean aNode = new ReportDiagramNodeBean();
		aNode.setItsName(theNodeName);
		return itsNodes.indexOf(aNode);
	}
	
	/**
	* Find the index of the specified node step in the 
	* node list. This method is often used to help draw arcs between FROM and TO
	* nodes.
	* @param theNode the node that is being searched for in the node list.
	* @return the index of the first matching node in the current node list.
	*/
	public int getNodeIndex(ReportDiagramNodeBean theNode)
	{
		return itsNodes.indexOf(theNode);
	}

	/**
	 * Return a reference to the node that has the specified name.
	 * @param theNodeName the instance name of the node.
	 * @return a reference to the Node bean.
	 *
	 */
	public ReportDiagramNodeBean getNode(String theNodeName)
	{
		int anIndex = getNodeIndex(theNodeName);
		ReportDiagramNodeBean aNode = new ReportDiagramNodeBean();
		if(anIndex != -1)
		{
			aNode = (ReportDiagramNodeBean)itsNodes.get(anIndex);
		}
		return aNode;
	}
	
	/**
	 * Get a reference to the specified node
	 * @param theNodeName the name (usually a unique identifier) of the node
	 * for which a reference is requested.
	 * @return a reference to the node that has the specified name.
	 */
	public ReportDiagramNodeBean getNodeByName(String theNodeName)
	{
		ReportDiagramNodeBean aReturnNode = new ReportDiagramNodeBean();
		Iterator aNodeIt = itsNodes.iterator();
		while(aNodeIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeIt.next();
			if(aNode.getItsName().equals(theNodeName))
			{
				return aNode;
			}
		}
		
		return aReturnNode;
	}
	
	/**
	* 
	* Has the current node been used before as a starting 
	* (or FROM) node for an arc? (i.e. does it appear in the
	* set of used nodes maintained here.) If so, return the offset 
	* for the yPosition that should be used. This offset 
	* is calculated as n*theYOffset where n is the number
	* of times that the current node has been a FROM node
	* @param theCurrentNode the current node that is being 
	* considered
	* @param theYOffset the standard Y-Offset that is being used by the diagram
	*/
	public int isFromUsedAlready(ReportDiagramNodeBean theCurrentNode, int theYOffset)
	{
		int anOffset = 0;
		
		if(theCurrentNode != null)
		{
			// Go through the entire usedSteps list and update the offset for
			// each occurrence
			Iterator aListIt = itsUsedNodes.iterator();
			while(aListIt.hasNext())
			{
				// Get the next used node in the list
				ReportDiagramNodeBean aUsedNode = (ReportDiagramNodeBean)aListIt.next();
				
				// If this used node matches, theCurrentNode, update the offset for this
				// appearance of the node in a diagram.
				if(aUsedNode.equals(theCurrentNode))
				{
					anOffset = anOffset + theYOffset;
				}
			}
		}
		return anOffset;
	}
	
	/**
	 * Record the fact that the specied node has been used in a report diagram.
	 * @param theUsedNode the node that has been used.
	 */
	public void usedNode(ReportDiagramNodeBean theUsedNode)
	{
		itsUsedNodes.add(theUsedNode);
	}

	/**
	 * The name of the parameter used by the XSLT to refer to the instance that
	 * is being searched for/reported on 
	 * @return the itsInstanceXSLTVarName
	 */
	public String getItsInstanceXSLTVarName() 
	{
		return itsInstanceXSLTVarName;
	}

	/**
	 * @param theInstanceXSLTVarName the name of the parameter expected
	 * in the XSLT to use as the instance that is being reported on.
	 */
	public void setItsInstanceXSLTVarName(String theInstanceXSLTVarName) 
	{
		itsInstanceXSLTVarName = theInstanceXSLTVarName;
	}
	
	/**
	 * Helper method for rendering JSPs. Calculates the indexes of the 
	 * FROM and TO nodes of the arc and any required y-Offset (for bending
	 * arcs). Also records that the FROM node of theArc has been used. The
	 * results of this method are saved in an attribute, 'itsCurrentArc' which
	 * is of type ArcIteration.
	 * @param theArc the current arc in the iteration.
	 * @param theYpos the default standard y-coordinate for placing arcs.
	 * @see ArcIteration
	 */
	public void iterateArc(ReportDiagramArcBean theArc, int theYpos)
	{
		int aFromIndex = getNodeIndex(theArc.getItsFromNode());
		int aToIndex = getNodeIndex(theArc.getItsToNode());
		ReportDiagramNodeBean aFromNode = getNode(theArc.getItsFromNode());
		int anOffset = isFromUsedAlready(aFromNode, theYpos);
		usedNode(aFromNode);
		
		itsCurrentArc.setItsCurrentArcName(theArc.getItsFromNode());
		itsCurrentArc.setItsFromIndex(aFromIndex);
		itsCurrentArc.setItsToIndex(aToIndex);
		itsCurrentArc.setItsOffset(anOffset);
		
	}

	/** Accessor to the bean
	 * 
	 * @return a reference to the details required to render the current arc.
	 */
	public ArcIteration getItsCurrentArc() {
		return itsCurrentArc;
	}
	
	/** 
	 * Re-arrange the Node list in the correct order for rendering Process Flows.
	 *
	 */
	public void layoutNodesForProcess()
	{
		// Find the first node
		ReportDiagramNodeBean aFirstNode = findProcessFirstNode();
		
		// Build the list using the arcs to find the next node.
		ArrayList aSortedNodeList = new ArrayList();
		
		// Add the first node
		int anInsertPoint = 0;
		aSortedNodeList.add(anInsertPoint, aFirstNode);
		
		String aCurrentFromNode = aFirstNode.getItsName();
		anInsertPoint++;
		
		// Iterate across the Node list, finding slot for each node.
		aSortedNodeList = traverseArcs(aCurrentFromNode, anInsertPoint, aSortedNodeList);
		
		// Iterate over the current Nodelist to pick up any lost nodes.
		if(aSortedNodeList.size() != itsNodes.size())
		{
			Iterator aNodeIt = itsNodes.iterator();
			while(aNodeIt.hasNext())
			{
				ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeIt.next();
				if(!aSortedNodeList.contains(aNode))
				{
					// Add it at the end.
					aSortedNodeList.add(aNode);
				}
			}
		}
		
		// Finally, set the nodelist to the sorted list
		itsNodes = aSortedNodeList;
	}
	
	/**
	 * Find the list of nodes for which the specified node is the parent, according
	 * to the XML document supplied to this service. This can be used to represent
	 * containment of nodes - hence the method name. The returned list contains
	 * all the nodes that have specified theNode as their parent.
	 * @param theNode the node for which all contained nodes should be found.
	 * @return the list of all nodes that have specified theNode as their parent.
	 */
	public ArrayList getContainedNodes(ReportDiagramNodeBean theNode)
	{
		ArrayList aContainedNodeList = new ArrayList();
		
		// Iterate over the list of nodes. 
		Iterator aNodeIt = itsNodes.iterator();
		while(aNodeIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeIt.next();
			
			// Don't try to access a null node - shouldn't ever fail...
			if(aNode != null)
			{
				// If the Parent of aNode = the name of theNode
				if(aNode.getItsParentNode().equals(theNode.getItsName()))
				{
					// Add it to the list of contained nodes.
					aContainedNodeList.add(aNode);
				}
			}
		}
		
		return aContainedNodeList;
	}
	
	/**
	 * Return a list of nodes of the specified type.
	 * @param theNodeType the type of node that is to be returned
	 * @return a subset of nodes each of which are of the specified type
	 */
	public ArrayList getNodesOfType(String theNodeType)
	{
		ArrayList aNodesOfType = new ArrayList();
		
		// Iterate over the list of nodes. 
		Iterator aNodeIt = itsNodes.iterator();
		while(aNodeIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeIt.next();
			
			// Don't try to access a null node - shouldn't ever fail...
			if(aNode != null)
			{
				// If the Parent of aNode = the name of theNode
				if(aNode.getItsType().equals(theNodeType))
				{
					// Add it to the list of contained nodes.
					aNodesOfType.add(aNode);
				}
			}
		}
		
		return aNodesOfType;
	}

	/**
	 * Layout the specified list of nodes into rows and columns in a horizontal tree style.
	 * When this method has completed, each node in the model will have its
	 * row and column attributes set to indicate where they should be drawn.
	 * @param theNodeList the list of nodes to layout into a horizontal tree. 
	 * Each node in the list is arranged in the specified column and nodes that
	 * have arcs to that node are then laid out in the next column.
	 * @param theCurrentColumn the column in which theNodeList will be laid out
	 * in.
	 *
	 */
	public void layoutHorizontalTree(ArrayList theNodeList, int theCurrentColumn)
	{
		// Breadth 1st find the row and column for each node.
		int aRowID = 0;
		Iterator aNodeListIt = theNodeList.iterator();
		while(aNodeListIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeListIt.next();
			
			// If the node has already been used, it's appeared already, so 
			// discard it
			if(!itsUsedNodes.contains(aNode))
			{
				aNode.setItsColumn(theCurrentColumn);
				aNode.setItsRow(aRowID);
				usedNode(aNode);
				aRowID++;
			}
		}
		
		// All the nodes have been set. Now for each node in theNodeList,
		// find the nodes that have arcs to that node and set the rows and 
		// columns for that one.
		aNodeListIt = theNodeList.iterator();
		while(aNodeListIt.hasNext())
		{
			// Find the set of nodes that have arcs to this node.
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeListIt.next();
			ArrayList aToNodeList = getNodesToNode(aNode);
			
			// Recurse through this set of nodes at the next column over.
			if(!(aToNodeList.isEmpty()))
			{
				layoutHorizontalTree(aToNodeList, (theCurrentColumn + 1));
			}
		}
	}
	
	/**
	 * Get the set of nodes that have arcs TO the specified Nodes.
	 * @param theToNode the Node to that appears in the TO node of
	 * the arcs
	 * @return the list of Nodes that appear as FROM nodes in the set of Arcs
	 * that have theNode as the TO node.
	 */
	public ArrayList getNodesToNode(ReportDiagramNodeBean theToNode)
	{
		ArrayList aToNodeList = new ArrayList();
		Iterator anArcListIt = itsArcs.iterator();
		while(anArcListIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcListIt.next();
			if(anArc.getItsToNode().equals(theToNode.getItsName()))
			{
				ReportDiagramNodeBean aFromNode = getNode(anArc.getItsFromNode());
				aToNodeList.add(aFromNode);
			}					
		}
		return aToNodeList;
	}
	
	/**
	 * Get the set of nodes that have arcs FROM the specified Nodes.
	 * @param theFromNode the Node to that appears in the FROM node of
	 * the arcs
	 * @return the list of Nodes that appear as TO nodes in the set of Arcs
	 * that have theNode as the FROM node.
	 */
	public ArrayList getNodesFromNode(ReportDiagramNodeBean theFromNode)
	{
		ArrayList aFromNodeList = new ArrayList();
		Iterator anArcListIt = itsArcs.iterator();
		while(anArcListIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcListIt.next();
			if(anArc.getItsFromNode().equals(theFromNode.getItsName()))
			{
				ReportDiagramNodeBean aToNode = getNode(anArc.getItsToNode());
				aFromNodeList.add(aToNode);
			}					
		}
		return aFromNodeList;
	}
	
	/**
	 * Produce a string representation of the contents of the Nodes and Arcs
	 * model.
	 * @return a formatted string listing the nodes and arcs.
	 */
	public String displayModel()
	{
		StringBuffer aTempString = new StringBuffer();
		
		// Write all the nodes
		Iterator aNodeIt = itsNodes.iterator();
		while(aNodeIt.hasNext())
		{
			ReportDiagramNodeBean aNode = (ReportDiagramNodeBean)aNodeIt.next();
			aTempString.append("\nNode:\n");
			aTempString.append("Name: " + aNode.getItsName());
			aTempString.append("\nLabel: " + aNode.getItsLabel());
			aTempString.append("\nType: " + aNode.getItsType());
			aTempString.append("\nParent: " + aNode.getItsParentNode());
			aTempString.append("\nX=" + aNode.getItsXLoc());
			aTempString.append("\nY=" + aNode.getItsYLoc());
			aTempString.append("\nWidth=" + aNode.getItsWidth());
			aTempString.append("\nHeight=" + aNode.getItsHeight());
		}
		Iterator anArcIt = itsArcs.iterator();
		while(anArcIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcIt.next();
			aTempString.append("\nArc:");
			aTempString.append("\nFrom: " + anArc.getItsFromNode());
			aTempString.append("\nTo: " + anArc.getItsToNode());
			aTempString.append("\nLabel: " + anArc.getItsArcLabel());
			aTempString.append("\nType: " + anArc.getItsArcType());
		}
		return aTempString.toString();
	}
	
	/**
	 * Traverse the set of arcs from theCurrentNode by following the TO nodes of
	 * each arc that contains theCurrentNode in its FROM attribute.
	 * @param theCurrentFromNode the starting node
	 * @param theInsertPoint where in the sorted list the next node should be inserted
	 * @param theSortedList the current progress of nodes sorted in arc-traverse order.
	 * @return a complete set of the nodes sorted in arc-traverse order.
	 */
	private ArrayList traverseArcs(String theCurrentFromNode, int theInsertPoint, ArrayList theSortedList)
	{
		int anInsertPoint = theInsertPoint;
		ArrayList aSortedNodeList = theSortedList;
		
		// Find the arcs with the current node as the FROM 
		ArrayList anArcList = findArcFromNode(theCurrentFromNode);
		Iterator anArcListIt = anArcList.iterator();
		while(anArcListIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcListIt.next();
			// For each of those, find the To node and store it.
			String aToNode = anArc.getItsToNode();
		
			if(aToNode != "")
			{
				// Insert this node
				ReportDiagramNodeBean aNextNode = getNode(aToNode);
				
				if(!aSortedNodeList.contains(aNextNode))
				{
					aSortedNodeList.add(anInsertPoint, aNextNode);
					anInsertPoint++;
					
					// Recurse over the next node.
					traverseArcs(aNextNode.getItsName(), anInsertPoint, aSortedNodeList);
				}
			}
		}
		return aSortedNodeList;
	}
	
	/**
	 * Iterate through all the arcs, and return every one that contains
	 * theCurrentNode as its FROM node
	 * @param theCurrentNode the current node in question
	 * @return a list of the arcs that contain theCurrentNode in it's FROM attribute
	 */
	private ArrayList findArcFromNode(String theCurrentNode)
	{
		ArrayList anArcList = new ArrayList();
		Iterator anArcListIt = itsArcs.iterator();
		while(anArcListIt.hasNext())
		{
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcListIt.next();
			if(anArc.getItsFromNode().equals(theCurrentNode))
			{
				anArcList.add(anArc);
			}
		}
		return anArcList;
	}
	
	/**
	 * Find the first node in a process flow
	 * @return the first node in the process
	 */
	private ReportDiagramNodeBean findProcessFirstNode()
	{
		ReportDiagramNodeBean aFirstNode = new ReportDiagramNodeBean();
		String aFirstNodeName = "";
		HashSet aFromNodeSet = new HashSet();
		HashSet aToNodeSet = new HashSet();
		Iterator anArcIt = itsArcs.iterator();
		while(anArcIt.hasNext())
		{
			// Find the one with a From but no To.
			ReportDiagramArcBean anArc = (ReportDiagramArcBean)anArcIt.next();
			if(!anArc.getItsFromNode().equals(""))
			{
				aFromNodeSet.add(anArc.getItsFromNode());
			}
			if(!anArc.getItsToNode().equals(""))
			{
				aToNodeSet.add(anArc.getItsToNode());
			}
		}
		
		// Find the node that's in the From Node but not the To Node
		Iterator aFromNodeIt = aFromNodeSet.iterator();
		while(aFromNodeIt.hasNext())
		{
			String aFromNodeName = (String)aFromNodeIt.next();
			if(!aToNodeSet.contains(aFromNodeName))
			{
				aFirstNodeName = aFromNodeName;
			}
		}
		
		aFirstNode = getNode(aFirstNodeName);
		return aFirstNode;
	}
	
}
