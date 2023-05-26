<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" use-character-maps="c-1replace"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Technology_Node', 'Application_Provider', 'Geographic_Region')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[(name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value) and (count(own_slot_value[slot_reference = 'gr_region_identifier']/value) > 0)]"/>
	<xsl:variable name="allLocations" select="/node()/simple_instance[type = 'Geographic_Location' and (name = $allSites/own_slot_value[slot_reference = 'site_geographic_location']/value)]"/>
	<xsl:variable name="allSiteLocs" select="$allCountries union $allLocations"/>
	<xsl:variable name="allLocCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'gr_contained_regions']/value = $allLocations]"/>

	<xsl:variable name="allTechnologyNodes" select="/node()/simple_instance[type = 'Technology_Node']"/>
	<xsl:variable name="allAppInstances" select="/node()/simple_instance[type = 'Application_Software_Instance']"/>
	<xsl:variable name="allAppDeployments" select="/node()/simple_instance[type = 'Application_Deployment']"/>
	<xsl:variable name="allApps" select="/node()/simple_instance[(type = 'Application_Provider') or (type = 'Composite_Application_Provider')]"/>
	<xsl:variable name="allDeploymentRoles" select="/node()/simple_instance[type = 'Deployment_Role']"/>
	<xsl:variable name="allAttributeValues" select="/node()/simple_instance[type = 'Attribute_Value']"/>

	<xsl:variable name="techNodeSites" select="$allSites[name = $allTechnologyNodes/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
	<xsl:variable name="techNodeCountries" select="$allSiteLocs[name = $techNodeSites/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>

	<xsl:variable name="ipAddressAttribute" select="/node()/simple_instance[(type = 'Attribute') and (own_slot_value[slot_reference = 'name']/value = 'IP Address')]"/>

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Technology Node Catalogue')"/>
	</xsl:variable>

	<xsl:variable name="techNodeListByNameCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Name')]"/>
	<xsl:variable name="techNodeListByVendorCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Vendor')]"/>
	<xsl:variable name="techNodeListByProductCatalogue" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue by Product')]"/>
	<xsl:variable name="techNodeListAsTable" select="/node()/simple_instance[(type = 'Report') and (own_slot_value[slot_reference = 'name']/value = 'Core: Technology Node Catalogue as Table')]"/>

	<!--
		* Copyright (c)2008-2017 Enterprise Architecture Solutions ltd.
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
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
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
									</span>
								</h1>
                <!--                <table id="example2" class="display" width="100%">
                                    <thead>
                                <tr><td>Host Name</td><td>IP Address</td><td>Deployed Applications</td><td>Host Description</td><td>Host Location</td></tr></thead>
			                     <tbody></tbody>
                                </table>  -->

								<div class="altViewName">
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Show by')"/>:&#160;</span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByNameCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Name'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByVendorCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Vendor'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListByProductCatalogue"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Product'"/>
										</xsl:call-template>
									</span>
									<span class="text-darkgrey"> | </span>
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Table')"/>
									</span>
									<!--<span class="text-darkgrey">
										<xsl:call-template name="RenderCatalogueLink">
											<xsl:with-param name="theCatalogue" select="$techNodeListAsTable"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
											<xsl:with-param name="targetReport" select="$targetReport"/>
											<xsl:with-param name="targetMenu" select="$targetMenu"/>
											<xsl:with-param name="displayString" select="'Table'"/>
										</xsl:call-template>
									</span>-->
								</div>

							</div>

							<!--Setup the Catalogue section-->
			<!--				<div class="row">
								<div class="col-xs-12">
									<div class="sectionIcon">
										<i class="fa fa-list-ul icon-section icon-color"/>
									</div>
									<h2>
										<xsl:value-of select="eas:i18n('Catalogue')"/>
									</h2>
									<div class="content-section">
										<p><xsl:value-of select="eas:i18n('The table below shows a catalogue of all the Technology Nodes that have been captured')"/>.</p>
										<xsl:call-template name="ServerTableView"/>
									</div>
								</div>
							</div>
  --> 

                        
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
						<xsl:value-of select="eas:i18n('Deployed Applications')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Host Location')"/>
					</th>

				</tr>
			</thead>
            <tbody>
                <!--<xsl:apply-templates select="$inScopeApps" mode="Applications">
                    <xsl:sort select="current()/own_slot_value[slot_reference='name']/value" order="ascending"/>
                </xsl:apply-templates>-->
            </tbody>
                <tfoot>
				<tr>
					<th>
                        <input type="text" name="search_host" value="" class="search_init"><xsl:value-of select="eas:i18n('Host Name')"/></input>
					</th>
					<th>
						<input type="text" name="search_env" value="" class="search_init"/><xsl:value-of select="eas:i18n('IP Address')"/>
					</th>
					<th>
						<input type="text" name="search_app" value="" class="search_init"/><xsl:value-of select="eas:i18n('Deployed Applications')"/>
					</th>
					<th>
						<input type="text" name="search_env" value="" class="search_init"/><xsl:value-of select="eas:i18n('Host Description')"/>
					</th>
					<th>
						<input type="text" name="search_loc" value="" class="search_init"/><xsl:value-of select="eas:i18n('Host Location')"/>
					</th>

				</tr>
			</tfoot>
                            </table>
    
 <script type="text/javascript">
										
										var asInitVals = new Array();
										
										$(document).ready(function() {				
										
										var oTable = $('#dt_server').DataTable( {	
										"aaData": [
										/* Reduced data set */
	<xsl:apply-templates select="$allTechnologyNodes" mode="ServerTableView"/> 		
										],
										"aoColumns": [
										{ "sName":"name", "sType": "html" },
										{ "sName":"ip", "sType": "html" },
										{ "sName":"deployed", "sType": "html" },
										{ "sName":"desc", "sType": "html" },
										{ "sName":"loc", "sType": "html" }
										],
										"sDom": 'T&#60;"clear"&#62;lfrtip',
										"oTableTools": {
										"aButtons":	[
										{
										"sExtends": "copy",
										"sButtonText": "Copy"
										},
										{
										"sExtends": "pdf",
										"sButtonText": "PDF"
										},
										{
										"sExtends": "print",
										"sButtonText": "Print"
										}
										]
										},
										"bPaginate": false,
										"bScrollInfinite": false,
										"sScrollY": "300px",
										"sScrollX": "1000px",
										"bScrollCollapse": true,
										"sPaginationType": "full_numbers",
										"bLengthChange": false,
										"bFilter": true,
                                        "deferRender": true,
										"bSort": true,
										"bInfo": false,
										"bAutoWidth": false,
										"oLanguage": {
										"sSearch": "<strong>Search all columns:</strong>"
										}
										} );
										
                                 
                                       
                                    // Apply the search
                                            oTable.columns().every( function () {
                                                var that = this;

                                                $( 'input', this.footer() ).on( 'keyup change', function () {
                                                    if ( that.search() !== this.value ) {
                                                        that
                                                            .search( this.value )
                                                            .draw();
                                                    }
                                                });
                                            } );
										   // Setup - add a text input to each footer cell
                                           
                                        } );
                                        $('#dt_server tfoot th').each( function () {
                                                var title = $(this).text();
                                                $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
                                            } );
                            </script>
                            
                            
                            
                            
						</div>
					</div>
				</div>



				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="ServerTableView">
 
					<xsl:variable name="thisAppInstances" select="$allAppInstances[own_slot_value[slot_reference = 'technology_instance_deployed_on_node']/value = current()/name]"/>
					<xsl:variable name="thisAppDeployments" select="$allAppDeployments[own_slot_value[slot_reference = 'application_deployment_technology_instance']/value = $thisAppInstances/name]"/>
					<xsl:variable name="thisApps" select="$allApps[own_slot_value[slot_reference = 'deployments_of_application_provider']/value = $thisAppDeployments/name]"/>
                    <xsl:variable name="appDeployments" select="$thisAppDeployments[name = current()/own_slot_value[slot_reference = 'deployments_of_application_provider']/value]"/>
					<xsl:variable name="techNodeSite" select="$allSites[name = current()/own_slot_value[slot_reference = 'technology_deployment_located_at']/value]"/>
					<xsl:variable name="techNodeCountry" select="$allSiteLocs[name = $techNodeSite/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
					<xsl:variable name="currentTechNodeIPAddress" select="$allAttributeValues[(name = current()/own_slot_value[slot_reference = 'technology_node_attributes']/value) and (own_slot_value[slot_reference = 'attribute_value_of']/value = $ipAddressAttribute/name)]"/>

					['<!--<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="current()"/>
									<xsl:with-param name="displayString" select="current()/own_slot_value[slot_reference = 'name']/value"/>
								</xsl:call-template>--><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="theXML" select="$reposXML"/><xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/></xsl:call-template>','<xsl:call-template name="RenderInstanceLinkForJS">
									<xsl:with-param name="theSubjectInstance" select="$currentTechNodeIPAddress"/>
									<xsl:with-param name="displayString" select="$currentTechNodeIPAddress/own_slot_value[slot_reference = 'attribute_value']/value"/>
								</xsl:call-template>','<xsl:if test='$thisApps'><ul><xsl:for-each select="$thisApps"><li><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="theXML" select="$reposXML"/><xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/></xsl:call-template><xsl:if test="count($appDeployments) > 0"> (<xsl:for-each select="$appDeployments"><xsl:variable name="depRole" select="$allDeploymentRoles[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]"/><xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$depRole"/><xsl:with-param name="theXML" select="$reposXML"/><xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/></xsl:call-template><xsl:value-of select="$depRole/own_slot_value[slot_reference = 'name']/value"/><xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>)</xsl:if></li></xsl:for-each></ul></xsl:if>','<xsl:value-of select="current()/own_slot_value[slot_reference = 'description']/value"/>','<xsl:value-of select="$techNodeCountry/own_slot_value[slot_reference = 'name']/value"/>']<xsl:if test="not(position() = last())">, </xsl:if>
				 
			

	</xsl:template>


</xsl:stylesheet>
