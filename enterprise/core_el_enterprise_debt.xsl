<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_handlebars_functions.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
    <xsl:param name="viewScopeTermIds"/>
    <xsl:variable name="issues" select="/node()/simple_instance[type='Issue']"/>
	<xsl:key name="issuesByType" match="$issues" use="own_slot_value[slot_reference='strategic_requirement_type']/value"/>
    <xsl:key name="issueCat" match="/node()/simple_instance[type='Strategic_Requirement_Category']" use="own_slot_value[slot_reference='sr_category_subtypes']/value"/>
	<xsl:key name="issueType" match="/node()/simple_instance[type='Strategic_Requirement_Type']" use="name"/>
    <xsl:key name="elements" match="/node()/simple_instance[supertype='EA_Class']" use="name"/>
    <xsl:variable name="catTypes" select="key('issueType', $issues/own_slot_value[slot_reference='strategic_requirement_type']/value)"/>
	<xsl:variable name="cats" select="key('issueCat', $catTypes/name)"/>
    <xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
    <xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
    <xsl:variable name="impactData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: Business Scenario Impact API']"></xsl:variable>
	<xsl:variable name="processToAppData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Physical Process to Apps via Services']"></xsl:variable>
	<xsl:variable name="appToTechData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications to Technology']"></xsl:variable>
	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Applications']"></xsl:variable>
	<xsl:variable name="scopeData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core View API: Business Scenario Scope API']"></xsl:variable>
	<xsl:variable name="lifecycleData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Technology Lifecycles']"></xsl:variable>
	
	
    <xsl:template match="knowledge_base">
	<xsl:variable name="apiImpacts">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$impactData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="apiScope">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$scopeData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="apiLife">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$lifecycleData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="apiProcess">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$processToAppData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="apiAppsTech">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$appToTechData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="apiApps">
		<xsl:call-template name="GetViewerAPIPath">
			<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
    <xsl:call-template name="docType"/>
           
<html>
	<head>
		<xsl:call-template name="commonHeadContent"/>
		<xsl:for-each select="$linkClasses">
			<xsl:call-template name="RenderEditorInstanceLinkJavascript">
				<xsl:with-param name="instanceClassName" select="current()"/>
				<xsl:with-param name="targetMenu" select="()"/>
				<xsl:with-param name="newWindow" select="true()"/>
			</xsl:call-template>
		</xsl:for-each>
		<title><xsl:value-of select="eas:i18n('Technical Debt Dashboard')"/></title> 
		<script src="js/chartjs/chart_v3.9.1.min.js"/>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
		<script src="js/pptxgenjs/dist/pptxgen.bundle.js"></script>

		<style>
			
			.handle {
				position: absolute;
				right: -25px;
				top: 30%;
				width: 25px;
				height: 25px;
				background: #0e0e0e;
				color:white;
				text-align: center; 
				cursor: pointer;
				border-radius: 0 10px 10px 0;
				font-weight: bold;
				font-size:1.3em;
			}
			.content {
				margin-left: 20px;
				width: calc(100% - 270px);
				display: flex;
				flex-direction: column;
				gap: 10px;
			}
			.debt-item {
				padding: 5px;
				border: 1px solid #ddd;
				font-size:0.9em;
				margin-bottom: 3px;
				cursor: pointer;
				background: #fff;
			}

			.requirement-item{
				padding: 5px;
				border: 1px solid #ddd;
				border-left: 3px solid red;
				font-size:1em;
				width: 250px;
				margin-bottom: 3px;
				cursor: pointer;
				background: #fff;
				opacity: 0; /* Hidden initially */
				transform: translateX(-100%);
				transition: opacity 0.5s ease-out, transform 0.5s ease-out;
				position: relative;
			}
			
			.requirement-item.animate {
				animation: fadeInSummary 0.5s ease-out forwards;
			}

			@keyframes slideInFromLeft {
				from {
					opacity: 0;
					transform: translateX(-100%);
				}
				to {
					opacity: 1;
					transform: translateX(0);
				}
			} 

			.impact-item.animate {
				animation: fadeInSummary 0.5s ease-out forwards;
			}


			.impact-item{
				padding: 5px;
				border: 1px solid #ddd;
				border-left: 3px solid rgb(56, 144, 179);
				font-size:1em;
				width: 350px;
				position:relative;
				margin-bottom: 3px;
				cursor: pointer;
				background: #fff;
				opacity: 0; /* Hidden initially */
				transform: translateX(-100%);
				transition: opacity 0.5s ease-out, transform 0.5s ease-out;
				z-index:1;
			}
			.impactType{
				position:absolute;
				right: 2px;
				bottom:2px;
			//	font-size:0.8em;
			//	background-color:#7f8c8d;
			//color: #ffffff;
				padding:3px;
				border-radius:5px;
			}

			.summaryPanel{
				width: 220px;
				padding: 3px; 
				left: 30px;
				border: 1px solid rgba(255, 255, 255, 0.3);
				background: rgba(255, 255, 255, 0.2);
				backdrop-filter: blur(10px);
				box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
				display: none;
				border-radius: 5px;
			}
			.summaryBox{
				font-size:0.9em;
			}
			.scope{
				font-size:0.9em;
				display:inline-block;
			}
		
			.statistics{
				margin-left:50px
			}
			.chart { margin-top: 20px; display: flex; justify-content: space-around; flex-wrap: wrap; }
			.chart-container-20 { width: 20%; margin-bottom: 20px; display: flex; align-items: center; }
			.chart-container-35 { width: 35%; margin-bottom: 20px; display: flex; align-items: center; }
			.chart-container-40 { width: 40%; margin-bottom: 20px; display: flex; align-items: center; }
			.chart-container-50 { width: 50%; margin-bottom: 20px; display: flex; align-items: center; }
			.chart-container-text { width: 20%; margin-bottom: 20px; display: flex-wrap; align-items: center; padding-right: 25px}
			.legend { display: flex; flex-direction: column; margin-top: 10px; margin-left:10px; font-size:0.8em }
			.legend-item { display: flex; align-items: center; margin-bottom: 5px; }
			.legend-color { width: 15px; height: 15px; margin-right: 5px; }
			.chartBox{
				text-align: center;
			}
			.textInfo {
				border: 1pt solid #d3d3d3;
				padding: 2px;  /* Ensures proper layout */
				font-size:1em;
				margin-bottom:3px;
				font-size:1.1em;
				font-family: Helvetica Neue, Helvetica, Arial, Source Sans Pro, sans-serif;
			}

			.issueBox {
				display: inline-block;
				align-items: center;
				font-weight: bold;
				font-size: 1.2em;
				position: relative;
			}

			.issueCircle{
				content: "";
				display: inline-block;
				width: 10px;
				height: 10px;
				background-color: red;
				border-radius: 50%;
				right: -15px;
				top: 5px;
				animation: flash 1.5s infinite alternate;
			}
	

			@keyframes flash {
				0% { opacity: 1; }
				50% { opacity: 0.3; }
				100% { opacity: 1; }
			}

			.debt-summary {
				padding: 10px;
				border: 1px solid #ccc;
				border-radius: 10px;
				background: #fff;
				max-width: 420px;
				box-shadow: 3px 3px 15px rgba(0, 0, 0, 0.2);
				margin: 20px auto;
				text-align: left;
				opacity: 0;
				transform: translateY(20px);
				animation: fadeInSummary 0.6s ease-out forwards;
			}
			
			.debt-name {
				font-size: 1.1em;
				color: #2c3e50; 
			}
			
			.debt-description {
				font-size: 1em;
				color: #34495e;
				margin: 5px 0;
			}

			.debt-date, .debt-status {
				font-size: 0.95em;
				color: #7f8c8d;
				margin: 5px 0;
			}
			.debt-date i, .debt-status i {
				margin-right: 5px;
				color: #e67e22;
			}

			@keyframes fadeInSummary {
				from {
					opacity: 0;
					transform: translateY(20px);
				}
				to {
					opacity: 1;
					transform: translateY(0);
				}
			}
			.infoBox{
				padding-left:15px;
				border-left: 3px solid #6b2d2d
			}
			.caretButton{
				position: absolute;
				bottom:-2px;
				right:2px;
			}
			.caretButton.red {
				color: red;
			}
				.programme-box {
stroke: #D97333;
stroke-width: 3;
fill: none;
}
.cap-box{
stroke: #3b3b3b;
stroke-width: 1;
fill: none;
rx:6;
}
.cap-text{
font-size: 20px;
font-weight: bold;
fill: rgb(6, 6, 6);
font-family: Arial, sans-serif;
}
.depcap-text{
font-size: 10px;
font-weight: bold;
fill: rgb(6, 6, 6);
font-family: Arial, sans-serif;
}
.project {
fill: #4A4A4A;
stroke: rgb(255, 255, 255);
stroke-width: 1;
rx: 5;
}

.projectText {
font-family: Arial, sans-serif;
font-size: 8px;
fill: rgb(31, 31, 31);
}
.deptext {
font-size: 10px;
font-weight: bold;
fill: rgb(6, 6, 6);
font-family: Arial, sans-serif;
}
.timeline-text {
fill: black;
font-weight: bold;
font-family: Arial, sans-serif;
}
.quarter-text {
fill: #D97333;
font-size: 10px;
}
#valueKey {
flex: 1; margin-left: 20px; overflow: visible;
font-size:0.8em;
}
.debtData{
display:none;
}
.impact-columns {
    display: flex;
    gap: 20px; /* space between columns */
	justify-content: flex-start;
	
  }
  .impact-column {
    flex: 1; /* Each column takes an equal share of the available width */
  }

#debtTypeSelect, #debtItemSelect{display:none;}

.refModel-blob {
	background-color:#d5cbd6 !important;
	position:relative;
}
.refModel-l0-outer{
	margin:2px;
	background-color: #ffffff !important;
}
.capModel{
	padding:3px;
}

.root-nav-tabs > li > a {
		font-size: 12px;             /* Smaller font size */
		white-space: normal;         /* Allow wrapping */
		word-wrap: break-word;       /* Break long words */
		max-width: 150px;            /* Optional: constrain width */
		text-align: center;          /* Optional: nicer alignment */
	}

.blob-highlight{
	background-color: #008080 !important;
	color:#ffffff !important;

}	
.responses-section{
	display:none;
}

.refModel-popup {
    background: #fff;
    border: 1px solid #ccc;
    padding: 10px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    font-size: 12px;
}
.popup-table {
    width: 300px;
    border-collapse: collapse;
}
.popup-table th {background-color:#008080; color:#ffffff;}
.popup-table th,
.popup-table td {
    border: 1px solid #ddd;
    padding: 4px 8px;
    text-align: left; 
	font-size:0.95em;
}

.popup-table td {color:#000000;}

.hiddenDiv {
    display: none;
}
.program-label {
	font-size:0.8em; 
}
 .item-name{ 
	font-weight:bold;
	font-size:0.9em;
}

.programme-group text {
    transition: opacity 0.3s;
  }

  .dimmed text {
    opacity: 0.1;
  }

  .programme-group.highlight text {
    opacity: 1 !important;
  }

.faExport{
	color: #2975cb;
}
.search-input-wrapper {
    position: relative;
  }

  .search-input-wrapper input {
    padding-left: 2em;
  }

  .search-input-wrapper i {
    position: absolute;
    left: 6px;
    top: 50%;
    transform: translateY(-50%);
    color: #888;
    pointer-events: none;
  }

.eas-logo-spinner {
    display: flex; 
    justify-content: center; 
}
#editor-spinner {
    height: 100vh; 
    width: 100vw; 
    position: fixed; 
    top: 0; 
    left:0; 
    z-index:999999; 
    background-color: hsla(255,100%,100%,0.75); 
    text-align: center; 
}
#editor-spinner-text {
    width: 100vw; 
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

#trendImplsContainer {
  max-height: 400px;
  overflow-y: auto;
}

#trendImplsTableContainer {
  max-height: 600px;
  overflow-y: auto;
}
.chartButton{
	top: 65px;
    position: absolute;
    right: 10px;
	text-transform: uppercase;
}
.typeName{
	text-transform: uppercase;
    font-size: 0.7em;
    bottom: 1px;
    position: absolute;
    right: 18px;
    background-color: #c388da;
    padding-left: 3px;
    padding-right: 3px;
    color: white;
    border-radius: 0px 6px 6px 0px;
}

}
		</style>
	</head>
	<body>
              <xsl:call-template name="Heading"/>
              <div data-spy="scroll" data-target="#navbar-side" id="pagetop">	
	<!--ADD THE CONTENT-->
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-12">
				<div class="page-header">
					<h1>
						<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>:</span><xsl:text> </xsl:text>
						<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Enterprise Debt Analysis')"/></span>
					</h1> 
				</div>
			</div>
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
		</div>
		<div class="pull-right chartButton"><button class="btn btn-default btn-sm" id="home-button"><small><xsl:value-of select="eas:i18n('Show/Hide Summary')"/> <xsl:text> </xsl:text></small><i class="fa fa-pie-chart" style="color:gray"></i></button></div>
		<div id="leftPane">
			<div id="selectedScenarioTitlePanel" class="panel panel-default hiddenDiv">
				<div class="panel-body" id="selectedScenarioTitlePanel">
					<div id="selectedScenarioTitle" class="ess-section-title bottom-10" style="font-weight:700"/>					
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Enterprise Debt')"/></div>
						<div class="textInfo">
							<xsl:value-of select="eas:i18n('Total Issues')"/>:  <div class="issueBox"><span id="issueCount"/></div>
						</div>
						<div class="textInfo">
							<xsl:value-of select="eas:i18n('Unplanned Issues')"/>: 
							<div class="issueCircle"></div>
							<div class="issueBox"><span id="unplannedIssueCount"/></div>
							
						</div>
					</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body">
					<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Select Debt')"/></div> 
						<label for="catType"><xsl:value-of select="eas:i18n('Select Category')"/>:</label>
						<select id="catType" class="form-control"><option><xsl:value-of select="eas:i18n('Choose')"/></option></select><br/>
						<span id="debtTypeSelect">
							<label for="debtType"><xsl:value-of select="eas:i18n('Select Type')"/>:</label>
							<select id="debtType" class="form-control"></select>
						</span>
						<span id="debtItemSelect"> 
							<label for="debtSelect"><xsl:value-of select="eas:i18n('Select Debt')"/>:</label>
							<select id="debtSelect" class="form-control"></select>
							 
						</span>
					</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-body responses-section">
					<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Navigation')"/><xsl:text> </xsl:text></div>
					<nav id="navbar-side">
						<ul class="nav nav-pills nav-stacked">
							<li class="active">
								<a href="#pagetop"><i class="fa fa-home"/><xsl:value-of select="eas:i18n('Back to Top')"/></a>
							</li>
							<li>
								<a href="#debt-responses"><i class="fa fa-file-text-o"/><xsl:value-of select="eas:i18n('Debt Summary')"/></a>
							</li>
							<li class="trend-selected-nav hiddenDiv">
								<a href="#scope-responses"><i class="fa fa-check"/><xsl:value-of select="eas:i18n('Debt Scope')"/></a>
							</li>
							<li class="trend-selected-nav hiddenDiv">
								<a href="#rootcause-responses"><i class="fa fa-hospital-o"/><xsl:value-of select="eas:i18n('Root Causes')"/></a>
							</li>
							<li class="trend-selected-nav hiddenDiv">
								<a href="#impacts-responses"><i class="fa fa-crosshairs"/><xsl:value-of select="eas:i18n('Debt Impacts')"/></a>
							</li>
							<li class="trend-selected-nav hiddenDiv">
								<a href="#cap_panel"><i class="fa fa-sitemap"/><xsl:value-of select="eas:i18n('Capability Panel')"/></a>
							</li>
						</ul>
					</nav>
				</div>
			</div>
		</div>
		<div id="rightPane">
			<div class="row">
				<div class="col-xs-6 mgmt-section">
					<div class="panel panel-default " id="chart1">
						<div class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Debt by Category')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row headerInfo">
								<div class="col-md-12">
									<div class="chart-wrapper" style="display: flex; align-items: center;">
										<!--<svg id="radar"></svg>-->
										<canvas id="categoryPieChart"  aria-hidden="true" style="flex-shrink: 0; display: block; box-sizing: border-box; height: 300px; width: 300px;" width="600" height="600"></canvas>
										 <div id="valueKey"/>
									</div>
								</div>
							
							</div>
						</div>
					</div>
				</div>
				<div class="col-xs-6 mgmt-section">
					<div class="panel panel-default " id="chart1">
						<div class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Debt by Category')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row headerInfo">
								<div class="col-md-12">
									<div class="chart-wrapper">
											<!--<svg id="radar"></svg>-->
										<canvas id="impactBarChart" width="425px"></canvas> 
									</div>
								</div>
								
							</div>
						</div>
					</div>
				</div>
				<div id="strat-trend-header" class="col-md-12 mgmt-section">
					<div class="panel panel-default" id="implications_section">
						<div id="trendImplsContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Debt Resolution Planning')"/></div>	
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row headerInfo">
								<div class="col-md-12">
									<label><xsl:value-of select="eas:i18n('Start Date')"/>:
										<input type="date" id="start-date" class="dateChange"/>
									</label>
									<label><xsl:value-of select="eas:i18n('End Date')"/>:
										<input type="date" id="end-date" class="dateChange"/>
									</label>
									 
									<div id="export-icons" style="text-align: right; margin-bottom: 10px;">
									<i class="fa fa-file-pdf-o faExport" id="export-pdf" style="cursor:pointer;" title="Export to PDF"/><xsl:text> </xsl:text>
									<i class="fa fa-file-powerpoint-o faExport" id="export-ppt" style="cursor:pointer;" title="Export to PowerPoint"/>	<xsl:text> </xsl:text>	
									<i class="fa fa-file-image-o faExport" id="export-svg" style="cursor:pointer;" title="Export to SVG"/> 

									</div>
								</div>
								<div class="col-md-12">
							  		<div id="timeline-container"></div>
							    </div>
							</div>
						</div>
					</div>
				</div>
				<div id="strat-trend-header" class="col-md-12 mgmt-section">
					<div class="panel panel-default" id="implications_section">
						<div id="trendImplsTableContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Debt Table')"/></div>	
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row headerInfo">
								<div class="col-md-12">
							  		<table id="debtTable-container" class="table table-striped table-condensed display nowrap" style="width:100%" aria-describedby="tableDescription" role="table">
									<caption id="tableDescription"><xsl:value-of select="eas:i18n('This table displays enterprise debt, their status, resolution plans, and related root causes.')"/></caption>
									<thead>
									<tr role="row">
										<th scope="col"><xsl:value-of select="eas:i18n('Name')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Status')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Required By')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Description')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Resolved By')"/></th>
										<th scope="col"><xsl:value-of select="eas:i18n('Root Causes')"/></th>
									</tr>
									</thead>
									<tbody></tbody>
									<tfoot>
										<tr>
										<th><xsl:value-of select="eas:i18n('Name')"/></th>
										<th><xsl:value-of select="eas:i18n('Status')"/></th>
										<th><xsl:value-of select="eas:i18n('Required By')"/></th>
										<th><xsl:value-of select="eas:i18n('Description')"/></th>
										<th><xsl:value-of select="eas:i18n('Resolved By')"/></th>
										<th><xsl:value-of select="eas:i18n('Root Causes')"/></th>
									</tr>
									</tfoot>
								</table>
							    </div>
							</div>
						</div>
					</div>
				</div>
				<div id="debt-responses" class="col-md-12 responses-section">
					<div class="panel panel-default" id="responses_section">
						<div id="trendResponsesContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Debt Summary')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row">
								<div class="col-md-12">
									<div class="summaryBox"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="scope-responses" class="col-md-5 responses-section">
					<div class="panel panel-default" id="responses_section">
						<div id="trendResponsesContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Scope')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row">
								<div class="col-md-12">
									<div class="scope"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="rootcause-responses" class="col-md-7 responses-section">
					<div class="panel panel-default" id="responses_section">
						<div id="trendResponsesContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Root Cause')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row">
								<div class="col-md-12">
									<div class="rootCause"></div>
								</div>
							</div>	
						</div>
					</div>
				</div> 
				<div id="impacts-responses" class="col-md-12 responses-section">
					<div class="panel panel-default" id="responses_section">
						<div id="trendResponsesContainer" class="panel-body">
							<div class="ess-section-title bottom-10"><xsl:value-of select="eas:i18n('Secondary Impacts')"/></div>
							<button class="toggle-button" style="position: absolute; top: 10px; right: 10px; border: none; background: transparent; cursor: pointer;" aria-expanded="true">
								<i class="fa fa-chevron-up" aria-label="Expand Section"></i>
							</button>
							<div class="row">
								<div class="col-md-12">
									<div class="impacts"></div>
								</div>
							</div>		
						</div>
					</div>
				</div>
 
				<div class="col-md-12 responses-section" id="cap_panel">
					<div class="panel panel-default detail-section-panel">
					<div id="business_context_section" class="detail-section active">
						<div class="panel-body">
							<!-- Bootstrap Tabs -->
							<ul class="nav nav-tabs">
								<li class="active">
								<a href="#business" data-toggle="tab"><xsl:value-of select="eas:i18n('Business')"/></a>
								</li>
								<li>
								<a href="#application" data-toggle="tab"><xsl:value-of select="eas:i18n('Application')"/></a>
								</li>
								<li>
								<a href="#technology" data-toggle="tab"><xsl:value-of select="eas:i18n('Technology')"/></a>
								</li>
							</ul>

							<!-- Tab Panes -->
							<div class="tab-content">
								<div class="ess-section-title top-10 bottom-10"><xsl:value-of select="eas:i18n('Capability Model Impact')"/></div>
								<!-- Business Tab -->
								<div class="tab-pane fade in active" id="business">
							
								<div class="row">
									<div id="bcmPanel" class="capModel"></div>
								</div>
								</div>

								<!-- Application Tab -->
								<div class="tab-pane fade" id="application">
									<div id="armPanel" class="capModel"></div>
								</div>

								<!-- Technology Tab -->
								<div class="tab-pane fade" id="technology">
									<div id="trmPanel" class="capModel"></div>
								</div>
							</div>
							</div>

					</div>
					</div>
				</div>
			</div>
		</div>
		
		<!--Setup Closing Tags-->
	</div>
	
	<!-- HANDLEBARS TEMPLATES -->
	
	<script id="listof-template" type="text/x-handlebars-template"> 
		{{#if this}}
		{{#each this}} 
			<span class="label label-default">{{this.name}}</span>
		{{/each}}
		{{else}}
		<span class="label label-danger"><xsl:value-of select="eas:i18n('None Identified')"/></span>
		{{/if}}
	</script>
	
	<!-- Handlebars template for rendering the list of Implications for impacts -->
	<script id="impact-impl-list-template" type="text/x-handlebars-template">
		<li class="dropdown-header ess-dropdown-header"><xsl:value-of select="eas:i18n('Update direct impact of')"/>":</li>
		{{#each this}}
			<li>
				<a class="select-impact-impl" >{{name}}</a>
			</li>
		{{/each}}
	</script>
  
	<!-- Handlebars template for rendering impact badges -->
	<script id="impact-badge-template" type="text/x-handlebars-template">
		<span class="change-badge">{{label}}<i class="left-5 fa fa-caret-down"/></span>
	</script>
	
	
	<!-- handlebars template for rendering a dashboard section -->
	<script id="dashboard-summary-template" type="text/x-handlebars-template">
		{{#each this}}
			<div class="col-md-4">
				<div class="panel panel-default dashMatchHeight1 dashbox" id="{{id}}">
					<div class="panel-body">
						<div class="{{impactColour}} ess-section-title bottom-10">{{label}}</div>
						<div class="xxsmall pos-top-right-10" title="Impacts: {{positiveCount}} Positive and {{negativeCount}} Negative" data-toggle="tooltip" data-placement="top">
							<div class="dashboard-positive-impact textColourGreen" >
								<i class="fa fa-caret-up"/>
								<span>{{positiveCount}}</span>
							</div>
							<div class="dashboard-negative-impact textColourRed">
								<i class="fa fa-caret-down"/>
								<span>{{negativeCount}}</span>
							</div>
						</div>
						<div class="row {{impactColour}}">
							<div class="col-md-3">
								<i class="dashboard-icon {{icon}}"/>
							</div>
							<div class="col-md-9">
								{{#each breakdown}}
									<div><span class="fontBlack large right-5">{{count}}</span><span class="fontLight uppercase">{{sectionLabel}}</span></div>
								{{/each}}
							</div>
						</div>
					</div>
				</div>
			</div>
		{{/each}}
	</script>
	
	
	
	<!-- Handlebars template for rendering Business Environment Categories/Factors -->
	<script id="bus-env-factor-tab-template" type="text/x-handlebars-template">
		{{#each this}}
			<li role="presentation" class="{{#if @first}}active{{/if}}">
	            <a  data-toggle="tab" href="#busenv{{@index}}" role="tab" >
	                <div class="impact-tab-label">
	                	<i class="fa {{icon}} right-5" aria-hidden="true"/>
	                	<span>{{name}}</span>
	                </div>
	                <div class="xxsmall inline-block" title="Impacts: 1 Positive and 2 Negative" data-toggle="tooltip" data-placement="top">
	                    <div class="dashboard-positive-impact textColourGreen" >
	                        <i class="fa fa-caret-up"/>
	                        <span  class="tab-impact-count bef-positive-count">0</span>
	                    </div>
	                    <div class="dashboard-negative-impact textColourRed">
	                        <i class="fa fa-caret-down"/>
	                        <span   class="tab-impact-count bef-negative-count">0</span>
	                    </div>
	                </div>
	            </a>
	        </li>
		{{/each}}
	</script>
	
  
	 
	<script id="generic-impact-list-template" type="text/x-handlebars-template">
		{{#each footprintValues}}
			<div id="{{id}}" class="refModel-blob" >
				<div class="blob-title">{{{essRenderInstanceLink this}}}</div>
				<!--<div  class="edit-{{../footprintType}}-impact-btn refModel-blob-impact">
					<i class="fa fa-bullseye text-primary"/>
				</div>-->
				<div class="refModel-blob-info">
					<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
				</div>
				<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
				<div  class="refModel-dependency-badge hiddenDiv">
					<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
				</div>
				<div eas-impact="eaImpacts" eas-data="{{../dataType}}"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown">
					<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
				</div>
                <ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
				<div  class="refModel-conflict-badge hiddenDiv">
					<span  class="conflict-badge"><i class="fa fa-warning"/></span>
				</div>
			</div>
		{{/each}}
	</script>
 
	
	<script id="bcm-template" type="text/x-handlebars-template"> 
		{{#each childBusCaps}}					
			<div class="row">
				<div class="col-xs-12">
					<div class="refModel-l0-outer">
						<div class="refModel-l0-title fontBlack large">
							{{this.name}}
						</div>
						{{#childBusCaps}}
							<!--<a href="#" class="text-default">-->
								<div id="{{id}}" class="refModel-blob top-10" ><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<!--<div  class="edit-buscap-impact-btn refModel-blob-impact">
										<i class="fa fa-bullseye text-primary"/>
									</div>-->
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="busCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
			                		<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>		
								-->							
									<div  class="refModel-conflict-badge hiddenDiv">
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>
							<!--</a>-->
						{{/childBusCaps}}
						<div class="clearfix"/>
					</div>
					{{#unless @last}}
						<div class="clearfix bottom-10"/>
					{{/unless}}
				</div>
			</div>
		{{/each}}				
	</script>
	
	<script id="irm-template" type="text/x-handlebars-template">
		<h3><xsl:value-of select="eas:i18n('Information')"/></h3>
		{{#each this}}					
			<div class="row">
				<div class="col-xs-12">
					<div class="refModel-l0-outer">
						<div class="refModel-l0-title fontBlack large">
							{{{essRenderInstanceLink this}}}
						</div>
						{{#infoConcepts}}
							<div id="{{id}}_blob"  class="refModel-blob top-10">
								<div class="refModel-blob-title">
									{{{essRenderInstanceLink this}}}
								</div>
								<!--<div  class="edit-infoconcept-impact-btn refModel-blob-impact">
									<i class="fa fa-bullseye text-primary"/>
								</div>-->
								<div   class="refModel-blob-info">
									<i  class="fa fa-info-circle text-white"/>											
								</div>
								<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
								<div  class="refModel-dependency-badge hiddenDiv">
									<span  class="dependency-badge"/>
								</div>
								<div eas-impact="eaImpacts" eas-data="infoConcepts"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown">
									<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
								</div>
		                		<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
								<div  class="refModel-conflict-badge hiddenDiv">
									<span  class="conflict-badge"><i class="fa fa-warning"/></span>
								</div>
							</div>
						{{/infoConcepts}}
						<div class="clearfix"/>
					</div>
					{{#unless @last}}
						<div class="clearfix bottom-10"/>
					{{/unless}}
				</div>
			</div>
		{{/each}}				
	</script>
	
	
	<script id="arm-template" type="text/x-handlebars-template">
		<div class="col-xs-4 col-md-3 col-lg-2" id="refLeftCol">
			{{#each left}}
				<div class="row bottom-15">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeight1">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childAppCaps}}
								<div id="{{id}}_blob" class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									
									<div class="refModel-blob-info" ><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv">
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
								<!--
									<div eas-impact="eaImpacts" eas-data="appCaps" class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small" ><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>

								-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								 
								</div>											
							{{/childAppCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
			{{/each}}
		</div>
	 
		<div class="col-xs-4 col-md-6 col-lg-8 matchHeight1" id="refCenterCol">
			{{#each middle}}							
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childAppCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white" ><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv">
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="appCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small" ><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>											
							{{/childAppCaps}}
							<div class="clearfix"/>
						</div>
						{{#unless @last}}
							<div class="clearfix bottom-10"/>
						{{/unless}}
					</div>
				</div>
			{{/each}}
		</div>
		<div class="col-xs-4 col-md-3 col-lg-2" id="refRightCol">
			{{#each right}}
				<div class="row bottom-15">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeight1">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childAppCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white" ><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="appCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>											
							{{/childAppCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
			{{/each}}
		</div>
		 
	</script>
	
 
	
	<script id="trm-template" type="text/x-handlebars-template">
		<h3 class="top-20"><xsl:value-of select="eas:i18n('Technology')"/></h3>
		<div class="col-xs-12">
			{{#each top}}
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeight2">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childTechCaps}}
								<div class="refModel-blob top-10"><xsl:attribute name="id">{{id}}_blob</xsl:attribute><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="techCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>								
							{{/childTechCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
				<div class="clearfix bottom-10"/>
			{{/each}}
		</div>
 
		<div class="col-xs-4 col-md-3 col-lg-2">
			{{#each left}}
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeightTRM">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childTechCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv">
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="techCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>				
							{{/childTechCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
			{{/each}}
		</div>
	 
		<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
			{{#each middle}}
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childTechCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv">
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="techCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>
							{{/childTechCaps}}
							<div class="clearfix"/>
						</div>
						{{#unless @last}}
							<div class="clearfix bottom-10"/>
						{{/unless}}
					</div>
				</div>
			{{/each}}
		</div>
	 
		<div class="col-xs-4 col-md-3 col-lg-2">
			{{#each right}}
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeightTRM">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childTechCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv">
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="techCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>				
							{{/childTechCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
			{{/each}}
		</div>
 
		<div class="col-xs-12">
			<div class="clearfix bottom-10"/>
			{{#each bottom}}
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer matchHeight2">
							<div class="refModel-l0-title fontBlack large">
								{{this.name}}
							</div>
							{{#childTechCaps}}
								<div id="{{id}}_blob"  class="refModel-blob top-10"><xsl:attribute name="eas-id-blob">{{id}}</xsl:attribute>
									<div class="refModel-blob-title">
										{{this.name}}
									</div>
									<div class="refModel-blob-info"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><xsl:attribute name="eas-info-id">{{id}}_info</xsl:attribute>
										<i class="fa fa-info-circle text-white"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></i>
									</div>
									<div class="refModel-popup hiddenDiv"><xsl:attribute name="id">{{id}}-popup</xsl:attribute>
										<div class="pop-up"><xsl:attribute name="id">{{id}}-popup-data</xsl:attribute></div>
									</div>
									<div  class="refModel-dependency-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="dependency-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></span>
									</div>
									<!--
									<div eas-impact="eaImpacts" eas-data="techCaps"  class="refModel-top-badge no-impact-badge dropdown-toggle" data-toggle="dropdown"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span class="change-badge"><xsl:value-of select="eas:i18n('No Impact')"/><i class="left-5 fa fa-caret-down"/></span>
									</div>
									<ul class="impact-impl-list dropdown-menu dropdown-menu-top small"><xsl:attribute name="eas-id">{{id}}</xsl:attribute></ul>
									-->
									<div  class="refModel-conflict-badge hiddenDiv"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
										<span  class="conflict-badge"><xsl:attribute name="eas-id">{{id}}</xsl:attribute><i class="fa fa-warning"/></span>
									</div>
								</div>							
							{{/childTechCaps}}
							<div class="clearfix"/>
						</div>
					</div>
				</div>
			{{/each}}
		</div>
	</script>
	 
	
	<!-- *******************************************
		HANDLEBARS TEMPLATES FOR MODALS
		***********************************************-->
	
	
	<!-- Handlebars templates for a list of instances in a table cell -->
	<script id="instance-list-template" type="text/x-handlebars-template">
		<ul>
        {{#each this}}
            <li>{{{essRenderInstanceLink this}}}</li>
        {{/each}}
       	</ul>
    </script>
	
	<!-- Handlebars templates for modal table row select buttons -->
	<script id="add-item-template" type="text/x-handlebars-template">
		<button  class="add-item-btn btn btn-sm btn-primary pl_action_button"><xsl:value-of select="eas:i18n('Select')"/></button>
	</script>
	
	<!-- Handlebars templates for selected instances in modals -->
	<script id="selected-instance-template" type="text/x-handlebars-template">
		{{#each this}}
			<li class="bg-lightblue-100"><div class="relevant-item" >{{{essRenderInstanceLink this}}}</div><i  class="remove-item-btn fa fa-minus-circle"/></li>
		{{/each}}
	</script>
	
	
	<!-- Select Business Process Modal -->
	<div class="modal fade" id="geoScopeModal" tabindex="-1" role="dialog" aria-labelledby="geoScopeModalLabel">
		<div class="modal-dialog modal-xl" role="document">
			<div class="modal-content" id="geoScopeModalContent"/>						
		</div>
	</div>
	
	
	<!-- Select Business Process Modal -->
	<div class="modal fade" id="geoScopeModal" tabindex="-1" role="dialog" aria-labelledby="geoScopeModalLabel">
		<div class="modal-dialog modal-xl" role="document">
			<div class="modal-content" id="geoScopeModalContent"/>						
		</div>
	</div>
	
	
	
  
	
	
	<!-- SUPPORTING JS LIBRARIES -->
	
	<!-- Editor specific css and javascript -->
	<link href="editors/enterprise/business-scenario-analyser/core_business_scenario_analyser.css" rel="stylesheet" type="text/css"/>
	
	<!-- Year Picker UI component -->
	<link rel="stylesheet" href="js/yearpicker/yearpicker.css"/>
	<script type="text/javascript" src="js/yearpicker/yearpicker.js"/>
	
	<!-- Slider libraries and styles -->
	<script type="text/javascript" src="js/bootstrap-slider/bootstrap-slider.min.js"/>
	<link rel="stylesheet" href="js/bootstrap-slider/bootstrap-slider.min.css"/>
	
	
	<!-- essential api library -->
	<script type="text/javascript" src="common/js/core_common_api_functions.js"/>
	
  
	<!-- strategic trend radar library -->
	<!--<script type="text/javascript" src="enterprise/js/ess_strategic_trend_radar.js"></script>-->

	<!-- Slider UI component 
	<link rel="stylesheet" href="js/nouislider/nouislider.min.css"/>
	<script type="text/javascript" src="js/nouislider/nouislider.min.js"/>
	-->
	<!-- geo map library 
	<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
	<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
	<script src="js/jvectormap/jquery-jvectormap-world-mill.js" type="text/javascript"/>
	-->
	<!-- Searchable Select Box Libraries and Styles -->
	<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
	<link href="js/select2/css/select2-bootstrap.min.css" rel="stylesheet"/>
	<script src="js/select2/js/select2.full.min.js"/>

	<!-- Date formatting library 
	<script type="text/javascript" src="js/moment/moment.js"/>
	-->
	<!-- Add datatables libraries 
	<link rel="stylesheet" type="text/css" href="js/DataTables/1.13.8/datatables.min.css"></link>
	<link rel="stylesheet" type="text/css" href="js/DataTables/1.13.8/DataTables-1.13.8/css/dataTables.bootstrap.min.css"></link>
	<script type="text/javascript" src="js/DataTables/1.13.8/datatables.min.js"></script>
	<script type="text/javascript" src="js/DataTables/datetime-moment.js"></script>
	<style type="text/css">div.dataTables_wrapper{margin-top: -5px;}</style>
	-->
	<!-- gannt chart library -->
	<!--<script src="js/dhtmlxgantt/dhtmlxgantt.js"/>
	<link href="js/dhtmlxgantt/dhtmlxgantt.css" rel="stylesheet"/>
	<link rel="stylesheet" href="css/dthmlxgantt_eas_skin.css"/>-->
	 
</div>
 
<xsl:call-template name="Footer"/>    
<script>
<xsl:call-template name="RenderViewerAPIJSFunction"> 
	<xsl:with-param name="viewerAPIPathImpacts" select="$apiImpacts"></xsl:with-param> 
	<xsl:with-param name="viewerAPIPathProcess" select="$apiProcess"></xsl:with-param> 
	<xsl:with-param name="viewerAPIPathAppsTech" select="$apiAppsTech"></xsl:with-param>
	<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param> 
	<xsl:with-param name="viewerAPIPathScope" select="$apiScope"></xsl:with-param>
	<xsl:with-param name="viewerAPIPathLife" select="$apiLife"></xsl:with-param>  
	
</xsl:call-template>  
</script>

</body>
<script id="timeline-template" type="text/x-handlebars-template">
    <svg xmlns="http://www.w3.org/2000/svg"><xsl:attribute name="style">width: 100%; height: {{svgHeight}};</xsl:attribute><xsl:attribute name="viewBox">0 0 {{svgWidth}} {{svgHeight}}</xsl:attribute>
      
      <!-- Year & Quarter Markers -->
      {{#each years}}
        <text class="timeline-text" y="20"><xsl:attribute name="x">{{this.pos}}</xsl:attribute>{{this.year}}</text>
        {{#each this.quarters}}
          <text class="quarter-text" y="35"><xsl:attribute name="x">{{this.pos}}</xsl:attribute>Q{{this.quarter}}</text>
        {{/each}}
        <line x1="{{this.pos}}" y1="0"  stroke="lightgrey" stroke-width="1" ><xsl:attribute name="x1">{{this.pos}}</xsl:attribute><xsl:attribute name="x2">{{this.pos}}</xsl:attribute><xsl:attribute name="y2">{{../svgHeight}}</xsl:attribute></line>
      {{/each}}

      <!-- Rows -->
      {{#each rows}}
        <text class="item-name" x="10"><xsl:attribute name="y">{{#yAdd this.y 10}}{{/yAdd}}</xsl:attribute>{{this.name}}</text>
        <!-- Required By Circle -->
        <circle r="8" fill="red" ><xsl:attribute name="cx">{{this.requiredByPos}}</xsl:attribute><xsl:attribute name="cy">{{#yAdd this.y 10}}{{/yAdd}}</xsl:attribute></circle>

        <!-- Programme Circles & Labels -->
        {{#each this.programmes}}
			<g class="programme-group">
			<circle r="8" fill="#89CFF0BF">
				<xsl:attribute name="cx">{{this.endPos}}</xsl:attribute>
				<xsl:attribute name="cy">{{#yAdd ../y 10}}{{/yAdd}}</xsl:attribute>
			</circle>
			<text class="program-label">
				<xsl:attribute name="x">{{add this.endPos 5}}</xsl:attribute>
				<xsl:attribute name="y">{{subtract ../y 2}}</xsl:attribute>{{this.name}}
			</text>
			</g>
        {{/each}}
      {{/each}}
	  <g><xsl:attribute name="transform">translate(10, {{legendY}})</xsl:attribute>
        <circle cx="0" cy="0" r="5" fill="red" />
        <text x="10" y="5" class="program-label"><xsl:value-of select="eas:i18n('Debt Required By Date')"/></text>
        <circle cx="140" cy="0" r="5" fill="#89CFF0BF" />
        <text x="150" y="5" class="program-label"><xsl:value-of select="eas:i18n('Resolving Programme(s) End Date')"/></text>
      </g>
    </svg>
  </script>
<!--
<script id="timeline-template" type="text/x-handlebars-template">
    <svg xmlns="http://www.w3.org/2000/svg" 
            preserveAspectRatio="none"
            style="width: 80%; height: auto;"><xsl:attribute name="viewBox">0 0 {{this.svgWidth}} {{this.svgHeight}}</xsl:attribute>
             
            {{#each this.years}}
                <text class="timeline-text" y="30"><xsl:attribute name="x">{{this.pos}}</xsl:attribute>{{this.year}}</text>
                {{#each this.quarters}}
                    <text class="quarter-text" y="50"><xsl:attribute name="x">{{this.pos}}</xsl:attribute>Q{{this.quarter}}</text>
                {{/each}}
                <line y1="60" stroke="lightgrey" stroke-width="1"><xsl:attribute name="x1">{{this.pos}}</xsl:attribute>
                <xsl:attribute name="x2">{{this.pos}}</xsl:attribute>
                <xsl:attribute name="y2">{{../svgHeight}}</xsl:attribute></line>
            {{/each}}
            
            <rect class="cap-box" x="5" y="50" width="70" rx="10" ry="10"><xsl:attribute name="height">{{this.capHeight}}</xsl:attribute></rect>
            <text class="cap-text" font-size="24" x="10"><xsl:attribute name="y">{{this.captextMid}}</xsl:attribute><xsl:attribute name="transform">rotate(270,40,{{this.captextMid}})</xsl:attribute>
            {{this.capability}}
            </text>
             
            {{#each this.programmes}} 
           
            {{#each this.projects}}
  
                <rect class="project" height="12" stroke="yellow"> <xsl:attribute name="width">{{this.width}}</xsl:attribute>
                <xsl:attribute name="x">{{this.svgStartPos}}</xsl:attribute><xsl:attribute name="y">{{this.yPos}}</xsl:attribute><xsl:attribute name="style">{{#ifEquals this.noDate true}}fill:#d3d3d3 !important;{{/ifEquals}}{{#checkDate this}}{{/checkDate}}</xsl:attribute></rect>
                <text class="projectText"  font-size="7"><xsl:attribute name="x">{{this.textX}}</xsl:attribute><xsl:attribute name="y">{{this.textY}}</xsl:attribute><xsl:attribute name="style">{{#ifEquals this.noDate true}}fill:#000000 !important;{{/ifEquals}}</xsl:attribute>{{this.name}}</text> 
                
            {{/each}}
            {{/each}}
        </svg>
</script>   -->
<script id="pop-template" type="text/x-handlebars-template">
   <table class="popup-table">
	<thead><tr><th scope="col"><xsl:value-of select="eas:i18n('Item')"/></th><th scope="col"><xsl:value-of select="eas:i18n('Impact')"/></th></tr></thead>
	<tbody>
	{{#each this}}	
	<tr><td>{{this.name}}</td><td>{{#if this.impact}} <xsl:value-of select="eas:i18n('Indirect via')"/> {{this.impact}} ({{this.type}}){{else}}<xsl:value-of select="eas:i18n('Direct')"/>{{/if}}</td></tr>
	{{/each}}
	</tbody>
	</table>
</script>     
<script id="debt-template" type="text/x-handlebars-template">
    <div class="debt-item"><xsl:attribute name="data-id">{{id}}</xsl:attribute>{{label}}</div>
</script>
<script id="debt-summary-template" type="text/x-handlebars-template">
		<div class="col-md-7">
			<span class="debt-name"><i class="fa fa-exclamation-circle"></i> {{name}}</span>
			<p class="debt-description">{{description}}</p>
			<p class="debt-date"><i class="fa fa-calendar"></i> <strong><xsl:value-of select="eas:i18n('Required by')"/>:</strong> {{required_by_date}}</p>
			<p class="debt-status"><i class="fa fa-info-circle"></i> <strong><xsl:value-of select="eas:i18n('Status')"/>:</strong> {{status}}</p>
			<hr/>
		</div>
		<div class="col-md-5">
			<p class="debt-status">
			<strong><xsl:value-of select="eas:i18n('Resolved By')"/> </strong>
			</p>
			{{#if this.resolved_by}}
				{{#each this.resolved_by}}
				<p class="debt-status">
				<span class="debt-name"><i class="fa fa-calendar"></i> {{name}}</span>
				<p class="debt-description">{{description}}</p>
				<b><xsl:value-of select="eas:i18n('Start')"/>:</b> {{start_date}}  <b><xsl:value-of select="eas:i18n('End')"/>:</b> {{end_date}}
				</p>
				{{/each}}
			{{else}}
			<i class="fa fa-exclamation-triangle fa-2x" style="color:red"></i> <xsl:value-of select="eas:i18n('No Resolution Planned')"/> 
			{{/if}}
		</div>
	
</script>
<script id="scope-template" type="text/x-handlebars-template">


	{{#if this.sr_requirement_for_elements}}
	<p><xsl:value-of select="eas:i18n('This debt is associated with these items')"/></p>
		{{#each this.sr_requirement_for_elements}}
		<div class="requirement-item"><xsl:attribute name="data-id">{{id}}</xsl:attribute>{{name}}
	
		{{#ifEquals this.inferred true}}<xsl:text>  </xsl:text><span class="label label-info"><xsl:value-of select="eas:i18n('Inferred')"/></span> {{/ifEquals}}
		<div class="typeName">{{type}}</div>
		<div class="caretButton"><i class="fa fa-chevron-circle-right"></i></div>
		</div>
		{{/each}}
	{{else}}
		<p><i class="fa fa-warning" style="color:red"></i><xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('No Impacts Identified')"/></p>
	{{/if}}
</script>
<script id="impact-template" type="text/x-handlebars-template">

{{#if this.message}}
	<p><xsl:value-of select="eas:i18n('No impacts identified for this item')"/></p>
{{else}}
	
  <p><xsl:value-of select="eas:i18n('This element in the architecture is impacted by the selected item')"/></p>
  <b><xsl:value-of select="eas:i18n('name')"/></b>: {{this.application.name}}{{this.process.name}}{{this.techProduct.name}}<br/>

  <div class="impact-columns">
    {{#with (getNested this "application" "process" "techProduct")}}
	{{#if processes}}
      <div class="impact-column processes">
          <h3>Processes</h3> 
            {{#each processes}}
              <div class="impact-item" data-id="{{id}}">
                {{name}}
                <div class="impactType"><span class="label label-default"><xsl:value-of select="eas:i18n('Business Process')"/></span></div>
              </div>
            {{/each}} 
      </div>
	  {{/if}}
	  {{#if applications}}
      <div class="impact-column applications"> 
          <h3>Applications</h3> 
            {{#each applications}}
              <div class="impact-item" data-id="{{id}}">
                {{name}}
                <div class="impactType"><span class="label label-default"><xsl:value-of select="eas:i18n('Application')"/></span></div>
              </div>
            {{/each}}  
      </div>
	  {{/if}}
	  {{#if techProducts}}
      <div class="impact-column tech-products"> 
          <h3>Tech Products</h3> 
            {{#each techProducts}}
              <div class="impact-item" data-id="{{id}}">
                {{name}}
                <div class="impactType"><span class="label label-default"><xsl:value-of select="eas:i18n('Technology Product')"/></span></div>
              </div>
            {{/each}}
      </div> 
	  {{/if}}
    {{/with}}
  </div>  
  {{/if}}
</script>

<script id="key-template" type="text/x-handlebars-template">

	{{#each this}}
	<i class="fa fa-square"><xsl:attribute name="style">color:{{this.color}};</xsl:attribute></i> {{this.name}}<br/>
	{{/each}}
</script>
<script id="cause-template" type="text/x-handlebars-template">
	{{#ifEquals this.length  0}}
		<p><xsl:value-of select="eas:i18n('No root cause identified')"/></p>
	{{/ifEquals}}
	{{#ifEquals this.length  1}}
	<!-- Just one cause -->
		<h4><i class="fa fa-warning"></i> <xsl:value-of select="eas:i18n('CAUSE')"/></h4>
		<p><xsl:value-of select="eas:i18n('This item is the root cause of the selected technical debt')"/></p>
		<b><xsl:value-of select="eas:i18n('Name')"/></b>: {{this.0.name}}<br/>
		<b><xsl:value-of select="eas:i18n('Description')"/></b>: {{this.0.description}}<br/>
		<b><xsl:value-of select="eas:i18n('Type')"/></b>: {{this.0.type}}<br/>
		{{#if this.information}}
			<b><xsl:value-of select="eas:i18n('Lifecycle Information')"/>:</b><br/>
			
				<div class="infoBox">
					{{#each this.information}}
						{{#ifEquals @index 0}}<span class="label label-warning">{{this.name}}</span>{{else}}<span class="label label-danger">{{this.name}}</span>{{/ifEquals}}<xsl:text> </xsl:text>
						<span class="label label-default">{{this.dateOf}}</span> <br/>
					{{/each}} 
				</div>
		{{/if}}
	{{else}}
		<!-- Tabs navigation -->
		<ul class="nav nav-tabs root-nav-tabs">
			{{#each this}}
				<li><xsl:attribute name="class">{{#if @first}}active{{/if}}</xsl:attribute>
					<a data-toggle="tab"><xsl:attribute name="href">#tab{{@index}}</xsl:attribute>{{name}}</a>
				</li>
			{{/each}}
		</ul>

		<!-- Tab content -->
		<div class="tab-content">
			{{#each this}}
				<div><xsl:attribute name="class">tab-pane {{#if @first}}active{{/if}}</xsl:attribute><xsl:attribute name="id">tab{{@index}}</xsl:attribute>
					<h4><i class="fa fa-warning"></i> CAUSE</h4>
					<p><xsl:value-of select="eas:i18n('This item is the root cause of the selected technical debt')"/></p>
					<b><xsl:value-of select="eas:i18n('Name')"/></b>: {{name}}<br/>
					<b><xsl:value-of select="eas:i18n('Description')"/></b>: {{description}}<br/>
					<b><xsl:value-of select="eas:i18n('Type')"/></b>: {{type}}<br/>
					{{#if this.information}}
						<b><xsl:value-of select="eas:i18n('Lifecycle Information')"/>:</b><br/>
						<div class="infoBox"> 
						{{#each this.information}}
							 {{#ifEquals @index 0}}<span class="label label-warning">{{this.name}}</span>{{else}}<span class="label label-danger">{{this.name}}</span>{{/ifEquals}}<xsl:text> </xsl:text>
							<span class="label label-default">{{this.dateOf}}</span> <br/>
						{{/each}}
						</div>	
					{{/if}}
				</div>
			{{/each}}
		</div>
	{{/ifEquals}}
</script>


</html>
        
</xsl:template>
<xsl:template name="RenderViewerAPIJSFunction"> 
	<xsl:param name="viewerAPIPathImpacts"></xsl:param>  
	<xsl:param name="viewerAPIPathProcess"></xsl:param>  
	<xsl:param name="viewerAPIPathAppsTech"></xsl:param>  
	<xsl:param name="viewerAPIPathApps"></xsl:param>  
	<xsl:param name="viewerAPIPathScope"></xsl:param>  
	<xsl:param name="viewerAPIPathLife"></xsl:param>
	//a global variable that holds the data returned by an Viewer API Report 
	var viewAPIDataImpacts = '<xsl:value-of select="$viewerAPIPathImpacts"/>';  
	var viewAPIDataProcess = '<xsl:value-of select="$viewerAPIPathProcess"/>';
	var viewAPIDataAppsTech = '<xsl:value-of select="$viewerAPIPathAppsTech"/>';    
	var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>';   
	var viewAPIDataScope = '<xsl:value-of select="$viewerAPIPathScope"/>';  
	var viewAPIDatalife = '<xsl:value-of select="$viewerAPIPathLife"/>'; 

	const promise_loadViewerAPIData = async (apiDataSetURL) => {
		if (!apiDataSetURL) {
			throw new Error("API URL is required.");
		}
		
		const response = await fetch(apiDataSetURL);
		if (!response.ok) {
			throw new Error(`Network response was not ok: ${response.status}`);
		}
		
		const viewerData = await response.json();
		$('#ess-data-gen-alert').hide();
		
		return viewerData;
	};

	var summaryTemplate, scopeTemplate, impactTemplate , data, timelineTemplate, getMergedData, bcmImpacts, lifecycles, listTemplate; 


 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

	function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};
	  
	showEditorSpinner('Fetching Impact Data...this may take a little while');

	$(document).ready(function() {

		$('#home-button').on('click', function () {
			const isMgmtVisible = $('.mgmt-section:visible').length > 0;
			const $icon = $(this).find('i');
		 
			if (isMgmtVisible) {
				$('.mgmt-section').fadeOut(400, function () {
				$('.mgmt-section .toggle-button').attr('aria-expanded', 'false');
				$('.responses-section').slideDown(400);
				$('#home-button').css('color', 'gray');
			});
			} else { 
				$('.mgmt-section').fadeIn(400);
				$('.mgmt-section .toggle-button').attr('aria-expanded', 'true');
				$('.row.headerInfo').each(function () {
					var $headerRow = $(this);

					// Only close if currently visible
					if (!$headerRow.is(':visible')) {
						$headerRow.slideDown(400);

						// Find the closest panel-body and then the toggle button within it
						var $panelBody = $headerRow.closest('.panel-body');
						var $toggleButton = $panelBody.find('.toggle-button');
						var $icon = $toggleButton.find('i');

						// Ensure the icon reflects the closed state
						$icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
					}
				});
				$('#home-button').css('color','green'); 
			}
		});
 

			$('#navbar-side').hide()
			let typeData= [<xsl:apply-templates select="$catTypes" mode="cats"/>]
            let catData = [<xsl:apply-templates select="$cats" mode="cats"/>]
            let issueData = [<xsl:apply-templates select="$issues" mode="data"/>]

		issueData.filter((issue)=> { return issue.status !== "Resolved"})


			//sum debts by category
			catData.forEach(category => {
				const total = category.types.reduce((sum, type) => {
					return sum + parseInt(type.count || "0", 10);
				}, 0);
				category.totalCount = total;
			});
             data={"category": catData, "debts": issueData}

		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
		
		Handlebars.registerHelper('yAdd', function(arg1, arg2) {
			return (arg1 + arg2)
		});

		Handlebars.registerHelper('getNested', function(context, ...keys) {
		// Remove the options argument (last item)
			keys.pop();
			for (let key of keys) {
				if (context &amp;&amp; context[key]) {
				return context[key];
				}
			}
			return {};
		});

         Handlebars.registerHelper('checkDate', function(arg1) {
              
                if (!arg1 || !arg1.required_by_date) {
                    return ""; // Return empty string if no date is provided
                }

                let today = new Date();
                let requiredDate = new Date(arg1.required_by_date);

                let diffMonths = (requiredDate.getFullYear() - today.getFullYear()) * 12 + (requiredDate.getMonth() - today.getMonth());

                if (requiredDate &lt; today || diffMonths &lt;= 1) {
                    return "fill: #ff9e9e !important;"; // Date is past or within 1 month
                } else if (diffMonths &lt;= 6) {
                    return "fill: #e57416 !important;"; // Within 6 months
                } else if (diffMonths &lt;= 12) {
                    return "fill: #f1c40f !important;"; // Within 12 months
                }

                return ""; // No styling if beyond 12 months
            }); 

		// Register the Handlebars helper
		Handlebars.registerHelper('wrapText', function(text, maxWidth) {
            // Use an approximate average width (in pixels) per character.
            // Adjust this value based on your font and styling.
            const avgCharWidth = 7;
            
            // Split the text into words
            const words = text.split(/\s+/);
            let line = "";
            const lines = [];
            
            // Build lines by adding words until the estimated width exceeds maxWidth
            words.forEach(function(word) {
                // Test adding the word (with a preceding space if needed)
                const testLine = line ? line + " " + word : word;
                // Estimate the width in pixels
                if (testLine.length * avgCharWidth > maxWidth &amp;&amp; line !== "") {
                // If adding the word exceeds maxWidth, push the current line and start a new one
                lines.push(line);
                line = word;
                } else {
                line = testLine;
                }
            });
            
            // Push the last line if there is any text left
            if (line) {
                lines.push(line);
            }
            
            // Generate the  tspan  elements.
            // The first line uses dy="0em" and subsequent lines use dy="1.2em"
            let result = "";
            lines.forEach(function(lineText, index) {
                const dy = index === 0 ? "0em" : "1.2em";
                result += `<tspan x="10" dy="${dy}">${Handlebars.escapeExpression(lineText)}</tspan>`;
            });
            
            // Mark the result as safe HTML so it won't be escaped again
            return new Handlebars.SafeString(result);
            });


	const template = Handlebars.compile($('#debt-template').html());
	summaryTemplate = Handlebars.compile($('#debt-summary-template').html());
	popTemplate = Handlebars.compile($('#pop-template').html());
	scopeTemplate = Handlebars.compile($('#scope-template').html());
	impactTemplate = Handlebars.compile($('#impact-template').html());
	causeTemplate = Handlebars.compile($('#cause-template').html()); 
	keyTemplate = Handlebars.compile($('#key-template').html());
	timelineTemplate = Handlebars.compile($('#timeline-template').html());
	trmTemplate = Handlebars.compile($('#trm-template').html());
	armTemplate = Handlebars.compile($('#arm-template').html());
	bcmTemplate = Handlebars.compile($('#bcm-template').html());
	listTemplate = Handlebars.compile($('#listof-template').html());
	 
			Promise.all([ 
				promise_loadViewerAPIData(viewAPIDataImpacts) ,
				promise_loadViewerAPIData(viewAPIDataProcess) ,
				promise_loadViewerAPIData(viewAPIDataAppsTech),
				promise_loadViewerAPIData(viewAPIDataApps),
				promise_loadViewerAPIData(viewAPIDataScope),
				promise_loadViewerAPIData(viewAPIDatalife) 
				]).then(function (responses){ 
			removeEditorSpinner()
			const scopeData = (({ bcmData, armData, trmData }) => ({ bcmData, armData, trmData }))(responses[4]); 
			responses[5] = responses[5].technology_lifecycles.filter(tl => {
						const dates = tl.allDates;
						if (!Array.isArray(dates) || dates.length === 0) return false;
						for (let i = 0; i &lt; dates.length; i++) {
							if (!dates[i]?.dateOf) return false;
						}
						return true;
					})
				 
				lifecycles=responses[5]
				bcmImpacts= responses[0].impacts;
				let process_to_apps = responses[1].process_to_apps;
				let applicationToTechData = responses[2].application_technology_architecture;

				$('#bcmPanel').html(bcmTemplate(scopeData.bcmData));	
		 		$('#armPanel').html(armTemplate(scopeData.armData));	
			 	$('#trmPanel').html(trmTemplate(scopeData.trmData));	
					
				//create mappings for impacts
				// Create mappings using Map for efficient key lookup 
			// Process &amp; Application mappings:
const processToApplications = new Map(); // process id -&gt; set of application ids
const applicationToProcesses = new Map();  // application id -&gt; set of process ids
const processLookup = new Map();
const appLookup = new Map();

// Populate appLookup from responses[3].applications
responses[3].applications.forEach(app => {
  if (app.id &amp;&amp; app.name) {
    appLookup.set(app.id, app.name);
  }
});

// Helper function to add process-application mappings
function addMapping(processId, appId) {
  if (!processToApplications.has(processId)) {
    processToApplications.set(processId, new Set());
  }
  processToApplications.get(processId).add(appId);

  if (!applicationToProcesses.has(appId)) {
    applicationToProcesses.set(appId, new Set());
  }
  applicationToProcesses.get(appId).add(processId);
}

// Build process-to-application mappings using traditional for‑loops
for (let i = 0, len = process_to_apps.length; i &lt; len; i++) {
  const record = process_to_apps[i];
  const procId = record.processid;

  if (!processLookup.has(procId)  &amp;&amp;  record.processName) {
    processLookup.set(procId, record.processName);
  }

  const directApps = record.appsdirect;
  if (directApps  &amp;&amp;  Array.isArray(directApps)) {
    for (let j = 0, len2 = directApps.length; j &lt; len2; j++) {
      const app = directApps[j];
      if (app.id) {
        addMapping(procId, app.id);
      }
    }
  }

  const serviceApps = record.appsviaservice;
  if (serviceApps  &amp;&amp;  Array.isArray(serviceApps)) {
    for (let j = 0, len2 = serviceApps.length; j &lt; len2; j++) {
      const appService = serviceApps[j];
      if (appService.appid) {
        addMapping(procId, appService.appid);
      }
    }
  }
}

 
for (const [key, appSet] of processToApplications) {
 
  const sourceImpact = bcmImpacts[key];
  if (!sourceImpact) continue; // Skip if no matching BCM Impact

  for (const appId of appSet) {

    if (bcmImpacts[appId]) {
      // Extend existing scopeIds (merge and deduplicate)
      const existingScopeIds = new Set(bcmImpacts[appId].scopeIds || []);

      for (const sid of sourceImpact.scopeIds) {
        existingScopeIds.add(sid);
      }

      bcmImpacts[appId].scopeIds = Array.from(existingScopeIds);
    } else {
      // Create new BCM impact entry
      bcmImpacts[appId] = {
        id: appId,
        name: "", // Or use a placeholder if needed
        meta: {},
        scopeIds: [...sourceImpact.scopeIds],
        directImpacts: []
      };
    }
  }
}

// Lookup functions for process/application data
function getApplicationsForProcess(processId) {
  return processToApplications.has(processId)
    ? Array.from(processToApplications.get(processId)).map(appId => ({
        id: appId,
        name: appLookup.get(appId) || null
      }))
    : [];
}

function getProcessesForApplication(appId) {
  return applicationToProcesses.has(appId)
    ? Array.from(applicationToProcesses.get(appId)).map(procId => ({
        id: procId,
        name: processLookup.get(procId) || null
      }))
    : [];
}

// Application-to-Technology mappings:
const applicationToTechMapping = new Map(); // application id -&gt; set of tech product ids
const techToApplicationMapping = new Map();   // tech product id -&gt; set of application ids
const techProductLookup = new Map();          // tech product id -&gt; tech product name

// Helper function to add tech mappings
function addTechMapping(appId, techProdId) {
  if (!applicationToTechMapping.has(appId)) {
    applicationToTechMapping.set(appId, new Set());
  }
  applicationToTechMapping.get(appId).add(techProdId);

  if (!techToApplicationMapping.has(techProdId)) {
    techToApplicationMapping.set(techProdId, new Set());
  }
  techToApplicationMapping.get(techProdId).add(appId);
}
 
// Build application-to-tech mappings using traditional for‑loops
for (let i = 0, len = applicationToTechData.length; i &lt; len; i++) {
  const appRecord = applicationToTechData[i];
  const appId = appRecord.id;
 
  const techProducts = appRecord.allTechProds;
  if (techProducts  &amp;&amp;  Array.isArray(techProducts)) {
    for (let j = 0, len2 = techProducts.length; j &lt; len2; j++) {
      const tech = techProducts[j];
      if (tech  &amp;&amp;  tech.productId) {
        addTechMapping(appId, tech.productId);
        if (!techProductLookup.has(tech.productId)) {
          techProductLookup.set(tech.productId, tech.product);
        }
      }
    }
  }
}

// Lookup functions for tech data
function getTechProductsForApplication(appId) {
  return applicationToTechMapping.has(appId)
    ? Array.from(applicationToTechMapping.get(appId)).map(prodId => ({
        id: prodId,
        name: techProductLookup.get(prodId) || null
      }))
    : [];
}

function getApplicationsForTechProduct(techProdId) {
  return techToApplicationMapping.has(techProdId)
    ? Array.from(techToApplicationMapping.get(techProdId)).map(appId => ({
        id: appId,
        name: appLookup.get(appId) || null
      }))
    : [];
}


// TEST USE IMPACTS THE GET DATA

// Function that finds all instances where the given id exists in scopeIds
function findInstancesByScopeId(instancesObj, targetId) {
  // Convert the object values to an array of instance objects
  const instancesArray = Object.values(instancesObj);
  // Filter instances whose scopeIds include the target id
  return instancesArray.filter(instance => instance.scopeIds.includes(targetId));
}

// Merged lookup function: returns all related data for a given id
 getMergedData= function getMergedData(id) {
  const result = { id: id };

  // If id is a process id
  if (processLookup.has(id)) {
    result.process = {
      id: id,
      name: processLookup.get(id),
	  "type": "business process",
      applications: getApplicationsForProcess(id)
    };
  }

  // If id is an application id
  if (appLookup.has(id)) {
    result.application = {
      id: id,
      name: appLookup.get(id),
      processes: getProcessesForApplication(id),
	  type: "application",
      techProducts: getTechProductsForApplication(id)
    };
  }

  // If id is a tech product id
  if (techProductLookup.has(id)) {
    result.techProduct = {
      id: id,
	  "type": "technology Product",
      name: techProductLookup.get(id),
      applications: getApplicationsForTechProduct(id)
    };
  }

  // If no matching data was found
  if (!result.process &amp;&amp; !result.application &amp;&amp; !result.techProduct) {
    result.message = "No data found for the given id";
  }

  return result;
}


				// end of impact mapping
            data.category.forEach(type => {
				if(type.totalCount > 0){
                	$('#catType').append(new Option(type.label, type.id));
				}
            });
            $('#debtType').hide();

            $('#catType').change(function() {
				renderTimeline()
				$('.row.headerInfo').each(function () {
					var $headerRow = $(this);

					// Only close if currently visible
					if (!$headerRow.is(':visible')) {
						$headerRow.slideDown(400);

						// Find the closest panel-body and then the toggle button within it
						var $panelBody = $headerRow.closest('.panel-body');
						var $toggleButton = $panelBody.find('.toggle-button');
						var $icon = $toggleButton.find('i');

						// Ensure the icon reflects the closed state
						$icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
					}
				});

                let pick=$(this).val();
                $('#debtType').empty();
                $('#debtType').append('<option>Choose</option>');
                data.category.find(cat => cat.id == pick).types.forEach(type => {
					if(type.count > 0){
                    	$('#debtType').append(new Option(type.label, type.id));
					}
                });
                $('#debtType, #debtTypeSelect').show(); 
                $('#debtType').change(function() {

					$('#debtItemSelect').show()
                    $('#debtList').html('');
                    let selected=$(this).val(); 

				let matches=data.debts.filter((d)=>{
						return d.categories.includes(selected)
					})
					$('#debtSelect').html('<option>Choose</option>');
				matches.forEach(debt => {
						$('#debtSelect').append(new Option(debt.name, debt.id)); 
                    });
                    registerDebts();
 
                });
            });

            const result = consolidateCategories(data.debts);
            data.category.forEach((e)=>{
                e.types.forEach((t)=>{
                    t.debts=result[t.id]
                })
            })
  

           let programmes= [{
            name: "Technical Debt",
            type: "programme",
            projects: []
            }];
			let issueCount=issueData.filter((d)=>{return d.status !='Resolved'}).length;
			let unplannedIssueCount=issueData.filter((d)=>{return d.status !='Resolved' &amp;&amp; d.resolved_by.length==0}).length;
	 
			if(unplannedIssueCount==0){$('.issueCircle').hide()}
			$('#unplannedIssueCount').text(unplannedIssueCount);
			$('#issueCount').text(issueCount);
            issueData.forEach((n)=>{
                programmes[0].projects.push({ id: n.id, name: n.name , startDate: n.required_from_date, endDate: n.required_by_date })
            })
 
            <!--let timelineData = generateTimelineData(programmes, 'Debts');  -->

			const allDates = [];
			issueData.forEach(item => {
				if (item.required_by_date) allDates.push(new Date(item.required_by_date));
				item.resolved_by.forEach(p => {
					if (p.start_date) allDates.push(new Date(p.start_date));
					if (p.end_date) allDates.push(new Date(p.end_date));
				});
			});

	

		// Handlebars helpers
		Handlebars.registerHelper("add", function(a, b) {
		return a + b;
		});
		Handlebars.registerHelper("subtract", function(a, b) {
		return a - b;
		});
  
function renderTimeline(customStart, customEnd, setInputFields = false) {
		 
  const minDate = customStart ? new Date(customStart) : new Date(Math.min(...allDates));
  const maxDate = customEnd ? new Date(customEnd) : new Date(Math.max(...allDates));
  const chartStartDate = new Date(minDate.getFullYear(), 0, 1);
  let chartEndDate = new Date(maxDate.getFullYear(), 0, 1);
  
  if (!setInputFields) { 
	chartEndDate=new Date(maxDate.getFullYear(), 0, 1);
    // Format as YYYY-MM-DD for input fields
    const formatInputDate = date => date.toISOString().split("T")[0];
    document.getElementById("start-date").value = formatInputDate(chartStartDate);
    document.getElementById("end-date").value = formatInputDate(chartEndDate);
  }
let workingData=issueData;
 
if ($('#catType')[0].selectedIndex !== 0) {
	 
	let thisCat = catData.find((cat)=>{ 
		return cat.id==$('#catType').val()
	})
	 
	const typeIds = thisCat.types.map(t => t.id);

	workingData = workingData.filter(d => 
	d.categories.some(cat => typeIds.includes(cat))
	);
	 
  }
   
  const chartWidth = 800;
  const chartStartPoint = 200;
  const rowHeight = 30;

  const rows = workingData.map((item, index) => {
    if (!item.required_by_date) {
      const today = new Date();
      item.required_by_date = today.toISOString().split("T")[0];
    }
    const y = 60 + index * rowHeight;
    const requiredByPos = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, item.required_by_date);

    const programmes = item.resolved_by.map(p => {
      const endPos = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, p.end_date);
      return endPos >= 250 ? { name: p.name, endPos } : null;
    }).filter(Boolean); // remove nulls

    return {
      name: item.name,
      y,
      requiredByPos: requiredByPos >= 250 ? requiredByPos : null,
      programmes
    };
  });

  function generateYearsAndQuarters(start, end) {
    const result = [];
    let current = new Date(start.getFullYear(), 0, 1);
    while (current &lt; end) {
      const year = current.getFullYear();
      const yearStart = new Date(year, 0, 1);
      const yearEnd = new Date(year + 1, 0, 1);
      const pos = getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, yearStart);
      const quarters = [0, 1, 2, 3].map(q => {
        const quarterDate = new Date(year, q * 3, 1);
        return {
          quarter: q + 1,
          pos: getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, quarterDate)
        };
      });
      result.push({ year, pos, quarters });
      current = yearEnd;
    }
    return result;
  }

  const years = generateYearsAndQuarters(chartStartDate, chartEndDate);
  const svgHeight = 60 + rowHeight * workingData.length + 60;
  const legendY = svgHeight - 30;
  const svgWidth = chartStartPoint + chartWidth + 20;

  const svgHTML = timelineTemplate({
    svgWidth,
    svgHeight,
    years,
    rows,
    legendY
  });

  $("#timeline-container").html(svgHTML);

  //manage table content
// Clear previous DataTable if it exists
if ( $.fn.DataTable.isDataTable('#debtTable-container') ) {
  $('#debtTable-container').DataTable().clear().destroy();
}
 

	$('#debtTable-container tfoot th').each(function () {
        const title = $(this).text();
        $(this).html(`
		<div class="search-input-wrapper">
		<i class="fa fa-search" aria-hidden="true"></i>
		<input type="text" aria-label="`+ title+`" placeholder="`+title+`" />
		</div>
	`);
      });

      const tableData = workingData.map(item => [
        item.name,
        item.status || "–",
        item.required_by_date || "–",
        item.description || "–",
        listTemplate(item.resolved_by) || '&lt;p>None&lt;/p>',
		listTemplate(item.rootCauses) ||  '&lt;p>None&lt;/p>'
      ]);

      const table = $('#debtTable-container').DataTable({
        data: tableData,
        columns: [
          { title: "Name" },
          { title: "Status" },
          { title: "Required By" },
          { title: "Description" },
          { title: "Resolved By", type: "html" },
          { title: "Root Causes",type: "html"  }
        ],
        pageLength: 5,
        responsive: true,
        dom: 'Bfrtip',
        buttons: [
          {
            extend: 'excelHtml5',
            text: 'Export to Excel',
            className: 'exportExcel',
            titleAttr: 'Export the table data to Excel',
            filename: 'Issue_Data_Export',
            exportOptions: {
              columns: ':visible'
            }
          }
        ],
        language: {
          paginate: {
            previous: "Previous page",
            next: "Next page"
          },
          info: "Showing _START_ to _END_ of _TOTAL_ entries"
        },
        initComplete: function () {
          this.api().columns().every(function () {
            const that = this;
            $('input', this.footer()).on('keyup change clear', function () {
              if (that.search() !== this.value) {
                that.search(this.value).draw();
              }
            });
          });
        }
      }); 


}


// Initial render
 
renderTimeline();

// On Refresh Button Click
$(".dateChange").off().on("change", () => {
  const start = document.getElementById("start-date").value;
  const end = document.getElementById("end-date").value;
  renderTimeline(start, end);
});



// Use event delegation so it works even after dynamic rendering
$(document).on('mouseover', '.programme-group', function() {
	$('.programme-group').addClass('dimmed'); 
  $(this).addClass('highlight'); 
});

$(document).on('mouseout', '.programme-group', function() {
  $('.programme-group').removeClass('dimmed highlight');
});

document.getElementById('export-pdf').addEventListener('click', function () {
  const container = document.getElementById('timeline-container');

  html2canvas(container).then(canvas => {
    const imgData = canvas.toDataURL('image/png');
    const { jsPDF } = window.jspdf;
    const pdf = new jsPDF('l', 'pt', 'a4');

    const pdfWidth = pdf.internal.pageSize.getWidth();
    const pdfHeight = pdf.internal.pageSize.getHeight();
    const ratio = Math.min(pdfWidth / canvas.width, pdfHeight / canvas.height);

    const imgWidth = canvas.width * ratio;
    const imgHeight = canvas.height * ratio;

    pdf.addImage(imgData, 'PNG', 20, 20, imgWidth, imgHeight);
    pdf.save("timeline.pdf");
  });
});

document.getElementById('export-ppt').addEventListener('click', function () {
  const container = document.getElementById('timeline-container');

  html2canvas(container).then(canvas => {
    const imgData = canvas.toDataURL('image/png');

    const pptx = new PptxGenJS();
    const slide = pptx.addSlide();

    // Optional: set slide layout
    pptx.defineLayout({ name: 'LAYOUT_WIDE', width: 13.33, height: 7.5 });
    pptx.layout = 'LAYOUT_WIDE';

    slide.addImage({ data: imgData, x: 0.2, y: 0.2, w: 12.9, h: 7.1 });
    pptx.writeFile("timeline.pptx");
  });
});

document.getElementById('export-svg').addEventListener('click', function () {
  const svg = document.querySelector("#timeline-container svg");
  if (!svg) {
    alert("SVG not found.");
    return;
  }

  const clonedSvg = svg.cloneNode(true);

  // Step 1: Define your actual CSS styles here
  const css = `
    svg text {
      font-family: Arial, sans-serif;
      font-size: 12px;
      fill: #000;
    }

    .timeline-label {
      font-weight: bold;
      fill: #333;
    }

    .program-circle {
      fill: #e74c3c;
    }

    .required-circle {
      fill: red;
    }

    line {
      stroke: #ccc;
    }
  `;

  // Step 2: Inject CSS into the SVG
  const styleElement = document.createElementNS("http://www.w3.org/2000/svg", "style");
  styleElement.textContent = css;
  clonedSvg.insertBefore(styleElement, clonedSvg.firstChild);

  // Step 3: Serialize and trigger download
  const serializer = new XMLSerializer();
  const svgString = serializer.serializeToString(clonedSvg);
  const blob = new Blob([svgString], { type: "image/svg+xml;charset=utf-8" });
  const url = URL.createObjectURL(blob);

  const a = document.createElement("a");
  a.href = url;
  a.download = "timeline.svg";
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
});



           
        //   $("#timeline-container").html(timelineTemplate(timelineData));

     // charts data
    function renderPieChart(selector, data) {
	
    const ctx = document.querySelector(selector).getContext('2d');

    const labels = data.map(d => d.label || `Item ${d.count}`);
    const values = data.map(d => d.totalCount);
    const colors = [
        "#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", "#9966FF", "#FF9F40",
        "#C9CBCF", "#FF6F61", "#6B4226", "#51A351", "#F39C12", "#9B59B6"
    ].slice(0, data.length); 
    let lbl=[];
     labels.forEach((l,index)=>{
        lbl.push({name:l, color:colors[index]})
     })

    $('#valueKey').html(keyTemplate(lbl));
     
    new Chart(ctx, {
        type: 'pie',
        data: {
            labels: labels,
            datasets: [{
                data: values,
                backgroundColor: colors
            }]
        },
        options: {
            responsive: false,
            plugins: {
                legend: {
                    display: false,
                    position: 'right'
                },
                title: {
                    display: false,
                    text: "Debt By Category",
                    font: {
                        size: 18
                    },
                    padding: {
                        top: 10,
                        bottom: 20
                    }
                }
            }
        }
    });
 
}
      
        function calculateDebtCounts(data) {
            return data.map(category => {
                let categoryDebtCount = 0;
                let typeDebtCounts = {};

                category.types.forEach(type => {
                    let typeDebtCount = type.length;
                    categoryDebtCount += typeDebtCount;
                    typeDebtCounts[type.label] = typeDebtCount;
                });

                return {
                    label: category.label,
                    count: categoryDebtCount,
                    debtsPerType: typeDebtCounts
                };
            });
        }
 
        const impactData = calculateDebtCounts(data.category)

        renderPieChart("#categoryPieChart", catData);
 
        renderBarChart('#impactBarChart',  catData, "Technical Debt Breakdown");
 

		$('.toggle-button').on('click', function() {
			const isExpanded = $(this).attr('aria-expanded') === 'true';
			$(this).attr('aria-expanded', !isExpanded);
			// Find the panel body within the same panel container
			var $nextRow = $(this).nextAll('.row').first(); // Finds the first subsequent element with class 'row'
	
			// Toggle only the next row with slide animation
			$nextRow.slideToggle(400);
			// Toggle the icon based on visibility
			var $icon = $(this).find('i');
			if ($icon.hasClass('fa-chevron-up')) {
				$icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
			} else {
				$icon.removeClass('fa-chevron-down').addClass('fa-chevron-up');
			}
		});
	})



    function registerDebts() {
    $(document).on('change', '#debtSelect', function() {

		$('.responses-section').show();
		$('.refModel-blob').removeClass('blob-highlight');
   // Show the navbar side
	$('#navbar-side').show();

	let debtInfo = data.debts.find(debt => debt.id == $(this).val());
 
	$('.row.headerInfo').each(function () {
		var $headerRow = $(this);

		// Only close if currently visible
		if ($headerRow.is(':visible')) {

			$('.mgmt-section').fadeOut(500);
		/*	$headerRow.slideUp(400);

			// Find the closest panel-body and then the toggle button within it
			var $panelBody = $headerRow.closest('.panel-body');
			var $toggleButton = $panelBody.find('.toggle-button');
			var $icon = $toggleButton.find('i');
			 
			$toggleButton.attr('aria-expanded', 'false');
			// Ensure the icon reflects the closed state
			$icon.removeClass('fa-chevron-up').addClass('fa-chevron-down');
			*/
		}
	});
 
        $('.impacts').html('No scope item selected, choose one in the scope panel above')
		debtInfo.rootCauses.forEach((e)=>{

			let match = lifecycles.find((l)=>{
				return l.id == e.id
			})
		 
			if(match){ 

				const today = new Date();
				let lastPastDate = null;
				let latestDate = null;

			match.allDates.forEach(entry => {
				const entryDate = new Date(entry.dateOf);

				// Check for last past date 
				if (entryDate &lt;= today) {
					if (!lastPastDate || entryDate > new Date(lastPastDate.dateOf)) {
						lastPastDate = entry;
					}
				}

				// Check for overall latest date
				if (!latestDate || entryDate > new Date(latestDate.dateOf)) {
					latestDate = entry;
				}
				
			});

			e.information.push(lastPastDate)
			e.information.push(latestDate)
 

			}
		})

		let temp;
		let rootImpacts = debtInfo.rootCauses.forEach((r)=>{
			let match = getMergedData(r.id)
			temp=ensureTopLevelElementsInSrRequirements(debtInfo, match)
		})


        $('.rootCause').html(causeTemplate(debtInfo.rootCauses));
		 let infoArray=[];
		debtInfo.sr_requirement_for_elements.forEach((e)=>{
		 
			let allSecondary = getMergedData(e.id);
			let getObj=Object.keys(allSecondary)[1];
			const mainObj = allSecondary[getObj];

		mainObj.applications?.forEach((a)=>{
		 
			if(a.id!=""){
				$('[eas-id='+a.id+']').addClass('blob-highlight');
				if(bcmImpacts[a.id]){
			
					bcmImpacts[a.id].scopeIds?.forEach((s)=>{ 
						infoArray.push({"id":s.replace(/\./g, "_"), "impact":e.name, "name":a.name, "type":"Application"})
						$('[eas-id-blob='+s.replace(/\./g, "_")+']').addClass('blob-highlight');
					})
				}
			}
		})
		mainObj.processes?.forEach((a)=>{
			 
			if(a.id!=""){
				$('[eas-id='+a.id+']').addClass('blob-highlight');
				if(bcmImpacts[a.id]){
					bcmImpacts[a.id].scopeIds?.forEach((s)=>{ 
						infoArray.push({"id":s.replace(/\./g, "_"), "impact":e.name, "name":a.name, "type":"Process"})
						$('[eas-id-blob='+s.replace(/\./g, "_")+']').addClass('blob-highlight');
					})
				}
			}
		})
		mainObj.techProducts?.forEach((a)=>{
			
			if(a.id!=""){
				$('[eas-id='+a.id+']').addClass('blob-highlight');
				if(bcmImpacts[a.id]){
				
					bcmImpacts[a.id].scopeIds?.forEach((s)=>{  
						infoArray.push({"id":s.replace(/\./g, "_"), "impact":e.name, "name":a.name, "type":"Technology Product"})
						$('[eas-id-blob='+s.replace(/\./g, "_")+']').addClass('blob-highlight');
					})
				}
			}
		})
		
		 
		if(e.id!=""){
		  
			if(bcmImpacts[e.id]){
			bcmImpacts[e.id].scopeIds?.forEach((s)=>{   
				infoArray.push({"id":s.replace(/\./g, "_"), "name":e.name})
					$('[eas-id-blob='+s.replace(/\./g, "_")+']').addClass('blob-highlight');
					 
				}) 
			}
		}
			 
		})

		const infoMap = infoArray.reduce((acc, item) => {
			if (!acc[item.id]) {
				acc[item.id] = [];
			}
			acc[item.id].push(item);
			return acc;
			}, {});

function ensureTopLevelElementsInSrRequirements(debtInfo, match) {
    // Make sure sr_requirement_for_elements exists
    if (!debtInfo.sr_requirement_for_elements) {
        debtInfo.sr_requirement_for_elements = [];
    }

    const existingIds = new Set(debtInfo.sr_requirement_for_elements.map(el => el.id));

    // List of potential elements to include
    const topLevelElements = [match.techProduct, match.application, match.process].filter(Boolean);
 
    topLevelElements.forEach(el => {
        if (!existingIds.has(el.id)) {
            debtInfo.sr_requirement_for_elements.push({
                id: el.id,
                value: el.id,
                name: el.name || "Unknown",
                label: el.name || "Unknown",
                type: el.type || "Unknown",
                impacts: [],
                inferred: true
            });
            existingIds.add(el.id);
        }
    });

    return debtInfo;
}



		 
 	
	$('.refModel-blob-info i.fa-info-circle').on('click', function (e) {
		
        e.stopPropagation();
 
        const $icon = $(this);
        const id = $icon.attr('eas-id');
        const $popup = $('#' + id + '-popup');   
		const $blob = $icon.closest('.refModel-blob');
 
 
		$('#' + id + '-popup-data').html(popTemplate(infoMap[id])); 
		 
        // Hide other popups
        $('.refModel-popup').not($popup).addClass('hiddenDiv');

        // Get icon position and dimensions
		const iconPosition = $icon.position();
        const popupWidth = $popup.outerWidth();
        const blobWidth = $blob.outerWidth();

        // Calculate left position — adjust if it overflows the blob
        let left = iconPosition.left;
        if (left + popupWidth > blobWidth) {
            left = blobWidth - popupWidth - 10; // shift left if needed
        }

        $popup.css({
            position: 'absolute',
            top: iconPosition.top + $icon.outerHeight() + 5,
            left: left,
            zIndex: 100
        });
	$popup.removeClass('hiddenDiv') 
    });

    // Close popups when clicking elsewhere
    $(document).on('click', function () {
        $('.refModel-popup').addClass('hiddenDiv');
    });
 
 
        $('.summaryBox').html(summaryTemplate(debtInfo));
        $('.scope').html(scopeTemplate(debtInfo));
        setTimeout(() => {
            let items = document.querySelectorAll(".requirement-item"); 
            items.forEach((item, index) => {
                setTimeout(() => {
                    item.classList.add("animate");
                }, index * 300); // Stagger animations
            });
        }, 100);
    

 
        $('.rootCause').html(causeTemplate(debtInfo.rootCauses));
    });

    // Event delegation for .requirement-item clicks
    $(document).on('click', '.requirement-item', function() {

        //find the debtInfo
        let debtInfo = data.debts.find(debt => debt.sr_requirement_for_elements.some(req => req.id == $(this).data('id')));
      
        $(".caretButton").removeClass("red");
        $(this).find(".caretButton").toggleClass("red");
        let req = debtInfo.sr_requirement_for_elements?.find(req => req.id == $(this).data('id') )
 
		let impactsData= getMergedData(req.id);
	 
        $('.impacts').html(impactTemplate(impactsData));
        setTimeout(() => {
            let items = document.querySelectorAll(".impact-item");
            items.forEach((item, index) => {
                setTimeout(() => {
                    item.classList.add("animate");
                }, index * 150); // Stagger animations
            });
        }, 100);
    });
}
});
  
function consolidateCategories(data) {
    const categoryMap = {};
    
    data.forEach(item => {
        const value = item.value;
        const categories = item.categories || [];
        
        categories.forEach(category => {
            if (!categoryMap[category]) {
                categoryMap[category] = [];
            }
            categoryMap[category].push(value);
        });
    });
    
    return categoryMap;
}

function renderBarChart(selector, data, chartTitle = "Stacked Bar Chart") {
    const canvas = document.querySelector(selector);
    if (!canvas || !(canvas instanceof HTMLCanvasElement)) {
        console.error(`Element "${selector}" must be a canvas for Chart.js.`);
        return;
    }

    const ctx = canvas.getContext('2d');
 
	const categories = data.map(c => c.label);
 
	// All unique type labels
	const subcategories = Array.from(new Set(
		data.flatMap(cat => (cat.types ?? []).map(t => t.label))
	)); 
   const colors = [
        "#FF6384", "#36A2EB", "#FFCE56", "#4BC0C0", "#9966FF", "#FF9F40",
        "#C9CBCF", "#FF6F61", "#6B4226", "#51A351", "#F39C12", "#9B59B6"
    ].slice(0, data.length); 

    // Extract dataset values
	const datasets = subcategories.map((typeLabel, index) => {
        return {
            label: typeLabel,
            data: data.map(category => {
                const type = category.types.find(t => t.label === typeLabel);
                return type ? type.count : 0;
            }),
            backgroundColor: colors[index % colors.length]
        };
    });
 
    // Create the Chart
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: categories,
            datasets: datasets
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    stacked: true,
                    ticks: {
                        display: true  // This hides the x-axis labels
                    }
                },
                y: {
                    stacked: true,
                    beginAtZero: true
                }
            },
            plugins: {
                legend: {
                    display: false,
                    position: 'right'
                },
                title: {
                    display: false,
                    text: chartTitle,
                    font: {
                        size: 18
                    },
                    padding: {
                        top: 20,
                        bottom: 20
                    }
                }
            }
        }
    });
 
}



// Helper function to generate random colors
function getRandomColor() {
    return `hsl(${Math.floor(Math.random() * 360)}, 70%, 60%)`;
}

// Custom legend rendering
function renderLegend(selector, datasets) {
    const legendContainer = document.querySelector(selector);
    if (!legendContainer) {
        console.warn(`Legend container "${selector}" not found.`);
        return;
    }
}
        
        var projectsWithDependencies;

        function getPosition(chartStartPoint, chartWidth, chartStartDate, chartEndDate, thisDateToShow) {
  
            let startDate = new Date(chartStartDate);       
            let endDate = new Date(chartEndDate);
            let thisDate = new Date(thisDateToShow);
            let pixelsPerMs = chartWidth / (endDate - startDate);
  
            return ((thisDate - startDate) * pixelsPerMs) + chartStartPoint;
        }

        function generateTimelineData(programmes, capability) {

 
            let allDates = programmes.flatMap(p => 
                p.projects.flatMap(pr => [
                    isNaN(new Date(pr.startDate)) ? new Date() : new Date(pr.startDate),
                    isNaN(new Date(pr.endDate)) ? new Date() : new Date(pr.endDate)
                ])
            );
 
            let startDate = new Date(Math.min(...allDates));
        
            let endDate = new Date(Math.max(...allDates));
            endDate.setFullYear(endDate.getFullYear()+1); 

            let svgWidth = 600;
            let svgHeight = 110 + programmes.length * 150;
            let chartStartPoint = 200;
            let chartWidth = svgWidth - chartStartPoint - 50;

            let years = [];
            let currentYear = startDate.getFullYear();
            while (currentYear &lt;= endDate.getFullYear()) {
                let yearPos = getPosition(chartStartPoint, chartWidth, startDate, endDate, new Date(currentYear, 0, 1));
                let quarters = [1, 2, 3, 4].map(q => ({
                    quarter: q,
                    pos: getPosition(chartStartPoint, chartWidth, startDate, endDate, new Date(currentYear, (q - 1) * 3, 1))
                }));
                years.push({ year: currentYear, pos: yearPos, quarters });
                currentYear++;
            }
      
            let programmeData = programmes.map((programme, index) => {
                let yPos = 75 + index * 150;
                let maxWidth = 0;
                let rowUsage = []; 

                if(index==0){
                //do nothing
                    }else{
                        if(programmes[index-1].ht){
                            yPos = programmes.slice(0, index).reduce((acc, prevProgramme) => acc + prevProgramme.ht, 0)
                            yPos=yPos+120 + ((index - 1) * 20)
                         
                        }else{
                            // leave ypos
                        }
                    }  
                let projects = programme.projects.map((project) => {
             
                    let projectStart = isNaN(new Date(project.startDate)) ? new Date() : new Date(project.startDate)
                    let projectEnd = new Date(project.endDate);

                    if (isNaN(projectEnd.getTime())) {
                        projectEnd = new Date(); // Default to today if invalid
                        project['noDate']=true;
                        if(project.startDate){ 
                            projectEnd.setFullYear(projectEnd.getFullYear() + 1); 
                        }
                    }
 
                    // Assuming 8 pixels per character and 1 pixel equals X milliseconds
                    const pixelsPerChar = 8;
                    const msPerPixel = 10 * 60 * 1000; // Example: each pixel represents 10 minutes
                    const extraTime = project.name.length * pixelsPerChar * msPerPixel * 200;

                    projectEnd = new Date(projectEnd.getTime() + extraTime); 
                    
                    let barStart = getPosition(chartStartPoint, chartWidth, startDate, endDate, projectStart);
                    let barEnd = getPosition(chartStartPoint, chartWidth, startDate, endDate, projectEnd);
                   
                    let width = Math.max(((barEnd-barStart)+4), 10);
                    maxWidth = Math.max(maxWidth, barEnd);

                    let yPosition = yPos;
                    for (let row = 0; ; row++) {
                        let occupied = rowUsage[row]?.some(([s, e]) => !(barEnd &lt;= s || barStart >= e));
                        if (!occupied) {
                            yPosition = yPos + row * 14;
                            if (!rowUsage[row]) rowUsage[row] = [];
                            rowUsage[row].push([barStart, barEnd]);
                            break;
                        }
                    }
 
                   
                    return {
                        name: project.name,
                        svgStartPos: barStart,
                        svgStartPosCircle: barStart - 5,
                        yPosCircle: yPosition + 15,
                        svgTextStart: 8, // Adjusted text position
                        yposText: yPosition + 3,
                        id: project.id,
                        noDate: project.noDate || false, 
                        required_by_date: project.endDate,
                        yPos: yPosition,
                        width: width,
                        textX: barStart + 5,
                        textY: yPosition + 8
                    };
                });
                programme.ht=rowUsage.length * 20 + 20
                programme.yPos=yPos;
                return {
                    name: programme.name,
                    svgStartPos: chartStartPoint - 20,
                    type: programme.type,
                    yPos: yPos - 10,
                    yPosMinus10: yPos - 17,
                    width: maxWidth - chartStartPoint + 25,
                    height: rowUsage.length * 40 + 20,
                    projects: projects,
                    cap: programme.cap,
                    yPosMid: yPos + (rowUsage.length * 40 + 20)/2 - 20
                };
            });

            let capLen=capability.length
 
            const programmesOnly = programmes.filter(p => p.type === "programme");
            const lastProgramme = programmesOnly[programmesOnly.length - 1];
            const capHeight = lastProgramme.ht + lastProgramme.yPos - 50;
            const captextMid = (capHeight/2)+(10 * capLen);
          
            return {
                svgWidth: svgWidth,
                svgHeight: svgHeight,
                years: years,
                programmes: programmeData,
                capability: capability,
                capHeight: capHeight,
                captextMid: captextMid
            };
        }
</xsl:template>
<xsl:template match="node()" mode="data">
<xsl:variable name="elements" select="key('elements', current()/own_slot_value[slot_reference='sr_requirement_for_elements']/value)"/>
<xsl:variable name="resolutions" select="key('elements', current()/own_slot_value[slot_reference='resolved_by']/value)"/>
<xsl:variable name="status" select="key('elements', current()/own_slot_value[slot_reference='requirement_status']/value)"/>
  {
    id: "<xsl:value-of select="current()/name"/>", 
    value: "<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
        'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')')),
        'label': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
		'status':string(translate(translate($status/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
        }"/>
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
    categories: [<xsl:for-each select="current()/own_slot_value[slot_reference='strategic_requirement_type']/value">"<xsl:value-of select="."/>"<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>], 
    required_by_date: "<xsl:value-of select="current()/own_slot_value[slot_reference='sr_required_by_date_ISO8601']/value"/>",
    required_from_date: "<xsl:value-of select="current()/own_slot_value[slot_reference='sr_required_from_date_ISO8601']/value"/>",
    resolved_by: [<xsl:for-each select="$resolutions">
        {
        id: "<xsl:value-of select="current()/name"/>", 
        value: "<xsl:value-of select="current()/name"/>", 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
                'label': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
                }"/>
        <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
           <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
        type: "<xsl:value-of select="current()/name"/>",
        start_date: "<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_from_date_iso_8601']/value"/>",
        end_date: "<xsl:value-of select="current()/own_slot_value[slot_reference='strategic_plan_valid_to_date_iso_8601']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>],

    rootCauses: [<xsl:for-each select="key('elements', current()/own_slot_value[slot_reference='sr_root_causes']/value)">{
					id: "<xsl:value-of select="current()/name"/>", 
					<xsl:variable name="combinedMap" as="map(*)" select="map{
							'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')), 
							'description': string(translate(translate(current()/own_slot_value[slot_reference = 'description']/value, '}', ')'), '{', ')'))
							}"/>
					<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
					<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
					type: "<xsl:value-of select="translate(current()/type, '_', ' ')"/>",
                    information:[]
                    }<xsl:if test="position()!=last()">,</xsl:if>
				</xsl:for-each>
				],
    sr_requirement_for_elements:[<xsl:for-each select="$elements">
    {
        id: "<xsl:value-of select="current()/name"/>", 
        value: "<xsl:value-of select="current()/name"/>", 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
                'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
                'label': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
                }"/>
            <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
           <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,
         type: "<xsl:value-of select="translate(current()/type, '_', ' ')"/>",
         impacts:[]}<xsl:if test="position()!=last()">,</xsl:if>
        </xsl:for-each>]
      } <xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="cats">
   {
    id: "<xsl:value-of select="current()/name"/>", 
    value: "<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
        'label': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
        }"/>
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
	<xsl:if test="current()/type='Strategic_Requirement_Category'">, 
		<xsl:variable name="thisTypes" select="key('issueType', current()/own_slot_value[slot_reference='sr_category_subtypes']/value)"/>
           types:[<xsl:for-each select="$thisTypes"> 
<xsl:variable name="issueCounts" select="key('issuesByType', current()/name)"/>
		   {"id":"<xsl:value-of select="current()/name"/>",
		   "count":<xsl:value-of select="count($issueCounts)"/>,
		   <xsl:variable name="combinedMap" as="map(*)" select="map{
			'name': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')')),
			'label': string(translate(translate(current()/own_slot_value[slot_reference = 'name']/value, '}', ')'), '{', ')'))
			}"/>
		<xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method': 'json', 'indent': true()})" />
		<xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>
	  		}  <xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			]
		</xsl:if>
   }<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
 
<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

</xsl:template>	
</xsl:stylesheet>