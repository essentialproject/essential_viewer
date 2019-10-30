<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:functx="http://www.functx.com" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>


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

	<xsl:param name="currentPageLink"/>
	<xsl:param name="theURLPrefix"/>
	<xsl:variable name="aSafeCurrentPageLink" select="replace($currentPageLink, '[&lt;&gt;]', '')"></xsl:variable>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<title>
					<xsl:value-of select="eas:i18n('Select a Language')"/>
				</title>
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
									<span class="text-primary">
										<xsl:value-of select="eas:i18n('Language Selection')"/>
									</span>
								</h1>
							</div>
							<form action="essentialLanguage" method="POST" name="languageForm">
								<!--	<xsl:variable name="encodedURL" select="translate($theURLFullPath, '&amp;', '%26')" />-->
								<input type="hidden" name="currentPage" value="{$aSafeCurrentPageLink}"/>
								<label for="language">
									<strong><xsl:value-of select="eas:i18n('Choose your language')"/>: </strong>
								</label>
								<select name="i18n" id="language" class="form-control" style="width: 300px;">
									<xsl:for-each select="$enabledLanguages">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
										<option>
											<xsl:attribute name="value" select="current()/own_slot_value[slot_reference = 'name']/value"/>
											<xsl:if test="current()/own_slot_value[slot_reference = 'name']/value = $i18n">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="current()/own_slot_value[slot_reference = 'lang_display_label']/value"/>
										</option>
									</xsl:for-each>

								</select>
								<div class="top-15">
									<button class="btn btn-success right-10" onclick="submitform();">
										<xsl:value-of select="eas:i18n('Save Setting')"/>
									</button>
									<button class="btn btn-danger right-10" onclick="history.back();">
										<xsl:value-of select="eas:i18n('Cancel')"/>
									</button>
								</div>
							</form>
						</div>
						<!--<script type="text/javascript">
									function submitform()
									{	
									<!-\-
                                var baseURL = "<xsl:value-of select=" substring - before($currentPageLink, 'cl=') "/>";//-\->
										var baseURL = "<xsl:value-of select="$currentPageLink"/>";
										var oldLangParam = "<xsl:value-of select="$i18n"/>";
									<!-\-
                                var newURL = baseURL + "cl=" + document.languageForm.i18n.value;//-\->
										var newURL = baseURL.replace(oldLangParam, document.languageForm.i18n.value);
										<!-\-
                                document.languageForm.currentPage.value = newURL;//-\->
										document.languageForm.currentPage.value ="<xsl:value-of select="$currentPageLink"/>&amp;cl=" + document.languageForm.i18n.value;
										document.languageForm.submit();
										<!-\-
                                document.languageForm.submit();//-\->
									}
								</script>-->

						<script type="text/javascript">
							function submitform()
							{	
								var baseURL = "<xsl:value-of select="substring-before($currentPageLink, 'cl=')"/>";
								<!--
								var baseURL = "<xsl:value-of select=" $currentPageLink "/>";//-->
								var oldLangParam = "<xsl:value-of select="$i18n"/>";
								var newURL = baseURL + "cl=" + document.languageForm.i18n.value;
								<!--
								var newURL = baseURL.replace(oldLangParam, document.languageForm.i18n.value);//-->
								document.languageForm.currentPage.value = newURL;
								<!--
								document.languageForm.currentPage.value = "<xsl:value-of select=" $currentPageLink "/>&amp;cl=" + document.languageForm.i18n.value;//-->
								document.languageForm.submit();
								<!--
								document.languageForm.submit();//-->
							}
						</script>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>




	<xsl:template name="Index"> </xsl:template>






</xsl:stylesheet>
