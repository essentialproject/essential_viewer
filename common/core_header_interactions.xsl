<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"  xmlns:user="http://www.enterprise-architecture.org/essential/vieweruserdata">
	<xsl:import href="../WEB-INF/security/viewer_security.xsl"/>
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_approvals.xsl"/>
	<xsl:import href="../common/core_comments.xsl"/>
	<xsl:import href="../common/core_ideas.xsl"/>
		
	<xsl:param name="param1"/>	
	<xsl:param name="theURLFullPath"/>
	<xsl:param name="X-CSRF-TOKEN"/>
	<xsl:param name="theCurrentXSL"/>
	<xsl:param name="eipMode"/>
	
	<xsl:variable name="sysIdeationConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Ideation Enabled')]/own_slot_value[slot_reference = 'report_constant_value']/value"/>
	<xsl:variable name="sysIdeationIsOn" select="string-length($sysIdeationConstant)"/>
	
	<xsl:variable name="thisRepoVersion" select="/node()/simple_instance[type='Meta_Model_Version'][1]/own_slot_value[slot_reference = 'meta_model_version_id']/value"/>
	<xsl:variable name="viewSubject" select="/node()/simple_instance[name = $param1]"/>
	
	<xsl:variable name="sysApprovalRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'SYS_CONTENT_APPROVER')]"/>
	<xsl:variable name="sysUser" select="/node()/simple_instance[own_slot_value[slot_reference = 'email']/value = $userData//user:email]"/>
	<xsl:variable name="sysUserAsApprover" select="/node()/simple_instance[(own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $sysUser/name) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $sysApprovalRole/name)]"/>
	<xsl:variable name="sysUserIsApprover">
		<xsl:choose>
			<xsl:when test="count($sysUserAsApprover) > 0">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="noSQLEssentialRefStoreUri">/essential-reference/v1/stores/<xsl:value-of select="$repositoryID"/>/collections</xsl:variable>
	<xsl:variable name="noSQLEssentialRefBatchStoreUri">/essential-reference-batch/v1/stores/<xsl:value-of select="$repositoryID"/>/collections</xsl:variable>
	
	<!-- Define a dictionary entry for the URLs of a given Data Set API -->
	<xsl:template mode="RenderViewerDataSetAPIDetails" match="node()">
		<xsl:param name="thisUserId"/>
		
		<xsl:variable name="userIdParam">&amp;essuser=<xsl:value-of select="$thisUserId"/></xsl:variable>
		<!-- Get the URL path for the data set -->
		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderLinkText">
				<xsl:with-param name="theXSL" select="current()/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
				<xsl:with-param name="theUserParams" select="$userIdParam"/>
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Get the property label to be used for accessing the data set details -->
		<xsl:variable name="dataSetLabel" select="current()/own_slot_value[slot_reference = 'dsa_data_label']/value"/>
		["<xsl:value-of select="$dataSetLabel"/>", "<xsl:value-of select="$dataSetPath"/>"]<xsl:if test="not(position() = last())">,
		</xsl:if>
	</xsl:template>
	

	
	<xsl:template name="RenderCommonAPIJS">
		<!-- Handlebars template to render a list in a drop down box-->
		<script id="ess-ea-element-list-template" type="text/x-handlebars-template">
			{{#each this}}
				<option/>
				<option>
					<xsl:attribute name="value">{{id}}</xsl:attribute>
		  			{{name}}
		  		</option>
			{{/each}}
		</script>
		
		
		<!-- Handlebars template to render a list in a drop down box-->
		<script id="ess-enum-list-template" type="text/x-handlebars-template">
			{{#each this}}
				<option/>
				<option>
					<xsl:attribute name="value">{{id}}</xsl:attribute>
		  			{{label}}
		  		</option>
			{{/each}}
		</script>
		
		
		<script type="text/javascript">
			var essEAElementListTemplate, essEnumListTemplate;
			const essEssentialSystemApiUri = '/essential-system/v1';
			const essEssentialAuditApiUri = '/essential-system/audit/v1';
			const essEssentialCoreApiUri = '/essential-core/v1';
			const essEssentialUtilv3ApiUri = '/essential-utility/v3';
			const essEssentialReferenceApiUri = '<xsl:value-of select="$noSQLEssentialRefStoreUri"/>';
			const essEssentialRefBatchApiUri = '<xsl:value-of select="$noSQLEssentialRefBatchStoreUri"/>';

			// define the global object to hold environment variables
			const essViewer = {};
			essViewer.repoId = '<xsl:value-of select="repository/repositoryID"/>';
			essViewer.baseUrl = '<xsl:value-of select="replace(concat(substring-before($theURLFullPath, '/report?'), ''), 'http://', 'https://')"></xsl:value-of>';	
			essViewer.currentXSL = '<xsl:value-of select="translate($theCurrentXSL, '/', '-')"/>';
			essViewer.user = {
				'id': '<xsl:value-of select="$userData//user:email"/>',
				'firstName': '<xsl:value-of select="$userData//user:firstname"/>',
				'lastName': '<xsl:value-of select="$userData//user:lastname"/>',
				'approvalClasses': [<xsl:apply-templates mode="RenderContentApprovalClass" select="$userData//user:className"/>],
				'TEST': '<xsl:value-of select="$userData//user:className"/>',
				'isApprover': <xsl:value-of select="$sysUserIsApprover"/>
			};


			// define the global object to hold environment variables
			// note we have to define this script in-line to make use of the xsl values
			<xsl:variable name="targetReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'report_xsl_filename']/value = $theCurrentXSL]"/>
			var essEnvironment = {};
			essEnvironment.form = {
				'id': '<xsl:value-of select="$targetReport/name"/>',
				'name': '<xsl:value-of select="$targetReport/own_slot_value[slot_reference = 'name']/value"/>'
			};


			
			function showViewSpinner(message) {
			    $('#view-spinner-text').text(message);                            
			    $('#view-spinner').removeClass('hidden');                         
			};
			
			function updateViewSpinner(message) {
			    $('#view-spinner-text').text(message);                                                    
			};
			
			function removeViewSpinner() {
			    $('#view-spinner').addClass('hidden');
			    $('#view-spinner-text').text('');
			};
			
			
			// function you can use to retrieve the PMA, subject id from a viewer url:
			function getViewerAPISubjectId(linkHref) {
			    var upTo = linkHref.split('PMA=')[1];
			    return upTo.split('&amp;')[0];
			}
			
			essViewer.viewerAPIData = {};
			essViewer.dataSetAPIUrls = {};
			
			function essAddViewerDataSetAPIUrls(apiDetailsList) {
				apiDetailsList.forEach(function(anAPI) {
					essViewer.dataSetAPIUrls[anAPI[0]] = anAPI[1];
				});
			}
				
			function essGetViewerDataSetAPIUrl(dataSetLabel, instanceId) {
				return essViewer.dataSetAPIUrls[dataSetLabel] + '&amp;PMA=' + instanceId;
			}
			
			function promise_getViewerAPIDataSet(thisDataSetURL) {
			    return new Promise(
			    function (resolve, reject) {
			        if (thisDataSetURL != null) {
			            var xmlhttp = new XMLHttpRequest();
			            xmlhttp.onreadystatechange = function () {
			                if (this.readyState == 4 &amp;&amp; this.status == 200) {
			                    var thisAPIData = JSON.parse(this.responseText);
			                    resolve(thisAPIData);
			                }
			            };
			            xmlhttp.onerror = function () {
			                console.log('Error loading modal data');
			                reject(false);
			            };
			            xmlhttp.open("GET", thisDataSetURL, true);
			            xmlhttp.send();
			        } else {
			            reject(false);
			        }
			    });
			};
			
			
			function promise_getViewerAPIData(apiDataSetName, instanceId) {
			    return new Promise(
			    function (resolve, reject) {
			        var thisDataSetURL = essGetViewerDataSetAPIUrl(apiDataSetName, instanceId);
			        if (thisDataSetURL != null) {
			            var xmlhttp = new XMLHttpRequest();
			            xmlhttp.onreadystatechange = function () {
			                if (this.readyState == 4 &amp;&amp; this.status == 200) {
			                    var thisAPIData = JSON.parse(this.responseText);
			                    resolve(thisAPIData);
			                }
			            };
			            xmlhttp.onerror = function () {
			                console.log('Error loading modal data');
			                reject(false);
			            };
			            xmlhttp.open("GET", thisDataSetURL, true);
			            xmlhttp.send();
			        } else {
			            reject(false);
			        }
			    });
			};
			
			//initialisation when view has loaded
			$(document).ready(function(){
				//compile the re-usable handlebars templates
				var essEAElementListFragment = $("#ess-ea-element-list-template").html();
				essEAElementListTemplate = Handlebars.compile(essEAElementListFragment);
				
				var essEnumListFragment = $("#ess-enum-list-template").html();
				essEnumListTemplate = Handlebars.compile(essEnumListFragment);
			});
			
		</script>
		
		<!-- Call the JS script to load the CSRF token -->
		<script defer="defer" src="common/js/ess-csrf.js?release=6.19"></script>
		
		<!--Include library containing common API platform functions for retrieving and updating repository data-->
		<script type="text/javascript" src="common/js/core_common_api_functions.js?release=6.19"/>
	</xsl:template>
	
	<xsl:template name="RenderInteractiveHeaderBars">
		<xsl:if test="($eipMode = 'true') and eas:compareVersionNumbers($thisRepoVersion, '6.6')">
			<div id="view-spinner" class="hidden">
				<div class="eas-logo-spinner" style="margin: 100px auto 10px auto; display: inline-block;">
					<div class="spin-icon" style="width: 60px; height: 60px;">
						<div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
						<div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
						<div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
					</div>						
				</div>
				<div id="view-spinner-text" class="text-center xlarge strong spin-text2"/>
			</div>
			
			<xsl:call-template name="RenderCommonAPIJS"/>
			
			<xsl:call-template name="approvalBar">
				<xsl:with-param name="viewSubject" select="$viewSubject"/>
				<xsl:with-param name="theUserId" select="$userData//user:lastname"/>
				<xsl:with-param name="theUserIsApprover" select="$sysUserIsApprover"/>
			</xsl:call-template>
			
			<xsl:call-template name="comments">
				<xsl:with-param name="viewSubject" select="$viewSubject"/>
			</xsl:call-template>
			<xsl:if test="$sysIdeationIsOn">
				<xsl:call-template name="ideas"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template mode="RenderContentApprovalClass" match="node()">
		"<xsl:value-of select="."/>"<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
	


</xsl:stylesheet>
