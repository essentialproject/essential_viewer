<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan eas" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<!--<xsl:output method="html"/>-->
	<xsl:import href="core_utilities.xsl"/>

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
	
	 28.01.2009 JWC	Added table tags around the tr after moved header and footer to divs 
	 28.01.2009 JWC Migrated to divs 
	 10.11.2011	JWC Re-worked the page history breadcrumb list. 
	 11.11.2011	JWC	Revised structure of breadcrumb object - no longer HTML code but structured String.
	 17.06.2014	JWC Fixed a bug in translating / i18n the label for the history entry
	 15.06.2018	JMK protect text rendering in javascript
-->
	<!-- theCurrentXSL = relative path of current report XSL file passed in by the reporting engine  -->
	<xsl:param name="theCurrentXSL"/>

	<!-- theCurrentURL = full path of the current page  -->
	<xsl:param name="theCurrentURL"/>

	<!-- theSubjectID = the ID of the subject of the current page  -->
	<xsl:param name="theSubjectID"/>

	<xsl:template match="node()" name="Page_History">
		<xsl:param name="breadcrumbs"/>


		<xsl:variable name="currentReport" select="$utilitiesAllReports[own_slot_value[slot_reference = 'report_xsl_filename']/value = $theCurrentXSL]"/>
		<xsl:variable name="currentSubject" select="/node()/simple_instance[name = $theSubjectID]"/>
		<xsl:variable name="subjectLabelSlot">
			<xsl:call-template name="GetDisplaySlotForClass">
				<xsl:with-param name="theClass" select="$currentSubject/type"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="subjectLabel">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$currentSubject"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="reportHistoryPrefix" select="eas:i18n($currentReport/own_slot_value[slot_reference = 'report_history_label']/value)"/>
		<xsl:variable name="reportHistoryLabel" select="concat($reportHistoryPrefix, ' ', $subjectLabel)"/>

		<div id="pageHistoryContainer">

			<script type="text/javascript">
				function goToPage()
				{
				var pageIndex = document.pageHistory.page.value;
				if(pageIndex != -1) {
				location.href = pageIndex;
				}
				}
			</script>

			<script type="text/javascript">
				
                $(document).ready(function ()
                {
                    $.ajax(
                    {
                        type: 'POST',
                        url: 'viewHistory',
                        data:
                        {
                            label: '<xsl:value-of select="eas:renderJSText($reportHistoryLabel)"/>', url: '<xsl:value-of select="$theCurrentURL"/>'
                        },
                        success: function (data)
                        {
                            // successful request; create the view history drop down list
                            $('#historyList').empty();
                            $(data).find('visit').each(function (i)
                            {
                                $('#historyList').append('&lt;li&gt;&lt;a href=&quot;' + $(this).find('url').text() + '">' + $(this).find('label').text() + '&lt;/a&gt;&lt;/li&gt;');
                            });
                        },
                        <!--
					contentType (default: 'application/x-www-form-urlencoded; charset=UTF-8'),//-->
                        error: function ()
                        {
                            // failed request; give feedback to user
                            $('#historyList').append('<li>Page history unavailable</li>');
                        }
                    });
                });
			</script>

			<div class="pageHistoryPanel">
				<ul id="historyList">
					<!--<xsl:for-each select="tokenize($breadcrumbs, '§')">
						<xsl:variable name="aURL" select="substring-before(current(), '±')">							
						</xsl:variable>
						<xsl:variable name="aLabel" select="substring-after(current(), '±')"></xsl:variable>
						<li>
							<a>
								<xsl:attribute name="href"><xsl:value-of select="$aURL"></xsl:value-of></xsl:attribute>
								<xsl:value-of select="$aLabel"></xsl:value-of>
							</a>
						</li>
					</xsl:for-each>-->
				</ul>
			</div>
			<br/>

		</div>
	</xsl:template>
</xsl:stylesheet>
