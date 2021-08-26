<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>


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

    <xsl:variable name="phyProc" select="/node()/simple_instance[type = 'Physical_Process']"/>
	<xsl:variable name="busProc" select="/node()/simple_instance[type = 'Business_Process']"/>
     <xsl:variable name="appSvs" select="/node()/simple_instance[type = 'Application_Service']"/>
	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"/>  
    <xsl:variable name="org" select="/node()/simple_instance[type = ('Group_Actor','Individual_Actor')]"/> 
    <xsl:variable name="obj" select="/node()/simple_instance[type = 'Business_Objective']"/>
	<xsl:template match="knowledge_base">

<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <Author>Essential Strategy Planner</Author>
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2018-11-26T17:58:06Z</Created>
  <LastSaved>2019-06-20T18:33:08Z</LastSaved>
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
  <WindowHeight>15040</WindowHeight>
  <WindowWidth>26440</WindowWidth>
  <WindowTopX>640</WindowTopX>
  <WindowTopY>460</WindowTopY>
  <ActiveSheet>6</ActiveSheet>
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
  <Style ss:ID="s57">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s58">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s59">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s60">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s61">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s62">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s63">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s64">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="16" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s65">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s66">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s67">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
 </Styles>
 <Worksheet ss:Name="Business Processes">
  <Table ss:ExpandedColumnCount="3"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($busProc)+8"/></xsl:attribute>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="188"/>
   <Row ss:Index="2" ss:Height="21">
    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Business Processes</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Name</Data></Cell>
   </Row>
   <xsl:apply-templates select="$busProc" mode="busProcesses">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
      <TabColorIndex>54</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>6</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Application Services">
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($appSvs)+8"/></xsl:attribute>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="152"/>
   <Row ss:Index="2" ss:Height="21">
    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Application Services</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Name</Data></Cell>
   </Row>
      <xsl:apply-templates select="$appSvs" mode="busProcesses">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
      <TabColorIndex>54</TabColorIndex>
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
 </Worksheet>
 <Worksheet ss:Name="Organisation">
  <Table ss:ExpandedColumnCount="3"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($org)+8"/></xsl:attribute>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="175"/>
   <Row ss:Index="2" ss:Height="21">
    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Organisation</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Name</Data></Cell>
   </Row>
    <xsl:apply-templates select="$org" mode="busProcesses">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
     
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
      <TabColorIndex>54</TabColorIndex>
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
 </Worksheet>
 <Worksheet ss:Name="Applications">
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($apps)+8"/></xsl:attribute>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="242"/>
   <Row ss:Index="2" ss:Height="21">
    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Applications</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Name</Data></Cell>
   </Row>
       <xsl:apply-templates select="$apps" mode="busProcesses">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>
    
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
      <TabColorIndex>54</TabColorIndex>
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
 </Worksheet>
<Worksheet ss:Name="Objectives">
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($obj)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="336"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="565"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Objectives</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">Objectives List - Edit in repository only</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Objective</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
      
    <xsl:apply-templates select="$obj" mode="nameDesc">
      <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
    </xsl:apply-templates>  
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
      <TabColorIndex>54</TabColorIndex>
   <Unsynced/>
   <Selected/>
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
 </Worksheet>     
 <Worksheet ss:Name="Roadmap">
  <Table ss:ExpandedColumnCount="4" ss:ExpandedRowCount="9" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="48"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="286"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="363"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Roadmap</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The roadmap to be created</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Roadmap Name</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s61"><Data ss:Type="String">RM1</Data></Cell>
    <Cell ss:StyleID="s61"><Data ss:Type="String">rm1</Data></Cell>
    <Cell ss:StyleID="s61"><Data ss:Type="String">sssss</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
    <Cell ss:StyleID="s65"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
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
 </Worksheet>
 <Worksheet ss:Name="Strategic Plans">
  <Table ss:ExpandedColumnCount="7" ss:ExpandedRowCount="8" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="34"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="140"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="322"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="93"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="101"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Strategic Plans</Data></Cell>
    <Cell ss:StyleID="s58"/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The strategic plans contained in the Roadmap</Data></Cell>
    <Cell ss:StyleID="s59"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Roadmap</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Strategic Plan Name</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">Start Date</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">End Date</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>5</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R6C2:R8C7</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R200C3</Range>
   <Type>List</Type>
   <Value>'Roadmap'!R8C3:R2000C3</Value>
  </DataValidation>
 </Worksheet>
 
 <Worksheet ss:Name="Strat Plan Objectives">
  <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="8" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="336"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="565"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Strategic Plan Objectives</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">Maps Strategic Plans to the Objectives that they support</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Supported Objective</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Selected/>
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
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R300C3</Range>
   <Type>List</Type>
   <Value>'Objectives'!R8C2:R201C2</Value>
  </DataValidation> 
 </Worksheet>
 <Worksheet ss:Name="Strat Plan Dependencies">
  <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="336"
    ss:Span="1"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Strategic Plan Dependencies</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">Define the dependencies between Strategic Plans</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Depends on Plan</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>15</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R300C3</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>     
 </Worksheet>
 <Worksheet ss:Name="App Planning Actions">
  <Table ss:ExpandedColumnCount="5" ss:ExpandedRowCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="207"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="335"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="322"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Application Planning Actions</Data></Cell>
    <Cell ss:StyleID="s58"/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The changes that are planned to Applications</Data></Cell>
    <Cell ss:StyleID="s59"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Impacted Application</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">Planned Change</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Change Rationale</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
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
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Applications'!R8C3:R300C3</Value>
  </DataValidation>  
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Enhance, Establish, Replace, Switch Off, Decommission, Outsource&quot;</Value>
  </DataValidation> 
 </Worksheet>
 <Worksheet ss:Name="App Svc Planning Actions">
  <Table ss:ExpandedColumnCount="5" ss:ExpandedRowCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="207"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="335"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="322"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Application Service Planning Actions</Data></Cell>
    <Cell ss:StyleID="s58"/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The changes that are planned to Application Services</Data></Cell>
    <Cell ss:StyleID="s59"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Impacted Application Service</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">Planned Change</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Change Rationale</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
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
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Application Services'!R8C3:R300C3</Value>
  </DataValidation>  
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Enhance, Establish, Replace, Switch Off, Decommission, Outsource&quot;</Value>
  </DataValidation>      
     
 </Worksheet>
 <Worksheet ss:Name="Bus Proc Planning Actions">
  <Table ss:ExpandedColumnCount="5" ss:ExpandedRowCount="8" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="207"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="335"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="322"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Business Process Planning Actions</Data></Cell>
    <Cell ss:StyleID="s58"/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The changes that are planned to Business Processes</Data></Cell>
    <Cell ss:StyleID="s59"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Impacted Business Process</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">Planned Change</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Change Rationale</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s65"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s67"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s66"><Data ss:Type="String"></Data></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>14</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R2000C3</Range>
   <Type>List</Type>
   <Value>'Business Processes'!R6C3:R2062C3</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Enhance, Establish, Replace, Switch Off, Decommission, Outsource&quot;</Value>
  </DataValidation>      
 </Worksheet>
 <Worksheet ss:Name="Org Planning Actions">
  <Table ss:ExpandedColumnCount="5" ss:ExpandedRowCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s57" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="207"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="335"/>
   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s57" ss:AutoFitWidth="0" ss:Width="322"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s58"><Data ss:Type="String">Organisation Planning Actions</Data></Cell>
    <Cell ss:StyleID="s58"/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s59"><Data ss:Type="String">The changes that are planned to Organisations</Data></Cell>
    <Cell ss:StyleID="s59"/>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s60"><Data ss:Type="String">Strategic Plan</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Impacted Organisation</Data></Cell>
    <Cell ss:StyleID="s63"><Data ss:Type="String">Planned Change</Data></Cell>
    <Cell ss:StyleID="s60"><Data ss:Type="String">Change Rationale</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>16</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R300C2</Range>
   <Type>List</Type>
   <Value>'Strategic Plans'!R8C4:R300C4</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R3000C3</Range>
   <Type>List</Type>
   <Value>'Organisation'!R8C3:R300C3</Value>
  </DataValidation>  
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Enhance, Establish, Replace, Switch Off, Decommission, Outsource&quot;</Value>
  </DataValidation>  
 </Worksheet>  
</Workbook>
	</xsl:template>
  
<xsl:template match="node()" mode="busProcesses">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
   </Row>
 
</xsl:template>   
 <xsl:template match="node()" mode="nameDesc">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
   </Row>
 
</xsl:template>    

</xsl:stylesheet>
