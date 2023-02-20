<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    <xsl:import href="../enterprise/core_el_issue_functions.xsl"/>
	<xsl:import href="../common/core_strategic_plans.xsl"/>
    <xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_arch_image.xsl"/>
	<xsl:include href="../common/core_external_repos_ref.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>



	<xsl:output method="html"/>
	<xsl:param name="param1"/>
	<xsl:variable name="currentProcess" select="/node()/simple_instance[name = $param1]"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->
	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Process', 'Business_Role', 'Business_Capability', 'Group_Actor', 'Individual_Actor', 'Site','Composite_Application_Service', 'Application_Service', 'Composite_Application_Provider', 'Application_Provider', 'Information_Concept', 'Information_View', 'Business_Strategic_Plan')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Required View-specific instance -->
	<xsl:variable name="allIndividualActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="businessCapability" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="processManagerRole" select="/node()/simple_instance[(type = 'Individual_Business_Role') and (own_slot_value[slot_reference = 'name']/value = 'Process Manager')]"/>
	<xsl:variable name="allProcesses" select="/node()/simple_instance[(type = 'Business_Process')]"/>

	<xsl:variable name="standardisation_level" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'standardisation_level']/value]"/>
	<xsl:variable name="phys_process_list" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value]"/>
	<xsl:variable name="allPhysProcessActorRelations" select="/node()/simple_instance[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
	<xsl:variable name="allPhysProcessDirecActors" select="$allPhysProcessActorRelations[type = 'Group_Actor']"/>
	<xsl:variable name="allPhysProcessActorsViaRoles" select="/node()/simple_instance[name = $allPhysProcessActorRelations/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allPhysProcessActors" select="$allPhysProcessDirecActors union $allPhysProcessActorsViaRoles"/>
	
	<xsl:variable name="allPhysProcessSites" select="$allSites[name = $phys_process_list/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
	<xsl:variable name="allPhysProcActorSites" select="$allSites[name = $allPhysProcessActors/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
	<xsl:variable name="allPhysProcAppRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcAppProRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = $phys_process_list/name]"/>
	
	<xsl:variable name="allPhysProcApp2Roles" select="/node()/simple_instance[name = $allPhysProcAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="directApps" select="/node()/simple_instance[name = $allPhysProcAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
	<xsl:variable name="indirectApps" select="/node()/simple_instance[name = $allPhysProcApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
	<xsl:variable name="allPhysProcSupportingApps" select="$directApps union $indirectApps"/>
	
	<xsl:variable name="appSvs" select="/node()/simple_instance[type = 'Application_Service'][own_slot_value[slot_reference='provided_by_application_provider_roles']/value=$allPhysProcApp2Roles/name]"/>
	
	<!--<xsl:variable name="allPhysProcApp2Roles" select="/node()/simple_instance[name = $allPhysProcAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
	<xsl:variable name="allPhysProcSupportingApps" select="$allApps[name = $allPhysProcApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>-->
	

	<xsl:variable name="allPhysProcApp2InfoRelations" select="/node()/simple_instance[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value = $phys_process_list/name]"/>
	<xsl:variable name="allPhysProcApp2Infos" select="/node()/simple_instance[name = $allPhysProcApp2InfoRelations/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value]"/>
	<xsl:variable name="allPhysProcSupportingInfoApps" select="$allApps[name = $allPhysProcApp2Infos/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>
    <xsl:variable name="inScopeCosts" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $currentProcess/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
    <xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>

	<xsl:variable name="maxDepth" select="10"/>

	<xsl:variable name="currentBusinessCapability" select="$businessCapability[name=$currentProcess/own_slot_value[slot_reference='realises_business_capability']/value]"/>	
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
	<!-- 15.06.2016 JP 	Refactored to improve performance. -->

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Business Process Summary')"/>
				</title>
				<script type="text/javascript" src="js/jquery.columnizer.js"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentProcess" mode="Page_Content"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				
				<script id="caps-template" type="text/x-handlebars-template">
					{{#each this}}
					<li>{{{this.link}}} {{#if this.type}}{{else}}<span style="font-size:0.8em">(via a parent)</span>{{/if}}</li>
					{{/each}}
				</script>
			
<script id="proc-template" type="text/x-handlebars-template">
{{#each this}}
	 {{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
		<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
			<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{#if this.subProcess}}<button style="height:20px; border:none; background-color:#ffffff" easid="but" data-toggle="collapse"><xsl:attribute name="data-target">#{{this.id}}</xsl:attribute><i class="fa fa-caret-up"></i></button>{{/if}}<br/>
			<div class="collapse"><xsl:attribute name="id">{{this.id}}</xsl:attribute>
				<div style="padding-left:15px">{{#each this.subProcess}}- {{{this.link}}}{{/each}}</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
			</div>
			{{/each}}
			</div>
		</div>
		{{/each}}
{{/each}}
</script>						
			</body>
		</html>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE PAGE BODY -->
	<xsl:template match="node()" mode="Page_Content">
		<!-- Get the name of the business process -->
		<xsl:variable name="processName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<div class="container-fluid">
			<div class="row">

				<div class="col-xs-12">
					<div class="page-header">
						<h1>
							<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
							<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Process Summary for')"/>&#160;</span>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$currentProcess"/>
								<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
							</xsl:call-template>
						</h1>
					</div>
				</div>

				<!--Setup the Definition section-->

				<div class="col-xs-9"> 
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="string-length($currentProcess/own_slot_value[slot_reference = 'description']/value) = 0">
								<span>-</span>
							</xsl:if>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="$currentProcess"/>
							</xsl:call-template>
						</p>
					</div>
					<hr/>
				</div>
				<xsl:if test="$currentProcess/own_slot_value[slot_reference = 'business_process_id']/value">
					<div class="col-xs-3"> 
						<div class="sectionIcon">
							<i class="fa fa-hashtag icon-section icon-color"/> 
						</div>
						<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('ID')"/>
					</h2>
					<h2><span style="color:#000"><xsl:value-of select="$currentProcess/own_slot_value[slot_reference = 'business_process_id']/value"/></span></h2>
					</div> 
				
				</xsl:if>


				<!--Setup the Standardisation section-->

				<div class="col-xs-6">
					<div class="sectionIcon">
						<i class="fa fa-check icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Standardisation Level')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="not(string($standardisation_level))">
								<em>
									<xsl:value-of select="eas:i18n('Standardisation level not defined for this process')"/>
								</em>
							</xsl:if>
							<xsl:value-of select="$standardisation_level/own_slot_value[slot_reference = 'enumeration_value']/value"/>
						</p>
					</div>
					<hr/>
				</div>
                    <!-- Process Costs  -->
       
                                
                                <xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($inScopeCostComponents, 0)"/>
                                
                        <div class="col-xs-6">
							<div class="sectionIcon">
								<i class="fa fa-pie-chart icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Process Cost')"/>
							</h2>
							<div class="content-section">
                                <xsl:choose><xsl:when test="$costTypeTotal=0"> -</xsl:when><xsl:otherwise><xsl:value-of select="$currency"/>  <xsl:value-of select="format-number($costTypeTotal, '###,###,###')"/></xsl:otherwise></xsl:choose>
                             
							</div>
							<hr/>
						</div> 

				<!--Setup the Performed by Roles section-->
				<xsl:variable name="rolesPerformed" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'business_process_performed_by_business_role']/value]"/>

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-user icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Performed by Roles')"/>
					</h2>

					<div class="content-section">
						<p>
							<xsl:if test="not(count($rolesPerformed) > 0)">
								<em>
									<xsl:value-of select="eas:i18n('No roles defined for this process')"/>
								</em>
							</xsl:if>
							<ul class="noMarginBottom">
								<xsl:for-each select="$rolesPerformed">
									<li>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="current()"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ul>
						</p>
					</div>
					<hr/>
				</div>


				<!--Setup the Realised Business Capabilities section-->
			

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa essicon-blocks icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Realised Business Capabilities')"/>
					</h2>

					<div class="content-section">
						<ul class="noMarginBottom" id="busCaps"></ul>
					</div>

					<hr/>
				</div>



				<!--Setup the Strategic Plans section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Planning')"/>
					</h2>


					<div class="content-section">
						<xsl:apply-templates select="$currentProcess/name" mode="StrategicPlansForElement"/>
					</div>

					<hr/>
				</div>


			<div class="col-xs-5">
					<div class="sectionIcon">
						<i class="fa fa-chevron-up icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Parent Process')"/>
						</h2>
					</div>
					<div class="content-section">
					  <div id="parentName"></div>
						
					</div>
					<hr/>
				</div>
				<div class="col-xs-7">
					<div class="sectionIcon">
						<i class="fa fa-chevron-down icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Sub Processes')"/>
						</h2>
					</div>
					<div class="content-section">
					  <div id="processTable"></div>
						
					</div>
					<hr/>
				</div>
				<!--Setup the Implementing Processes section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-users icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Implementing Processes')"/>
						</h2>
					</div>
					<div class="content-section">

						<xsl:choose>
							<xsl:when test="not(count($phys_process_list) > 0)">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Physical Processes Defined')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>

								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-25pc">
												<xsl:value-of select="eas:i18n('Process Performed by')"/>
											</th>
                                            <th class="cellWidth-15pc">
												<xsl:value-of select="eas:i18n('Application Service Utilising')"/>
											</th>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Performed at Sites')"/>
											</th>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Process Manager')"/>
											</th>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Supporting Applications')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$phys_process_list" mode="Physical_Process"> </xsl:apply-templates>
									</tbody>
								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>
		
			


				<!--Setup the Supporting Information section-->
				<xsl:variable name="read_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_reads_information']/value]"/>
				<xsl:variable name="created_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_creates_information']/value]"/>
				<xsl:variable name="updated_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_updates_information']/value]"/>
				<xsl:variable name="deleted_info_views" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'bus_process_type_deletes_information']/value]"/>
				<xsl:variable name="anInfoRelList" select="own_slot_value[slot_reference = 'busproctype_uses_infoviews']/value"/>
				<xsl:variable name="aReadRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_reads_infoview']/value = 'Yes']"/>
				<xsl:variable name="aCreateRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_creates_infoview']/value = 'Yes']"/>
				<xsl:variable name="anUpdateRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_updates_infoview']/value = 'Yes']"/>
				<xsl:variable name="aDeleteRelList" select="/node()/simple_instance[name = $anInfoRelList and own_slot_value[slot_reference = 'busproctype_deletes_infoview']/value = 'Yes']"/>
				<xsl:variable name="anInfoRead" select="/node()/simple_instance[name = $aReadRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoCreated" select="/node()/simple_instance[name = $aCreateRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoUpdated" select="/node()/simple_instance[name = $anUpdateRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<xsl:variable name="anInfoDeleted" select="/node()/simple_instance[name = $aDeleteRelList/own_slot_value[slot_reference = 'busproctype_to_infoview_to_infoview']/value]"/>
				<script>
								$(document).ready(function(){									
									$('#dt_infoUsed,#dt_infoCreated,#dt_infoUpdated,#dt_infoDeleted').DataTable({
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									filter: false,
									columns: [
									    { "width": "20%" },
									    { "width": "40%" },
									    { "width": "40%" }
									  ]
									});
									
									$(window).resize( function () {
									        table.columns.adjust();
									    });
					<xsl:variable name="thisparentProcesses" select="$allProcesses[own_slot_value[slot_reference='bp_sub_business_processes']/value=current()/name]"/>	
					 
					var subProcesses=[<xsl:apply-templates select="$currentProcess" mode="processModel"/>];
					var parentProcesses=[<xsl:apply-templates select="$thisparentProcesses" mode="parents"/>]
					
					var thisCapsList= [<xsl:for-each select="$currentBusinessCapability">{"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>","type":"direct"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]
	
					var parentCapsList=[]
					
					parentProcesses.forEach(function(d){
					 
						d.capsSupporting.forEach(function(e){
							parentCapsList.push(e);
						});
					});
			 		
					parentCapsList.forEach(function(d){
						var match = thisCapsList.filter(function(e){
							return e.link ==d.link;
						})
				 
					if(match.length &gt;0){}else{ thisCapsList.push(d)}
					})  
 					
				
					var capsFragmentFront   = $("#caps-template").html();
					capsTemplateFront = Handlebars.compile(capsFragmentFront);
					var procFragmentFront   = $("#proc-template").html();
					procTemplateFront = Handlebars.compile(procFragmentFront);
	
					$('#processTable').append(procTemplateFront(subProcesses));
					
					$('#busCaps').append(capsTemplateFront(thisCapsList)) 
					
					if(parentProcesses[0]){
					$('#parentName').html(parentProcesses[0].link)
					}
					
					$("span[easid='but']").click(function() {
						console.log(this)
						$(this).children().toggleClass("fa-caret-up fa-caret-down");
						});


						$("button[easid='but']").click(function() {
						$(this).children().toggleClass("fa-caret-up fa-caret-down");
						});
					
								});
							</script>

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-files-o icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Information')"/>
					</h2>

					<div class="content-section">
						<p><xsl:value-of select="eas:i18n('A summary of the information interactions for the')"/>&#160;<span class="text-primary"><xsl:call-template name="RenderMultiLangInstanceName">
								<xsl:with-param name="theSubjectInstance" select="$currentProcess"></xsl:with-param>
							</xsl:call-template></span>&#160;<xsl:value-of select="eas:i18n(' process')"/></p>

						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Used')"/>
						</h3>
						<xsl:if test="not(count($read_info_views) > 0) and not(count($anInfoRead) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($read_info_views) > 0) or (count($anInfoRead) > 0)">
							<table id="dt_infoUsed" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$read_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoRead" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Created')"/>
						</h3>
						<xsl:if test="not(count($created_info_views) > 0) and not(count($anInfoCreated) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($created_info_views) > 0) or (count($anInfoCreated) > 0)">
							<table id="dt_infoCreated" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$created_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoCreated" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Updated')"/>
						</h3>
						<xsl:if test="not(count($updated_info_views) > 0) and not(count($anInfoUpdated) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($updated_info_views) > 0) or (count($anInfoUpdated) > 0)">
							<table id="dt_infoUpdated" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$updated_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoUpdated" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>

						<h3 class="text-secondary">
							<xsl:value-of select="eas:i18n('Information Deleted')"/>
						</h3>
						<xsl:if test="not(count($deleted_info_views) > 0) and not(count($anInfoDeleted) > 0)">
							<p>
								<em>
									<xsl:value-of select="eas:i18n('No Views Defined')"/>
								</em>
							</p>
						</xsl:if>
						<xsl:if test="(count($deleted_info_views) > 0) or (count($anInfoDeleted) > 0)">
							<table id="dt_infoDeleted" class="table table-striped table-bordered">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Information View Name')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Description')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('View of Information Concept')"/>
										</th>
									</tr>
								</thead>
								<tbody>
									<xsl:apply-templates select="$deleted_info_views" mode="Info_View"/>
									<xsl:apply-templates select="$anInfoDeleted" mode="Info_View"/>
								</tbody>
							</table>
							<div class="verticalSpacer_20px"/>
						</xsl:if>
					</div>
					<hr/>
				</div>


				<!--Setup the defining process flow section-->

				<!--<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-sitemap icon-section icon-color"/>
					</div>
					<div>
						<h2 class="text-primary">
							<xsl:value-of select="eas:i18n('Defining Process Flow')"/>
						</h2>
					</div>
					<div class="content-section">
						<xsl:variable name="processFlowArch" select="own_slot_value[slot_reference='defining_business_process_flow']/value"/>
						<xsl:choose>
							<xsl:when test="count($processFlowArch) > 0">
								<p><xsl:value-of select="eas:i18n('The following diagram shows the process flow that describes the design of the')"/>&#160;<span class="text-primary"><xsl:value-of select="$processName"/></span> process </p>
								<div>
									<xsl:apply-templates select="/node()/simple_instance[name=$processFlowArch]" mode="RenderArchitectureImage"/>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div><xsl:value-of select="eas:i18n('No process flow defined for the')"/>&#160; <span class="text-primary"><xsl:value-of select="$processName"/></span>&#160; <xsl:value-of select="eas:i18n('process')"/>. </div>
							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>-->


				<!--Setup the Supporting Documentation section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-file-text-o icon-section icon-color"/>
					</div>

					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
					</h2>

					<div class="content-section">
						<xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentProcess/own_slot_value[slot_reference = 'external_reference_links']/value]"/>
						<xsl:call-template name="RenderExternalDocRefList">
							<xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/>
						</xsl:call-template>
						<!--<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>-->
					</div>

					<hr/>
				</div>

			</div>
		</div>
	</xsl:template>
	<!--Other Templates called by the main body-->
	<!-- TEMPLATE TO CREATE THE DETAILS FOR PHYSICAL PROCESSES THAT IMPLEMENT THE LOGICAL PROCESS -->
	<xsl:template match="node()" mode="Physical_Process">
		<xsl:variable name="processActorRelation" select="$allPhysProcessActorRelations[name = current()/own_slot_value[slot_reference = 'process_performed_by_actor_role']/value]"/>
		<xsl:variable name="processActorsViaRole" select="$allPhysProcessActors[name = $processActorRelation/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<xsl:variable name="processDirectActors" select="$processActorRelation[type = 'Group_Actor']"/>
		<xsl:variable name="processActor" select="$processActorsViaRole union $processDirectActors"/>
		
		<xsl:variable name="processSites" select="$allSites[name = current()/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>
		<xsl:variable name="actorSites" select="$allSites[name = $processActor/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
		<xsl:variable name="processManagerActor2Role" select="$allActor2Roles[(name = current()/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $processManagerRole/name)]"/>
		<xsl:variable name="processManager" select="$allIndividualActors[name = $processManagerActor2Role/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		<!--<xsl:variable name="supportingAppRelations" select="$allPhysProcAppRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		<xsl:variable name="supportingApps" select="$allApps[name = $supportingAppRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>-->
		<xsl:variable name="supportingAppProRelations" select="$allPhysProcAppProRelations[own_slot_value[slot_reference = 'apppro_to_physbus_to_busproc']/value = current()/name]"/>
		
		<xsl:variable name="supportingApp2Roles" select="$allPhysProcApp2Roles[name = $supportingAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="supportingDirectApps" select="$directApps[name = $supportingAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="supportingIndirectApps" select="$indirectApps[name = $supportingApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>
		<xsl:variable name="supportingApps" select="$supportingDirectApps union $supportingIndirectApps"/>
		
		<!--<xsl:variable name="supportingApp2Roles" select="$allPhysProcApp2Roles[name = $supportingAppProRelations/own_slot_value[slot_reference = 'apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="supportingApps" select="$allApps[name = $supportingApp2Roles/own_slot_value[slot_reference = 'role_for_application_provider']/value]"/>-->

		<xsl:variable name="supportingApp2InfoRelations" select="$allPhysProcApp2InfoRelations[own_slot_value[slot_reference = 'physbusproc_to_appinfoview_from_physbusproc']/value = current()/name]"/>
		<xsl:variable name="supportingApp2Infos" select="$allPhysProcApp2Infos[name = $supportingApp2InfoRelations/own_slot_value[slot_reference = 'physbusproc_to_appinfoview_to_appinforep']/value]"/>
		<xsl:variable name="supportingInfoApps" select="$allPhysProcSupportingInfoApps[name = $supportingApp2Infos/own_slot_value[slot_reference = 'app_pro_to_inforep_from_app']/value]"/>

		<xsl:variable name="allSupportingApps" select="$supportingApps union $supportingInfoApps"/>
		
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$processActor"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
            <td>
       
				<ul>
				<xsl:for-each select="$appSvs">
				 <li><xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template></li>
				</xsl:for-each>
				</ul>
            </td>
			<td>
				<xsl:choose>
					<xsl:when test="count($processSites) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$processSites">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="count($actorSites) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$actorSites">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="not(string($processManager))">-</xsl:if>
				<!--<xsl:value-of select="$processManager/own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$processManager"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="count($supportingApps) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$supportingApps">
								 
								<xsl:variable name="supportingAPR" select="$supportingApp2Roles[name=current()/own_slot_value[slot_reference='provides_application_services']/value]"/>
								
								<xsl:variable name="thissupportingSvc" select="$appSvs[name=$supportingAPR/own_slot_value[slot_reference='implementing_application_service']/value]"/>
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
									<xsl:if test="count($thissupportingSvc) > 0">
										<br/>
										<xsl:for-each select="$thissupportingSvc">
											<span style="font-size:9pt; ">
										
												- <xsl:call-template name="RenderInstanceLink">
												<xsl:with-param name="theSubjectInstance" select="current()"/>
												<xsl:with-param name="theXML" select="$reposXML"/>
												<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											</xsl:call-template>
											</span><br/>	
										</xsl:for-each>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<!--<xsl:when test="count($allSupportingApps) > 0">
						<ul class="noMarginBottom">
							<xsl:for-each select="$allSupportingApps">
								<li>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="current()"/>
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>-->
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING INFORMATION VIEW -->
	<xsl:template match="node()" mode="Info_View">
		<tr>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoCapViewRep.xsl&amp;</xsl:text>
						<xsl:text>&amp;LABEL=Information Model Catalogue - </xsl:text>
						<xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, '::', ' ')" />
					</xsl:attribute>
					<xsl:value-of select="translate(own_slot_value[slot_reference='name']/value, '::', ' ')" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(string(own_slot_value[slot_reference = 'description']/value))">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<xsl:variable name="infoConcept" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'refinement_of_information_concept']/value]"/>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoCapViewRep.xsl&amp;</xsl:text>
						<xsl:text>&amp;LABEL=Information Model Catalogue - </xsl:text>
						<xsl:value-of select="$infoConcept/own_slot_value[slot_reference='name']/value" />
					</xsl:attribute>
					<xsl:value-of select="$infoConcept/own_slot_value[slot_reference='name']/value" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$infoConcept"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>
	<!-- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -->
	<!-- Given a reference (instance ID) to an element, find all its plans and render each -->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>
		<xsl:variable name="aStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>
		<!-- Test to see if any plans are defined yet -->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-- Show active plans first -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the future -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<!-- Then the old -->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference = 'strategic_plan_status']/value = $anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Render the details of a particular strategic plan in a small table -->
	<!-- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus"/>
		<xsl:variable name="aStatusID" select="current()/own_slot_value[slot_reference = 'strategic_plan_status']/value"/>
		<xsl:if test="$aStatusID = $theStatus">
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th>
							<xsl:value-of select="eas:i18n('Plan')"/>
						</th>
						<th>
							<xsl:value-of select="eas:i18n('Description')"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<strong>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
								</xsl:call-template>
							</strong>
						</td>
						<td>
							<xsl:call-template name="RenderMultiLangInstanceDescription">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
     <xsl:function as="xs:float" name="eas:get_cost_components_total">
        <xsl:param name="costComponents"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($costComponents) > 0">
                <xsl:variable name="nextCost" select="$costComponents[1]"/>
                <xsl:variable name="newCostComponents" select="remove($costComponents, 1)"/>
                <xsl:variable name="costAmount" select="$nextCost/own_slot_value[slot_reference='cc_cost_amount']/value"/>
                <xsl:choose>
                    <xsl:when test="$costAmount > 0">
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total + number($costAmount))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
	
<xsl:template match="node()" mode="parents">
<xsl:variable name="thisbusinessCapability" select="$businessCapability[name=current()/own_slot_value[slot_reference='realises_business_capability']/value]"/>	
<xsl:variable name="thisparentProcesses" select="$allProcesses[own_slot_value[slot_reference='bp_sub_business_processes']/value=current()/name]"/>	
	{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>","capsSupporting":[<xsl:for-each select="$thisbusinessCapability">{"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]},<xsl:if test="$thisparentProcesses"><xsl:apply-templates select="$thisparentProcesses" mode="parents"/></xsl:if>
</xsl:template>	
	
<xsl:template match="node()" mode="processModel">
	<xsl:variable name="thissubBusinessProcesses" select="$allProcesses[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
	 
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
 "subProcess":[<xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"/>]}<xsl:if test="position()!=last()">,</xsl:if>	
</xsl:template>

<xsl:template match="node()" mode="subProcesses">
	<xsl:param name="depth" select="0"/>
	<xsl:variable name="thissubBusinessProcesses" select="$allProcesses[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
"description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
<xsl:if test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">"flow":"yes",</xsl:if>	
 "subProcess":[
	<xsl:if test="$depth &lt;= $maxDepth"><xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"><xsl:with-param name="depth" select="$depth + 1"/></xsl:apply-templates></xsl:if>
	]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>		
</xsl:stylesheet>
