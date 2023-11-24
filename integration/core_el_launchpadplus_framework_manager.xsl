<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
   <xsl:variable name="controlFramework" select="/node()/simple_instance[type = 'Control_Framework']"/> 
  <xsl:variable name="controls" select="/node()/simple_instance[type = 'Control']"/>  
  <xsl:variable name="processFramework" select="/node()/simple_instance[type='Business_Process'][name=$controls/own_slot_value[slot_reference = 'control_supported_by_business']/value]"/>
  <xsl:variable name="processOwnerRole" select="/node()/simple_instance[type = 'Individual_Business_Role'][own_slot_value[slot_reference = 'name']/value='Managing Process Owner']"/>  
  <xsl:variable name="processOwnera2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_to_role']/value=$processOwnerRole/name]"/>  
  <xsl:variable name="actors" select="/node()/simple_instance[type = 'Individual_Actor']"/> 
  <xsl:variable name="processOwner" select="$actors[name=$processOwnera2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>  
  <xsl:variable name="processCSA" select="/node()/simple_instance[type = 'Control_Solution_Assessment']"/>  
  <xsl:variable name="assessment" select="/node()/simple_instance[type='Control_Assessment']"/>
  <xsl:variable name="controlToElement" select="/node()/simple_instance[type='CONTROL_TO_ELEMENT_RELATION'][own_slot_value[slot_reference = 'control_to_element_control']/value=$controls/name]"/>
	<xsl:variable name="processControls" select="/node()/simple_instance[type='Business_Process'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="applicationControls" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
	<xsl:variable name="technologyControls" select="/node()/simple_instance[supertype='Technology_Provider'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
  <xsl:variable name="assessmentc2e" select="/node()/simple_instance[type='Control_Assessment'][name=$controlToElement/own_slot_value[slot_reference = 'control_to_element_assessments']/value]"/>
	<xsl:variable name="assessmentFinding" select="/node()/simple_instance[type='Control_Assessment_Finding']"/>
  <xsl:key name="controlSolution_key" match="/node()/simple_instance[type='Control_Solution']" use="own_slot_value[slot_reference = 'control_solution_for_controls']/value"/>
  <xsl:key name="controlSolutionAssessment_key" match="$processCSA" use="own_slot_value[slot_reference = 'assessed_control_solution']/value"/>
  <xsl:key name="comment_key" match="/node()/simple_instance[type='Commentary']" use="own_slot_value[slot_reference = 'commentary_subject']/value"/>

  <xsl:key name="controlElement_key" match="/node()/simple_instance[type='CONTROL_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'control_solution_for_controls']/value"/>
  <xsl:key name="controlElementAssessed_key" match="/node()/simple_instance[type='Control_Assessment']" use="own_slot_value[slot_reference = 'control_assessed_element']/value"/>

  
  <xsl:variable name="allCommentary" select="/node()/simple_instance[type='Commentary']"/>
 
  <!-- END GENERIC LINK VARIABLES -->
 	<xsl:variable name="apiPathBusinessCapsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"/>
	<xsl:variable name="apiPathBusinessDomainsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Domains']"/>
 
	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	-->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		
        <xsl:variable name="apiPathNodes">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessCapsRep"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathApptoServer">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathBusinessDomainsRep"/>
            </xsl:call-template>
        </xsl:variable>
 
		  
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/> 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Launchpad Exporter</title> 
				<script src="js/FileSaver.min.js?release=6.19"/>
				<style>
				.minText {font-size:0.8em;
						  vertical-align: top;
							}
				.stepsHead {font-size:0.9em;
						  	horizontal-align: center;
							background-color:#393939;
							color:#fff}	
				.playBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					border-radius: 4px;
					width: 100%;
					margin-bottom: 10px;
					position: relative;
				}
				.notesBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					width:60%;
					border-radius: 4px; 
				}
				.playTitle{
					font-weight: 700;
					font-size: 110%;
				}
				.playDescription{
					font-size: 90%;
				}
				.playDocs {
					position: absolute;
					top: 5px;
					right: 5px;
				}
				.playSteps{
					display: none;
            }
           
				.playSteps > ul {
					<!--columns: 2;-->
				}

            .additional {
               color: #32a8a8;
            }
            .additionalShow {
               color: #32a8a8;
            }
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
 	 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Launchpad Export - Framework Controls</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-3">
							<p>
              <button id="genExcel" class="btn btn-default bg-primary text-white small bottom-10">Generate Framework Launchpad File</button>
              </p>
              <p>
              <a class="noUL" href="integration/plus/control_assessment_SPECv4.zip" download="control_assessment_SPECv4.zip">
                <button id="downloadSpec" class="btn btn-default bg-secondary text-white small bottom-10">Get Frameworks Import Specification</button>
                </a> 
              <br/>
                  <a href="integration/plus/LaunchpadPlus-Essential_Framework_Manager.docx" download="LaunchpadPlus-Essential_Framework_Manager.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
    
              </p>
						</div>
            <div class="col-md-9">
                <p>
                    The Frameworks import allows you to import frameworks, methods use to manage controls and assessments.  It also allows you to import assessed elements for controls, along with assessment dates and results.<br/>
                    The workbook will export any existing data.
                </p>
                <p>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <td>Sheet</td>
                            <td>Description</td>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Control Framework Assessment</td>
                            <td>Capture controls, the frameworks they apply to and, if you have the information, the managing process.  If you have assessed the process then that can be added along with the date, assessor and outcome.<br/>
                            Note: External reference links are not exported but you can add links if required - one row per link and ensure the row, including the ID is exactly the same as the previous if you are adding more than one link.  This will prevent duplicates being created</td>
                        </tr>  
                        <tr>
                            <td>Control Compliance Assessment</td>
                            <td>Assessments for elements in the repository against controls.  Ensure you only have one row per item being assessed.</td>
                        </tr> 
                          
                        </tbody>
                    </table>
                </p>
                </div>
						<!--Setup Closing Tags-->
					</div>
				</div>
 
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
 			
<script>

   let controls=[<xsl:apply-templates select="$controlFramework" mode="frameworkControls"/>];

   console.log('controls',controls)
	var worksheetList=[];
 	var ExcelArray=[];		
	
	statusSet={}
		 
    $('document').ready(function () {
   
	 
	var frameworkFragment   = $("#framework-tab").html();
   frameworkTemplate = Handlebars.compile(frameworkFragment);
	
	var complianceFragment   = $("#compliance-tab").html();
   complianceTemplate = Handlebars.compile(complianceFragment);
	
    Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) { 
    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
    });
    
	Handlebars.registerHelper('greaterThan', function (v1, v2, options) {
	'use strict';
	   if (v1>v2) {
		 return options.fn(this);
	  }
	  return options.inverse(this);
	});
	
	$('#genExcel').click(function(){

      console.log()
	var xmlhead, xmlfoot;
	getXML('integration/launchpad_plus_head.xml').then(function(response){
		xmlhead=response;	

		}).then(function(response){ 
 
		var LaunchpadJSON=[];
		ExcelArray=[];
	var worksheetText='';
   worksheetText 
 
	   ExcelString=xmlhead+worksheetText+frameworkTemplate(controls)+complianceTemplate(controls)+'&lt;/Workbook>';
 
		ExcelArray.push(ExcelString)
 
 	var blob = new Blob([ExcelArray[0]], {type: "text/xml"});
 	saveAs(blob, "launchpad_framework_export.xml");
	
   console.log(ExcelArray[0])
	  		});
		});
	});
	
var getXML = function promise_getExcelXML(excelXML_URL) {
    return new Promise(
    function (resolve, reject) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 &amp;&amp; this.status == 200) {
                ////console.log(prefixString);
                resolve(this.responseText);
            }
        };
        xmlhttp.onerror = function () {
            reject(false);
        };
        xmlhttp.open("GET", excelXML_URL, true);
        xmlhttp.send();
    });
};

</script>
<script  id="framework-tab" type="text/x-handlebars-template">
   <Worksheet ss:Name="Control Framework Assessment">
  <Names>
   <NamedRange ss:Name="_FilterDatabase"
    ss:RefersTo="='Control Framework Assessment'!R7C2:R7C13" ss:Hidden="1"/>
  </Names>
  <Table ss:ExpandedColumnCount="13"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="53" ss:DefaultRowHeight="15">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="218" ss:Span="1"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="105"/>
   <Column ss:Width="317"/>
   <Column ss:AutoFitWidth="0" ss:Width="106"/>
   <Column ss:AutoFitWidth="0" ss:Width="134" ss:Span="1"/>
   <Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="125"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:AutoFitWidth="0" ss:Width="79"/>
   <Column ss:AutoFitWidth="0" ss:Width="131"/>
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s19"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s41"><Data ss:Type="String">Control Framework Assessment</Data></Cell>
    <Cell><Data ss:Type="String">Key:</Data></Cell>
    <Cell ss:StyleID="s23"><Data ss:Type="String">Mandatory</Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">Optional</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s42"><Data ss:Type="String">Use this sheet to load the NIST Framework, and the assessment of the managing processes </Data></Cell>
   </Row>
   <Row ss:StyleID="s92"/>
   <Row ss:StyleID="s92">
    <Cell ss:Index="2"><Data ss:Type="String">Date:</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="16" ss:StyleID="s92">
    <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="m140222808481976"><Data
      ss:Type="String">Link to Managing Process Documentation</Data></Cell>
    <Cell ss:Index="11" ss:StyleID="s96"><Data ss:Type="String">ISO Format YYYY-MM-DD</Data></Cell>
   </Row>
   <Row ss:Height="40" ss:StyleID="s92">
    <Cell ss:Index="2" ss:StyleID="s23" ><Data ss:Type="String">ID</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s23" ><Data ss:Type="String">Control ID Name</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s23" ><Data ss:Type="String">Description</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s23" ><Data ss:Type="String">Framework</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22" ><Data ss:Type="String">Managing Process</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">Managing Process Owner</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">External Reference Link Name</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ><Data ss:Type="String">External Reference Link URL</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">Assessor</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ><Data ss:Type="String">Assessment Date</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">Outcome</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String">Comments</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
   </Row>
   {{#each this}}
    {{#each this.controls}}
    {{#if this.processes}}
      {{#each this.processes}}
   <Row ss:Height="45" ss:StyleID="s92">
    <Cell ss:Index="2" ><Data ss:Type="String">{{../this.id}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{../this.name}}</Data><NamedCell
      ss:Name="Control_ID_Name"/></Cell>
    <Cell ><Data ss:Type="String">{{../this.description}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{../../this.name}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.name}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.owner}}</Data></Cell>
    <Cell />
    <Cell ><Data ss:Type="String"> </Data></Cell>
    <Cell ><Data ss:Type="String">{{../control_solution.0.assessments.0.assessmentAssessor}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{../control_solution.0.assessments.0.assessmentDate}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{../control_solution.0.assessments.0.assessmentOutcome}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#each ../control_solution.0.assessments.0.assessmentComments}}{{this.name}}{{/each}}</Data></Cell>
   </Row>
      {{/each}}
      {{else}}
      <Row ss:Height="45" ss:StyleID="s92">
          <Cell ss:Index="2" ><Data ss:Type="String">{{this.id}}</Data></Cell>
          <Cell ><Data ss:Type="String">{{this.name}}</Data><NamedCell
            ss:Name="Control_ID_Name"/></Cell>
          <Cell ><Data ss:Type="String">{{this.description}}</Data></Cell>
          <Cell ><Data ss:Type="String">{{../this.name}}</Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell />
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String">{{control_solution.0.assessments.0.assessmentAssessor}}</Data></Cell>
          <Cell ><Data ss:Type="String">{{control_solution.0.assessments.0.assessmentDate}}</Data></Cell>
          <Cell ><Data ss:Type="String">{{control_solution.0.assessments.0.assessmentOutcome}}</Data></Cell>
          <Cell ><Data ss:Type="String">{{#each control_solution.0.assessments.0.assessmentComments}}{{this.name}}{{/each}}</Data></Cell>
         </Row>
      {{/if}}
    {{/each}}
   {{/each}} 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>8</ActiveRow>
     <RangeSelection>R9:R116</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C12</Range>
   <Type>List</Type>
   <Value>Outcome</Value>
  </DataValidation>
  <AutoFilter x:Range="R7C2:R7C13"
   xmlns="urn:schemas-microsoft-com:office:excel">
  </AutoFilter>
 </Worksheet>	
</script>	
<script  id="compliance-tab" type="text/x-handlebars-template">
   <Worksheet ss:Name="Control Compliance Assessment">
   
  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="13604" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s92" ss:DefaultColumnWidth="69"
   ss:DefaultRowHeight="15">
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="30"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="122"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="182"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="178"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="183"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="214"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="205"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="125"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="121"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:StyleID="s92" ss:AutoFitWidth="0" ss:Width="196"/>
   <Row>
    <Cell ss:Index="10" ss:StyleID="s98"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s99"><Data ss:Type="String">Control Compliance Assessment</Data></Cell>
    <Cell ss:StyleID="s100"/>
    <Cell ss:StyleID="s100"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="6" ss:StyleID="s101"><Data ss:Type="String">Use this sheet to load  the assessments of the elements against the control</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="3" ss:MergeAcross="4" ss:StyleID="m140222790472544"><Data
      ss:Type="String">Select One per Assessment Only</Data></Cell>
    <Cell ss:Index="9" ss:StyleID="s96"><Data ss:Type="String">ISO Format YYYY-MM-DD</Data></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row ss:Height="40">
    <Cell ss:Index="2" ><Data ss:Type="String">Control ID</Data></Cell>
    <Cell ><Data ss:Type="String">Assessed Business Process</Data></Cell>
    <Cell ><Data ss:Type="String">Assessed Composite Application Provider</Data></Cell>
    <Cell ><Data ss:Type="String">Assessed Application Provider</Data></Cell>
    <Cell ><Data ss:Type="String">Assessed Application Provider Interface</Data></Cell>
    <Cell ><Data ss:Type="String">Assesed Technology Product</Data></Cell>
    <Cell ><Data ss:Type="String">Assessor</Data></Cell>
    <Cell ><Data ss:Type="String">Assessment Date</Data></Cell>
    <Cell ><Data ss:Type="String">Outcome</Data></Cell>
    <Cell ><Data ss:Type="String">Comments</Data></Cell>
    <Cell ><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
    <Cell />
   </Row>
   {{#each this}}
    {{#each this.controls}}
      {{#each this.control_to_element}}
    <Row>
    <Cell ss:Index="2" ><Data ss:Type="String">{{../this.name}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#ifEquals this.type 'Business_Process'}}{{this.elementName}}{{/ifEquals}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#ifEquals this.type 'Composite_Application_Provider'}}{{this.elementName}}{{/ifEquals}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#ifEquals this.type 'Application_Provider'}}{{this.elementName}}{{/ifEquals}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#ifEquals this.type 'Application_Provider_Interface'}}{{this.elementName}}{{/ifEquals}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#ifEquals this.type 'Technology_Product'}}{{this.elementName}}{{/ifEquals}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.assessments.0.assessmentAssessor}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.assessments.0.assessmentDate}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.assessments.0.assessmentOutcome}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{#each this.assessments.0.assessmentComments}}{{this.name}}{{/each}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.assessments.0.description}}</Data></Cell>
      
   </Row>
       {{/each}}
     {{/each}}
   {{/each}}
   <Row>
    <Cell ss:Index="2" ss:StyleID="s112"/>
    <Cell ss:Index="11" />
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s112"/>
    <Cell ss:Index="11" />
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s112"/>
    <Cell ss:Index="11" />
   </Row>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>12</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R9C10</Range>
   <Type>List</Type>
   <Value>Outcome</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R12443C2</Range>
   <Type>List</Type>
   <Value>'Control Framework Assessment'!R8C3:R9994C3</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Sheet1">
  <Table ss:ExpandedColumnCount="2" ss:ExpandedRowCount="4" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="69" ss:DefaultRowHeight="15">
   <Row ss:Index="2">
    <Cell ss:Index="2"><Data ss:Type="String">Outcome</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Pass</Data><NamedCell
      ss:Name="Outcome"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Fail</Data><NamedCell
      ss:Name="Outcome"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Visible>SheetHidden</Visible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>2</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R3C2:R4C2</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</script>	
</body>
<script>
 <xsl:call-template name="RenderViewerAPIJSFunction"> 
 </xsl:call-template>
</script>			
		</html>
	</xsl:template>
 
	<xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
    </xsl:template>
	
	 <xsl:template name="RenderViewerAPIJSFunction">
  
 
		 
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            <!--$('#ess-data-gen-alert').hide();-->
                        }
                    };
                    xmlhttp.onerror = function () {
                        reject(false);
                    };
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(false);
                }
            });
        };
        var applicationTechArch={};
	   var applicationDependencies={};
   
    </xsl:template>

<xsl:template match="node()" mode="frameworkControls">
<xsl:variable name="controls" select="$controls[name=current()/own_slot_value[slot_reference='cf_controls']/value]"/>
    {
      "id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
     "controls":[<xsl:apply-templates select="$controls" mode="controls"/>]       
   }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<xsl:template match="node()" mode="controls">
    <xsl:variable name="thisprocessFramework" select="$processFramework[name=current()/own_slot_value[slot_reference = 'control_supported_by_business']/value]"/>
    <xsl:variable name="thiscontrolToElement" select="$controlToElement[own_slot_value[slot_reference = 'control_to_element_control']/value=current()/name]"/> 
    <xsl:variable name="thiscontrolSolution" select="key('controlSolution_key', current()/name)"/>
    {
      "id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
      "description":"<xsl:call-template name="RenderMultiLangInstanceDescription">
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
         <xsl:with-param name="theSubjectInstance" select="current()"/>
    </xsl:call-template>",
    "processes":[<xsl:for-each select="$thisprocessFramework">
        <xsl:variable name="thisprocessOwnera2r" select="$processOwnera2r[name=current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>  
        <xsl:variable name="thisprocessOwner" select="$processOwner[name=$thisprocessOwnera2r/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>  {
      "id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",   
       "owner":"<xsl:call-template name="RenderMultiLangInstanceName">
          <xsl:with-param name="theSubjectInstance" select="$thisprocessOwner"/>
          <xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
      "control_solution":[<xsl:apply-templates select="$thiscontrolSolution" mode="c2cs"/>],  
      "control_to_element":[<xsl:apply-templates select="$thiscontrolToElement" mode="c2es"/>]                 
   }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	

<xsl:template match="node()" mode="c2es">
  <xsl:variable name="thiscontrolAssess" select="key('controlElementAssessed_key', current()/name)"/>
  <xsl:variable name="element" select="/node()/simple_instance[name=current()/own_slot_value[slot_reference = 'control_to_element_ea_element']/value]"/>
    {
      "id":"<xsl:value-of select="current()/name"/>",
      "name":"temp",
      "type":"<xsl:value-of select="$element/type"/>", 
      "elementName":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="$element"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>",
      "assessments":[<xsl:for-each select="$thiscontrolAssess[position()=last()]">
        <xsl:variable name="thisAssessor" select="$actors[name=current()/own_slot_value[slot_reference = 'control_assessor']/value]"/>
        <xsl:variable name="thisOutcome" select="$assessmentFinding[name=current()/own_slot_value[slot_reference = 'assessment_finding']/value]"/>
        <xsl:variable name="thisComments" select="$allCommentary[name=current()/own_slot_value[slot_reference = 'commentary']/value]"/>        
            { 
            "id":"<xsl:value-of select="current()/name"/>",
            "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="current()"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>",
            "assessmentAssessor":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="$thisAssessor"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>",   
            "assessmentDate":"<xsl:value-of select="own_slot_value[slot_reference = 'assessment_date_iso_8601']/value"/>",   
            "assessmentOutcome":"<xsl:value-of select="$thisOutcome/own_slot_value[slot_reference = 'name']/value"/>",   
            "assessmentComments":[<xsl:for-each select="$thisComments">{
            "id":"<xsl:value-of select="current()/name"/>",
            "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="current()"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]    
          }<xsl:if test="position()!=last()">,</xsl:if>
      </xsl:for-each>]       
      }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="c2cs">
  <xsl:variable name="thiscontrolSolutionAssess" select="key('controlSolutionAssessment_key', current()/name)"/>
  
    {
      "id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>",
      "type":"<xsl:value-of select="current()/type"/>",      
      "assessments":[<xsl:for-each select="$thiscontrolSolutionAssess[position()=last()]">
        <xsl:variable name="thisAssessor" select="$actors[name=current()/own_slot_value[slot_reference = 'control_solution_assessor']/value]"/>
        <xsl:variable name="thisOutcome" select="$assessmentFinding[name=current()/own_slot_value[slot_reference = 'assessment_finding']/value]"/>
        <xsl:variable name="thisComments" select="$allCommentary[name=current()/own_slot_value[slot_reference = 'commentary']/value]"/>        
            { 
            "id":"<xsl:value-of select="current()/name"/>",
            "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="current()"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>",
            "assessmentAssessor":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="$thisAssessor"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>",   
            "assessmentDate":"<xsl:value-of select="own_slot_value[slot_reference = 'assessment_date_iso_8601']/value"/>",   
            "assessmentOutcome":"<xsl:value-of select="$thisOutcome/own_slot_value[slot_reference = 'name']/value"/>",   
            "assessmentComments":[<xsl:for-each select="$thisComments">{
            "id":"<xsl:value-of select="current()/name"/>",
            "name":"<xsl:call-template name="RenderMultiLangInstanceName">
                      <xsl:with-param name="theSubjectInstance" select="current()"/>
                      <xsl:with-param name="isRenderAsJSString" select="true()"/>
                  </xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]    
          }<xsl:if test="position()!=last()">,</xsl:if>
      </xsl:for-each>]      
      }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

</xsl:stylesheet>  
