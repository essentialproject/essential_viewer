<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">
<xsl:import href="../common/core_js_functions.xsl"></xsl:import>

 <xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8" media-type="application/ms-excel"/>
<xsl:key name="prodTypeNameKey" match="/node()/simple_instance[type=('Product_Type','Composite_Product_Type')]" use="name"/>

<xsl:key name="proTypeKey" match="/node()/simple_instance[type=('Product_Type','Composite_Product_Type')]" use="type"/>
<xsl:variable name="productTypes" select="key('proTypeKey',('Product_Type','Composite_Product_Type'))"/>
<xsl:key name="valueStreamsKey" match="/node()/simple_instance[type=('Value_Stream')]" use="type"/>
<xsl:variable name="valueStreams" select="key('valueStreamsKey',('Value_Stream'))"/>
<xsl:key name="valueStagesKey" match="/node()/simple_instance[type=('Value_Stage')]" use="type"/>
<xsl:variable name="valueStages" select="key('valueStagesKey',('Value_Stage'))"/>
<xsl:key name="a2r_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"/>
<xsl:key name="eventNameKey" match="/node()/simple_instance[type = 'Business_Event']" use="name"/>
<xsl:key name="conditionNameKey" match="/node()/simple_instance[type = 'Business_Condition']" use="name"/>
<xsl:key name="conditionTypeKey" match="/node()/simple_instance[type = 'Business_Condition']" use="type"/>
<xsl:variable name="conditions" select="key('conditionTypeKey','Business_Condition')"/>
<xsl:key name="roleType_key" match="/node()/simple_instance[type = ('Business_Role_Type','Individual_Business_Role','Group_Business_Role')]" use="name"/> 

<xsl:key name="allActor2RoleRelations_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference = 'act_to_role_to_role']/value"/> 
<xsl:key name="allActor2RoleRelationsviaActor_key" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="own_slot_value[slot_reference = 'act_to_role_from_actor']/value"/> 
	
<xsl:key name="emotionKey" match="/node()/simple_instance[type = 'Customer_Emotion']" use="type"/>
<xsl:variable name="emotions" select="key('emotionKey',('Customer_Emotion'))"/>
<xsl:key name="emotionrelKey" match="/node()/simple_instance[type = 'VALUE_STAGE_TO_EMOTION_RELATION']" use="own_slot_value[slot_reference='value_stage_to_emotion_from_value_stage']/value"/>

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
 
	<xsl:variable name="busRole" select="/node()/simple_instance[type = 'Business_Role_Type']"/>
    <xsl:variable name="orgBusRole" select="/node()/simple_instance[type = 'Group_Business_Role']"/>
     <xsl:variable name="indivBusRole" select="/node()/simple_instance[type = 'Individual_Business_Role']"/>
    <xsl:variable name="busEvent" select="/node()/simple_instance[type = 'Business_Event']"/>
    <xsl:variable name="products" select="/node()/simple_instance[type = 'Product']"/>  
    <xsl:variable name="valueStreamsWithStages" select="$valueStreams[own_slot_value[slot_reference='vs_value_stages']/value=$valueStages/name]"/>
    <xsl:variable name="valueStageLabel" select="/node()/simple_instance[type = 'Label']"/>
	<xsl:template match="knowledge_base">
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Essential Development Team</Author>
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2018-07-02T09:12:33Z</Created>
  <LastSaved>2019-06-05T12:23:06Z</LastSaved>
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
  <WindowHeight>16540</WindowHeight>
  <WindowWidth>27440</WindowWidth>
  <WindowTopX>1360</WindowTopX>
  <WindowTopY>760</WindowTopY>
  <ActiveSheet>14</ActiveSheet>
  <FirstVisibleSheet>10</FirstVisibleSheet>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s16" ss:Name="Hyperlink">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#0563C1"
    ss:Underline="Single"/>
  </Style>
  <Style ss:ID="s17">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s18">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s19">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s20">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s21">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s22">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s23">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s24">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s25">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s26">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s27">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s28">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s29">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s30">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s31">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s32">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s33">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s34">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s35">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#DDEBF7" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s36">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#A6A6A6"/>
  </Style>
  <Style ss:ID="s37">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s39">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
  </Style>
  <Style ss:ID="s40">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s41">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s45">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#E2EFDA" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s46">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s48">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri (Body)" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s50" ss:Parent="s16">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s51" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s53">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri (Body)" ss:Size="16" ss:Color="#000000" ss:Bold="1"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="Business_Events" ss:RefersTo="='Business Events'!R7C3:R8C3"/>
  <NamedRange ss:Name="Business_Role_Types"
   ss:RefersTo="='Business Role Types'!R7C3:R8C3"/>
  <NamedRange ss:Name="Customer_Emotions"
   ss:RefersTo="='Customer Emotions'!R7C3:R106C3"/>
  <NamedRange ss:Name="Customer_Service_Qualities"
   ss:RefersTo="='Value Stage KPIs'!R7C3:R118C3"/>
  <NamedRange ss:Name="Individual_Business_Roles"
   ss:RefersTo="='Individual Business Roles'!R7C3:R8C3"/>
  <NamedRange ss:Name="Org_Business_Roles"
   ss:RefersTo="='Org Business Roles'!R7C3:R8C3"/>
  <NamedRange ss:Name="Physical_Processes" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Product_Types" ss:RefersTo="='Product Types'!R7C3:R395C3"/>
  <NamedRange ss:Name="Products" ss:RefersTo="='Product Types'!R7C3:R7C3"/>
  <NamedRange ss:Name="UoMs" ss:RefersTo="='Units of Measure'!R7C3:R429C3"/>
  <NamedRange ss:Name="Value_Stages" ss:RefersTo="='Value Stages'!R7C8:R162C8"/>
  <NamedRange ss:Name="Value_Streams" ss:RefersTo="='Value Streams'!R7C3:R95C3"/>
 </Names>
 <Worksheet ss:Name="Contents">
  <Table ss:ExpandedColumnCount="5"   x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="30"/>
   <Column ss:AutoFitWidth="0" ss:Width="174"/>
   <Column ss:AutoFitWidth="0" ss:Width="117"/>
   <Column ss:AutoFitWidth="0" ss:Width="182"/>
   <Column ss:AutoFitWidth="0" ss:Width="156"/>
   <Row ss:Index="2" ss:Height="21">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s53"><Data ss:Type="String">Value Stream Definition Woeksheet</Data></Cell>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s48"><Data ss:Type="String">Map the Value Streams to the value sttreams to the products and roles and the expected conditions and emotions</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s48"/>
    <Cell ss:StyleID="s48"/>
    <Cell ss:StyleID="s48"/>
    <Cell ss:StyleID="s48"/>
   </Row>
   <Row ss:Index="6" ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s45"><Data ss:Type="String">Worksheet</Data></Cell>
    <Cell ss:StyleID="s45"><Data ss:Type="String">Type</Data></Cell>
    <Cell ss:StyleID="s45"><Data ss:Type="String">Worksheet Content Source</Data></Cell>
    <Cell ss:StyleID="s45"><Data ss:Type="String">Notes</Data></Cell>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Product Types'!A1"><Data
      ss:Type="String">Product Types</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pulled from Repo</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Business Role Types'!A1"><Data
      ss:Type="String">Business Role Types</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pulled from Repo</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Org Business Roles'!A1"><Data
      ss:Type="String">Org Bud Roles</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pulled from Repo</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Individual Business Roles'!A1"><Data
      ss:Type="String">Indiv Bus Roles</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pulled from Repo</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Business Events'!A1"><Data
      ss:Type="String">Business Events</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pulled from Repo</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Streams'!A1"><Data
      ss:Type="String">Value Streams</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">New</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stream 2 Stakeholders'!A1"><Data
      ss:Type="String">Value Streams to Stakeholders</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stream 2 Product Types'!A1"><Data
      ss:Type="String">Value Streams to Product Types</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stream 2 Events'!A1"><Data
      ss:Type="String">Value Streams to Events</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stages'!A1"><Data
      ss:Type="String">Value Stages</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Catalogue</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">New</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stage 2 Participants'!A1"><Data
      ss:Type="String">Value Stage to Participants</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stages 2 Emotions'!A1"><Data
      ss:Type="String">Value Stage to Emotion</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stages 2 KPI Values'!A1"><Data
      ss:Type="String">Value Stage Target KPIs</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Mapping from within worksheet</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stage Criteria'!A1"><Data
      ss:Type="String">Value stage Criteria</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Enumeration</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pallette</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Customer Emotions'!A1"><Data
      ss:Type="String">Customer Emotions</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Enumeration</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pallette</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17" ss:StyleID="s24">
    <Cell ss:Index="2" ss:StyleID="s50" ss:HRef="#'Value Stage KPIs'!A1"><Data
      ss:Type="String">Value Stage KPIs</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Enumeration</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pallette</Data></Cell>
    <Cell ss:StyleID="s46"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s51" ss:HRef="#'Units of Measure'!A1"><Data
      ss:Type="String">Unit of Measure</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Enumeration</Data></Cell>
    <Cell ss:StyleID="s46"><Data ss:Type="String">Pallette</Data></Cell>
    <Cell ss:StyleID="s46"/>
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
     <ActiveRow>9</ActiveRow>
     <ActiveCol>7</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Product Types">
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($productTypes)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="447"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Product Types</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Products associated with Customer Journeys</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
<Row ss:AutoFitHeight="0" ss:Height="6"/>
    <xsl:apply-templates select="$productTypes" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>

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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Business Role Types">
  <Names>
   <NamedRange ss:Name="Product_Types"
    ss:RefersTo="='Business Role Types'!R7C3:R392C3"/>
   <NamedRange ss:Name="Products" ss:RefersTo="='Business Role Types'!R7C3:R8C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($busRole)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="291"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Business Role Types</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Business Role Types associated with Value Streams or Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
    <xsl:apply-templates select="$busRole" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Org Business Roles">
  <Names>
   <NamedRange ss:Name="Business_Role_Types"
    ss:RefersTo="='Org Business Roles'!R7C3:R8C3"/>
   <NamedRange ss:Name="Product_Types"
    ss:RefersTo="='Org Business Roles'!R7C3:R396C3"/>
   <NamedRange ss:Name="Products" ss:RefersTo="='Org Business Roles'!R7C3:R8C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($orgBusRole)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Organisation Business Roles</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Organisation Business Roles associated with Value Streams or Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
    <xsl:apply-templates select="$orgBusRole" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Individual Business Roles">
  <Names>
   <NamedRange ss:Name="Business_Role_Types"
    ss:RefersTo="='Individual Business Roles'!R7C3:R8C3"/>
   <NamedRange ss:Name="Product_Types"
    ss:RefersTo="='Individual Business Roles'!R7C3:R396C3"/>
   <NamedRange ss:Name="Products"
    ss:RefersTo="='Individual Business Roles'!R7C3:R8C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($indivBusRole)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Individual Business Roles</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Individual Business Roles associated with Value Streams or Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <xsl:apply-templates select="$indivBusRole" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Business Conditions">
  <Names>
   <NamedRange ss:Name="Business_Role_Types"
    ss:RefersTo="='Business Events'!R7C3:R8C3"/>
   <NamedRange ss:Name="Product_Types" ss:RefersTo="='Business Events'!R7C3:R392C3"/>
   <NamedRange ss:Name="Products" ss:RefersTo="='Business Events'!R7C3:R8C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Business Conditions</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Business Conditions used in Value Streams or Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <xsl:apply-templates select="$conditions" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
      </xsl:apply-templates>
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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Business Events">
  <Names>
   <NamedRange ss:Name="Business_Role_Types"
    ss:RefersTo="='Business Events'!R7C3:R8C3"/>
   <NamedRange ss:Name="Product_Types" ss:RefersTo="='Business Events'!R7C3:R392C3"/>
   <NamedRange ss:Name="Products" ss:RefersTo="='Business Events'!R7C3:R8C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($busEvent)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="54"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Business Events</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Business Events that trigger or occur as a result of Value Streams or Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <xsl:apply-templates select="$busEvent" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
      </xsl:apply-templates>
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
     <ActiveRow>28</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Value Streams">
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="44"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="447"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="557"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Value Streams</Data></Cell>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Value Streams</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">VS1</Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"> </Data><NamedCell
      ss:Name="Value_Streams"/></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <xsl:apply-templates select="$valueStreams" mode="nameDesc">
    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>

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
   <Range>R8C2:R8C4</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Value Stream 2 Stakeholders">
  <Names>
   <NamedRange ss:Name="Roadmaps"
    ss:RefersTo="='Value Stream 2 Stakeholders'!R7C2:R8C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="5"   x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:AutoFitWidth="0" ss:Width="270" ss:Span="2"/>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s18"><Data ss:Type="String">Value Stream to Stakeholder Mappings</Data></Cell>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps Value Streams to Business Roles/Role Types that initiate their execution</Data></Cell>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Value Stream</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Business Role Type</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Individual Business Role</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Organisation Business Role</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>

 
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
   </Row>
   <xsl:apply-templates select="$valueStreams" mode="vsOrg">
    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
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
     <RangeSelection>R9:R320</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Streams'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Business Role Types'!R8C3:R2010C3</Value>
      
  </DataValidation>
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3000C4</Range>
   <Type>List</Type>
   <Value>'Individual Business Roles'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'Org Business Roles'!R8C3:R2010C3</Value>
      
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Value Stream 2 Product Types">
  <Names>
   <NamedRange ss:Name="Roadmaps"
    ss:RefersTo="='Value Stream 2 Product Types'!R7C2:R8C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="3"   x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:AutoFitWidth="0" ss:Width="347"/>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s18"><Data ss:Type="String">Value Stream to Product Type Mappings</Data></Cell>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps Value Streams to their associated Product Types</Data></Cell>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Value Stream</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Product Type</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>

   <xsl:apply-templates select="$valueStreams" mode="vsProd"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
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
     <ActiveRow>8</ActiveRow>
     <RangeSelection>R9:R275</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Streams'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Product Types'!R8C3:R2010C3</Value>
      
  </DataValidation>     

 </Worksheet>
 <Worksheet ss:Name="Value Stream 2 Events">
  <Names>
   <NamedRange ss:Name="Roadmaps" ss:RefersTo="='Value Stream 2 Events'!R7C2:R8C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="6"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s24" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="247"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="352"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="244"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="364"/>
   <Row ss:Index="2" ss:Height="27">
    <Cell ss:Index="2" ss:StyleID="s37"><Data ss:Type="String">Value Stream to Event Mappings</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="1"><Data ss:Type="String">Maps Value Streams to their associated Business Events and Conditions</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s29"><Data ss:Type="String">Value Stream</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Trigger Event</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Trigger Conditon</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Outcome Event</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Outcome Condition</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <xsl:apply-templates select="$valueStreams" mode="vsEvent"/>
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
     <RangeSelection>R9:R276</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
   <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Streams'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3,R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'Business Events'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
    <Range>R8C4:R3000C4,R8C6:R3000C6</Range>
    <Type>List</Type>
    <Value>'Business Conditions'!R8C3:R2010C3</Value>
       
   </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Value Stages">
  <Names>
   <NamedRange ss:Name="Arch_States" ss:RefersTo="='Value Stages'!R7C7:R8C7"/>
  </Names>
  <Table ss:ExpandedColumnCount="8"   x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="44"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="195" ss:Span="1"/>
   <Column ss:Index="5" ss:StyleID="s31" ss:AutoFitWidth="0" ss:Width="50"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="309"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="362"/>
   <Column ss:StyleID="s36" ss:AutoFitWidth="0" ss:Width="183"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Value Stages</Data></Cell>
    <Cell ss:StyleID="s26"/>
    <Cell ss:StyleID="s26"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Provides the list of Value Stages</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Parent Value Stream</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Parent Value Stage</Data></Cell>
    <Cell ss:StyleID="s32"><Data ss:Type="String">Index</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Stage Name</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Description</Data></Cell>
       <Cell ss:StyleID="s28"><Data ss:Type="String">Make sure to copy this cell down</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s33"><Data ss:Type="Number"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><NamedCell ss:Name="Arch_States"/></Cell>
    <Cell ss:Formula="=CONCATENATE(RC[-5],RC[-4],&quot;: &quot;,RC[-3],&quot;. &quot;,RC[-2])"><Data
      ss:Type="String"></Data><NamedCell
      ss:Name="Value_Stages"/></Cell>
   </Row>
 
<xsl:apply-templates select="$valueStages" mode="vstages"/>
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
     <RangeSelection>R9:R269</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2,R8C6:R8C7</Range>
   <UseBlank/>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5</Range>
   <Type>Whole</Type>
   <Qualifier>GreaterOrEqual</Qualifier>
   <UseBlank/>
   <Value>0</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Value Streams'!R8C3:R2010C3</Value>
      
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3000C4</Range>
   <Type>List</Type>
   <Value>'Value Stages'!R8C8:R2010C8</Value>
      
  </DataValidation>

 </Worksheet>
 <Worksheet ss:Name="Value Stage 2 Participants">
  <Names>
   <NamedRange ss:Name="Roadmaps"
    ss:RefersTo="='Value Stage 2 Participants'!R7C2:R8C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="5"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:AutoFitWidth="0" ss:Width="270" ss:Span="2"/>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s18"><Data ss:Type="String">Value Stream to Participant Mappings</Data></Cell>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps Value Streams to Business Roles/Role Types that participate in them</Data></Cell>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Value Stage</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Business Role Type</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Individual Business Role</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Organisation Business Role</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
   <xsl:apply-templates select="$valueStages" mode="vsOrgStage">
    <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"/>
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
     <ActiveRow>8</ActiveRow>
     <RangeSelection>R9:R277</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Stages'!R8C8:R2010C8</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'Org Business Roles'!R8C3:R2010C3</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3000C4</Range>
   <Type>List</Type>
   <Value>'Individual Business Roles'!R8C3:R2010C3</Value>
      
  </DataValidation>
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Business Role Types'!R8C3:R2010C3</Value>
      
  </DataValidation>
 
 </Worksheet>
 <Worksheet ss:Name="Value Stages 2 Emotions">
  <Names>
   <NamedRange ss:Name="Roadmaps"
    ss:RefersTo="='Value Stages 2 Emotions'!R7C2:R8C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="118"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="464"/>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s24"/>
   </Row>
   <Row ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Value Stage to Target Emotion Mappings</Data></Cell>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps Value Stages to their associated Emotions</Data></Cell>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s24"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">Value Stage</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Target Emotion</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Target Emotion Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s24"/>
   </Row>

   <xsl:apply-templates select="$valueStages" mode="vsemotions"/>
   
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
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Customer_Emotions</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Stages'!R8C8:R2010C8</Value>
      
  </DataValidation>
 </Worksheet>     
 <Worksheet ss:Name="Value Stages 2 KPI Values">
  <Table ss:ExpandedColumnCount="5"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:AutoFitWidth="0" ss:Width="270"/>
   <Column ss:AutoFitWidth="0" ss:Width="158"/>
   <Column ss:AutoFitWidth="0" ss:Width="238"/>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s18"><Data ss:Type="String">Value Stage Target KPI Values</Data></Cell>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Maps Customer Journey Phases to their associated Service Qualities</Data></Cell>
    <Cell ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">Value Stage</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Target KPI</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Target KPI Value</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Unit of Measure (Optional)</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="3" ss:StyleID="s20"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number"></Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String"></Data></Cell>
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
     <ActiveRow>8</ActiveRow>
     <RangeSelection>R9:R642</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Customer_Service_Qualities</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Stages'!R8C8:R2010C8</Value>
      
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3000C5</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>UoMs</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Value Stage Criteria">
  <Names>
   <NamedRange ss:Name="Roadmaps" ss:RefersTo="='Value Stage Criteria'!R7C2:R36C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="6"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s24" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="247"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="352"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="244"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="364"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s37"><Data ss:Type="String">Value Stage to Entrance/Exit Criteria Mappings</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="1"><Data ss:Type="String">Maps Value Stages to their associated entrance/exit Business Events and Conditions</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s29"><Data ss:Type="String">Value Stage</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Entrance Event</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Entrance Condition</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Exit Event</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Exit Condition</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
   </Row>
   <xsl:apply-templates select="$valueStages" mode="vsConditions"/>

   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"><NamedCell ss:Name="Roadmaps"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s25"/>
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3,R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'Business Events'!R8C3:R2010C3</Value>
      
  </DataValidation>     
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
    <Range>R8C4:R3000C4,R8C6:R3000C6</Range>
    <Type>List</Type>
    <Value>'Business Conditions'!R8C3:R2010C3</Value>
       
   </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Value Stages'!R8C8:R2010C8</Value>
      
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Customer Emotions">
  <Table ss:ExpandedColumnCount="11"   x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="58"/>
   <Column ss:AutoFitWidth="0" ss:Width="156"/>
   <Column ss:StyleID="s20" ss:AutoFitWidth="0" ss:Width="262"/>
   <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="145"/>
   <Column ss:AutoFitWidth="0" ss:Width="60"/>
   <Column ss:AutoFitWidth="0" ss:Width="70"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:StyleID="s20" ss:AutoFitWidth="0" ss:Width="291"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Customer Emotions</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Emotion Name</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Index</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE1</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Bored</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">boredEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-8</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE2</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Confused</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">confusedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-3</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE3</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Deceived</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">deceivedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-10</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE4</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Grateful</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">gratefulEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE5</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Disappointed</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">disappointedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-10</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE6</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Excited</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">excitedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">6</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">8</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE7</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Impatient</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">impatientEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">7</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-8</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE8</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Surprised</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">surprisedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">8</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">6</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE9</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Worried</Data><NamedCell
      ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"><Data ss:Type="String">worriedEmotion</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">9</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="Number">-7</Data></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE10</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE11</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE12</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE13</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE14</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE15</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE16</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE17</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE18</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE19</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE20</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE21</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE22</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE23</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE24</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE25</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE26</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE27</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE28</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE29</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE30</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE31</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE32</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE33</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE34</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE35</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE36</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE37</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE38</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE39</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE40</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE41</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE42</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE43</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE44</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE45</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE46</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE47</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE48</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE49</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE50</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE51</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE52</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE53</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE54</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE55</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE56</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE57</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE58</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE59</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE60</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE61</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE62</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE63</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE64</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE65</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE66</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE67</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE68</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE69</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE70</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE71</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE72</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE73</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE74</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE75</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE76</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE77</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE78</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE79</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE80</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE81</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE82</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE83</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE84</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE85</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE86</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE87</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE88</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE89</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE90</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE91</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE92</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE93</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE94</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE95</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE96</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE97</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE98</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">CE99</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="Customer_Emotions"/></Cell>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s17"/>
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
   <TabColorIndex>45</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>24</ActiveRow>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Value Stage KPIs">
  <Table ss:ExpandedColumnCount="7"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s23" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="193"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="360"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="203"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="247"/>
   <Column ss:StyleID="s23" ss:AutoFitWidth="0" ss:Width="118"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Customer Service Qualities</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s27"><Data ss:Type="String">Service Quality</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ1</Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String">Docments Reviewed</Data><NamedCell
      ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ2</Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String">Documents Classified Official</Data><NamedCell
      ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ3</Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String">Records Missing/Altered</Data><NamedCell
      ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ4</Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String">Records Held Beyond Retention</Data><NamedCell
      ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ5</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ6</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ7</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ8</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ9</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ10</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ11</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ12</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ13</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ14</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ15</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ16</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ17</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ18</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ19</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ20</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ21</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ22</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ23</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ24</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ25</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ26</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ27</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ28</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ29</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ30</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ31</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ32</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ33</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ34</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ35</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ36</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ37</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ38</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ39</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ40</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ41</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ42</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ43</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ44</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ45</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ46</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ47</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ48</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ49</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ50</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ51</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ52</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ53</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ54</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ55</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ56</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ57</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ58</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ59</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ60</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ61</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ62</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ63</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ64</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ65</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ66</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ67</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ68</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ69</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ70</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ71</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ72</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ73</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ74</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ75</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ76</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ77</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ78</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ79</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ80</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ81</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ82</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ83</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ84</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ85</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ86</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ87</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ88</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ89</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ90</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ91</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ92</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ93</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ94</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ95</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ96</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ97</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ98</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ99</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ100</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String">CSQ101</Data></Cell>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"><NamedCell ss:Name="Customer_Service_Qualities"/></Cell>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
    <Cell ss:StyleID="s28"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>45</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>24</ActiveRow>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Units of Measure">
  <Table ss:ExpandedColumnCount="5"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="248"/>
   <Column ss:AutoFitWidth="0" ss:Width="324"/>
   <Column ss:StyleID="s39" ss:AutoFitWidth="0" ss:Width="73"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="3" ss:StyleID="s18"><Data ss:Type="String">Units of Measure</Data></Cell>
    <Cell ss:StyleID="s18"/>
   </Row>
   <Row>
    <Cell ss:Index="3"><Data ss:Type="String">Defines the allowed units of measure for KPI values</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s19"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Unit Name</Data></Cell>
    <Cell ss:StyleID="s19"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s40"><Data ss:Type="String">Symbol</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">UOM1</Data></Cell>
    <Cell ss:StyleID="s17"><Data ss:Type="String">Percentage</Data><NamedCell
      ss:Name="UoMs"/></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"><Data ss:Type="String">%</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">UOM2</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="UoMs"/></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">UOM3</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="UoMs"/></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">UOM4</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="UoMs"/></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"><Data ss:Type="String">UOM5</Data></Cell>
    <Cell ss:StyleID="s17"><NamedCell ss:Name="UoMs"/></Cell>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s17"/>
    <Cell ss:StyleID="s41"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>45</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>24</ActiveRow>
     <ActiveCol>6</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
	</xsl:template>


 <xsl:template match="node()" mode="nameDesc">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceDescription">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
   </Row>
 
</xsl:template>   

<xsl:template match="node()" mode="vsEvent">
  <xsl:variable name="thisStream" select="current()"/> 
  <xsl:variable name="thisTrigEv" select="key('eventNameKey',current()/own_slot_value[slot_reference='vs_trigger_events']/value)"/>
  <xsl:variable name="thisOutEv" select="key('eventNameKey',current()/own_slot_value[slot_reference='vs_outcome_events']/value)"/>
  <xsl:variable name="thisTrigCon" select="key('conditionNameKey',current()/own_slot_value[slot_reference='vs_trigger_conditions']/value)"/>
  <xsl:variable name="thisOutCon" select="key('conditionNameKey',current()/own_slot_value[slot_reference='vs_outcome_conditions']/value)"/>
  <xsl:for-each select="$thisTrigEv">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data><NamedCell
        ss:Name="Roadmaps"/></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>

  <xsl:for-each select="$thisTrigCon">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data><NamedCell
        ss:Name="Roadmaps"/></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>   
  <xsl:for-each select="$thisOutEv">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data><NamedCell
        ss:Name="Roadmaps"/></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell> 
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>
  <xsl:for-each select="$thisOutCon">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data><NamedCell
        ss:Name="Roadmaps"/></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell> 
     </Row> 
  </xsl:for-each>
 
</xsl:template>
 
<xsl:template match="node()" mode="vsProd">
  <xsl:variable name="thisStream" select="current()"/> 
  <xsl:variable name="thisProd" select="key('prodTypeNameKey',current()/own_slot_value[slot_reference='vs_product_types']/value)"/>
  <xsl:for-each select="$thisProd">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
   </Row>
  </xsl:for-each>
</xsl:template>


<xsl:template match="node()" mode="vsOrgStage">
  <xsl:variable name="thisStage" select="current()"/> 
  <xsl:variable name="thisRole" select="key('roleType_key',current()/own_slot_value[slot_reference='vsg_participants']/value)"/> 
  <xsl:variable name="roleType" select="$thisRole[type='Business_Role_Type']"/> 
  <xsl:variable name="roleGroup" select="$thisRole[type='Group_Business_Role']"/> 
  <xsl:variable name="roleIndividual" select="$thisRole[type='Individual_Business_Role']"/>  
  <xsl:for-each select="$roleType">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
   </Row>
  </xsl:for-each> 
  <xsl:for-each select="$roleIndividual">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
   </Row>
  </xsl:for-each>
  <xsl:for-each select="$roleGroup">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
   </Row>
</xsl:for-each>
</xsl:template>


<xsl:template match="node()" mode="vsOrg">
  <xsl:variable name="thisStream" select="current()"/> 
  <xsl:variable name="thisRole" select="key('roleType_key',current()/own_slot_value[slot_reference='vs_trigger_business_roles']/value)"/> 
  <xsl:variable name="roleType" select="$thisRole[type='Business_Role_Type']"/> 
  <xsl:variable name="roleGroup" select="$thisRole[type='Group_Business_Role']"/> 
  <xsl:variable name="roleIndividual" select="$thisRole[type='Individual_Business_Role']"/>  
  <xsl:for-each select="$roleType">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
   </Row>
  </xsl:for-each> 
  <xsl:for-each select="$roleIndividual">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
   </Row>
  </xsl:for-each>
  <xsl:for-each select="$roleGroup">
  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s22"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
   </Row>
</xsl:for-each>
</xsl:template>


<xsl:template match="node()" mode="vstages">
  <xsl:variable name="thisStage" select="current()"/> 
  <xsl:variable name="thisStream" select="$valueStreams[name=current()/own_slot_value[slot_reference='vsg_value_stream']/value]"/> 
  <xsl:variable name="thisParentStage" select="$valueStages[name=current()/own_slot_value[slot_reference='vsg_value_stream']/value]"/>
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s28"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
      <Cell ss:StyleID="s28"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStream"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s28"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisParentStage"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s33"><Data ss:Type="Number"><xsl:value-of select="$thisStage/own_slot_value[slot_reference='vsg_index']/value"/></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceDescription">
      <xsl:with-param name="theSubjectInstance" select="current()"/>
      <xsl:with-param name="isRenderAsJSString" select="true()"/>
  </xsl:call-template></Data></Cell>
      <Cell ss:Formula="=CONCATENATE(RC[-5],RC[-4],&quot;: &quot;,RC[-3],&quot;. &quot;,RC[-2])"><Data
        ss:Type="String"></Data><NamedCell
        ss:Name="Value_Stages"/></Cell>
     </Row>
 
    </xsl:template>
<xsl:template match="node()" mode="vsemotions">
<xsl:variable name="emotionsrel" select="key('emotionrelKey',current()/name)"/>
<xsl:variable name="thisemotions" select="$emotions[name=$emotionsrel/own_slot_value[slot_reference='value_stage_to_emotion_to_emotion']/value]"/>
<Row ss:Height="17">
  <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
    <xsl:with-param name="theSubjectInstance" select="current()"/>
    <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template></Data><NamedCell
    ss:Name="Roadmaps"/></Cell>
  <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
    <xsl:with-param name="theSubjectInstance" select="$thisemotions"/>
    <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template></Data></Cell>
  <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceDescription">
    <xsl:with-param name="theSubjectInstance" select="$thisemotions"/>
    <xsl:with-param name="isRenderAsJSString" select="true()"/>
</xsl:call-template></Data></Cell>
 </Row>
</xsl:template>

<xsl:template match="node()" mode="vsConditions">
  <xsl:variable name="thisStage" select="current()"/> 
  <xsl:variable name="thisEntEv" select="key('eventNameKey',current()/own_slot_value[slot_reference='vsg_entrance_events']/value)"/>
  <xsl:variable name="thisExEv" select="key('eventNameKey',current()/own_slot_value[slot_reference='vsg_exit_events']/value)"/>
  <xsl:variable name="thisEntCon" select="key('conditionNameKey',current()/own_slot_value[slot_reference='vsg_entrance_conditions']/value)"/>
  <xsl:variable name="thisExCon" select="key('conditionNameKey',current()/own_slot_value[slot_reference='vsg_exit_conditions']/value)"/>
  <xsl:for-each select="$thisEntEv">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>

  <xsl:for-each select="$thisEntCon">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>   
  <xsl:for-each select="$thisExEv">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data><NamedCell
        ss:Name="Roadmaps"/></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell> 
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
     </Row> 
  </xsl:for-each>
  <xsl:for-each select="$thisExCon">
    <Row ss:Height="17">
      <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="$thisStage"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
      <Cell ss:StyleID="s25"><Data ss:Type="String"><xsl:call-template name="RenderMultiLangInstanceName">
        <xsl:with-param name="theSubjectInstance" select="current()"/>
        <xsl:with-param name="isRenderAsJSString" select="true()"/>
    </xsl:call-template></Data></Cell> 
     </Row> 
  </xsl:for-each>

  <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s25"><Data ss:Type="String"></Data></Cell>
   </Row>
</xsl:template>
</xsl:stylesheet>
