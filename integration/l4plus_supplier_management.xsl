<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

<xsl:variable name="techProd" select="/node()/simple_instance[type = ('Technology_Product','Technology_Product_Build')]"/>  
<xsl:variable name="vendorLife" select="/node()/simple_instance[type = 'Vendor_Lifecycle_Status']"/>    
<xsl:variable name="internalLife" select="/node()/simple_instance[type = 'Lifecycle_Status']"/> 
 <xsl:variable name="lifecycleModel" select="/node()/simple_instance[type = ('Lifecycle_Model','Vendor_Lifecycle_Model')][own_slot_value[slot_reference='lifecycle_model_subject']/value=$techProd/name]"/>   
<xsl:variable name="lifecycleModelStatus" select="/node()/simple_instance[type = ('Lifecycle_Status_Usage','Vendor_Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$lifecycleModel/name]"/>   
<xsl:variable name="supplier" select="/node()/simple_instance[type = ('Supplier')]"/>   
<xsl:variable name="groupActors" select="/node()/simple_instance[type = ('Group_Actor')]"/>   
<xsl:variable name="groupActorSuppliers" select="/node()/simple_instance[type = ('Group_Actor')][own_slot_value[slot_reference='external_to_enterprise']/value='true']"/>    
<xsl:variable name="allSupplier" select="$supplier union $groupActorSuppliers"/>   
<xsl:variable name="suppStatus" select="/node()/simple_instance[type = 'Supplier_Relationship_Status']"/>      <xsl:variable name="contracts" select="/node()/simple_instance[type = ('Contract')]"/>  
 <xsl:variable name="contractType" select="/node()/simple_instance[type = ('Contract_Type')]"/>  
 <xsl:variable name="processes" select="/node()/simple_instance[type = ('Business_Process')]"/>       
<xsl:variable name="apps" select="/node()/simple_instance[type = ('Composite_Application_Provider','Application_Provider')]"/>    
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
  <Title>l5 supplier</Title>
  <Author>eas</Author>
  <LastAuthor>Microsoft Office User</LastAuthor>
  <Created>2020-10-13T14:06:02Z</Created>
  <LastSaved>2020-02-17T16:41:46Z</LastSaved>
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
  <WindowHeight>16540</WindowHeight>
  <WindowWidth>28800</WindowWidth>
  <WindowTopX>920</WindowTopX>
  <WindowTopY>860</WindowTopY>
  <TabRatio>871</TabRatio>
  <ActiveSheet>7</ActiveSheet>
  <FirstVisibleSheet>2</FirstVisibleSheet>
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
  <Style ss:ID="s1021" ss:Name="Hyperlink">
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
  <Style ss:ID="m140400766371760">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
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
  <Style ss:ID="s1025">
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
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
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
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1028">
   <Interior/>
  </Style>
  <Style ss:ID="s1029">
   <Alignment ss:Vertical="Bottom"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1030">
   <Borders/>
  </Style>
  <Style ss:ID="s1031">
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
  <Style ss:ID="s1032">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1033">
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1034">
   <Borders/>
   <Interior/>
  </Style>
  <Style ss:ID="s1036">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1037">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1038">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1039">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1040">
   <Alignment ss:Horizontal="Left" ss:Vertical="Bottom"/>
  </Style>
  <Style ss:ID="s1041">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1042">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Interior/>
  </Style>
  <Style ss:ID="s1044">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1045">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1046">
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1047">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1049">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1051">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#76933C"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1052">
   <Alignment ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1053">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1054">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1055">
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
  <Style ss:ID="s1056">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
  </Style>
  <Style ss:ID="s1057">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF"/>
  </Style>
  <Style ss:ID="s1058">
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
  <Style ss:ID="s1059">
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
  <Style ss:ID="s1060">
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
  <Style ss:ID="s1061">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1063">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1064">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1065">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1066">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
  </Style>
  <Style ss:ID="s1067">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1068">
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
  <Style ss:ID="s1069">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1070">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1071">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1073">
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
  <Style ss:ID="s1074" ss:Parent="s17">
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1076">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1077">
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
  <Style ss:ID="s1078">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1079">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1080">
   <Alignment ss:Horizontal="Right" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1081">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1083">
   <Alignment ss:Vertical="Bottom"/>
  </Style>
  <Style ss:ID="s1084" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1087" ss:Parent="s18">
   <Alignment ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1088">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1089">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1090" ss:Parent="s18">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1091">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
  </Style>
  <Style ss:ID="s1092">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1093">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1094">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1095">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1096">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1097">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1098">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1099">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1100">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1101">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1102">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="Fixed"/>
  </Style>
  <Style ss:ID="s1103" ss:Parent="s18">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1104">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1105">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1106">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#808080"
    ss:Bold="1"/>
   <Interior ss:Color="#D9D9D9" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1107" ss:Parent="s1021">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1108">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1109">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="0"/>
  </Style>
  <Style ss:ID="s1110">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <NumberFormat ss:Format="0"/>
  </Style>
  <Style ss:ID="s1111">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1112">
   <Alignment ss:Vertical="Bottom"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
  </Style>
  <Style ss:ID="s1113">
   <Alignment ss:Vertical="Top"/>
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
  <Style ss:ID="s1114">
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
  </Style>
  <Style ss:ID="s1115">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1116">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1117">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1118">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1119">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1120">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1121">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1122">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1123">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1124">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1125">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1126">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1127">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1128">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1129">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1130">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1131">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1132">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1133">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1134">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior ss:Color="#4F81BD" ss:Pattern="Solid"/>
  </Style>
  <Style ss:ID="s1135">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1136">
   <Alignment ss:Vertical="Bottom"/>
   <Borders/>
   <Font ss:FontName="Arial" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1137">
   <Alignment ss:Vertical="Top"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1138">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1139">
   <Alignment ss:Vertical="Top"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1140">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
   <NumberFormat/>
  </Style>
  <Style ss:ID="s1141">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1142">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1144">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1145">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1146">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1147">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1148">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1149">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1150">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
   <NumberFormat ss:Format="yyyy\-mm\-dd;@"/>
  </Style>
  <Style ss:ID="s1151">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
   <NumberFormat ss:Format="0"/>
  </Style>
  <Style ss:ID="s1152">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
   <NumberFormat ss:Format="0"/>
  </Style>
  <Style ss:ID="s1153">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
   <NumberFormat ss:Format="Fixed"/>
  </Style>
  <Style ss:ID="s1154">
   <Alignment ss:Horizontal="Center" ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1155">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1166">
   <Alignment ss:Horizontal="Left" ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1167">
   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1168">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1169">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1170">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1171">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1172">
   <Alignment ss:Vertical="Top"/>
   <Borders>
    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
   </Borders>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"
    ss:Bold="1"/>
   <Interior/>
  </Style>
  <Style ss:ID="s1178">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1179">
   <Alignment ss:Vertical="Bottom"/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1181" ss:Parent="s18">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
    ss:Bold="1"/>
  </Style>
  <Style ss:ID="s1182">
   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
   <Borders/>
   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"/>
  </Style>
 </Styles>
 <Names>
  <NamedRange ss:Name="Allowed_CRUD_Values" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="App_Cap_Cat" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="App_Delivery_Models" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="App_Dif_Level" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="App_Type" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Application_Codebases" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Application_Cost_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Application_Delivery_Model" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="AppProRole" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Area" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Buainess_Drivers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Bus_Cap_type" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Bus_Caps" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Business_Drivers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Business_Goals" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Business_Objectives" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Contract_Types" ss:RefersTo="='Contract Types'!R7C3:R21C3"/>
  <NamedRange ss:Name="Languages" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Lifecycle_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Organisations"
   ss:RefersTo="='REF Orgs - Contract Owner'!R7C3:R166C3"/>
  <NamedRange ss:Name="Product_Concepts" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Product_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Products" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Reference_Model_Layers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Renewal_Types" ss:RefersTo="='Renewal Types'!R7C3:R14C3"/>
  <NamedRange ss:Name="Servers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Supplier_Relationship_Statii"
   ss:RefersTo="='Supplier Relation Status'!R7C3:R12C3"/>
  <NamedRange ss:Name="Tech_Compliance_Levels" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Delivery_Models" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Svc_Quality_Values" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Tech_Vendor_Release_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Capabilities" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Components" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Domains" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Product_Families" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Technology_Product_Suppliers"
   ss:RefersTo="=Suppliers!R7C3:R175C3"/>
  <NamedRange ss:Name="Technology_Products"
   ss:RefersTo="='REF Technology Products'!R7C3:R743C3"/>
  <NamedRange ss:Name="Usage_Lifecycle_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Actor_Category" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Caps" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Category" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Classification" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Service_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_App_Services" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Application_Capability_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Application_Provider_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Application_Purpose" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Best_Practice_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Bus_Comp_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Bus_Doms" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Bus_Proc"
   ss:RefersTo="='REF Business Processes'!R7C3:R314C3"/>
  <NamedRange ss:Name="Valid_Business_Criticality" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Business_Domain_Layers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Business_Issue_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Business_Processes"
   ss:RefersTo="='REF Business Processes'!R8C3:R859C3"/>
  <NamedRange ss:Name="Valid_Calendar_Quarters" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Calendar_Year" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Composite_Applications"
   ss:RefersTo="='REF Applications'!R8C3:R365C3"/>
  <NamedRange ss:Name="Valid_Countries" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Data_Aquisition_Methods" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Data_Attribute_Cardinality" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Data_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Day_In_Month" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Deployment_Roles" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Driver_Classifications" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_EA_Standard_Lifcycle_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_End_Flow" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Environments" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Goal_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_High_Medium_Low" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Information_Representation_Categories"
   ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Month_In_Year" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Obligation_Lifecycle_Status" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Owning_Org" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Pimitive_Data_Objects" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Planning_Actions" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Position_in_Parent" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Principle_Compliance_Level" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Product_Type_Categories" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Project_Approval_Status" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Project_Statii" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Reporting_Line_Strength" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Secured_Actions" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Sites" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Skill_Level" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Skill_Qualifiers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Standardisation_Level" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Start_Flow" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Support_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Tech_Node_Roles" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Technology_Architecture_Tiers" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Technology_Component_Usage_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_Technology_Composite_Types" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_True_or_False" ss:RefersTo="=#REF!"/>
  <NamedRange ss:Name="Valid_YesNo" ss:RefersTo="=#REF!"/>
 </Names>
 <Worksheet ss:Name="Table of Contents">
  <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="24" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1028" ss:AutoFitWidth="0"/>
   <Column ss:AutoFitWidth="0" ss:Width="394"/>
   <Column ss:AutoFitWidth="0" ss:Width="786"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1084"><Data ss:Type="String">IT Contracts Capture Spreadsheet</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:MergeAcross="1" ss:StyleID="s1079"/>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="2" ss:StyleID="s19"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s19"/>
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
    <Cell ss:Index="2" ss:StyleID="s1038"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1031" ss:HRef="#Suppliers!A1"><Data
      ss:Type="String">Suppliers (Resellers)</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Captures the suppliers of products and/or services to the enterprise</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1031" ss:HRef="#Contracts!A1"><Data
      ss:Type="String">Contracts</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Captures the contracts related to a supplier</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1031" ss:HRef="#'Contract Components'!A1"><Data
      ss:Type="String">Contract Components</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">Captures the individual components for a  contract, for example the applications/technologies covered, cost etc.</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Supplier Rel Statii'!A1"><Data
      ss:Type="String">REF Supplier Relation Status</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of Supplier status</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Organisations'!A1"><Data
      ss:Type="String">REF Orgs - Contract Owner</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of organisations that might own a contract</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Contract Types'!A1"><Data
      ss:Type="String">REF Contract Types</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of types of contracts</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Renewal Types'!A1"><Data
      ss:Type="String">REF Renewal Types</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of types of renewals</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Unit Types'!A1"><Data
      ss:Type="String">REF Unit Types</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of types of contract units</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Business Processes'!A1"><Data
      ss:Type="String">REF Business Processes</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of the business processes that have been exported from the repository</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="Default"/>
    <Cell ss:StyleID="s1058" ss:HRef="#'REF Applications'!A1"><Data
      ss:Type="String">REF Applications</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of the applications that have been exported from the repository</Data></Cell>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1058" ss:HRef="#'REF Technology Products'!A1"><Data
      ss:Type="String">REF Technology Products</Data></Cell>
    <Cell ss:StyleID="s1024"><Data ss:Type="String">A reference list of the technology products that have been exported from the repository</Data></Cell>
   </Row>
   <Row ss:Height="20" ss:Hidden="1">
    <Cell ss:Index="2" ss:StyleID="s1106" ss:HRef="#'REF LIcenses'!A1"><Data
      ss:Type="String">REF Licenses (DEFERRED)</Data></Cell>
    <Cell ss:StyleID="s1047"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1051"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>33</ActiveRow>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R12C2:R14C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R12C2:R14C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R20C2:R23C2,R15C2,R17C2:R18C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R20C2:R23C2, RC)+COUNTIF(R15C2:R15C2, RC)+COUNTIF(R17C2:R18C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R16C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R16C2:R16C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R19C2</Range>
   <Condition>
    <Value1>AND(COUNTIF(R19C2:R19C2, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="REF Orgs - Contract Owner">
  <Table ss:ExpandedColumnCount="5"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1052" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="189"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="1001"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="91"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1053"><Data ss:Type="String">Organisations</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Capture the organisations and hierarchy/structure</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1129"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1129"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1129"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1117"><Data ss:Type="String">External?</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6" ss:StyleID="s1139">
    <Cell ss:Index="2" ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Organisations"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1138"/>
   </Row>
   <xsl:apply-templates select="$groupActors" mode="orgs"/>
 
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>22</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>3</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <RangeSelection>R7</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C5:R166C5</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;True, False&quot;</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="REF Business Processes">
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="33"/>
   <Column ss:Index="3" ss:StyleID="s1039" ss:AutoFitWidth="0" ss:Width="172"/>
   <Column ss:StyleID="s1039" ss:AutoFitWidth="0" ss:Width="933"/>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1083"/>
    <Cell ss:StyleID="s1049"/>
    <Cell ss:StyleID="s1040"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1179"><Data ss:Type="String">Business Processes</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1083"><Data ss:Type="String">Captures the Business processes and their relationship to the business capabilities.</Data></Cell>
    <Cell ss:StyleID="s1049"/>
    <Cell ss:StyleID="s1040"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1083"/>
    <Cell ss:StyleID="s1049"/>
    <Cell ss:StyleID="s1040"/>
   </Row>
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1083"/>
    <Cell ss:StyleID="s1049"/>
    <Cell ss:StyleID="s1040"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1120"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1133"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8" ss:StyleID="s1028">
    <Cell ss:Index="2" ss:StyleID="s1142"/>
    <Cell ss:StyleID="s1166"><NamedCell ss:Name="Valid_Bus_Proc"/></Cell>
    <Cell ss:StyleID="s1167"/>
   </Row>
    <xsl:apply-templates select="$processes" mode="processes"/>   
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <Print>
    <ValidPrinterInfo/>
    <PaperSizeIndex>9</PaperSizeIndex>
    <HorizontalResolution>-4</HorizontalResolution>
    <VerticalResolution>-4</VerticalResolution>
   </Print>
   <TabColorIndex>22</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>3</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <RangeSelection>R7</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
 </Worksheet>
 <Worksheet ss:Name="REF Applications">
  <Names>
   <NamedRange ss:Name="_FilterDatabase"
    ss:RefersTo="='REF Applications'!R6C2:R135C4" ss:Hidden="1"/>
   <NamedRange ss:Name="Print_Area" ss:RefersTo="='REF Applications'!R6C2:R135C4"/>
  </Names>
  <Table ss:ExpandedColumnCount="4"  x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1030" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="15">
   <Column ss:StyleID="s1030" ss:AutoFitWidth="0" ss:Width="36"/>
   <Column ss:StyleID="s1030" ss:AutoFitWidth="0" ss:Width="50"/>
   <Column ss:StyleID="s1046" ss:AutoFitWidth="0" ss:Width="184"/>
   <Column ss:StyleID="s1030" ss:AutoFitWidth="0" ss:Width="479"/>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1045"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="35">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1181"><Data ss:Type="String">Applications</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s1182"><Data ss:Type="String">Captures information about the Applications used within the organisation</Data></Cell>
   </Row>
   <Row ss:Index="5" ss:AutoFitHeight="0">
    <Cell ss:Index="3" ss:StyleID="s1045"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="23">
    <Cell ss:Index="2" ss:StyleID="s1134"><Data ss:Type="String">ID</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font
        html:Color="#000000">                      </Font><Font html:Size="9"
        html:Color="#000000">A unique ID for the Application</Font><Font
        html:Color="#000000">                   </Font></ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Name</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font
        html:Color="#000000">                      </Font><Font html:Size="9"
        html:Color="#000000">The name of the Application</Font><Font
        html:Color="#000000">                   </Font></ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1134"><Data ss:Type="String">Description</Data><Comment
      ss:Author="AutoGen"><ss:Data xmlns="http://www.w3.org/TR/REC-html40">                      <Font
        html:Size="9" html:Color="#000000">A description of the functionality provided by the Application</Font>                   </ss:Data></Comment><NamedCell
      ss:Name="Print_Area"/><NamedCell ss:Name="_FilterDatabase"/></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="11" ss:StyleID="s1034">
    <Cell ss:Index="2" ss:StyleID="s1024"><NamedCell ss:Name="Print_Area"/><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1077"><NamedCell ss:Name="Print_Area"/><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
    <Cell ss:StyleID="s1142"><NamedCell ss:Name="Print_Area"/><NamedCell
      ss:Name="_FilterDatabase"/></Cell>
   </Row>
     <xsl:apply-templates select="$apps" mode="processes"/>   
  
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
   <TabColorIndex>22</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>8</ActiveRow>
     <ActiveCol>2</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <RangeSelection>R7</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2:R7C2,R6C4:R7C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R7C2, RC)+COUNTIF(R6C4:R7C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3:R7C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R7C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="REF Technology Products">
  <Names>
   <NamedRange ss:Name="_FilterDatabase"
    ss:RefersTo="='REF Technology Products'!R8C1:R743C5" ss:Hidden="1"/>
  </Names>
  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1052" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="19"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="70"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="236"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="148"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="388"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1053"><Data ss:Type="String">Technology Products</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Details the Technology Products</Data></Cell>
   </Row>
   <Row>
    <Cell ss:Index="5" ss:StyleID="s1080"/>
   </Row>
   <Row ss:Index="6" ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1115"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Supplier</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="10" ss:StyleID="s1139">
    <Cell ss:Index="2" ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1135"><NamedCell ss:Name="Technology_Products"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1142"/>
   </Row>
   <xsl:apply-templates select="$techProd" mode="techProds"/>
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <TabColorIndex>22</TabColorIndex>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>3</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <RangeSelection>R7</RangeSelection>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C4:R743C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Technology_Product_Suppliers</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="REF LIcenses">
  <Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="31" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="236"/>
   <Column ss:AutoFitWidth="0" ss:Width="210"/>
   <Column ss:AutoFitWidth="0" ss:Width="125"/>
   <Column ss:AutoFitWidth="0" ss:Width="488"/>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1087"><Data ss:Type="String">Licenses</Data></Cell>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1084"/>
    <Cell ss:StyleID="s1084"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"><Data ss:Type="String">Used to capture the Licenses in scope for the enterprise</Data></Cell>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1088"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1088"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1068"><Data ss:Type="String">Licenser</Data></Cell>
    <Cell ss:StyleID="s1093"><Data ss:Type="String">License Type</Data></Cell>
    <Cell ss:StyleID="s1092"><Data ss:Type="String">Description</Data></Cell>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS1</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS2</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS3</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS4</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS5</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS6</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS7</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS8</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS9</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS10</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS11</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS12</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS13</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS14</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS15</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS16</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS17</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS18</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS19</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS20</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">LCS21</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1044"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1097"><Data ss:Type="String">LCS22</Data></Cell>
    <Cell ss:StyleID="s1097"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1033"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1079"/>
   </Row>
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Visible>SheetHidden</Visible>
   <TabColorIndex>55</TabColorIndex>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>17</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C6,R6C2:R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C6:R6C6, RC)+COUNTIF(R6C2:R6C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
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
 </Worksheet> 
<Worksheet ss:Name="Contract Types">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Contract Types'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Contract Types'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="24" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1079" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="128"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1178"><Data ss:Type="String">Contract Types</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Language</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Custom Label</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT1</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Statement of Work</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Statement of Work</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT2</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">NDA</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">NDA</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT3</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">MSA</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">MSA</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT4</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Agreement</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Agreement</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT5</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Order Form</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Order Form</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT6</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Service Level Agreement</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">6</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Service Level Agreement</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT7</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Schedule</Data><NamedCell
      ss:Name="Contract_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">7</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Schedule</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT8</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT9</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT10</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT11</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT12</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT13</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT14</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Contract_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT15</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT16</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">CT17</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
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
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>9</ActiveRow>
     <ActiveCol>2</ActiveCol>
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
 <Worksheet ss:Name="Renewal Types">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Renewal Types'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Renewal Types'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="24" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1079" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1052" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="128"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1178"><Data ss:Type="String">Renewal Types</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1059"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Language</Data></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Custom Label</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT1</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Auto-renew</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Auto-renew</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT2</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Fixed Term</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Fixed Term</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT3</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Ad-hoc</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Ad-hoc</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT4</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Renewal_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT5</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Renewal_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT6</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Renewal_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT7</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Renewal_Types"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT8</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT9</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT10</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT11</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT12</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT13</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT14</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT15</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT16</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">RT17</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
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
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>2</ActiveRow>
     <ActiveCol>3</ActiveCol>
    </Pane>
   </Panes>
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
 <Worksheet ss:Name="Unit Types">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Unit Types'!R7C3:R24C3"/>
   <NamedRange ss:Name="Renewal_Types" ss:RefersTo="='Unit Types'!R8C3:R14C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Unit Types'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="24" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1079" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1052" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="128"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1178"><Data ss:Type="String">Unit Types</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1132"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1130"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1130"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1130"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1130"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1131"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1059"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1060"><Data ss:Type="String">Language</Data></Cell>
    <Cell ss:StyleID="s1055"><Data ss:Type="String">Custom Label</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6" ss:StyleID="s1168">
    <Cell ss:Index="2" ss:StyleID="s1169"/>
    <Cell ss:StyleID="s1142"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1142"/>
    <Cell ss:StyleID="s1142"/>
    <Cell ss:StyleID="s1142"/>
    <Cell ss:StyleID="s1170"/>
    <Cell ss:StyleID="s1171"/>
    <Cell ss:StyleID="s1171"/>
    <Cell ss:StyleID="s1171"/>
    <Cell ss:StyleID="s1171"/>
    <Cell ss:StyleID="s1172"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT1</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Enteprise</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Enteprise</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT2</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Named User</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Named User</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT3</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Floating User</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">3</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Floating User</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT4</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Day</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">4</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Day</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT5</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Hour</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">5</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Hour</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT6</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Year</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">6</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Year</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT7</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">CPU</Data><NamedCell
      ss:Name="Renewal_Types"/><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">7</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">CPU</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1114"><Data ss:Type="String">UT8</Data></Cell>
    <Cell ss:StyleID="s1044"><Data ss:Type="String">Core</Data><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1044"><Data ss:Type="Number">8</Data></Cell>
    <Cell ss:StyleID="s1044"/>
    <Cell ss:StyleID="s1069"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Core</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT9</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT10</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT11</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT12</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT13</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT14</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT15</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1100"><Data ss:Type="String">UT16</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1101"><Data ss:Type="String">UT17</Data></Cell>
    <Cell ss:StyleID="s1071"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1071"/>
    <Cell ss:StyleID="s1096"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
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
   <Selected/>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>27</ActiveRow>
     <ActiveCol>6</ActiveCol>
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
 <Worksheet ss:Name="Suppliers">
  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1052" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="18"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="59"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="290"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="351"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="466"/>
   <Column ss:StyleID="s1056" ss:AutoFitWidth="0" ss:Width="91"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1053"><Data ss:Type="String">Supplier Organisations</Data></Cell>
    <Cell ss:StyleID="s1067"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Captures a list of organisations that supply products or services to an Organisation</Data></Cell>
    <Cell ss:StyleID="s1066"/>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="6"><Data ss:Type="String">Optional</Data></Cell>
   </Row>
   <Row ss:Height="19">
    <Cell ss:Index="2" ss:StyleID="s1115"><Data ss:Type="String">Ref</Data></Cell>
    <Cell ss:StyleID="s1116"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1116"><Data ss:Type="String">Relationship Status</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Web Site Link</Data></Cell>
    <Cell ss:StyleID="s1117"><Data ss:Type="String">External?</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="6" ss:StyleID="s1139">
    <Cell ss:Index="2" ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1136"><NamedCell ss:Name="Technology_Product_Suppliers"/></Cell>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1137"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1138"/>
   </Row>
      
    <xsl:apply-templates select="$allSupplier" mode="supplierList"/>  
   
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Zoom>94</Zoom>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>8</ActiveRow>
     <ActiveCol>2</ActiveCol>
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
   <Range>R7C5:R175C5</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>Supplier_Relationship_Statii</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C7:R175C7</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;TRUE, FALSE&quot;</Value>
  </DataValidation>
 </Worksheet>
 <Worksheet ss:Name="Contracts">
  <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1052" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="46"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="162"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="333"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="171"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="453"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="139"/>
   <Column ss:StyleID="s1091" ss:AutoFitWidth="0" ss:Width="124"/>
   <Column ss:StyleID="s1091" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="124"
    ss:Span="1"/>
   <Column ss:Index="11" ss:StyleID="s1052" ss:Hidden="1" ss:AutoFitWidth="0"
    ss:Width="161"/>
   <Column ss:StyleID="s1052" ss:AutoFitWidth="0" ss:Width="757"/>
   <Column ss:AutoFitWidth="0"/>
   <Row>
    <Cell ss:Index="13" ss:StyleID="s1052"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:StyleID="s1087"><Data ss:Type="String">Contracts</Data></Cell>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:Index="5" ss:StyleID="s1084"/>
    <Cell ss:StyleID="s1084"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1103"/>
    <Cell ss:StyleID="s1103"/>
    <Cell ss:StyleID="s1103"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:Index="13" ss:StyleID="s1052"/>
   </Row>
   <Row>
    <Cell ss:Index="2"><Data ss:Type="String">Used to capture the Contracts in scope for the enterprise</Data></Cell>
    <Cell ss:Index="5" ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:Index="13" ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="9"><Data ss:Type="String">Hide</Data></Cell>
    <Cell><Data ss:Type="String">Hide</Data></Cell>
    <Cell><Data ss:Type="String">Hide</Data></Cell>
    <Cell ss:Index="13" ss:StyleID="s1052"/>
   </Row>
   <Row>
    <Cell ss:Index="13" ss:StyleID="s1052"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="44">
    <Cell ss:Index="2" ss:StyleID="s1118"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1118"><Data ss:Type="String">Supplier or Reseller</Data></Cell>
    <Cell ss:StyleID="s1119"><Data ss:Type="String">Contract Name</Data></Cell>
    <Cell ss:StyleID="s1120"><Data ss:Type="String">Contract Owner</Data></Cell>
    <Cell ss:StyleID="s1120"><Data ss:Type="String">Service Description</Data></Cell>
    <Cell ss:StyleID="s1121"><Data ss:Type="String">Contract Type</Data></Cell>
    <Cell ss:StyleID="s1123"><Data ss:Type="String">Signature Date (YYYY-MM-DD)</Data></Cell>
    <Cell ss:StyleID="s1121"><Data ss:Type="String">Column1</Data></Cell>
    <Cell ss:StyleID="s1121"><Data ss:Type="String">Column2</Data></Cell>
    <Cell ss:StyleID="s1121"><Data ss:Type="String">Column3</Data></Cell>
    <Cell ss:StyleID="s1122"><Data ss:Type="String">Document Link - URL</Data></Cell>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8" ss:StyleID="s1139">
    <Cell ss:Index="2" ss:StyleID="s1141"/>
    <Cell ss:StyleID="s1073"/>
    <Cell ss:StyleID="s1140"
     ss:Formula="=IF(RC[-1]&lt;&gt;&quot;&quot;, CONCATENATE(RC[-2], &quot; - &quot;, RC[-1], &quot; - &quot;, RC[3], &quot; - &quot;, TEXT(RC[4], &quot;yyyy-mm-dd&quot;)), &quot;&quot;)"><Data
      ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1073"/>
    <Cell ss:StyleID="s1142"/>
    <Cell ss:StyleID="s1135"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1144"/>
    <Cell ss:StyleID="s1145"/>
    <Cell ss:StyleID="s1146"/>
   </Row>
      <xsl:apply-templates select="$contracts" mode="contract"/>  
   <Row>
    <Cell ss:Index="2" ss:StyleID="s1089"><Data ss:Type="String">CTR1</Data></Cell>
    <Cell ss:StyleID="s1073"/>
    <Cell ss:StyleID="s1113"/>
    <Cell ss:StyleID="s1073"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1104"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1094"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1107"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
  
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <LeftColumnVisible>1</LeftColumnVisible>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>6</SplitHorizontal>
   <TopRowBottomPane>6</TopRowBottomPane>
   <SplitVertical>3</SplitVertical>
   <LeftColumnRightPane>11</LeftColumnRightPane>
   <ActivePane>0</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
    <Pane>
     <Number>1</Number>
     <ActiveCol>4</ActiveCol>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
    <Pane>
     <Number>0</Number>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C5:R56C5</Range>
   <Type>List</Type>
   <Value>'REF Orgs - Contract Owner'!R7C3:R3000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C7:R56C7</Range>
   <Type>List</Type>
   <Value>Contract_Types</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C3:R56C3</Range>
   <Type>List</Type>
    <Value>Suppliers!R7C3:R3000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C9:R56C9</Range>
   <Type>List</Type>
   <Value>Renewal_Types</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C6:R7C6,R6C2:R7C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C6:R7C6, RC)+COUNTIF(R6C2:R7C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C5:R7C5</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C5:R7C5, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C12:R7C12</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C12:R7C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C7:R7C8</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C7:R7C8, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C4:R7C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R7C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C9:R7C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C9:R7C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10:R7C11</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R7C11, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Contract Components">
  <Table ss:ExpandedColumnCount="17" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="16"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="328"/>
   <Column ss:AutoFitWidth="0" ss:Width="181" ss:Span="2"/>
   <Column ss:Index="7" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="181"/>
   <Column ss:AutoFitWidth="0" ss:Width="181"/>
   <Column ss:AutoFitWidth="0" ss:Width="232"/>
   <Column ss:AutoFitWidth="0" ss:Width="184"/>
   <Column ss:AutoFitWidth="0" ss:Width="181"/>
   <Column ss:StyleID="s1091" ss:AutoFitWidth="0" ss:Width="117"/>
   <Column ss:StyleID="s1091" ss:AutoFitWidth="0" ss:Width="139"/>
   <Column ss:StyleID="s1091" ss:AutoFitWidth="0" ss:Width="96"/>
   <Column ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="181"/>
   <Column ss:AutoFitWidth="0" ss:Width="578"/>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="29">
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1087"><Data ss:Type="String">Contract Components</Data></Cell>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1084"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1090"/>
    <Cell ss:StyleID="s1090"/>
    <Cell ss:StyleID="s1090"/>
    <Cell ss:StyleID="s1087"/>
    <Cell ss:StyleID="s1084"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"><Data ss:Type="String">Used to capture the Contracts in scope for the enterprise</Data></Cell>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1052"><Data ss:Type="String">Hide</Data></Cell>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="19">
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:MergeAcross="2" ss:StyleID="m140400766371760"><Data ss:Type="String">Contracted Product / Service (select ONE from THREE columns below)</Data></Cell>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1056"/>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1079"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Contract</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Business Process</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Application</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Technology Product</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Column1</Data></Cell>
    <Cell ss:StyleID="s1124"><Data ss:Type="String">Renewal Type</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Service End Date (YYYY-MM-DD)</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Service Notice Period (days)</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Unit Type</Data></Cell>
    <Cell ss:StyleID="s1126"><Data ss:Type="String"># of Units</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Total Annual  Cost</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Currency</Data></Cell>
    <Cell ss:StyleID="s1125"><Data ss:Type="String">Column2</Data></Cell>
    <Cell ss:StyleID="s1127"><Data ss:Type="String">Comments</Data></Cell>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8" ss:StyleID="s1028">
    <Cell ss:StyleID="s1139"/>
    <Cell ss:StyleID="s1147"/>
    <Cell ss:StyleID="s1147"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1149"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1150"/>
    <Cell ss:StyleID="s1151"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1152"/>
    <Cell ss:StyleID="s1153"/>
    <Cell ss:StyleID="s1154"/>
    <Cell ss:StyleID="s1148"/>
    <Cell ss:StyleID="s1155"/>
    <Cell ss:StyleID="s1139"/>
   </Row>
   <Row>
    <Cell ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1089"><Data ss:Type="String">CTRCP1</Data></Cell>
    <Cell ss:StyleID="s1089"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1094"/>
    <Cell ss:StyleID="s1110"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1109"/>
    <Cell ss:StyleID="s1102"/>
    <Cell ss:StyleID="s1076"/>
    <Cell ss:StyleID="s1054"/>
    <Cell ss:StyleID="s1095"/>
    <Cell ss:StyleID="s1052"/>
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
   <Range>R7C8:R64C8</Range>
   <Type>List</Type>
   <Value>Renewal_Types</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C3:R64C3</Range>
   <Type>List</Type>
    <Value>Contracts!R3C3:R3000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C14:R64C14</Range>
   <Type>List</Type>
   <Qualifier>GreaterOrEqual</Qualifier>
   <CellRangeList/>
   <Value>&quot;British Pound, Euro, US Dollar&quot;</Value>
  </DataValidation>

 
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R7C15:R64C15</Range>
   <Type>List</Type>
   <Value>Licenses!R7C3:R3000C3</Value>
  </DataValidation>
    <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C4:R3000C4</Range>
   <Type>List</Type>
   <Value>'REF Business Processes'!R8C3:R44C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R3000C5</Range>
   <Type>List</Type>
   <Value>'REF Applications'!R8C3:R42C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R3000C6</Range>
   <Type>List</Type>
   <Value>'REF Technology Products'!R8C3:R33C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C11:R3000C11</Range>
   <Type>List</Type>
   <Value>'Unit Types'!R8C3:R23C3</Value> 
    </DataValidation>  
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C16:R7C16,R6C2:R7C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C16:R7C16, RC)+COUNTIF(R6C2:R7C3, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C4:R7C6,R5C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C4:R7C6, RC)+COUNTIF(R5C4:R5C4, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R7C8</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R7C8, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C7:R7C7,R6C9:R7C15</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C7:R7C7, RC)+COUNTIF(R6C9:R7C15, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Supplier Relation Status">
  <Names>
   <NamedRange ss:Name="Application_Codebases"
    ss:RefersTo="='Supplier Relation Status'!R7C3:R24C3"/>
   <NamedRange ss:Name="Tech_Compliance_Levels"
    ss:RefersTo="='Supplier Relation Status'!R7C3:R24C3"/>
  </Names>
  <Table ss:ExpandedColumnCount="13" ss:ExpandedRowCount="24" x:FullColumns="1"
   x:FullRows="1" ss:StyleID="s1079" ss:DefaultColumnWidth="65"
   ss:DefaultRowHeight="16">
   <Column ss:Index="2" ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="57"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="131"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="252"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="92"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="89"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="134"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="141"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="259"/>
   <Column ss:StyleID="s1079" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="111"/>
   <Column ss:StyleID="s1052" ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="128"/>
   <Column ss:StyleID="s1079" ss:AutoFitWidth="0" ss:Width="148"/>
   <Row ss:Index="2" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s1178"><Data ss:Type="String">Supplier Relationship Status</Data></Cell>
   </Row>
   <Row ss:Index="5">
    <Cell ss:Index="3" ss:StyleID="s1052"/>
    <Cell ss:StyleID="s1052"/>
   </Row>
   <Row ss:Height="20">
    <Cell ss:Index="2" ss:StyleID="s1128"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Sequence No</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Colour</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Style Class</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Score</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Name Translation</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Description Translation</Data></Cell>
    <Cell ss:StyleID="s1128"><Data ss:Type="String">Language</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Custom Label</Data></Cell>
    <Cell ss:StyleID="s1115"><Data ss:Type="String">Contract Review Notice</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS1</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Strategic</Data><NamedCell
      ss:Name="Supplier_Relationship_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">1</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Strategic</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">120</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS2</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String">Approved</Data><NamedCell
      ss:Name="Supplier_Relationship_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">2</Data></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="String">Approved</Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="Number">90</Data></Cell>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS3</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Supplier_Relationship_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS4</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Supplier_Relationship_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS5</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Supplier_Relationship_Statii"/><NamedCell
      ss:Name="Tech_Compliance_Levels"/><NamedCell ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS6</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS7</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS8</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS9</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS10</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS11</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS12</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS13</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS14</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS15</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS16</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
   </Row>
   <Row ss:Height="17">
    <Cell ss:Index="2" ss:StyleID="s1061"><Data ss:Type="String">SRS17</Data></Cell>
    <Cell ss:StyleID="s1061"><NamedCell ss:Name="Tech_Compliance_Levels"/><NamedCell
      ss:Name="Application_Codebases"/></Cell>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1061"/>
    <Cell ss:StyleID="s1054" ss:Formula="=RC[-9]"><Data ss:Type="Number">0</Data></Cell>
    <Cell ss:StyleID="s1061"/>
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
   <Zoom>80</Zoom>
   <Panes>
    <Pane>
     <Number>3</Number>
     <ActiveRow>33</ActiveRow>
     <ActiveCol>4</ActiveCol>
    </Pane>
   </Panes>
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
    
<xsl:template match="node()" mode="supplierList">
<Row ss:AutoFitHeight="0">
    <Cell ss:Index="2" ss:StyleID="s1054"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1065"><NamedCell ss:Name="Technology_Product_Suppliers"/><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1054"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1054"><Data ss:Type="String"><xsl:value-of select="$suppStatus[name=current()/own_slot_value[slot_reference='supplier_relationship_status']/value]/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1054"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='supplier_url']/value"/></Data></Cell>
    <Cell ss:StyleID="s1108"><Data ss:Type="Boolean">1</Data></Cell>
   </Row>    
</xsl:template>
 <xsl:template match="node()" mode="contract">   
 <Row ss:AutoFitHeight="0" ss:Height="44">
   <xsl:variable name="thisSup" select="$allSupplier[name=current()/own_slot_value[slot_reference='contract_supplier']/value]"/>
<xsl:variable name="thisCust" select="$groupActors[name=current()/own_slot_value[slot_reference='contract_customer']/value]"/>
<xsl:variable name="ctype" select="$contractType[name=current()/own_slot_value[slot_reference='contract_type']/value]"/>     
    <Cell ss:Index="2" ss:StyleID="s1089"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="$thisSup/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1113"/>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="$thisCust/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1061"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1054"><Data ss:Type="String"><xsl:value-of select="$ctype/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1104"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='contract_signature_date_ISO8601']/value"/></Data></Cell>
    <Cell ss:StyleID="s1054"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1094"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1110"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s1107"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='external_reference_links']/value"/></Data></Cell>
    <Cell ss:StyleID="s1052"/>
   </Row>   
    </xsl:template>   
 <xsl:template match="node()" mode="orgs">   
    <Row>
     <Cell ss:StyleID="s1073"></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
     <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
    <Cell ss:StyleID="s1108"><Data ss:Type="Boolean">0</Data></Cell>
   </Row>
</xsl:template> 
 <xsl:template match="node()" mode="processes">   
    <Row>
     <Cell ss:StyleID="s1073"></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
     <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
   </Row>
 
</xsl:template>  
    <xsl:template match="node()" mode="techProds"> 
         <xsl:variable name="thisSup" select="$allSupplier[name=current()/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    <Row>
     <Cell ss:StyleID="s1073"></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/name"/></Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='name']/value"/></Data></Cell>
    <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="$thisSup/own_slot_value[slot_reference='name']/value"/></Data></Cell>    
     <Cell ss:StyleID="s1073"><Data ss:Type="String"><xsl:value-of select="current()/own_slot_value[slot_reference='description']/value"/></Data></Cell>
   </Row>
 
</xsl:template>   
    
</xsl:stylesheet>