<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

<xsl:variable name="apps" select="/node()/simple_instance[type = ('Composite_Application_Provider')]"/>  
<xsl:variable name="appProPhyBus" select="/node()/simple_instance[type = ('APP_PRO_TO_PHYS_BUS_RELATION')]"/>    <xsl:variable name="appPRs" select="/node()/simple_instance[type = ('Application_Provider_Role')]"/>   
<xsl:variable name="vendorLife" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>    
<xsl:variable name="internalLife" select="/node()/simple_instance[type = 'Lifecycle_Status']"/> 
 <xsl:variable name="lifecycleModel" select="/node()/simple_instance[type = ('Lifecycle_Model','Vendor_Lifecycle_Model')]"/>   
<xsl:variable name="lifecycleModelStatus" select="/node()/simple_instance[type = ('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$lifecycleModel/name]"/>   
<xsl:variable name="supplier" select="/node()/simple_instance[type = ('Supplier')]"/>    
<xsl:variable name="physbusProc" select="/node()/simple_instance[type = ('Physical_Process')][name=$appProPhyBus/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value]"/>  
<xsl:variable name="busProc" select="/node()/simple_instance[type = ('Business_Process')][name=$physbusProc/own_slot_value[slot_reference='implements_business_process']/value]"/>    
<xsl:variable name="busCap" select="/node()/simple_instance[type = ('Business_Capability')][name=$busProc/own_slot_value[slot_reference='realises_business_capability']/value]"/>   
<xsl:variable name="busPerf" select="/node()/simple_instance[type = ('Business_Performance_Measure')][name=$appProPhyBus/own_slot_value[slot_reference='performance_measures']/value]"/> 
<xsl:variable name="busPerfScore" select="/node()/simple_instance[type = ('Business_Service_Quality_Value')][name=$busPerf/own_slot_value[slot_reference='pm_performance_value']/value]"/>       
   
<xsl:variable name="techPerf" select="/node()/simple_instance[type = ('Technology_Performance_Measure')][name=$appProPhyBus/own_slot_value[slot_reference='performance_measures']/value]"/>      
<xsl:variable name="techPerfScore" select="/node()/simple_instance[type = ('Technology_Service_Quality_Value')][name=$techPerf/own_slot_value[slot_reference='pm_performance_value']/value]"/>     
 <xsl:variable name="busFitQual" select="/node()/simple_instance[type = ('Business_Service_Quality')][own_slot_value[slot_reference='name']/value='Business Fit']"/>   
<xsl:variable name="techFitQual" select="/node()/simple_instance[type = ('Technology_Service_Quality')][own_slot_value[slot_reference='name']/value='Technical Fit']"/>    
    
<xsl:variable name="BSQ" select="$busPerfScore[own_slot_value[slot_reference='usage_of_service_quality']/value=$busFitQual/name]"/>
<xsl:variable name="TSQ" select="$techPerfScore[own_slot_value[slot_reference='usage_of_service_quality']/value=$techFitQual/name]"/>   
 <xsl:variable name="styles" select="/node()/simple_instance[type = 'Element_Style']"/>    
<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="iso-8859-1"/>
<xsl:template match="knowledge_base">
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2020-01-24T15:51:08Z</Created>
  <LastSaved>2020-02-17T13:14:24Z</LastSaved>
  <Version>16.00</Version>
 </DocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <WindowHeight>16340</WindowHeight>
  <WindowWidth>28800</WindowWidth>
  <WindowTopX>32767</WindowTopX>
  <WindowTopY>620</WindowTopY>
  <TabRatio>500</TabRatio>
  <ActiveSheet>1</ActiveSheet>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
  <DisplayInkNotes>False</DisplayInkNotes>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" ss:Size="11"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s16" ss:Name="Hyperlink">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#0563C1"
    ss:Underline="Single"/>
  </Style>
  <Style ss:ID="s15">
   <Borders/>
   <Font ss:FontName="Calibri" ss:Size="11"/>
   <Interior/>
  </Style>
  <Style ss:ID="s18">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" ss:Size="11"/>
   <Interior/>
  </Style>
  <Style ss:ID="s19">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s20">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s21">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s22">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s23">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s24">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>
   <Interior/>
  </Style>
  <Style ss:ID="s25">
   <Alignment ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s26">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s27">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>
   <Interior/>
  </Style>
  <Style ss:ID="s28">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" ss:Size="11"/>
   <Interior/>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s29">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s30">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11"/>
   <Interior/>
  </Style>
  <Style ss:ID="s32">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s33">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s34">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s35">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s36" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" ss:Size="11"/>
  </Style>
  <Style ss:ID="s37">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s43">
   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Bold="1"/>
   <Interior/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="BusFit" ss:RefersTo="='Bus Fit Values'!R8C2:R30C2"/>
  <NamedRange ss:Name="Lifecycle" ss:RefersTo="='Lifecycle Values'!R8C3:R30C3"/>
  <NamedRange ss:Name="TechFit" ss:RefersTo="='App Fit Values'!R8C2:R30C2"/>
 </Names>
 <Worksheet ss:Name="App Lifecycle">
  <Table ss:ExpandedColumnCount="3"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s15" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="186"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="98"/>
   <Row ss:Index="3" ss:Height="24">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s37"><Data ss:Type="String">Application Lifecycle</Data></Cell>
   </Row>
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s23"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:StyleID="s19"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s21"><Data ss:Type="String">Application Name</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Lifecycle</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
      <xsl:apply-templates select="$apps" mode="appLife"/>
   
  
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
   <Range>R8C3:R579C3</Range>
   <Type>List</Type>
   <Value>Lifecycle</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R579C2</Range>
   <Type>List</Type>
   <Value>Apps</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="App Fit">
  <Table ss:ExpandedColumnCount="9"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s15" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="116"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="99"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="98"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="239"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="98"/>
   <Column ss:StyleID="s15" ss:AutoFitWidth="0" ss:Width="239"/>
   <Row ss:Index="3" ss:Height="24">
    <Cell ss:Index="2" ss:StyleID="s37"><Data ss:Type="String">Application Bus and Tech Fit</Data></Cell>
    <Cell ss:MergeAcross="2" ss:StyleID="s37"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s43"/>
    <Cell ss:StyleID="s23"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:StyleID="s29"/>
    <Cell ss:StyleID="s19"/>
    <Cell ss:StyleID="s19"/>
    <Cell ss:StyleID="s25"/>
    <Cell ss:StyleID="s22"/>
    <Cell ss:StyleID="s26"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s21"><Data ss:Type="String">Business Capability</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">AppProRoletoPhyBusRelation</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Business Fit</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Comments on Score</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Technology Fit</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Comments on Score</Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String">Date</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:Index="7" ss:StyleID="s20"/>
   </Row>
      <xsl:apply-templates select="$appProPhyBus" mode="appProPhyBus"/>
   
  
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Selected/>
   <TopRowVisible>1</TopRowVisible>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>25</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R532C7</Range>
   <Type>List</Type>
   <Value>TechFit</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R660C5</Range>
   <Type>List</Type>
   <Value>BusFit</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Bus Fit Values">
  <Table ss:ExpandedColumnCount="4" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="85"/>
   <Column ss:AutoFitWidth="0" ss:Width="106"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s32"><Data ss:Type="String">Business Fit Values</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s33"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Value</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Colours</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
      
    <xsl:apply-templates select="$BSQ" mode="fit"/>  
 
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
     <ActiveRow>10</ActiveRow>
     <ActiveCol>5</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="App Fit Values">
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="85"/>
   <Column ss:AutoFitWidth="0" ss:Width="106"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s32"><Data ss:Type="String">Application Fit Values</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s33"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Value</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Colours</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
    <xsl:apply-templates select="$TSQ" mode="techfit"/>  
 
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
     <ActiveCol>5</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Lifecycle Values">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="106"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="90" ss:Span="1"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s32"><Data ss:Type="String">Application Lifecycle Values</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s33"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Label</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s33"><Data ss:Type="String">Colours</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
      
      
    <xsl:apply-templates select="$internalLife" mode="lifecycles"/>  
      
 
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
     <ActiveRow>18</ActiveRow>
     <ActiveCol>9</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
</Workbook>
    
</xsl:template> 
<xsl:template match="node()" mode="vendorLife">  
<xsl:variable name="thisSupplier" select="$supplier[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    
 <Row ss:Height="16">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="$thisSupplier/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
     
     <Cell><Data ss:Type="String"></Data></Cell>
     <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>
    <Cell><Data ss:Type="String"></Data></Cell>

 </Row>    
</xsl:template>
    
<xsl:template match="node()" mode="internalLife">
<xsl:variable name="thisSupplier" select="$supplier[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>

 <Row ss:Height="16">
    <Cell ss:Index="2"><Data ss:Type="String"><xsl:value-of select="$thisSupplier/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
     
     <Cell><Data ss:Type="String"></Data></Cell>
     <Cell><Data ss:Type="String"></Data></Cell>
 </Row>    
</xsl:template>  
    
<xsl:template match="node()" mode="internalLifeValues">
<xsl:variable name="thisElement" select="$styles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>

<Row>
    <Cell ss:Index="2" ss:StyleID="s21"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
      ss:Name="Internal_Lifecycle"/></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s21"><Data ss:Type="Number"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></Data></Cell>
    <Cell ss:StyleID="s30"><Data ss:Type="String"><xsl:value-of select="$thisElement/own_slot_value[slot_reference='element_style_colour']/value"/></Data></Cell>
   </Row>   
</xsl:template>  
 <xsl:template match="node()" mode="appLife">  
     <xsl:variable name="thisLife" select="$internalLife[name=current()/own_slot_value[slot_reference='lifecycle_status_application_provider']/value]"/>

<Row>
    <Cell ss:Index="2" ss:StyleID="s27"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="$thisLife/own_slot_value[slot_reference='name']/value"/></Data></Cell>
   </Row>    
</xsl:template>    
    
<xsl:template match="node()" mode="appProPhyBus"> 
<xsl:variable name="thisappPRs" select="$appPRs[name=current()/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/> 
<xsl:variable name="app" select="$apps[name=current()/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/> 
<xsl:variable name="appPro" select="$apps[name=$thisappPRs/own_slot_value[slot_reference='role_for_application_provider']/value]"/> 
<xsl:variable name="appAll" select="$app union $appPro"/>  
<xsl:variable name="thisphysbusProc" select="$physbusProc[name=current()/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value]"/>  
<xsl:variable name="thisbusProc" select="$busProc[name=$thisphysbusProc/own_slot_value[slot_reference='implements_business_process']/value]"/>    
<xsl:variable name="thisbusCap" select="$busCap[name=$thisbusProc/own_slot_value[slot_reference='realises_business_capability']/value]"/>    
    
<xsl:variable name="thisbusPerf" select="$busPerf[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/> 
<xsl:variable name="thisbusPerfScore" select="$busPerfScore[name=$thisbusPerf/own_slot_value[slot_reference='pm_performance_value']/value]"/>       
   
<xsl:variable name="thistechPerf" select="$techPerf[name=current()/own_slot_value[slot_reference='performance_measures']/value]"/>      
<xsl:variable name="thistechPerfScore" select="$techPerfScore[name=$thistechPerf/own_slot_value[slot_reference='pm_performance_value']/value]"/>    
     
<Row>
    <Cell ss:Index="2" ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="$thisbusCap/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="$appAll/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='relation_name']/value"/></Data></Cell>
    <Cell ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="$thisbusPerfScore/own_slot_value[slot_reference='service_quality_value_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="$thisbusPerf/own_slot_value[slot_reference='pm_comments']/value"/></Data></Cell>
    <Cell ss:StyleID="s18"><Data ss:Type="String"><xsl:value-of select="$thistechPerfScore/own_slot_value[slot_reference='service_quality_value_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="$thistechPerf/own_slot_value[slot_reference='pm_comments']/value"/></Data></Cell>
    <Cell ss:StyleID="s28"><Data ss:Type="String"><xsl:if test="$thistechPerf/own_slot_value[slot_reference='pm_measure_data_iso_8601']/value"><xsl:value-of select="$thistechPerf/own_slot_value[slot_reference='pm_measure_data_iso_8601']/value"/></xsl:if></Data></Cell>
   </Row>    
    </xsl:template>  
   <xsl:template match="node()" mode="fit">  
       <xsl:variable name="colours" select="$styles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
    <Row>
    <Cell ss:Index="2" ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="Number"><xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"/></Data><NamedCell
      ss:Name="BusFit"/></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String"><xsl:value-of select="$colours/own_slot_value[slot_reference='element_style_colour']/value"/></Data></Cell>
   </Row>
    </xsl:template>   
     <xsl:template match="node()" mode="techfit">  
       <xsl:variable name="colours" select="$styles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
    <Row>
    <Cell ss:Index="2" ss:StyleID="s24"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s24"><Data ss:Type="Number"><xsl:value-of select="current()/own_slot_value[slot_reference='service_quality_value_score']/value"/></Data><NamedCell
      ss:Name="TechFit"/></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String"><xsl:value-of select="$colours/own_slot_value[slot_reference='element_style_colour']/value"/></Data></Cell>
   </Row>
    </xsl:template>  
   <xsl:template match="node()" mode="lifecycles">  
    <xsl:variable name="colours" select="$styles[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>   
    <Row>
    <Cell ss:Index="2" ss:StyleID="s34"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data><NamedCell
      ss:Name="Lifecycle"/></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/></Data></Cell>
    <Cell ss:StyleID="s34"><Data ss:Type="Number"><xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_sequence_number']/value"/></Data></Cell>
        <Cell ss:StyleID="s35"><Data ss:Type="String"><xsl:value-of select="$colours/own_slot_value[slot_reference='element_style_colour']/value"/></Data></Cell>
   </Row>
    </xsl:template>
</xsl:stylesheet>