<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

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


	<!--param1 = the id of the programme that the roadmap is describing -->
	<!--<xsl:param name="param1"/>-->

	<!--<xsl:variable name="programme" select="/node()/simple_instance[name=$param1]"/>
	<xsl:variable name="programmeName" select="$programme/own_slot_value[slot_reference='name']/value"/>
	<xsl:variable name="programmeDesc" select="$programme/own_slot_value[slot_reference='description']/value"/>-->
	<!--<xsl:variable name="projects" select="/node()/simple_instance[name = $programme/own_slot_value[slot_reference='projects_for_programme']/value]"/>-->

	<!-- START GENERIC CATALOGUE PARAMETERS -->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Project', 'ACTOR_TO_ROLE_RELATION', 'Individual_Actor', 'Group_Actor')"/>
	<!-- END GENERIC CATALOGUE SETUP VARIABES -->

	<xsl:variable name="projects" select="/node()/simple_instance[type = 'Project']"/>

	<xsl:variable name="pageLabel">
		<xsl:value-of select="eas:i18n('Project Catalogue by Name')"/>
	</xsl:variable>
	<xsl:variable name="projectCount" select="count($projects)"/>

	<xsl:variable name="allProjectStakeholders" select="/node()/simple_instance[name = $projects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allProjectActors" select="/node()/simple_instance[name = $allProjectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allProjectRoles" select="/node()/simple_instance[name = $allProjectStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<a id="top"/>
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
							</div>
						</div>
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Catalogue')"/>
							</h2>
							<p>
								<xsl:value-of select="eas:i18n('Select a Project or Person to navigate to the required view')"/>
							</p>
							<xsl:call-template name="Index"/>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Index">

		<script>
			$(document).ready(function(){
				// Setup - add a text input to each footer cell
			    $('#dt_Projects tfoot th').each( function () {
			        var title = $(this).text();
			        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
			    } );
				
				var table = $('#dt_Projects').DataTable({
				scrollY: "350px",
				scrollCollapse: true,
				paging: false,
				info: false,
				sort: true,
				responsive: true,
				columns: [
				    { "width": "20%" },
				    { "width": "40%" },
				    { "width": "40%" }
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

		<table class="table table-striped table-bordered" id="dt_Projects">
			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Project')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Project Members')"/>
					</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Project')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Project Members')"/>
					</th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:choose>
					<xsl:when test="string-length($viewScopeTermIds) > 0">
						<xsl:apply-templates mode="ProjectRow" select="$projects[own_slot_value[slot_reference = 'element_classified_by']/value]">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="ProjectRow" select="$projects">
							<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>

			</tbody>
		</table>

	</xsl:template>

	<xsl:template match="node()" mode="ProjectRow">

		<xsl:variable name="projectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="projectDesc" select="current()/own_slot_value[slot_reference = 'description']/value"/>

		<xsl:variable name="projectStakeholders" select="$allProjectStakeholders[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		<xsl:variable name="stakeholderCount" select="count($projectStakeholders)"/>
		<xsl:variable name="projectRoles" select="/node()/simple_instance[name = $allProjectStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
		<tr>
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="targetMenu" select="$targetMenu"/>
					<xsl:with-param name="targetReport" select="$targetReport"/>
				</xsl:call-template>
				<!-- PARAM 2 IS THE PARENT PROGRAMME -->
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$projectStakeholders">
						<xsl:variable name="projectActor" select="$allProjectActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
						<xsl:variable name="actorName" select="$projectActor/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="projectRole" select="$allProjectRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
						<xsl:variable name="roleName" select="$projectRole/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="displayString">
							<xsl:choose>
								<xsl:when test="count($projectRole) > 0">
									<xsl:value-of select="concat($actorName, ' (', $roleName, ')')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$actorName"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="$projectActor"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displayString" select="$displayString"/>
							</xsl:call-template>

						</li>
					</xsl:for-each>
				</ul>
			</td>
		</tr>


	</xsl:template>






</xsl:stylesheet>
