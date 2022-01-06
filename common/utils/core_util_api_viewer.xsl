<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../../common/core_doctype.xsl"/>
	<xsl:include href="../../common/core_common_head_content.xsl"/>
	<xsl:include href="../../common/core_header.xsl"/>
	<xsl:include href="../../common/core_footer.xsl"/>
	<xsl:include href="../../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
 
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="reportAPI" select="/node()/simple_instance[type='Data_Set_API']"></xsl:variable>
	 
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
				<title>Data Set API List</title>
				<style>
				.fa-circle {color:#d3d3d3}
				.word-break {word-break: break-word;}
				</style>
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
									<span class="text-darkgrey">Data Set API List</span>
								</h1>
							</div>
						</div>
 
						<!--Setup Description Section-->
						<div class="col-xs-12">
							 <div id="stuff"></div>
						</div>

					
						<!--Setup Closing Tags-->
					</div>
				</div>
				<script id="api-template" type="text/x-handlebars-template">
					<table class="table table-striped table-condensed">
						<tr>
							<th>API Name</th>
							<th>Pre-Cache</th>
							<th>Status</th>
							<th>File Size</th>
							<!--<th>Download</th>-->
						</tr>		

					{{#each this}}
						<tr>
							<td><strong>{{this.name}}</strong><br/><span class="text-muted small word-break">{{this.fullpath}}</span></td>
							<td>{{this.cache}}</td>
							<td><i class="fa fa-circle"><xsl:attribute name="id">{{this.id}}</xsl:attribute></i></td>
							<td>{{getFileSize this.fullpath}}k</td>
							<!--<td>
								<a class="btn btn-xs btn-default">
									<xsl:attribute name="download" select="concat('{{this.xslpathrep}}','.json')"></xsl:attribute>
									<xsl:attribute name="href" select="concat('platform/tmp/reportApiCache/','{{this.xslpathrep}}')"></xsl:attribute>
								<i class="fa fa-download right-5"/>Download</a>
							</td>-->
						</tr>
					{{/each}}
					</table>					
				</script>	
				<script>
					let apis=[<xsl:apply-templates select="$reportAPI" mode="api"><xsl:sort select="current()/own_slot_value[slot_reference='is_data_set_api_precached']/value" order="descending"/></xsl:apply-templates>];

					$(document).ready(function () {
						apiFragment = $("#api-template").html();
						apiTemplate = Handlebars.compile(apiFragment);
						$('#stuff').html(apiTemplate(apis))
						let cachedAPIs = apis.filter((ap) => {
							return ap.cache == 'true';
						});
						
						cachedAPIs.forEach((d) => {
							
							let thispath = 'reportApi?XML=reportXML.xml&amp;XSL=' + d.xslpath;
							Promise.all([
							promise_loadViewerAPIData(thispath)]).then(function (responses, reject) {
								if (responses[0]) {
									if (typeof responses[0] == 'object') {
										$('#' + d.id).css('color', 'green');
									} else {
										$('#' + d.id).html = 'no';
									}
								} else {
									$('#' + d.id).css('color', 'amber');
								}
							}). catch (function (error, reject) {
								console.log('FAILED API:' + d.name)
								$('#' + d.id).css('color', 'red');
							});
						});
					});
					
					function LinkCheck(url) {
						var http = new XMLHttpRequest();
						http.open('HEAD', url, false);
						http.send();
						return http.status != 404;
					}
					
					function doesFileExist(urlToFile) {
						var xhr = new XMLHttpRequest();
						xhr.open('HEAD', urlToFile, false);
						xhr.send();
						
						if (xhr.status == "404") {
							return false;
						} else {
							return true;
						}
					}
					
					Handlebars.registerHelper("getFileSize", function(url) {
					  var fileSize = '';
					    var http = new XMLHttpRequest();
					    http.open('HEAD', url, false); // false = Synchronous
					    http.send(null); // it will stop here until this http request is complete
					
					    // when we are here, we already have a response, b/c we used Synchronous XHR
					
					    if (http.status === 200) {
					        fileSize = http.getResponseHeader('content-length');
					        //console.log('fileSize = ' + fileSize);
					    } else fileSize = 0;
					    return fileSize;
					});

					
					var promise_loadViewerAPIData = function (apiDataSetURL) {
						return new Promise(function (resolve, reject) {
							if (apiDataSetURL != null) {
								var xmlhttp = new XMLHttpRequest();
								//console.log(apiDataSetURL);
								xmlhttp.onreadystatechange = function () {
									if (this.readyState == 4 &amp;&amp; this.status == 200) {
										// console.log(this.responseText);
										var viewerData = JSON.parse(this.responseText);
										resolve(viewerData);
									}
								};
								xmlhttp.onerror = function () {
									reject(false);
								};
								xmlhttp.open("GET", apiDataSetURL, true);
								xmlhttp.send();
							} else {
								reject(false);
							}
						});
					};
				</script>	

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
<xsl:template match="node()" mode="api">
	<xsl:variable name="dataset-id" select="eas:getSafeJSString(current()/name)"/>
	<xsl:variable name="dataset-name">
		<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param  name="theSubjectInstance" select="current()"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="dataset-xslpathrep" select="replace(current()/own_slot_value[slot_reference='report_xsl_filename']/value,'/','.')"/>
	<xsl:variable name="dataset-xslpath" select="current()/own_slot_value[slot_reference='report_xsl_filename']/value"/>
	<xsl:variable name="dataset-cache" select="current()/own_slot_value[slot_reference='is_data_set_api_precached']/value"/>
	<xsl:variable name="dataset-fullpath" select="concat('platform/tmp/reportApiCache/',$dataset-xslpathrep)"/>
	{"id":"<xsl:value-of select="$dataset-id"/>",
	"name":"<xsl:value-of select="$dataset-name"/>",
	"xslpathrep":"<xsl:value-of select="$dataset-xslpathrep"/>",
	"xslpath":"<xsl:value-of select="$dataset-xslpath"/>",
	"cache":"<xsl:choose><xsl:when test="string-length($dataset-cache) &gt; 0"><xsl:value-of select="$dataset-cache"/></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>",
	"fullpath": "<xsl:value-of select="$dataset-fullpath"/>"}
	<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>

<!--
	<xsl:template match="node()" mode="lifes">
		{"shortname":"<xsl:value-of select="current()/own_slot_value[slot_reference='enumeration_value']/value"/>","colour":"<xsl:value-of select="$style[name=current()[1]/own_slot_value[slot_reference='element_styling_classes']/value]/own_slot_value[slot_reference='element_style_colour']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if> 
	</xsl:template>	
-->
</xsl:stylesheet> 
