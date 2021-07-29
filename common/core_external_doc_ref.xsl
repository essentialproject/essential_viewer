<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>
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
	<!-- Receive an instance node and report any external repository references
		that are defined against it in a table -->
	<!-- 04.11.2008	JWC	Added to new report servlet -->

	<xsl:variable name="imageSuffixes" select="('png', 'jpg', 'jpeg','jpg, jpeg', 'bmp', 'gif')"/>
	<xsl:variable name="videoSuffixes" select="('mp4', 'mov')"/>
	<xsl:variable name="extRefLinkTypes" select="/node()/simple_instance[type='Document_File_Type']"/>
	<xsl:variable name="imageExtRefLinkTypes" select="$extRefLinkTypes[functx:contains-any-of(own_slot_value[slot_reference = 'extension_mime_type']/value, $imageSuffixes)]"/>
	<xsl:variable name="videoExtRefLinkTypes" select="$extRefLinkTypes[functx:contains-any-of(own_slot_value[slot_reference = 'extension_mime_type']/value, $videoSuffixes)]"/>
	<xsl:variable name="extDocRefsInNewWindow" select="/node()/simple_instance[type = 'Report_Constant' and own_slot_value[slot_reference = 'report_constant_short_name']/value = 'extDocRefInNewWindow']/own_slot_value[slot_reference = 'report_constant_value']/value = 'yes'"/>

	<xsl:template match="node()" mode="ReportExternalDocRef">
		<xsl:param name="emptyMessage">
			<span>-</span>
		</xsl:param>
		<!-- Create a new table styled via css, to report any external references -->
		<xsl:variable name="anExternalDocRefList" select="own_slot_value[slot_reference = 'external_reference_links']/value"/>

		<xsl:choose>
			<xsl:when test="count($anExternalDocRefList) > 0">
				<ul>
					<xsl:for-each select="$anExternalDocRefList">
						<xsl:variable name="anInstDocName" select="."/>
						<xsl:variable name="anExternalDocRef" select="/node()/simple_instance[name = $anInstDocName]"/>
						<xsl:variable name="anExternalReposInst" select="$anExternalDocRef/own_slot_value[slot_reference = 'external_reference_links']/value"/>
						<li>
							<a>
								<xsl:if test="$extDocRefsInNewWindow = true()"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
								<xsl:attribute name="href">
									<xsl:value-of select="$anExternalDocRef/own_slot_value[slot_reference = 'external_reference_url']/value"/>
								</xsl:attribute>
								<xsl:value-of select="$anExternalDocRef/own_slot_value[slot_reference = 'name']/value"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:when>
			<xsl:when test="count($anExternalDocRefList) = 0">
				<xsl:value-of select="$emptyMessage"/>
			</xsl:when>


		</xsl:choose>

	</xsl:template>


	<!-- Receive a list of external doc references and display them as required -->
	<!-- 26.09.2016	JP Created -->
	<xsl:template name="RenderExternalDocRefList">
		<xsl:param name="emptyMessage">
			<span>-</span>
		</xsl:param>
		<xsl:param name="extDocRefs" select="()"/>

		<xsl:choose>
			<xsl:when test="count($extDocRefs) > 0">
				<!-- Create an image slider for image-based external documents -->
				<xsl:variable name="imageDocRefs" select="$extDocRefs[own_slot_value[slot_reference = 'external_link_type']/value = $imageExtRefLinkTypes/name]"/>
				<xsl:variable name="videoDocRefs" select="$extDocRefs[own_slot_value[slot_reference = 'external_link_type']/value = $videoExtRefLinkTypes/name]"/>
				<xsl:variable name="docRefList" select="($extDocRefs except ($imageDocRefs union $videoDocRefs))"/>
				<xsl:if test="count($imageDocRefs) > 0">
					<h2>External Diagrams</h2>
					<script>
						$(document).ready(function(){
							$('.carousel').carousel({
								interval: false
							})
						});
					</script>
					<style>
						.carousel-control.left {
							background-image: none;
						}
						.carousel-control.right {
							background-image: none;
						}
						.carousel-control {
							text-shadow: 0 1px 2px rgba(0,0,0,1);
						}
					</style>
					<div id="externalRefImages" class="carousel slide" data-ride="carousel">
						<ol class="carousel-indicators">
							<xsl:for-each select="$imageDocRefs">
								<li data-target="#externalRefImages">
									<xsl:attribute name="data-slide-to"><xsl:value-of select="position()-1"/></xsl:attribute>
									<xsl:if test="position()=1">
										<xsl:attribute name="class">active</xsl:attribute>
									</xsl:if>
								</li>
							</xsl:for-each>
						</ol>
						<div class="carousel-inner">
							<xsl:for-each select="$imageDocRefs">
								<xsl:variable name="currentImgLink" select="current()"/>
								<xsl:variable name="imgURL" select="$currentImgLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
								<xsl:variable name="imgCaption" select="$currentImgLink/own_slot_value[slot_reference = 'name']/value"/>
								<xsl:variable name="imgAltText" select="$currentImgLink/own_slot_value[slot_reference = 'description']/value"/>
								<xsl:if test="string-length($imgURL) > 0">
									<div class="item">
										<xsl:if test="position()=1">
											<xsl:attribute name="class">item active</xsl:attribute>
										</xsl:if>
										<a target="_blank" href="{$imgURL}"><img class="d-block w-100" src="{$imgURL}" alt="{$imgAltText}" title="{$imgCaption}"/></a>
									</div>
								</xsl:if>
							</xsl:for-each>
						</div>
						<a class="left carousel-control" href="#externalRefImages" role="button" data-slide="prev">
							<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
							<span class="sr-only">Previous</span>
						</a>
						<a class="right carousel-control" href="#externalRefImages" role="button" data-slide="next">
							<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
							<span class="sr-only">Next</span>
						</a>
					</div>
				</xsl:if>

				<xsl:if test="count($videoDocRefs) > 0">
					<h2>External Videos</h2>
					<div id="videos">
						<xsl:for-each select="$videoDocRefs">
							<xsl:variable name="currentVideoLink" select="current()"/>
							<xsl:variable name="videoURL" select="$currentVideoLink/own_slot_value[slot_reference = 'external_reference_url']/value"/>
							<xsl:variable name="videoCaption" select="$currentVideoLink/own_slot_value[slot_reference = 'name']/value"/>
							<xsl:variable name="videoDescription" select="$currentVideoLink/own_slot_value[slot_reference = 'description']/value"/>
							<p><strong><xsl:value-of select="$videoCaption"/></strong> - <xsl:value-of select="$videoDescription"/></p>
							<iframe width="560" height="315" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen="allowfullscreen">
								<xsl:attribute name="src" select="$videoURL"></xsl:attribute>
							</iframe>
						</xsl:for-each>
					</div>
					<div class="verticalSpacer_10px"/>
				</xsl:if>

				<xsl:if test="(count($docRefList) > 0) and (count($imageDocRefs) > 0)">
					<div class="verticalSpacer_20px"/>
				</xsl:if>

				<!-- Create a new unordered list to report any external references -->
				<xsl:if test="count($docRefList) > 0">
					<h2>External Documents</h2>
					<ul>
						<xsl:for-each select="$docRefList">
							<xsl:variable name="anExternalDocRef" select="current()"/>
							<li>
								<a>
									<xsl:if test="$extDocRefsInNewWindow = true()"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
									<xsl:attribute name="href">
										<xsl:value-of select="$anExternalDocRef/own_slot_value[slot_reference = 'external_reference_url']/value"/>
									</xsl:attribute>
									<xsl:value-of select="$anExternalDocRef/own_slot_value[slot_reference = 'name']/value"/>
								</a>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="$emptyMessage"/>
				</em>
			</xsl:otherwise>

		</xsl:choose>

	</xsl:template>


	<!-- Receive a list of external doc references and display them as required -->
	<!-- 26.09.2016	JP Created -->
	<xsl:template name="RenderExternalDocRef">
		<xsl:param name="extDocRef" select="()"/>
		<xsl:param name="urlPrefix"/>

		<a>
			<xsl:if test="$extDocRefsInNewWindow = true()"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:attribute name="href">
				<xsl:value-of select="$extDocRef/own_slot_value[slot_reference = 'external_reference_url']/value"/>
			</xsl:attribute>
			<xsl:value-of select="$extDocRef/own_slot_value[slot_reference = 'name']/value"/>
		</a>

	</xsl:template>

</xsl:stylesheet>
