<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>
	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Node', 'Application_Provider', 'Group_Actor', 'Individual_Actor')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allRegions" select="/node()/simple_instance[type='Geographic_Region'] union /node()/simple_instance[type='Geographic_Location']"/>
	
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<!--<xsl:variable name="allCountries" select="/node()/simple_instance[(name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value) and (count(own_slot_value[slot_reference = 'gr_region_identifier']/value) > 0)]"/>-->
	<xsl:variable name="countryTaxonomyTerm" select="/node()/simple_instance[(type='Taxonomy_Term' and own_slot_value[slot_reference='name']/value = 'Country')]"></xsl:variable>
	<xsl:variable name="allCountries" select="$allRegions[own_slot_value[slot_reference='element_classified_by']/value = $countryTaxonomyTerm/name]"></xsl:variable>

	<xsl:variable name="allTechnologyNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allAppInstances" select="/node()/simple_instance[type = 'Application_Software_Instance']"/>
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[type = 'Application_Deployment']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider','Application_Provider_Interface')]"/>
	<xsl:variable name="allActor2Roles" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="allGroupActors" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allIndivActors" select="/node()/simple_instance[type = 'Individual_Actor']"/>
	<xsl:variable name="allActors" select="$allIndivActors union $allGroupActors"/>
	<xsl:variable name="allDeploymentRoles" select="/node()/simple_instance[type = 'Deployment_Role']"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[(type = 'Group_Business_Role') or (type = 'Individual_Business_Role')]"/>
	<xsl:variable name="allAttributeValues" select="/node()/simple_instance[type = 'Attribute_Value']"/>
	<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>
	
	<xsl:variable name="currentApp" select="$allApps[name = $param1]"/>
	<xsl:variable name="appName" select="$currentApp/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="appDescription" select="$currentApp/own_slot_value[slot_reference = 'description']/value"/>

	<xsl:variable name="appUserRole" select="$allRoles[own_slot_value[slot_reference = 'name']/value = ('Application User', 'Application Organisation User')]"/>
	<xsl:variable name="thisAppUser2Roles" select="$allActor2Roles[(name = $currentApp/own_slot_value[slot_reference = 'stakeholders']/value) and (own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserRole/name)]"/>
	<xsl:variable name="thisAppUsers" select="$allGroupActors[name = $thisAppUser2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
    <xsl:variable name="appSitesUsing" select="$allSites[name=$currentApp/own_slot_value[slot_reference = 'ap_site_access']/value]"/>
	<xsl:variable name="thisUserSites" select="$allSites[name = $thisAppUsers/own_slot_value[slot_reference = 'actor_based_at_site']/value] union $appSitesUsing"/>
	<xsl:variable name="thisUserCountries" select="$allRegions[name = $thisUserSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	
	<xsl:variable name="thisAppDeployments" select="$allAppDeployments[name = $currentApp/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
	<xsl:variable name="thisAppInstances" select="$allAppInstances[name = $thisAppDeployments/own_slot_value[slot_reference = 'application_deployment_technology_instance']/value]"/>
	<xsl:variable name="thisTechNodes" select="$allTechnologyNodes[name = $thisAppInstances/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value]"/>
	<xsl:variable name="techNodeSites" select="$allSites[name = $thisTechNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountries" select="$allRegions[name = $techNodeSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
	
	<xsl:variable name="thisAppStakeholder2Roles" select="$allActor2Roles[(name = $currentApp/own_slot_value[slot_reference = 'stakeholders']/value) and not(own_slot_value[slot_reference = 'act_to_role_to_role']/value = $appUserRole/name)]"/>
	<xsl:variable name="thisStakeholders" select="$allGroupActors[name = $thisAppStakeholder2Roles/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>

	<xsl:variable name="pageLabel" select="eas:i18n('Application Deployment Summary - ')"/>

	<!-- Defined the colours to be displayed on the map -->
	<xsl:variable name="selectedColour" select="'#f8a85c'"/>
    <xsl:variable name="bothColour" select="'#609f58'"/>
	<xsl:variable name="accessedColour" select="'#6593c8'"/>

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
	<!-- 04.04.2017	JWC Ensure that Geo Locations and sub-country regions are mapped to the world map -->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="$pageLabel"/>
					<xsl:value-of select="$appName"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<link href="js/jvectormap/jquery-jvectormap-2.0.2.css" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jquery.vector-map.js" type="text/javascript"/>
				<script src="js/world-en.js" type="text/javascript"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
										<span class="text-primary">
											<xsl:value-of select="$appName"/>
										</span>
									</span>
								</h1>
 
							</div>
						</div>


						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Description')"/>
							</h2>
							<div class="content-section">
								<xsl:call-template name="RenderMultiLangInstanceDescription">
									<xsl:with-param name="theSubjectInstance" select="$currentApp"/>
								</xsl:call-template>
							</div>

							<hr/>
						</div>

						<!--Setup Map Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-globe icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Geographic View')"/>
							</h2>

							<div class="content-section">
								<p><xsl:value-of select="eas:i18n('The map below highlights the countries from where the Application')"/>
									<xsl:text> </xsl:text><strong><xsl:value-of select="$appName"/></strong>
									<xsl:text> </xsl:text><xsl:value-of select="eas:i18n('is deployed as well as the locations from where it is accessed or used')"/>.</p>
								<div class="verticalSpacer_10px"/>
								<div id="keyContainer">
									<div class="keyLabel"><xsl:value-of select="eas:i18n('Legend')"/>:</div>
									<div class="keySample backColour8"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Hosted')"/>
									</div>
									<div class="keySample backColour9"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Accessed')"/>
									</div>
                                    <div class="keySample" style="background-color:#609f58"/>
									<div class="keySampleLabel">
										<xsl:value-of select="eas:i18n('Both')"/>
									</div>
								</div>
								<div class="clear"/>
								<xsl:call-template name="Map"/>
							</div>


							<hr/>
						</div>



						<!--Setup Stakeholders Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-users icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Stakeholders</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($thisAppStakeholder2Roles) > 0">
										<p><xsl:value-of select="eas:i18n('The table below lists the stakeholders for the')"/>
											<xsl:text> </xsl:text><strong><xsl:value-of select="$appName"/></strong>
											<xsl:text> </xsl:text><xsl:value-of select="eas:i18n('application')"/>.</p>
										<br/>
										<xsl:call-template name="StakeholderTableView"/>
									</xsl:when>
									<xsl:otherwise> - </xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>


						<!--Setup Users Section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-user icon-section icon-color"/>
							</div>
							<h2 class="text-primary">Users</h2>
							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($thisAppUser2Roles) > 0">
										<p><xsl:value-of select="eas:i18n('The table below lists the users that access the')"/><xsl:text> </xsl:text>
											<strong><xsl:value-of select="$appName"/></strong>
											<xsl:text> </xsl:text><xsl:value-of select="eas:i18n('application')"/>.</p>
										<br/>
										<xsl:call-template name="UserTableView"/>
									</xsl:when>
									<xsl:otherwise> - </xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>



						<!--Setup Servers Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-server icon-section icon-color"/>
							</div>

							<h2 class="text-primary">Servers</h2>

							<div class="content-section">
								<xsl:choose>
									<xsl:when test="count($thisAppDeployments) > 0">
										<p><xsl:value-of select="eas:i18n('The table below lists the servers upon which the')"/>
											<xsl:text> </xsl:text><strong><xsl:value-of select="$appName"/></strong><xsl:text> </xsl:text>
											<xsl:value-of select="eas:i18n('application is deployed')"/>.</p>
										<xsl:call-template name="ServerTableView"/>
									</xsl:when>
									<xsl:otherwise> - </xsl:otherwise>
								</xsl:choose>
							</div>
							<hr/>
						</div>

						<!--Setup the Supporting Documentation section-->

						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-file-text-o icon-section icon-color"/>
							</div>

							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
							</h2>

							<div class="content-section">
								<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
							</div>
							<hr/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="Map">
		<script>
			$(document).ready(function(){
				$(function(){
					$('#map').vectorMap(
						{
							color: '#cccccc',
							backgroundColor: '#ffffff',
							hoverOpacity: 0.7,
							hoverColor: false,
							colors: {
							<xsl:apply-templates mode="PrintCountryData" select="$thisUserCountries union $techNodeCountries"><xsl:sort select="own_slot_value[slot_reference = 'gr_region_identifier']/value"/></xsl:apply-templates>
							}
						}
					);
				});
			});
		</script>
		<div id="map" style="width:100%;"/>
	</xsl:template>

	<xsl:template name="StakeholderTableView">
		<table class="table table-striped table-bordered" id="dt_stakeholders">
			<thead>
				<tr>
					<th class="cellWidth-20pc">Role</th>
					<th class="cellWidth-20pc">Name</th>
					<th class="cellWidth-60pc">Email</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$thisAppStakeholder2Roles">
					<xsl:sort select="own_slot_value[slot_reference = 'relation_name']/value"/>
					<xsl:variable name="stakeholderRole" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
					<xsl:variable name="stakeholder" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
					<xsl:variable name="stakeholderEmail" select="$stakeholder/own_slot_value[slot_reference = 'email']/value"/>
					<tr>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$stakeholderRole"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$stakeholder"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<a href="mailto:{$stakeholderEmail}">
								<xsl:value-of select="$stakeholderEmail"/>
							</a>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="UserTableView">
		<table class="table table-striped table-bordered" id="dt_users">
			<thead>
				<tr>
					<th class="cellWidth-20pc">User</th>
					<th class="cellWidth-80pc">Location</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="$thisAppUser2Roles">
					<xsl:sort select="own_slot_value[slot_reference = 'relation_name']/value"/>
					<xsl:variable name="user" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
					<xsl:variable name="userSites" select="$allSites[name = $user/own_slot_value[slot_reference = 'actor_based_at_site']/value]"/>
					<tr>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$user"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$userSites"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							</xsl:call-template>
						</td>
					</tr>
				</xsl:for-each>

			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="ServerTableView">
		<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_server tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
				
				var table = $('#dt_server').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "20%" },
				    { "width": "20%" },
				    { "width": "20%" },
				    { "width": "20%" },
				    { "width": "20%" }
				  ],
				dom: 'Bfrtip',
			    buttons: [
		            'copyHtml5', 
		            'excelHtml5',
		            'csvHtml5',
		            'pdfHtml5', 'print'
		        ]
				});
				
				
				// Apply the search
			    table.columns().every( function () {
			        var that = this;
			 
			        $( 'input', this.footer() ).on( 'keyup change', function () {
			            if ( that.search() !== this.value ) {
			                that
			                    .search( this.value )
			                    .draw();
			            }
			        } );
			    } );
			    
			    table.columns.adjust();
			    
			    $(window).resize( function () {
			        table.columns.adjust();
			    });
			});
		</script>
		
		<table class="table table-striped table-bordered" id="dt_server">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Host Name')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('IP Address')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Environment')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Site')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Location')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Host Name')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('IP Address')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Environment')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Location')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Location')"/>
					</th>

				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="$thisAppDeployments">
					<xsl:variable name="depRole" select="$allDeploymentRoles[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
					<xsl:variable name="depAppInstances" select="$allAppInstances[name = current()/own_slot_value[slot_reference = 'application_deployment_technology_instance']/value]"/>
					<xsl:variable name="depTechNodes" select="$allTechnologyNodes[name = $depAppInstances/own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value]"/>
					<xsl:for-each select="$depTechNodes">
						<xsl:variable name="thisTechNodeSite" select="$allSites[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
						<xsl:variable name="techNodeLocation" select="$allRegions[name = $thisTechNodeSite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>												
						<xsl:variable name="techNodeCountryMap" select="eas:getRegionForLocation($techNodeLocation, $allRegions, $allCountries)"/>
						
						<xsl:variable name="currentTechNodeIPAddress" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value) and (own_slot_value[slot_reference = 'attribute_value_of']/value = $ipAddressAttribute/name)]"/>

						<tr>
							<td>
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</td>
							<td>
								<xsl:value-of select="$currentTechNodeIPAddress/own_slot_value[slot_reference = 'attribute_value']/value"/>
							</td>
							<td>
								<xsl:value-of select="$depRole/own_slot_value[slot_reference = 'name']/value"/>
							</td>
							<td>
								<xsl:call-template name="RenderInstanceLink">									
									<xsl:with-param name="theSubjectInstance" select="$thisTechNodeSite"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</td>
							<td>																
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$techNodeLocation"/>									
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
								<xsl:if test="not($techNodeLocation/name = $techNodeCountryMap/name)">
									<xsl:if test="not(empty($techNodeCountryMap))">,&#160;</xsl:if>
									<xsl:call-template name="RenderInstanceLink">
										<xsl:with-param name="theSubjectInstance" select="$techNodeCountryMap"/>									
										<xsl:with-param name="theXML" select="$reposXML"/>
										<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
									</xsl:call-template>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</xsl:for-each>

			</tbody>
		</table>

		
	</xsl:template>


	<!-- Render the map country data, identifying server and user locations -->
	<xsl:template match="node()" mode="PrintCountryData">
		<xsl:variable name="geoRegion" select="current()"></xsl:variable>
		<xsl:variable name="country" select="eas:getRegionForLocation($geoRegion, $allRegions, $allCountries)"/>
		<xsl:variable name="countryCode">'<xsl:value-of select="$country/own_slot_value[slot_reference = 'gr_region_identifier']/value"/>'</xsl:variable>
				
		<xsl:choose>
            <xsl:when test="$techNodeCountries[eas:getRegionForLocation(self::node(), $allRegions, $allCountries)/name = $country/name] and $thisUserCountries[eas:getRegionForLocation(self::node(), $allRegions, $allCountries)/name = $country/name]">				
				<xsl:value-of select="lower-case($countryCode)"/>: '<xsl:value-of select="$bothColour"/>'<xsl:if test="position() != last()">,</xsl:if>
			</xsl:when>	
			<xsl:when test="$techNodeCountries[eas:getRegionForLocation(self::node(), $allRegions, $allCountries)/name = $country/name]">				
				<xsl:value-of select="lower-case($countryCode)"/>: '<xsl:value-of select="$selectedColour"/>'<xsl:if test="position() != last()">,</xsl:if>
			</xsl:when>			
			<xsl:when test="$thisUserCountries[eas:getRegionForLocation(self::node(), $allRegions, $allCountries)/name = $country/name]">							
				<xsl:value-of select="lower-case($countryCode)"/>: '<xsl:value-of select="$accessedColour"/>'<xsl:if test="position() != last()">,</xsl:if>
			</xsl:when>
		</xsl:choose>

	</xsl:template>
	
	
</xsl:stylesheet>
