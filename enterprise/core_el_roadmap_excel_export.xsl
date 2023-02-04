<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="UTF-8" media-type="application/ms-excel"/>
	
	<xsl:template name="RenderRoadmapExcel">
		<!-- Handlebars template to render the roadmap data in json format for exporting as Excel -->
		<script id="roadmap-excel-json-template" type="text/x-handlebars-template">
			{
				"roadmap": {
					"id": 1,
					"name":"Roadmap",
					"worksheetNameNice":"Roadmap",
					"worksheetName":"Roadmap",
					"description":"The Roadmap that has been created",
					"heading":[
						{"col":"B", "name":"Id"},
						{"col":"C", "name":"Name"},
						{"col":"D", "name":"Description"}
					],
					"data": [
						{
							"row": 8,
							"id": "{{roadmap.extId}}",
							"name": "{{roadmap.name}}",
							"description": "{{roadmap.description}}"
						}
					]
				},
				"strategicPlans": {
					"id": 2,
					"name":"Strategic Plans",
					"worksheetNameNice":"Strategic Plans",
					"worksheetName":"Strategic_Plans",
					"description":"The strategic plans contained in the Roadmap",
					"heading":[
						{"col":"B", "name":"Roadmap"}, 
						{"col":"C", "name":"Name"},
						{"col":"D", "name":"Description"},
						{"col":"E", "name":"StartDate"},
						{"col":"F", "name":"EndDate"}
					],
					"data": [
						{{#each strategicPlans}}
							{{#unless @first}},{{/unless}}
							{
								"row": {{add @index 8 0}},
								"roadmap": "{{../roadmap.name}}",
								"name": "{{name}}",
								"description": "{{description}}",
								"startdate": "{{excelStartDate}}",
								"enddate": "{{excelEndDate}}"
							}
						{{/each}}
					]
				},
				"stratPlanObjectives": {
					"id": 3,
					"name":"Strategic Plan Objectives",
					"worksheetNameNice":"Strategic Plan Objectives",
					"worksheetName":"Strategic_Plan_Objectives",
					"description":"Maps Strategic Plans to the Objectives that they support",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"SupportedObjective"}
					],
					"data": []
				},
				"stratPlanDependencies": {
					"id": 4,
					"name":"Strategic Plan Dependencies",
					"worksheetNameNice":"Strategic Plan Dependencies",
					"worksheetName":"Strategic_Plan_Dependencies",
					"description":"Define the dependencies between Strategic Plans",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"DependsOnPlan"}
					],
					"data": []
				},
				"plannedAppChanges": {
					"id": 5,
					"name":"Application Planning Actions",
					"worksheetNameNice":"Application Planning Actions",
					"worksheetName":"Application_Planning_Actions",
					"description":"The changes that are planned to Applications",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedApplication"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedAppServiceChanges": {
					"id": 6,
					"name":"Application Service Planning Actions",
					"worksheetNameNice":"Application Service Planning Actions",
					"worksheetName":"Application_Service_Planning_Actions",
					"description":"The changes that are planned to Application Services",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedApplicationService"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedBusProcChanges": {
					"id": 7,
					"name":"Business Process Planning Actions",
					"worksheetNameNice":"Business Process Planning Actions",
					"worksheetName":"Business Process_Planning_Actions",
					"description":"The changes that are planned to Business Processes",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedBusinessProcess"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				},
				"plannedOrgChanges": {
					"id": 8,
					"name":"Organisation Planning Actions",
					"worksheetNameNice":"Organisation Planning Actions",
					"worksheetName":"Organisation_Planning_Actions",
					"description":"The changes that are planned to Organisations",
					"heading":[
						{"col":"B", "name":"StrategicPlan"}, 
						{"col":"C", "name":"ImpactedOrganisation"}, 
						{"col":"D", "name":"PlannedChange"}, 
						{"col":"E", "name":"ChangeRationale"}
					],
					"data": []
				}
			}
		</script>
		
		
		<!-- Handlebars template to render the roadmap data in excel format -->
		<script id="roadmap-excel-template" type="text/x-handlebars-template">
			<?mso-application progid="Excel.Sheet"?>
			<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
			 xmlns:o="urn:schemas-microsoft-com:office:office"
			 xmlns:x="urn:schemas-microsoft-com:office:excel"
			 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
			 xmlns:html="http://www.w3.org/TR/REC-html40">
			 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
			  <Author>Essential Strategy Planner</Author>
			  <LastAuthor>Essential Strategy Planner</LastAuthor>
			  <Created>2018-11-26T17:58:06Z</Created>
			  <LastSaved>2018-11-26T23:22:52Z</LastSaved>
			  <Version>1.00</Version>
			 </DocumentProperties>
			 <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
			  <AllowPNG/>
			 </OfficeDocumentSettings>
			 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
			  <WindowHeight>15540</WindowHeight>
			  <WindowWidth>26840</WindowWidth>
			  <WindowTopX>1580</WindowTopX>
			  <WindowTopY>1960</WindowTopY>
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
			  <Style ss:ID="s62">
			   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
			  </Style>
			  <Style ss:ID="s63">
			   <Alignment ss:Vertical="Top"/>
			   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="22" ss:Color="#000000"
			    ss:Bold="1"/>
			  </Style>
			  <Style ss:ID="s64">
			   <Alignment ss:Vertical="Top"/>
			  </Style>
			  <Style ss:ID="s65">
			   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
			   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
			   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
			  </Style>
			  <Style ss:ID="s66">
			   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
			   <Borders>
			    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			   </Borders>
			  </Style>
			  <Style ss:ID="s67">
			   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
			  </Style>
			  <Style ss:ID="s68">
			   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
			   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#FFFFFF"/>
			   <Interior ss:Color="#4472C4" ss:Pattern="Solid"/>
			  </Style>
			  <Style ss:ID="s69">
			   <Alignment ss:Vertical="Top" ss:WrapText="1"/>
			   <Borders>
			    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			   </Borders>
			  </Style>
			  <Style ss:ID="s70">
			   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
			   <Borders>
			    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			   </Borders>
			  </Style>
			  <Style ss:ID="s71">
			   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:WrapText="1"/>
			   <Borders>
			    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
			    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
			   </Borders>
			  </Style>
			 </Styles>
			 <Worksheet ss:Name="Roadmap">
			  <Table ss:ExpandedColumnCount="4" ss:ExpandedRowCount="9" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="48"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="286"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="363"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Roadmap</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The roadmap to be created</Data></Cell>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">ID</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Roadmap Name</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Description</Data></Cell>
			   	<Cell ss:StyleID="s65"><Data ss:Type="String">Business Model</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			   <Row ss:AutoFitHeight="0" ss:Height="17">
			    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{roadmap.extId}}</Data></Cell>
			    <Cell ss:StyleID="s66"><Data ss:Type="String">{{roadmap.name}}</Data></Cell>
			    <Cell ss:StyleID="s66"><Data ss:Type="String">{{roadmap.description}}</Data></Cell>
			   	<Cell ss:StyleID="s66"><Data ss:Type="String">{{roadmap.businessModel.name}}</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="17">
			    <Cell ss:Index="2" ss:StyleID="s66"/>
			    <Cell ss:StyleID="s66"/>
			    <Cell ss:StyleID="s66"/>
			   	<Cell ss:StyleID="s66"/>
			   </Row>
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
			 </Worksheet>
			 <Worksheet ss:Name="Strategic Plans">
			  <Table ss:ExpandedColumnCount="7" x:FullColumns="1"
			   ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16" x:FullRows="1">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{stratPlanRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="33"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="140"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="259"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="322"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="93"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="101"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Strategic Plans</Data></Cell>
			    <Cell ss:StyleID="s63"/>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The strategic plans contained in the Roadmap</Data></Cell>
			    <Cell ss:StyleID="s64"/>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">ID</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Roadmap</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Strategic Plan Name</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Description</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">Start Date</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">End Date</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			   {{#each strategicPlans}}
				   <Row ss:AutoFitHeight="0" ss:Height="17">
				    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{extId}}</Data></Cell>
				    <Cell ss:StyleID="s66"><Data ss:Type="String">{{../roadmap.name}}</Data></Cell>
				    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
				    <Cell ss:StyleID="s69"><Data ss:Type="String">{{description}}</Data></Cell>
				    <Cell ss:StyleID="s70"><Data ss:Type="String">{{excelStartDate}}</Data></Cell>
				    <Cell ss:StyleID="s70"><Data ss:Type="String">{{excelEndDate}}</Data></Cell>
				   </Row>
			   {{/each}}
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
			     <ActiveCol>2</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="Strat Plan Objectives">
			  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{objRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="336"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="565"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Strategic Plan Objectives</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Maps Strategic Plans to the Objectives that they support</Data></Cell>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Strategic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Supported Objective</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			  	{{#each strategicPlans}}
			  		{{#each objectives}}
					   <Row ss:AutoFitHeight="0" ss:Height="17">
					    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{../name}}</Data></Cell>
					    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
					   </Row>
			  		{{/each}}
			  	{{/each}}
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
			     <ActiveCol>1</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="Strat Plan Dependencies">
			  <Table ss:ExpandedColumnCount="3" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{stratPlanDepsRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="336"
			    ss:Span="1"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Strategic Plan Dependencies</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">Define the dependencies between Strategic Plans</Data></Cell>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Strategic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Depends on Plan</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			  	{{#each planDeps}}
				   <Row ss:AutoFitHeight="0" ss:Height="17">
				    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{plan}}</Data></Cell>
				    <Cell ss:StyleID="s66"><Data ss:Type="String">{{dependsOnPlan}}</Data></Cell>
				   </Row>
			  	{{/each}}
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
			     <ActiveCol>1</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="App Planning Actions">
			  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{appsRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="207"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="335"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="141"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="322"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Application Planning Actions</Data></Cell>
			    <Cell ss:StyleID="s63"/>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The changes that are planned to Applications</Data></Cell>
			    <Cell ss:StyleID="s64"/>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Stratgic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Impacted Application</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">Planned Change</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Change Rationale</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			  	{{#each strategicPlans}}
			  		{{#each applications}}
					   <Row ss:AutoFitHeight="0" ss:Height="17">
					    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{../name}}</Data></Cell>
					    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
					    <Cell ss:StyleID="s71"><Data ss:Type="String">{{planningAction.name}}</Data></Cell>
					    <Cell ss:StyleID="s69"><Data ss:Type="String">{{planningNotes}}</Data></Cell>
					   </Row>
			  		{{/each}}
			  	{{/each}}
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
			     <ActiveCol>1</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="App Svc Planning Actions">
			  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{appSvcRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="207"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="335"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="141"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="322"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Application Service Planning Actions</Data></Cell>
			    <Cell ss:StyleID="s63"/>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The changes that are planned to Application Services</Data></Cell>
			    <Cell ss:StyleID="s64"/>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Stratgic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Impacted Application Service</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">Planned Change</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Change Rationale</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			   {{#each strategicPlans}}
			  		{{#each appServices}}
					   <Row ss:AutoFitHeight="0" ss:Height="17">
					    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{../name}}</Data></Cell>
					    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
					    <Cell ss:StyleID="s71"><Data ss:Type="String">{{planningAction.name}}</Data></Cell>
					    <Cell ss:StyleID="s69"><Data ss:Type="String">{{planningNotes}}</Data></Cell>
					   </Row>
			  		{{/each}}
			  	{{/each}}
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
			     <ActiveCol>1</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="Bus Proc Planning Actions">
			  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{busProcRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="207"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="335"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="141"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="322"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Business Process Planning Actions</Data></Cell>
			    <Cell ss:StyleID="s63"/>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The changes that are planned to Business Processes</Data></Cell>
			    <Cell ss:StyleID="s64"/>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Stratgic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Impacted Business Process</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">Planned Change</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Change Rationale</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			   {{#each strategicPlans}}
			  		{{#each busProcesses}}
					   <Row ss:AutoFitHeight="0" ss:Height="17">
					    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{../name}}</Data></Cell>
					    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
					    <Cell ss:StyleID="s71"><Data ss:Type="String">{{planningAction.name}}</Data></Cell>
					    <Cell ss:StyleID="s69"><Data ss:Type="String">{{planningNotes}}</Data></Cell>
					   </Row>
			  		{{/each}}
			  	{{/each}}
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
			     <ActiveCol>1</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			 <Worksheet ss:Name="Org Planning Actions">
			  <Table ss:ExpandedColumnCount="5" x:FullColumns="1"
			   x:FullRows="1" ss:StyleID="s62" ss:DefaultColumnWidth="65"
			   ss:DefaultRowHeight="16">
			  	<xsl:attribute name="ss:ExpandedRowCount">{{orgRowCount}}</xsl:attribute>
			   <Column ss:Index="2" ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="207"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="335"/>
			   <Column ss:StyleID="s67" ss:AutoFitWidth="0" ss:Width="141"/>
			   <Column ss:StyleID="s62" ss:AutoFitWidth="0" ss:Width="322"/>
			   <Row ss:AutoFitHeight="0"/>
			   <Row ss:AutoFitHeight="0" ss:Height="29">
			    <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Organisation Planning Actions</Data></Cell>
			    <Cell ss:StyleID="s63"/>
			   </Row>
			   <Row ss:AutoFitHeight="0">
			    <Cell ss:Index="2" ss:StyleID="s64"><Data ss:Type="String">The changes that are planned to Organisations</Data></Cell>
			    <Cell ss:StyleID="s64"/>
			   </Row>
			   <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17"/>
			   <Row ss:AutoFitHeight="0" ss:Height="20">
			    <Cell ss:Index="2" ss:StyleID="s65"><Data ss:Type="String">Stratgic Plan</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Impacted Organisation</Data></Cell>
			    <Cell ss:StyleID="s68"><Data ss:Type="String">Planned Change</Data></Cell>
			    <Cell ss:StyleID="s65"><Data ss:Type="String">Change Rationale</Data></Cell>
			   </Row>
			   <Row ss:AutoFitHeight="0" ss:Height="9"/>
			   {{#each strategicPlans}}
			  		{{#each organisations}}
					   <Row ss:AutoFitHeight="0" ss:Height="17">
					    <Cell ss:Index="2" ss:StyleID="s66"><Data ss:Type="String">{{../name}}</Data></Cell>
					    <Cell ss:StyleID="s66"><Data ss:Type="String">{{name}}</Data></Cell>
					    <Cell ss:StyleID="s71"><Data ss:Type="String">{{planningAction.name}}</Data></Cell>
					    <Cell ss:StyleID="s69"><Data ss:Type="String">{{planningNotes}}</Data></Cell>
					   </Row>
			  		{{/each}}
			  	{{/each}}
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
			     <ActiveRow>18</ActiveRow>
			     <ActiveCol>4</ActiveCol>
			    </Pane>
			   </Panes>
			   <ProtectObjects>False</ProtectObjects>
			   <ProtectScenarios>False</ProtectScenarios>
			  </WorksheetOptions>
			 </Worksheet>
			</Workbook>
		</script>
		
	</xsl:template>
	
	
	
</xsl:stylesheet>
