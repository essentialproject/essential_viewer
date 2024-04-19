<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../../common/core_utilities_NG.xsl"/>
	
	<xsl:param name="theCurrentXSL"/>

	<xsl:param name="scopingListsAPIConstantXML"/>
	<eas:apiRequests>
		
		{
			"apiRequestSet": [
				{
				"variable": "scopingListsAPIConstantXML",
				"query": "/instances/type/Report_Constant/slots?name=Default View Scoping Lists API"
				}
			]
		}
		
	</eas:apiRequests>
	<xsl:variable name="scopingListsAPIConstant" select="$scopingListsAPIConstantXML//simple_instance"/>

	<xsl:variable name="aScopeTimestamp" select="timestamp"/>
	<!--
	<xsl:variable name="userSettingsView" select="$utilitiesAllReports[own_slot_value[slot_reference = 'report_xsl_filename']/value = $theCurrentXSL]"/>
	<xsl:variable name="viewDefinedScopeAPI" select="$utilitiesAllDataSetAPIs[name = $userSettingsView[1]/own_slot_value[slot_reference = 'report_scoping_api']/value]"/>-->
	<xsl:key name="userSettingsViewKey" match="$utilitiesAllReports" use="own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
	<xsl:key name="viewDefinedScopeAPIKey" match="$utilitiesAllDataSetAPIs" use="name"/>
	<xsl:key name="utilitiesAllDataSetAPIsKey" match="$utilitiesAllDataSetAPIs" use="own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="userSettingsView" select="key('userSettingsViewKey', $theCurrentXSL)"/>
	<xsl:variable name="viewDefinedScopeAPI" select="key('viewDefinedScopeAPI', $userSettingsView[1]/own_slot_value[slot_reference = 'report_scoping_api']/value)"/>
	<xsl:variable name="scopingRepoID">
	<xsl:choose>
		<xsl:when test="repository/repositoryID">
			<xsl:value-of select="repository/repositoryID"/>
		</xsl:when>
		<xsl:otherwise>ess</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

	
	<!-- <xsl:variable name="scopeDataAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: View Scoping Data']"/> -->
    <xsl:variable name="scopeDataAPIUrl">
		<xsl:choose>
			<xsl:when test="$viewDefinedScopeAPI">
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$viewDefinedScopeAPI[1]/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!--
				<xsl:variable name="scopeDataAPI" select="$utilitiesAllDataSetAPIs[name = $scopingListsAPIConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>-->
				<xsl:variable name="scopeDataAPI" select="key('viewDefinedScopeAPIKey', $scopingListsAPIConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value)"/>
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$scopeDataAPI[1]/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>

	<xsl:variable name="defaultScopeColour">#666</xsl:variable>

	<xsl:template name="ViewUserSettingsUI">
		<script type="text/javascript" src="common/user-settings/core_common_user_settings_functions.js"/>
		<script>
			const essUserSettingsPublishTimestamp = '<xsl:value-of select="$aScopeTimestamp"/>';
			const essUserSettingsRepoId = '<xsl:value-of select="$scopingRepoID"/>';
			
			$('#shareLink').on('shown.bs.popover', function () {
				theURL=window.location.href;
				$('input#ess-page-link-url').val(theURL);
				$('.btn#ess-copy-page-link').click(function(){
					essCopyPageLink();
				});
				$('.closeSharePopover').click(function(){
					$('#shareLink').popover('hide');
				});
			})
		</script>
	</xsl:template>
	
	<xsl:template name="ViewUserScopingUI">
		<style>
			div.dataTables_wrapper {
				margin-top: 5px!important;
			}
			.dt-buttons {
				top: 0px;
				position: absolute!important;
			}
			
			.roadmap-buttons-wrapper {
				display: flex;
				align-items: center;
			}
			
			#viewpoint-bar{
				width: 100%;
				float: left;
				padding: 0px 15px;
				border-bottom: 1px solid #ccc;
				background-color: #eee;
				z-index: 999;
			}
			#scope-bar {
				background-color: #eee;
			}
			#scope-bar,#scope-panel,#roadmap-panel,#scenario-panel{
				width: 100%;
				float: left;
				padding: 5px 15px;
				border-bottom: 1px solid #ccc;
				box-shadow: 0px 0px 2px rgba(0,0,0,0.25) inset;
			}
			
			.ess-viewpoint-bar {display: flex; gap: 30px;}
			.ess-viewpoint-section {
			padding: 5px 0;
			display: flex;
			align-items: center;
			}
			.ess-scope-title{font-weight: 700; text-transform: uppercase;}
			.ess-scope-title:hover{cursor:pointer;}
			.ess-scenarios-wrapper{width: 150px; display: flex; gap: 10px;}
			.ess-scenario-select{background-color: #aaa; color: white; padding: 0 10px; text-align: center;}
			.ess-scenario-select:hover{cursor: pointer;}
			.ess-scenario-select.selected{background-color: #333; color: white}
			@media (max-width: 1600px) {
			.ess-viewpoint-bar {gap: 15px;}
			}
			@media (max-width: 1280px) {
			.ess-viewpoint-section {font-size:85%;}
			}
			@media (max-width: 1150px) {
			.ess-viewpoint-section {display:none;}
			}
			
			.panel-table-container {
				padding:10px;
				background-color:#fff;
				border: 1px solid #eee;
			}
			
			.ess-scope-blob-label {
				margin-bottom: 5px;
				width: 90%;
				line-height: 1.1em;
    			padding-bottom: 12px;
			}
			.ess-scope-blob {
				min-width: 160px;
				min-height: 40px;
			    padding: 5px;
			    background-color: #fff;
			    position: relative;
			    border: 1px solid;
			    margin: 0 10px 10px 0;
			    float: left;
			    box-shadow: 1px 1px 2px rgba(0,0,0,0.25);
			}
			.ess-scope-blob-typeicon {
				font-size: 10px;
				margin-top: 5px;
				position: absolute;
    			bottom: 2px;
			}
			.ess-scope-blob-icon {
			}
			.ess-scope-blob-type {
				text-transform: uppercase;
			}
			.ess-remove-scope-btn {
				position: absolute;
				top: 0px;
				right: 5px;
			}
			#ess-scoping-scope {
				width:100%;
				min-height: 40px;
				display: flex;
				flex-wrap: wrap;
			}
			.ess-remove-scope-icon:hover {
				cursor:pointer;
			}
			.ess-remove-scope-btn:hover {
				cursor:pointer;
			}
			.closeHeaderOverlay:hover {
				cursor:pointer;
			}

			.eas-label{background-color:#c41e3a; padding: 1px 3px;}
			.ess-filters-summary {
				position:relative;
				bottom:0px;
				right:10px;
				font-size:8pt;
				text-align:right;
			}
			
			.rm-animation-btn {
				border: none;
				padding: 0;
				background: transparent;
				margin: 0 10px 0 0;
			}

			#rmWidgetEndDateSelect {
				font-weight: bold;
			}

				.rmDate {
					float:left;
					margin-right:20px;
				}
				
				.rm-plain-text {
					color: #404040;
					font-weight: bold;
				}
				
				.rm-create-text {
					color: #4f8956;
					font-weight: bold;
				}
				
				.rm-enhance-text {
					color: #1B51A5;
					font-weight: bold;
				}
				
				.rm-reduce-text {
					color: #F59C3D;
					font-weight: bold;
				}
				
				.rm-remove-text {
					color: #ccc;
					font-weight: bold;
				}

				.month-picker-open-button {
					height: 26px;
					width: 24px;
					margin-bottom: 2px;
					border-radius:0 4px 4px 0;
					margin-left: -1px;
				}
				
				#ess-roadmap-widget-bar {
					<!--height: 35px;-->
					float: left;
					width: 100%;
					padding: 4px 10px;
					position: relative;
					top: 0px;
					z-index: 100;
					background-color: #f6f6f6;
					box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.5);
				}
				#ess-roadmap-widget-bar > div {
					
				}
				#ess-roadmap-widget-toggle {
					cursor: pointer;
				}

				.ess-roadmap-widget-active {
					color: #c3193c;
				}
				
				.ess-roadmap-widget-picker {
					color: black !important;
					width: 70px;
					text-align: center;
				}
				
				.month-picker {
					box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
				}
				
				.month-picker .ui-widget {
					font-family: 'Source Sans Pro', sans-serif;
					font-size: 0.9em;
				}
				
				.month-picker .ui-button {
					border: none;
					background: #eee;
					padding: .3em .9em;
				}
				
				.month-picker-year-table .ui-button {
					width: 100%!important;
				}
				
				.month-picker .ui-widget-header {
					border: none;
					background: #ccc;
					
				}
				
				.month-picker .ui-state-disabled {
					opacity: 1
				}
				
				.month-picker-previous > .ui-button,.month-picker-next > .ui-button{
					background: none;
					position: relative;
					top: -2px;
				}
				
				.rm-animation-btn {
					font-size: 1.4em;
				}
				
				.rm-animation-btn:hover {
					cursor: pointer;
				}
				
				.rm-btn-active {
					color: green;
				}
				
				.rm-btn-disabled {
					color: lightgrey !important;
					cursor: not-allowed !important;
				}
				
				.rm-animation-date-blink {
					animation-name: blink;
					animation-duration: 1500ms;
					animation-iteration-count: infinite;
				}

				#ess-rm-changes-end-date {
					color: #0855d1;
				}

				.ess-rm-changes-header {
					font-size: 1.2em;
					font-weight: bold;
				}
				
				@keyframes blink {
			    	0% {color: black;}
			    	50% {color: red;}
			    	100% {color: black;}
			    }
			    
			    .ess-scope-blob-color {
			    border-color: <xsl:value-of select="$defaultScopeColour"/>;
				color: <xsl:value-of select="$defaultScopeColour"/>;
			}
			</style>

		<script>
			const essScopeViewAPIURL = '<xsl:value-of select="$scopeDataAPIUrl"/>';
			
			function renderScenarioPanel(){
				var dtSCTable = $('#dt-scenario-table').DataTable({
					paging: false,
					deferRender:    true,
					scrollY:        350,
					scrollCollapse: true,
					info: true,
					sort: true,
					responsive: false,
					destroy: true
				});
								
				dtSCTable.columns.adjust();
				
				$(window).resize( function () {
					dtSCTable.columns.adjust();
				});
			}

			$(document).ready(function(){
				
				$(window).scroll(function() {
					if ($(this).scrollTop() &gt; 40) {
						$('#viewpoint-bar').css('position','fixed');
						$('#viewpoint-bar').css('top','0');
					}
					if ($(this).scrollTop() &lt; 40) {
						$('#viewpoint-bar').css('position','relative');
						$('#viewpoint-bar').css('top','auto');
					}
				});
			
				$('#edit-scope-btn').click(function(){
					$('#scope-panel').slideToggle();
					$('.ess-scope-title:not(#edit-scope-btn)').removeClass('ess-roadmap-widget-active');
					$('#edit-scope-btn').toggleClass('ess-roadmap-widget-active');
					if($(this).children('i').hasClass('fa-caret-down')){
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
						}
					else{
						$('.ess-scope-title > i').removeClass('fa-caret-down').addClass('fa-caret-right');
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
					};
					$('#roadmap-panel,#scenario-panel').slideUp();
				});
				
				$('#edit-roadmap-btn').click(function(){
					$('#roadmap-panel').slideToggle();
					
					$('.ess-scope-title:not(#edit-roadmap-btn)').removeClass('ess-roadmap-widget-active');
					$('#edit-roadmap-btn').toggleClass('ess-roadmap-widget-active');
					if($(this).children('i').hasClass('fa-caret-down')){
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
						}
					else{
						$('.ess-scope-title > i').removeClass('fa-caret-down').addClass('fa-caret-right');
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
					};
					$('#scope-panel,#scenario-panel').slideUp();
					setTimeout(renderRoadmapPanel(),500);
				});
				
				$('#edit-scenario-btn').click(function(){
					$('#scenario-panel').slideToggle();
					if($(this).children('i').hasClass('fa-caret-down')){
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
						}
					else{
						$('.ess-scope-title > i').removeClass('fa-caret-down').addClass('fa-caret-right');
						$(this).children('i').toggleClass('fa-caret-right fa-caret-down');
					};
					$('#roadmap-panel,#scope-panel').slideUp();
					setTimeout(renderScenarioPanel(),500);
				});
				
				$('#roadmap-panel > .closeHeaderOverlay,#scope-panel > .closeHeaderOverlay,#scenario-panel > .closeHeaderOverlay').click(function(){
					$('.ess-scope-title > i').removeClass('fa-caret-down').addClass('fa-caret-right');
					$('#edit-roadmap-btn').removeClass('ess-roadmap-widget-active');
					$('#edit-scope-btn').removeClass('ess-roadmap-widget-active');
				});
				
				// Select a scenario
				$('.ess-scenario-select').click(function(){
					$('.ess-scenario-select').removeClass('selected');
					$(this).addClass('selected');
				});
				
				$('[data-toggle="tooltip"]').tooltip();
				
				
			});
		</script>


		<script>
			<xsl:choose>
				<xsl:when test="count($roadmapPlansAPI) > 0 and count($roadmapsPlansProjectsAPI) > 0">
					const essPlannedChangesAPIURL = '<xsl:value-of select="$roadmapPlannedChangesAPIUrl"/>';
					const essRoadmapsPlansProjectsAPIURL = '<xsl:value-of select="$roadmapsPlansProjectsAPIUrl"/>';
				</xsl:when>
				<xsl:otherwise>
					const essPlannedChangesAPIURL = '';
					const essRoadmapsPlansProjectsAPIURL = '';
				</xsl:otherwise>
			</xsl:choose>
		</script>
		
		<!-- handlebars template for the a scoping dropdown list -->
		<script id="ess-scope-dropdown-list-template" type="text/x-handlebars-template">
			<option/>{{#each this}}<option><xsl:attribute name="value">{{id}}</xsl:attribute>{{name}}</option>{{/each}}
		</script>

		<!-- handlebars template for the a list of scoping values -->
		<script id="ess-scoping-value-template" type="text/x-handlebars-template">
			{{#each this}}
			<!-- NW to add dynamic colours here -->
				<div class="ess-scope-blob ess-scope-blob-color bottom-10">
					<xsl:attribute name="style">{{#if color}}border-color:{{color}};color:{{color}};{{/if}}</xsl:attribute>
					<div class="ess-scope-blob-label"><span class="ess-scope-blob-operand">{{#if isExcludes}}<span class="label label-danger eas-label right-5">Exclude</span>{{else}}{{/if}}</span>{{name}}</div>
					<div class="ess-scope-blob-typeicon">
						<span class="ess-scope-blob-icon right-5"><i><xsl:attribute name="class">fa {{#if icon}}{{icon}}{{else}}fa-cogs{{/if}}</xsl:attribute></i></span>
						<span class="ess-scope-blob-type">{{category}}</span>
					</div>
					<div class="ess-remove-scope-btn">
						<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
						<!-- <i><xsl:attribute name="class">fa {{icon}}</xsl:attribute></i> -->
						<i class="fa fa-times"/>
					</div>
				</div>
			{{/each}}
		</script>

		<!-- handlebars template for a selection checkbox in a table -->
		<script id="ess-rm-table-row-selection-template" type="text/x-handlebars-template">
			<div class="form-check form-switch">
				<input eas-id="{{id}}" type="checkbox" class="ess-row-select-chkbx form-check-input" checked="checked" role="switch"/>
			</div>
		</script>

		<!-- handlebars template for an instance name in a table -->
		<script id="ess-rm-table-instance-name-template" type="text/x-handlebars-template">
			<span><strong><i><xsl:attribute name="class">fa {{instance.icon}} right-5</xsl:attribute></i>{{instance.name}}</strong></span>
		</script>

		<!-- handlebars template for an instance type in a table -->
		<script id="ess-rm-table-instance-type-template" type="text/x-handlebars-template">
			<span><strong>{{instance.type}}</strong></span>
		</script>

		<!-- handlebars template for a planned change in a table -->
		<script id="ess-rm-table-planned-change-template" type="text/x-handlebars-template">
			<span><xsl:attribute name="style">color:{{planningAction.colour}};</xsl:attribute><i><xsl:attribute name="class">fa {{planningAction.icon}} right-5</xsl:attribute></i>{{planningAction.name}}</span>
		</script>

		<!-- handlebars template for an instance list -->
		<script id="ess-rm-table-instance-list-template" type="text/x-handlebars-template">
			<ul>
				{{#each this}}
					<li>{{name}}</li>
				{{/each}}
			</ul>
		</script>


		<div class="clearfix"/>
		<div id="viewpoint-bar">
			<div class="ess-viewpoint-bar">
				<div class="ess-viewpoint-section">
					<span class="ess-scope-title uppercase">
						<i class="fa fa-binoculars right-5"/>Essential Viewpoint
					</span>
				</div>
				<!--Scope Section-->
				<div class="ess-viewpoint-section">
					<div id="edit-scope-btn" class="ess-scope-title right-10"><i class="fa fa-caret-right fa-fw"/>Scope</div>
					<div class="btn btn-xs btn-success ess-flex right-10">Active</div>
					<!--<strong class="right-5">Current scope:</strong>-->
					<!--<span id="ess-scope-summary" />-->
					<span><span id="scope-filter-count">0</span> filters applied</span>
					<!--<div>
						<span class="label label-success right-15"><i class="fa fa-check-circle right-5"/>Scope Is Active</span>
						<!-\-<span class="label label-default right-15 hiddenDiv"><i class="fa fa-times-circle right-5"/>Scope Is Inactive</span>
						<button id="edit-scope-btn" class="btn btn-xs btn-default">Edit Scope</button>-\->
					</div>-->
					<script>
						function enabledRoadmapButton(){
						$('#ess-roadmap-widget-toggle').parent().removeClass('disabled');
						}
						enabledRoadmapButton();
					</script>
				</div>
				<!--Roadmap Section-->
				<div id="roadmap-filter-wrapper" class="ess-viewpoint-section">
					<div id="edit-roadmap-btn" class="ess-scope-title right-10"><i class="fa fa-caret-right fa-fw"/>Roadmap</div>
					<div id="rmActiveButton" class="btn btn-xs btn-success ess-flex right-10 rmActive" style="width: 60px;">Active</div>
					<div class="roadmap-buttons-wrapper right-15" >
						<div>
							<div class="left-10">
								<button id="playRoadmap" class="rm-animation-btn right-10"><i class="fa fa-play-circle"/></button>
								<button id="pauseRoadmap" class="rm-animation-btn rm-btn-disabled right-10" disabled="true"><i class="fa fa-pause-circle"/></button>
								<button id="resetRoadmap" class="rm-animation-btn rm-btn-disabled" disabled="true"><i class=" fa fa-history"/></button>
							</div>
						</div>
						<div style="display: inline-block;">
							<span class="right-5"><strong>From:</strong></span>
							<span id="rm-button-active">
								<input id="rmWidgetEndDateSelect" class="ess-roadmap-widget-picker" type="text"/>
							</span>
						</div>
						
					</div>
					<span id="roadmap-filter-count-wrapper"><span id="roadmap-filter-count">0</span> changes planned</span>
				</div>
				<!--Scenario Section-->
				<!--<div class="ess-viewpoint-section">
					<div id="edit-scenario-btn" class="ess-scope-title right-10"><i class="fa fa-caret-right fa-fw"/>Scenario</div>
					<div class="btn btn-xs btn-success ess-flex right-10 scenarioActive" style="width: 60px;">Active</div>
					<div class="ess-scenarios-wrapper" style="display: flex; gap: 5px;">
						<div class="ess-scenario-select" data-toggle="tooltip" data-placement="bottom" title="Name of scenario 1">1</div>
						<div class="ess-scenario-select selected" data-toggle="tooltip" data-placement="bottom" title="Name of scenario 2">2</div>
						<div class="ess-scenario-select" data-toggle="tooltip" data-placement="bottom" title="Name of scenario 3">3</div>
						<div class="ess-scenario-select" data-toggle="tooltip" data-placement="bottom" title="Name of scenario 4">4</div>
						<div class="ess-scenario-select" data-toggle="tooltip" data-placement="bottom" title="Name of scenario 5">5</div>
					</div>
				</div>-->
			</div>
		</div>
		<!--Scope Panel-->
		<div id="scope-panel" class="bg-offwhite headerOverlay hiddenDiv">
			<i class="fa fa-times closeHeaderOverlay"/>
			<div class="xlarge bottom-15 strong"><i class="fa fa-sliders right-10"/>Scope</div>
			<div>
				<div class="row">
					<div class="col-sm-6 col-md-4 col-lg-3">
						<label for="ess-scoping-category-list" class="fontBold">Category</label>
						<select id="ess-scoping-category-list" style="width:100%" class="inputStyle"/>
					</div>
					<div class="col-sm-6 col-md-4 col-lg-3">
						<label for="ess-scoping-value-list" class="fontBold">Select a <span id="ess-scope-value-label">Value</span></label>
						<select id="ess-scoping-value-list" style="width:100%" class="inputStyle" disabled="true"/>
					</div>
					<div class="col-sm-6 col-md-4 col-lg-3">
						<label>&#160;</label>
						<div>
							<button id="ess-add-scoping-value-btn" class="btn btn-default right-15" disabled="true"><i class="fa fa-plus-circle right-5 text-success"/>Includes</button>
							<button id="ess-add-exl-scoping-value-btn" class="btn btn-default" disabled="true"><i class="fa fa-minus-circle right-5 text-danger"/>Excludes</button>
						</div>
					</div>
				</div>
				<div class="row">	
					<div class="col-md-12 top-10">
						<label for="ess-scoping-scope" class="fontBold">Current Scope</label>
						<div id="ess-scoping-scope"/>
					</div>
					<div class="col-md-12 top-5">
						<div class="ess-filters-summary">
							<span><strong>Available Filters: </strong></span>
							<span id="ess-filter-scope-summary"></span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--Roadmap Panel-->
		<div id="roadmap-panel" class="bg-offwhite headerOverlay hiddenDiv">
			<i class="fa fa-times closeHeaderOverlay"/>
			<div class="xlarge bottom-15 strong"><i class="fa fa-sliders right-10"/>Roadmap</div>
			<div class="panel-table-container">
				<div class="ess-rm-changes-header top-5"><xsl:value-of select="eas:i18n(('Planned Changes up to '))"/><span id="ess-rm-changes-end-date"></span></div>
				<table id="dt-roadmap-table-changes" class="table table-bordered table-striped table-condensed top-15 bottom-15">
					<thead>
						<tr>
							<th><xsl:value-of select="eas:i18n('Changed Element')"/></th>
							<th><xsl:value-of select="eas:i18n('Type')"/></th>
							<th><xsl:value-of select="eas:i18n('Description')"/></th>
							<th><xsl:value-of select="eas:i18n('Planned Change')"/></th>
							<th><xsl:value-of select="eas:i18n('Completion Date')"/></th>
							<th><xsl:value-of select="eas:i18n('Part of Plan')"/></th>
							<th><xsl:value-of select="eas:i18n('In Roadmaps')"/></th>
							<th><xsl:value-of select="eas:i18n('Implemented By')"/></th>
						</tr>
					</thead>
					<tbody>
					</tbody>
					<tfoot>
						<tr>
							<th><xsl:value-of select="eas:i18n('Changed Element')"/></th>
							<th><xsl:value-of select="eas:i18n('Type')"/></th>
							<th><xsl:value-of select="eas:i18n('Description')"/></th>
							<th><xsl:value-of select="eas:i18n('Planned Change')"/></th>
							<th><xsl:value-of select="eas:i18n('Completion Date')"/></th>
							<th><xsl:value-of select="eas:i18n('Strategic Plans')"/></th>
							<th><xsl:value-of select="eas:i18n('Roadmaps')"/></th>
							<th><xsl:value-of select="eas:i18n('Projects')"/></th>
						</tr>
					</tfoot>
				</table>

				<!-- <div class="bottom-15">
					<label>Filter by:</label>
					<select id="ess-roadmap-type-filter" style="width: 160px;">
						<option>Project</option>
						<option>Strategic Plan</option>
						<option>Roadmap</option>
					</select>
				</div> -->
				
				<!-- <ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="#ess-roadmap-tabs-filter" aria-controls="ess-roadmap-tabs-filter" role="tab" data-toggle="tab">Roadmap Filters</a></li>
					<li role="presentation" class="active"><a href="#ess-roadmap-tabs-changes" aria-controls="ess-roadmap-tabs-changes" role="tab" data-toggle="tab">Applied Changes</a></li>
				</ul>
				
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="ess-roadmap-tabs-filter">
						<div class="clearfix top-15"/>
						<table id="dt-roadmap-table-filter" class="table table-bordered table-striped table-condensed top-15 bottom-15">
							<thead>
								<tr>
									<th width="24px">&#160;</th>
									<th>Name</th>
									<th>Description</th>
									<th>Dates</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td><input type="checkbox"/></td>
									<td>Project 1</td>
									<td>Some Description</td>
									<td>Dates here</td>
								</tr>
								<tr>
									<td><input type="checkbox"/></td>
									<td>Project 2</td>
									<td>Some Description</td>
									<td>Dates here</td>
								</tr>
								<tr>
									<td><input type="checkbox"/></td>
									<td>Plan 1</td>
									<td>Some Description</td>
									<td>Dates here</td>
								</tr>
								<tr>
									<td><input type="checkbox"/></td>
									<td>Roadmap 1</td>
									<td>Some Description</td>
									<td>Dates here</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<th width="24px">&#160;</th>
									<th>Name</th>
									<th>Description</th>
									<th>Dates</th>
								</tr>
							</tfoot>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane active" id="ess-roadmap-tabs-changes">
						<div class="clearfix top-15"/>
						<table id="dt-roadmap-table-changes" class="table table-bordered table-striped table-condensed top-15 bottom-15">
							<thead>
								<tr>
									<th>Changed Element</th>
									<th>Type</th>
									<th>Description</th>
									<th>Planned Change</th>
									<th>Completion Date</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
							<tfoot>
								<tr>
									<th>Changed Element</th>
									<th>Type</th>
									<th>Description</th>
									<th>Planned Change</th>
									<th>Completion Date</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div> -->
				
				
			</div>
			<div class="clearfix bottom-15"/>
		</div>
		<!--Scenario Panel-->
		<!--<div id="scenario-panel" class="bg-offwhite headerOverlay hiddenDiv">
			<i class="fa fa-times closeHeaderOverlay"/>
			<div class="xlarge bottom-15 strong"><i class="fa fa-sliders right-10"/>Scenario</div>
			<div class="panel-table-container">
				<div>
					<span class="large strong right-15">Select up to 5 scenarios:</span>
					<span class="label label-info right-10">1: Selected Scenario 1</span>
					<span class="label label-info right-10">2: Selected Scenario 2</span>
					<span class="label label-info right-10">3: Selected Scenario 3</span>
					<span class="label label-info right-10">4: Selected Scenario 4</span>
					<span class="label label-info right-10">5: Selected Scenario 5</span>
				</div>
				<table id="dt-scenario-table" class="table table-bordered table-striped table-condensed top-15">
					<thead>
						<tr>
							<th width="24px">&#160;</th>
							<th>Name</th>
							<th>Description</th>
							<th>Author</th>
							<th>Need / Requirement</th>
							<th>Last Updated</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="checkbox"/></td>
							<td>Scenario 1</td>
							<td>Some Description</td>
							<td>Neil Walsh</td>
							<td></td>
							<td>01-03-2022</td>
						</tr>
						<tr>
							<td><input type="checkbox"/></td>
							<td>Scenario  2</td>
							<td>Some Description</td>
							<td>Jason Powell</td>
							<td><span class="label label-default right-10">tag1</span><span class="label label-default right-10">tag2</span><span class="label label-default right-10">tag3</span></td>
							<td>01-03-2022</td>
						</tr>
						<tr>
							<td><input type="checkbox"/></td>
							<td>Scenario  1</td>
							<td>Some Description</td>
							<td>John Mayall</td>
							<td></td>
							<td>01-03-2022</td>
						</tr>
						<tr>
							<td><input type="checkbox"/></td>
							<td>Scenario  1</td>
							<td>Some Description</td>
							<td>Sarah Smith</td>
							<td></td>
							<td>01-03-2022</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="clearfix bottom-15"/>
		</div>-->

		<!-- JQuery Month Picker plug-in -->
		<link href="js/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css" />
			<link href="js/jquery-ui/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" />
		<link href="js/jquery-ui-month-picker/MonthPicker.min.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="js/jquery.maskedinput.min.js"/>
		<script type="text/javascript" src="js/jquery-ui-month-picker/MonthPicker.min.js"/>
	</xsl:template>

	<xsl:template name="GetReportFilterExcludedSlots">
		<xsl:param name="theReport"/>
		<xsl:variable name="excludedSlots" select="$theReport/own_slot_value[slot_reference = 'report_filter_excluded_slots']/value"/>
		<xsl:for-each select="$excludedSlots">"<xsl:value-of select="."/>"<xsl:if test="position() != last()">, </xsl:if></xsl:for-each>
	</xsl:template>
	
<!--
	<xsl:variable name="roadmapPlansAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Roadmap Planned Changes API']"/>-->
	<xsl:variable name="roadmapPlansAPI" select="key('utilitiesAllDataSetAPIsKey', 'System: Roadmap Planned Changes API')"/>
	
    <xsl:variable name="roadmapPlannedChangesAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$roadmapPlansAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
    </xsl:variable>
<!--
	<xsl:variable name="roadmapsPlansProjectsAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'System: Roadmaps, Plans and Projects API']"/>-->
	<xsl:variable name="roadmapsPlansProjectsAPI" select="key('utilitiesAllDataSetAPIsKey', 'System: Roadmaps, Plans and Projects API')"/>
	<xsl:variable name="roadmapsPlansProjectsAPIUrl">
		<xsl:call-template name="RenderAPILinkText">
			<xsl:with-param name="theXSL" select="$roadmapsPlansProjectsAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
    </xsl:variable>
	
	<xsl:template name="RoadmapEnablementJSUI">
		<style>
			
		</style>

		<script>
			<xsl:choose>
				<xsl:when test="count($roadmapPlansAPI) > 0 and count($roadmapsPlansProjectsAPI) > 0">
					const essPlannedChangesAPIURL = '<xsl:value-of select="$roadmapPlannedChangesAPIUrl"/>';
					const essRoadmapsPlansProjectsAPIURL = '<xsl:value-of select="$roadmapsPlansProjectsAPIUrl"/>';
				</xsl:when>
				<xsl:otherwise>
					const essPlannedChangesAPIURL = '';
					const essRoadmapsPlansProjectsAPIURL = '';
				</xsl:otherwise>
			</xsl:choose>
		</script>
		
		<!-- handlebars template for the Roadmap Enablement UI -->
		<script id="ess-rm-enablement-template" type="text/x-handlebars-template">
			<option/>{{#each this}}<option><xsl:attribute name="value">{{id}}</xsl:attribute>{{name}}</option>{{/each}}
		</script>
	</xsl:template>
	
</xsl:stylesheet>