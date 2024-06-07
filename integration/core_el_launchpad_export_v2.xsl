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
 
   <xsl:variable name="lifecycleModels" select="/node()/simple_instance[supertype = 'Lifecycle_Model' or  type='Lifecycle_Model']"/>
   <xsl:key name="lifecycleModelUsage" match="/node()/simple_instance[supertype = 'Lifecycle_Status_Usage' or  type='Lifecycle_Status_Usage']" use="own_slot_value[slot_reference='used_in_lifecycle_model']/value"/>
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

        * ExcelJS
        The MIT License (MIT)

         Copyright (c) 2014-2019 Guyon Roche

         Permission is hereby granted, free of charge, to any person obtaining a copy
         of this software and associated documentation files (the "Software"), to deal
         in the Software without restriction, including without limitation the rights
         to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
         copies of the Software, and to permit persons to whom the Software is
         furnished to do so, subject to the following conditions:

         The above copyright notice and this permission notice shall be included in all
         copies or substantial portions of the Software.

         THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
         IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
         FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
         AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
         LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
         OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
         SOFTWARE.

        * FileSaver
         The MIT License

         Copyright © 2016 Eli Grey.

         Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

         The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

         THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
            <title>Essential Assistant</title>
            <!--	<script type="text/javascript"
                 src="js/json-rules-engine/dist/json-rules-engine.js?release=6.19">  
                 </script>	 -->
            <script src="js/exceljs/exceljs.min.js?release=6.19"></script>		     
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
    <!-- font-family: 'Arial', sans-serif;
    background-color: #ffffff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); -->
    border-left: 1px solid #ccc;
    border-right: 1px solid #ccc;
    border-top: none;
    border-bottom: 1px solid #ccc;
    background-color: #fff;
    border-radius: 0 0 4px 4px;
    padding: 10px 5px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.15);
}

/* Panel containing questions */
.questionPanel {
    width: 293px;
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
    position: absolute;
    right: 25px;
    top: 51px;
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
.eas-logo-spinner {
    display: flex; 
    justify-content: center; 
}
#editor-spinner {
    height: 100px; 
    width: 100px; 
    top: 140px !important; 
    left: 300px;; 
    z-index:999999; 
    background-color: hsla(255,100%,100%,0.75); 
    text-align: center; 
}
#editor-spinner-text {
    width: 100px; 
    z-index:999999; 
    text-align: center; 
}
.spin-text {
    font-weight: 700; 
    animation-duration: 1.5s; 
    animation-iteration-count: infinite; 
    animation-name: logo-spinner-text; 
    color: #aaa; 
    float: left; 
}
.spin-text2 {
    font-weight: 700; 
    animation-duration: 1.5s; 
    animation-iteration-count: infinite; 
    animation-name: logo-spinner-text2; 
    color: #666; 
    float: left; 
}

.import-wrapper {
   display: flex;
   gap: 15px;
   margin-bottom: 30px;
}

.nmBoxStyle{
   border: 1px solid #ccc;
   border-radius: 5px;
   padding: 10px;
   border-left: 10px solid #aef4d2;
   background-color: #dff3e9;
   width: 50%;
}
.home-card-container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
}

.home-card {
    flex-basis: calc(50% - 10px); /* Adjust the 10px for the desired spacing */
    margin: 5px; /* Half of the space you want between boxes */
    position:relative;
}

.home-card:first-child {
    flex-basis: calc(100% - 10px); /* Full width minus the margin */
}

.home-card:hover {
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
}

.home-card-background {
   width: 100%;
   height: 195px;
   border-radius:5px 5px 0px 0px;
   background-size: 100% auto;
   background-position: center;
}

.home-card-content {
    padding: 15px;
    text-align: center;
    z-index:1;
    border: 1px solid #ccc;
    background-color: #f6f6f6;
}
.useCoachBox{
   border:1pt solid #d3d3d3;
   border-radius:6px;
   padding: 3px;
   padding-left:0px;
   height:120px;
   width:305px;
   position:relative;
   z-index: 1;
   margin-bottom: 5px;
}

.useCoachBox::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image: url('images/adobestock_269014286.jpeg'); /* Replace with your image URL */
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    opacity: 0.5; /* Adjust transparency; 0 is fully transparent, 1 is fully opaque */
    z-index: -1;
}
.useCoachBoxText{
   border-radius: 6px 0px 0px 6px;
    padding: 2px; 
    padding-right: 7px;
    position: absolute;
    background-color: #ffffff3d;
    color: black;
    font-weight: bold;
    font-size: 28px;
    top: 4px;
    left:4px;
    height: 34px;
    display: inline-block;
}
.useCoachBoxQs{
    border-radius: 0px 6px 6px 0px;
    padding-top: 2px;
    width: 120px;
    position: absolute;
    right: 2px;
    bottom: 3px;
    background-color: #e3e3e3b3;
    color: #000;
    font-weight: bold;
}
.watermark {
      position: absolute;
      top: 5%;
      left: 5%;
      transform: translate(-10%, -10%);
      max-width: 100%;
      white-space: nowrap;
      text-overflow: ellipsis;
      z-index: 0;
      opacity: 0.15;
      font-size: 160px;
      color: #fff;
      pointer-events: none;
      }
.box{
   border:1pt solid #d3d3d3;
   border-left:25px solid #e3e3e3;
   padding:2px;
   border-radius:6px; 
   margin:2px;
}
.reportCard{
   width: 160px;
   height:60px;
   font-size:0.9em;
   background-color:#82e3c6;
   border-radius: 6px;
   border: 1pt solid #d3d3d3;
   padding:3px;
   margin:2px;
   display:inline-block;
   text-align:center;
   vertical-align:top;
   position:relative;
}
.infoBox{
   background-color: #cf3e3e;
   border:1pt solid #d3d3d3;
   border-radius:6px;
   color:white;
   padding: 4px;
   width:50%;
   margin 5px;
}

.selectDiv{ 
    position: absolute;
    right: 20px;
    top: 20px;
}
.select2-container--default .select2-selection--single {
    height: 30px; /* Smaller height */
}

.select2-container--default .select2-selection--single .select2-selection__rendered {
    line-height: 30px; /* Adjust line height to match the new height */
    font-size: 12px; /* Smaller font size */
}

.select2-container--default .select2-selection--single .select2-selection__arrow {
    height: 30px; /* Adjust arrow height to match the new height */
}
@keyframes blinker {
  50% {
    opacity: 0;
  }
}

.blinking {
  animation: blinker 1s linear infinite;
}

.saveinfo{
   position:relative;
   top:-45px;
}  

@keyframes pulse {
    0% {
        transform: scale(1);
        opacity: 1;
    }
    50% {
        transform: scale(1.1);
        opacity: 0.7;
    }
    100% {
        transform: scale(1);
        opacity: 1;
    }
}

.pulse-icon {
    animation: pulse 1s ease-in-out 5;
}

.pulsing-border {   
   border: 1px solid transparent; 
   animation: pulse 2s infinite;
   border-radius:6px;
   padding-left:3px;
 }
 
 @keyframes pulse {
   0%, 100% {
     border-color: #e3e3e3;
     box-shadow: 0 0 0 0 #e3e3e3;
   }
   50% {
     border-color: red;
     box-shadow: 0 0 1px 1px rgba(255, 0, 0, 0.5);
   }
 }
 .panelNameChange{
   padding-left:5px;
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
                           <span class="text-darkgrey"><xsl:value-of select="eas:i18n('Essential Assistant')"/></span>
                        </h1>
                     </div>
                  </div>
               	<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
                  <div class="col-xs-12">
                     <ul class="nav nav-tabs">
                        <li class="active"><a data-toggle="tab" href="#home">Home</a></li> 
                        <li><a data-toggle="tab" href="#coach">Playbook</a></li> 
                        <li><a data-toggle="tab" href="#launchpad">Launchpad Export</a></li> 
                        <!--       
                        <li><a data-toggle="tab" href="#launchpadplus">Launchpad Plus</a></li>        
                        -->
                     </ul>	
                     <div class="tab-content">
                        <div id="home" class="tab-pane fade in active">
                           <div class="home-card-container">
                              <div class="home-card" data-target="#coach">
                                 <div class="home-card-background" style="background-image: url(images/ramon-salinero-vEE00Hx5d0Q-unsplash.jpg);"></div>
                                  <div class="home-card-content">
                                      <h2><b>Playbook</b></h2>
                                      <h2 class="watermark">playbook</h2>
                                      <p>Essential Playbook, select playbooks are best suited to your needs.</p>
                                  </div>
                              </div>
                              <div class="home-card" data-target="#launchpad">
                                 <div class="home-card-background" style="background-image: url(images/adobestock_197711208.jpeg);"></div>
                                  <div class="home-card-content">
                                      <h2><b>Launchpad Export</b></h2>
                                      <h2 class="watermark">export</h2>
                                      <p>Essential Launchpad based export of your current repository data.</p>
                                  </div>
                              </div>
                              <!-- PLANNED 
                              <div class="home-card" data-target="#launchpadplus">
                                 <div class="home-card-background" style="background-image: url(images/adobestock_197711208.jpeg);"></div>
                                  <div class="home-card-content">
                                      <h2><b>Launchpad Plus Export</b></h2>
                                      <h2 class="watermark">export</h2>
                                      <p>Essential Launchpad Plus export of data.</p>
                                  </div>
                              </div>
                               -->
                          </div>
                      
                        </div>
                        <div id="coach" class="tab-pane fade">
                        
                         <div class="questionanswercontainer">

                           <div id="results" class="top-10 resultsPanel">
                              
                              <div id="playResults"></div>
                              
                           </div>
                        </div>
                           
                        </div>
                        <div id="launchpad" class="tab-pane fade">
                           <button class="btn btn-warning" onclick="createWorkbookFromJSON()">Download Excel File</button> <xsl:text> </xsl:text>
                           <button class="btn btn-info" onclick="createEmptyWorkbookFromJSON()">Download Blank Excel File</button> 
                           <div id="infoBox" class="infoBox"/>
                           <p>Note: if there are dropdowns in the spreadsheet that reference sheets not exported, you may get an update warning when opening the downloaded spreadsheet, you can ignore the warning or export the relevant sheets</p>
                           <div class="col-xs-12">
                           <b>Key: </b>  
                           <div class="box" style="font-size:0.8em; height:20px;width: 125px;display:inline-block"> Data Not Loaded</div>
                           <div class="box" style="font-size:0.8em; height:20px;width: 125px;border-left:25px solid #0aa20a;display:inline-block"> Data Loaded</div>
                           </div>
                           <div class="col-xs-4">
                           <h3 class="text-primary">Worksheets</h3>
                           <ul class="list-unstyled">
                              <li>
                                 <div class="box" id="bc">
                                 <input type="checkbox" class="sheet" id="busCapsWorksheetCheck" easid="4" name="busCapsWorksheetCheck" value="false"/>Business Capabilities <i class="fa fa-cloud-download additional" id="busCapsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box"  id="bd">
                                 <input type="checkbox" class="sheet" id="busDomWorksheetCheck" easid="2" name="busDomWorksheetCheck" value="false"/>Business Domains <i class="fa fa-cloud-download additional" id="busDomi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="bp">
                                    <input type="checkbox" class="sheet" id="busProcsWorksheetCheck" easid="5" name="busProcsWorksheet" value="false"/>Business Processes  <i class="fa fa-cloud-download additional" id="busProcsi"></i>
                                 </div>   
                              </li>
                              <li>
                                 <div class="box" id="bpf">
                                    <input type="checkbox" class="sheet" id="busProcsFamilyWorksheetCheck" easid="7" name="busProcsFamilyWorksheetCheck" value="false"/>Business Process Families
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="st">
                                    <input type="checkbox" class="sheet" id="sitesCheck" easid="7" name="sitesCheck" value="false"/>Sites  <i class="fa fa-cloud-download additional" id="sitesi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="or">
                                   <input type="checkbox" class="sheet" id="orgsCheck" easid="7" name="orgsCheck" value="false"/>Organisations  <i class="fa fa-cloud-download additional" id="orgsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="ors">
                                    <input type="checkbox" class="sheet" id="orgs2sitesCheck" easid="7" name="orgs2sitesCheck" value="false"/>Orgs to Sites 
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="ac">
                                    <input type="checkbox" class="sheet" id="appCapsCheck" easid="7" name="appCapsCheck" value="false"/>Application Capabilities  <i class="fa fa-cloud-download additional" id="appCapsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="as">
                                 <input type="checkbox" class="sheet" id="appSvcsCheck" easid="7" name="appSvcsCheck" value="false"/>Application Services  <i class="fa fa-cloud-download additional" id="appSvcsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="ac2s">
                                    <input type="checkbox" class="sheet" id="appCaps2SvcsCheck" easid="7" name="appCaps2SvcsCheck" value="false"/>Application Caps 2 Services
                                 </div>   
                              </li>
                              <li>
                                 <div class="box" id="aps">
                                  <input type="checkbox" class="sheet" id="appsCheck" easid="7" name="appsCheck" value="false"/>Applications  <i class="fa fa-cloud-download additional" id="appsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="aps2sv">
                                    <input type="checkbox" class="sheet" id="apps2svcsCheck" easid="7" name="apps2svcsCheck" value="false"/>Applications to Service <i class="fa fa-cloud-download additional" id="apps2svcsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="aps2or">
                                    <input type="checkbox" class="sheet" id="apps2orgsCheck" easid="7" name="apps2orgsCheck" value="false"/>Applications to Orgs
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="bp2srvs">
                                    <input type="checkbox" class="sheet" id="busProc2SvcsCheck" easid="7" name="busProc2SvcsCheck" value="false"/>Bus Processes to App Services
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="phyp2appsv">
                                     <input type="checkbox" class="sheet" id="physProc2AppVsCheck" easid="7" name="physProc2AppVsCheck" value="false"/>Physical Process to Apps via Services
                                 </div>   
                              </li>
                              <li>
                                 <div class="box" id="phyp2appdirect">
                                    <input type="checkbox" class="sheet" id="physProc2AppCheck" easid="7" name="physProc2AppCheck" value="false"/>Physical Process to Apps
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="infex">
                                    <input type="checkbox" id="infoExchangedCheck" easid="7" name="infoExchangedCheck" value="false"/>Information Exchanged  <i class="fa fa-cloud-download additional" id="infoXi"></i>
                                </div> 
                              </li>
                              <li>
                                 <div class="box" id="nodes">
                                    <input type="checkbox" class="sheet" id="nodesCheck" easid="7" name="nodesCheck" value="false"/>Servers  <i class="fa fa-cloud-download additional" id="nodesi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="ap2servs">
                                    <input type="checkbox" class="sheet" id="apps2serverCheck" easid="7" name="apps2serverCheck" value="false"/>Application to Server
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tds">
                                    <input type="checkbox" class="sheet" id="techDomsCheck" easid="7" name="techDomsCheck" value="false"/>Technology Domains  <i class="fa fa-cloud-download additional" id="techDomsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tcaps">
                                    <input type="checkbox" class="sheet" id="techCapsCheck" easid="7" name="techCapsCheck" value="false"/>Technology Capabilities  <i class="fa fa-cloud-download additional" id="techCapsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tcomps">
                                   <input type="checkbox" class="sheet" id="techCompsCheck" easid="7" name="techCompsCheck" value="false"/>Technology Components  <i class="fa fa-cloud-download additional" id="techCompsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tsups">
                                   <input type="checkbox" class="sheet" id="techSuppliersCheck" easid="7" name="techSuppliersCheck" value="false"/>Technology Suppliers  <i class="fa fa-cloud-download additional" id="techSuppi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tprods">
                                    <input type="checkbox" class="sheet" id="techProductsCheck" easid="7" name="techProductsCheck" value="false"/>Technology Products  <i class="fa fa-cloud-download additional" id="techProdsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tprodfams">
                                     <input type="checkbox" class="sheet" id="techProductFamiliesCheck" easid="7" name="techProductFamiliesCheck" value="false"/>Technology Product Families <i class="fa fa-cloud-download additional" id="techFami"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="tprodors">
                                    <input type="checkbox" class="sheet" id="techProducttoOrgsCheck" easid="7" name="techProducttoOrgsCheck" value="false"/>Technology Products to Orgs
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="dsubjs">
                                    <input type="checkbox" class="sheet" id="dataSubjectCheck" easid="7" name="dataSubjectCheck" value="false"/>Data Subjects  <i class="fa fa-cloud-download additional" id="dataSubjsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="dObjs">
                                    <input type="checkbox" class="sheet" id="dataObjectCheck" easid="7" name="dataObjectCheck" value="false"/>Data Objects  <i class="fa fa-cloud-download additional" id="dataObjsi"></i>
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="dObjins">
                                    <input type="checkbox" class="sheet" id="dataObjectInheritCheck" easid="7" name="dataObjectInheritCheck" value="false"/>Data Object Inheritance
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="dObjAts">
                                    <input type="checkbox" class="sheet" id="dataObjectAttributeCheck" easid="7" name="dataObjectAttributeCheck" value="false"/>Data Object Attributes
                                 </div>
                              </li>
                              <li>
                                 <div class="box" id="appDps">
                                    <input type="checkbox" class="sheet" id="appDependencyCheck" easid="7" name="appDependencyCheck" value="false"/>Application Dependencies
                                 </div>
                              </li>								
                              <li>
                                 <div class="box" id="apptechs">
                                    <input type="checkbox" id="apptotechCheck" easid="7" name="apptotechCheck" value="false"/>App to Technology Products
                                 </div>   
                              </li>
                           
                           </ul>
                           </div>
                           <div class="col-md-4">
                              <h3 class="text-primary"><xsl:value-of select="eas:i18n('Foundation Views')"/></h3>
                              <ul class="list-unstyled">
                                 <li><input type="checkbox" class="views" id="busCapDash"/>Business Capability Dashboard</li>
                                 <li><input type="checkbox" class="views" id="appRefModel"/>Application Reference Model </li>
                                 <li><input type="checkbox" class="views"  id="technologyRefModel"/>Technology Reference Model</li> 
                                 <li><input type="checkbox" class="views"  id="itAsset"/>IT Asset Dashboard</li>
                             
                                 <li><input type="checkbox" class="views"  id="domi"/>Data Object Model</li> 
                                 <li><input type="checkbox" class="views" id="afoot"/>Application Footprint Comparison </li>
                                 <li><input type="checkbox" class="views" id="appStratTech"/>Application Technology Strategy Alignment</li>
                                
                                 <li><input type="checkbox" class="views" id="ari"/>Application Radar</li>
                                 <li><input type="checkbox" class="views" id="adepsi"/>Application Dependency</li>
                                 <li><input type="checkbox" class="views" id="arai"/>Application Rationalisation Analysis</li> 
                                 <li><input type="checkbox" class="views" id="bditi"/>Business Domain IT Analysis </li>
                                 <li><input type="checkbox" class="views" id="bdpai"/>Business Domain Process Analysis</li>
                                 </ul>
                                 <h4>Catalogues and Summaries</h4>
                                 <small>Note these use lots of relationships, We highlight the foundation data only here</small>
                                 <ul class="list-unstyled">
                                    <li><input type="checkbox" class="views" id="businessCapabilitySummary"/>Business Capability Summary </li>
                                    <li><input type="checkbox" class="views" id="busProcSummary"/>Business Process Summary</li>
                                    <li><input type="checkbox" class="views" id="appCapabilitySummary"/>Application Capability Summary </li>
                                    <li><input type="checkbox" class="views"  id="applicationCatalogue"/>Application Catalogue</li>
                                    <li><input type="checkbox" class="views" id="applicationSummary"/>Application Summary </li>
                                    <li><input type="checkbox" class="views" id="appDeploymentSummary"/>Application Deployment Summary</li>
                                    <li><input type="checkbox" class="views" id="tcsi"/>Technology Component Summary </li>
                                    <li><input type="checkbox" class="views" id="technologyCatalogue"/>Technology Catalogue</li> 
                                    <li><input type="checkbox" class="views" id="technologyProdSummary"/>Technology Product Summary</li> 
                                    <li><input type="checkbox" class="views" id="technologyNodeSumary"/>Technology Node Summary </li>
                                    <li><input type="checkbox" class="views" id="dataObjectSummary"/>Data Object Summary</li>
                                    <li><input type="checkbox" class="views" id="dataSubjectSummary"/>Data Subject Summary</li> 
                                 <!--
                                    <li><input type="checkbox" class="views" id="adai"/>Application Diversity Analysis </li>
                                  
                                 <li><input type="checkbox" id="bctti"/>Business Capability to Technology Tree</li> 
                                 <li><input type="checkbox" id="bctfi"/>Business Capability to Technology Force</li> 
                               
                                 <li><input type="checkbox" id="bpfsi"/>Business Process Family Summary</li>                                  
                               
                                 -->
                              </ul>
                           </div>
                           <div class="col-xs-4"></div>
                           <div class="clearfix"/>
                        </div>
                        <div id="launchpadplus" class="tab-pane fade">
                              <button class="btn btn-default" id="exportApplicationLifecycles">App Lifecycles</button>
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
               
               var lifecycleModels=[<xsl:apply-templates select="$lifecycleModels" mode="lifecycleModels"/>];
               var lifecycles=[<xsl:for-each select="$lifecycle union $techlifecycle"><xsl:sort select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value" order="ascending"/> {"id":"<xsl:value-of select="current()/name"/>",
                  <xsl:variable name="tempName" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name', 'relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
                  <xsl:variable name="result" select="serialize($tempName, map{'method':'json', 'indent':true()})"/>  
                  <xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,"val":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>", "type":"<xsl:value-of select="current()/type"/>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
               console.log('lifecycleModels',lifecycleModels)
               console.log('lifecycle',lifecycles)

              
            //   console.log("COUNTS:"+BusinessCapability+":"+BusinessDomain+":"+BusinessProcess+":"+BusinessProcessFamily+":"+Site+":"+GroupActor+":"+ApplicationCapability+":"+ApplicationService+":"+Applications+":"+InformationRepresentation+":"+TechnologyNode+":"+TechnologyDomain+":"+TechnologyCapability+":"+TechnologyComponent+":"+TechnologySupplier+":"+TechnologyProduct+":"+TechnologyProductFamily+":"+DataSubject+":"+DataObject+":"+DataObjectAttribute)			
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
                 
          //     $('#results').show();
                
            </script>
        
            <script id="play-template" type="text/x-handlebars-template">
               <div class="pull-right lp-setup-legend">Click <i class="fa fa-rocket"></i> on required steps to set up Launchpad</div>
               <h3 class="text-primary">{{this.words}}</h3>
               <ul class="nav nav-pills">					
                  {{#each this.plays}}
                  <li><xsl:attribute name="class"><!--{{#ifEquals @index 0}}active{{/ifEquals}}--> playTabs </xsl:attribute><xsl:attribute name="easplayid">{{this.name}}</xsl:attribute><a data-toggle="tab"><xsl:attribute name="href">#{{this.name}}</xsl:attribute>{{this.name}}</a></li>
                  {{/each}}
               </ul>								  
               
               <div class="tab-content" style="border: none;box-shadow: none;">
                  {{#each this.plays}}
                  <div><xsl:attribute name="class">{{#ifEquals @index 0}}tab-pane fade in active{{else}}tab-pane fade{{/ifEquals}}</xsl:attribute><xsl:attribute name="id">{{this.name}}</xsl:attribute>
                     <div class="top-15">
                        <h4>{{this.name}} - {{this.description}}</h4>
                        <p class="small text-muted">For detailed information see <a target="_blank"><xsl:attribute name="href" >{{{this.link}}}</xsl:attribute>here</a></p> 
                        {{#each this.steps}}
                        <div class="playcard">
                           <div class="cardname">{{this.name}}<div class="pull-right launch"><xsl:attribute name="easid">{{../this.name}}{{#getCount @index}}{{/getCount}}</xsl:attribute><i class="fa fa-rocket" style="color:white"></i>
                           <input type="checkbox" style="display:none;"> 
                              <xsl:attribute name="id">{{../this.name}}{{#getCount @index}}{{/getCount}}</xsl:attribute> 
                              <xsl:attribute name="name">{{../this.name}}{{#getCount @index}}{{/getCount}}</xsl:attribute>
                           </input>
                     </div></div>
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
               sessionStorage.clear();
               var currentTab = 0; // Current tab is set to be the first tab (0)
               // Display the current tab
               var playTemplate, playFragment;
               var portalJSON, portalPlayJSON, portalSavedJSON;
               var portalOptions=[];
               var portalPlays=[];
               var playlist={
   "set":[
      {
         "name":"Play1",
         "description":"Anchor on Applications, Bring in Business Elements",
         "link":"https://enterprise-architecture.org/resources/essential-playbook/essential-playbook-1/",
         "steps":[
            {  
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited",
               "data":[
                  {
                     "name":"Applications",
                     "Optional":"N"
                  },
                  {
                     "name":"Application Services",
                     "Optional":"N"
                  },
                  {
                     "name":"Organisations",
                     "Optional":"N"
                  },
                  {
                     "name":"Application Services to Apps",
                     "Optional":"N"
                  },
                  {
                     "name":"Applications to Org Users",
                     "Optional":"N"
                  },
                  {
                     "name":"Sites",
                     "Optional":"Y"
                  },
                  {
                     "name":"Organisation to Sites",
                     "Optional":"Y"
                  }
               ],
               "views":[
                  {
                     "id":"Core: Application Provider Catalogue as Table",
                     "name":"Application Catalogue",
                     "type":"view"
                  },
                  {
                     "id":"Core: Application Provider Summary",
                     "name":"Application Summary",
                     "type":"view"
                  },
                  {
                     "id":"Config: Application Editor",
                     "name":"Application Editor",
                     "type":"editor"
                  }
               ]
            },
            {
               "name":"A1.2",
               "what":"Create the application reference model and map applications",
               "usage":"Identify duplicate application candidates from an application perspective. Initial view, provides focus for the business work",
               "parties":"CIO",
               "description":"Interested, keen to discover more",
               "views":[
                  {
                     "id":"Core: Application Reference Model",
                     "name":"Application Reference Model",
                     "type":"view"
                  },
                  {
                     "id":"Core: Application Capability Summary",
                     "name":"Application Capability Summary",
                     "type":"view"
                  }
               ]
            },
            {
               "name":"B1.1",
               "what":"Create the business capability model with the BA, validate with Executive",
               "usage":"Will be the anchor for application duplication from a business perspective",
               "parties":"Business",
               "description":"Interested",
               "views":[
                  {
                     "id":"Core: Business Capability Dashboard",
                     "name":"Business Capability Dashboard"
                  },
                  {
                     "id":"Core: Business Capability Summary",
                     "name":"Business Capability Summary",
                     "type":"view"
                  },
                  {
                     "id":"Core: Business Capability Model Editor",
                     "name":"Business Capability Model Editor",
                     "type":"view"
                  }
               ]
            },
            {
               "name":"B1.2",
               "what":"Identify the high-level processes and map applications that use them",
               "usage":"Enables identification of duplicate application candidates in the business.",
               "parties":"Business &amp; CIO",
               "description":"Interested, keen to discover more. Initiate cost review activities",
               "views":[
                  
               ]
            },
            {
               "name":"S1.5",
               "what":"Get costs for applications that are prime for review",
               "usage":"Use costs to identify which candidates are worth chasing",
               "parties":"Business &amp; CIO",
               "description":"Actively interested, want high-level business case",
               "views":[
                  
               ]
            },
            {
               "name":"A1.4",
               "what":"Identify inter-dependencies for applications that are prime for review",
               "usage":"Use complexity to gauge the work required in rationalising the candidate",
               "parties":"Business &amp; CIO",
               "description":"Actively Interested, want business case and action plan",
               "views":[
                  
               ]
            }
         ]
      },
      {
         "name":"Play2",
         "description":"Anchor on Applications, Link to Technology, Bring in Business Elements",
         "link":"https://enterprise-architecture.org/resources/essential-playbook/essential-playbook-2",
         "steps":[
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited"
            },
            {
               "name":"A1.2",
               "what":"Create the application reference model and map applications",
               "usage":"Identify duplicate application candidates from an application perspective. Initial view, provides focus for the business work",
               "parties":"CIO",
               "description":"Interested, keen to discover more"
            },
            {
               "name":"T1.1",
               "what":"Create the technology reference model",
               "usage":"Anchor for technology Products created",
               "parties":"CIO",
               "description":"Interested, but not excited"
            },
            {
               "name":"T1.2",
               "what":"Capture the technology products against the reference model",
               "usage":"Identify duplicate and high risk technologies",
               "parties":"CIO",
               "description":"Initiates activities based on duplicate technology or risk"
            },
            {
               "name":"T1.3",
               "what":"Create technology nodes , with locations and attach technology instances to them",
               "usage":"Get clarity on what technology nodes exist, where and what technology sits on them. See the implications of, for example, a failure, a data centre move or a cloud-first strategy",
               "parties":"CIO",
               "description":"Has clarity on what exists where. Keen to know impact of strategic infrastructure initiatives"
            },
            {
               "name":"A1.3",
               "what":"Map technology components and products to Applications",
               "usage":"Use to identify application technology risk and non strategic technologies used by applications",
               "parties":"CIO",
               "description":"Realignment of the portfolio based on risk and strategy. Business risk discussions begin"
            }
         ]
      },
      {
         "name":"Play3",
         "description":"Build Simple Governance, Anchored Around Applications Then Technology",
         "link":"https://enterprise-architecture.org/ea_play_3/",
         "steps":[
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited",
               "views":[
                  {
                     "id":"Core: Application Provider Catalogue as Table",
                     "name":"Application Catalogue"
                  }
               ]
            },
            {
               "name":"S1.1",
               "what":"Define a set of achievable architecture principles to govern against",
               "usage":"Engage projects with the principles at start-up and decide architecture against the principles. Break the principles only where there is a compelling reason",
               "parties":"CIO",
               "description":"Interested, keen to know how the principles will help them achieve strategy. Projects positive if the principles are reasonable",
               "views":[
                  {
                     "id":"Core: EA Principles Catalogue",
                     "name":"Principles Catalogue"
                  }
               ]
            },
            {
               "name":"S1.6",
               "what":"Create a governance process against which to maintain data in Essential and monitor alignment",
               "usage":"Use the process to engage projects, get data updates from projects and to review changes against the principles (standards can come later). Keep it light touch and initially let projects do some self governance.",
               "parties":"Projects",
               "description":"Participation, a good process should see active participation by projects"
            },
            {
               "name":"S1.5",
               "what":"Capture costs against the applications in the architecture",
               "usage":"Costs will be key in starting to highlight high cost applications so rationalisation opportunities can be better identified and compelling business cases built",
               "parties":"CIO &amp; Business",
               "description":"Active interest, visibility of unnecessary cost always engages"
            },
            {
               "name":"T1.1",
               "what":"Create the technology reference model",
               "usage":"Anchor for technology Products created",
               "parties":"CIO",
               "description":"Interested but not excited"
            },
            {
               "name":"T1.2",
               "what":"Capture the technology products against the reference model",
               "usage":"Identify duplicate and high risk technologies",
               "parties":"CIO",
               "description":"Initiates activities based on duplicate technology or risk"
            }
         ]
      },
      {
         "name":"Play4",
         "description":"Anchor On Technology And Build The Architecture Out From There",
         "link":"https://enterprise-architecture.org/ea_play_4/",
         "steps":[
            {
               "name":"T1.2",
               "what":"Capture the technology products in use",
               "usage":"Have a list of technology products",
               "parties":"CIO",
               "description":"Initiates activities based on duplicate technology or risk"
            },
            {
               "name":"T1.1",
               "what":"Create the technology reference model and map to products",
               "usage":"Anchor for technology Products created Identify duplicate and high risk technologies",
               "parties":"CIO",
               "description":"Interested but not excited"
            },
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details &amp; services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited"
            },
            {
               "name":"T1.3",
               "what":"Create technology nodes , with locations and attach technology instances to them",
               "usage":"Get clarity on what technology nodes exist, where and what technology sits on them. See the implications of, for example, a failure, a data centre move or a cloud-first strategy",
               "parties":"CIO",
               "description":"Has clarity on what exists where. Keen to know impact of strategic infrastructure initiatives"
            },
            {
               "name":"B1.1",
               "what":"Create the business capability model with the BA, validate with Executive",
               "usage":"Will be the anchor for business duplication perspective",
               "parties":"Business",
               "description":"Interested"
            },
            {
               "name":"B1.2",
               "what":"Identify the high-level processes and map applications that use them",
               "usage":"Enables identification of duplicate application candidates in the business",
               "parties":"Business &amp; CIO",
               "description":"Interested, keen to discover more. Initiate cost review activities"
            }
         ]
      },
      {
         "name":"Play5",
         "description":"Get Data In Shape",
         "link":"https://enterprise-architecture.org/ea_play_5/",
         "steps":[
            {
               "name":"D1.1",
               "what":"Capture the Data Subjects and associated Data Objects with descriptions",
               "usage":"This becomes the common vocabulary for data so when people refer to data everyone has a consistent understanding.  This will be the anchor for identifying data duplication, inconsistencies, etc",
               "parties":"Project Teams",
               "description":"Interested but not excited"
            },
            {
               "name":"D1.3",
               "what":"Identify the locations of the databases/data stores that contain the Data Object",
               "usage":"Understanding of where data stores are.  This can later be an anchor for identifying where sensitive data is stored and what it is being used for  (when we tie it to Applications and processes, e.g. for data privacy analysis)",
               "parties":"CIO",
               "description":"High-level visibility as to where data is"
            },
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Begin discussions on where data being mastered in multiple places"
            }
         ]
      },
      {
         "name":"Play6",
         "description":"Bring In Standards For Technology, Anchored Around Applications",
         "link":"https://enterprise-architecture.org/ea_play_6/",
         "steps":[
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited"
            },
            {
               "name":"T1.1",
               "what":"Capture the technology products against the technology reference model",
               "usage":"Identify duplicate and high risk technologies",
               "parties":"CIO",
               "description":"Initiates activities based on duplicate technology or risk"
            },
            {
               "name":"T1.2",
               "what":"Create the technology reference model",
               "usage":"Anchor for technology products created",
               "parties":"CIO",
               "description":"Interested but not excited"
            },
            {
               "name":"S1.4",
               "what":"Define standards for your technologies and define lifecycle status for your technologies",
               "usage":"Anchor for Design Authority discussions, for projects to leverage in technical designs.",
               "parties":"CIO",
               "description":"Keen on convergence on the standards, will want a plan"
            },
            {
               "name":"A1.3",
               "what":"Map the technologies to the applications using them",
               "usage":"Provides a view on application alignment to standards and also can be used to highlight technology risk",
               "parties":"CIO",
               "description":"Very interested as risk can be seen. Will want plans for ‘at risk’ applications or those using non-standard technology"
            }
         ]
      },
      {
         "name":"Play7",
         "description":"Map Applications To Projects For Impact Analysis",
         "link":"https://enterprise-architecture.org/ea_play_7/",
         "steps":[
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited"
            },
            {
               "name":"S1.2",
               "what":"Define strategic plans and the applications they impact",
               "usage":"See strategic plans applications implementing them",
               "parties":"Business &amp; IT",
               "description":"Interested in what is changing"
            },
            {
               "name":"S1.3",
               "what":"Create the projects that will implement the strategic plans",
               "usage":"See Projects delivering the strategic plans",
               "parties":"CIO",
               "description":"Visibility of the change portfolio"
            }
         ]
      },
      {
         "name":"Play8",
         "description":"Create Your Roadmaps",
         "link":"https://enterprise-architecture.org/ea_play_8/",
         "steps":[
            {
               "name":"A1.1",
               "what":"Capture the applications with basic details and services",
               "usage":"Have a list of applications used that can be the anchor for the rest of the work. Define strategic applications in line with your target state",
               "parties":"Business &amp; IT",
               "description":"Interested but not excited"
            },
            {
               "name":"T1.2",
               "what":"Capture the technology products",
               "usage":"Have a list of technology products, ideally you would do T1.1 at the same time",
               "parties":"CIO",
               "description":"Interested but not excited"
            },
            {
               "name":"B1.1",
               "what":"Create the business capability model with the BA, validate with Executive",
               "usage":"Will be the anchor for application duplication from a business perspective",
               "parties":"Business",
               "description":"Interested but not excited"
            },
            {
               "name":"B1.2",
               "what":"Identify the high-level processes and map applications that use them",
               "usage":"Enables identification of duplicate application candidates in the business.",
               "parties":"Business &amp; CIO",
               "description":"Interested, keen to discover more."
            },
            {
               "name":"S1.2",
               "what":"Define strategic plans and the applications they impact",
               "usage":"See strategic plans applications implementing them",
               "parties":"Business &amp; IT",
               "description":"Interested in what is changing"
            },
            {
               "name":"A1.3",
               "what":"Create the projects that will implement the strategic plans",
               "usage":"See Projects delivering the strategic plans",
               "parties":"CIO",
               "description":"Visibility of the change portfolio"
            }
         ]
      }
   ]
};

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
      "id":"applicationCatalogue",
      "sheets":['apps2svcsCheck','appsCheck','appSvcsCheck']
   },
   {
      "id":"businessCapabilitySummary",
      "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck']
   },
   {
      "id":"busProcSummary",
      "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck']
   },
   {
      "id":"appCapabilitySummary",
      "sheets":['appSvcsCheck','appCaps2SvcsCheck','appCapsCheck']
   },
   {
      "id":"applicationSummary",
      "sheets":['appSvcsCheck', 'appsCheck', 'apps2svcsCheck','apps2orgsCheck']
   },
   {
      "id":"appDeploymentSummary",
      "sheets":['appsCheck','nodesCheck', 'apps2serverCheck']
   },
   {
      "id":"technologyProdSummary",
      "sheets":['techCompsCheck','techProductsCheck']
   },
   {
      "id":"technologyCatalogue",
      "sheets":['techCompsCheck','techProductsCheck']
   },
   {
      "id":"technologyNodeSumary",
      "sheets":['nodesCheck', 'sitesCheck']
   },
   {
      "id":"technologyRefModel",
      "sheets":['techDomsCheck', 'techCapsCheck','techCompsCheck','techProductsCheck','techProducttoOrgsCheck','orgsCheck']
   },
   {
      "id":"itAsset",
      "sheets":['busDomWorksheetCheck','busCapsWorksheetCheck','busProcsWorksheetCheck','orgsCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','apps2orgsCheck','physProc2AppVsCheck','physProc2AppCheck','appCaps2SvcsCheck','appCapsCheck','techDomsCheck', 'techCapsCheck','techCompsCheck','techProductsCheck','techProducttoOrgsCheck', 'sitesCheck', 'orgs2sitesCheck']
   },
   {
      "id":"dataObjectSummary",
      "sheets":['dataObjectCheck','dataObjectInheritCheck','dataObjectAttributeCheck']
   },
   {
      "id":"dataSubjectSummary",
      "sheets":['dataObjectCheck','dataSubjectCheck']
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
   "sheets":['appsCheck','appSvcsCheck', 'apps2svcsCheck', 'busProcsWorksheetCheck', 'physProc2AppVsCheck','physProc2AppCheck']
   },
   {"id":"bditi",
   "sheets":['busCapsWorksheetCheck','busProcsWorksheetCheck', 'appSvcsCheck', 'appsCheck', 'apps2svcsCheck','physProc2AppVsCheck','physProc2AppCheck','nodesCheck', 'apps2serverCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck','busDomWorksheetCheck','techSuppliersCheck','techCompsCheck','techProductsCheck','apptotechCheck','techCapsCheck','busProc2SvcsCheck']
   },
   {"id":"bdpai",
   "sheets":['busCapsWorksheetCheck','busDomWorksheetCheck','busProcsWorksheetCheck', 'appSvcsCheck','busProc2SvcsCheck', 'appsCheck', 'apps2svcsCheck','physProc2AppVsCheck','physProc2AppCheck','nodesCheck', 'apps2serverCheck','appCaps2SvcsCheck','appsCheck','appSvcsCheck','appCapsCheck','techSuppliersCheck','techCompsCheck','techProductsCheck','apptotechCheck','techCapsCheck']             
   }	
   ]   

 
var selecttemplate, emptyPortal;

   $(document).ready(function() {
 
      $('#infoBox').hide()
      $('#loadSpinner').hide(); 
      $('#confirmPopup').hide();

      $('.home-card').click(function(){
            var targetTab = $(this).data('target');
            $('.nav-tabs a[href="' + targetTab + '"]').tab('show');
        });

       $('.custom-select').select2({width:'250px'})
 
         playFragment = $("#play-template").html();
         var playTemplate = Handlebars.compile(playFragment);

   
 

         Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
         return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
         });
         Handlebars.registerHelper('getCount', function(arg1, options) {
         return (arg1 + 1);
         });	
    
         $('.resultsPanel').show()
 

//get Portals
 
 
$('#playResults').empty();
         let dataplays=[];
         dataplays['plays']=playlist.set 
    console.log('dataplays',dataplays)
         $('#playResults').append(playTemplate(dataplays));

$(document).on('click', '.launch', function(){
  
                  // Toggle color
                  let icon = $(this).children('i.fa-rocket');
                  let currentColor = icon.css("color");
                  if (currentColor === 'rgb(255, 255, 255)') {  
                     icon.css("color", "rgb(0, 255, 0)"); // Change to green
                  } else {
                     icon.css("color", "rgb(255, 255, 255)");  
                  }

                  // Set box state
                  var boxState = currentColor !== 'rgb(0, 255, 0)';  

                  // Get step ID
                  let stepId = $(this).attr('easid').toLowerCase(); 

                  // Handle step change
                  handleStepChange(stepId, boxState);
 
                  
               });
               
    });
               
             
            </script>
            
            <!-- Playbook code from here -->				
            <script>
               
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
               
function setBox(tick,list){
               
               if (tick == false) {
                  playUnselect(list)
                  }
                  else {
                  playSelect(list)
                  }
                  
               }
// Mapping of step IDs to their respective lists
var stepIdToListMap = {
    'play11': ['applicationCatalogue'],
    'Play12': ['appRefModel'],
    'play12': ['appRefModel'],
    'play13': ['busCapDash'],
    'play14': ['arai'],
    'play16': ['adepsi'],
    'play21': ['applicationCatalogue'],
    'play22': ['appRefModel'],
    'play23': ['technologyRefModel'],
    'play24': ['technologyCatalogue'],
    'play25': ['applicationCatalogue'],
    'play26': ['busCapDash'],
    'play27': ['busProcSummary'],
    'play31': ['applicationSummary'],
    'play35': ['technologyRefModel'],
    'play36': ['technologyProdSummary'],
    'play41': ['technologyProdSummary'],
    'play42': ['technologyRefModel'],
    'play43': ['applicationSummary'],
    'play44': ['technologyNodeSumary'],
    'play45': ['busCapDash'],
    'play46': ['busProcSummary'],
    'play51': ['dataObjectSummary', 'dataSubjectSummary'],
    'play53': ['applicationSummary'],
    'play61': ['applicationSummary'],
    'play62': ['technologyRefModel'],
    'play63': ['technologyProdSummary'],
    'play65': ['appStratTech'],
    'play71': ['applicationSummary'],
    'play81': ['applicationSummary'],
    'play82': ['technologyProdSummary'],
    'play83': ['busCapDash'],
    'play84': ['busProcSummary']
};

// Function to determine the list and action based on the step ID
function handleStepChange(stepId, isChecked) {
    var thisList = stepIdToListMap[stepId];

    if (!thisList) {
        console.log('Unknown step ID:', stepId);
        return;
    }

    if (stepId === 'play36' || stepId === 'play63' || stepId === 'play65' || stepId === 'play82') {
        playSelect(thisList);
    } else {
        setBox(isChecked, thisList);
    }
}
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
         
            let index = activeViewArray.indexOf(sheetId);
            if (index !== -1) {
                activeViewArray.splice(index, 1); // Remove only the first occurrence
            }
        });
   }
   let uniqueArray = [...new Set(activeViewArray)]; 

   $('.sheet').prop('checked', false);
   uniqueArray.forEach((c)=>{
    
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
var reportsJSON ;     
var groupedData;
$('document').ready(function () {


      $('.edit').click(function(){
      $(this).parent().parent().find('.playSteps').slideToggle();
      $(this).toggleClass('fa-caret-right');
      $(this).toggleClass('fa-caret-down');
   });

 
 

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

Handlebars.registerHelper('ifContains', function(arg1, arg2, options) {
    if (typeof arg1 === 'string' &amp;&amp; typeof arg2 === 'string') {
        return arg1.includes(arg2.toLocaleLowerCase()) ? options.fn(this) : options.inverse(this);
    } 
});


       

Handlebars.registerHelper('escaper', function(words) {		 
   if(words){
	   return words.replace(/\n/g, "\\n").replace(/\r/g, "\\n").replace(/"/g, '\\"');
   }
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
 
         <script src="integration/js/getSheetData.js"/>
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
      var trueFalse=[{"id":"T" , "name":"true"}, {"id":"F" , "name":"false"}];
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
      var emptySheet=false;
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
   
      let text='<xsl:value-of select="eas:i18n(&quot;If you are starting with a blank Launchpad we suggest you load your catalogue data, e.g. Capabilities, Processes, Applications, Services, etc.  Upload, publish then re-export here, using the Download Excel File button.  This will populate the data-driven drop-downs for you&quot;)"/>';
 
      function createEmptyWorkbookFromJSON(){
         $('#infoBox').show()
      $('#infoBox').html(text)
         dataRows.sheets.forEach((e)=>{
          
            if(e.visible!==false || e.id == 'appcapLookup'|| e.id == 'indivLookup'){
               if(e.id!='country'){ 
                  e.data=[];
               }
            }
         })

    
         $('.box').css('border-left','25px solid #d3d3d3')
         switchedOn=[];
         emptySheet=true;
         createWorkbookFromJSON();
      }
      


      function createWorkbookFromJSON() {
		var workbook = new ExcelJS.Workbook();
	   
      var uncheckedIds = $('input[type="checkbox"]:not(:checked)').map(function() {
        return this.id;
    }).toArray();

    let filteredElements = dataRows.sheets.filter(element => !uncheckedIds.includes(element.id));

		// Gather values for the dropdown lists
		let dropdownValues = {};
		filteredElements.forEach(sheet => {
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
		filteredElements.forEach(sheet => {
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
        const totalRows = dataRowCount + 200;

for (let rowNumber = sheet.headerRow + 1; rowNumber &lt;= totalRows; rowNumber++) {
    let row = worksheet.getRow(rowNumber);

    if (sheet.concatenate) {
        const formulaColumn = sheet.concatenate.column;
        const formulaType = sheet.concatenate.type;
        let formulaTemplate = sheet.concatenate.formula;

        // Apply formula only if the row is beyond the header row
        let dynamicFormula = formulaType + '(' + formulaTemplate.replace(/[A-Z]/g, match => `${match}${rowNumber}`) + ')';
        row.getCell(formulaColumn).value = { formula: dynamicFormula, result: '' };
    }

    // Make sure to commit the row to the worksheet
    row.commit();
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

      if(emptySheet==true){
         dataRows = {"sheets": []}; 
         emptySheet=false;   
      }

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
<xsl:template match="node()" mode="lifecycleModels">
   <xsl:variable name="lm" select="key('lifecycleModelUsage', current()/name)"/>
   {
      "id":"<xsl:value-of select="current()/name"/>",
      "type":"<xsl:value-of select="current()/type"/>",
      "subject":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'lifecycle_model_subject']/value"/>",
		<xsl:variable name="tempName" as="map(*)" select="map{'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name', 'relation_name')]/value,'}',')'),'{',')'))}"></xsl:variable>
		<xsl:variable name="result" select="serialize($tempName, map{'method':'json', 'indent':true()})"/>  
		<xsl:value-of select="substring-before(substring-after($result,'{'),'}')"></xsl:value-of>,
      "dates":[<xsl:for-each select="$lm">
        {"id":"<xsl:value-of select="current()/name"/>",
        "lifecycle_status":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'lcm_lifecycle_status']/value"/>",
        "date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'lcm_status_start_date_iso_8601']/value"/>",
	      }<xsl:if test="position()!=last()">,</xsl:if>
      </xsl:for-each>]
   }<xsl:if test="position()!=last()">,</xsl:if>

</xsl:template>
</xsl:stylesheet>  
