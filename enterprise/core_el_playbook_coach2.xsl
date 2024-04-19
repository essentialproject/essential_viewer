<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
   <xsl:include href="../common/core_doctype.xsl"/>
   <xsl:include href="../common/core_common_head_content.xsl"/>
   <xsl:include href="../common/core_header.xsl"/>
   <xsl:include href="../common/core_footer.xsl"/>
   <xsl:include href="../common/core_external_doc_ref.xsl"/>
   <xsl:include href="js/handlebarsExcelTemplates.xsl"/>
   <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
   
   <xsl:param name="param1"/>
   
   <!-- START GENERIC PARAMETERS -->
   <xsl:param name="viewScopeTermIds"/>
   
   <!-- END GENERIC PARAMETERS -->
   
   <!-- START GENERIC LINK VARIABLES -->
   <xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
   <xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
   
   <xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>  
   <xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>  
  <xsl:variable name="techdelivery" select="/node()/simple_instance[type = 'Technology_Delivery_Model']"/> 
   <xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
   <xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
  <xsl:variable name="stdStrengths" select="/node()/simple_instance[type = 'Standard_Strength']"/>
  <xsl:variable name="criticality" select="/node()/simple_instance[type = 'Business_Criticality']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type = 'Data_Category']"/>
  <xsl:variable name="primitiveDO" select="/node()/simple_instance[type = 'Primitive_Data_Object']"/>
  <xsl:variable name="dataAttrCard" select="/node()/simple_instance[type = 'Data_Attribute_Cardinality']"/> 
  <xsl:variable name="timeliness" select="/node()/simple_instance[type = 'Information_Service_Quality_Value']"/> 
  <xsl:variable name="acqMethod" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/> 
  <xsl:variable name="language" select="/node()/simple_instance[type = 'Language']"/>  
   <xsl:variable name="synonym" select="/node()/simple_instance[type = 'Synonym'][name=$allStatus/own_slot_value[slot_reference='synonyms']/value]"/>  
   <xsl:variable name="style" select="/node()/simple_instance[type = 'Element_Style'][own_slot_value[slot_reference='style_for_elements']/value=$allStatus/name]"/>  
   <xsl:variable name="acquisition" select="/node()/simple_instance[type = 'Data_Acquisition_Method']"/>
   <xsl:variable name="allIndividuals" select="/node()/simple_instance[type='Individual_Actor']"/>
   <xsl:variable name="environment" select="/node()/simple_instance[type = 'Deployment_Role']"/>
   <xsl:variable name="allStatus" select="$codebase union $delivery union $lifecycle union $techlifecycle union $stdStrengths"/>
   <!-- END GENERIC LINK VARIABLES -->
   <xsl:variable name="apiPathBusinessCapsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Capabilities']"/>
   <xsl:variable name="apiPathBusinessDomainsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Domains']"/>
   <xsl:variable name="apiPathBusinessProcessRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes']"/>
   <xsl:variable name="apiPathBusinessProcessFamilyRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Process Families']"/>
   <xsl:variable name="apiPathSitesRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Sites']"/>
   <xsl:variable name="apiPathOrgsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Orgs with Sites']"/>
   <xsl:variable name="apiPathAppCapsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities']"/>
   <xsl:variable name="apiPathAppSvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Services']"/>
   <xsl:variable name="apiPathAppCap2SvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Capabilities 2 Services']"/>
   <xsl:variable name="apiPathAppsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications']"/>
   <xsl:variable name="apiPathApps2SvcsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Services']"/>
   <xsl:variable name="apiPathApps2orgsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications 2 Orgs']"/>
   <xsl:variable name="apiPathBPtoAppsSvcRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Business Processes to App Services']"/>
   <xsl:variable name="apiPathPPtoAppsViaSvcRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"/>
   <xsl:variable name="apiPathPPtoAppsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps']"/>
   <xsl:variable name="apiPathInfoRepRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Information Representations']"/>
   <xsl:variable name="apiPathNodesRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Nodes']"/>
   <xsl:variable name="apiPathApptoServerRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application to Server']"/>
   <xsl:variable name="apiPathTechDomainsRep" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Domains']"/>
   <xsl:variable name="apiPathTechCapReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Capabilities']"/>   
   <xsl:variable name="apiPathTechCompReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Components']"/>   
   <xsl:variable name="apiPathTechSupplierReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Suppliers']"/>   
   <xsl:variable name="apiPathTechProdReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Products']"/>   
   <xsl:variable name="apiPathTechProdFamilyReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Product Families']"/>   
   <xsl:variable name="apiPathTechProdOrgReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Technology Product Organisation Users']"/>   
   <xsl:variable name="apiPathDataSubjectReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Subjects']"/>   
   <xsl:variable name="apiPathDataObjectReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects']"/>   
   <xsl:variable name="apiPathDataObjectInheritReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects Inheritance']"/> 
   <xsl:variable name="apiPathDataObjectAttributesReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Data Objects Attributes']"/> 
   <xsl:variable name="apiPathDataAppDependencyReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Application Dependency']"/> 	
   <xsl:variable name="apiPathDataApptoTechReps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"/> 	
   
   
   
   
   <xsl:variable name="BusinessCapability" select="count(/node()/simple_instance[type='Business_Capability'])"/>
   <xsl:variable name="BusinessDomain" select="count(/node()/simple_instance[type='Business_Domain'])"/>
   <xsl:variable name="BusinessProcess" select="count(/node()/simple_instance[type='Business_Process'])"/>
   <xsl:variable name="BusinessProcessFamily" select="count(/node()/simple_instance[type='Business_Process_Family'])"/>
   <xsl:variable name="Site" select="count(/node()/simple_instance[type='Site'])"/>
   <xsl:variable name="GroupActor" select="count(/node()/simple_instance[type='Group_Actor'])"/>
   <xsl:variable name="ApplicationCapability" select="count(/node()/simple_instance[type='Application_Capability'])"/>
   <xsl:variable name="ApplicationService" select="count(/node()/simple_instance[type='Application_Service'])"/>
   <xsl:variable name="Applications" select="count(/node()/simple_instance[type=('Application_Provider', 'Composite_Application_Provider')])"/>
   <xsl:variable name="InformationRepresentation" select="count(/node()/simple_instance[type='Information_Representation'])"/>
   <xsl:variable name="TechnologyNode" select="count(/node()/simple_instance[type='Technology_Node'])"/>
   <xsl:variable name="TechnologyDomain" select="count(/node()/simple_instance[type='Technology_Domain'])"/>
   <xsl:variable name="TechnologyCapability" select="count(/node()/simple_instance[type='Technology_Capability'])"/>
   <xsl:variable name="TechnologyComponent" select="count(/node()/simple_instance[type='Technology_Component'])"/>
   <xsl:variable name="TechnologySupplier" select="count(/node()/simple_instance[type='Technology_Supplier'])"/>
   <xsl:variable name="TechnologyProduct" select="count(/node()/simple_instance[type='Technology_Product'])"/>
   <xsl:variable name="TechnologyProductFamily" select="count(/node()/simple_instance[type='Technology_Product_Family'])"/> 
   <xsl:variable name="DataSubject" select="count(/node()/simple_instance[type='Data_Subject'])"/>
   <xsl:variable name="DataObject" select="count(/node()/simple_instance[type='Data_Object'])"/>
   <xsl:variable name="DataObjectAttribute" select="count(/node()/simple_instance[type='Data_Object_Attribute'])"/>
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
            <xsl:with-param name="apiReport" select="$apiPathNodesRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathApptoServer">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathApptoServerRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathTechDomains">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechDomainsRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathTechCap">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechCapReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathBusinessCaps">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathBusinessCapsRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathBusinessDomains">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathBusinessDomainsRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathBusinessProcesses">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathBusinessProcessRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathBusinessProcessFamilies">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathBusinessProcessFamilyRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathSites">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathSitesRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathOrgs">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathOrgsRep"/>
         </xsl:call-template>
      </xsl:variable>		
      <xsl:variable name="apiPathAppCaps">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathAppCapsRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathAppSvcs">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathAppSvcsRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathAppCap2Svcs">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathAppCap2SvcsRep"/>
         </xsl:call-template>
      </xsl:variable>		
      <xsl:variable name="apiPathApps">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathAppsRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathApp2Svcs">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathApps2SvcsRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathApp2orgs">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathApps2orgsRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathBPtoAppsSvc">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathBPtoAppsSvcRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathPPtoAppsViaSvc">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathPPtoAppsViaSvcRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathPPtoApps">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathPPtoAppsRep"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathInfoRep">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathInfoRepRep"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathTechComp">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechCompReps"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathTechSupplier">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechSupplierReps"/>
         </xsl:call-template>
      </xsl:variable>	
      <xsl:variable name="apiPathTechProd">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechProdReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathTechProdFamily">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechProdFamilyReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathTechProdOrg">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathTechProdOrgReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataSubject">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataSubjectReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataObject">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataObjectReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataObjectInherit">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataObjectInheritReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataObjectAttributes">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataObjectAttributesReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataAppDependency">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataAppDependencyReps"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="apiPathDataApptoTech">
         <xsl:call-template name="GetViewerAPIPath">
            <xsl:with-param name="apiReport" select="$apiPathDataApptoTechReps"/>
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
            <title>Playbook Coach</title>
            <!--	<script type="text/javascript"
                 src="js/json-rules-engine/dist/json-rules-engine.js?release=6.19">  
                 </script>	 -->
            <script src="https://cdn.jsdelivr.net/npm/exceljs@4.4.0/dist/exceljs.min.js" integrity="sha256-fknaaFiOJQ27i7oZDSyqirN4fMAoS9odiy+AXE33Qsk=" crossorigin="anonymous"></script>		     
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.16.9/xlsx.full.min.js"></script>
            <script src="js/FileSaver.min.js?release=6.19"></script>   
<style>
               .minText{
               font-size: 0.8em;
               vertical-align: top;
               }
               
               .stepsHead{
               font-size: 0.9em;
               text-align: center;
               background-color: #393939;
               color: #fff}
               
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
               width: 60%;
               border-radius: 4px;
               }
               
               .playTitle{
               font-weight: 700;
               font-size: 110%;
               }
               
               .playDescription{
               font-size: 90%;
               }
               
               .playDocs{
               position: absolute;
               top: 5px;
               right: 5px;
               }
               
               .playSteps{
               display: none;
               }
               
               .playSteps > ul{
               /*columns: 2;*/
               }
               
               
               .label{
               font-size: 1.2em
               }
               
               
               
               
               /* Mark input boxes that gets an error on validation: */
               
               input.invalid{
               background-color: #ffdddd;
               }
               
               /* Hide all steps by default: */
               
               .tab{
               display: block;
               }
               
               /* Make circles that indicate the steps of the form: */
               
               .step{
               height: 15px;
               width: 15px;
               margin: 0 2px;
               background-color: #bbbbbb;
               border: none;
               border-radius: 50%;
               display: inline-block;
               opacity: 0.5;
               }
               
               /* Mark the active step: */
               
               .step.active{
               opacity: 1;
               }
               
               /* Mark the steps that are finished and valid: */
               
               .step.finish{
               background-color: #4CAF50;
               }
               
               .playcard{
               border: 1pt solid #d3d3d3;
               border-radius: 4px;
               width: 200px;
               display: inline-block;
               vertical-align: top;
               margin-right: 5px;
               }
               
               .smallTitle{
               position: absolute;
               top: 3pt;
               color: #6f6f6f;
               font-size: 6pt
               }
               
               .cardparties{
               background-color: #f2f2f2;
               padding: 5px
               }
               
               .cardusage{
               background-color: #e8e8e8;
               padding: 5px
               }
               
               .cardwhat{
               background-color: #e2e2e2;
               padding: 5px
               }
               
               .cardname{
               background-color: #c41e3a;
               color: #fff;
               font-weight: bold;
               padding: 5px
               }
               
               #eaForm{
               background-color: #ddd;
               margin: 50px auto;
               padding: 15px;
               width: 75%;
               min-width: 300px;
               box-shadow: 1px 1px 2px 1px rgba(0,0,0,0.25);
               }

.questionanswercontainer {
    display: flex;
    align-items: flex-start; /* This aligns the items at the top */
}
               /* Overall container */
.tab-content {
    font-family: 'Arial', sans-serif;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

/* Panel containing questions */
.questionPanel {
    width: 450px;
    background-color: #f2f2f2;
    padding: 3px;
    border: 1pt solid #000000;
    border-radius: 4px;
    margin-bottom: 20px;
}

.resultsPanel{
padding: 3x;

}

.question-section {
    background-color: #c2ced8;
    padding: 10px;
    margin-bottom: 1px;
    display: block;
    font-size: 1em;
    min-height: 80px;
    width: 98%;
    box-shadow: inset 0 0 2px #333;
    border-left: 7px solid palevioletred;
}

.lp-setup-legend {
    border: 1pt solid #d3d3d3;
    border-radius: 4px;
    padding: 10px;
    color: #000;
    font-size: 85%;
}

.launch:hover {
    cursor: pointer;
}

/* Styling select elements */
.custom-select {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid #ccc;
    border-radius: 4px;
    background-color: #fff;
    font-size: 16px;
    color: #333;
    box-sizing: border-box;
}

/* Styling the submit button */
#submit {
    background-color: #4CAF50; /* Green */
    color: white;
    padding: 12px 20px;
    margin: 10px 0;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

#submit:hover {
    background-color: #45a049;
}

/* Clearfix for floating elements */
.clearfix::after {
    content: "";
    clear: both;
    display: table;
}

/* Additional styles for results */
#results {
    margin-top: 20px;
    padding-left:3px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .tab-content {
        padding: 10px;
    }

    .questionPanel {
        width: auto;
        padding: 10px;
    }
}
.eas-logo-spinner {​​​​​​ 
    display: flex; 
    justify-content: center; 
}​​​​​​ 
#editor-spinner {​​​​​​​​​​​​​ 
    height: 100px; 
    width: 100px; 
    position: fixed; 
    top: 300px; 
    left: 300px;; 
    z-index:999999; 
    background-color: hsla(255,100%,100%,0.75); 
    text-align: center; 
}​​​​​​​​​​​​​ 
#editor-spinner-text {​​​​​​​​​​​​​ 
    width: 100px; 
    z-index:999999; 
    text-align: center; 
}​​​​​​​​​​​​​ 
.spin-text {​​​​​​​​​​​​​ 
    font-weight: 700; 
    animation-duration: 1.5s; 
    animation-iteration-count: infinite; 
    animation-name: logo-spinner-text; 
    color: #aaa; 
    float: left; 
}​​​​​​​​​​​​​ 
.spin-text2 {​​​​​​​​​​​​​ 
    font-weight: 700; 
    animation-duration: 1.5s; 
    animation-iteration-count: infinite; 
    animation-name: logo-spinner-text2; 
    color: #666; 
    float: left; 
}​​​​​​​​​​​​​ 

// xls load styles

					.active-tab {
						background-color: #ddd;
					}
					table, th, td {
						border: 1px solid black;
						border-collapse: collapse;
					}
					th, td {
						padding: 5px;
						text-align: left;
					}
					.table-condensed{
						font-size:0.9em;
					}
					.modaltd{
						border:0px;
					}
				
				.fileDiv {
					border: 1pt solid #000;
					border-radius: 4px;
					padding: 3px;
					margin: 2px;
					width: 48%;
					position: relative;
					font-size: 0.9em;
					display: inline-block;
					height: 102px;
					vertical-align: top;
					background-color: #ffffff;
					color: #101010;
					}
				.buttDiv{
						position:absolute;
						bottom:2px;
						right:2px;
					}
				.worksheetBox{
               margin:5px;
               border:1pt solid #d3d3d3;
               padding:3px;
               border-radius:6px;
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
                           <span class="text-darkgrey">Playbook Coach</span>
                        </h1>
                     </div>
                  </div>
               	<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
                  <div class="col-xs-12">
                     <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#coach">Playbook</a></li> 
                        <li><a data-toggle="tab" href="#advice">Advice</a></li> 
                        <li><a data-toggle="tab" href="#launchpad">Launchpad</a></li> 
                        <li><a data-toggle="tab" href="#launchpadImport">Launchpad Import</a></li>
                     </ul>	
                     <div class="tab-content">
                        <div id="coach" class="tab-pane fade in active">
                         <div class="questionanswercontainer">
                           <div class="questionPanel">
                            <h3>Questions</h3>
                              <!-- One "tab" for each step in the form: -->
                               <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> What is the level of engagement of management?
                                 <select id="engaged" class="custom-select form-control"> 
                                    <option class="option" essValue="High" value="H">High</option>
                                    <option class="option" essValue="Medium"  selected="true"  value="M">Medium</option>
                                    <option class="option" essValue="Low"  value="Low">Low</option>
                                    <option class="option" essValue="High"  value="NA">Don't know</option>
                                 </select>
                                </div>
                                 
                              </div>
                              
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> What is the key driver for EA currently?
                                 <select id="driver" class="custom-select form-control"> 
                                    <option class="option" essValue="risk" value="Risk">Risk</option>
                                    <option class="option" essValue="efficiency" value="Efficiency">Cost Efficiency</option>
                                    <option class="option"  selected="true" essValue="High" value="Rationalisation">Rationalisation</option>
                                    <option class="option"  essValue="strategy alignment" value="Alignment">Strategy Alignment</option>
                                    <option class="option"  essValue="Business Model change" value="Model">Business Model Change</option>
                                    <option class="option"  essValue="Digital" value="Digital">Digital Business Transformation</option>
                                    <option class="option"  essValue="Don't know" value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>
                          
                              <div class="tab">	
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have good working relationship with the business, i.e. people who you can work with to deliver elements of the EA?
                                 <select id="interest" class="custom-select form-control"> 
                                    <option class="option"  essValue="yes" selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="no" value="N">No</option> 
                                 </select> 
                                </div>
                              </div>	
                              <div class="tab">	
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have good engagement within IT, some scepticism or a bit of both?
                                 <select id="itinterest" class="custom-select form-control"> 
                                    <option class="option" essValue="Good" selected="true" value="Good">Good</option>
                                    <option class="option" essValue="Bad" value="Bad">Not good</option>
                                    <option class="option" essValue="mixed" value="mixed">Mixed</option>
                                 </select>
                                </div>
                              </div>	
                       
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> 
                                    How would you describe your maturity
                                    <ol>
                                       <li>Disparate data, some catalogues, reactive, low interest beyond a few IT teams, CIO looking for value</li>
                                       <li>Good engagement with CIO, but no wide engagement beyond IT</li>
                                       <li>Engagement with IT projects on regular basis, interaction with business on regular basis</li>
                                       <li>Embedded in change process, feeding into business decisions</li>
                                       <li>Port of call in strategic business decisions, involved in any M&amp;A activity</li>
                                    </ol> 
                                 <select id="maturity" class="custom-select form-control"> 
                                    <option class="option"  selected="true" essValue="Disparate reactive" value="1">Level 1</option>  
                                    <option class="option"  essValue="not wide" value="2">Level 2</option>  
                                    <option class="option"  essValue="engaged but not interactive" value="3">Level 3</option>
                                    <option class="option"  essValue="good" value="4">Level 4</option> 
                                    <option class="option"  essValue="top drawer engagement" value="5">Level 5</option>
                                 </select>
                                </div>
                              </div>		
                           
                              
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> 
                                    Do you have a business capability model defined?
                                 <select id="buscap" class="custom-select form-control"> 
                                    <option class="option" essValue="Yes"  selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="No"  value="N">No</option> 
                                    <option class="option" essValue="Don't know"  value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>	
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> 
                                    Do you have a business processes defined and linked to applications?
                                 <select id="busproc" class="custom-select form-control"> 
                                    <option class="option" essValue="Yes" selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="no" value="N">No</option> 
                                    <option class="option" essValue="Don't know" value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>		
                              <div class="tab">		
                                 <div class="question-section"><i class="fa fa-question-circle"></i> 
                                    Do you have a list of applications?
                                 
                                 <select id="apps" class="custom-select form-control"> 
                                    <option class="option" essValue="Yes" selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="No" value="N">No</option> 
                                 </select>
                                </div>
                              </div>
                              <div class="tab">			
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have access to application costs?
                                 <select id="costaccess" class="custom-select form-control"> 
                                    <option class="option"  essValue="yes"  value="Y">Yes</option>
                                    <option class="option" essValue="no"  selected="true"  value="N">No</option> 
                                 </select>
                                </div>
                              </div>	
                              <div class="tab">		
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have a list of technologies used?
                                 
                                 <select id="techlist" class="custom-select form-control"> 
                                    <option class="option" essValue="yes"  selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="no"  value="N">No</option> 
                                 </select>
                                </div>
                              </div>
                              <div class="tab">			
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have access to technology costs?
                                 <select id="techcostaccess" class="custom-select form-control"> 
                                    <option class="option" essValue="yes"  value="Y">Yes</option>
                                    <option class="option" essValue="no"  selected="true"  value="N">No</option> 
                                 </select>
                                </div>
                              </div>			
                              <div  class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have access to vendor technology Lifecycles?
                                 <select id="vendlife" class="custom-select form-control"> 
                                    <option class="option"  selected="true" value="Y">Yes</option>
                                    <option class="option"  value="N">No</option> 
                                    <option class="option"  value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>	
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have standards defined?
                                 <select id="standards" class="custom-select form-control"> 
                                    <option class="option" essValue="yes"  value="Y">Yes</option>
                                    <option class="option" essValue="no"  selected="true"  value="N">No</option> 
                                    <option class="option" essValue="don't know"  value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>	
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have strategic plans/roadmaps defined?
                                 <select id="plans" class="custom-select form-control"> 
                                    <option class="option" essValue="yes"  value="Y">Yes</option>
                                    <option class="option" essValue="no"  selected="true" value="N">No</option> 
                                    <option class="option" essValue="don't know"  value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>	
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> Do you have a project portfolio?
                                 <select id="projects" class="custom-select form-control"> 
                                    <option class="option" essValue="yes"  selected="true" value="Y">Yes</option>
                                    <option class="option" essValue="no"  value="N">No</option> 
                                    <option class="option" essValue="don't know"  value="NA">Don't know</option>
                                 </select>
                                </div>
                              </div>			
                              <div class="tab">
                                 <div class="question-section"><i class="fa fa-question-circle"></i> What is the current credibility of EA in the organisation?
                                 <select id="credibility" class="custom-select form-control">  
                                    <option class="option" essValue="none"  value="1">None</option>  
                                    <option class="option" essValue="low"  value="2">Low</option>  
                                    <option class="option" essValue="ok"  selected="true" value="3">OK</option>
                                    <option class="option" essValue="high"  value="4">High</option> 
                                    <option class="option" essValue="very high"  value="5">Very High</option>
                                 </select> 
                                </div>
                              </div>	
                           
                              
                            <div class="pull-right"><button id="submit" class="btn btn-success">Submit</button></div>
                              <div class="clearfix"/>
                            </div>	
                          
                           <div id="results" class="top-10 resultsPanel">
                              <div id="playResults"></div>
                              
                           </div>
                        </div>
                           
                        </div>
                        <div id="advice" class="tab-pane fade">
                            <div id="editor-spinner" class="hidden"> 
                                <div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;"> 
                                    <div class="spin-icon" style="width: 60px; height: 60px;"> 
                                        <div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/> 
                                        <div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/> 
                                        <div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/> 
                                    </div>                       
                                </div> 
                                <div id="editor-spinner-text" class="text-center xlarge strong spin-text2"/> 
                            </div>  
                            <div id="adviceBox"/>


                        </div>
                        <div id="launchpad" class="tab-pane fade">
                           <button onclick="createWorkbookFromJSON()">Download Excel File</button>
                           <p>Note: if there are dropdowns in the spreadsheet that reference sheets not exported, you may get an update warning when opening the downloaded spreadsheet, you can ignore the warning or export the relevant sheets</p>
                           <div class="col-xs-4">
                           <h3 class="text-primary">Worksheets</h3>
                           <ul class="list-unstyled">
                              <li><i class="fa fa-circle right-5" id="bc"/><input type="checkbox" class="sheet" id="busCapsWorksheetCheck" easid="4" name="busCapsWorksheetCheck" value="false"/>Business Capabilities <i class="fa fa-cloud-download additional" id="busCapsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="bd"/><input type="checkbox" class="sheet" id="busDomWorksheetCheck" easid="2" name="busDomWorksheetCheck" value="false"/>Business Domains <i class="fa fa-cloud-download additional" id="busDomi"></i></li>
                              <li><i class="fa fa-circle right-5" id="bp"/><input type="checkbox" class="sheet" id="busProcsWorksheetCheck" easid="5" name="busProcsWorksheet" value="false"/>Business Processes  <i class="fa fa-cloud-download additional" id="busProcsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="bpf"/><input type="checkbox" class="sheet" id="busProcsFamilyWorksheetCheck" easid="7" name="busProcsFamilyWorksheetCheck" value="false"/>Business Process Families</li>
                              <li><i class="fa fa-circle right-5" id="st"/><input type="checkbox" class="sheet" id="sitesCheck" easid="7" name="sitesCheck" value="false"/>Sites  <i class="fa fa-cloud-download additional" id="sitesi"></i></li>
                              <li><i class="fa fa-circle right-5" id="or"/><input type="checkbox" class="sheet" id="orgsCheck" easid="7" name="orgsCheck" value="false"/>Organisations  <i class="fa fa-cloud-download additional" id="orgsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="ors"/><input type="checkbox" class="sheet" id="orgs2sitesCheck" easid="7" name="orgs2sitesCheck" value="false"/>Orgs to Sites </li>
                              <li><i class="fa fa-circle right-5" id="ac"/><input type="checkbox" class="sheet" id="appCapsCheck" easid="7" name="appCapsCheck" value="false"/>Application Capabilities  <i class="fa fa-cloud-download additional" id="appCapsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="as"/><input type="checkbox" class="sheet" id="appSvcsCheck" easid="7" name="appSvcsCheck" value="false"/>Application Services  <i class="fa fa-cloud-download additional" id="appSvcsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="ac2s"/><input type="checkbox" class="sheet" id="appCaps2SvcsCheck" easid="7" name="appCaps2SvcsCheck" value="false"/>Application Caps 2 Services</li>
                              <li><i class="fa fa-circle right-5" id="aps"/><input type="checkbox" class="sheet" id="appsCheck" easid="7" name="appsCheck" value="false"/>Applications  <i class="fa fa-cloud-download additional" id="appsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="aps2sv"/><input type="checkbox" class="sheet" id="apps2svcsCheck" easid="7" name="apps2svcsCheck" value="false"/>Applications to Service <i class="fa fa-cloud-download additional" id="apps2svcsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="aps2or"/><input type="checkbox" class="sheet" id="apps2orgsCheck" easid="7" name="apps2orgsCheck" value="false"/>Applications to Orgs</li>
                              <li><i class="fa fa-circle right-5" id="bp2srvs"/><input type="checkbox" class="sheet" id="busProc2SvcsCheck" easid="7" name="busProc2SvcsCheck" value="false"/>Bus Processes to App Services</li>
                              <li><i class="fa fa-circle right-5" id="phyp2appsv"/><input type="checkbox" class="sheet" id="physProc2AppVsCheck" easid="7" name="physProc2AppVsCheck" value="false"/>Physical Process to Apps via Services</li>
                              <li><i class="fa fa-circle right-5" id="phyp2appdirect"/><input type="checkbox" class="sheet" id="physProc2AppCheck" easid="7" name="physProc2AppCheck" value="false"/>Physical Process to Apps</li>
                              <li><i class="fa fa-circle right-5" id="infex"/><input type="checkbox" id="infoExchangedCheck" easid="7" name="infoExchangedCheck" value="false"/>Information Exchanged  <i class="fa fa-cloud-download additional" id="infoXi"></i></li>
                              <li><i class="fa fa-circle right-5" id="nodes"/><input type="checkbox" class="sheet" id="nodesCheck" easid="7" name="nodesCheck" value="false"/>Servers  <i class="fa fa-cloud-download additional" id="nodesi"></i></li>
                              <li><i class="fa fa-circle right-5" id="ap2servs"/><input type="checkbox" class="sheet" id="apps2serverCheck" easid="7" name="apps2serverCheck" value="false"/>Application to Server</li>
                              <li><i class="fa fa-circle right-5" id="tds"/><input type="checkbox" class="sheet" id="techDomsCheck" easid="7" name="techDomsCheck" value="false"/>Technology Domains  <i class="fa fa-cloud-download additional" id="techDomsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="tcaps"/><input type="checkbox" class="sheet" id="techCapsCheck" easid="7" name="techCapsCheck" value="false"/>Technology Capabilities  <i class="fa fa-cloud-download additional" id="techCapsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="tcomps"/><input type="checkbox" class="sheet" id="techCompsCheck" easid="7" name="techCompsCheck" value="false"/>Technology Components  <i class="fa fa-cloud-download additional" id="techCompsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="tsups"/><input type="checkbox" class="sheet" id="techSuppliersCheck" easid="7" name="techSuppliersCheck" value="false"/>Technology Suppliers  <i class="fa fa-cloud-download additional" id="techSuppi"></i></li>
                              <li><i class="fa fa-circle right-5" id="tprods"/><input type="checkbox" class="sheet" id="techProductsCheck" easid="7" name="techProductsCheck" value="false"/>Technology Products  <i class="fa fa-cloud-download additional" id="techProdsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="tprodfams"/><input type="checkbox" class="sheet" id="techProductFamiliesCheck" easid="7" name="techProductFamiliesCheck" value="false"/>Technology Product Families <i class="fa fa-cloud-download additional" id="techFami"></i></li>
                              <li><i class="fa fa-circle right-5" id="tprodors"/><input type="checkbox" class="sheet" id="techProducttoOrgsCheck" easid="7" name="techProducttoOrgsCheck" value="false"/>Technology Products to Orgs</li>
                              <li><i class="fa fa-circle right-5" id="dsubjs"/><input type="checkbox" class="sheet" id="dataSubjectCheck" easid="7" name="dataSubjectCheck" value="false"/>Data Subjects  <i class="fa fa-cloud-download additional" id="dataSubjsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="dObjs"/><input type="checkbox" class="sheet" id="dataObjectCheck" easid="7" name="dataObjectCheck" value="false"/>Data Objects  <i class="fa fa-cloud-download additional" id="dataObjsi"></i></li>
                              <li><i class="fa fa-circle right-5" id="dObjins"/><input type="checkbox" class="sheet" id="dataObjectInheritCheck" easid="7" name="dataObjectInheritCheck" value="false"/>Data Object Inheritance</li>
                              <li><i class="fa fa-circle right-5" id="dObjAts"/><input type="checkbox" class="sheet" id="dataObjectAttributeCheck" easid="7" name="dataObjectAttributeCheck" value="false"/>Data Object Attributes</li>
                              <li><i class="fa fa-circle right-5" id="appDps"/><input type="checkbox" class="sheet" id="appDependencyCheck" easid="7" name="appDependencyCheck" value="false"/>Application Dependencies</li>								<li><i class="fa fa-circle right-5" id="apptechs"/><input type="checkbox" id="apptotechCheck" easid="7" name="apptotechCheck" value="false"/>App to Technology Products</li>
                           
                           </ul>
                           </div>
                           <div class="col-md-4">
                              <h3 class="text-primary">Foundation Views</h3>
                              <ul class="list-unstyled">
                                 <li><input type="checkbox" class="views" id="busCapDash"/>Business Capability Dashboard</li>
                                 <li><input type="checkbox" class="views" id="appRefModel"/>Application Reference Model </li>
                                 <li><input type="checkbox" class="views"  id="techRef"/>Technology Reference Model</li> 
                                 <li><input type="checkbox" class="views"  id="itAsset"/>IT Asset Dashboard</li>
                             
                                 <li><input type="checkbox" class="views"  id="domi"/>Data Object Model</li> 
                                 <li><input type="checkbox" class="views" id="afoot"/>Application Footprint Comparison </li>
                                 <li><input type="checkbox" class="views" id="appStratTech"/>Application Technology Strategy Alignment</li>
                                
                                 <li><input type="checkbox" class="views" id="ari"/>Application Radar</li>
                                 <li><input type="checkbox" class="views" id="adepsi"/>Application Dependency</li>
                                 <li><input type="checkbox" class="views" id="arai"/>Application Rationalisation Analysis</li> 
                                 <li><input type="checkbox" class="views" id="bditi"/>Business Domain IT Analysis </li>
                                 <li><input type="checkbox" class="views" id="bdpai"/>Business Domain Process Analysis</li>
                                 <!--
                                    <li><input type="checkbox" class="views" id="adai"/>Application Diversity Analysis </li>
                                 <li><input type="checkbox" id="appcat"/>Application Catalogue</li>
                                 <li><input type="checkbox" id="bcsi"/>Business Capability Summary </li>
                                 <li><input type="checkbox" id="bctti"/>Business Capability to Technology Tree</li> 
                                 <li><input type="checkbox" id="bctfi"/>Business Capability to Technology Force</li> 
                                 <li><input type="checkbox" id="acsi"/>Application Capability Summary </li>
                                 <li><input type="checkbox" id="asumi"/>Application Summary </li>
                                 <li><input type="checkbox" class="views" id="adci"/>Application Deployment Summary</li> 
                                 <li><input type="checkbox" id="busProcSumm"/>Business Process Summary</li>
                                 <li><input type="checkbox" id="bpfsi"/>Business Process Family Summary</li> 
                                 <li><input type="checkbox" id="tcsi"/>Technology Component Summary </li>
                                 <li><input type="checkbox" id="tpsi"/>Technology Product Summary</li> 
                                 <li><input type="checkbox" id="tnsi"/>Technology Node Summary </li>
                                 <li><input type="checkbox" id="techcat"/>Technology Catalogue</li> 
                                 
                                 <li><input type="checkbox" id="dssi"/>Data Subject Summary</li> 
                                 <li><input type="checkbox" id="dosi"/>Data Object Summary</li>
                                 -->
                              </ul>
                           </div>
                           <div class="col-xs-4"></div>
                           <div class="clearfix"/>
                        </div>
                        <div id="launchpadImport" class="tab-pane">
                           <div class="main-content">
                              Excel or ODS: <input type="file" id="fileUpload" accept=".xls,.xlsx,.ods"/>	<span id="filespinner"><i class="fa fa-spinner"></i> - Loading File</span>
                              <div class="pull-right">Workbook Mappings
                                 <button id="loadworksheet" class="btn btn-xs btn-primary"><i class="fa fa-upload"></i> Load Worksheet</button><xsl:text> </xsl:text>
                                 <button id="loadworkbook" class="btn btn-xs btn-primary"><i class="fa fa-floppy-o"></i> Load Workbook</button>
                              </div>
                              <div class="worksheetBox">
                                 <table>
                                    <tr style="font-size: 0.9em">
                                       <td>Worksheet</td>
                                       <td></td>
                                    </tr>
                                    <tr>
                                    <td>
                                       <select id="worksheetSelect"></select>
                                    </td>
                                 
                                    <td>
                                       <i class="fa fa-plus-circle mapper" id="addRowButton"></i>
                                    </td>
                                    </tr>
                                    
                                 </table>
                              </div>
                              <div class="table-container"></div> 
                           </div>
                        </div>
                     </div>	
                  </div>
               </div>
            </div>
            
            <!-- ADD THE PAGE FOOTER -->
            <xsl:call-template name="Footer"/>
            <xsl:call-template name="excelTemplates"/>
            
            <script>
               let BusinessCapability = <xsl:value-of select='$BusinessCapability'/>;
               let BusinessDomain = <xsl:value-of select='$BusinessDomain'/>;
               let BusinessProcess = <xsl:value-of select='$BusinessProcess'/>;
               let BusinessProcessFamily = <xsl:value-of select='$BusinessProcessFamily'/>;
               let Site = <xsl:value-of select='$Site'/>;
               let GroupActor = <xsl:value-of select='$GroupActor'/>;
               let ApplicationCapability = <xsl:value-of select='$ApplicationCapability'/>;
               let ApplicationService = <xsl:value-of select='$ApplicationService'/>;
               let Applications = <xsl:value-of select='$Applications'/>;
               let InformationRepresentation = <xsl:value-of select='$InformationRepresentation'/>;
               let TechnologyNode = <xsl:value-of select='$TechnologyNode'/>;
               let TechnologyDomain = <xsl:value-of select='$TechnologyDomain'/>;
               let TechnologyCapability = <xsl:value-of select='$TechnologyCapability'/>;
               let TechnologyComponent = <xsl:value-of select='$TechnologyComponent'/>;
               let TechnologySupplier = <xsl:value-of select='$TechnologySupplier'/>;
               let TechnologyProduct = <xsl:value-of select='$TechnologyProduct'/>;
               let TechnologyProductFamily = <xsl:value-of select='$TechnologyProductFamily'/>;
               let DataSubject = <xsl:value-of select='$DataSubject'/>;
               let DataObject = <xsl:value-of select='$DataObject'/>;
               let DataObjectAttribute = <xsl:value-of select='$DataObjectAttribute'/>;			
               
               
               console.log("COUNTS:"+BusinessCapability+":"+BusinessDomain+":"+BusinessProcess+":"+BusinessProcessFamily+":"+Site+":"+GroupActor+":"+ApplicationCapability+":"+ApplicationService+":"+Applications+":"+InformationRepresentation+":"+TechnologyNode+":"+TechnologyDomain+":"+TechnologyCapability+":"+TechnologyComponent+":"+TechnologySupplier+":"+TechnologyProduct+":"+TechnologyProductFamily+":"+DataSubject+":"+DataObject+":"+DataObjectAttribute)			
            </script>	
            
            <!-- rules for coach -->			
            <script>
               
               var play={set:[{"name":"play1",
               "data":["apps","caps"]},
               {"name":"play2",
               "data":["apps","caps","info"]},
               {"name":"play3",
               "data":["apps","caps","info"]}
               ]};	
               
               var viewsData={"views":[{
               "name": "IT Asset Dashboard",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "GroupActor", "ApplicationCapability", "ApplicationService", "Applications", "TechnologyDomain", "TechnologyCapability", "TechnologyComponent", "TechnologyProduct"]
               }, {
               "name": "Application Reference Model",
               "data": ["ApplicationCapability", "ApplicationService", "Applications"]
               }, {
               "name": "Application Capability Summary",
               "data": ["ApplicationCapability", "ApplicationService"]
               }, {
               "name": "Application Summary",
               "data": ["BusinessProcess", "GroupActor", "ApplicationService", "Applications", "TechnologyNode", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct", "TechnologyProductFamily"
               ]
               }, {
               "name": "Application Footprint Comparison",
               "data": ["BusinessCapability", "BusinessProcess", "ApplicationCapability", "ApplicationService", "Applications"
               ]
               }, {
               "name": "Application Deployment Summary",
               "data": ["Site", "GroupActor", "Applications", "TechnologyNode"]
               }, {
               "name": "Application Diversity Analysis",
               "data": ["ApplicationCapability", "ApplicationService", "Applications", "TechnologyNode", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct"]
               }, {
               "name": "Application Radar",
               "data": ["BusinessCapability", "BusinessDomain", "ApplicationService", "Applications"]
               }, {
               "name": "Application Dependency",
               "data": ["Applications", "InformationRepresentation"]
               }, {
               "name": "Application Catalogue",
               "data": ["Site", "GroupActor", "ApplicationCapability", "ApplicationService", "Applications"]
               }, {
               "name": "Application Rationalisation Analysis",
               "data": ["ApplicationService", "Applications"]
               }, {
               "name": "Business Capability Model",
               "data": ["BusinessCapability", "BusinessDomain"]
               }, {
               "name": "Business Capability Summary",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "ApplicationService", "Applications"]
               }, {
               "name": "Business Capability to Technology Tree",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "ApplicationService", "Applications", "TechnologyNode"]
               }, {
               "name": "Business Capability to Technology Force",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "ApplicationService", "Applications", "TechnologyNode"]
               }, {
               "name": "Business Domain IT Analysis",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "ApplicationService", "Applications", "TechnologyNode", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct"]
               }, {
               "name": "Business Domain Process Analysis",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "ApplicationService", "Applications", "TechnologyNode", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct"]
               }, {
               "name": "Business Process Summary",
               "data": ["BusinessProcess", "Site", "GroupActor", "Applications"]
               }, {
               "name": "Business Process Family Summary",
               "data": ["BusinessCapability", "BusinessDomain", "BusinessProcess", "BusinessProcessFamily", "Site", "GroupActor", "ApplicationService", "Applications"]
               }, {
               "name": "Application Technology Strategy Alignment",
               "data": ["Applications", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct"]
               }, {
               "name": "Technology Component Summary",
               "data": ["TechnologyCapability", "TechnologyComponent", "TechnologyProduct"]
               }, {
               "name": "Technology Product Summary",
               "data": ["Applications", "TechnologyCapability", "TechnologyComponent", "TechnologySupplier", "TechnologyProduct", "TechnologyProductFamily"]
               }, {
               "name": "Technology Node Summary",
               "data": ["Site", "GroupActor", "Applications", "TechnologyNode"]
               }, {
               "name": "Technology Catalogue",
               "data": ["TechnologyComponent", "TechnologySupplier", "TechnologyProduct"]
               }, {
               "name": "Technology Reference Model",
               "data": ["GroupActor", "TechnologyDomain", "TechnologyCapability", "TechnologyComponent", "TechnologyProduct"]
               }, {
               "name": "Data Catalogue",
               "data": ["DataSubject", "DataObject"]
               }, {
               "name": "Data Object Model",
               "data": ["DataObject", "DataObjectAttribute"]
               }, {
               "name": "Data Subject Summary",
               "data": ["DataSubject", "DataObject"]
               }, {
               "name": "Data Object Summary",
               "data": ["DataObject", "DataObjectAttribute"]
               }]};
                 
               $('#results').hide();
                
            </script>
            <script id="play-template" type="text/x-handlebars-template">
               <div class="pull-right lp-setup-legend">Click <i class="fa fa-rocket"></i> on required steps to set up Launchpad</div>
               <h3 class="text-primary">{{this.words}}</h3>
               <ul class="nav nav-pills">					
                  {{#each this.plays}}
                  <li><xsl:attribute name="class">{{#ifEquals @index 0}}active{{/ifEquals}}</xsl:attribute><a data-toggle="tab"><xsl:attribute name="href">#{{this.name}}</xsl:attribute>{{this.name}}</a></li>
                  {{/each}}
               </ul>								 
               
               <div class="tab-content">
                  {{#each this.plays}}
                  <div><xsl:attribute name="class">{{#ifEquals @index 0}}tab-pane fade in active{{else}}tab-pane fade{{/ifEquals}}</xsl:attribute><xsl:attribute name="id">{{this.name}}</xsl:attribute>
                     <div class="top-15">
                        <h4>{{this.name}} - {{this.description}}</h4>
                        <p class="small text-muted">For detailed information see <a target="_blank"><xsl:attribute name="href" >{{{this.link}}}</xsl:attribute>here</a></p> 
                        {{#each this.steps}}
                        <div class="playcard">
                           <div class="cardname">{{this.name}}<div class="pull-right launch"><xsl:attribute name="easid">{{../this.name}}{{#getCount @index}}{{/getCount}}</xsl:attribute><i class="fa fa-rocket" style="color:white"></i></div></div>
                           <div class="cardwhat">{{this.what}}</div>
                           <div class="cardusage">{{this.usage}}</div>
                           <div class="cardparties">{{this.parties}}<br/>
                              {{this.description}}</div>
                           <!--	
                                <div class="cardapps">
                                <ul>
                                {{#each this.data}}
                                <li>{{this.name}}:{{this.optional}} </li>
                                {{/each}}
                                </ul>	
                                </div>
                           -->
                        </div>
                        {{/each}}
                     </div>
                  </div>	
                  {{/each}}
               </div>
            </script>
            <script>
               var currentTab = 0; // Current tab is set to be the first tab (0)
               // Display the current tab
               var playTemplate, playFragment;
               var playlist={set:[{
               "name": "Play1",
               "description": "Anchor on Applications, Bring in Business Elements",
               "link": "https://enterprise-architecture.org/ea_play_1.php",			
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited",
               "data":[{"name":"Applications","Optional":"N"},
               {"name":"Application Services","Optional":"N"},
               {"name":"Organisations","Optional":"N"},
               {"name":"Application Services to Apps","Optional":"N"},
               {"name":"Applications to Org Users","Optional":"N"},
               {"name":"Sites","Optional":"Y"},
               {"name":"Organisation to Sites","Optional":"Y"}]		
               }, {
               "name": "A1.2",
               "what": "Create the application reference model and map applications",
               "usage": "Identify duplicate application candidates from an application perspective. Initial view, provides focus for the business work",
               "parties": "CIO",
               "description": "Interested, keen to discover more"
               }, {
               "name": "B1.1",
               "what": "Create the business capability model with the BA, validate with Executive",
               "usage": "Will be the anchor for application duplication from a business perspective",
               "parties": "Business",
               "description": "Interested"
               }, {
               "name": "B1.2",
               "what": "Identify the high-level processes and map applications that use them",
               "usage": "Enables identification of duplicate application candidates in the business.",
               "parties": "Business &amp; CIO",
               "description": "Interested, keen to discover more. Initiate cost review activities"
               }, {
               "name": "S1.5",
               "what": "Get costs for applications that are prime for review",
               "usage": "Use costs to identify which candidates are worth chasing",
               "parties": "Business &amp; CIO",
               "description": "Actively interested, want high-level business case"
               }, {
               "name": "A1.4",
               "what": "Identify inter-dependencies for applications that are prime for review",
               "usage": "Use complexity to gauge the work required in rationalising the candidate",
               "parties": "Business &amp; CIO",
               "description": "Actively Interested, want business case and action plan"
               }]
               }, {
               "name": "Play2", 	
               "description": "Anchor on Applications, Link to Technology, Bring in Business Elements", 	
               "link": "https://enterprise-architecture.org/ea_play_2.php",
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "A1.2",
               "what": "Create the application reference model and map applications",
               "usage": "Identify duplicate application candidates from an application perspective. Initial view, provides focus for the business work",
               "parties": "CIO",
               "description": "Interested, keen to discover more"
               }, {
               "name": "T1.1",
               "what": "Create the technology reference model",
               "usage": "Anchor for technology Products created",
               "parties": "CIO",
               "description": "Interested, but not excited"
               }, {
               "name": "T1.2",
               "what": "Capture the technology products against the reference model",
               "usage": "Identify duplicate and high risk technologies",
               "parties": "CIO",
               "description": "Initiates activities based on duplicate technology or risk"
               }, {
               "name": "T1.3",
               "what": "Create technology nodes , with locations and attach technology instances to them",
               "usage": "Get clarity on what technology nodes exist, where and what technology sits on them. See the implications of, for example, a failure, a data centre move or a cloud-first strategy",
               "parties": "CIO",
               "description": "Has clarity on what exists where. Keen to know impact of strategic infrastructure initiatives"
               }, {
               "name": "A1.3",
               "what": "Map technology components and products to Applications",
               "usage": "Use to identify application technology risk and non strategic technologies used by applications",
               "parties": "CIO",
               "description": "Realignment of the portfolio based on risk and strategy. Business risk discussions begin"
               }]
               }, {
               "name": "Play3", 	
               "description": "Build Simple Governance, Anchored Around Applications Then Technology", 	
               "link": "https://enterprise-architecture.org/ea_play_3.php",
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "S1.1",
               "what": "Define a set of achievable architecture principles to govern against",
               "usage": "Engage projects with the principles at start-up and decide architecture against the principles. Break the principles only where there is a compelling reason",
               "parties": "CIO",
               "description": "Interested, keen to know how the principles will help them achieve strategy. Projects Positive if the principles are reasonable"
               }, {
               "name": "S1.6",
               "what": "Create a governance process against which to maintain data in Essential and monitor alignment",
               "usage": "Use the process to engage projects, get data updates from projects and to review changes against the principles (standards can come later). Keep it light touch and initially let projects do some self governance.",
               "parties": "Projects",
               "description": "Participation, a good process should see active participation by projects"
               }, {
               "name": "S1.5",
               "what": "Capture costs against the applications in the architecture",
               "usage": "Costs will be key in starting to highlight high cost applications so rationalisation opportunities can be better identified and compelling business cases built",
               "parties": "CIO &amp; Business",
               "description": "Active interest, visibility of unnecessary cost always engages"
               }, {
               "name": "T1.1",
               "what": "Create the technology reference model",
               "usage": "Anchor for technology Products created",
               "parties": "CIO",
               "description": "Interested but not excited"
               }, {
               "name": "T1.2",
               "what": "Capture the technology products against the reference model",
               "usage": "Identify duplicate and high risk technologies",
               "parties": "CIO",
               "description": "Initiates activities based on duplicate technology or risk"
               }]
               }, {
               "name": "Play4", 	
               "description": "Anchor On Technology And Build The Architecture Out From There", 	
               "link": "https://enterprise-architecture.org/ea_play_4.php",
               "steps": [{
               "name": "T1.2",
               "what": "Capture the technology products in use",
               "usage": "Have a list of technology products",
               "parties": "CIO",
               "description": "Initiates activities based on duplicate technology or risk"
               }, {
               "name": "T1.1",
               "what": "Create the technology reference model and map to products",
               "usage": "Anchor for technology Products created Identify duplicate and high risk technologies",
               "parties": "CIO",
               "description": "Interested but not excited"
               }, {
               "name": "A1.1",
               "what": "Capture the applications with basic details &amp; services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "T1.3",
               "what": "Create technology nodes , with locations and attach technology instances to them",
               "usage": "Get clarity on what technology nodes exist, where and what technology sits on them. See the implications of, for example, a failure, a data centre move or a cloud-first strategy",
               "parties": "CIO",
               "description": "Has clarity on what exists where. Keen to know impact of strategic infrastructure initiatives"
               }, {
               "name": "B1.1",
               "what": "Create the business capability model with the BA, validate with Executive",
               "usage": "Will be the anchor for business duplication perspective",
               "parties": "Business",
               "description": "Interested"
               }, {
               "name": "B1.2",
               "what": "Identify the high-level processes and map applications that use them",
               "usage": "Enables identification of duplicate application candidates in the business",
               "parties": "Business &amp; CIO",
               "description": "Interested, keen to discover more. Initiate cost review activities"
               }]
               }, {
               "name": "Play5", 	
               "description": "Get Data In Shape", 	
               "link": "https://enterprise-architecture.org/ea_play_5.php",
               "steps": [{
               "name": "D1.1",
               "what": "Capture the Data Subjects and associated Data Objects with descriptions",
               "usage": "This becomes the common vocabulary for data so when people refer to data everyone has a consistent understanding.  This will be the anchor for identifying data duplication, inconsistencies, etc",
               "parties": "Project Teams",
               "description": "Interested but not excited"
               }, {
               "name": "D1.3",
               "what": "Identify the locations of the databases/data stores that contain the Data Object",
               "usage": "Understanding of where data stores are.  This can later be an anchor for identifying where sensitive data is stored and what it is being used for  (when we tie it to Applications and processes, e.g. for data privacy analysis)",
               "parties": "CIO",
               "description": "High-level visibility as to where data is"
               }, {
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Begin discussions on where data being mastered in multiple places"
               }]
               }, {
               "name": "Play6", 	
               "description": "Bring In Standards For Technology, Anchored Around Applications", 	
               "link": "https://enterprise-architecture.org/ea_play_6.php",
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "T1.1",
               "what": "Capture the technology products against the technology reference model",
               "usage": "Identify duplicate and high risk technologies",
               "parties": "CIO",
               "description": "Initiates activities based on duplicate technology or risk"
               }, {
               "name": "T1.2",
               "what": "Create the technology reference model",
               "usage": "Anchor for technology products created",
               "parties": "CIO",
               "description": "Interested but not excited"
               }, {
               "name": "S1.4",
               "what": "Define standards for your technologies and define lifecycle status for your technologies",
               "usage": "Anchor for Design Authority discussions, for projects to leverage in technical designs.",
               "parties": "CIO",
               "description": "Keen on convergence on the standards, will want a plan"
               }, {
               "name": "A1.3",
               "what": "Map the technologies to the applications using them",
               "usage": "Provides a view on application alignment to standards and also can be used to highlight technology risk",
               "parties": "CIO",
               "description": "Very interested as risk can be seen. Will want plans for ‘at risk’ applications or those using non-standard technology"
               }]
               }, {
               "name": "Play7", 	
               "description": "Map Applications To Projects For Impact Analysis", 	
               "link": "https://enterprise-architecture.org/ea_play_7.php",
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "S1.2",
               "what": "Define strategic plans and the applications they impact",
               "usage": "See strategic plans applications implementing them",
               "parties": "Business &amp; IT",
               "description": "Interested in what is changing"
               }, {
               "name": "S1.3",
               "what": "Create the projects that will implement the strategic plans",
               "usage": "See Projects delivering the strategic plans",
               "parties": "CIO",
               "description": "Visibility of the change portfolio"
               }]
               }, {
               "name": "Play8", 	
               "description": "Create Your Roadmaps", 	
               "link": "https://enterprise-architecture.org/ea_play_8.php",
               "steps": [{
               "name": "A1.1",
               "what": "Capture the applications with basic details and services",
               "usage": "Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties": "Business &amp; IT",
               "description": "Interested but not excited"
               }, {
               "name": "T1.2",
               "what": "Capture the technology products",
               "usage": "Have a list of technology products, ideally you would do T1.1 at the same time",
               "parties": "CIO",
               "description": "Interested but not excited"
               }, {
               "name": "B1.1",
               "what": "Create the business capability model with the BA, validate with Executive",
               "usage": "Will be the anchor for application duplication from a business perspective",
               "parties": "Business",
               "description": "Interested but not excited"
               }, {
               "name": "B1.2",
               "what": "Identify the high-level processes and map applications that use them",
               "usage": "Enables identification of duplicate application candidates in the business.",
               "parties": "Business &amp; CIO",
               "description": "Interested, keen to discover more."
               }, {
               "name": "S1.2",
               "what": "Define strategic plans and the applications they impact",
               "usage": "See strategic plans applications implementing them",
               "parties": "Business &amp; IT",
               "description": "Interested in what is changing"
               }, {
               "name": "A1.3",
               "what": "Create the projects that will implement the strategic plans",
               "usage": "See Projects delivering the strategic plans",
               "parties": "CIO",
               "description": "Visibility of the change portfolio"
               }]
               }]};	

var viewsList=[
	{
      "id":"busCapDash",
      "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck','orgsCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','apps2orgsCheck','physProc2AppVsCheck','physProc2AppCheck']
     },
   {
      "id":"appRefModel",
      "sheets":['apps2svcsCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck']
   },
   {
      "id":"techRef",
      "sheets":['techDomsCheck', 'techCapsCheck','techCompsCheck','techProductsCheck','techProducttoOrgsCheck','orgsCheck']
   },
   {
      "id":"itAsset",
      "sheets":['busDomWorksheetCheck','busCapsWorksheetCheck','busProcsWorksheetCheck','orgsCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','apps2orgsCheck','physProc2AppVsCheck','physProc2AppCheck','appCaps2SvcsCheck','appCapsCheck','techDomsCheck', 'techCapsCheck','techCompsCheck','techProductsCheck','techProducttoOrgsCheck', 'sitesCheck', 'orgs2sitesCheck']
   },
   {
      "id":"domi",
      "sheets":['dataObjectCheck','dataObjectInheritCheck','dataObjectAttributeCheck']
   },
   {
      "id":"afoot",
      "sheets":['apps2svcsCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck', 'orgsCheck','apps2orgsCheck']
   },
   {"id":"appStratTech",
   "sheets":['appsCheck','techCapsCheck','techCompsCheck','techProductsCheck','apptotechCheck','apps2svcsCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck','nodesCheck', 'apps2serverCheck', 'techSuppliersCheck',  'apptotechCheck']
   },
   {"id":"adai",
      "sheets":[ ]
   },
   {"id":"ari",
   "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','physProc2AppVsCheck','physProc2AppCheck']              
   },
   {"id":"adepsi",
   "sheets":['appsCheck','appDependencyCheck', 'infoExchangedCheck']
   },
   {"id":"arai",
   "sheets":['appsCheck','appSvcsCheck', 'apps2svcsCheck']
   },
   {"id":"bditi",
   "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','physProc2AppVsCheck','physProc2AppCheck','nodesCheck', 'apps2serverCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck','busDomWorksheetCheck','techSuppliersCheck','techCompsCheck','techProductsCheck','apptotechCheck','techCapsCheck','busProc2SvcsCheck']
   },
   {"id":"bdpai",
   "sheets":['busCapsWorksheetCheck','busDomWorksheetCheck','busProcsWorksheetCheck', 'appSvcsCheck','busProc2SvcsCheck', 'appsCheck', 'apps2svcsCheck','physProc2AppVsCheck','physProc2AppCheck','nodesCheck', 'apps2serverCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck','techSuppliersCheck','techCompsCheck','techProductsCheck','apptotechCheck','techCapsCheck']             
   }	
   ]               



          
   $(document).ready(function() {

            $('.custom-select').select2({width:'250px'})
         
         console.log('playlist');
         console.log(playlist);	
         
         playFragment = $("#play-template").html();
         var playTemplate = Handlebars.compile(playFragment);
         
         Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
         return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
         });
         Handlebars.registerHelper('getCount', function(arg1, options) {
         return (arg1 + 1);
         });			
         
         
         $('#submit').click(function() { 
         //sendFacts();
         let ruleSetName = "newRules";
         let facts = {
         "managementEngagement": $('#engaged').val(),
         "keyDriver": $('#driver').val(),
         "busRelationship": $('#interest').val(),
         "itEngagement": $('#itinterest').val(),
         "maturity": $('#maturity').val(),
         "capabilityModel": $('#buscap').val(),
         "processDocument": $('#busproc').val(),
         "appList": $('#apps').val(),
         "costAccess": $('#costaccess').val(),
         "technologyList": $('#techlist').val(),
         "techCosts": $('#techcostaccess').val(),
         "vendorDates": $('#vendlife').val(),
         "techStandards": $('#standards').val(),
         "strategicPlans": $('#plans').val(),
         "projectPortfolio": $('#projects').val(),
         "projectInformation": "Y",
         "credibility": $('#credibility').val()
         }

    let managementEngagement = $('#engaged option:selected').attr('essValue');
    let keyDriver = $('#driver option:selected').attr('essValue');
    let busRelationship = $('#interest option:selected').attr('essValue');
    let itEngagement = $('#itinterest option:selected').attr('essValue');
    let maturity = $('#maturity option:selected').attr('essValue');
    let capabilityModel = $('#buscap option:selected').attr('essValue');
    let processDocument = $('#busproc option:selected').attr('essValue');
    let appList = $('#apps option:selected').attr('essValue');
    let costAccess = $('#costaccess option:selected').attr('essValue');
    let technologyList = $('#techlist option:selected').attr('essValue');
    let techCosts = $('#techcostaccess option:selected').attr('essValue');
    let vendorDates = $('#vendlife option:selected').attr('essValue');
    let techStandards = $('#standards option:selected').attr('essValue');
    let strategicPlans = $('#plans option:selected').attr('essValue');
    let projectPortfolio = $('#projects option:selected').attr('essValue');
    let credibility = $('#credibility option:selected').val(); // Assuming this is also a select element
   
   let projectInformation="Y"; 

   let questionforAI = `Based on these responses from an enterprise architecture (EA) questionnaire, can you analyze and identify key opportunities for improvement within our organization, provide a rationale for each opportunity based on the questionnaire responses, suggest strategies for how we can achieve these opportunities, and explain how the Essential EA management tool can facilitate in realizing these improvements? Responses: What is the level of engagement of management? ${managementEngagement} What is the key driver for EA currently? ${keyDriver} Do you have a good working relationship with the business, i.e., people who you can work with to deliver elements of the EA? ${busRelationship} Do you have good engagement within IT, some skepticism or a bit of both? ${itEngagement} How would you describe your maturity? ${maturity} Do you have a business capability model defined? ${capabilityModel} Do you have business processes defined and linked to applications? ${processDocument} Do you have a list of applications? ${appList} Do you have access to application costs? ${costAccess} Do you have a list of technologies used? ${technologyList} Do you have access to technology costs? ${techCosts} Do you have access to vendor technology Lifecycles? ${vendorDates} Do you have standards defined? ${techStandards} Do you have strategic plans/roadmaps defined? ${strategicPlans} Do you have a project portfolio? ${projectPortfolio} What is the current credibility of EA in the organisation? ${credibility}. Provide the response in a JSON structure, be verbose in the strategy and how. You must use this JSON structure [{"OpportunityName": "A", "rationale": "X", "strategy": "Y", "essentialUse": "Z"},...]`;

   console.log('facts', facts);
   console.log('questionforA', questionforAI);
   let eaRecommended;

   showEditorSpinner('Preparing advice')
   essPromise_askChatQuestion(questionforAI).then(function(chatResponse){
      let chatResponseJSON =chatResponse.content;

      console.log('chatResponseJSON',chatResponseJSON)
      console.log('chatResponseJSON',JSON.parse(chatResponseJSON))
      removeEditorSpinner()
      $("#adviceBox").html(answerTemplate(JSON.parse(chatResponseJSON)))
   }) 
         
   essPromise_createAdviceFromRules(ruleSetName, facts)
      .then(function(response) {
               console.log('rules response', response);
               
               // run response to sending facts
               let dataSet=[];
               let plays=[];
               
               response.forEach(function(d){
               var playPick = playlist.set.filter(function(e){
               return e.name ==d.params.data;
               });
               plays.push(playPick[0]);
               });
               
               if(plays.length ==0){
               plays.push(playlist.set[0])
               }
               
               console.log('plays', plays)
               var wording;
               if(plays.length &gt;1)
               {
               wording='Based on your responses, there are '+plays.length+' plays that are recommended for you...'
               }
               else
               {
               wording='We recommend you start with this play.'
               };
               dataSet['words']=wording;
               dataSet['plays']=plays;
               
               $('#playResults').empty();
               $('#playResults').append(playTemplate(dataSet));
               $('#results').show();
               
                $('.launch').click(function(){
                let step= $(this).attr('easid');
                $(this).children().css("color","rgb(0,255,0)");
                $('#'+step.toLowerCase()).trigger('click');
                });
            });
           
       });
               
    });
               
               function runSubmit() {
               console.log('Submitted');
               // sendFacts();
               }
                  
               function sendFacts() {
               
            
               };    
               
            </script>
            
            <!-- Playbook code from here -->				
            <script>
               
               
               
function setBox(tick,list){
               
               if (tick == false) {
                  playUnselect(list)
                  }
                  else {
                  playSelect(list)
                  }
                  
               }
               
               $("#play11").on("change", function(){
               var thisList=['appcat']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play12").on("change", function(){
               var thisList=['appRefModel']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play13").on("change", function(){
               var thisList=['bcmi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play14").on("change", function(){
               var thisList=['bdpai']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play16").on("change", function(){
               var thisList=['adepsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play21").on("change", function(){
               var thisList=['appcat']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play22").on("change", function(){
               var thisList=['appRefModel']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               $("#play23").on("change", function(){
               var thisList=['techRef']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play24").on("change", function(){
               var thisList=['techcat']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });

               $("#play25").on("change", function(){
               var thisList=['appcat'] //app tech prod
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play26").on("change", function(){
               var thisList=['bcmi']  //app tech strategy
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               $("#play27").on("change", function(){
               var thisList=['busProcSumm']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play31").on("change", function(){
               var thisList=['asumi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
                           
               $("#play35").on("change", function(){
               var thisList=['techRef']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play36").on("change", function(){
               var thisList=['tpsi']
               playSelect(thisList)
               });
               
               $("#play42").on("change", function(){
               var thisList=['techRef']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play41").on("change", function(){
               var thisList=['tpsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play43").on("change", function(){
               var thisList=['asumi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play44").on("change", function(){
               var thisList=['tnsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play45").on("change", function(){
               var thisList=['bcmi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
                      
               $("#play46").on("change", function(){
               var thisList=['busProcSumm']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play51").on("change", function(){
               var thisList=['dosi','dssi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play53").on("change", function(){
               var thisList=['asumi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play62").on("change", function(){
               var thisList=['techRef']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               
               });
               
               $("#play63").on("change", function(){
               var thisList=['tpsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play61").on("change", function(){
               var thisList=['asumi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play65").on("change", function(){
               var thisList=['tpsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play65").on("change", function(){
               var thisList=['appStratTech']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });             
               
               $("#play71").on("change", function(){
               var thisList=['asumi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               $("#play81").on("change", function(){
                  var thisList=['asumi']
                  var boxState = $(this).prop("checked");
                  setBox(boxState,thisList)
               });

               $("#play82").on("change", function(){
               var thisList=['tpsi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });

               $("#play83").on("change", function(){
               var thisList=['bcmi']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               $("#play84").on("change", function(){
               var thisList=['busProcSumm']
               var boxState = $(this).prop("checked");
               setBox(boxState,thisList)
               });
               
               function playSelect(list){
                  list.forEach(function(d){
                  $('#'+d).prop('checked', true )
                  $('#'+d).trigger("change");
                  })
               }
               
               function playUnselect(list){
               list.forEach(function(d){
               $('#'+d).prop('checked', false )
               $('#'+d).trigger("change");
               })
               }
               
               /*
               var sheets=[{'name':'busCap','count':0, 'sheet':'busCapsWorksheetCheck'},
               {'name':'busDomain','count':0, 'sheet':'busDomWorksheetCheck'},
               {'name':'busProcess','count':0, 'sheet':'busProcsWorksheetCheck'},
               {'name':'busProcessf','count':0, 'sheet':'busProcsFamilyWorksheetCheck'},
               {'name':'site','count':0, 'sheet':'sitesCheck'}, 
               {'name':'org','count':0, 'sheet':'orgsCheck'},
               {'name':'org2site','count':0, 'sheet':'orgs2sitesCheck'},
               {'name':'appCapability','count':0, 'sheet':'appCapsCheck'},
               {'name':'appService','count':0, 'sheet':'appSvcsCheck'},
               {'name':'appCaps2SvcsCheck','count':0, 'sheet':'appCaps2SvcsCheck'},
               {'name':'app','count':0, 'sheet':'appsCheck'}, 
               {'name':'app2service','count':0, 'sheet':'apps2svcsCheck'},
               {'name':'app2org','count':0, 'sheet':'apps2orgsCheck'},
               {'name':'busProcess2appService','count':0, 'sheet':'busProc2SvcsCheck'},
               {'name':'pp2appService','count':0, 'sheet':'physProc2AppVsCheck'}, 
               {'name':'physicalprocess2app','count':0, 'sheet':'physProc2AppCheck'},
               {'name':'infoExchange','count':0, 'sheet':'infoExchangedCheck'},
               {'name':'serv','count':0, 'sheet':'nodesCheck'},
               {'name':'app2server','count':0, 'sheet':'apps2serverCheck'},  
               {'name':'techDoms','count':0, 'sheet':'techDomsCheck'},
               {'name':'techCaps','count':0, 'sheet':'techCapsCheck'},
               {'name':'techComp','count':0, 'sheet':'techCompsCheck'},
               {'name':'techSuppliers','count':0, 'sheet':'techSuppliersCheck'},
               {'name':'techProducts','count':0, 'sheet':'techProductsCheck'},
               {'name':'techProductsFamily','count':0, 'sheet':'techProductFamiliesCheck'},
               {'name':'techProductsOrg','count':0, 'sheet':'techProducttoOrgsCheck'},
               {'name':'dataSubject','count':0, 'sheet':'dataSubjectCheck'},
               {'name':'dataObject','count':0, 'sheet':'dataObjectCheck'},
               {'name':'dataObjecti','count':0, 'sheet':'dataObjectInheritCheck'},
               {'name':'dataObjecta','count':0, 'sheet':'dataObjectAttributeCheck'},
               {'name':'appDependency','count':0, 'sheet':'appDependencyCheck'},
               {'name':'app2techProducts','count':0, 'sheet':'apptotechCheck'}]
               */
               
               function setCounts(tick,list){
                  if (tick == false) {
                  reduceNumbers(list)
                  }
                  else {
                  increaseNumbers(list)
                  }
               }	
        
activeViewArray=[];               
$('.views').on('change', function(){
  
   setting=$(this).prop('checked');

   let selected=viewsList.find((e)=>{
      return e.id==$(this).attr('id');
   })
   if(setting==true){
      activeViewArray=[...activeViewArray, ...selected.sheets]
   }else{
      selected.sheets.forEach(sheetId => {
         console.log('si', sheetId)
            let index = activeViewArray.indexOf(sheetId);
            if (index !== -1) {
                activeViewArray.splice(index, 1); // Remove only the first occurrence
            }
        });
   }
   let uniqueArray = [...new Set(activeViewArray)]; 
console.log('uniqueArray',uniqueArray)
   $('.sheet').prop('checked', false);
   uniqueArray.forEach((c)=>{
      console.log('c', c)
    $('#' + c).prop('checked', true).trigger('change');
   })
})
               
               function reduceNumbers(focussheet){
                  focussheet.forEach(function(v){
                     sheets.forEach(function(d){
                        if(d.name==v){
                        if(d.count&gt;0){
                        d.count=d.count-1;
                        }
                     }
                  });
                  })
               }	
               
               function increaseNumbers(focussheet){
               focussheet.forEach(function(v){
               sheets.forEach(function(d){
               if(d.name==v){
               d.count=d.count+1;
               }
               });
               })
               }
               
               function setSheets(){
               sheets.forEach(function(d){
               sheetName=d.sheet;
               if(d.count &gt;0){
               $('#'+sheetName).prop('checked', true )
               $('#'+sheetName).trigger("change");
               }
               else{
               $('#'+sheetName).prop('checked', false )
               $('#'+sheetName).trigger("change");
               }
               })
               }	
               
               $("#bcmi").on("change", function()
               {var arr=['busDomain','busCap'];	
               var boxState = $(this).prop("checked");
               setCounts(boxState,arr);
               setSheets();
               })
               
               
            </script>			
            <script id="slot-template" type="text/x-handlebars-template">
	<table id="slotTable" class="table table-striped table-condensed">
		<thead>
			<tr><th style="width:100px">Slot</th><th>Description</th></tr>
		</thead>
		<tbody>
		{{#each this.slots}}
			<tr><td><b>{{this.name}}</b></td><td><i>{{this.description}}</i></td></tr>
		{{/each}}
		</tbody>
		<tfoot>
			<tr><th>Slot</th><th>Description</th></tr>
		</tfoot>
	</table>

</script>		
<script> 	

function showEditorSpinner(message){
    $('#editor-spinner-text').text(message);                             
    $('#editor-spinner').removeClass('hidden');
}
 
function removeEditorSpinner(){
    $('#editor-spinner').addClass('hidden'); 
    $('#editor-spinner-text').text(''); 
}
var dataRows = {"sheets": []};           
    $('document').ready(function () {
      $('.edit').click(function(){
      $(this).parent().parent().find('.playSteps').slideToggle();
      $(this).toggleClass('fa-caret-right');
      $(this).toggleClass('fa-caret-down');
   });

var answerFragment   = $("#answer-page").html();
answerTemplate = Handlebars.compile(answerFragment);     

var sitetableFragment   = $("#sites-name").html();
   sitetableTemplate = Handlebars.compile(sitetableFragment);
      
var buscaptableFragment   = $("#captable-name").html();
   buscaptableTemplate = Handlebars.compile(buscaptableFragment);
      
var busdomtableFragment   = $("#domtable-name").html();
   busdomtableTemplate = Handlebars.compile(busdomtableFragment);		
      
var busprocesstableFragment   = $("#processtable-name").html();
   busprocesstableTemplate = Handlebars.compile(busprocesstableFragment);	
      
var busprocessfamilytableFragment   = $("#processfamilytable-name").html();
   busprocessfamilytableTemplate = Handlebars.compile(busprocessfamilytableFragment);
      
var orgtableFragment   = $("#orgs-name").html();
   orgtableTemplate = Handlebars.compile(orgtableFragment);
      
      
var orgsitetableFragment   = $("#orgsite-name").html();
   orgsitetableTemplate = Handlebars.compile(orgsitetableFragment);
      
var appCaptableFragment   = $("#appcap-name").html();
   appCaptableTemplate = Handlebars.compile(appCaptableFragment);
      
var appSvctableFragment   = $("#appsvc-name").html();
   appSvctableTemplate = Handlebars.compile(appSvctableFragment);
      
var appCap2SvctableFragment   = $("#appcapsvc-name").html();
   appCap2SvctableTemplate = Handlebars.compile(appCap2SvctableFragment);
      
var appstableFragment   = $("#apps-name").html();
   appstableTemplate = Handlebars.compile(appstableFragment);
      
var app2svcstableFragment   = $("#app2svc-name").html();
   apps2svcstableTemplate = Handlebars.compile(app2svcstableFragment);
      
var app2orgstableFragment   = $("#app2org-name").html();
   apps2orgtableTemplate = Handlebars.compile(app2orgstableFragment);
      
var pp2apptableFragment   = $("#pp2app-name").html();
   pp2apptableTemplate = Handlebars.compile(pp2apptableFragment);
      
var pp2appviasvctableFragment   = $("#pp2appviasvc-name").html();
   pp2appviasvctableTemplate = Handlebars.compile(pp2appviasvctableFragment);
      
var bp2appsvctableFragment   = $("#bp2appsvc-name").html();
   bp2appsvctableTemplate = Handlebars.compile(bp2appsvctableFragment);	
      
var infoReptableFragment   = $("#inforeps-name").html();
   infoReptableTemplate = Handlebars.compile(infoReptableFragment);	
      
var serverstableFragment   = $("#servers-name").html();
   serverstableTemplate = Handlebars.compile(serverstableFragment);		
      
var app2servertableFragment   = $("#app2server-name").html();
   app2servertableTemplate = Handlebars.compile(app2servertableFragment);	
      
var techdomstableFragment   = $("#techdoms-name").html();
   techdomstableTemplate = Handlebars.compile(techdomstableFragment);	
      
var techcapstableFragment   = $("#techcaps-name").html();
   techcapstableTemplate = Handlebars.compile(techcapstableFragment);	
      
var techcompstableFragment   = $("#techcomps-name").html();
   techcompstableTemplate = Handlebars.compile(techcompstableFragment);	
      
var techproductstableFragment   = $("#techprods-name").html();
   techproductstableTemplate = Handlebars.compile(techproductstableFragment);   
      
var techsuppliertableFragment   = $("#techsuppliers-name").html();
   techsuppliertableTemplate = Handlebars.compile(techsuppliertableFragment);   
      
var techproductfamilytableFragment   = $("#techprodfamily-name").html();
   techproductfamilytableTemplate = Handlebars.compile(techproductfamilytableFragment);  
      
var techproductorgtableFragment   = $("#techprodorg-name").html();
   techproductorgtableTemplate = Handlebars.compile(techproductorgtableFragment); 
      
var dataSubjecttableFragment   = $("#datasubject-name").html();
   dataSubjecttableTemplate = Handlebars.compile(dataSubjecttableFragment); 
      
var dataObjecttableFragment   = $("#dataobject-name").html();
   dataObjecttableTemplate = Handlebars.compile(dataObjecttableFragment); 
      
var dataObjectinheritFragment   = $("#dataobjectinherit-name").html();
   dataObjectinheritTemplate = Handlebars.compile(dataObjectinheritFragment); 	
      
var dataObjectattributeFragment   = $("#dataobjectattribute-name").html();
   dataObjectattributeTemplate = Handlebars.compile(dataObjectattributeFragment); 	
      
var appDependencyFragment   = $("#appdependency-name").html();
   appDependencyTemplate = Handlebars.compile(appDependencyFragment); 
      
var appToTechFragment   = $("#apptotechprod-name").html();
   appToTechTemplate = Handlebars.compile(appToTechFragment); 
       
Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) { 
      return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
      });

Handlebars.registerHelper('escaper', function(words) {		 
	return words.replace(/\n/g, "\\n").replace(/\r/g, "\\n");
});   
         
Handlebars.registerHelper('greaterThan', function (v1, v2, options) {
      'use strict';
      if (v1>v2) {
      return options.fn(this);
      }
      return options.inverse(this);
      });
         
});
         
   </script>
		
            <script id="answer-page" type="text/x-handlebars-template">
                {{#each this}}
                    <h3>{{OpportunityName}}</h3>
                    <p>
                    <b>Rationale</b>: {{rationale}}
                    </p>
                    <p>
                    <b>Strategy</b>: {{strategy}}
                    </p>
                    <p>
                    <b>Essential</b>: {{essentialUse}}
                    </p>

                {{/each}}
            </script>
            <script src="enterprise/js/getSheetData.js"/>
            <script src="integration/js/easxlsjs.js"/>
         </body>
         <script>
            <xsl:call-template name="RenderViewerAPIJSFunction">
               <xsl:with-param name="viewerAPIPath" select="$apiPathBusinessCaps"/>
               <xsl:with-param name="viewerAPIPathBD" select="$apiPathBusinessDomains"/>
               <xsl:with-param name="viewerAPIPathBP" select="$apiPathBusinessProcesses"/>
               <xsl:with-param name="viewerAPIPathBPF" select="$apiPathBusinessProcessFamilies"/>
               <xsl:with-param name="viewerAPIPathSites" select="$apiPathSites"/>
               <xsl:with-param name="viewerAPIPathOrgs" select="$apiPathOrgs"/>
               <xsl:with-param name="viewerAPIPathAppCaps" select="$apiPathAppCaps"/>
               <xsl:with-param name="viewerAPIPathAppSvcs" select="$apiPathAppSvcs"/>
               <xsl:with-param name="viewerAPIPathAppCap2Svcs" select="$apiPathAppCap2Svcs"/>
               <xsl:with-param name="viewerAPIPathApps" select="$apiPathApps"/>
               <xsl:with-param name="viewerAPIPathApp2Svcs" select="$apiPathApp2Svcs"/>
               <xsl:with-param name="viewerAPIPathApp2orgs" select="$apiPathApp2orgs"/>
               <xsl:with-param name="viewerAPIPathBPtoAppsSvc" select="$apiPathBPtoAppsSvc"/>
               <xsl:with-param name="viewerAPIPathPPtoAppsViaSvc" select="$apiPathPPtoAppsViaSvc"/>
               <xsl:with-param name="viewerAPIPathPPtoApps" select="$apiPathPPtoApps"/>
               <xsl:with-param name="viewerAPIPathInfoRep" select="$apiPathInfoRep"/>
               <xsl:with-param name="viewerAPIPathTechCap" select="$apiPathTechCap"/>
               <xsl:with-param name="viewerAPIPathTechDomains" select="$apiPathTechDomains"/>
               <xsl:with-param name="viewerAPIPathApptoServer" select="$apiPathApptoServer"/>
               <xsl:with-param name="viewerAPIPathNodes" select="$apiPathNodes"/>
               <xsl:with-param name="viewerAPIPathTechComp" select="$apiPathTechComp"/>
               <xsl:with-param name="viewerAPIPathTechSupplier" select="$apiPathTechSupplier"/>
               <xsl:with-param name="viewerAPIPathTechProd" select="$apiPathTechProd"/> 
               <xsl:with-param name="viewerAPIPathTechProdOrg" select="$apiPathTechProdOrg"/> 
               <xsl:with-param name="viewerAPIPathTechProdFamily" select="$apiPathTechProdFamily"/> 
               <xsl:with-param name="viewerAPIPathDataSubject" select="$apiPathDataSubject"/> 
               <xsl:with-param name="viewerAPIPathDataObject" select="$apiPathDataObject"/> 
               <xsl:with-param name="viewerAPIPathDataObjectAttributes" select="$apiPathDataObjectAttributes"/> 
               <xsl:with-param name="viewerAPIPathDataObjectInherit" select="$apiPathDataObjectInherit"/> 
               <xsl:with-param name="viewerAPIPathAppDependency" select="$apiPathDataAppDependency"/>  
               <xsl:with-param name="viewerAPIPathApptoTech" select="$apiPathDataApptoTech"/> 
               
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
      <xsl:param name="viewerAPIPath"/>
      <xsl:param name="viewerAPIPathBD"/>
      <xsl:param name="viewerAPIPathBP"/> 
      <xsl:param name="viewerAPIPathBPF"/>
      <xsl:param name="viewerAPIPathSites"/>
      <xsl:param name="viewerAPIPathOrgs"/> 
      <xsl:param name="viewerAPIPathAppCaps"/> 
      <xsl:param name="viewerAPIPathAppSvcs"/> 
      <xsl:param name="viewerAPIPathAppCap2Svcs"/>  
      <xsl:param name="viewerAPIPathApps"/> 
      <xsl:param name="viewerAPIPathApp2Svcs"/> 
      <xsl:param name="viewerAPIPathApp2orgs"/> 
      <xsl:param name="viewerAPIPathBPtoAppsSvc"/> 
      <xsl:param name="viewerAPIPathPPtoAppsViaSvc"/> 
      <xsl:param name="viewerAPIPathPPtoApps"/>
      <xsl:param name="viewerAPIPathInfoRep"/>
      <xsl:param name="viewerAPIPathTechCap"/>
      <xsl:param name="viewerAPIPathTechDomains"/>
      <xsl:param name="viewerAPIPathApptoServer"/>
      <xsl:param name="viewerAPIPathNodes"/>
      <xsl:param name="viewerAPIPathTechComp"/>
      <xsl:param name="viewerAPIPathTechSupplier"/>
      <xsl:param name="viewerAPIPathTechProd"/>
      <xsl:param name="viewerAPIPathTechProdOrg"/>
      <xsl:param name="viewerAPIPathTechProdFamily"/>
      <xsl:param name="viewerAPIPathDataObject"/>
      <xsl:param name="viewerAPIPathDataSubject"/> 
      <xsl:param name="viewerAPIPathDataObjectInherit"/> 
      <xsl:param name="viewerAPIPathDataObjectAttributes"/> 
      <xsl:param name="viewerAPIPathAppDependency"/> 
      <xsl:param name="viewerAPIPathApptoTech"/>
      var allIndividuals = [<xsl:apply-templates select="$allIndividuals" mode="dataLookup"/>]
		var busCapPosition=[{"id":"M" , "name":"Manage"}, {"id":"M" , "name":"Front"}, {"id":"M" , "name":"Back"}];
		var appCategory=[{"id":"M" , "name":"Management"}, {"id":"C" , "name":"Core"}, {"id":"S" , "name":"Shared"}, {"id":"E" , "name":"Enabling"}];
		var appRefModelLayer=[{"id":"M" , "name":"Middle"}, {"id":"L" , "name":"Left"},{"id":"R" , "name":"Right"}]
		var techRefModelLayer=[{"id":"T" , "name":"Top"}, {"id":"M" , "name":"Middle"}, {"id":"L" , "name":"Left"},{"id":"R" , "name":"Right"},{"id":"B" , "name":"Bottom"}];
		var isAbstract=[{"id":"T" , "name":"true"}, {"id":"F" , "name":"false"}]
		var allCodebase = [<xsl:apply-templates select="$codebase" mode="dataLookup"/>]
		var allEnvironment = [<xsl:apply-templates select="$environment" mode="dataLookup"/>]
		var allDelivery = [<xsl:apply-templates select="$delivery" mode="dataLookup"/>]
		var allLifecycle = [<xsl:apply-templates select="$lifecycle" mode="dataLookup"/>]
		var allCriticality = [<xsl:apply-templates select="$criticality" mode="dataLookup"/>]
		var allTechLifecycle = [<xsl:apply-templates select="$techlifecycle" mode="dataLookup"/>]
		var allTechDelivery = [<xsl:apply-templates select="$techdelivery" mode="dataLookup"/>]
		var allStandardStrengths =[<xsl:apply-templates select="$stdStrengths" mode="dataLookup"/>]
		var allDataCategory=[<xsl:apply-templates select="$dataCategory" mode="dataLookup"/>]
		var allDataCardinaility=[<xsl:apply-templates select="$dataAttrCard" mode="dataLookup"/>]
		var allDataPrimitives=[<xsl:apply-templates select="$primitiveDO" mode="dataLookup"/>]
		var allTimeliness=[<xsl:apply-templates select="$timeliness" mode="dataLookup"/>]
		var allAcqMeth=[<xsl:apply-templates select="$acqMethod" mode="dataLookup"/>]

      var switchedOn=[];
      
      //a global variable that holds the data returned by an Viewer API Report
      var viewCheck = 'report?XML=reportXML.xml&amp;XSL=&amp;cl=en-gb'; 
      var viewAPIDataBusCaps = '<xsl:value-of select="$viewerAPIPath"/>';
      var viewAPIDataBusDoms = '<xsl:value-of select="$viewerAPIPathBD"/>';
      var viewAPIDataBusProcs = '<xsl:value-of select="$viewerAPIPathBP"/>'; 
      var viewAPIDataBusProcFams = '<xsl:value-of select="$viewerAPIPathBPF"/>'; 
      var viewAPIDataSites = '<xsl:value-of select="$viewerAPIPathSites"/>'; 	
      var viewAPIDataOrgs = '<xsl:value-of select="$viewerAPIPathOrgs"/>'; 	
      var viewAPIDataAppCaps ='<xsl:value-of select="$viewerAPIPathAppCaps"/>';
      var viewAPIDataAppSvcs ='<xsl:value-of select="$viewerAPIPathAppSvcs"/>'; 
      var viewAPIDataAppCap2Svcs ='<xsl:value-of select="$viewerAPIPathAppCap2Svcs"/>';
      var viewAPIDataApps ='<xsl:value-of select="$viewerAPIPathApps"/>';  
      var viewAPIDataApps2Svcs ='<xsl:value-of select="$viewerAPIPathApp2Svcs"/>'; 
      var viewAPIDataApps2orgs ='<xsl:value-of select="$viewerAPIPathApp2orgs"/>'; 
      var viewAPIDataBPtoAppsSvc ='<xsl:value-of select="$viewerAPIPathBPtoAppsSvc"/>'; 
      var viewAPIDataPPtoAppsViaSvc ='<xsl:value-of select="$viewerAPIPathPPtoAppsViaSvc"/>'; 
      var viewAPIDataPPtoApps ='<xsl:value-of select="$viewerAPIPathPPtoApps"/>'; 
      var viewAPIDataInfoRep ='<xsl:value-of select="$viewerAPIPathInfoRep"/>'; 
      var viewAPIDataTechCap ='<xsl:value-of select="$viewerAPIPathTechCap"/>'; 
      var viewAPIDataTechDomains ='<xsl:value-of select="$viewerAPIPathTechDomains"/>'; 
      var viewAPIDataApptoServer ='<xsl:value-of select="$viewerAPIPathApptoServer"/>'; 
      var viewAPIDataNodes ='<xsl:value-of select="$viewerAPIPathNodes"/>';          
      var viewAPIDataTechComp ='<xsl:value-of select="$viewerAPIPathTechComp"/>';   
      var viewAPIDataTechSupplier ='<xsl:value-of select="$viewerAPIPathTechSupplier"/>';   
      var viewAPIDataTechProd ='<xsl:value-of select="$viewerAPIPathTechProd"/>';
      var viewAPIDataTechProdOrg ='<xsl:value-of select="$viewerAPIPathTechProdOrg"/>';
      var viewAPIDataDataSubject ='<xsl:value-of select="$viewerAPIPathDataSubject"/>';
      var viewAPIDataDataObject ='<xsl:value-of select="$viewerAPIPathDataObject"/>'; 
      var viewAPIDataDataObjectInherit ='<xsl:value-of select="$viewerAPIPathDataObjectInherit"/>'; 
      var viewAPIDataDataObjectAttribute ='<xsl:value-of select="$viewerAPIPathDataObjectAttributes"/>'; 
      var viewAPIDataTechProdFamily = '<xsl:value-of select="$viewerAPIPathTechProdFamily"/>' 
      var viewAPIDataAppDependency ='<xsl:value-of select="$viewerAPIPathAppDependency"/>'  
      var viewAPIPathApptoTech ='<xsl:value-of select="$viewerAPIPathApptoTech"/>'    
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
      
      
      


      function createWorkbookFromJSON() {
		var workbook = new ExcelJS.Workbook();
	  
		console.log('dataRows', dataRows);
      console.log('switchedOn',switchedOn)
      var uncheckedIds = $('input[type="checkbox"]:not(:checked)').map(function() {
        return this.id;
    }).toArray();

    console.log(uncheckedIds);
    let filteredElements = dataRows.sheets.filter(element => !uncheckedIds.includes(element.id));

console.log(filteredElements)
		// Gather values for the dropdown lists
		let dropdownValues = {};
		dataRows.sheets.forEach(sheet => {
		  dropdownValues[sheet.name] = {};
		  sheet.lookup?.forEach(lookup => {
			dropdownValues[sheet.name][lookup.column] = new Set();
			sheet.data.forEach(rowData => {
			  dropdownValues[sheet.name][lookup.column].add(rowData[lookup.values]);
			});
			dropdownValues[sheet.name][lookup.column] = Array.from(dropdownValues[sheet.name][lookup.column]);
		  });
		});
	  
		// Create sheets with dropdowns based on the gathered values
		dataRows.sheets.forEach(sheet => {
		  var worksheet = workbook.addWorksheet(sheet.name);
		
		  if (sheet.visible === false) {
			worksheet.state = 'hidden';
		  }
		
		  // Add empty rows up to the header row start
		  for (let i = 1; i &lt; sheet.headerRow; i++) {
			worksheet.addRow([]);
		  }
		  // Set column headers and widths
		  worksheet.columns = sheet.headers.map(header => {
			return {key: header.name, width: header.width };
		  });

		  // Add 'name' and 'description' labels
		  const nameCell = worksheet.getCell('A1');
		  nameCell.value = 'Name';
		  nameCell.fill = {
			type: 'pattern',
			pattern: 'solid',
			fgColor: { argb: 'FF000000' },
			bgColor: { argb: 'FF000000' }
		  };
		  nameCell.font = {
			color: { argb: 'FFFFFFFF' },
			bold: true
		  };
	  
		  const descriptionCell = worksheet.getCell('A2');
		  descriptionCell.value = 'Description';
		  descriptionCell.fill = {
			type: 'pattern',
			pattern: 'solid',
			fgColor: { argb: 'FF000000' },
			bgColor: { argb: 'FF000000' }
		  };
		  descriptionCell.font = {
			color: { argb: 'FFFFFFFF' },
			bold: true
		  };
	  
		  const notesCell = worksheet.getCell('A3');
		  notesCell.value = 'Notes';
		  notesCell.fill = {
			type: 'pattern',
			pattern: 'solid',
			fgColor: { argb: '990000' },
			bgColor: { argb: '990000' }
		  };
		  notesCell.font = {
			color: { argb: 'FFFFFFFF' },
			bold: true
		  };
		  // Add sheet name and description
		  worksheet.getCell('B1').value = sheet.name;
		  worksheet.getCell('B2').value = sheet.description; 
		  worksheet.getCell('B3').value = sheet.notes; 
		   
		  // Formatting header row 
		  const headerRow = worksheet.getRow(sheet.headerRow);
		  sheet.headers.forEach((header, index) => {
			if(index!==0){
			const cell = headerRow.getCell(index + 1); // +1 because ExcelJS columns are 1-indexed
			cell.value = header.name;
			cell.fill = {
			  type: 'pattern',
			  pattern: 'solid',
			  fgColor: { argb: 'FF000000' }, // Black background
			  bgColor: { argb: 'FF000000' }
			};
			cell.font = {
			  color: { argb: 'FFFFFFFF' }, // White text
			  bold: true
			};
		}
		  });
	  
		  // Adding data rows starting after the header row
		  let dataRowCount = sheet.data.length;
		  sheet.data.forEach(rowData => {
			let row = [];
			 
			  row.push(null); // Placeholder cells to align data with the correct column
			 
			row.push(...Object.values(rowData));
			worksheet.addRow(row);
		  });
	  
		  // Add extra rows for future data (100 rows)
		  for (let i = 0; i &lt; 100; i++) {
			worksheet.addRow([]);
		  }
	  
	  
		  // Applying lookups (dropdowns)
		  if (sheet.lookup) {
			sheet.lookup.forEach(lookup => {
				let lookupVal= "='"+lookup.worksheet+"'!$"+lookup.values+"$"+lookup.start+":$"+lookup.values+"$"+lookup.end;
			  worksheet.getColumn(lookup.column).eachCell({ includeEmpty: true }, (cell, rowNumber) => {
				if (rowNumber > sheet.headerRow  &amp;&amp; rowNumber &lt;= dataRowCount + 100) { // Skip header row
				  cell.dataValidation = {
					type: 'list',
					allowBlank: true,
					formulae: [lookupVal]
				  };
				}
			  });
			});
		  }
	  
		  // Handling the concatenate formula
		  if (sheet.concatenate) {
			const formulaColumn = sheet.concatenate.column;
			const formulaType = sheet.concatenate.type;
			let formulaTemplate = sheet.concatenate.formula;
	  
			worksheet.eachRow(function (row, rowNumber) {
				if (rowNumber > sheet.headerRow &amp;&amp; rowNumber &lt;= dataRowCount + 100) { // Apply to data rows and 100 extra rows
				  let dynamicFormula = formulaType + '(' + formulaTemplate.replace(/[A-Z]/g, match => `${match}${rowNumber}`) + ')';
				  row.getCell(formulaColumn).value = { formula: dynamicFormula, result: '' };
				}
			  });
		  }

		});
	  
		// Trigger download
		workbook.xlsx.writeBuffer().then(function (buffer) {
		  var blob = new Blob([buffer], {
			type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		  });
		  var url = window.URL.createObjectURL(blob);
		  var anchor = document.createElement('a');
		  anchor.href = url;
		  anchor.download = 'LaunchpadExport.xlsx';
		  document.body.appendChild(anchor); // For Firefox
		  anchor.click();
		  document.body.removeChild(anchor); // For Firefox
		  window.URL.revokeObjectURL(url);
		}).catch(function (error) {
		  console.error(error);
		});
	  }
  
   </xsl:template>
   
   
   <xsl:template match="node()" mode="status">
      <xsl:variable name="thislanguage" select="$language"/>  
      <xsl:variable name="thissynonym" select="$synonym[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>  
      <xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/> 	 
      {"id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
      "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",
      "colour":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",
      "seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
      "score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>",
      "synonyms":[<xsl:for-each select="$thissynonym">
         <xsl:variable name="thislanguage" select="$language[name=current()/own_slot_value[slot_reference='synonym_language']/value]"/>  
         {"name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
         "translation":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
         "language":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thislanguage"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
   </xsl:template>
   <xsl:template match="node()" mode="standard">
      <xsl:variable name="thislanguage" select="$language"/>  
      <xsl:variable name="thissynonym" select="$synonym[name=current()/own_slot_value[slot_reference='synonyms']/value]"/>  
      <xsl:variable name="thisstyle" select="$style[own_slot_value[slot_reference='style_for_elements']/value=current()/name]"/>  
      {"id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
      "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",	 
      "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
      "colour":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>",	 
      "class":"<xsl:value-of select="$thisstyle[1]/own_slot_value[slot_reference='element_style_class']/value"/>",
      "seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
      "score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>",
      "synonyms":[<xsl:for-each select="$thissynonym">
         <xsl:variable name="thislanguage" select="$language[name=current()/own_slot_value[slot_reference='synonym_language']/value]"/>  
         {"name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
         "translationName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
         "translationDesc":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
         "language":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thislanguage"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>
   </xsl:template>	
   <xsl:template match="node()" mode="acquisition">
      {"id":"<xsl:value-of select="current()/name"/>",
      "name":"<xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/>",
      "label":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>",	 
      "description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
      "seqNo":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", 
      "score":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
   </xsl:template>	
   <xsl:template match="node()" mode="dataLookup">
		{"id":"<xsl:value-of select="current()/name"/>",
		<xsl:variable name="tempName" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name', 'relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="result" select="serialize($tempName, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
		<xsl:variable name="tempDescription" as="map(*)" select="map{'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="result1" select="serialize($tempDescription, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result1,'{'),'}')"></xsl:value-of>,
		<xsl:call-template name="RenderSecurityClassificationsJSONForInstance"><xsl:with-param name="theInstance" select="current()"/></xsl:call-template>}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>  
   
</xsl:stylesheet>  
