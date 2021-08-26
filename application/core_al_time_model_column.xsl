<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"></xsl:variable>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="timeVals" select="/node()/simple_instance[type = ('Disposition_Lifecycle_Status')]"></xsl:variable>
	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')][own_slot_value[slot_reference = 'ap_disposition_lifecycle_status']/value = $timeVals/name]"></xsl:variable>
	<xsl:variable name="styles" select="/node()/simple_instance[type = ('Element_Style')]"></xsl:variable>
	<!-- ***REQUIRED*** DETERMINE IF ANY RELEVANT INSTANCES ARE ROADMAP ENABLED -->
	<xsl:variable name="allRoadmapInstances" select="($apps)"></xsl:variable>
	<xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"></xsl:variable>

	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>Application Disposition Model</title>
				<style>
                    .ess-tag-dotted {
                    	border: 2px dashed #222;
                    }
                    
                    .ess-tag-dotted > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag-default {
                    	background-color: #fff;
                    	color: #333;
                    	border: 2px solid #222;
                    }
                    
                    .ess-tag-default > a{
                    	color: #333!important;
                    }
                    
                    .ess-tag {
                    	padding: 3px 12px;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    	
					}
					.ess-tag-key {
                    	padding: 3px 12px;
                    	border-radius: 16px;
                    	margin-right: 10px;
                    	margin-bottom: 5px;
                    	display: inline-block;
                    	font-weight: 700;
                    	
                    }
				</style>
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"></xsl:with-param>
				</xsl:call-template>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
				<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"></xsl:call-template>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<!-- ***REQUIRED*** TEMPLATE TO RENDER THE COMMON ROADMAP PANEL AND ASSOCIATED JAVASCRIPT VARIABLES AND FUNCTIONS -->
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"></xsl:with-param>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"></xsl:with-param>
					</xsl:call-template>

					<div class="clearfix"></div>
				</div>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Application Disposition Model')"></xsl:value-of>
									</span>
								</h1>
							</div>
						</div>

						<div class="col-xs-12">
							<div class="row">
								<div class="col-sm-6">
									<div class="input-group">
										<span class="input-group-addon"><i class="fa fa-search"/></span>
										<input type="text" class="form-control" id="applyFilter" placeholder="Filter..." style="width: 200px;"/>
									</div>
								</div>
								<div class="col-sm-6">
									<div class="pull-right top-10 bottom-5">
										<strong class="right-10">Legend:</strong>
										<div class="ess-tag-key ess-tag-default">
											<a><xsl:value-of select="eas:i18n('Active Application')"></xsl:value-of></a>
										</div>
									<!--<div class="ess-tag ess-tag-dotted">
											<a><xsl:value-of select="eas:i18n('Retired')"></xsl:value-of></a>
										</div>
									-->
									</div>
								</div>
							</div>
							<table class="table table-bordered">
								<thead>
									<tr>
										<xsl:apply-templates select="$timeVals" mode="timeHead"></xsl:apply-templates>
									</tr>
								</thead>
								<tbody>
									<tr>
										<xsl:apply-templates select="$timeVals" mode="timeData"></xsl:apply-templates>
									</tr>
								</tbody>
							</table>
						</div>


						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
			<script id="disposition-template" type="text/x-handlebars-template"></script>
			<script>
				var timeJSON = [<xsl:apply-templates select="$timeVals" mode="timeJSON"/>];
				var applications = {
					applications: [<xsl:apply-templates select="$apps" mode="getApplications"/>]
				};
				var inScopeApplications=[];
				// console.log(timeJSON)
				// console.log(applications)
				var newList=[];
				$('document').ready(function () {
					var dispostionFragment = $("#disposition-template").html();
				    var dispostionTemplate = Handlebars.compile(dispostionFragment);
					redrawView()


					$('#applyFilter').on('keyup',function(){
							 
							let pattern=$(this).val().toUpperCase(); 
							newList=applications.applications.filter((d)=>{
								return d.name.toUpperCase().includes(pattern)
							})
					 
							$('.ess-tag').hide();
							redrawView()
					})	
				});

				function redrawView() {
					<xsl:if test="$isRoadmapEnabled">
					// console.log('Redrawing View');
					
					//update the roadmap status of the applications and application provider roles passed as an array of arrays
					rmSetElementListRoadmapStatus([applications.applications]);
					
					if(newList.length&gt;0){ 
						inScopeApplications.applications =rmGetVisibleElements(newList);
					}
					else
					{
					//filter applications to those in scope for the roadmap start and end date
					inScopeApplications.applications = rmGetVisibleElements(applications.applications);
					}
				 
					$('.ess-tag').hide();
					drawApps(inScopeApplications.applications)
					</xsl:if>
				}

				function drawApps(ele){
					ele.forEach(element => {
						$('[easid="'+element.id+'"]').show();
						$('[easid="'+element.id+'"]').css({'border-color': element.colour});
						$('[easid="'+element.id+'"]').addClass('ess-tag-default');
					});
				}
			</script>

		</html>
	</xsl:template>
	<xsl:template match="node()" mode="timeHead">
		<xsl:variable name="this" select="current()"></xsl:variable>
		<xsl:variable name="tcount" select="count($timeVals)"></xsl:variable>
		<xsl:variable name="thisStyle" select="$styles[name = current()/own_slot_value[slot_reference = 'element_styling_classes']/value]"></xsl:variable>

		<th class="bg-offwhite">
			<xsl:attribute name="width"><xsl:value-of select="100 div $tcount"></xsl:value-of>%</xsl:attribute>
			<div class="keySample">
				<xsl:attribute name="style">background-color:<xsl:value-of select="$thisStyle/own_slot_value[slot_reference='element_style_colour']/value"/></xsl:attribute>
			</div>
			<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"></xsl:value-of>
		</th>
	</xsl:template>
	<xsl:template match="node()" mode="timeData">
		<xsl:variable name="this" select="current()"></xsl:variable>
		<xsl:variable name="thisApps" select="$apps[own_slot_value[slot_reference = 'ap_disposition_lifecycle_status']/value = $this/name]"></xsl:variable>

		<td class="tabcolumn">
			<xsl:for-each select="$thisApps">
				<div class="ess-tag ess-tag-dotted">
					<xsl:attribute name="easid">
						<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>
					</xsl:attribute>
					<xsl:call-template name="RenderInstanceLink">
						<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
					</xsl:call-template>
				</div>
			</xsl:for-each>
		</td>
	</xsl:template>

	<xsl:template match="node()" mode="timeJSON">
		<xsl:variable name="this" select="current()"></xsl:variable>
		<xsl:variable name="thisApps" select="$apps[own_slot_value[slot_reference = 'ap_disposition_lifecycle_status']/value = $this/name]"></xsl:variable> {"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>", "name":"<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param>
			<xsl:with-param name="isRenderAsJSString" select="true()"></xsl:with-param>
		</xsl:call-template>", "apps":[<xsl:for-each select="$thisApps">{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"></xsl:value-of>","link":"<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"></xsl:with-param></xsl:call-template>"}<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position() != last()">,</xsl:if>
	</xsl:template>
	<xsl:template match="node()" mode="getApplications">
		<xsl:variable name="thisAppDisp" select="$timeVals[name = current()/own_slot_value[slot_reference = 'ap_disposition_lifecycle_status']/value]"></xsl:variable>
		<xsl:variable name="thisStyle" select="$styles[name = $thisAppDisp/own_slot_value[slot_reference = 'element_styling_classes']/value]"></xsl:variable>
		{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"></xsl:with-param><xsl:with-param name="theRoadmapInstance" select="current()"></xsl:with-param><xsl:with-param name="theDisplayInstance" select="current()"></xsl:with-param><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"></xsl:with-param></xsl:call-template>, <!-- codebase: "<xsl:value-of select="translate($thisAppCodebase/name, '.', '_')"/>",
			delivery: "<xsl:value-of select="translate($thisAppDeliveryModel/name, '.', '_')"/>"  --> "colour":"<xsl:value-of select="$thisStyle/own_slot_value[slot_reference = 'element_style_colour']/value"></xsl:value-of>" } <xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>
</xsl:stylesheet>
