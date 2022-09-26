<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8" media-type="application/ms-excel"/>


	<!--
        * Copyright © 2008-2019 Enterprise Architecture Solutions Limited.
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
	<!-- 20.05.2019 JM/JP	Created -->
    <xsl:variable name="sites" select="/node()/simple_instance[type = 'Site']"/>
    <xsl:variable name="countries" select="/node()/simple_instance[type = 'Geographic_Region']"/>
    <xsl:variable name="businessCriticality" select="/node()/simple_instance[type = 'Business_Criticality']"/>
    <xsl:variable name="businessDomains" select="/node()/simple_instance[type = 'Business_Domain']"/>
    <xsl:variable name="businessCapabilities" select="/node()/simple_instance[type = 'Business_Capability']"/>
    <xsl:variable name="applicationCapabilities" select="/node()/simple_instance[type = 'Application_Capability']"/>
    <xsl:variable name="phyProc" select="/node()/simple_instance[type = 'Physical_Process']"/>
  <xsl:variable name="busProcesses" select="/node()/simple_instance[type = 'Business_Process']"/>
  <xsl:variable name="busProc" select="$busProcesses[own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value=$phyProc/name]"/>
   <xsl:variable name="a2r" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
 
   <xsl:variable name="act2role" select="$a2r[own_slot_value[slot_reference = 'performs_physical_processes']/value=$phyProc/name]"/>
   <xsl:variable name="actors" select="/node()/simple_instance[type = 'Group_Actor']"/>
   <xsl:variable name="busRole" select="/node()/simple_instance[type = ('Group_Business_Role','Individual_Business_Role')][own_slot_value[slot_reference = 'bus_role_played_by_actor']/value=$act2role/name]"/>
   
  <xsl:variable name="dataRoles" select="$busRole[own_slot_value[slot_reference='name']/value=('Data Owner','Data Steward','Data Standard Owner')]"/> 
  <xsl:variable name="dataRolesa2r" select="$a2r[name = $dataRoles/own_slot_value[slot_reference='act_to_role_to_role']/value]"/> 
   <xsl:variable name="products" select="/node()/simple_instance[type = 'Product_Type']"/>
   <xsl:variable name="busprocessfamily" select="/node()/simple_instance[type = 'Business_Process_Family']"/>
   <xsl:variable name="siteswithActors" select="$sites[name=$actors/own_slot_value[slot_reference='actor_based_at_site']/value]"/>
   <xsl:variable name="actorsWithSites" select="$actors[own_slot_value[slot_reference='actor_based_at_site']/value=$siteswithActors/name]"/> 
   <xsl:variable name="applicationServices" select="/node()/simple_instance[type = 'Application_Service']"/>    
   <xsl:variable name="allapplications" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/> 
	 <xsl:variable name="applications" select="/node()/simple_instance[type = ('Composite_Application_Provider')]"/>  
    <xsl:variable name="codebase" select="/node()/simple_instance[type = 'Codebase_Status']"/>  
    <xsl:variable name="delivery" select="/node()/simple_instance[type = 'Application_Delivery_Model']"/>  
    <xsl:variable name="lifecycle" select="/node()/simple_instance[type = 'Lifecycle_Status']"/>
    <xsl:variable name="techlifecycle" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>
    <xsl:variable name="informationRepresentation" select="/node()/simple_instance[type = 'Information_Representation']"/> 
    <xsl:variable name="aprs" select="/node()/simple_instance[type = 'Application_Provider_Role']"/> 
    <xsl:variable name="tprs" select="/node()/simple_instance[type = 'Technology_Product_Role']"/> 
    <xsl:variable name="groupBusinessRole" select="/node()/simple_instance[type = 'Group_Business_Role']"/> 
    <xsl:variable name="appUser" select="$groupBusinessRole[own_slot_value[slot_reference='name']/value='Application Organisation User']"/> 
    <xsl:variable name="technodes" select="/node()/simple_instance[type = 'Technology_Node']"/> 
    <xsl:variable name="appswinstance" select="/node()/simple_instance[type = 'Application_Software_Instance'][own_slot_value[slot_reference='technology_instance_deployed_on_node']/value=$technodes/name]"/> 
  <xsl:variable name="appsdeployment" select="/node()/simple_instance[type = 'Application_Deployment'][own_slot_value[slot_reference='application_deployment_technology_instance']/value=$appswinstance/name]"/> 
  <xsl:variable name="deploymentRole" select="node()/simple_instance[type = 'Deployment_Role']"/>
  <xsl:variable name="appsvc2busproc" select="/node()/simple_instance[type = 'APP_SVC_TO_BUS_RELATION']"/>
  <xsl:variable name="techDomain" select="/node()/simple_instance[type='Technology_Domain']"/>
  <xsl:variable name="techCapabilities" select="/node()/simple_instance[type='Technology_Capability']"/>
  <xsl:variable name="techComponents" select="/node()/simple_instance[type='Technology_Component']"/>
  <xsl:variable name="techSuppliers" select="/node()/simple_instance[type='Supplier']"/>
  <xsl:variable name="techProdFams" select="/node()/simple_instance[type='Technology_Product_Family']"/>
  <xsl:variable name="techProducts" select="/node()/simple_instance[type='Technology_Product']"/>
  <xsl:variable name="techDeliveryModel" select="/node()/simple_instance[type='Technology_Delivery_Model']"/>
  <xsl:variable name="techStandards" select="/node()/simple_instance[type='Technology_Provider_Standard_Specification']"/>
  <xsl:variable name="enumsStandards" select="/node()/simple_instance[type='Standard_Strength']"/>
  <xsl:variable name="dataSubjects" select="/node()/simple_instance[type='Data_Subject']"/>
  <xsl:variable name="dataObjects" select="/node()/simple_instance[type='Data_Object']"/>
  <xsl:variable name="synonyms" select="/node()/simple_instance[type='Synonym']"/>
  <xsl:variable name="dataCategory" select="/node()/simple_instance[type='Data_Category']"/>
  <xsl:variable name="individual" select="/node()/simple_instance[type='Individual_Actor']"/>
  <xsl:variable name="DOA" select="/node()/simple_instance[type='Data_Object_Attribute']"/>
  <xsl:variable name="primitiveDataObjects" select="/node()/simple_instance[type='Primitive_Data_Object']"/>
  <xsl:variable name="dataAttributeCardinality" select="/node()/simple_instance[type='Data_Attribute_Cardinality']"/>
  <xsl:variable name="physbusApp" select="/node()/simple_instance[type='APP_PRO_TO_PHYS_BUS_RELATION']"/>
  <xsl:variable name="elemStyles" select="/node()/simple_instance[type='Element_Style']"/>
	<xsl:template match="knowledge_base">
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Title>Capture v4 NEW FORMAT</Title>
  <Author>EAS ltd</Author>
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2011-10-13T14:06:02Z</Created>
  <LastSaved>2019-08-08T11:00:20Z</LastSaved>
  <Company>EAS Ltd</Company>
  <Version>16.00</Version>
 </DocumentProperties>
 <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <ContentTypeId dt:dt="string">0x010100D23CB377CC937043B7A9F1C20506A289</ContentTypeId>
  <TaxKeyword dt:dt="string"></TaxKeyword>
 </CustomDocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>13700</WindowHeight>
  <WindowWidth>28560</WindowWidth>
  <WindowTopX>40</WindowTopX>
  <WindowTopY>560</WindowTopY>
  <TabRatio>871</TabRatio>
  <ActiveSheet>1</ActiveSheet>
  <FirstVisibleSheet>1</FirstVisibleSheet>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
  <DisplayInkNotes>False</DisplayInkNotes>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s1021" ss:Name="appOwner">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Verdana" x:Family="Swiss" ss:Color="#0000FF"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s16" ss:Name="ColumnHeading">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#CCCCFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1020" ss:Name="Hyperlink">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#0000FF"
    ss:Underline="Single"/>
  </Style>
  <Style ss:ID="s20" ss:Name="indexColumnHeadingStyleId">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#000000" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s19" ss:Name="IndexSubheading">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s17" ss:Name="SheetCell">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1019" ss:Name="SheetCell 3">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s18" ss:Name="SheetHeading">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1025" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1026">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1027">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1028">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1029">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1030" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1031">
   <Interior/>
  </Style>
  <Style ss:ID="s1032">
   <Alignment ss:Vertical="Bottom"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1033">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1034">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1035" ss:Parent="s16">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#CCCCFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1036">
   <Borders/>
  </Style>
  <Style ss:ID="s1037">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1038" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1039" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1040">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1041" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1042" ss:Parent="s16">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#CCCCFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1043" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1044">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1045">
   <Alignment ss:Vertical="Bottom"/>
  </Style>
  <Style ss:ID="s1046">
   <Borders/>
   <Interior/>
  </Style>
  <Style ss:ID="s1050">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1051">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1052">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1053">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1054">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1055">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1056">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1057">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1058">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
  </Style>
  <Style ss:ID="s1059">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1060">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1061">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1063">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1064">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1065">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1066">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1067">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1069">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1071">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1072">
   <Alignment ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1073">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1074">
   <Alignment ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1075">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Tahoma" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1076">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Segoe UI" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1077">
   <Alignment ss:Vertical="Center" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1079">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1080">
   <Alignment ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1081">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1082">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1083">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1084">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1085">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1086">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1087">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1088">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1089">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1090">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1091">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1092">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1093">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1094">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1095" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1096">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1100">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1101">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1102">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1103">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Interior/>
  </Style>
  <Style ss:ID="s1104">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders/>
   <Interior/>
  </Style>
  <Style ss:ID="s1105" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1106">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1107">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1109">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#76933C"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1110">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1111">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1112">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1113">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1114">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1115">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1116">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#92CDDC" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1117">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1118">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1119">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"/>
  </Style>
  <Style ss:ID="s1120">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E4DFEC" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1123">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1124">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#92CDDC" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1125">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1126">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1128" ss:Parent="s1020">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1129" ss:Parent="s1020">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E4DFEC" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1131">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1132">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1133">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1134">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1135">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1136">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1137">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1138">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1139">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
  </Style>
  <Style ss:ID="s1140">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1141">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1142" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1143">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1144">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1145">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1146">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1147">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1148">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1149">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1150">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1151">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1152">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1153">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1154">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1155">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1156">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1157">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Interior ss:Color="#FDE9D9" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1158">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1159">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#595959" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1160">
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1161">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1162">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1163">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1164">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1165">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri (Body)" ss:Size="11" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1166">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri (Body)" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1167">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1168">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri (Body)" ss:Size="11" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1169">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1170">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1171">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1172">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1173">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1174">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1175">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1176" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1177">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1178">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1179">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1180">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1181">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1182">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1183">
   <Borders>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#B8CCE4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1184">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#B8CCE4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1185">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#DCE6F1" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1186">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1187">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1188">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1189">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1190">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="3"
     ss:Color="#FFFFFF"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#B8CCE4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1191">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1192">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1193">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1194">
   <Alignment ss:Vertical="Top"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1195">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1199">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1200">
   <Alignment ss:Vertical="Top"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1201">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#95B3D7" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1202">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1203">
   <Alignment ss:Horizontal="Right" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1204">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1205" ss:Parent="s17">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1206">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1207">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1208">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1209">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1210">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1211">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1213">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1214">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1215">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1216">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1217">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1218">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1219">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1220" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1221">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1222">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1223">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#DCE6F1" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1224">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#DCE6F1" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1225">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1226">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1227">
   <Alignment ss:Vertical="Bottom"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1228">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1229">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1230">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1233" ss:Parent="s1019">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1234">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1235">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1236">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1238" ss:Parent="s17">
   <Borders/>
  </Style>
  <Style ss:ID="s1239" ss:Parent="s17">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1240">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1241">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1242">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1243">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1244" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1245" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1246" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1247">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#B8CCE4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1248">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1249">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1250">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1251" ss:Parent="s17">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1252">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1253" ss:Parent="s1021">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Verdana" x:Family="Swiss" ss:Size="11"/>
  </Style>
  <Style ss:ID="s1254">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Verdana" x:Family="Swiss" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1255" ss:Parent="s17">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1256" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1257" ss:Parent="s16">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1258" ss:Parent="s16">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1259">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"
     ss:Color="#FFFFFF"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1260">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#DDD9C4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1261">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1262">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#EEECE1" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1263">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#BFBFBF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1266">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1269">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1271" ss:Parent="s18">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1272">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1289" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1292">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1296" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1297">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1298" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1299">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1300">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1302">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1303" ss:Parent="s16">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1305">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="Allowed_CRUD_Values"
   ss:RefersTo="='REFERENCE DATA'!R9C3:R9C5"/>
  <NamedRange ss:Name="App_Cap_Cat"
   ss:RefersTo="='CLASSIFICATION DATA'!R25C3:R25C6"/>
  <NamedRange ss:Name="App_Delivery_Models"
   ss:RefersTo="='Application Delivery Models'!R7C3:R24C3"/>
  <NamedRange ss:Name="App_Dif_Level"
   ss:RefersTo="='CLASSIFICATION DATA'!R24C3:R24C5"/>
  <NamedRange ss:Name="App_Type" ss:RefersTo="='REFERENCE DATA'!R46C3:R46C8"/>
  <NamedRange ss:Name="Application_Codebases"
   ss:RefersTo="='Application Codebases'!R7C3:R24C3"/>
  <NamedRange ss:Name="Application_Delivery_Model"
   ss:RefersTo="='REFERENCE DATA'!R21C3:R21C5"/>
  <NamedRange ss:Name="AppProRole" ss:RefersTo="=CONCATS!R8C4:R200C4"/>
  <NamedRange ss:Name="Area" ss:RefersTo="='CLASSIFICATION DATA'!R23C3:R23C5"/>
  <NamedRange ss:Name="Bus_Cap_type"
   ss:RefersTo="='CLASSIFICATION DATA'!R22C3:R22C4"/>
  <NamedRange ss:Name="Bus_Caps" ss:RefersTo="='Business Capabilities'!R8C3:R127C3"/>
  <NamedRange ss:Name="Languages" ss:RefersTo="='REFERENCE DATA'!R49C3:R49C17"/>
  <NamedRange ss:Name="Lifecycle_Statii" ss:RefersTo="='REFERENCE DATA'!R8C3:R8C11"/>
  <NamedRange ss:Name="Organisations" ss:RefersTo="=Organisations!R7C3:R79C3"/>
  <NamedRange ss:Name="Reference_Model_Layers"
   ss:RefersTo="='REFERENCE DATA'!R50C3:R50C7"/>
  <NamedRange ss:Name="Servers" ss:RefersTo="=Servers!R8C3:R178C3"/>
  <NamedRange ss:Name="Tech_Compliance_Levels"
   ss:RefersTo="='Standards Compliance Levels'!R7C3:R24C3"/>
  <NamedRange ss:Name="Tech_Delivery_Models"
   ss:RefersTo="='Technology Delivery Models'!R7C3:R24C3"/>
  <NamedRange ss:Name="Tech_Svc_Quality_Values" ss:RefersTo="=CONCATS!R7C2:R145C2"/>
  <NamedRange ss:Name="Tech_Vendor_Release_Statii"
   ss:RefersTo="='Tech Vendor Release Statii'!R7C3:R24C3"/>
  <NamedRange ss:Name="Technology_Capabilities"
   ss:RefersTo="='Technology Capabilities'!R7C3:R39C3"/>
  <NamedRange ss:Name="Technology_Components"
   ss:RefersTo="='Technology Components'!R7C3:R169C3"/>
  <NamedRange ss:Name="Technology_Domains"
   ss:RefersTo="='Technology Domains'!R7C3:R72C3"/>
  <NamedRange ss:Name="Technology_Product_Families"
   ss:RefersTo="='Technology Product Families'!R7C3:R41C3"/>
  <NamedRange ss:Name="Technology_Product_Suppliers"
   ss:RefersTo="='Technology Suppliers'!R7C3:R136C3"/>
  <NamedRange ss:Name="Technology_Products"
   ss:RefersTo="='Technology Products'!R7C3:R753C3"/>
  <NamedRange ss:Name="Usage_Lifecycle_Statii"
   ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
  <NamedRange ss:Name="Valid_Actor_Category"
   ss:RefersTo="='CLASSIFICATION DATA'!R17C3:R17C4"/>
  <NamedRange ss:Name="Valid_App_Caps"
   ss:RefersTo="='Application Capabilities'!R8C3:R100C3"/>
  <NamedRange ss:Name="Valid_App_Category"
   ss:RefersTo="='REFERENCE DATA'!R41C3:R41C4"/>
  <NamedRange ss:Name="Valid_App_Classification"
   ss:RefersTo="='REFERENCE DATA'!R41C3:R41C4"/>
  <NamedRange ss:Name="Valid_App_Service_Statii"
   ss:RefersTo="='REFERENCE DATA'!R23C3:R23C4"/>
  <NamedRange ss:Name="Valid_App_Services"
   ss:RefersTo="='Application Services'!R7C3:R172C3"/>
  <NamedRange ss:Name="Valid_Application_Capability_Types"
   ss:RefersTo="='CLASSIFICATION DATA'!R10C3:R10C8"/>
  <NamedRange ss:Name="Valid_Application_Provider_Categories"
   ss:RefersTo="='CLASSIFICATION DATA'!R16C3:R16C5"/>
  <NamedRange ss:Name="Valid_Application_Purpose"
   ss:RefersTo="='REFERENCE DATA'!R24C3:R24C9"/>
  <NamedRange ss:Name="Valid_Best_Practice_Categories"
   ss:RefersTo="='REFERENCE DATA'!R42C3:R42C9"/>
  <NamedRange ss:Name="Valid_Bus_Comp_Categories"
   ss:RefersTo="='REFERENCE DATA'!R10C3:R10C5"/>
  <NamedRange ss:Name="Valid_Bus_Doms" ss:RefersTo="='Business Domains'!R8C3:R25C3"/>
  <NamedRange ss:Name="Valid_Bus_Proc"
   ss:RefersTo="='Business Processes'!R8C3:R314C3"/>
  <NamedRange ss:Name="Valid_Business_Criticality"
   ss:RefersTo="='REFERENCE DATA'!R35C3:R35C5"/>
  <NamedRange ss:Name="Valid_Business_Domain_Layers"
   ss:RefersTo="='CLASSIFICATION DATA'!R13C3:R13C8"/>
  <NamedRange ss:Name="Valid_Business_Issue_Categories"
   ss:RefersTo="='REFERENCE DATA'!R45C3:R45C11"/>
  <NamedRange ss:Name="Valid_Business_Processes"
   ss:RefersTo="='Business Processes'!R7C3:R859C3"/>
  <NamedRange ss:Name="Valid_Calendar_Quarters"
   ss:RefersTo="='REFERENCE DATA'!R18C3:R18C6"/>
  <NamedRange ss:Name="Valid_Calendar_Year"
   ss:RefersTo="='REFERENCE DATA'!R19C3:R19C20"/>
  <NamedRange ss:Name="Valid_Composite_Applications"
   ss:RefersTo="=Applications!R7C3:R275C3"/>
  <NamedRange ss:Name="Valid_Countries"
   ss:RefersTo="='REFERENCE DATA'!R11C3:R11C190"/>
  <NamedRange ss:Name="Valid_Data_Aquisition_Methods"
   ss:RefersTo="='REFERENCE DATA'!R13C3:R13C9"/>
  <NamedRange ss:Name="Valid_Data_Attribute_Cardinality"
   ss:RefersTo="='REFERENCE DATA'!R22C3:R22C8"/>
  <NamedRange ss:Name="Valid_Data_Categories"
   ss:RefersTo="='REFERENCE DATA'!R12C3:R12C6"/>
  <NamedRange ss:Name="Valid_Day_In_Month"
   ss:RefersTo="='REFERENCE DATA'!R16C3:R16C33"/>
  <NamedRange ss:Name="Valid_Deployment_Roles"
   ss:RefersTo="='REFERENCE DATA'!R44C3:R44C10"/>
  <NamedRange ss:Name="Valid_Driver_Classifications"
   ss:RefersTo="='CLASSIFICATION DATA'!R9C3:R9C6"/>
  <NamedRange ss:Name="Valid_EA_Standard_Lifcycle_Statii"
   ss:RefersTo="='REFERENCE DATA'!R34C2:R34C3"/>
  <NamedRange ss:Name="Valid_End_Flow" ss:RefersTo="='REFERENCE DATA'!R26C3:R26C3"/>
  <NamedRange ss:Name="Valid_Environments"
   ss:RefersTo="='REFERENCE DATA'!R48C3:R48C9"/>
  <NamedRange ss:Name="Valid_Goal_Types"
   ss:RefersTo="='CLASSIFICATION DATA'!R8C3:R8C5"/>
  <NamedRange ss:Name="Valid_High_Medium_Low"
   ss:RefersTo="='REFERENCE DATA'!R29C3:R29C5"/>
  <NamedRange ss:Name="Valid_Information_Representation_Categories"
   ss:RefersTo="='CLASSIFICATION DATA'!R18C3:R18C9"/>
  <NamedRange ss:Name="Valid_Month_In_Year"
   ss:RefersTo="='REFERENCE DATA'!R17C3:R17C14"/>
  <NamedRange ss:Name="Valid_Obligation_Lifecycle_Status"
   ss:RefersTo="='REFERENCE DATA'!R38C3:R38C4"/>
  <NamedRange ss:Name="Valid_Owning_Org"
   ss:RefersTo="='REFERENCE DATA'!R40C3:R40C7"/>
  <NamedRange ss:Name="Valid_Pimitive_Data_Objects"
   ss:RefersTo="='REFERENCE DATA'!R39C3:R39C6"/>
  <NamedRange ss:Name="Valid_Planning_Actions"
   ss:RefersTo="='REFERENCE DATA'!R27C3:R27C10"/>
  <NamedRange ss:Name="Valid_Position_in_Parent"
   ss:RefersTo="='REFERENCE DATA'!R47C3:R47C5"/>
  <NamedRange ss:Name="Valid_Principle_Compliance_Level"
   ss:RefersTo="='REFERENCE DATA'!R33C3:R33C7"/>
  <NamedRange ss:Name="Valid_Product_Type_Categories"
   ss:RefersTo="='CLASSIFICATION DATA'!R15C2:R15C3"/>
  <NamedRange ss:Name="Valid_Project_Approval_Status"
   ss:RefersTo="='REFERENCE DATA'!R31C3:R31C6"/>
  <NamedRange ss:Name="Valid_Project_Statii"
   ss:RefersTo="='REFERENCE DATA'!R20C3:R20C12"/>
  <NamedRange ss:Name="Valid_Reporting_Line_Strength"
   ss:RefersTo="='REFERENCE DATA'!R36C3:R36C4"/>
  <NamedRange ss:Name="Valid_Secured_Actions"
   ss:RefersTo="='REFERENCE DATA'!R28C3:R28C7"/>
  <NamedRange ss:Name="Valid_Sites" ss:RefersTo="=Sites!R8C3:R8C3"/>
  <NamedRange ss:Name="Valid_Skill_Level"
   ss:RefersTo="='REFERENCE DATA'!R37C3:R37C5"/>
  <NamedRange ss:Name="Valid_Skill_Qualifiers"
   ss:RefersTo="='CLASSIFICATION DATA'!R19C3:R19C6"/>
  <NamedRange ss:Name="Valid_Standardisation_Level"
   ss:RefersTo="='REFERENCE DATA'!R30C3:R30C5"/>
  <NamedRange ss:Name="Valid_Start_Flow"
   ss:RefersTo="='REFERENCE DATA'!R25C3:R25C3"/>
  <NamedRange ss:Name="Valid_Support_Types"
   ss:RefersTo="='CLASSIFICATION DATA'!R21C3:R21C6"/>
  <NamedRange ss:Name="Valid_Tech_Node_Roles"
   ss:RefersTo="='REFERENCE DATA'!R43C3:R43C8"/>
  <NamedRange ss:Name="Valid_Technology_Architecture_Tiers"
   ss:RefersTo="='CLASSIFICATION DATA'!R11C3:R11C5"/>
  <NamedRange ss:Name="Valid_Technology_Component_Usage_Types"
   ss:RefersTo="='CLASSIFICATION DATA'!R12C3:R12C4"/>
  <NamedRange ss:Name="Valid_Technology_Composite_Types"
   ss:RefersTo="='CLASSIFICATION DATA'!R14C3:R14C4"/>
  <NamedRange ss:Name="Valid_True_or_False"
   ss:RefersTo="='REFERENCE DATA'!R15C3:R15C4"/>
  <NamedRange ss:Name="Valid_YesNo"
   ss:RefersTo="='CLASSIFICATION DATA'!R20C3:R20C4"/>
 </Names>
 <Worksheet ss:Name="Table of Contents">
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1031" ss:AutoFitWidth="0"/>
   <Column ss:AutoFitWidth="0" ss:Width="394"/>
   <Column ss:AutoFitWidth="0" ss:Width="786"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1289"><Data ss:Type="String">Essential Launchpad Capture Spreadsheet</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1056"/>
   </Row>
   <Row ss:Index="5" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Project:</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Content Owner:</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Template Type:</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Template Version:</Data></Cell>
   </Row>
   <Row ss:Index="10" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s20"><Data ss:Type="String">Worksheet</Data></Cell>
    <Cell ss:StyleID="s20"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1054"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#Sites!A1"><Data
      ss:Type="String">Sites</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the Locations (Sites), including the country in which the Location (Site) exists</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Business Domains'!A1"><Data
      ss:Type="String">Business Domains</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Captures the Business Domains in scope</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Business Capabilities'!A1"><Data
      ss:Type="String">Business Capabilities</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Captures the business capabilities of your organisation.  Some columns are also required to set up the view layout</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Business Processes'!A1"><Data
      ss:Type="String">Business Processes</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Captures the Business processes and their relationship to the business capabilities.</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Business Process Family'!A1"><Data
      ss:Type="String">Business Process Family</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Used to group Business Processes into their Family  groupings</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#Organisations!A1"><Data
      ss:Type="String">Organisations</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the organisational hierarchy for the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Organisation to Sites'!A1"><Data
      ss:Type="String">Organisation to Sites</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Maps the Organisations of the enterprise to the sites at which they are based</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Application Capabilities'!A1"><Data
      ss:Type="String">Application Capabilities </Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the Application Capabilities required to support the buisness and the category to manage the structure of the view</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Application Services'!A1"><Data
      ss:Type="String">Application Services</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the Application Services required to support the business</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'App Service 2 App Capabilities'!A1"><Data
      ss:Type="String">App Service 2 App Capabilities</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Maps the Application Services to the Application Capability they support</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#Applications!A1"><Data
      ss:Type="String">Applications</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the mapping of the Application Services to the Application Capability they support</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'App Service 2 Apps'!A1"><Data
      ss:Type="String">App Service 2 Apps</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Maps the Applications to the Services they can provide</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Application to User Orgs'!A1"><Data
      ss:Type="String">Application to User Orgs</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Maps Applications to the Orgasnisations that use them</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#Servers!A1"><Data
      ss:Type="String">Servers</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the list of physical technology nodes deployed across the enterprise, and the IP address if available</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Application 2 Server'!A1"><Data
      ss:Type="String">Application 2 Server</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Maps the applications to the servers that they are hosted on, with the environment</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037" ss:HRef="#'Business Process 2 App Services'!A1"><Data
      ss:Type="String">Business Process 2 App Services</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Maps the business processes to the application services they require</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Physical Proc 2 App and Service'!A1"><Data
      ss:Type="String">Physical Process 2 App via Servuce</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Maps the Physical Business Porcess to the Application used and the Sevice it is used to provide</Data></Cell>
   </Row>
	<Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Physical Proc 2 App'!A1"><Data
      ss:Type="String">Physical Process 2 App</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Maps the Physical Business Process to the Application used directly - only use this sheet if you are unable to use the sheet above to provide the services</Data></Cell>
   </Row>   
  
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Domains'!A1"><Data
      ss:Type="String">Technology Domains</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the high level technology areas relevant to the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Capabilities'!A1"><Data
      ss:Type="String">Technology Capabilities</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the conceptual technology infrastructure capabilities supporting the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Components'!A1"><Data
      ss:Type="String">Technology Components</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the logical types of technology infrastructure supporting the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Suppliers'!A1"><Data
      ss:Type="String">Technology Suppliers</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the suppliers of Technology Products in use by the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Product Families'!A1"><Data
      ss:Type="String">Technology Product Families</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Used to group Technology Products into their Family  groupings</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Products'!A1"><Data
      ss:Type="String">Technology Products</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Captures the Technology Products in use by the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Tech Prods to User Orgs'!A1"><Data
      ss:Type="String">Tech Prods to User Orgs</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Maps Technology Products to the Orgasnisations that use them</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Tech Reference Archs'!A1"><Data
      ss:Type="String">Technology Reference Architectures</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Defines the standatd logical architectures to be used to implement IT solutons</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Tech Ref Arch Svc Quals'!A1"><Data
      ss:Type="String">Technology Reference Architecture Qualities</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Defines the non-functional service qualities associated with Technology Reference Architectures</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Tech Reference Models'!A1"><Data
      ss:Type="String">Technology Reference Models</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Defines the logical technology components that comprise Technology Reference Architectures</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'App to Tech Products'!A1"><Data
      ss:Type="String">App to Tech Products</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Used to map Applications to the Technology used</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Technology Service Qualities'!A1"><Data
      ss:Type="String">Technology Service Qualities</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captrues the non-functional service qualities (e.g. scalability) associated with Technology Reference Architectures</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128" ss:HRef="#'Tech Service Qual Vals'!A1"><Data
      ss:Type="String">Technology Service Quality Values</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captrues the values for the non-functional service qualities (e.g. scalability) and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1120" ss:HRef="#'Application Codebases'!A1"><Data
      ss:Type="String">Application Codebases</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the types of Application Codebase relevant to the enteprise and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1120" ss:HRef="#'Application Delivery Models'!A1"><Data
      ss:Type="String">Application Delivery Models</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the the different ways in which Applications are delivered and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1120" ss:HRef="#'Technology Delivery Models'!A1"><Data
      ss:Type="String">Technology Delivery Models</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures thethe different ways in which Technology infrastructure services are delivered and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1120" ss:HRef="#'Tech Vendor Release Statii'!A1"><Data
      ss:Type="String">Tech Vendor Release Statii</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the Vendor Release Statii of Technology Products and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1129" ss:HRef="#'Standards Compliance Levels'!A1"><Data
      ss:Type="String">Technology Compliance Levels</Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String">Captures the different levels of compliance defined againts Technology Product Standards and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1129"><Data ss:Type="String">Technology Adoption Statii</Data></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String">Captures and internal adoption status for a technology</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1109"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TopRowVisible>22</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>49</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R42C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R42C2:R42C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R43C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R43C2:R43C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R44C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R44C2:R44C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R45C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R45C2:R45C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R46C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R46C2:R46C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R23C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R23C2:R23C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R24C2:R28C2,R12C2:R22C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R24C2:R28C2, RC)+COUNTIF(R12C2:R22C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R39C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R39C2:R39C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R29C2:R38C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R29C2:R38C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R40C2:R41C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R40C2:R41C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R47C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R47C2:R47C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Sites">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="31"/>
   <Column ss:StyleID="s1102" ss:AutoFitWidth="0" ss:Width="41"/>
   <Column ss:AutoFitWidth="0" ss:Width="205"/>
   <Column ss:AutoFitWidth="0" ss:Width="203"/>
   <Column ss:AutoFitWidth="0" ss:Width="140"/>
   <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="25">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1289"><Data ss:Type="String">Sites</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056"><Data ss:Type="String">Used to capture a list of Sites, including the country in which the Site exists</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Country</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1101"/>
    <Cell ss:StyleID="s1036"/>
    <Cell ss:StyleID="s1036"/>
    <Cell ss:StyleID="s1036"/>
   </Row>
    <xsl:apply-templates select="$sites" mode="sites"></xsl:apply-templates>
 
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String">SITE4a4</Data></Cell>
    <Cell ss:StyleID="s1233"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1233"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String">SITE4a5</Data></Cell>
    <Cell ss:StyleID="s1233"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1233"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String">SITE4a6</Data></Cell>
    <Cell ss:StyleID="s1233"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1233"/>
   </Row>
  

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R29C5</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Valid_Countries</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Business Domains">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="44" ss:Span="1"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="155"/>
   <Column ss:AutoFitWidth="0" ss:Width="337"/>
   <Column ss:AutoFitWidth="0" ss:Width="166"/>
   <Column ss:AutoFitWidth="0" ss:Width="170"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="5" ss:StyleID="s1289"><Data ss:Type="String">Business Domains</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="5" ss:StyleID="s1056"><Data ss:Type="String">Used to capture the Business Domains in scope</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1145"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1146"><Data ss:Type="String">Parent Business Domain</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Check Parent Domain</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="2" ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1160"/>
   </Row>
          <xsl:apply-templates select="$businessDomains" mode="businessDomains"></xsl:apply-templates>
   
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1143"><Data ss:Type="String">BD1a1</Data></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Bus_Doms"/></Cell>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Domains'!C[-3],1,0)),&quot;Parent must be defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R27C5</Range>
   <Type>List</Type>
   <Value>'Business Domains'!R8C3:R400C3</Value>
  </DataValidation>
  
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3,R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R27C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Business Capabilities">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="66"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="35"/>
   <Column ss:Index="3" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="188"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="291"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="125" ss:Span="1"/>
   <Column ss:Index="7" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="130"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="172"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="122"/>
   <Column ss:Index="11" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="226"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="240"/>
   <Row ss:Height="20">
    <Cell ss:Index="8" ss:StyleID="s1155"><Data ss:Type="String">Checks</Data></Cell>
    <Cell ss:StyleID="s1156"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1292"><Data ss:Type="String">Business Capabilities</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="21">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1057"><Data ss:Type="String">Used to capture the business capabilities of your organisation.  Some columns are also required to set up the view layout</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s1157"><Data ss:Type="String">Root Capability</Data></Cell>
    <Cell ss:MergeAcross="2" ss:StyleID="s1057"
     ss:Formula="=IF((COUNTA(C[-1])&gt;6),&quot;ERROR: Only one root node should be defined&quot;,&quot;OK&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="102">
    <Cell ss:Index="8"><Data ss:Type="String">Position in Parent</Data></Cell>
    <Cell ss:MergeAcross="2" ss:StyleID="s1057"
     ss:Formula="=IF((COUNTA(C[-3]))&gt;((COUNTA(C[-6])*0.2)),&quot;You only need to define position in parent for the top level capabilities against the root capability, just check these are OK&quot;,&quot;OK&quot;)"><Data
      ss:Type="String">You only need to define position in parent for the top level capabilities against the root capability, just check these are OK</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="37">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Parent Business Capability</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Position in Parent</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Sequence Number</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Root Capability</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Business Domain</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Level</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Parent Capability Check</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Business Domain Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1051"><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1158"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1158"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">Business Domain must be already defined in Business Domains sheet</Data></Cell>
   </Row>
   <xsl:apply-templates select="$businessCapabilities" mode="businessCapabilities"/>
   <Row ss:Height="17" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String">BC2a1</Data></Cell>
    <Cell ss:StyleID="s1025"><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1209"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1209"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String">BC3</Data></Cell>
    <Cell ss:StyleID="s1025"><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1209"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1209"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <LeftColumnVisible>1</LeftColumnVisible>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>7</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
    <Range>R8C5:R1000C5,R8C8:R1000C8</Range>
   <Type>List</Type>
   <Value>'Business Capabilities'!R8C3:R1000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R127C6</Range>
   <Type>List</Type>
   <Value>Valid_Position_in_Parent</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C9:R1270C9</Range>
   <Type>List</Type>
   <Value>'Business Domains'!R8C3:R300C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3,R6C10,R6C5,R6C7</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C10:R6C10, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4,R6C6,R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)+COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R7C3:R7C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R127C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
   <Condition>
    <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R127C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R127C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R127C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R8C3:R127C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R127C12</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Business Processes">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="33"/>
   <Column ss:Index="3" ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="172"/>
   <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="294"/>
   <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="198" ss:Span="3"/>
   <Column ss:Index="9" ss:AutoFitWidth="0" ss:Width="147" ss:Span="3"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
    <Cell ss:StyleID="s1100"/>
    <Cell ss:StyleID="s1058"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1269"><Data ss:Type="String">Business Processes</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"><Data ss:Type="String">Captures the Business processes and their relationship to the business capabilities.</Data></Cell>
    <Cell ss:StyleID="s1100"/>
    <Cell ss:StyleID="s1058"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
    <Cell ss:StyleID="s1100"/>
    <Cell ss:StyleID="s1058"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
    <Cell ss:StyleID="s1100"/>
    <Cell ss:StyleID="s1058"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1149"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1149"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1150"><Data ss:Type="String">Parent Capability 1</Data></Cell>
    <Cell ss:StyleID="s1150"><Data ss:Type="String">Parent Capability 2</Data></Cell>
    <Cell ss:StyleID="s1150"><Data ss:Type="String">Parent Capability 3</Data></Cell>
    <Cell ss:StyleID="s1150"><Data ss:Type="String">Parent Capability 4</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Check Parent Capability 1</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Check Parent Capability 2</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Check Parent Capability 3</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Check Parent Capability 4</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1160"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data><NamedCell
      ss:Name="Valid_Business_Processes"/></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1229"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1230"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-6],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1230"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-7],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1230"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1230"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
   </Row>
      
    <xsl:apply-templates select="$busProcesses" mode="businessProcesses"/>
      
   <Row ss:AutoFitHeight="0" ss:Height="18">
    <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String">BP1</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Valid_Bus_Proc"/><NamedCell
      ss:Name="Valid_Business_Processes"/></Cell>
    <Cell ss:StyleID="s1059"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-6],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-7],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
   
  
   
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <LeftColumnVisible>2</LeftColumnVisible>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R1000C5,R8C6:R1000C6,R8C7:R1000C7,R8C8:R1000C8</Range>
      <Type>List</Type>
      <Value>'Business Capabilities'!R8C3:R1000C3</Value>
    </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C9:R314C12</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Business Process Family">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="46"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="161"/>
   <Column ss:AutoFitWidth="0" ss:Width="200"/>
   <Column ss:AutoFitWidth="0" ss:Width="238"/>
   <Column ss:AutoFitWidth="0" ss:Width="147" ss:Span="1"/>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1111"><Data ss:Type="String">Business Process Families</Data></Cell>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Used to group Business Processes into their Family  groupings</Data></Cell>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Business Process Family</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Contained Business Processes</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Business Process Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="5">
    <Cell ss:Index="2" ss:StyleID="s1160"/>
    <Cell ss:StyleID="s1160"/>
    <Cell ss:StyleID="s1160"/>
    <Cell ss:StyleID="s1160"/>
    <Cell ss:StyleID="s1228"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&quot;Business Process must be already defined in Business Process sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
      
    <xsl:apply-templates select="$busprocessfamily" mode="busprocessfamily"/>  
 
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R200C5</Range>
   <Type>List</Type>
   <Value>'Business Processes'!R8C3:R4000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R61C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Organisations">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="189"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="293"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="179"/>
   <Column ss:StyleID="s1117" ss:AutoFitWidth="0" ss:Width="75"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="164"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Organisations</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Capture the organisations and hierarchy/structure</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1151"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Parent Organisation</Data></Cell>
    <Cell ss:StyleID="s1152"><Data ss:Type="String">External?</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Parent Organisation Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="7" ss:StyleID="s1162"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&quot;Organisation must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  <xsl:apply-templates select="$actors" mode="actors"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String">GA2</Data></Cell>
    <Cell ss:StyleID="s1112"><NamedCell ss:Name="Organisations"/></Cell>
    <Cell ss:StyleID="s1112"/>
    <Cell ss:StyleID="s1112"/>
    <Cell ss:StyleID="s1118"><Data ss:Type="String">false</Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&quot;Organisation must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>

   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R79C6</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Valid_True_or_False</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R790C5</Range>
   <Type>List</Type>
   <Value>'Organisations'!R8C3:R790C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R79C7</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Organisation to Sites">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="180"/>
   <Column ss:AutoFitWidth="0" ss:Width="237"/>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1111"><Data ss:Type="String">Organisation to Sites</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Map which organisations use which sites</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Organisation</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Site</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Organisation Checker</Data></Cell>
    <Cell ss:StyleID="s1159"><Data ss:Type="String">Site Checker</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="4"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-1],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Sites!C[-2],1,0)),&quot;Site must be already defined in Sites sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    
      <xsl:apply-templates select="$actorsWithSites" mode="actorsWithSites"/>  

   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1153"/>
    <Cell ss:StyleID="s1040"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-1],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Sites!C[-2],1,0)),&quot;Site must be already defined in Sites sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>52</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R790C2</Range>
     <Type>List</Type>
     <Value>'Organisations'!R8C3:R790C3</Value>
   </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R800C3</Range>
   <Type>List</Type>
   <Value>'Sites'!R8C3:R500C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R59C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Capabilities">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1045" ss:DefaultColumnWidth="66"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="49"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="209"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="326"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="145"/>
   <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="179"/>
   <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="189"/>
   <Column ss:StyleID="s1032" ss:AutoFitWidth="0" ss:Width="194"/>
   <Column ss:AutoFitWidth="0" ss:Width="156"/>
   <Column ss:StyleID="s1165" ss:AutoFitWidth="0" ss:Width="169"/>
   <Column ss:StyleID="s1166" ss:AutoFitWidth="0" ss:Width="169" ss:Span="1"/>
   <Row>
    <Cell ss:Index="9" ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1269"><Data ss:Type="String">Application Capabilities</Data></Cell>
    <Cell ss:Index="5" ss:StyleID="s1032"/>
    <Cell ss:StyleID="s1045"/>
    <Cell ss:Index="9" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1166"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the Application Capabilities required to support the buisness and the category to manage the structure of the view</Data></Cell>
    <Cell ss:Index="5" ss:StyleID="s1103"/>
    <Cell ss:Index="9" ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s1104"/>
    <Cell ss:Index="9" ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="68">
    <Cell ss:Index="5" ss:StyleID="s1272"><Data ss:Type="String">Management – Left&#10;Shared - Right&#10;Core – Top Middle&#10;Enabling – Bottom middle</Data></Cell>
    <Cell ss:Index="9" ss:StyleID="s1249"><Data ss:Type="String">Do not use top or bottom</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Description </Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">App Cap Category</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Business Domain</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Parent App Capabaility</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Suported Bus Capability</Data></Cell>
    <Cell ss:StyleID="s1164"><Data ss:Type="String">Reference Model Layer</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Business Domain Checker</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Parent App Capability Checker</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Suported Bus Capability Checker</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9">
    <Cell ss:Index="2" ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1034"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:Index="10" ss:StyleID="s1168"/>
    <Cell ss:StyleID="s1168"/>
    <Cell ss:StyleID="s1168"/>
   </Row>
     <xsl:apply-templates select="$applicationCapabilities" mode="applicationCapabilities"/>    
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1034"><Data ss:Type="String">AC1a1</Data></Cell>
    <Cell ss:StyleID="s1025"><NamedCell ss:Name="Valid_App_Caps"/></Cell>
    <Cell ss:StyleID="s1105"/>
    <Cell ss:StyleID="s1034"/>
    <Cell ss:StyleID="s1105"/>
    <Cell ss:StyleID="s1105"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&quot;Application Capability must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&quot;Business Capability must be already defined in the Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>31</TabColorIndex>
   <Selected/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>56</TopRowBottomPane>
   <SplitVertical>3</SplitVertical>
   <LeftColumnRightPane>3</LeftColumnRightPane>
   <ActivePane>0</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>1</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>6</ActiveRow>
    </Pane>
    <Pane>
     <Number>0</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>4</ActiveCol>
     <RangeSelection>R8C5:R139C5</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C6:R1000C6</Range>
     <Type>List</Type>
     <Value>'Business Domains'!R8C3:R1000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C7:R1000C7</Range>
     <Type>List</Type>
     <Value>'Application Capabilities'!R8C3:R1000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C8:R1000C8</Range>
     <Type>List</Type>
     <Value>'Business Capabilities'!R8C3:R1000C3</Value>
   </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C9:R139C9</Range>
   <Type>List</Type>
   <UseBlank/>
   <CellRangeList/>
   <Value>&quot;Left, Right, Middle&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R139C5</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Core, Management, Shared, Enabling&quot;</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3,R6C5,R6C7</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4,R6C6,R6C8</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)+COUNTIF(R6C8:R6C8, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C11</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C11:R6C11, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10,R6C12</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)+COUNTIF(R6C12:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R139C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R139C12</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Services">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1045" ss:DefaultColumnWidth="448"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="24"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="47"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="200"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="285"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="403"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="155"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="140"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1269"><Data ss:Type="String">Application Services</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="2"><Data ss:Type="String">Capture the Application Services required to support the business</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1145"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1146"><Data ss:Type="String">Description </Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">App Service Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="5">
    <Cell ss:Index="2" ss:StyleID="s1170"/>
    <Cell ss:StyleID="s1034"><NamedCell ss:Name="Valid_App_Services"/></Cell>
    <Cell ss:StyleID="s1171"/>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-2],1,0)),&quot;OK&quot;,&quot;These Services look like your applications, try and break them down into what the applications does at a high level, 2-6 per application is about right&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
      <xsl:apply-templates select="$applicationServices" mode="applicationServices"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R151C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="App Service 2 App Capabilities">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1045" ss:DefaultColumnWidth="66"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="218"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="253"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="192"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="219"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s1106"><Data ss:Type="String">Application Capability to Application Service</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Capture the mapping of the Application Services to the Application Capability they support</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1169"><Data ss:Type="String">Application Capability</Data></Cell>
    <Cell ss:StyleID="s1037"><Data ss:Type="String">Application Service</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">App Capability Check</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Application Service Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8" ss:StyleID="s1032">
    <Cell ss:Index="2" ss:StyleID="s1226"/>
    <Cell ss:StyleID="s1177"/>
    <Cell ss:StyleID="s1227"/>
    <Cell ss:StyleID="s1227"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
         <xsl:apply-templates select="$applicationServices" mode="applicationCapServices"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1176"/>
    <Cell ss:StyleID="s1176"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Capabilities'!C[-1],1,0)),&quot;Application Capability must be already defined in Application Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>18</ActiveRow>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R4000C2</Range>
     <Type>List</Type>
     <Value>'Application Capabilities'!R8C3:R1000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C3:R4000C3</Range>
     <Type>List</Type>
     <Value>'Application Services'!R8C3:R4000C3</Value>
   </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C4:R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R97C4</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R97C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Applications">
  <Names>
   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=Applications!R6C2:R45C5"
    ss:Hidden="1"/>
   <NamedRange ss:Name="Print_Area" ss:RefersTo="=Applications!R6C2:R45C4"/>
  </Names>
  <Table ss:ExpandedColumnCount="10"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1036" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="36"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="50"/>
   <Column ss:StyleID="s1066" ss:AutoFitWidth="0" ss:Width="184"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="267"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="129"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="158"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="114"/>
   <Column ss:StyleID="s1036" ss:AutoFitWidth="0" ss:Width="126" ss:Span="2"/>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1065"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1296"><Data ss:Type="String">Applications</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1297"><Data ss:Type="String">Captures information about the Applications used within the organisation</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1065"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1037"><Data ss:Type="String">ID</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font
        html:Color="#000000">                      </Font><Font html:Size="9"
        html:Color="#000000">A unique ID for the Application</Font><Font
        html:Color="#000000">                   </Font></ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1037"><Data ss:Type="String">Name</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The name of the Application</Font>                   </ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1037"><Data ss:Type="String">Description</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A description of the functionality provided by the Application</Font>                   </ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1037"><Data ss:Type="String">Type</Data><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1037"><Data ss:Type="String">Lifecycle Status</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Delivery Model</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Type Check</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Lifecycle Check</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Delivery Model Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="5" ss:StyleID="s1063"><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:Index="8" ss:StyleID="s1179"/>
    <Cell ss:StyleID="s1179"/>
    <Cell ss:StyleID="s1179"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(App_Delivery_Models,RC[-3]),&quot;OK&quot;,&quot;Delivery Model MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
      
        <xsl:apply-templates select="$applications" mode="applications"/>
   <Row ss:AutoFitHeight="0" ss:StyleID="s1046">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String">App1</Data><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1029"><NamedCell ss:Name="Print_Area"/><NamedCell
      ss:Name="_FilterDatabase"/><NamedCell ss:Name="Valid_Composite_Applications"/></Cell>
    <Cell ss:StyleID="s1027"><NamedCell ss:Name="Print_Area"/><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1028"><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1028"/>
    <Cell ss:StyleID="s1028"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(App_Type,RC[-3]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(Lifecycle_Statii,RC[-3]),&quot;OK&quot;,&quot;Lifecycle Status MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(App_Delivery_Models,RC[-3]),&quot;OK&quot;,&quot;Delivery Model MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Unsynced/>
   <FitToPage/>
   <Print>
    <FitHeight>0</FitHeight>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <Scale>43</Scale>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TabColorIndex>31</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
     <RangeSelection>R8C3:R9C3</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R2000C5</Range>
   <Type>List</Type>
   <Value>App_Type</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R2000C6</Range>
   <Type>List</Type>
   <Value>Lifecycle_Statii</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R2000C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>App_Delivery_Models</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4,R6C6</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3,R6C5,R6C7</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R2000C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="App Service 2 Apps">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1045" ss:DefaultColumnWidth="66"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="35"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="240"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="212"/>
   <Column ss:StyleID="s1045" ss:AutoFitWidth="0" ss:Width="154" ss:Span="1"/>
   <Row ss:Index="2" ss:Height="24">
    <Cell ss:Index="2" ss:StyleID="s1069"><Data ss:Type="String">Application Service to Applications</Data></Cell>
    <Cell ss:StyleID="s1069"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps the Applications to the Services they can provide</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1145"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s1146"><Data ss:Type="String">Application Service</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Check Applications</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Check Application Services</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="2" ss:StyleID="s1170"/>
    <Cell ss:StyleID="s1171"/>
    <Cell ss:StyleID="s1177"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1177"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
       <xsl:apply-templates select="$applications" mode="applicationstoservices"/>  
   <Row ss:Height="17" ss:StyleID="s1032">
    <Cell ss:Index="2" ss:StyleID="s1172"/>
    <Cell ss:StyleID="s1172"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>66</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>68</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R10000C2</Range>
     <Type>List</Type>
     <Value>'Applications'!R8C3:R5000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C3:R10000C3</Range>
     <Type>List</Type>
     <Value>'Application Services'!R8C3:R4000C3</Value>
   </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C4:R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R162C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet> 


 <Worksheet ss:Name="Information Exchanged">
  <Table ss:ExpandedColumnCount="8" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="69"/>
   <Column ss:AutoFitWidth="0" ss:Width="218"/>
   <Column ss:AutoFitWidth="0" ss:Width="377"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1298"><Data ss:Type="String">Information Exchanged</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1056"><Data ss:Type="String">Used to capture the Information exchanged between applications</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1244"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1245"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1144"/>
   </Row>
     <xsl:apply-templates select="$informationRepresentation" mode="informationRepresentation"/>  
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1143"><Data ss:Type="String">IR02</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s1239"/>
    <Cell ss:Index="8" ss:StyleID="s1238"/>
   </Row>
  
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
     <ActiveRow>13</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Application Dependencies">
  <Table ss:ExpandedColumnCount="10" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="21"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="163"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
   <Column ss:AutoFitWidth="0" ss:Width="104"/>
   <Column ss:AutoFitWidth="0" ss:Width="93"/>
   <Row>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1269"><Data ss:Type="String">Application Dependencies</Data></Cell>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"><Data ss:Type="String">Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data></Cell>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:Index="8"><Data ss:Type="String">Checks</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1241"><Data ss:Type="String">Source Application</Data></Cell>
    <Cell ss:StyleID="s1242"><Data ss:Type="String">Target Application</Data></Cell>
    <Cell ss:StyleID="s1242"><Data ss:Type="String">Information Exchanged</Data></Cell>
    <Cell ss:StyleID="s1241"><Data ss:Type="String">Acquisition Method</Data></Cell>
    <Cell ss:StyleID="s1243"><Data ss:Type="String">Frequency</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s1167"><Data ss:Type="String">Source Check</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Target Check</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Info Exchanged</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1240"/>
    <Cell ss:StyleID="s1235"/>
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:Index="8" ss:StyleID="s1247"/>
    <Cell ss:StyleID="s1247"/>
    <Cell ss:StyleID="s1247"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:StyleID="s1234"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1215"/>
    <Cell ss:StyleID="s1236"/>
    <Cell ss:StyleID="s1143"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="8" ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Source Application MUST match the values in Applications sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1248"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(#REF!,RC[-6]),&quot;OK&quot;,&quot;Info exchanged MUST match the values in Information Exchanged sheet.&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R10000C2,R8C3:R100000C3</Range>
     <Type>List</Type>
     <Value>'Applications'!R8C3:R5000C3</Value>
   </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R18C5</Range>
   <Type>List</Type>
   <Value>Valid_Data_Aquisition_Methods</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R10000C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Information Exchanged'!R8C3:R1000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R18C6</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R19C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application to User Orgs">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="109"/>
   <Column ss:AutoFitWidth="0" ss:Width="145"/>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1111"><Data ss:Type="String">Application to User Organisations</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Maps the Applications to the Organisations that use them.</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Organisation</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Check Applications</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Check Organisations</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1181"/>
    <Cell ss:StyleID="s1181"/>
    <Cell ss:StyleID="s1178"/>
    <Cell ss:StyleID="s1178"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  <xsl:apply-templates select="$applications" mode="apporgusers"/>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R10000C2</Range>
     <Type>List</Type>
     <Value>'Applications'!R8C3:R5000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C3:R10000C3</Range>
     <Type>List</Type>
     <Value>'Organisations'!R8C3:R5000C3</Value>
   </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C4:R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R207C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Servers">
  <Table ss:ExpandedColumnCount="6" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="37"/>
   <Column ss:AutoFitWidth="0" ss:Width="70"/>
   <Column ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="200"/>
   <Column ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
   <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="25">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1289"><Data ss:Type="String">Servers</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056"><Data ss:Type="String">Captures the list of physical technology nodes deployed across the enterprise, and the IP address if available</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">ID</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A unique ID for the server</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Hosted In</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The location of the Sever</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">IP Address</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font
        html:Color="#000000">                      </Font><Font html:Size="9"
        html:Color="#000000">The IP address of the Server</Font><Font
        html:Color="#000000">                   </Font></ss:Data></Comment></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
      
    <xsl:apply-templates select="$technodes" mode="servers"></xsl:apply-templates> 
 
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:StyleID="s1095"><Data ss:Type="String">TechNode02</Data></Cell>
    <Cell ss:StyleID="s1075"><NamedCell ss:Name="Servers"/></Cell>
    <Cell ss:StyleID="s1040"/>
    <Cell ss:StyleID="s1076"/>
   </Row>

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>3</ActiveCol>
     <RangeSelection>R8C4:R178C4</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R178C4</Range>
   <Type>List</Type>
      <Value>'Sites'!R8C3:R5000C3</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Application 2 Server">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="217"/>
   <Column ss:AutoFitWidth="0" ss:Width="236"/>
   <Column ss:AutoFitWidth="0" ss:Width="242"/>
   <Column ss:AutoFitWidth="0" ss:Width="202"/>
   <Column ss:AutoFitWidth="0" ss:Width="226"/>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:MergeAcross="2" ss:StyleID="s1299"><Data ss:Type="String">Application to Server</Data></Cell>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:MergeAcross="2" ss:StyleID="s1300"><Data ss:Type="String">Mapps the applications to the servers that they are hosted on, with the environment</Data></Cell>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1087"><Data ss:Type="String">App</Data></Cell>
    <Cell ss:StyleID="s1088"><Data ss:Type="String">Server</Data></Cell>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">Environment</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Application Checker</Data></Cell>
    <Cell ss:StyleID="s1167"><Data ss:Type="String">Server Checker</Data></Cell>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1086"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1266"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1266"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1266"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <xsl:apply-templates select="$technodes" mode="app2Serv"></xsl:apply-templates> 
   <Row ss:Height="17">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1218"/>
    <Cell ss:StyleID="s1218"/>
    <Cell ss:StyleID="s1091"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Applications!C[-2],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Servers!C[-3],1,0)),&quot;Server must be already defined in Servers sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1266"/>
   </Row>

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R11C3</Range>
   <Type>List</Type>
   <Value>Servers</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R11C4</Range>
   <Type>List</Type>
   <Value>Valid_Environments</Value>
  </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C2:R10000C2</Range>
     <Type>List</Type>
     <Value>'Applications'!R8C3:R5000C3</Value>
   </DataValidation>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
     <Range>R8C3:R10000C3</Range>
     <Type>List</Type>
     <Value>'Servers'!R8C3:R5000C3</Value>
   </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C5:R6C6</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C5:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R11C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Business Process 2 App Services">
  <Table ss:ExpandedColumnCount="6"  x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="269"/>
   <Column ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:AutoFitWidth="0" ss:Width="216"/>
   <Column ss:AutoFitWidth="0" ss:Width="277"/>
   <Column ss:AutoFitWidth="0" ss:Width="253"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="23">
    <Cell ss:Index="2" ss:StyleID="s1269"><Data ss:Type="String">Business Process to Required Application Service</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"><Data ss:Type="String">Maps the business processes to the application services they require</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1045"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1141"><Data ss:Type="String">Business Process</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Application Service</Data></Cell>
    <Cell ss:StyleID="s1141"><Data ss:Type="String">Criticality of Application Service</Data></Cell>
    <Cell ss:StyleID="s1180"><Data ss:Type="String">Check Business Process</Data></Cell>
    <Cell ss:StyleID="s1180"><Data ss:Type="String">Check Application Services</Data></Cell>
   </Row>
    
    <xsl:apply-templates select="$applicationServices" mode="busproc2services"></xsl:apply-templates>
  
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1172"/>
    <Cell ss:StyleID="s1172"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Application Services'!C[-3],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>1</SplitHorizontal>
   <TopRowBottomPane>1</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R4500C4</Range>
   <Type>List</Type>
   <Value>Valid_Business_Criticality</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R4500C3</Range>
   <Type>List</Type>
    <Value>'Application Services'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R4500C2</Range>
   <Type>List</Type>
    <Value>'Business Processes'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C6</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C5:R6C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R4500C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Physical Proc 2 App and Service">
  <Table ss:ExpandedColumnCount="6" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
   <Column ss:AutoFitWidth="0" ss:Width="199"/>
   <Column ss:AutoFitWidth="0" ss:Width="297"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="194"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Business Process to Performing Organisation</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"><Data ss:Type="String">Map the organisations to the processes they perform</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1182"><Data ss:Type="String">Business Process</Data></Cell>
    <Cell ss:StyleID="s1182"><Data ss:Type="String">Performing Organisation</Data></Cell>
    <Cell ss:StyleID="s1182"><Data ss:Type="String">Application and Service Used</Data></Cell>
    <Cell ss:StyleID="s1188"><Data ss:Type="String">Process Check</Data></Cell>
    <Cell ss:StyleID="s1189"><Data ss:Type="String">Organisation Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="2" ss:StyleID="s1183"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1184"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1184"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1190"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1190"><Data ss:Type="String">.</Data></Cell>
   </Row>
    
    <xsl:apply-templates select="$phyProc" mode="physapps"></xsl:apply-templates>
   
   
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>

  
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1224"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1199"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R174C4</Range>
   <Type>List</Type>
   <Value>AppProRole</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
    <Value>'Business Processes'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
    <Value>'Organisations'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R174C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>

<Worksheet ss:Name="Physical Proc 2 App">
  <Table ss:ExpandedColumnCount="6" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
   <Column ss:AutoFitWidth="0" ss:Width="199"/>
   <Column ss:AutoFitWidth="0" ss:Width="297"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="194"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Business Process to Performing Organisation</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"><Data ss:Type="String">Map the organisations to the processes they perform - these applications are a direct relationship to process, use the previous worksheet if you can for application relationships</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1182"><Data ss:Type="String">Business Process</Data></Cell>
    <Cell ss:StyleID="s1182"><Data ss:Type="String">Performing Organisation</Data></Cell>
    <Cell ss:StyleID="s1182"><Data ss:Type="String">Application Used</Data></Cell>
    <Cell ss:StyleID="s1188"><Data ss:Type="String">Process Check</Data></Cell>
    <Cell ss:StyleID="s1189"><Data ss:Type="String">Organisation Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="2" ss:StyleID="s1183"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1184"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1184"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1190"><Data ss:Type="String">.</Data></Cell>
    <Cell ss:StyleID="s1190"><Data ss:Type="String">.</Data></Cell>
   </Row>
    
    <xsl:apply-templates select="$phyProc" mode="physappsdirect"></xsl:apply-templates>
   
   
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1223"/>
    <Cell ss:StyleID="s1185"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1161"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
 
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>

  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
    <Range>R8C4:R4174C4</Range>
   <Type>List</Type>
    <Value>'Applications'!R8C3:R5000C3</Value>
  </DataValidation>	
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
    <Value>'Business Processes'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
    <Value>'Organisations'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R174C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>		
 <Worksheet ss:Name="Technology Domains">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="73"/>
   <Column ss:AutoFitWidth="0" ss:Width="237"/>
   <Column ss:AutoFitWidth="0" ss:Width="367"/>
   <Column ss:AutoFitWidth="0" ss:Width="156"/>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1111"><Data ss:Type="String">Technology Domains</Data></Cell>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Used to capture a list of Technology Domains</Data></Cell>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1225"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1225"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1225"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1225"><Data ss:Type="String">Position</Data></Cell>
   </Row>
    <Row ss:Height="34">
      <Cell ss:Index="2" ss:StyleID="s1063"></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data><NamedCell
        ss:Name="Technology_Domains"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data></Cell>
    </Row>
   <xsl:apply-templates select="$techDomain" mode="techDomain"></xsl:apply-templates> 
    <Row ss:Height="34">
      <Cell ss:Index="2" ss:StyleID="s1063"></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data><NamedCell
        ss:Name="Technology_Domains"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data></Cell>
    </Row>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>5</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R82C5</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Reference_Model_Layers</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Technology Capabilities">
  <Table ss:ExpandedColumnCount="6" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="251"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="243"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="220"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Capabilities</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Used to capture a list of Technology Capabilities</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1151"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Capability Name</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Parent Technology Domain</Data></Cell>
    <Cell ss:StyleID="s1186"><Data ss:Type="String">Check Domain</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="5">
    <Cell ss:Index="6" ss:StyleID="s1162"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Domains'!C[-3],1,0)),&quot;Technology Domain must be already defined in Technology Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    <xsl:apply-templates select="$techCapabilities" mode="techCapabilities"></xsl:apply-templates>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Domains'!C[-3],1,0)),&quot;Technology Domain must be already defined in Technology Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
   </Row>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>5</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3900C5</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Domains'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R3900C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Technology Components">
  <Table ss:ExpandedColumnCount="8" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="58"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="284"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="331"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="238" ss:Span="1"/>
   <Column ss:Index="7" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="178"
    ss:Span="1"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Components</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Details the technology components</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1151"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Parent Tech Capability 1</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Parent Tech Capability 2</Data></Cell>
    <Cell ss:StyleID="s1186"><Data ss:Type="String">Tech Capability 1 Check</Data></Cell>
    <Cell ss:StyleID="s1186"><Data ss:Type="String">Tech Capability 2 Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7">
    <Cell ss:Index="7" ss:StyleID="s1162"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Capabilities'!C[-4],1,0)),&quot;Technology Capability must be already defined in Technology Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1162"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Capabilities'!C[-5],1,0)),&quot;Technology Capability must be already defined in Technology Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    <xsl:apply-templates select="$techComponents" mode="techComponents"></xsl:apply-templates>
   
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <LeftColumnVisible>1</LeftColumnVisible>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>5</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R15C5:R17C5,R26C5,R24C5,R19C5:R22C5</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Capabilities</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R1400C5,R8C5:R1400C6</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Capabilities'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R169C8</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Technology Suppliers">
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="59"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="236"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="351"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Product Suppliers</Data></Cell>
    <Cell ss:StyleID="s1140"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures a list of Suppliers of Technologu Products</Data></Cell>
    <Cell ss:StyleID="s1139"/>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1137"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s1139"><NamedCell
      ss:Name="Technology_Product_Suppliers"/></Cell>
   </Row>
    
    <xsl:apply-templates select="$techSuppliers" mode="suppliers"></xsl:apply-templates>
   
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"></Data><NamedCell
      ss:Name="Technology_Product_Suppliers"/></Cell>
    <Cell ss:StyleID="s1112"/>
   </Row>
   

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>122</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>136</ActiveRow>
     <RangeSelection>R137:R370</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Technology Product Families">
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="268"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="349"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Product Families</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Used to capture a list of Technology Product Families that group separate versions of a Technology Product into a family for that Product. e.g. Oracle WebLogic to group WebLogic 7.0, WebLogic 8.0, WebLogic 9.0.</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1151"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Product Family Name</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="5"/>
    <xsl:apply-templates select="$techProdFams" mode="prodFams"></xsl:apply-templates>
 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>27</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>41</ActiveRow>
     <RangeSelection>R42:R786</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Technology Products">
  <Names>
   <NamedRange ss:Name="_FilterDatabase"
    ss:RefersTo="='Technology Products'!R7C1:R753C19" ss:Hidden="1"/>
  </Names>
  <Table ss:ExpandedColumnCount="39"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="19"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="70"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="236"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="148"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="127"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="154"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="164"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="83"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="122"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="150"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="83"/>
   <Column ss:AutoFitWidth="0" ss:Width="83" ss:Span="1"/>
   <Column ss:Index="15" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="83"/>
   <Column ss:AutoFitWidth="0" ss:Width="83" ss:Span="1"/>
   <Column ss:Index="18" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="83"/>
   <Column ss:AutoFitWidth="0" ss:Width="83" ss:Span="1"/>
   <Column ss:Index="21" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="144"
    ss:Span="2"/>
   <Column ss:Index="24" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="127"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="129" ss:Span="1"/>
   <Column ss:Index="27" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="93"
    ss:Span="3"/>
   <Column ss:Index="31" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="119"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="104" ss:Span="3"/>
   <Column ss:Index="36" ss:StyleID="s1110" ss:Hidden="1" ss:AutoFitWidth="0"
    ss:Span="2"/>
   <Row>
    <Cell ss:Index="13" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="16" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="19" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Products</Data></Cell>
    <Cell ss:Index="13" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="16" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="19" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Details the Technology Products</Data></Cell>
    <Cell ss:Index="13" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="16" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="19" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s1203"><Data ss:Type="String">Error Status</Data></Cell>
    <Cell ss:StyleID="s1112" ss:Formula="=SUM(C[33])"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:Index="13" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="16" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="19" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:Index="13" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="16" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:Index="19" ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Supplier</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Product Family</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Vendor Release Status</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Delivery Model</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Usage 1</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 1 Compliance Level</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 1 Adoption Status</Data></Cell>
    <Cell ss:StyleID="s1202"><Data ss:Type="String">Usage 2</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 2 Compliance Level</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 2 Adoption Status</Data></Cell>
    <Cell ss:StyleID="s1202"><Data ss:Type="String">Usage 3</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 3 Compliance Level</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 3 Adoption Status</Data></Cell>
    <Cell ss:StyleID="s1202"><Data ss:Type="String">Usage 4</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 4 Compliance Level</Data></Cell>
    <Cell ss:StyleID="s1201"><Data ss:Type="String">Usage 4 Adoption Status</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Product Family Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Vendor Release check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Delivery Model Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Usage 1 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Usage 2 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Usage 3 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Usage 4 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Compliance 1 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Compliance 2 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Compliance 3 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Compliance 4 Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Adoption 1</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Adoption 2</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Adoption 3</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Adoption 4</Data></Cell>
    <Cell><Data ss:Type="String">Checks</Data></Cell>
    <Cell><Data ss:Type="String">Checks2</Data></Cell>
    <Cell><Data ss:Type="String">Checks3</Data></Cell>
    <Cell><Data ss:Type="String">Issues</Data></Cell>
   </Row>
   <xsl:apply-templates select="$techProducts" mode="techProducts"/>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>17</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R488C10:R753C11,R488C13:R753C14,R8C9:R753C9</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Components</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R488C11:R753C11,R488C13:R753C14,R8C16:R753C16,R488C19:R753C20,R8C13:R487C13,R8C10:R753C10,R8C19:R487C19</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Compliance_Levels</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C19:R487C20,R8C13:R487C14,R8C10:R487C11,R8C16:R753C17</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Usage_Lifecycle_Statii</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R753C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Vendor_Release_Statii</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R753C8</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Delivery_Models</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R753C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Product_Suppliers</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R753C6</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Product_Families</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R8C10008</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Product Families'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C39:R753C39</Range>
   <Condition>
    <Qualifier>Greater</Qualifier>
    <Value1>0</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R4C6</Range>
   <Condition>
    <Qualifier>Equal</Qualifier>
    <Value1>0</Value1>
    <Format Style='color:#C4D79B;background:#C4D79B'/>
   </Condition>
   <Condition>
    <Qualifier>Greater</Qualifier>
    <Value1>0</Value1>
    <Format Style='color:#E6B8B7;background:#E6B8B7'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Tech Prods to User Orgs">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="208" ss:Span="1"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="153"/>
   <Column ss:AutoFitWidth="0" ss:Width="264"/>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1111"><Data ss:Type="String">Technology Product to User Organisations</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">Maps Technology Products to the Organisations that use them.</Data></Cell>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1110"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Technology Product</Data></Cell>
    <Cell ss:StyleID="s1151"><Data ss:Type="String">Organisation</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Product Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">Organisation Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="4"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Products'!C[-1],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    <xsl:apply-templates select="$techProducts" mode="techorgusers"></xsl:apply-templates>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Products'!C[-1],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>49</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>223</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R8C2:R228C3</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R2280C2</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Products'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R228C3</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Organisations'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R2280C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="App to Tech Products">
  <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="179"/>
   <Column ss:AutoFitWidth="0" ss:Width="146"/>
   <Column ss:AutoFitWidth="0" ss:Width="207"/>
   <Column ss:AutoFitWidth="0" ss:Width="197"/>
   <Column ss:AutoFitWidth="0" ss:Width="177"/>
   <Column ss:AutoFitWidth="0" ss:Width="181"/>
   <Column ss:AutoFitWidth="0" ss:Width="139" ss:Span="2"/>
   <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="156"/>
   <Column ss:AutoFitWidth="0" ss:Width="139"/>
   <Column ss:AutoFitWidth="0" ss:Width="143"/>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:MergeAcross="2" ss:StyleID="s1299"><Data ss:Type="String">Application Technology Architecture</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1126"><Data ss:Type="String">Defines the technology architecture supporting applications in terms of Technology Products, the components that they implement and the dependencies between them</Data></Cell>
    <Cell ss:StyleID="s1126"/>
    <Cell ss:StyleID="s1126"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1086"/>
    <Cell ss:StyleID="s1266"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="s1266"/>
    <Cell ss:StyleID="s1087"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s1088"><Data ss:Type="String">Environment</Data></Cell>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">From Technology Product</Data></Cell>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">From Technology Component</Data></Cell>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">To Technology Product</Data></Cell>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">To Technology Component</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check Application</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check Environment</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check From Tech Product</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check From Tech Component</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check To Tech Product</Data></Cell>
    <Cell ss:StyleID="s1195"><Data ss:Type="String">Check To Tech Component</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7">
    <Cell ss:Index="2"><Data ss:Type="String">.</Data></Cell>
    <Cell><Data ss:Type="String">.</Data></Cell>
    <Cell><Data ss:Type="String">.</Data></Cell>
    <Cell><Data ss:Type="String">.</Data></Cell>
    <Cell><Data ss:Type="String">.</Data></Cell>
    <Cell><Data ss:Type="String">.</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1090"/>
    <Cell ss:StyleID="s1091"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-6]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
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
     <ActiveRow>6</ActiveRow>
     <ActiveCol>7</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R35C3</Range>
   <Type>List</Type>
   <Value>Valid_Environments</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3500C2</Range>
   <Type>List</Type>
    <Value>'Applications'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3500C4,R8C6:R3500C6</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Products'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3500C5,R8C7:R3500C7</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Technology Components'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R35C13</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Data Subjects">
  <Table ss:ExpandedColumnCount="9" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="1"/>
   <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="200"/>
   <Column ss:AutoFitWidth="0" ss:Width="108"/>
   <Column ss:AutoFitWidth="0" ss:Width="139"/>
   <Column ss:AutoFitWidth="0" ss:Width="133"/>
   <Row ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271"><Data ss:Type="String">Data Subjects</Data></Cell>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302"><Data ss:Type="String">Captures the data subjects used within the organisation</Data></Cell>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:Index="9" ss:StyleID="s1250"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
    <Cell ss:Index="2" ss:StyleID="s1245"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1256"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Synonym 1</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Synonym 2</Data></Cell>
    <Cell ss:StyleID="s1245"><Data ss:Type="String">Data Category</Data></Cell>
    <Cell ss:StyleID="s1245"><Data ss:Type="String">Organisation Owner</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Individual Owner</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="7" ss:StyleID="s1063"/>
    <Cell ss:Index="9" ss:StyleID="s1148"/>
   </Row>
    <xsl:apply-templates select="$dataSubjects" mode="dataSubject"></xsl:apply-templates>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1251"><Data ss:Type="String">DS001</Data></Cell>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:StyleID="s1144"/>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TopRowVisible>6</TopRowVisible>
   <LeftColumnVisible>1</LeftColumnVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>7</ActiveRow>
     <ActiveCol>8</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R88C7</Range>
   <Type>List</Type>
   <Value>Valid_Data_Categories</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R88C8</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>INDIRECT(&quot;Orgs[Name]&quot;)</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Data Objects">
  <Table ss:ExpandedColumnCount="15" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="1"/>
   <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="200"/>
   <Column ss:AutoFitWidth="0" ss:Width="218"/>
   <Column ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
   <Column ss:Index="10" ss:AutoFitWidth="0" ss:Width="170"/>
 
   <Row ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271"><Data ss:Type="String">Data Objects</Data></Cell>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
    <Cell ss:StyleID="s18"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302"><Data ss:Type="String">Captures the data objects used within the organisation</Data></Cell>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
    <Cell ss:Index="11" ss:StyleID="s1250"/>
    <Cell ss:StyleID="s1250"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="36" ss:StyleID="s1181">
    <Cell ss:Index="2" ss:StyleID="s1245"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1256"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Synonym 1</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Synonym 2</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Parent Data Subject</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Data Category</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Is Abstract</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="11" ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1148"/>
   </Row>

<xsl:apply-templates select="$dataObjects" mode="dataObject"></xsl:apply-templates>
   <Row ss:AutoFitHeight="0" ss:Height="15" ss:Span="726"/>
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>7</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C9:R107C9</Range>
   <Type>List</Type>
   <Value>Valid_True_or_False</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R107C8</Range>
   <Type>List</Type>
   <Value>Valid_Data_Categories</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R10700C10</Range>
   <Type>List</Type>
   <UseBlank/>
    <Value>'Organisations'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R10700C7</Range>
   <Type>List</Type>
    <Value>'Data Subjects'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C14:R8C15</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Data Object Inheritance">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:AutoFitWidth="0" ss:Width="241"/>
   <Column ss:AutoFitWidth="0" ss:Width="290"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="123"/>
   <Column ss:AutoFitWidth="0" ss:Width="138"/>
   <Column ss:AutoFitWidth="0" ss:Width="66"/>
   <Row ss:AutoFitHeight="0" ss:Height="15"/>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:StyleID="s1271"><Data ss:Type="String">Data Object Inheritance</Data></Cell>
    <Cell ss:StyleID="s1271"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1302"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="5" ss:StyleID="s1261"><Data ss:Type="String">Checks</Data></Cell>
    <Cell ss:StyleID="s1261"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="36">
    <Cell ss:Index="2" ss:StyleID="s1246"><Data ss:Type="String">Parent Data Object</Data></Cell>
    <Cell ss:StyleID="s1246"><Data ss:Type="String">Child Data Object</Data></Cell>
    <Cell ss:Index="5" ss:StyleID="s1260"><Data ss:Type="String">Parent Data Object</Data></Cell>
    <Cell ss:StyleID="s1260"><Data ss:Type="String">Child Data Object</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
    
    <xsl:apply-templates select="$dataObjects" mode="dataSubtoObj"/>
  
 
   <Row ss:AutoFitHeight="0" ss:Height="15" ss:Span="621"/>
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3700C3</Range>
   <Type>List</Type>
    <Value>'Data Objects'!R8C3:R5000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R37C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Data Object Attributes">
   <Table ss:ExpandedColumnCount="17"   x:FullColumns="1"
     x:FullRows="1"
     ss:DefaultColumnWidth="65"
     ss:DefaultRowHeight="16"> 
     <Column ss:AutoFitWidth="0" ss:Width="18"/>
     <Column ss:AutoFitWidth="0" ss:Width="57"/>
     <Column ss:AutoFitWidth="0" ss:Width="190"/>
     <Column ss:AutoFitWidth="0" ss:Width="218" ss:Span="2"/>
     <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="200" ss:Span="1"/>
     <Column ss:Index="9" ss:StyleID="s1057" ss:AutoFitWidth="0" ss:Width="143"/>
     <Column ss:AutoFitWidth="0" ss:Width="112"/>
     <Column ss:Index="12" ss:AutoFitWidth="0" ss:Width="123"/>
     <Column ss:AutoFitWidth="0" ss:Width="115"/>
     <Column ss:AutoFitWidth="0" ss:Width="181"/>
     <Column ss:Index="16" ss:Hidden="1" ss:AutoFitWidth="0" ss:Span="1"/>
     <Row ss:AutoFitHeight="0" ss:Height="15"/>
     <Row ss:AutoFitHeight="0" ss:Height="35">
       <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1271">
         <Data ss:Type="String">Data Attributes</Data>
       </Cell>
       <Cell ss:StyleID="s18"/>
       <Cell ss:StyleID="s18"/>
       <Cell ss:StyleID="s18"/>
       <Cell ss:StyleID="s18"/>
       <Cell ss:StyleID="s18"/>
     </Row>
     <Row ss:AutoFitHeight="0" ss:Height="15">
       <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1302">
         <Data ss:Type="String">Captures the data object Attributes used within the organisation</Data>
       </Cell>
       <Cell ss:StyleID="s1250"/>
       <Cell ss:StyleID="s1250"/>
       <Cell ss:StyleID="s1250"/>
       <Cell ss:StyleID="s1250"/>
     </Row>
     <Row ss:AutoFitHeight="0" ss:Height="17">
       <Cell ss:Index="8" ss:MergeAcross="1" ss:StyleID="s1305">
         <Data ss:Type="String">One of these per row, not both in one row</Data>
       </Cell>
     </Row>
     <Row ss:AutoFitHeight="0" ss:Height="21">
       <Cell ss:Index="4" ss:MergeAcross="6" ss:StyleID="s1303">
         <Data ss:Type="String">Data Attribute Details</Data>
       </Cell>
       <Cell ss:Index="12" ss:StyleID="s1263">
         <Data ss:Type="String">Checks</Data>
       </Cell>
       <Cell ss:StyleID="s1263"/>
       <Cell ss:StyleID="s1263"/>
     </Row>
     <Row ss:Height="20" ss:StyleID="s1181">
       <Cell ss:Index="2" ss:StyleID="s1245">
         <Data ss:Type="String">ID</Data>
         <Comment ss:Author="AutoGen">
           <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
             <Font html:Color="#000000"/>
             <Font html:Size="9" html:Color="#000000">A unique ID for the Application</Font>
             <Font html:Color="#000000"/>
           </ss:Data>
         </Comment>
       </Cell>
       <Cell ss:StyleID="s1246">
         <Data ss:Type="String">Data Object Name</Data>
         <Comment ss:Author="AutoGen">
           <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
             <Font html:Color="#000000"/>
             <Font html:Size="9" html:Color="#000000">The name of the Application</Font>
             <Font html:Color="#000000"/>
           </ss:Data>
         </Comment>
       </Cell>
       <Cell ss:StyleID="s1246">
         <Data ss:Type="String">Attribute Name</Data>
         <Comment ss:Author="AutoGen">
           <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
             <Font html:Color="#000000"/>
             <Font html:Size="9" html:Color="#000000">A description of the functionality provided by the Application</Font>
             <Font html:Color="#000000"/>
           </ss:Data>
         </Comment>
       </Cell>
       <Cell ss:StyleID="s1246">
         <Data ss:Type="String">Attribute Description</Data>
       </Cell>
       <Cell ss:StyleID="s1246">
         <Data ss:Type="String">Synonym 1</Data>
       </Cell>
       <Cell ss:StyleID="s1246">
         <Data ss:Type="String">Synonym 2</Data>
         <Comment ss:Author="AutoGen">
           <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
             <Font html:Color="#000000"/>
             <Font html:Size="9" html:Color="#000000">The support owner for the Application</Font>
             <Font html:Color="#000000"/>
           </ss:Data>
         </Comment>
       </Cell>
       <Cell ss:StyleID="s1257">
         <Data ss:Type="String">Data Type (Object)</Data>
         <Comment ss:Author="AutoGen">
           <ss:Data xmlns="http://www.w3.org/TR/REC-html40">
             <Font html:Color="#000000"/>
             <Font html:Size="9" html:Color="#000000">The support owner for the Application</Font>
             <Font html:Color="#000000"/>
           </ss:Data>
         </Comment>
       </Cell>
       <Cell ss:StyleID="s1258">
         <Data ss:Type="String">Data Type (Primitive)</Data>
       </Cell>
       <Cell ss:StyleID="s1245">
         <Data ss:Type="String">Cardinality</Data>
       </Cell>
       <Cell ss:Index="12" ss:StyleID="s1262">
         <Data ss:Type="String">Data Object Check</Data>
       </Cell>
       <Cell ss:StyleID="s1262">
         <Data ss:Type="String">Data Type Check</Data>
       </Cell>
       <Cell ss:StyleID="s1262">
         <Data ss:Type="String">Column Check</Data>
       </Cell>
     </Row>
     <Row ss:AutoFitHeight="0" ss:Height="6"/>
     
     <xsl:apply-templates select="$DOA" mode="DOA"></xsl:apply-templates>  
   
   
   <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:StyleID="s1251"><Data ss:Type="String">...<xsl:value-of select="count($DOA)"/></Data></Cell>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1251"/>
    <Cell ss:StyleID="s1253"/>
    <Cell ss:StyleID="s1063"/>
    <Cell ss:Index="12" ss:StyleID="s1259"
     ss:Formula="=IF(RC[-9]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-9],'Data Objects'!C[-9],1,0)),&quot;Data Object must be already defined in Data Objects&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1259"
     ss:Formula="=IF(RC[-5]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-5],'Data Objects'!C[-10],1,0)),&quot;Data Type must be already defined in Data Objects&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell
     ss:Formula="=IF(COUNTIF(RC[2]:RC[3], &quot;0&quot;)=0,&quot;You can only have 1 value across the two columns&quot;,&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
  
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>2</ActiveCol>
     <RangeSelection>R8C3:R9C4</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C9:R66C9</Range>
   <Type>List</Type>
   <Value>Valid_Pimitive_Data_Objects</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R5000C8,R8C3:R5000C3</Range>
   <Type>List</Type>
    <Value>'Data Objects'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R66C10</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Multiple, One, One To Many, Single, Zero to One, Zero to Many&quot;</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C12:R66C13</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Codebases">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/>
	<Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/> 
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:Index="6" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Application Codebases</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the types of Application Codebase relevant to the enterprise and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
	
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Description</Data></Cell> 
  <Cell ss:StyleID="s1114"><Data ss:Type="String">Label</Data></Cell> 
  <Cell ss:StyleID="s1114"><Data ss:Type="String">Sequence No</Data></Cell> 
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1113"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1116"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1116"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1116"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/> 
	   <xsl:apply-templates select="$codebase" mode="cdbase"></xsl:apply-templates> 

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>54</TabColorIndex>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R24C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Application Delivery Models">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/>
	<Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/> 
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:Index="6" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Application Delivery Models</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the types of Application Delivery Model relevant to the enterprise and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
	
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Description</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Label</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Sequence No</Data></Cell> 
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Colour</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Style Class</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Score</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Name Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Description Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/> 
	   <xsl:apply-templates select="$delivery" mode="cdbase"></xsl:apply-templates> 

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>54</TabColorIndex>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R24C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>	
 <Worksheet ss:Name="Technology Delivery Models">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/>
	<Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/> 
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:Index="6" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Delivery Models</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the the different ways in which Applications are delivered and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
	
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Description</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Label</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Sequence No</Data></Cell> 
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Colour</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Style Class</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Score</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Name Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Description Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/> 
	   <xsl:apply-templates select="$techDeliveryModel" mode="cdbase"></xsl:apply-templates> 

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>54</TabColorIndex>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R24C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>	
 <Worksheet ss:Name="Tech Vendor Release Statii">
  <Table ss:ExpandedColumnCount="12" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1110" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/>
	<Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="131"/> 
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:Index="6" ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1110" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1111"><Data ss:Type="String">Technology Vendor Release Statii</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the Vendor Release Statii of Technology Products and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
	
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1113"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Description</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Label</Data></Cell> 
    <Cell ss:StyleID="s1114"><Data ss:Type="String">Sequence No</Data></Cell> 
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Colour</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Style Class</Data></Cell>
      <Cell ss:StyleID="s1113"><Data ss:Type="String">Score</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Name Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Description Translation</Data></Cell>
      <Cell ss:StyleID="s1116"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/> 
	   <xsl:apply-templates select="$techlifecycle" mode="cdbase"></xsl:apply-templates> 

  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>54</TabColorIndex>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R24C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>	

 <Worksheet ss:Name="Standards Compliance Levels">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Standards Compliance Levels'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="11" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Standards Compliance Levels</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL1</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Mandatory</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Strength of standard to which implementations MUST comply.</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">#1B51A5</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">ragTextBlue</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL2</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Recommended</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Strength of standard to which implementations SHOULD comply.</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="68">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL3</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Permitted</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Strength of standard to which implementations CAN comply. e.g. for defined exceptions, alternatives or transitionary states on route to full compliance.</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">#C8DE39</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">ragTextLightGreen</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">8</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL4</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Waiver Required</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Strength of standard for which a governance waiver is required</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL5</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL6</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL7</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL8</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL9</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL10</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL11</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL12</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL13</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL14</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL15</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL16</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">SCL17</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>4</TopRowVisible>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R24C11</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Technology Adoption Statii">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Technology Adoption Statii'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="11" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1056" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:Index="9" ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1292"><Data ss:Type="String">Technology Adoption Statii</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS1</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Under Planning</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">An element that is planned but is yet to be implemented in any form. The next status is Prototype</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS2</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Prototype</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for things that are at early stages of investigation and development</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS3</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Pilot</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for things that are at an introductory stage of their lifecycle.</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS4</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">OffStrategy</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for elements that are explicitly deemed as being off strategy</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS5</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Reference</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Used to represent any element that is a Reference implementation. e.g. a reference architecture.</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS6</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">ProductionStrategic</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for things that are in current use in production environments and have been defined as a strategic standard</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">6</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS7</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Disaster Recovery</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Only used in a DR scenario</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">7</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS8</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Sunset</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for things that are in reduced use with a view to retiring or decommissioning them</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">8</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="51">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS9</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Retired</Data><NamedCell
      ss:Name="Usage_Lifecycle_Statii"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Status for things that have been retired or decommissioned and should no longer be supporting the business</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="Number">9</Data></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS10</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS11</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS12</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS13</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS14</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS15</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS16</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><Data ss:Type="String">TAS17</Data></Cell>
    <Cell ss:StyleID="s1125"><NamedCell ss:Name="Usage_Lifecycle_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
    <Cell ss:StyleID="s1125"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <VerticalResolution>0</VerticalResolution>
   </Print>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>6</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>19</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8</Range>
   <Type>Whole</Type>
   <UseBlank/>
   <Min>0</Min>
   <Max>10</Max>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R24C11</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="CONCATS">
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="65"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="173"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="229"/>
   <Row ss:Index="2">
    <Cell ss:Index="2" ss:StyleID="Default"/>
   </Row>
   <Row ss:Index="5" ss:Height="51">
    <Cell ss:Index="4"><Data ss:Type="String">Needed for Business process to app sheet extend to number of rows in App Service 2 Apps sheet</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1123"><Data ss:Type="String">Tech Svc Quality Values</Data></Cell>
    <Cell ss:Index="4" ss:StyleID="s1123"><Data ss:Type="String">App Pro Role</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1125"><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="4"
     ss:Formula="=CONCATENATE('App Service 2 Apps'!RC[-2],&quot; as &quot;,'App Service 2 Apps'!RC[-1])"><Data
      ss:Type="String"> as </Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>54</TabColorIndex>
   <TopRowVisible>7</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>5</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="REFERENCE DATA">
  <Table ss:ExpandedColumnCount="187" ss:ExpandedRowCount="50" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:Width="200" ss:Span="1"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="76"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="25">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1289"><Data ss:Type="String">REFERENCE DATA</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056"><Data ss:Type="String">Used to capture reference information to be used for validation purposes</Data></Cell>
   </Row>
   <Row ss:Index="8" ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">App Lifecycle Statii</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Contains a list of Lifecycle Statii</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Disaster Recovery</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">OffStrategy</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Pilot</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">ProductionStrategic</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Prototype</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Reference</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Retired</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sunset</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Under Planning</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">CRUD Values</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the allowed values when defining a CRUD on data on information</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Yes</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">No</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Unknown</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Component Categories</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used to categorise Business Capabilities</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Direct</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Control</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Execute</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Countries</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A list of standard countries</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Afghanistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Albania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Algeria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Angola</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Antarctica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Antigua and Barbuda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Argentina</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Armenia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Australia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Austria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Azerbaijan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bahamas</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bangladesh</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Barbados</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Belarus</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Belgium</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Belize</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Benin</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bhutan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bolivia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bosnia and Herzegovina</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Botswana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Brazil</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Brunei Darussalam</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Bulgaria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Burkina Faso</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Burma</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Burundi</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cambodia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cameroon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Canada</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cape Verde</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Central African Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Chad</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Chile</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">China</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Colombia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Comoros</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Congo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Costa Rica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cote d'Ivoire</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Croatia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cuba</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cyprus</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Czech Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Democratic Republic of the Congo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Denmark</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Djibouti</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Dominica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Dominican Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Ecuador</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Egypt</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">El Salvador</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Equatorial Guinea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Eritrea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Estonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Ethiopia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Falkland Islands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Fiji</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Finland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">France</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">French Guiana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Gabon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Gambia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Georgia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Germany</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Ghana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Greece</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Grenada</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Guadeloupe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Guatemala</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Guinea-Bissau</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Guyana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Haiti</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Honduras</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Hungary</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Iceland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">India</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Indonesia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Iran</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Iraq</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Ireland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Israel</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Italy</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Jamaica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Japan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Jordan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Kazakhstan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Kenya</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Korea, Democratic People's Republic of</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Korea, Republic of</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Kuwait</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Kyrgyzstan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Lao People's Democratic Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Latvia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Lebanon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Lesotho</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Liberia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Libya</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Lithuania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Luxembourg</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Macedonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Madagascar</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Malawi</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Malaysia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mali</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Martinique</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mauritania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mauritius</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mexico</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mongolia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Morocco</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Mozambique</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Namibia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Nepal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Netherlands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">New Caledonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">New Zealand</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Nicaragua</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Nigeria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Norway</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Oman</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Pakistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Palau</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Panama</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Papua New Guinea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Paraguay</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Peru</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Philippines</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Poland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Portugal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Puerto Rico</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Qatar</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Republic of Moldova</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Reunion</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Romania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Russia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Rwanda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sao Tome and Principe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Saudi Arabia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Senegal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Serbia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sierra Leone</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Singapore</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Slovakia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Slovenia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Solomon Islands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Somalia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">South Africa</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Spain</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sri Lanka</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">St. Kitts and Nevis</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">St. Lucia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">St. Vincent and the Grenadines</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sudan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Suriname</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Swaziland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Sweden</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Switzerland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Syria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Taiwan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Tajikistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Thailand</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Timor-Leste</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Togo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Trinidad and Tobago</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Tunisia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Turkey</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Turkmenistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Uganda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Ukraine</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">United Arab Emirates</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">United Kingdom</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">United Republic of Tanzania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">United States</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Uruguay</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Uzbekistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Vanuatu</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Venezuela</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Vietnam</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">West Bank</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Western Sahara</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Yemen</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Zambia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Zimbabwe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data_Categories</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Describes the list of Data Categories</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Conditional Master Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Master Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Reference Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Transactional Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data Acquisition Methods</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Batch File Upload</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Data Service</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Database Replication</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Manual Data Entry</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Messaging</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Unknown</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1041"><Data ss:Type="String">Direct API Call</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Deployment Role</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">ARCH</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">BT1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">CL1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">CL2</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">CL3</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">CP1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Cl2</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DR</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DV1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DV2</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DV3</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DV6</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Dev</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Dev/Prod</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Development</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Live</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Migration</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">PROD</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Pend</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Production</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Quality Assurance</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">SAT</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">SP1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TRAIN</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TS1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TS2</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TS3</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TS4</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">TS5</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Test</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Training</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">UA1</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">UA3</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">UAT</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">True or False Values</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Represents fixed strings for true or false values</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">true</Data><NamedCell
      ss:Name="Valid_True_or_False"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">false</Data><NamedCell
      ss:Name="Valid_True_or_False"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Day in Month</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The day in a calendar month</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">1</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">3</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">4</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">5</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">6</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">7</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">8</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">9</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">10</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">11</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">12</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">13</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">14</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">15</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">16</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">17</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">18</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">19</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">20</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">21</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">22</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">23</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">24</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">25</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">26</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">27</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">28</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">29</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">30</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">31</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Month in Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A month in a calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">1</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">3</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">4</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">5</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">6</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">7</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">8</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">9</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">10</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">11</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">12</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Quarter in Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A quarter in a calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Q1</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Q2</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Q3</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Q4</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Calendar Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2005</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2006</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2007</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2008</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2009</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2010</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2011</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2012</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2013</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2014</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2015</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2016</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2017</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2018</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2019</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2020</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2021</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">2022</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Project Lifecycle Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The lifecycle status of a project</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Build</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Closed</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Definition</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Design</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Feasibility</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Implementation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Initiation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Post Implementation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">System Test</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">UAT</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Delivery Model</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Hosted</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">OnSite</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">SaaS</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data Attribute Cardinality</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Multiple</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">One</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">One to Many</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Single</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Zero or One</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Zero to Many</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">App Service Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Allowed values for Application Service Staus</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Online</Data><NamedCell
      ss:Name="Valid_App_Service_Statii"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">For_Retirement</Data><NamedCell
      ss:Name="Valid_App_Service_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Purpose</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A list of agreed application purposes</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Application Integration</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Logic</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business System Application</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Data Integration</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">InboundData</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">OutboundData</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">ProcessAutomation</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Start Flow</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used for process flows and roadmaps to signifiy the start of the flow</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Start</Data><NamedCell
      ss:Name="Valid_Start_Flow"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">End Flow</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used for process flows and roadmaps to signifiy the end of a flow</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">End</Data><NamedCell
      ss:Name="Valid_End_Flow"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Planning Actions</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The set of actions for strategic plans</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Decommission</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Enhance</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Establish</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Outsource</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Replace</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Strategic</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Switch_Off</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Tactical</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Secured Actions</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A secured action associated with a security policy</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Create</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Delete</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">None</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Read</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Update</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">High Medium Low Values</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Low</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Medium</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">High</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Standardisation Level</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Describes the standardisation level of a business process or activity</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Custom</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Standard</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Standard with Customisation</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Project Approval Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The approval status of a project or programme</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Approved</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Not Approved</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Project Suspended</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Suspended</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Principle Compliance Levels</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Full Compliance</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">No Compliance</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Not Applicable</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Strong Compliance</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Weak Compliance</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Principle Compliance Assessment Level</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The assessmet level for the principles compliance</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Full Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">No Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Not Applicable</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Strong Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Weak Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">EA Standard Lifecycle Statii</Data><NamedCell
      ss:Name="Valid_EA_Standard_Lifcycle_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Criticality</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Criticality: High</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Criticality: Low</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Criticality: Medium</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Actor Reporting Line Strength</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Direct</Data><NamedCell
      ss:Name="Valid_Reporting_Line_Strength"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Indirect</Data><NamedCell
      ss:Name="Valid_Reporting_Line_Strength"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Skill Level</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Expert</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Intermediate</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Novice</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Obligation Lifecycle Status</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Active</Data><NamedCell
      ss:Name="Valid_Obligation_Lifecycle_Status"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Future</Data><NamedCell
      ss:Name="Valid_Obligation_Lifecycle_Status"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Primitive Data Objects</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Boolean</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Float</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Integer</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">String</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Owning Org</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Group</Data><NamedCell
      ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Shared</Data><NamedCell
      ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1025"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1030"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1030"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Classification</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Key App</Data><NamedCell
      ss:Name="Valid_App_Classification"/><NamedCell ss:Name="Valid_App_Category"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Support App</Data><NamedCell
      ss:Name="Valid_App_Classification"/><NamedCell ss:Name="Valid_App_Category"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Best Practice Category</Data></Cell>
    <Cell ss:StyleID="s1041"><Data ss:Type="String">Components/CI Configuration</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1041"><Data ss:Type="String">Servers</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1030"><Data ss:Type="String">SQL</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1030"><Data ss:Type="String">Network</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1030"><Data ss:Type="String">VMWare</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1030"><Data ss:Type="String">Citrix</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1042"><Data ss:Type="String">Tech Node Roles</Data></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">32-bit Citrix Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">Web Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">Database Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">File Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">64-bit Citrix Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1041"><Data ss:Type="String">Batch Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Environment Types</Data></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">UAT</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1043"><Data ss:Type="String">Production</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1044"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1044"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1044"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1044"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1044"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Issue Category</Data></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Type</Data></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Packaged</Data><NamedCell
      ss:Name="App_Type"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Bespoke</Data><NamedCell
      ss:Name="App_Type"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Customised_Package</Data><NamedCell
      ss:Name="App_Type"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1042"><Data ss:Type="String">Valid Position in Parent</Data></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Front</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Manage</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Back</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Environments</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Decommissioned</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">DR</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Infra Server</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Production</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Staging</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Test</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Languages</Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">English (US)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">French (France)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">German (Germany)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Spanish (Spain)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Portuguese (Brazil)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Portuguese (Portugal)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Chinese (Simplified)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Chinese (Traditional)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Arabic (Saudi Arabia)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1063"><NamedCell ss:Name="Languages"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1035"><Data ss:Type="String">Reference Model Layer</Data></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Left</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Right</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Top</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Middle</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Bottom</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Unsynced/>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TopRowVisible>11</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>47</ActiveRow>
     <ActiveCol>2</ActiveCol>
     <RangeSelection>R48C3:R48C9</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="CLASSIFICATION DATA">
  <Table ss:ExpandedColumnCount="9" ss:ExpandedRowCount="25" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:Width="200" ss:Span="1"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="25">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1289"><Data ss:Type="String">CLASSIFICATION DATA</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s1056"><Data ss:Type="String">Used to capture reference information that is generated from user-definable Taxonomies in the Essential Repository</Data></Cell>
   </Row>
   <Row ss:Index="8" ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Goal Taxonomies</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Vaild Taxonomy Terms for Goals (Objectives)</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Company</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Personal</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Team</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Driver Taxonomies</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Valid Taxonomy Terms for Drivers</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Internal</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">External</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Gap</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Opportunity</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Capability Layer Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the layers used to lay out application capabilities in a reference model</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 1 - App Level 1</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 2 - App Level 2</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 3 - App Level 3</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 4 - App Level 4</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 5 - App Level 5</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Level 6 - App Level 6</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Architecture Tier Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the architecture tiers in which technology components exist</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Front End Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Middle Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Back End Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Component Usage Type Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Defines whether a dependent technology component included in a technology architecture is contained within the Composite Technology Component which is being described</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Primary</Data><NamedCell
      ss:Name="Valid_Technology_Component_Usage_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Secondary</Data><NamedCell
      ss:Name="Valid_Technology_Component_Usage_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Domain Layers Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the layers used to lay out business domains in a reference model</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 2</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 1</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 4</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 5</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 6</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Domain Layer 3</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Composite Types Classification</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A classification of types of technology composite</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Logical Technology Environment</Data><NamedCell
      ss:Name="Valid_Technology_Composite_Types"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Logical Technology Platform</Data><NamedCell
      ss:Name="Valid_Technology_Composite_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Product Type Categories Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Classification of product types (services)</Font>                   </ss:Data></Comment><NamedCell
      ss:Name="Valid_Product_Type_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Provider Category Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used to capture the different types of applications in use</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Integration Module</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Application Module</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business User Application</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Actor Categories Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used to categorise different types of actors (e.g. actual, placeholder)</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Actual Actor</Data><NamedCell
      ss:Name="Valid_Actor_Category"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Placeholder Actor</Data><NamedCell
      ss:Name="Valid_Actor_Category"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Information Representation Categories Taxonomy</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Reporting Cube</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Reporting Cube Object</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Data Feed</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Report</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Data Storage</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Business Data Extract</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Data View</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Skill Qualifier Taxonomies</Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Analysis</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Testing</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String">Support</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1035"><Data ss:Type="String">Yes/No</Data></Cell>
    <Cell ss:StyleID="s1038"><Data ss:Type="String">Yes</Data><NamedCell
      ss:Name="Valid_YesNo"/></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">No</Data><NamedCell
      ss:Name="Valid_YesNo"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1035"><Data ss:Type="String">Support Types</Data></Cell>
    <Cell ss:StyleID="s1038"><Data ss:Type="String">Infrastructure Support</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">Application Support Level 1</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">Application Support Level 2</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">Application Support Level 3</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1042"><Data ss:Type="String">Bus Cap Type</Data></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Commodity</Data><NamedCell
      ss:Name="Bus_Cap_type"/></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Differentiator</Data><NamedCell
      ss:Name="Bus_Cap_type"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Area</Data></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Local</Data><NamedCell
      ss:Name="Area"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">Regional </Data><NamedCell
      ss:Name="Area"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String">Global</Data><NamedCell
      ss:Name="Area"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Differentiation Level</Data></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">System of Innovation</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">System of Differentiation</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String">System of Record</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1035"><Data ss:Type="String">App Cap Cat</Data></Cell>
    <Cell ss:StyleID="s1107"><Data ss:Type="String">Core</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1046"><Data ss:Type="String">Management</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1046"><Data ss:Type="String">Shared</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1046"><Data ss:Type="String">Enabling</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Unsynced/>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TopRowVisible>3</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>26</ActiveRow>
     <ActiveCol>9</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>

    </xsl:template>
    <xsl:template match="node()" mode="sites">
    <xsl:variable name="thiscountry" select="$countries[name=current()/own_slot_value[slot_reference='site_geographic_location']/value]"/> 
     <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="$thiscountry/own_slot_value[slot_reference='name']/value"/></Data></Cell>
   </Row>
    </xsl:template>    
    <xsl:template match="node()" mode="businessDomains">
    <xsl:variable name="parentDomain" select="$businessDomains[own_slot_value[slot_reference='contained_business_domains']/value=current()/name]"/> 
        <xsl:apply-templates select="current()" mode="businessDomainsRow">
            <xsl:with-param name="parent" select="$parentDomain"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="node()" mode="businessDomainsRow">
    <xsl:param name="parent"/>
    <xsl:variable name="this" select="current()"/>    
    <xsl:choose>
        <xsl:when test="$parent">   
    <xsl:for-each select="$parent">
        <Row ss:Height="17">
        <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="$this/name"/></Data></Cell>
        <Cell ss:StyleID="s1142"><NamedCell ss:Name="Valid_Bus_Doms"/><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/></Data></Cell>
        <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Domains'!C[-3],1,0)),&quot;Parent must be defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
       </Row>
    </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
        <Row ss:Height="17">
        <Cell ss:Index="2" ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="$this/name"/></Data></Cell>
        <Cell ss:StyleID="s1142"><NamedCell ss:Name="Valid_Bus_Doms"/><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1142"><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/></Data></Cell>
        <Cell ss:StyleID="s1142"><Data ss:Type="String"></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Domains'!C[-3],1,0)),&quot;Parent must be defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
       </Row>
        </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>      
    
    <xsl:template match="node()" mode="businessCapabilities">
       <xsl:variable name="parentCap" select="$businessCapabilities[own_slot_value[slot_reference='contained_business_capabilities']/value=current()/name]"/>   
      <xsl:variable name="busDomain" select="$businessDomains[name=current()/own_slot_value[slot_reference='belongs_to_business_domain']/value]"/> 
        <xsl:choose><xsl:when test="$parentCap"><xsl:apply-templates select="$parentCap" mode="businessCapabilitiesRow"><xsl:with-param name="businessCap" select="current()"/></xsl:apply-templates></xsl:when><xsl:otherwise>
            <Row ss:Height="17" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_index']/value"/></Data></Cell>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"><Data ss:Type="String"><xsl:value-of select="$busDomain/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1071"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='business_capability_level']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
          </xsl:otherwise></xsl:choose>
    
    </xsl:template>
    <xsl:template match="node()" mode="businessCapabilitiesRow">
    <xsl:param name="businessCap"/>
     <xsl:variable name="busDomain" select="$businessDomains[name=current()/own_slot_value[slot_reference='belongs_to_business_domain']/value]"/>     
    <Row ss:Height="17" ss:StyleID="s1051">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="$businessCap/name"/></Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="$businessCap/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Bus_Caps"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String"><xsl:value-of select="$businessCap/own_slot_value[slot_reference='description']/value"/></Data></Cell>
        <Cell ss:StyleID="s1071"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1071"/>    
    <Cell ss:StyleID="s1050"><Data ss:Type="String"><xsl:value-of select="$businessCap/own_slot_value[slot_reference='business_capability_index']/value"/></Data></Cell>
    <Cell ss:StyleID="s1050"/>
    <Cell ss:StyleID="s1071"><Data ss:Type="String"><xsl:value-of select="$busDomain/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1071"> <Data ss:Type="String"><xsl:value-of select="$businessCap/own_slot_value[slot_reference='business_capability_level']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined in Column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Domains'!C[-9],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    </xsl:template>
    <xsl:template match="node()" mode="businessProcesses">
        
<Row ss:AutoFitHeight="0" ss:Height="18">
    <xsl:variable name="caps" select="$businessCapabilities[name=current()/own_slot_value[slot_reference='realises_business_capability']/value]"/>  
    <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
  <Cell ss:StyleID="s1061"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Valid_Bus_Proc"/><NamedCell
      ss:Name="Valid_Business_Processes"/></Cell>
    <Cell ss:StyleID="s1059"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1064"><Data ss:Type="String"><xsl:value-of select="$caps[1]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1064"><Data ss:Type="String"><xsl:value-of select="$caps[2]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1064"><Data ss:Type="String"><xsl:value-of select="$caps[3]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1064"><Data ss:Type="String"><xsl:value-of select="$caps[4]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-6],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-7],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-8],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&quot;Parent Capability must be already defined Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    </xsl:template>  
    <xsl:template match="node()" mode="busprocessfamily">
    <xsl:variable name="thisbusprocess" select="$busProcesses[name=current()/own_slot_value[slot_reference='bpf_contains_busproctypes']/value]"/> 
    
     <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$thisbusprocess/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1199"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&quot;Business Process must be already defined in Business Process sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>    
    </xsl:template>
     <xsl:template match="node()" mode="busprocessfamilyrow">
        <xsl:param name="fam"/> 
      <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$fam"/>:<xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$fam/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$fam/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1199"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Business Processes'!C[-3],1,0)),&quot;Business Process must be already defined in Business Process sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    </xsl:template>  
     <xsl:template match="node()" mode="actors">
      <xsl:variable name="parent" select="$actors[name=current()/own_slot_value[slot_reference='is_member_of_actor']/value]"/>
           <xsl:apply-templates select="current()" mode="actorsRow">
            <xsl:with-param name="parent" select="$parent"/>
        </xsl:apply-templates>
   <!--  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
         <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Organisations"/></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$parent/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1118"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='external_to_enterprise']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&quot;Organisation must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>-->
    </xsl:template>
    
    <xsl:template match="node()" mode="actorsRow">
    <xsl:param name="parent"/>
    <xsl:variable name="this" select="current()"/>    
    <xsl:choose>
        <xsl:when test="$parent">   
        <xsl:for-each select="$parent">
            <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$this/name"/></Data></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Organisations"/></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/></Data></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
            <Cell ss:StyleID="s1118"><Data ss:Type="String"><xsl:value-of select="$this/own_slot_value[slot_reference='external_to_enterprise']/value"/></Data></Cell>
            <Cell ss:StyleID="s1191"
             ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&quot;Organisation must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
              ss:Type="String"></Data></Cell>
           </Row>
        </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
            <Row ss:Height="17">
            <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Organisations"/></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
            <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$parent/own_slot_value[slot_reference='name']/value"/></Data></Cell>
            <Cell ss:StyleID="s1118"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='external_to_enterprise']/value"/></Data></Cell>
            <Cell ss:StyleID="s1191"
             ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-4],1,0)),&quot;Organisation must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
              ss:Type="String"></Data></Cell>
           </Row>
        </xsl:otherwise>
    </xsl:choose>       
    
    
    
    
    </xsl:template>     
    
    
    
    
    
    
<xsl:template match="node()" mode="actorsWithSites">
    <xsl:variable name="thisSite" select="$siteswithActors[name=current()/own_slot_value[slot_reference='actor_based_at_site']/value]"/>
       <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Organisations"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String"><xsl:value-of select="$thisSite/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Sites"/></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-1],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Sites!C[-2],1,0)),&quot;Site must be already defined in Sites sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   
    </xsl:template>   
<xsl:template match="node()" mode="applicationCapabilities">
    <xsl:variable name="busDomain" select="$businessDomains[name=current()/own_slot_value[slot_reference='mapped_to_business_domain']/value]"/>     
     <xsl:variable name="parent" select="$applicationCapabilities[name=current()/own_slot_value[slot_reference='contained_in_application_capability']/value]"/>     
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1034"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Valid_App_Caps"/></Cell>
       <Cell ss:StyleID="s1105"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
       <Cell ss:StyleID="s1034"></Cell>
    <Cell ss:StyleID="s1105"><Data ss:Type="String"><xsl:value-of select="$busDomain/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1105"/>
    <Cell ss:StyleID="s1064"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Domains'!C[-7],1,0)),&quot;Business Domain must be already defined in Business Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Application Capabilities'!C[-8],1,0)),&quot;Application Capability must be already defined in column C&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-4]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-4],'Business Capabilities'!C[-9],1,0)),&quot;Business Capability must be already defined in the Business Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
</xsl:template>
<xsl:template match="node()" mode="applicationServices">
 <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Valid_App_Services"/></Cell>
    <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
     <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-2],1,0)),&quot;OK&quot;,&quot;These Services look like your applications, try and break them down into what the applications does at a high level, 2-6 per application is about right&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell> 
</Row>
  </xsl:template>  
<xsl:template match="node()" mode="applicationCapServices">
    <xsl:variable name="cap" select="$applicationCapabilities[name=current()/own_slot_value[slot_reference='realises_application_capabilities']/value]"/>
    <xsl:if test="$cap">
      <xsl:apply-templates select="$cap" mode="capRow">
        <xsl:with-param name="svc" select="current()"/>
      </xsl:apply-templates>
   <!--<Row ss:Height="17">
       <Cell ss:Index="2" ss:StyleID="s1176"><Data ss:Type="String"><xsl:value-of select="$cap/own_slot_value[slot_reference='name']/value"/></Data></Cell>
       <Cell ss:StyleID="s1176"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Capabilities'!C[-1],1,0)),&quot;Application Capability must be already defined in Application Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>  -->       
 </xsl:if>
</xsl:template>
    
<xsl:template match="node()" mode="capRow">
<xsl:param name="svc"></xsl:param>    
    <Row ss:Height="17">
       <Cell ss:Index="2" ss:StyleID="s1176"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
       <Cell ss:StyleID="s1176"><Data ss:Type="String"><xsl:value-of select="$svc/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Capabilities'!C[-1],1,0)),&quot;Application Capability must be already defined in Application Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>        
    </xsl:template>    
    
  <xsl:template match="node()" mode="applications">  
      <Row ss:AutoFitHeight="0" ss:StyleID="s1046">
    <Cell ss:Index="2" ss:StyleID="s1025"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1027"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1028"><Data ss:Type="String"><xsl:value-of select="$codebase[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
          <Cell ss:StyleID="s1028"><Data ss:Type="String"><xsl:value-of select="$lifecycle[name=current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1028"><Data ss:Type="String"><xsl:value-of select="$delivery[name=current()/own_slot_value[slot_reference='ap_delivery_model']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(App_Type,RC[-3]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(Lifecycle_Statii,RC[-3]),&quot;OK&quot;,&quot;Lifecycle Status MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,IF(COUNTIF(App_Delivery_Models,RC[-3]),&quot;OK&quot;,&quot;Delivery Model MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    </xsl:template>
      <xsl:template match="node()" mode="applicationstoservices">
       
        <xsl:variable name="thisapr" select="$aprs[own_slot_value[slot_reference='role_for_application_provider']/value=current()/name]"/>
          <xsl:variable name="thisServ" select="$applicationServices[own_slot_value[slot_reference='provided_by_application_provider_roles']/value=$thisapr/name]"/>
          
          
   <xsl:apply-templates select="$thisServ" mode="applicationstoservicesrow">
          <xsl:with-param name="app" select="current()/own_slot_value[slot_reference='name']/value"/>
          </xsl:apply-templates>  
 
 <!--       <Row ss:Height="17" ss:StyleID="s1032">
           <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
           <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$thisServ/name"/></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
        </Row>-->
   
    </xsl:template>      
    <xsl:template match="node()" mode="applicationstoservicesrow">
        <xsl:param name="app"/>
        <Row ss:Height="17" ss:StyleID="s1032">
           <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$app"/></Data></Cell>
           <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
        <Cell ss:StyleID="s1191"
         ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
        </Row>
        
    </xsl:template>
    
    <xsl:template match="node()" mode="informationRepresentation">
    <Row ss:Height="17" ss:StyleID="s1032">
           <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
            <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
           <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
        </Row>
    </xsl:template>
    
    <xsl:template match="node()" mode="apporgusers">
        
          <xsl:variable name="thisact" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
          <xsl:variable name="thisRole" select="$actors[name=$thisact/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
        
          
          
  <xsl:apply-templates select="$thisRole" mode="applicationstoorgrow">
          <xsl:with-param name="app" select="current()"/>
          </xsl:apply-templates>
        
    </xsl:template>
    <xsl:template match="node()" mode="applicationstoorgrow"> 
    <xsl:param name="app"/>    
        <Row ss:Height="17">
         <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$app/own_slot_value[slot_reference='name']/value"/></Data></Cell>
         <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Applications!C[-1],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
    </xsl:template>
    
<xsl:template match="node()" mode="servers"> 
    <xsl:variable name="thissite" select="$sites[name=current()/own_slot_value[slot_reference='technology_deployment_located_at']/value]"/>
    <Row ss:AutoFitHeight="0" ss:Height="15">
    <Cell ss:Index="2" ss:StyleID="s1095"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1075"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Servers"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String"><xsl:value-of select="$thissite/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1076"/>
   </Row>
    </xsl:template>
    
  <xsl:template match="node()" mode="app2Serv"> 
    <xsl:variable name="thisappswinstance" select="$appswinstance[own_slot_value[slot_reference='technology_instance_deployed_on_node']/value=current()/name]"/> 
    <xsl:variable name="thisappsdeployment" select="$appsdeployment[own_slot_value[slot_reference='application_deployment_technology_instance']/value=$thisappswinstance/name]"/> 
    <xsl:variable name="thisapps" select="$applications[own_slot_value[slot_reference='deployments_of_application_provider']/value=$thisappsdeployment/name]"/> 
    
    <xsl:apply-templates select="$thisapps" mode="app2ServRow">
      <xsl:with-param name="srv" select="current()"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="node()" mode="app2ServRow"> 
    <xsl:param name="srv"></xsl:param>

    <xsl:variable name="thisappsdeployment" select="$appsdeployment[own_slot_value[slot_reference='application_provider_deployed']/value=current()/name]"/> 
    <xsl:variable name="thisdeploymentRole" select="$deploymentRole[name=$thisappsdeployment/own_slot_value[slot_reference='application_deployment_role']/value]"/> 
    <xsl:apply-templates select="$thisdeploymentRole" mode="app2ServByRow">
      <xsl:with-param name="srv" select="$srv"/>
      <xsl:with-param name="app" select="current()"/>
    </xsl:apply-templates>
   
  </xsl:template> 
  <xsl:template match="node()" mode="app2ServByRow">
    <xsl:param name="srv"></xsl:param>
    <xsl:param name="app"></xsl:param>
    
    <Row ss:AutoFitHeight="0" ss:Height="15">
      <Cell ss:Index="2" ss:StyleID="s1095"><Data ss:Type="String"><xsl:value-of select="$app/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1075"><Data ss:Type="String"><xsl:value-of select="$srv/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Servers"/></Cell>
      <Cell ss:StyleID="s1040"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1076"/>
    </Row>
  </xsl:template> 
  <xsl:template match="node()" mode="busproc2services">
    <!--- to do -->
    <xsl:variable name="thisappsvc2busproc" select="$appsvc2busproc[name=current()/own_slot_value[slot_reference='supports_business_process_appsvc']/value]"/>  
    <xsl:variable name="thisappsvc2busprocBus" select="$busProcesses[name=$thisappsvc2busproc/own_slot_value[slot_reference='appsvc_to_bus_to_busproc']/value]"/>
    <!--
    <Row ss:AutoFitHeight="0" ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s1095"><Data ss:Type="String"><xsl:value-of select="$thisappsvc2busprocBus/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1075"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Servers"/></Cell>
      <Cell ss:StyleID="s1040"><Data ss:Type="String"><xsl:value-of select="thisappsvc2busproc"/></Data></Cell>
      <Cell ss:Index="5" ss:StyleID="s1177"
        ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1178"
        ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
    </Row>
  -->
    <xsl:apply-templates select="$thisappsvc2busprocBus" mode="busproc2servicesByRow">
      <xsl:with-param name="svc" select="current()"/>
      <xsl:with-param name="criticality" select="$thisappsvc2busproc"></xsl:with-param>
    </xsl:apply-templates>
    
    
  
  </xsl:template>
  <xsl:template match="node()" mode="busproc2servicesByRow">
    <xsl:param name="svc"></xsl:param>
    <xsl:param name="criticality"></xsl:param>
    <xsl:variable name="criticalityVal" select="$businessCriticality[name=$criticality/own_slot_value[slot_reference='app_to_process_business_criticality']/value]"/>
    <Row ss:AutoFitHeight="0" ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s1095"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1075"><Data ss:Type="String"><xsl:value-of select="$svc/own_slot_value[slot_reference='name']/value"/></Data><NamedCell ss:Name="Servers"/></Cell>
      <Cell ss:StyleID="s1040"><Data ss:Type="String"><xsl:value-of select="$criticalityVal/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:Index="5" ss:StyleID="s1177"
        ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1178"
        ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Application Services'!C[-2],1,0)),&quot;Application Service must be already defined in Application Services sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
    </Row>
  </xsl:template>
  <xsl:template match="node()" mode="physapps">
    <xsl:variable name="thisbusproc" select="$busProcesses[name=current()/own_slot_value[slot_reference='implements_business_process']/value]"/>
    <xsl:variable name="thisorg" select="$a2r[name=current()/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
    <xsl:variable name="thisRoleDirect" select="$actors[name=current()/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
    <xsl:variable name="thisRoleIndirect" select="$actors[name=$thisorg/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
    <xsl:variable name="thisRole" select="$thisRoleDirect  union $thisRoleIndirect"/>
    <xsl:variable name="apprel" select="$physbusApp[name=current()/own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value]"/>
	  <xsl:variable name="thisapr" select="$aprs[name=$apprel/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
	  
    
    <xsl:variable name="thisapp" select="$applications[name=$thisapr/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
    <xsl:variable name="thisservice" select="$applicationServices[name=$thisapr/own_slot_value[slot_reference='implementing_application_service']/value]"/>
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$thisbusproc/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$thisRole/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1185"><Data ss:Type="String"><xsl:value-of select="$thisapp/own_slot_value[slot_reference='name']/value"/> as <xsl:value-of select="$thisservice/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
      ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
        ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
      ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
        ss:Type="String"></Data></Cell>
  </Row>
  </xsl:template>
  <xsl:template match="node()" mode="physappsdirect">
    <xsl:variable name="thisbusproc" select="$busProcesses[name=current()/own_slot_value[slot_reference='implements_business_process']/value]"/>
    <xsl:variable name="thisorg" select="$a2r[name=current()/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
    <xsl:variable name="thisRoleDirect" select="$actors[name=current()/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
    <xsl:variable name="thisRoleIndirect" select="$actors[name=$thisorg/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
    <xsl:variable name="thisRole" select="$thisRoleDirect  union $thisRoleIndirect"/>  <xsl:variable name="apprel" select="$physbusApp[name=current()/own_slot_value[slot_reference='phys_bp_supported_by_app_pro']/value]"/> 
	    <xsl:variable name="thisapp" select="$applications[name=$apprel/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
    
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$thisbusproc/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$thisRole/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1185"><Data ss:Type="String"><xsl:value-of select="$thisapp/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1191"
      ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Business Processes'!C[-2],1,0)),&quot;Business Process must be already defined in Business Processes sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
        ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1191"
      ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],Organisations!C[-3],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
        ss:Type="String"></Data></Cell>
  </Row>
  </xsl:template>	
  <xsl:template mode="techDomain" match="node()">
    <Row ss:Height="34">
      <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
        ss:Name="Technology_Domains"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"></Data></Cell>
    </Row>
    
  </xsl:template>
  <xsl:template mode="techCapabilities" match="node()">
    <xsl:variable name="parent" select="$techDomain[name=current()/own_slot_value[slot_reference='belongs_to_technology_domain']/value]"/>
   
    <Row ss:Height="34"> 
      <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data><NamedCell
        ss:Name="Technology_Capabilities"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$parent/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
        ss:Name="Technology_Domains"/></Cell>
      <Cell ss:StyleID="s1191"
        ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-1],'Technology Domains'!C[-3],1,0)),&quot;Technology Domain must be already defined in Technology Domains sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String">OK</Data></Cell>
    </Row>
    
  </xsl:template>
  <xsl:template mode="techComponents" match="node()">
    <xsl:variable name="parentCaps" select="$techCapabilities[name=current()/own_slot_value[slot_reference='realisation_of_technology_capability']/value]"/>
    
    <Row ss:Height="34"> 
      <Cell ss:Index="2" ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data><NamedCell
        ss:Name="Technology_Capabilities"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$parentCaps[1]/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
        ss:Name="Technology_Capabilities"/></Cell>
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$parentCaps[2]/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
        ss:Name="Technology_Capabilities"/></Cell>
        <Cell ss:StyleID="s1191"
          ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Capabilities'!C[-4],1,0)),&quot;Technology Capability must be already defined in Technology Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
            ss:Type="String">OK</Data></Cell>
        <Cell ss:StyleID="s1191"
          ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Capabilities'!C[-5],1,0)),&quot;Technology Capability must be already defined in Technology Capabilities sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
            ss:Type="String"></Data></Cell>
    </Row>
    
  </xsl:template>  
  <xsl:template mode="suppliers" match="node()">
  <Row>
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
      ss:Name="Technology_Product_Suppliers"></NamedCell></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
  </Row>
  </xsl:template>
  <xsl:template mode="prodFams" match="node()">
    <Row>
      <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
      <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
        ss:Name="Technology_Product_Suppliers"></NamedCell></Cell>
      <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    </Row>
  </xsl:template>
  <xsl:template match="node()" mode="techProducts">
    <xsl:variable name="thissupplier" select="$techSuppliers[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    <xsl:variable name="thisfamily" select="$techProdFams[name=current()/own_slot_value[slot_reference='name']/value]"/>
    <xsl:variable name="thisvendor" select="$techlifecycle[name=current()/own_slot_value[slot_reference='vendor_product_lifecycle_status']/value]"/>
    <xsl:variable name="thisdelivery" select="$techDeliveryModel[name=current()/own_slot_value[slot_reference='technology_provider_delivery_model']/value]"/>
    <xsl:variable name="thisusages" select="$tprs[name=current()/own_slot_value[slot_reference='implements_technology_components']/value]"/>
    <xsl:variable name="thisusages1" select="$techComponents[name=$thisusages[1]/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
    <xsl:variable name="thisusages2" select="$techComponents[name=$thisusages[2]/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
    <xsl:variable name="thisusages3" select="$techComponents[name=$thisusages[3]/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
    <xsl:variable name="thisusages4" select="$techComponents[name=$thisusages[4]/own_slot_value[slot_reference='implementing_technology_component']/value]"/>
  
  
    <Row>
      <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thissupplier/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisfamily/own_slot_value[slot_reference='technology_product_family']/value"/></Data></Cell>
      <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisvendor/own_slot_value[slot_reference='name']/value"/></Data></Cell> 
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisdelivery/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisusages1/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$thisusages[1]/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$lifecycle[name=$thisusages[1]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisusages2/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$thisusages[2]/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$lifecycle[name=$thisusages[2]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisusages3/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$thisusages[3]/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$lifecycle[name=$thisusages[3]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thisusages4/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$enumsStandards[name=$techStandards[own_slot_value[slot_reference='tps_standard_tech_provider_role']/value=$thisusages[4]/name]/own_slot_value[slot_reference='sm_standard_strength']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell  ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$lifecycle[name=$thisusages[4]/own_slot_value[slot_reference='strategic_lifecycle_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-15]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Product Families'!C[-18],1,0)),&quot;Technology Product Family must be already defined in Technology Product Families sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-15]&lt;&gt;&quot;&quot;,IF(COUNTIF(Tech_Vendor_Release_Statii,RC[-15]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-15]&lt;&gt;&quot;&quot;,IF(COUNTIF(Tech_Delivery_Models,RC[-15]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-15]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Components'!C[-21],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-13]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-13],'Technology Components'!C[-22],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-11]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-11],'Technology Components'!C[-23],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-9]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-9],'Technology Components'!C[-24],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-18]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-18],'Standards Compliance Levels'!C[-25],1,0)),&quot;Compliance Level must be already defined in Standards Compliance Levels sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-16]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-16],'Standards Compliance Levels'!C[-26],1,0)),&quot;Compliance Level must be already defined in Standards Compliance Levels sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-14]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-14],'Standards Compliance Levels'!C[-27],1,0)),&quot;Compliance Level must be already defined in Standards Compliance Levels sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell
        ss:Formula="=IF(RC[-12]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-12],'Standards Compliance Levels'!C[-28],1,0)),&quot;Compliance Level must be already defined in Standards Compliance Levels sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1200"
        ss:Formula="=IF(RC[-21]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-21],'Technology Adoption Statii'!C[-29],1,0)),&quot;Adoption Level must be already defined in Technology Adoption Statii sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String">Adoption Level must be already defined in Technology Adoption Statii sheet</Data></Cell>
      <Cell ss:StyleID="s1200"
        ss:Formula="=IF(RC[-19]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-19],'Technology Adoption Statii'!C[-30],1,0)),&quot;Adoption Level must be already defined in Technology Adoption Statii sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1200"
        ss:Formula="=IF(RC[-17]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-17],'Technology Adoption Statii'!C[-31],1,0)),&quot;Adoption Level must be already defined in Technology Adoption Statii sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1200"
        ss:Formula="=IF(RC[-15]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-15],'Technology Adoption Statii'!C[-32],1,0)),&quot;Adoption Level must be already defined in Technology Adoption Statii sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-15]:RC[-1], &quot;OK&quot;)"><Data
        ss:Type="Number">0</Data></Cell>
      <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-16]:RC[-2], &quot;&quot;)"><Data
        ss:Type="Number">14</Data></Cell>
      <Cell ss:StyleID="s1200" ss:Formula="=COUNTIF(RC[-17]:RC[-3],&quot;&lt;&gt;''&quot;)"><Data
        ss:Type="Number">15</Data></Cell>
      <Cell ss:StyleID="s1200"/>
    </Row>
  </xsl:template>
  <xsl:template match="node()" mode="techorgusers">
    
    <xsl:variable name="thisact" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]"/>
    <xsl:variable name="thisRole" select="$actors[name=$thisact/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
    
    
    
    <xsl:apply-templates select="$thisRole" mode="techorgrow">
      <xsl:with-param name="tech" select="current()"/>
    </xsl:apply-templates>
    
  </xsl:template>
  <xsl:template match="node()" mode="techorgrow"> 
    <xsl:param name="tech"/>    
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="$tech/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1172"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1191"
        ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Products'!C[-1],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1191"
        ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],Organisations!C[-2],1,0)),&quot;Organisation must be already defined in Organisations sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
    </Row>
  </xsl:template>
  <xsl:template match="node()" mode="dataSubject">
    <!-- last two need to be org roles as the slots have been deprecated -->
    <Row ss:AutoFitHeight="0" ss:Height="40" ss:StyleID="s1181">
      <Cell ss:Index="2" ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value][1]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value][2]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$dataCategory[name=current()/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$actors[name=current()/own_slot_value[slot_reference='data_subject_organisation_owner']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$individual[name=current()/own_slot_value[slot_reference='data_subject_individual_owner']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    </Row>
  </xsl:template>

  <xsl:template match="node()" mode="dataObject">
    <xsl:variable name="thisDataSubj" select="$dataSubjects[name=current()/own_slot_value[slot_reference='defined_by_data_subject']/value]"/>
    <xsl:apply-templates select="$thisDataSubj" mode="dataObjectRow"><xsl:with-param name="DO" select="current()"/></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="node()" mode="dataObjectRow">
    
    
    <xsl:param name="DO"></xsl:param>
    <Row ss:AutoFitHeight="0" ss:Height="36" ss:StyleID="s1181">
      <!-- last two need to be org roles as the slots have been deprecated -->
      <Cell ss:Index="2" ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$DO/name"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$DO/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$DO/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=$DO/own_slot_value[slot_reference='synonyms']/value][1]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=$DO/own_slot_value[slot_reference='synonyms']/value][2]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$dataCategory[name=$DO/own_slot_value[slot_reference='data_category']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1246"><Data ss:Type="String"><xsl:value-of select="$DO/own_slot_value[slot_reference='data_object_is_abstract']/value"/></Data></Cell> 
    </Row>
  </xsl:template> 
  <xsl:template match="node()" mode="dataSubtoObj">
    <xsl:variable name="childDO" select="$dataObjects[name=current()/own_slot_value[slot_reference='data_object_specialisations']/value]"/>
    <xsl:apply-templates select="$childDO" mode="dataSubtoObjRow"><xsl:with-param name="DO" select="current()"></xsl:with-param></xsl:apply-templates>

  </xsl:template>
  <xsl:template match="node()" mode="dataSubtoObjRow">
  <xsl:param name="DO"></xsl:param>
    <Row ss:AutoFitHeight="0" ss:Height="15">
      <Cell ss:Index="2" ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$DO/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:Index="5" ss:StyleID="s1259"
        ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Data Objects'!C[-2],1,0)),&quot;Data Object must be already defined in Data Objects&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s1259"
        ss:Formula="=IF(RC[-3]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-3],'Data Objects'!C[-3],1,0)),&quot;Data Object must be already defined in Data Objects&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
          ss:Type="String"></Data></Cell>
    </Row>
  </xsl:template>
  <xsl:template match="node()" mode="DOA">
    <Row ss:AutoFitHeight="0" ss:Height="15">
      <Cell ss:Index="2" ss:StyleID="s1251">
        <Data ss:Type="String"><xsl:value-of select="current()/name"/></Data>
      </Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$dataObjects[name=current()/own_slot_value[slot_reference='belongs_to_data_object']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value][1]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$synonyms[name=current()/own_slot_value[slot_reference='synonyms']/value][2]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$dataObjects[name=current()/own_slot_value[slot_reference='type_for_data_attribute']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:StyleID="s1251"><Data ss:Type="String"><xsl:value-of select="$primitiveDataObjects[name=current()/own_slot_value[slot_reference='type_for_data_attribute']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
 
      <Cell ss:StyleID="s1063"><Data ss:Type="String"><xsl:value-of select="$dataAttributeCardinality[name=current()/own_slot_value[slot_reference='data_attribute_cardinality']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
      <Cell ss:Index="12" ss:StyleID="s1259"
        ss:Formula="=IF(RC[-9]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-9],'Data Objects'!C[-9],1,0)),&#34;Data Object must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
        <Data ss:Type="String"/>
      </Cell>
      <Cell ss:StyleID="s1259"
        ss:Formula="=IF(RC[-5]&lt;&gt;&#34;&#34;,(IF(ISNA(VLOOKUP(RC[-5],'Data Objects'!C[-10],1,0)),&#34;Data Type must be already defined in Data Objects&#34;,&#34;OK&#34;)),&#34;&#34;)">
        <Data ss:Type="String"/>
      </Cell>
      <Cell ss:Formula="=IF(COUNTIF(RC[2]:RC[3], &#34;0&#34;)=0,&#34;You can only have 1 value across the two columns&#34;,&#34;&#34;)">
        <Data ss:Type="String"/>
      </Cell>
      <Cell ss:Index="16" ss:Formula="=#REF!">
        <Data ss:Type="Number">0</Data>
      </Cell>
      <Cell ss:Formula="=#REF!">
        <Data ss:Type="Number">0</Data>
      </Cell>
    </Row>
  </xsl:template>
	
<xsl:template match="node()" mode="cdbase">
 <xsl:variable name="thiselemStyles" select="$elemStyles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
  <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></Data></Cell>  
  <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></Data></Cell>  
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thiselemStyles[1]/own_slot_value[slot_reference='element_style_colour']/value"/></Data></Cell>
    <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="$thiselemStyles[1]/own_slot_value[slot_reference='element_style_class']/value"/></Data></Cell>
	   <Cell ss:StyleID="s1112"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_score']/value"/></Data></Cell>
  <Cell ss:StyleID="s1112"></Cell>
  <Cell ss:StyleID="s1112"></Cell>
    <Cell ss:StyleID="s1112"/>
   </Row>	
</xsl:template>		
</xsl:stylesheet>
