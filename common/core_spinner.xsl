<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:template name="page-spinner">
		<style>
			#page-spinner {
				position: absolute;
				width: 100%;
				height: 100%;
				background-color: rgba(255,255,255,0.75);
				padding-top: 200px;
				z-index: 9999999999999999;
			}
			.spin-icon {
				width: 60px;
				height: 60px;
			}
			#page-spinner-text {
				float: none;
				display: block;
			}
		</style>
		<div id="page-spinner">
	        <div class="eas-logo-spinner">
	            <div class="spin-icon">
	                <div class="sq sq1"/><div class="sq sq2"/><div class="sq sq3"/>
	                <div class="sq sq4"/><div class="sq sq5"/><div class="sq sq6"/>
	                <div class="sq sq7"/><div class="sq sq8"/><div class="sq sq9"/>
	            </div>						
	            <!--<div class="spin-text">Loading...</div>-->
	        </div>
	        <p id="page-spinner-text" class="spin-text text-center xlarge top-10">Loading...</p>
	    </div>
		
	</xsl:template>

</xsl:stylesheet>