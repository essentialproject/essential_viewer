<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="allClasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete']"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allClasses[name = $allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value]/name"/>
	<xsl:variable name="allSlots" select="/node()/slot"/>

	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="thisClass " select="/node()/class[name = $param1]"/>

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
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Instance Overview</title>
				<link href="js/select2/css/select2.min.css?release=6.19" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js?release=6.19"/>
				<script>
					$(document).ready(function(){
						$('select').select2({theme: "bootstrap"});
					});
				</script>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Class Browser')"/></span>
								</h1>
							</div>
						</div>

						<div class="col-xs-12">
							<form>
								<div class="form-group">
									<label class="control-label"><xsl:value-of select="eas:i18n('Class Browser')"/></label>
									<select class="form-control select2" onchange="window.location.href='report?XML=reportXML.xml&amp;XSL=integration/class_overview.xsl&amp;PMA='+this.value">
										<option><xsl:value-of select="eas:i18n('Choose Class')"/></option>
										<xsl:apply-templates select="$allClasses" mode="allClasses">
											<xsl:sort select="name" order="ascending"/>
										</xsl:apply-templates>
									</select>
								</div>
							</form>
							<hr/>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-list-ul icon-section icon-color"/>
							</div>
							<h2 class="text-primary"><xsl:value-of select="eas:i18n('Class Information')"/></h2>
							<div class="content-section">
								<h3><strong><xsl:value-of select="eas:i18n('Selected Class')"/></strong>:<xsl:text> </xsl:text><xsl:value-of select="$thisClass/name"/></h3>
								<table class="table table-bordered table-striped" id="classTab">
									<thead>
										<th onclick="sortTable(0)"><xsl:value-of select="eas:i18n('Slot Name')"/></th>
										<th onclick="sortTable(1)"><xsl:value-of select="eas:i18n('Target Class')"/></th>
										<th onclick="sortTable(2)"><xsl:value-of select="eas:i18n('Inverse Slot Name')"/></th>
									</thead>
									<tbody>
										<xsl:apply-templates select="$thisClass/template_slot" mode="slots">
											<xsl:sort select="template_slot" order="ascending"/>
										</xsl:apply-templates>
										<xsl:variable name="super" select="$thisClass/superclass"/>
										<xsl:if test="$thisClass/superclass">
											<xsl:apply-templates select="/node()/class[name = string($super)]/template_slot" mode="slots"> </xsl:apply-templates>
										</xsl:if>
										<xsl:variable name="supersuper" select="/node()/class[name = string($super)]/superclass"/>
										<xsl:if test="/node()/class[name = string($super)]/superclass">
											<xsl:apply-templates select="/node()/class[name = string($supersuper)]/template_slot" mode="slots"> </xsl:apply-templates>
										</xsl:if>
									</tbody>
								</table>

							</div>

						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>


				<script>
                function sortTable(n) {
                  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                  table = document.getElementById("classTab");
                  switching = true;
                  // Set the sorting direction to ascending:
                  dir = "asc"; 
                  /* Make a loop that will continue until
                  no switching has been done: */
                  while (switching) {
                    // Start by saying: no switching is done:
                    switching = false;
                    rows = table.rows;
                    /* Loop through all table rows (except the
                    first, which contains table headers): */
                    for (i = 1; i &lt; (rows.length - 1); i++) {
                      // Start by saying there should be no switching:
                      shouldSwitch = false;
                      /* Get the two elements you want to compare,
                      one from current row and one from the next: */
                      x = rows[i].getElementsByTagName("TD")[n];
                      y = rows[i + 1].getElementsByTagName("TD")[n];
                      /* Check if the two rows should switch place,
                      based on the direction, asc or desc: */
                      if (dir == "asc") {
                        if (x.innerHTML.toLowerCase() &gt; y.innerHTML.toLowerCase()) {
                          // If so, mark as a switch and break the loop:
                          shouldSwitch = true;
                          break;
                        }
                      } else if (dir == "desc") {
                        if (x.innerHTML.toLowerCase() &lt; y.innerHTML.toLowerCase()) {
                          // If so, mark as a switch and break the loop:
                          shouldSwitch = true;
                          break;
                        }
                      }
                    }
                    if (shouldSwitch) {
                      /* If a switch has been marked, make the switch
                      and mark that a switch has been done: */
                      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                      switching = true;
                      // Each time a switch is done, increase this count by 1:
                      switchcount ++; 
                    } else {
                      /* If no switching has been done AND the direction is "asc",
                      set the direction to "desc" and run the while loop again. */
                      if (switchcount == 0 &amp;&amp; dir == "asc") {
                        dir = "desc";
                        switching = true;
                      }
                    }
                  }
                }
</script>

			</body>
		</html>
	</xsl:template>
	<xsl:template match="node()" mode="slots">


		<xsl:variable name="target" select="value"/>
		<tr>
			<td>
				<xsl:value-of select="current()"/>
				<br/>
			</td>
			<td>
				<xsl:value-of select="$allSlots[name = current()]/own_slot_value[slot_reference = ':SLOT-VALUE-TYPE']/value[@value_type = 'class']"/>
			</td>
			<td>
				<xsl:value-of select="$allSlots[name = current()]/own_slot_value[slot_reference = ':SLOT-INVERSE']/value"/>
			</td>

		</tr>

	</xsl:template>

	<xsl:template match="node()" mode="allClasses">
		<option value="{current()/name}">
			<xsl:value-of select="current()/name"/>
		</option>
	</xsl:template>


</xsl:stylesheet>
