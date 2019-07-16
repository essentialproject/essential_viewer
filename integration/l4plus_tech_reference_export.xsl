<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="iso-8859-1"/>


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
    <xsl:variable name="techProds" select="/node()/simple_instance[type = ('Technology_Product')]"/>  
    <xsl:variable name="techComps" select="/node()/simple_instance[type = ('Technology_Component')]"/> 
    <xsl:variable name="ref" select="/node()/simple_instance[type = ('Lifecycle_Status')][own_slot_value[slot_reference='name']/value='Reference']"/> 
    <xsl:variable name="techComposite" select="/node()/simple_instance[type = ('Technology_Composite')][own_slot_value[slot_reference='technology_component_lifecycle_status']/value=$ref/name]"/> 
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
  <Title>Data Capture</Title>
  <LastAuthor>Microsoft Office User</LastAuthor>
  <LastPrinted>2015-03-25T10:08:50Z</LastPrinted>
  <Created>2011-10-13T14:06:02Z</Created>
  <LastSaved>2019-06-24T13:23:41Z</LastSaved>
  <Company>EAS Ltd</Company>
  <Version>16.00</Version>
 </DocumentProperties>
 <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <ContentTypeId dt:dt="string">0x0101002F8DA711805F0A429105FD5A60F3101A</ContentTypeId>
  <TaxKeyword dt:dt="string"></TaxKeyword>
 </CustomDocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <SupBook>
   <Path>https://easglobal-my.sharepoint.com/Users/jasonpowell/OneDrive - Enterprise Architecture Solutions Limited/Clients/CCI/Investmenyt Planning/Data Capture/Technology Catalogue/CCI Technology Inventory - Data Capture 20171130.xlsx</Path>
   <SheetName>Table of Contents</SheetName>
   <SheetName>Applications</SheetName>
   <SheetName>Business Units</SheetName>
   <SheetName>Technology Domains</SheetName>
   <SheetName>Technology Capablities</SheetName>
   <SheetName>Tech Components</SheetName>
   <SheetName>Tech Prod Suppliers</SheetName>
   <SheetName>Technology Product Families</SheetName>
   <SheetName>Technology Products</SheetName>
   <SheetName>Tech Prods 2 Bus Units</SheetName>
   <SheetName>ORG PRODS SCRATCHPAD</SheetName>
   <SheetName>COPY PAD</SheetName>
   <SheetName>App Tech Products</SheetName>
   <SheetName>Tech Components SCRATCH</SheetName>
   <SheetName>REFERENCE DATA</SheetName>
   <Xct>
    <Count>0</Count>
    <SheetIndex>0</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>1</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>2</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>3</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>4</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>5</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>6</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>7</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>8</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>9</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>10</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>11</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>12</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>13</SheetIndex>
   </Xct>
   <Xct>
    <Count>1</Count>
    <SheetIndex>14</SheetIndex>
    <Crn>
     <Row>21</Row>
     <ColFirst>2</ColFirst>
     <ColLast>6</ColLast>
     <Text>Top</Text>
     <Text>Middle</Text>
     <Text>Left</Text>
     <Text>Right</Text>
     <Text>Bottom</Text>
    </Crn>
   </Xct>
  </SupBook>
  <WindowHeight>13700</WindowHeight>
  <WindowWidth>28560</WindowWidth>
  <WindowTopX>240</WindowTopX>
  <WindowTopY>1240</WindowTopY>
  <TabRatio>871</TabRatio>
  <ActiveSheet>4</ActiveSheet>
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
  <Style ss:ID="s18" ss:Name="SheetHeading">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1024" ss:Parent="s17">
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
  <Style ss:ID="s1029">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1030">
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
  <Style ss:ID="s1031" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1032">
   <Interior/>
  </Style>
  <Style ss:ID="s1036" ss:Parent="s16">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#CCCCFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1037">
   <Borders/>
  </Style>
  <Style ss:ID="s1038">
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
  <Style ss:ID="s1039" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1040" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1041">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1042" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1044" ss:Parent="s16">
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
  <Style ss:ID="s1045" ss:Parent="s17">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1047">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1048">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1050">
   <Borders/>
   <Interior/>
  </Style>
  <Style ss:ID="s1058">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1059">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1060">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1061">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1071">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1072">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1079">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1093">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1094">
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
  <Style ss:ID="s1095">
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
  <Style ss:ID="s1096">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1097">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1098">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
  </Style>
  <Style ss:ID="s1115">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1117">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#76933C"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1118">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1119">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1120">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1121">
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
  <Style ss:ID="s1127">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"/>
  </Style>
  <Style ss:ID="s1128">
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
  <Style ss:ID="s1133">
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
  <Style ss:ID="s1134">
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
  <Style ss:ID="s1135">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1136">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1137">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1139" ss:Parent="s1020">
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
  <Style ss:ID="s1140" ss:Parent="s1020">
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
  <Style ss:ID="s1143">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1144">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1152">
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
  <Style ss:ID="s1154">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1155">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1156">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1157">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1158">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1159">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1162">
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
  <Style ss:ID="s1164">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1179">
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
  <Style ss:ID="s1194">
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1204">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#FFFFFF" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1205">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FF0000"/>
  </Style>
  <Style ss:ID="s1208">
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#808080" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1300">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1304" ss:Parent="s18">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1305">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1307">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1309" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="Allowed_CRUD_Values"
   ss:RefersTo="='REFERENCE DATA'!R9C3:R9C5"/>
  <NamedRange ss:Name="App_Cap_Cat"
   ss:RefersTo="='CLASSIFICATION DATA'!R25C3:R25C6"/>
  <NamedRange ss:Name="App_Delivery_Models" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="App_Dif_Level"
   ss:RefersTo="='CLASSIFICATION DATA'!R24C3:R24C5"/>
  <NamedRange ss:Name="App_Type" ss:RefersTo="='REFERENCE DATA'!R46C3:R46C5"/>
  <NamedRange ss:Name="Application_Codebases" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Application_Delivery_Model"
   ss:RefersTo="='REFERENCE DATA'!R21C3:R21C5"/>
  <NamedRange ss:Name="AppProRole" ss:RefersTo="=CONCATS!R8C4:R200C4"/>
  <NamedRange ss:Name="Area" ss:RefersTo="='CLASSIFICATION DATA'!R23C3:R23C5"/>
  <NamedRange ss:Name="Bus_Cap_type"
   ss:RefersTo="='CLASSIFICATION DATA'!R22C3:R22C4"/>
  <NamedRange ss:Name="Bus_Caps" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Languages" ss:RefersTo="='REFERENCE DATA'!R49C3:R49C17"/>
  <NamedRange ss:Name="Lifecycle_Statii" ss:RefersTo="='REFERENCE DATA'!R8C3:R8C11"/>
  <NamedRange ss:Name="Organisations" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Reference_Model_Layers"
   ss:RefersTo="='REFERENCE DATA'!R50C3:R50C7"/>
  <NamedRange ss:Name="Servers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Cap_Layers"
   ss:RefersTo="='https://easglobal-my.sharepoint.com/Users/jasonpowell/OneDrive - Enterprise Architecture Solutions Limited/Clients/CCI/Investmenyt Planning/Data Capture/Technology Catalogue/[CCI Technology Inventory - Data Capture 20171130.xlsx]REFERENCE DATA'!R22C3:R22C12"/>
  <NamedRange ss:Name="Tech_Compliance_Levels" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Delivery_Models" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Ref_Archs"
   ss:RefersTo="='Tech Reference Archs'!R7C3:R10C3"/>
  <NamedRange ss:Name="Tech_Svc_Quality_Values" ss:RefersTo="=CONCATS!R7C2:R145C2"/>
  <NamedRange ss:Name="Tech_Svc_Quals"
   ss:RefersTo="='Technology Service Qualities'!R7C3:R127C3"/>
  <NamedRange ss:Name="Tech_Vendor_Release_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Capabilities" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Components"
   ss:RefersTo="='Technology Components'!R7C3:R169C3"/>
  <NamedRange ss:Name="Technology_Domains" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Product_Families" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Product_Suppliers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Products"
   ss:RefersTo="='Technology Products'!R7C3:R753C3"/>
  <NamedRange ss:Name="Usage_Lifecycle_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Actor_Category"
   ss:RefersTo="='CLASSIFICATION DATA'!R17C3:R17C4"/>
  <NamedRange ss:Name="Valid_App_Caps" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Category"
   ss:RefersTo="='REFERENCE DATA'!R41C3:R41C4"/>
  <NamedRange ss:Name="Valid_App_Classification"
   ss:RefersTo="='REFERENCE DATA'!R41C3:R41C4"/>
  <NamedRange ss:Name="Valid_App_Service_Statii"
   ss:RefersTo="='REFERENCE DATA'!R23C3:R23C4"/>
  <NamedRange ss:Name="Valid_App_Services" ss:RefersTo="=#REF!"/>
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
  <NamedRange ss:Name="Valid_Bus_Doms" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Bus_Proc" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Business_Criticality"
   ss:RefersTo="='REFERENCE DATA'!R35C3:R35C5"/>
  <NamedRange ss:Name="Valid_Business_Domain_Layers"
   ss:RefersTo="='CLASSIFICATION DATA'!R13C3:R13C8"/>
  <NamedRange ss:Name="Valid_Business_Issue_Categories"
   ss:RefersTo="='REFERENCE DATA'!R45C3:R45C11"/>
  <NamedRange ss:Name="Valid_Business_Processes" ss:RefersTo="=#REF!"/>
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
  <NamedRange ss:Name="Valid_Sites" ss:RefersTo="=#REF!"/>
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
 
 <Worksheet ss:Name="Applications">
  <Names>
   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=Applications!R6C2:R45C3"
    ss:Hidden="1"/>
   <NamedRange ss:Name="Print_Area" ss:RefersTo="=Applications!R6C2:R45C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1037" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($apps)+8"/></xsl:attribute> 
   <Column ss:StyleID="s1037" ss:AutoFitWidth="0" ss:Width="36"/>
   <Column ss:StyleID="s1037" ss:AutoFitWidth="0" ss:Width="50"/>
   <Column ss:StyleID="s1072" ss:AutoFitWidth="0" ss:Width="184"/>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1071"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1304"><Data ss:Type="String">Applications</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1305"><Data ss:Type="String">Captures information about the Applications used within the organisation   </Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1071"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1038"><Data ss:Type="String">ID</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font
        html:Color="#000000">                      </Font><Font html:Size="9"
        html:Color="#000000">A unique ID for the Application</Font><Font
        html:Color="#000000">                   </Font></ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1038"><Data ss:Type="String">Name</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The name of the Application</Font>          </ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6"/>
   <xsl:apply-templates select="$apps" mode="idName">
        <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
      </xsl:apply-templates>

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
   <TabColorIndex>54</TabColorIndex>
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
     <ActiveRow>24</ActiveRow>
     <ActiveCol>5</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Technology Components">
 <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1118" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($techComps)+8"/></xsl:attribute>
   <Column ss:Index="2" ss:StyleID="s1118" ss:AutoFitWidth="0" ss:Width="58"/>
   <Column ss:StyleID="s1118" ss:AutoFitWidth="0" ss:Width="284"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1119"><Data ss:Type="String">Technology Components</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Details the technology components</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1162"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1162"><Data ss:Type="String">Name</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
   <xsl:apply-templates select="$techComps" mode="idName">
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
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>233</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>8</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R9C2:R253C3</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Technology Products">
  <Names>
   <NamedRange ss:Name="_FilterDatabase"
    ss:RefersTo="='Technology Products'!R7C1:R753C3" ss:Hidden="1"/>
  </Names>
  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1118" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($techProds)+8"/></xsl:attribute>
   <Column ss:StyleID="s1118" ss:AutoFitWidth="0" ss:Width="19"/>
   <Column ss:StyleID="s1118" ss:AutoFitWidth="0" ss:Width="70"/>
   <Column ss:StyleID="s1118" ss:AutoFitWidth="0" ss:Width="236"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1119"><Data ss:Type="String">Technology Products</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Details the Technology Products</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1121"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1121"><Data ss:Type="String">Name</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
    <xsl:apply-templates select="$techProds" mode="idName">
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
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>772</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveRow>562</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R563C2:R787C3</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Tech Reference Archs">
  <Names>
   <NamedRange ss:Name="Valid_Bus_Doms"
    ss:RefersTo="='Tech Reference Archs'!R8C3:R10C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="6" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16"><xsl:attribute name="ss:ExpandedRowCount"><xsl:value-of select="count($techComposite)+12"/></xsl:attribute>
   <Column ss:AutoFitWidth="0" ss:Width="44" ss:Span="1"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="155"/>
   <Column ss:AutoFitWidth="0" ss:Width="337"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s18"><Data ss:Type="String">Technology Reference Architectures:<xsl:value-of select="$ref"/></Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="4"/>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1156"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1152"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1157"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell ss:Index="2" ss:StyleID="s1154"/>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Tech_Ref_Archs"/></Cell>
    <Cell ss:StyleID="s1155"/>
   </Row>
       <xsl:apply-templates select="$techComposite" mode="idNameDesc">
        <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>
      </xsl:apply-templates>

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
     <ActiveRow>8</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R9C2:R10C4</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Tech Ref Arch Svc Quals">
  <Names>
   <NamedRange ss:Name="Valid_Bus_Doms"
    ss:RefersTo="='Tech Ref Arch Svc Quals'!R8C2:R25C2"/>
  </Names>
  <Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="25" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="44"/>
   <Column ss:AutoFitWidth="0" ss:Width="241"/>
   <Column ss:AutoFitWidth="0" ss:Width="263"/>
   <Column ss:AutoFitWidth="0" ss:Width="164"/>
   <Column ss:AutoFitWidth="0" ss:Width="118"/>
   <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1309"><Data ss:Type="String">Technology Reference Architecture Qualities</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="3"/>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1156"><Data ss:Type="String">Reference Architecture</Data></Cell>
    <Cell ss:StyleID="s1157"><Data ss:Type="String">Service Quality Value</Data></Cell>
    <Cell ss:StyleID="s1179"><Data ss:Type="String">Check Ref Arch</Data></Cell>
    <Cell ss:StyleID="s1179"><Data ss:Type="String">Check Service</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s1154"/>
    <Cell ss:StyleID="s1155"/>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Tech Reference Archs'!C[-1],1,0)),&quot;Reference Architecture must be already defined in Tech Reference Archs sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Tech_Svc_Quality_Values,RC[-2]),&quot;OK&quot;,&quot;Service Qualities MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1154"><Data ss:Type="String"> </Data><NamedCell
      ss:Name="Valid_Bus_Doms"/></Cell>
    <Cell ss:StyleID="s1155"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Tech Reference Archs'!C[-1],1,0)),&quot;Reference Architecture must be already defined in Tech Reference Archs sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Tech_Svc_Quality_Values,RC[-2]),&quot;OK&quot;,&quot;Service Qualities MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
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
     <ActiveRow>8</ActiveRow>
     <RangeSelection>R9:R27</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R25C2</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Ref_Archs</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R25C3</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Svc_Quality_Values</Value>
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
   <Range>R8C4:R25C5</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Tech Reference Models">
  <Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="16" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="255"/>
   <Column ss:AutoFitWidth="0" ss:Width="291"/>
   <Column ss:AutoFitWidth="0" ss:Width="281"/>
   <Column ss:AutoFitWidth="0" ss:Width="269" ss:Span="1"/>
   <Row ss:Index="2" ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1309"><Data ss:Type="String">Technology Reference Models</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="3"/>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1038"><Data ss:Type="String">Reference Architecture</Data></Cell>
    <Cell ss:StyleID="s1038"><Data ss:Type="String">From Technology Component</Data></Cell>
    <Cell ss:StyleID="s1038"><Data ss:Type="String">To Technology Component</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">From Check</Data></Cell>
    <Cell ss:StyleID="s1194"><Data ss:Type="String">To Check</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7">
    <Cell ss:Index="5"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Components'!C[-2],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Components'!C[-3],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Components'!C[-2],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-2],'Technology Components'!C[-3],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String">OK</Data></Cell>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <LeftColumnVisible>1</LeftColumnVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>8</ActiveRow>
     <ActiveCol>1</ActiveCol>
     <RangeSelection>R9:R16</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R16C2</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Ref_Archs</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R16C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Components</Value>
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
   <Range>R6C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R6C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R16C6</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="App to Tech Products">
  <Table ss:ExpandedColumnCount="13" ss:ExpandedRowCount="35" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
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
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1093"/>
    <Cell ss:StyleID="s1136"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1136"/>
    <Cell ss:MergeAcross="2" ss:StyleID="s1307"><Data ss:Type="String">Application Technology Architecture</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1137"><Data ss:Type="String">Defines the technology architecture supporting applications in terms of Technology Products, the components that they implement and the dependencies between them</Data></Cell>
    <Cell ss:StyleID="s1137"/>
    <Cell ss:StyleID="s1137"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1093"/>
    <Cell ss:StyleID="s1136"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1093"/>
    <Cell ss:StyleID="s1136"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="s1136"/>
    <Cell ss:StyleID="s1094"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s1095"><Data ss:Type="String">Environment</Data></Cell>
    <Cell ss:StyleID="s1096"><Data ss:Type="String">From Technology Product</Data></Cell>
    <Cell ss:StyleID="s1096"><Data ss:Type="String">From Technology Component</Data></Cell>
    <Cell ss:StyleID="s1096"><Data ss:Type="String">To Technology Product</Data></Cell>
    <Cell ss:StyleID="s1096"><Data ss:Type="String">To Technology Component</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check Application</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check Environment</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check From Tech Product</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check From Tech Component</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check To Tech Product</Data></Cell>
    <Cell ss:StyleID="s1208"><Data ss:Type="String">Check To Tech Component</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1098"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-10],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],Applications!C[-5],1,0)),&quot;Application must be already defined in Applications sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-2]&lt;&gt;&quot;&quot;,IF(COUNTIF(Valid_Environments,RC[-2]),&quot;OK&quot;,&quot;Type MUST match the values in Launchpad.  To change these speak to us&quot;),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-7],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Components'!C[-8],1,0)),&quot;Technology Component must be already defined in Technology Components sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
     ss:Formula="=IF(RC[-6]&lt;&gt;&quot;&quot;,(IF(ISNA(VLOOKUP(RC[-6],'Technology Products'!C[-9],1,0)),&quot;Technology Product must be already defined in Technology Products sheet&quot;,&quot;OK&quot;)),&quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1204"
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
     <ActiveRow>7</ActiveRow>
     <ActiveCol>3</ActiveCol>
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
   <Range>R8C2:R3000C2</Range>
   <Type>List</Type>
   <Value>'Applications'!R8C3:R2010C3</Value>
  </DataValidation>     
  
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3000C4, R8C6:R3000C6</Range>
   <Type>List</Type>
   <Value>'Technology Products'!R8C3:R2010C3</Value>
  </DataValidation> 
 <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'Technology Components'!R8C3:R2010C3</Value>
  </DataValidation>
<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R3300C7</Range>
   <Type>List</Type>
   <Value>'Technology Components'!R8C3:R3010C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C8:R35C13</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Technology Service Qualities">
  <Names>
   <NamedRange ss:Name="Tech_Delivery_Models"
    ss:RefersTo="='Technology Service Qualities'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="7" ss:ExpandedRowCount="127" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1061" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="111"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1300"><Data ss:Type="String">Technology Service Qualities</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1133"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="34">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ1</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Scalability</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Degree with which a solution is able to grow or evolve to handle increased amounts of work.</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ2</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Technical Complexity</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ3</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Cost</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ4</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Proven Use</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ5</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Lead Time</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ6</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Skills Availability</Data><NamedCell
      ss:Name="Tech_Delivery_Models"/><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ7</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ8</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ9</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ10</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ11</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ12</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ13</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ14</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ15</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ16</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ17</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Delivery_Models"/><NamedCell
      ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ18</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ19</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ20</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ21</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ22</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ23</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ24</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ25</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ26</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ27</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ28</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ29</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ30</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ31</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ32</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ33</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ34</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ35</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ36</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ37</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ38</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ39</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ40</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ41</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ42</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ43</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ44</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ45</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ46</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ47</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ48</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ49</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ50</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ51</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ52</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ53</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ54</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ55</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ56</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ57</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ58</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ59</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ60</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ61</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ62</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ63</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ64</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ65</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ66</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ67</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ68</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ69</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ70</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ71</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ72</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ73</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ74</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ75</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ76</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ77</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ78</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ79</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ80</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ81</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ82</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ83</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ84</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ85</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ86</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ87</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ88</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ89</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ90</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ91</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ92</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ93</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ94</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ95</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ96</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ97</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ98</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ99</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ100</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ101</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ102</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ103</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ104</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ105</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ106</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ107</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ108</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ109</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ110</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ111</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ112</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ113</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ114</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ115</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ116</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ117</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ118</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ119</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"><Data ss:Type="String">TSQ120</Data></Cell>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Tech_Svc_Quals"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"/>
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
     <ActiveRow>124</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R127C7</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Tech Service Qual Vals">
  <Table ss:ExpandedColumnCount="10" ss:ExpandedRowCount="47" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="157"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="117" ss:Span="1"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="191"/>
   <Column ss:AutoFitWidth="0" ss:Width="255"/>
   <Column ss:AutoFitWidth="0" ss:Width="91"/>
   <Row>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1061"/>
    <Cell ss:MergeAcross="3" ss:StyleID="s1300"><Data ss:Type="String">Technology Service Quality Values</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="27">
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Service Quality</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Value</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Language</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV1</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Scalability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV2</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Scalability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV3</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Scalability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV4</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Technical Complexity</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV5</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Technical Complexity</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV6</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Technical Complexity</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV7</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Cost</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV8</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Cost</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV9</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Cost</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV10</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Proven Use</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV11</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Proven Use</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV12</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Proven Use</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV13</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Lead Time</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV14</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Lead Time</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV15</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Lead Time</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV16</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Skills Availability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Low</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#CB0E3A</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourRed</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV17</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Skills Availability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Medium</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#F59C3D</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">backColourOrange</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV18</Data></Cell>
    <Cell ss:StyleID="s1135"><Data ss:Type="String">Skills Availability</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">High</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">#1EAE4E</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">ragTextGreen</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="Number">10</Data></Cell>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV19</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV20</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV21</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV22</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV23</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV24</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV25</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV26</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV27</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV28</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV29</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV30</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV31</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV32</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV33</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV34</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV35</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV36</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV37</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV38</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV39</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1047"><Data ss:Type="String">TSQV40</Data></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1047"/>
    <Cell ss:StyleID="s1135"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>45</TabColorIndex>
   <Selected/>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R47C3</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Tech_Svc_Quals</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C10:R47C10</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Languages</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="CONCATS">
  <Table ss:ExpandedColumnCount="4" ss:ExpandedRowCount="200" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0"/>
   <Column ss:StyleID="s1061" ss:AutoFitWidth="0" ss:Width="173"/>
   <Column ss:Index="4" ss:AutoFitWidth="0" ss:Width="229"/>
   <Row ss:Index="2">
    <Cell ss:Index="2" ss:StyleID="Default"/>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1133"><Data ss:Type="String">Tech Svc Quality Values</Data></Cell>
    <Cell ss:Index="4" ss:StyleID="s1133"><Data ss:Type="String">App Pro Role</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="9"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Scalability - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Scalability - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Scalability - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Technical Complexity - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Technical Complexity - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Technical Complexity - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Cost - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Cost - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Cost - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Proven Use - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Proven Use - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Proven Use - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Lead Time - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Lead Time - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Lead Time - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Skills Availability - Low</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Skills Availability - Medium</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String">Skills Availability - High</Data><NamedCell
      ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1135"
     ss:Formula="=CONCATENATE('Tech Service Qual Vals'!RC[1],&quot; - &quot;,'Tech Service Qual Vals'!RC[2])"><Data
      ss:Type="String"> - </Data><NamedCell ss:Name="Tech_Svc_Quality_Values"/></Cell>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
   <Row>
    <Cell ss:Index="4" ss:Formula="=CONCATENATE(#REF!,&quot; as &quot;,#REF!)"><Data
      ss:Type="Error">#REF!</Data><NamedCell ss:Name="AppProRole"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Visible>SheetHidden</Visible>
   <TabColorIndex>54</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>149</ActiveRow>
     <ActiveCol>1</ActiveCol>
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
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="25">
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s18"><Data ss:Type="String">REFERENCE DATA</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="3"><Data ss:Type="String">Used to capture reference information to be used for validation purposes</Data></Cell>
   </Row>
   <Row ss:Index="8" ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">App Lifecycle Statii</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Contains a list of Lifecycle Statii</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Disaster Recovery</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">OffStrategy</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Pilot</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">ProductionStrategic</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Prototype</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Reference</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Retired</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sunset</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Under Planning</Data><NamedCell
      ss:Name="Lifecycle_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">CRUD Values</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the allowed values when defining a CRUD on data on information</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Yes</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">No</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Unknown</Data><NamedCell
      ss:Name="Allowed_CRUD_Values"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Component Categories</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used to categorise Business Capabilities</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Direct</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Control</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Execute</Data><NamedCell
      ss:Name="Valid_Bus_Comp_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Countries</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A list of standard countries</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Afghanistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Albania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Algeria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Angola</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Antarctica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Antigua and Barbuda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Argentina</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Armenia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Australia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Austria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Azerbaijan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bahamas</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bangladesh</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Barbados</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Belarus</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Belgium</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Belize</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Benin</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bhutan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bolivia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bosnia and Herzegovina</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Botswana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Brazil</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Brunei Darussalam</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Bulgaria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Burkina Faso</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Burma</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Burundi</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cambodia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cameroon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Canada</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cape Verde</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Central African Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Chad</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Chile</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">China</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Colombia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Comoros</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Congo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Costa Rica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cote d'Ivoire</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Croatia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cuba</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cyprus</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Czech Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Democratic Republic of the Congo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Denmark</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Djibouti</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Dominica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Dominican Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Ecuador</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Egypt</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">El Salvador</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Equatorial Guinea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Eritrea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Estonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Ethiopia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Falkland Islands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Fiji</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Finland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">France</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">French Guiana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Gabon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Gambia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Georgia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Germany</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Ghana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Greece</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Grenada</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Guadeloupe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Guatemala</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Guinea-Bissau</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Guyana</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Haiti</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Honduras</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Hungary</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Iceland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">India</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Indonesia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Iran</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Iraq</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Ireland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Israel</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Italy</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Jamaica</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Japan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Jordan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Kazakhstan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Kenya</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Korea, Democratic People's Republic of</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Korea, Republic of</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Kuwait</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Kyrgyzstan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Lao People's Democratic Republic</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Latvia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Lebanon</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Lesotho</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Liberia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Libya</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Lithuania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Luxembourg</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Macedonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Madagascar</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Malawi</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Malaysia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mali</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Martinique</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mauritania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mauritius</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mexico</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mongolia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Morocco</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Mozambique</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Namibia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Nepal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Netherlands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">New Caledonia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">New Zealand</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Nicaragua</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Nigeria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Norway</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Oman</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Pakistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Palau</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Panama</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Papua New Guinea</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Paraguay</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Peru</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Philippines</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Poland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Portugal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Puerto Rico</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Qatar</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Republic of Moldova</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Reunion</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Romania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Russia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Rwanda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sao Tome and Principe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Saudi Arabia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Senegal</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Serbia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sierra Leone</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Singapore</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Slovakia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Slovenia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Solomon Islands</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Somalia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">South Africa</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Spain</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sri Lanka</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">St. Kitts and Nevis</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">St. Lucia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">St. Vincent and the Grenadines</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sudan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Suriname</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Swaziland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Sweden</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Switzerland</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Syria</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Taiwan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Tajikistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Thailand</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Timor-Leste</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Togo</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Trinidad and Tobago</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Tunisia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Turkey</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Turkmenistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Uganda</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Ukraine</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">United Arab Emirates</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">United Kingdom</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">United Republic of Tanzania</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">United States</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Uruguay</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Uzbekistan</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Vanuatu</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Venezuela</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Vietnam</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">West Bank</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Western Sahara</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Yemen</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Zambia</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Zimbabwe</Data><NamedCell
      ss:Name="Valid_Countries"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data_Categories</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Describes the list of Data Categories</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Conditional Master Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Master Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Reference Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Transactional Data</Data><NamedCell
      ss:Name="Valid_Data_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data Acquisition Methods</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Batch File Upload</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Data Service</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Database Replication</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Manual Data Entry</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Messaging</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Unknown</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
    <Cell ss:StyleID="s1042"><Data ss:Type="String">Direct API Call</Data><NamedCell
      ss:Name="Valid_Data_Aquisition_Methods"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Deployment Role</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">ARCH</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">BT1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">CL1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">CL2</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">CL3</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">CP1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Cl2</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DR</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DV1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DV2</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DV3</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DV6</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Dev</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Dev/Prod</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Development</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Live</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Migration</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">PROD</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Pend</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Production</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Quality Assurance</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">SAT</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">SP1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TRAIN</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TS1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TS2</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TS3</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TS4</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">TS5</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Test</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Training</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">UA1</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">UA3</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">UAT</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">True or False Values</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Represents fixed strings for true or false values</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">true</Data><NamedCell
      ss:Name="Valid_True_or_False"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">false</Data><NamedCell
      ss:Name="Valid_True_or_False"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Day in Month</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The day in a calendar month</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">1</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">3</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">4</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">5</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">6</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">7</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">8</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">9</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">10</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">11</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">12</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">13</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">14</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">15</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">16</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">17</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">18</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">19</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">20</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">21</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">22</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">23</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">24</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">25</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">26</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">27</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">28</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">29</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">30</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">31</Data><NamedCell
      ss:Name="Valid_Day_In_Month"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Month in Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A month in a calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">1</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">3</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">4</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">5</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">6</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">7</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">8</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">9</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">10</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">11</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">12</Data><NamedCell
      ss:Name="Valid_Month_In_Year"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Quarter in Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A quarter in a calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Q1</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Q2</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Q3</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Q4</Data><NamedCell
      ss:Name="Valid_Calendar_Quarters"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Calendar Year</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A calendar year</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2005</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2006</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2007</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2008</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2009</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2010</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2011</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2012</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2013</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2014</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2015</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2016</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2017</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2018</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2019</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2020</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2021</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">2022</Data><NamedCell
      ss:Name="Valid_Calendar_Year"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Project Lifecycle Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The lifecycle status of a project</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Build</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Closed</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Definition</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Design</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Feasibility</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Implementation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Initiation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Post Implementation</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">System Test</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">UAT</Data><NamedCell
      ss:Name="Valid_Project_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Delivery Model</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Hosted</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">OnSite</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">SaaS</Data><NamedCell
      ss:Name="Application_Delivery_Model"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Data Attribute Cardinality</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Multiple</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">One</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">One to Many</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Single</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Zero or One</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Zero to Many</Data><NamedCell
      ss:Name="Valid_Data_Attribute_Cardinality"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">App Service Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Allowed values for Application Service Staus</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Online</Data><NamedCell
      ss:Name="Valid_App_Service_Statii"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">For_Retirement</Data><NamedCell
      ss:Name="Valid_App_Service_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Purpose</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A list of agreed application purposes</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Application Integration</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Logic</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business System Application</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Data Integration</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">InboundData</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">OutboundData</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">ProcessAutomation</Data><NamedCell
      ss:Name="Valid_Application_Purpose"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Start Flow</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used for process flows and roadmaps to signifiy the start of the flow</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Start</Data><NamedCell
      ss:Name="Valid_Start_Flow"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">End Flow</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used for process flows and roadmaps to signifiy the end of a flow</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">End</Data><NamedCell
      ss:Name="Valid_End_Flow"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Planning Actions</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The set of actions for strategic plans</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Decommission</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Enhance</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Establish</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Outsource</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Replace</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Strategic</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Switch_Off</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Tactical</Data><NamedCell
      ss:Name="Valid_Planning_Actions"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Secured Actions</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A secured action associated with a security policy</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Create</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Delete</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">None</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Read</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Update</Data><NamedCell
      ss:Name="Valid_Secured_Actions"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">High Medium Low Values</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Low</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Medium</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">High</Data><NamedCell
      ss:Name="Valid_High_Medium_Low"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Standardisation Level</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Describes the standardisation level of a business process or activity</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Custom</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Standard</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Standard with Customisation</Data><NamedCell
      ss:Name="Valid_Standardisation_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Project Approval Status</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The approval status of a project or programme</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Approved</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Not Approved</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Project Suspended</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Suspended</Data><NamedCell
      ss:Name="Valid_Project_Approval_Status"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Principle Compliance Levels</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Full Compliance</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">No Compliance</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Not Applicable</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Strong Compliance</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Weak Compliance</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Principle Compliance Assessment Level</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">The assessmet level for the principles compliance</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Full Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">No Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Not Applicable</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Strong Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Weak Compliance</Data><NamedCell
      ss:Name="Valid_Principle_Compliance_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">EA Standard Lifecycle Statii</Data><NamedCell
      ss:Name="Valid_EA_Standard_Lifcycle_Statii"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Criticality</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Criticality: High</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Criticality: Low</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Criticality: Medium</Data><NamedCell
      ss:Name="Valid_Business_Criticality"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Actor Reporting Line Strength</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Direct</Data><NamedCell
      ss:Name="Valid_Reporting_Line_Strength"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Indirect</Data><NamedCell
      ss:Name="Valid_Reporting_Line_Strength"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Skill Level</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Expert</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Intermediate</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Novice</Data><NamedCell
      ss:Name="Valid_Skill_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Obligation Lifecycle Status</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Active</Data><NamedCell
      ss:Name="Valid_Obligation_Lifecycle_Status"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Future</Data><NamedCell
      ss:Name="Valid_Obligation_Lifecycle_Status"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Primitive Data Objects</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Boolean</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Float</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Integer</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">String</Data><NamedCell
      ss:Name="Valid_Pimitive_Data_Objects"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Owning Org</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Group</Data><NamedCell
      ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Shared</Data><NamedCell
      ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1024"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1031"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
    <Cell ss:StyleID="s1031"><NamedCell ss:Name="Valid_Owning_Org"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Classification</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Key App</Data><NamedCell
      ss:Name="Valid_App_Classification"/><NamedCell ss:Name="Valid_App_Category"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Support App</Data><NamedCell
      ss:Name="Valid_App_Classification"/><NamedCell ss:Name="Valid_App_Category"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Best Practice Category</Data></Cell>
    <Cell ss:StyleID="s1042"><Data ss:Type="String">Components/CI Configuration</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1042"><Data ss:Type="String">Servers</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1031"><Data ss:Type="String">SQL</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1031"><Data ss:Type="String">Network</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1031"><Data ss:Type="String">VMWare</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
    <Cell ss:StyleID="s1031"><Data ss:Type="String">Citrix</Data><NamedCell
      ss:Name="Valid_Best_Practice_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1044"><Data ss:Type="String">Tech Node Roles</Data></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">32-bit Citrix Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">Web Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">Database Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">File Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">64-bit Citrix Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
    <Cell ss:StyleID="s1042"><Data ss:Type="String">Batch Server</Data><NamedCell
      ss:Name="Valid_Tech_Node_Roles"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Environment Types</Data></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">UAT</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1045"><Data ss:Type="String">Production</Data><NamedCell
      ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1048"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1048"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1048"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1048"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
    <Cell ss:StyleID="s1048"><NamedCell ss:Name="Valid_Deployment_Roles"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Issue Category</Data></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Valid_Business_Issue_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Type</Data></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Packaged</Data><NamedCell
      ss:Name="App_Type"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Bespoke</Data><NamedCell
      ss:Name="App_Type"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Customised_Package</Data><NamedCell
      ss:Name="App_Type"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1044"><Data ss:Type="String">Valid Position in Parent</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Front</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Manage</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Back</Data><NamedCell
      ss:Name="Valid_Position_in_Parent"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Environments</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Decommissioned</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">DR</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Infra Server</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Production</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Staging</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Test</Data><NamedCell
      ss:Name="Valid_Environments"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Languages</Data></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">English (US)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">French (France)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">German (Germany)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Spanish (Spain)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Portuguese (Brazil)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Portuguese (Portugal)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Chinese (Simplified)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Chinese (Traditional)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Arabic (Saudi Arabia)</Data><NamedCell
      ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
    <Cell ss:StyleID="s1047"><NamedCell ss:Name="Languages"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1036"><Data ss:Type="String">Reference Model Layer</Data></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Left</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Right</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Top</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Middle</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Bottom</Data><NamedCell
      ss:Name="Reference_Model_Layers"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Unsynced/>
   <Visible>SheetHidden</Visible>
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TopRowVisible>30</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>53</ActiveRow>
     <ActiveCol>4</ActiveCol>
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
    <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s18"><Data ss:Type="String">CLASSIFICATION DATA</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="3"><Data ss:Type="String">Used to capture reference information that is generated from user-definable Taxonomies in the Essential Repository</Data></Cell>
   </Row>
   <Row ss:Index="8" ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Goal Taxonomies</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Vaild Taxonomy Terms for Goals (Objectives)</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Company</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Personal</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Team</Data><NamedCell
      ss:Name="Valid_Goal_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Driver Taxonomies</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Valid Taxonomy Terms for Drivers</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Internal</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">External</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Gap</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Opportunity</Data><NamedCell
      ss:Name="Valid_Driver_Classifications"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Capability Layer Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the layers used to lay out application capabilities in a reference model</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 1 - App Level 1</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 2 - App Level 2</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 3 - App Level 3</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 4 - App Level 4</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 5 - App Level 5</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Level 6 - App Level 6</Data><NamedCell
      ss:Name="Valid_Application_Capability_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Architecture Tier Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the architecture tiers in which technology components exist</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Front End Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Middle Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Back End Tier</Data><NamedCell
      ss:Name="Valid_Technology_Architecture_Tiers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Component Usage Type Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Defines whether a dependent technology component included in a technology architecture is contained within the Composite Technology Component which is being described</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Primary</Data><NamedCell
      ss:Name="Valid_Technology_Component_Usage_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Secondary</Data><NamedCell
      ss:Name="Valid_Technology_Component_Usage_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Business Domain Layers Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Lists the layers used to lay out business domains in a reference model</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 2</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 1</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 4</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 5</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 6</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Domain Layer 3</Data><NamedCell
      ss:Name="Valid_Business_Domain_Layers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Technology Composite Types Classification</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A classification of types of technology composite</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Logical Technology Environment</Data><NamedCell
      ss:Name="Valid_Technology_Composite_Types"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Logical Technology Platform</Data><NamedCell
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
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Integration Module</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Application Module</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business User Application</Data><NamedCell
      ss:Name="Valid_Application_Provider_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Actor Categories Taxonomy</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">Used to categorise different types of actors (e.g. actual, placeholder)</Font>                   </ss:Data></Comment></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Actual Actor</Data><NamedCell
      ss:Name="Valid_Actor_Category"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Placeholder Actor</Data><NamedCell
      ss:Name="Valid_Actor_Category"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Information Representation Categories Taxonomy</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Reporting Cube</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Reporting Cube Object</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Data Feed</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Report</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Data Storage</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Business Data Extract</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Data View</Data><NamedCell
      ss:Name="Valid_Information_Representation_Categories"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Skill Qualifier Taxonomies</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Analysis</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Development</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Testing</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Support</Data><NamedCell
      ss:Name="Valid_Skill_Qualifiers"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1036"><Data ss:Type="String">Yes/No</Data></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">Yes</Data><NamedCell
      ss:Name="Valid_YesNo"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String">No</Data><NamedCell
      ss:Name="Valid_YesNo"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1036"><Data ss:Type="String">Support Types</Data></Cell>
    <Cell ss:StyleID="s1039"><Data ss:Type="String">Infrastructure Support</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String">Application Support Level 1</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String">Application Support Level 2</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
    <Cell ss:StyleID="s1040"><Data ss:Type="String">Application Support Level 3</Data><NamedCell
      ss:Name="Valid_Support_Types"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1044"><Data ss:Type="String">Bus Cap Type</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Commodity</Data><NamedCell
      ss:Name="Bus_Cap_type"/></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Differentiator</Data><NamedCell
      ss:Name="Bus_Cap_type"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Area</Data></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Local</Data><NamedCell
      ss:Name="Area"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">Regional </Data><NamedCell
      ss:Name="Area"/></Cell>
    <Cell ss:StyleID="s1047"><Data ss:Type="String">Global</Data><NamedCell
      ss:Name="Area"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s16"><Data ss:Type="String">Application Differentiation Level</Data></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">System of Innovation</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">System of Differentiation</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
    <Cell ss:StyleID="s1029"><Data ss:Type="String">System of Record</Data><NamedCell
      ss:Name="App_Dif_Level"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1036"><Data ss:Type="String">App Cap Cat</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Core</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">Management</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">Shared</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
    <Cell ss:StyleID="s1050"><Data ss:Type="String">Enabling</Data><NamedCell
      ss:Name="App_Cap_Cat"/></Cell>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Unsynced/>
   <Visible>SheetHidden</Visible>
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
     <ActiveRow>24</ActiveRow>
     <ActiveCol>2</ActiveCol>
     <RangeSelection>R25C3:R25C6</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
	</xsl:template>
  
<xsl:template match="node()" mode="idName">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
   </Row>
 
</xsl:template>   
<xsl:template match="node()" mode="idNameDesc">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>    
   </Row>
 
</xsl:template>       
 <xsl:template match="node()" mode="nameDesc">
    <Row ss:AutoFitHeight="0"  ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
   </Row>
 
</xsl:template>    

</xsl:stylesheet>
