<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

<xsl:variable name="techProd" select="/node()/simple_instance[type = ('Technology_Product')]"/>  
<xsl:variable name="vendorLife" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>    
<xsl:variable name="internalLife" select="/node()/simple_instance[type = 'Lifecycle_Status']"/> 
 <xsl:variable name="lifecycleModel" select="/node()/simple_instance[type = ('Lifecycle_Model','Vendor_Lifecycle_Model')][own_slot_value[slot_reference='lifecycle_model_subject']/value=$techProd/name]"/>   
<xsl:variable name="lifecycleModelStatus" select="/node()/simple_instance[type = ('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$lifecycleModel/name]"/>   
<xsl:variable name="supplier" select="/node()/simple_instance[type = ('Supplier')]"/>    
 <xsl:variable name="styles" select="/node()/simple_instance[type = 'Element_Style']"/>    
<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="iso-8859-1"/>
<xsl:template match="knowledge_base">
<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:o="urn:schemas-microsoft-com:office:office"
 xmlns:x="urn:schemas-microsoft-com:office:excel"
 xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
 xmlns:html="http://www.w3.org/TR/REC-html40">
 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2019-04-04T14:18:17Z</Created>
  <LastSaved>2020-02-13T11:45:53Z</LastSaved>
  <Version>16.00</Version>
 </DocumentProperties>
 <CustomDocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
  <ContentTypeId dt:dt="string">0x01010019B6C1A721E4FB45A4C935D8C800CAE6</ContentTypeId>
 </CustomDocumentProperties>
 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
  <AllowPNG/>
 </OfficeDocumentSettings>
 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
  <SupBook>
   <Path></Path>
   <SheetName>Table of Contents</SheetName>
   <SheetName>Business Drivers</SheetName>
   <SheetName>Business Goals</SheetName>
   <SheetName>Business Goals to Drivers</SheetName>
   <SheetName>Business Objs to Goals</SheetName>
   <SheetName>Business Objectives</SheetName>
   <SheetName>Business Domains</SheetName>
   <SheetName>Sites</SheetName>
   <SheetName>Business Capabilities</SheetName>
   <SheetName>Business Caps to Objs</SheetName>
   <SheetName>Business Process Family</SheetName>
   <SheetName>Organisations</SheetName>
   <SheetName>Business Processes</SheetName>
   <SheetName>Organisation to Sites</SheetName>
   <SheetName>Product Concepts</SheetName>
   <SheetName>Product Types</SheetName>
   <SheetName>Products</SheetName>
   <SheetName>Application Capabilities</SheetName>
   <SheetName>Application Services</SheetName>
   <SheetName>App Service 2 App Capabilities</SheetName>
   <SheetName>Application Cost Types</SheetName>
   <SheetName>App Service 2 Apps</SheetName>
   <SheetName>Information Exchanged</SheetName>
   <SheetName>Application Dependencies</SheetName>
   <SheetName>Application to User Orgs</SheetName>
   <SheetName>Servers</SheetName>
   <SheetName>Application 2 Server</SheetName>
   <SheetName>Business Process 2 App Services</SheetName>
   <SheetName>Physical Proc 2 App and Service</SheetName>
   <SheetName>Technology Domains</SheetName>
   <SheetName>Technology Capablities</SheetName>
   <SheetName>Technology Components</SheetName>
   <SheetName>Technology Suppliers</SheetName>
   <SheetName>Technology Product Families</SheetName>
   <SheetName>Technology Products</SheetName>
   <SheetName>Tech Product Lifecycles</SheetName>
   <SheetName>Applications</SheetName>
   <SheetName>Tech Prods to User Orgs</SheetName>
   <SheetName>App to Tech Products</SheetName>
   <SheetName>Data Subjects</SheetName>
   <SheetName>Data Objects</SheetName>
   <SheetName>Data Object Inheritance</SheetName>
   <SheetName>Data Object Attributes</SheetName>
   <SheetName>Application Codebases</SheetName>
   <SheetName>Application Delivery Models</SheetName>
   <SheetName>Technology Delivery Models</SheetName>
   <SheetName>Tech Vendor Release Statii</SheetName>
   <SheetName>Standards Compliance Levels</SheetName>
   <SheetName>Technology Adoption Statii</SheetName>
   <SheetName>CONCATS</SheetName>
   <SheetName>REFERENCE DATA</SheetName>
   <SheetName>CLASSIFICATION DATA</SheetName>
   <SheetName>App Costs</SheetName>
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
    <Count>0</Count>
    <SheetIndex>14</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>15</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>16</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>17</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>18</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>19</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>20</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>21</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>22</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>23</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>24</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>25</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>26</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>27</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>28</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>29</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>30</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>31</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>32</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>33</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>34</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>35</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>36</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>37</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>38</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>39</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>40</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>41</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>42</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>43</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>44</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>45</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>46</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>47</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>48</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>49</SheetIndex>
   </Xct>
   <Xct>
    <Count>1</Count>
    <SheetIndex>50</SheetIndex>
    <Crn>
     <Row>48</Row>
     <ColFirst>2</ColFirst>
     <ColLast>10</ColLast>
     <Text>English (US)</Text>
     <Text>French (France)</Text>
     <Text>German (Germany)</Text>
     <Text>Spanish (Spain)</Text>
     <Text>Portuguese (Brazil)</Text>
     <Text>Portuguese (Portugal)</Text>
     <Text>Chinese (Simplified)</Text>
     <Text>Chinese (Traditional)</Text>
     <Text>Arabic (Saudi Arabia)</Text>
    </Crn>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>51</SheetIndex>
   </Xct>
   <Xct>
    <Count>0</Count>
    <SheetIndex>52</SheetIndex>
   </Xct>
  </SupBook>
  <WindowHeight>16180</WindowHeight>
  <WindowWidth>28300</WindowWidth>
  <WindowTopX>500</WindowTopX>
  <WindowTopY>460</WindowTopY>
  <ProtectStructure>False</ProtectStructure>
  <ProtectWindows>False</ProtectWindows>
 </ExcelWorkbook>
 <Styles>
  <Style ss:ID="Default" ss:Name="Normal">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior/>
   <NumberFormat/>
   <Protection/>
  </Style>
  <Style ss:ID="s16" ss:Name="Hyperlink">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#0563C1"
    ss:Underline="Single"/>
  </Style>
  <Style ss:ID="s17">
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s18">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior ss:Color="#D9E1F2" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s19">
   <Interior/>
  </Style>
  <Style ss:ID="s20">
   <Interior/>
   <NumberFormat ss:Format="@"/>
  </Style>
  <Style ss:ID="s21">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s22">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s23">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s24">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s25">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s26">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s27">
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
  <Style ss:ID="s28">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s29">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s30">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s31">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior ss:Color="#D9E1F2" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s32">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior ss:Color="#B4C6E7" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s33">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s34">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="20" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s35">
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
  <Style ss:ID="s36">
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
  <Style ss:ID="s37">
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
  <Style ss:ID="s38">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s39">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s40" ss:Parent="s16">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="Internal_Lifecycle"
   ss:RefersTo="='Internal Tech Prod Lifecycles'!R8C3:R25C3"/>
  <NamedRange ss:Name="Languages"
   ss:RefersTo="='Internal Tech Prod Lifecycles'!R8C3:R16C3"/>
 </Names>
 <Worksheet ss:Name="Tech Prod Vendor Lifecycle">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="53" ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="127"/>
   <Column ss:AutoFitWidth="0" ss:Width="157"/>
   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="116"/>
   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="115"/>
   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="132"/>
   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="102"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s23"><Data ss:Type="String">Vendor Lifecycles for Technology Products</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Defines the Vendor Lifecycle of Technology Products</Data></Cell>
   </Row>
   <Row ss:Index="6">
    <Cell ss:Index="2" ss:StyleID="s35"><Data ss:Type="String">Supplier</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Beta Start</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">GA Start</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Extended Support Start</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">EOL Start</Data></Cell>
   </Row>
       <Row ss:AutoFitHeight="0" ss:Height="4" ss:StyleID="s19">
    <Cell ss:Index="4" ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
    <Cell ss:StyleID="s20"/>
   </Row>
 <xsl:apply-templates select="$techProd" mode="vendorLife"/> 
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
    <HorizontalResolution>300</HorizontalResolution>
    <VerticalResolution>300</VerticalResolution>
   </Print>
   <Selected/>
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
   <Range>R10C3</Range>
   <UseBlank/>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Tech Prod Internal Lifeycle">
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s25" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="127"/>
   <Column ss:StyleID="s25" ss:AutoFitWidth="0" ss:Width="208" ss:Span="2"/>
   <Row>
    <Cell ss:StyleID="s24"/>
    <Cell ss:Index="3" ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s23"><Data ss:Type="String">Internal Lifecycles for Technology Products</Data></Cell>
    <Cell ss:StyleID="s26"/>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s24"/>
    <Cell><Data ss:Type="String">Defines the Strategic Lifectycle of Technology Products</Data></Cell>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s24"/>
    <Cell ss:Index="3" ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s24"/>
    <Cell ss:Index="3" ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
    <Cell ss:StyleID="s24"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s19"/>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Supplier</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Technology Product</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Internal Lifecycle Status</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">From Date</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6">
    <Cell ss:Index="2" ss:StyleID="s19"/>
   </Row>
  <xsl:apply-templates select="$techProd" mode="internalLife"/>  
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
     <ActiveRow>16</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R224C5</Range>
   <Type>Date</Type>
   <Qualifier>Greater</Qualifier>
   <UseBlank/>
   <Value>36526</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R6000C4</Range>
   <Type>List</Type>
   <Value>Internal_Lifecycle</Value>
  </DataValidation>
<!--  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R300C4</Range>
   <Type>List</Type>
   <Value>'Internal Tech Prod Lifecycles'!R8C3:R300C3</Value>
  </DataValidation>-->
 </Worksheet>
 <Worksheet ss:Name="Internal Tech Prod Lifecycles">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="106"/>
   <Column ss:Index="5" ss:AutoFitWidth="0" ss:Width="90" ss:Span="1"/>
   <Row ss:Index="2" ss:Height="26">
    <Cell ss:Index="2" ss:StyleID="s34"><Data ss:Type="String">Internal Technology Product Lifecycle Terms</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s35"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Label</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s35"><Data ss:Type="String">Colours</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="7"/>
    <xsl:apply-templates select="$internalLife" mode="internalLifeValues"/>  
  
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
     <ActiveCol>10</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="Ref">
  <Table ss:ExpandedColumnCount="5" ss:ExpandedRowCount="471" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s24" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:Index="2" ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="43"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s24" ss:AutoFitWidth="0" ss:Width="131"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s26"><Data ss:Type="String">Technology Vendor Release Statii</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures the Vendor Release Statii of Technology Products and their relative score (1 - 10)</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3"><Data ss:Type="String">DO NOT EDIT</Data></Cell>
   </Row>
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s36"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s37"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s36"><Data ss:Type="String">Colour</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS1</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Beta</Data></Cell>
    <Cell ss:StyleID="s30"><Data ss:Type="String">#4196D9</Data></Cell>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS2</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">End of Life</Data></Cell>
    <Cell ss:StyleID="s30"><Data ss:Type="String">#9B53B3</Data></Cell>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS3</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">Extended Support</Data></Cell>
    <Cell ss:StyleID="s30"><Data ss:Type="String">#EEC62A</Data></Cell>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row ss:Height="16">
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS4</Data></Cell>
    <Cell ss:StyleID="s29"><Data ss:Type="String">General Availability</Data></Cell>
    <Cell ss:StyleID="s30"><Data ss:Type="String">#E37F2C</Data></Cell>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS5</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS6</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS7</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS8</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS9</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS10</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS11</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS12</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS13</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS14</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS15</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS16</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s30"><Data ss:Type="String">VLS17</Data></Cell>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s30"/>
    <Cell ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s25"/>
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
     <RangeSelection>R8C4:R11C4</RangeSelection>
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
    
</xsl:stylesheet>