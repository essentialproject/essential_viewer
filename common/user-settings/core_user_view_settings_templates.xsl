<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="3.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../../common/core_utilities.xsl"/>
	
	<xsl:param name="theCurrentXSL"/>

	<xsl:variable name="aScopeTimestamp" select="timestamp"/>
	
	<xsl:variable name="userSettingsView" select="$utilitiesAllReports[own_slot_value[slot_reference = 'report_xsl_filename']/value = $theCurrentXSL]"/>
	<xsl:variable name="viewDefinedScopeAPI" select="$utilitiesAllDataSetAPIs[name = $userSettingsView[1]/own_slot_value[slot_reference = 'report_scoping_api']/value]"/>

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
					<xsl:with-param name="theXSL" select="$viewDefinedScopeAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="scopingListsAPIConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default View Scoping Lists API')]"/>
				<xsl:variable name="scopeDataAPI" select="$utilitiesAllDataSetAPIs[name = $scopingListsAPIConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
				<xsl:call-template name="RenderAPILinkText">
					<xsl:with-param name="theXSL" select="$scopeDataAPI/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
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
			#scope-bar {
				background-color: #eee;
			}
			#scope-bar,#scope-panel{
				width: 100%;
				float: left;
				padding: 5px 15px;
				border-bottom: 1px solid #ccc;
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
			.ess-scope-blob-color {
				border-color: <xsl:value-of select="$defaultScopeColour"/>;
    			color: <xsl:value-of select="$defaultScopeColour"/>;
			}
			.eas-label{background-color:#c41e3a; padding: 1px 3px;}
		</style>

		<script>
			const essScopeViewAPIURL = '<xsl:value-of select="$scopeDataAPIUrl"/>';

			$(document).ready(function(){
				$('#edit-scope-btn').click(function(){
					$('#scope-panel').slideToggle();
				});
			});
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
		<div class="clearfix"/>
		<div id="scope-bar">
			<div class="row">
				<div class="col-md-8 text-left">
					<span class="fontMedium"><strong>Current scope:</strong><span id="ess-scope-summary" class="left-5"></span></span>		
				</div>
				<div class="col-md-4 text-right">
					<span class="label label-success right-15"><i class="fa fa-check-circle right-5"/>Scope Is Active</span>
					<span class="label label-default right-15 hiddenDiv"><i class="fa fa-times-circle right-5"/>Scope Is Inactive</span>
					<button id="edit-scope-btn" class="btn btn-xs btn-default">Edit Scope</button>
				</div>
			</div>
		</div>
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
						<label for="ess-scoping-value-list" class="fontBold">Select a <span id="ess-scope-value-label">Geography</span></label>
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
				</div>
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>