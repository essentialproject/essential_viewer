<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>-->
	<xsl:variable name="linkClasses" select="()"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- Param to hold originally requested URL -->
	<xsl:param name="preLoginURL"/>

	<!-- Param to hold success or fail -->
	<xsl:param name="loginFailed">false</xsl:param>

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
	<!-- 01.03.2015	JWC	Defined the login view -->
	<!-- 24.01.2017 JWC Tweaks to the login form + SAML link -->

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
				<link href="platform/login_styles.css" rel="stylesheet" type="text/css"/>
				<title>Essential Cloud Login</title>
			</head>
			<body>
				<div id="left" class="hidden-xs"/>
				<div id="right">
					<div id="wrapper">
						<div class="content">
							<div id="logoContainer">
								<img src="images/essential_cloud_logo_2016.png" alt="Essential Cloud Logo"/>
							</div>

							<div id="loginContainer">
								<xsl:if test="compare($loginFailed, 'false')">
									<div class="col-xs-12 alert alert-danger"><xsl:value-of select="eas:i18n('Sorry, we could not login you in with the details that you specified')"/>. <xsl:value-of select="eas:i18n('Please check your details below and try again')"/>.</div>
								</xsl:if>
								<form method="post" action="login" name="login" id="login" onsubmit="return setCookie(this);" autocomplete="off">
									<div class="form-group">
										<div class="pull-right">
											<span class="glyphicon glyphicon-question-sign" data-toggle="popover" data-content="Enter the Tenant ID provided to you when you signed up. The is typically something like 'mycompanyname'"/>
										</div>
										<label for="tenantName">Tenant ID</label>
										<input class="form-control" id="tenantName" name="tenantName" path="tenantName" placeholder="Tenant Name" title="Enter the Tenant ID provided to you when you signed up. This is typically something like 'mycompanyname'" required="required" pattern="[a-zA-Z0-9\s]+" onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');"/>
									</div>
									<div class="form-group">
										<label for="username">Email</label>
										<input class="form-control" id="username" name="username" path="username" placeholder="Email address" required="required" type="email"/>
									</div>
									<div class="form-group">
										<label for="password">Password</label>
										<input type="password" class="form-control" id="password" name="password" path="password" placeholder="Password" required="required" pattern="^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$" onchange="this.setCustomValidity(this.validity.patternMismatch ? this.title : '');" title="This password must contain at least one uppercase, one lowercase and one numerical characters"/>
									</div>
									<div class="form-group">
										<input type="hidden" name="preLoginURL" value="{$preLoginURL}"/>
									</div>
									<button class="btn btn-primary" style="width: 100%;" type="submit" value="Login">Login</button>
								</form>
								<style>
									input:focus:invalid {
										/* insert your own styles for invalid form input */
										-moz-box-shadow: none;
										border: 2px solid red;
									}
									input:required:valid {
										/* insert your own styles for invalid form input */
										-moz-box-shadow: none;
										border: 2px solid green;
									}
								</style>
								<hr/>

								<!-- Include link for SAML login -->
								<a class="btn btn-primary" style="width: 100%;" role="button" href="javascript:void()" id="callbackURL">Sign in with your company account</a>
								<!-- end of SAML login link -->
								<hr/>
								<div class="pull-left">
									<a href="app/forgottenPassword">Forgot password?</a>
								</div>
								<div class="pull-right">
									<a href="app/forgottenPassword?firstTime">First Time User?</a>
								</div>
								<div class="clearfix"/>
							</div>
							<div id="notCustomerGroup">
								<span>Not a customer?</span>
								<br class="visible-xs"/>
								<a class="btn btn-default" role="button" href="http://www.enterprise-architecture.org">Find Out More</a>
							</div>
							<div class="push"/>
						</div>
					</div>
				</div>

				<script type="text/javascript">
					function getCookie(key) {
						var re = new RegExp(key + "=([^;]+)");
						var value = re.exec(document.cookie);
						return (value != null) ? unescape(value[1]) : null;
					}
					function setCookie(form) {
						var key = "tenant";
						var value = form.tenantName.value;
						document.cookie = key + "=" + escape(value) + "; path=/;";
						return true;
					}
				
					if (tenant = getCookie("tenant")) {
						document.getElementById("login").tenantName.value = tenant;
					}
					
				</script>
				<script type="text/javascript">
		            $(document).ready(function(){
		                $('[data-toggle="popover"]').popover({
		                placement: 'top',
		                trigger: 'click'
		                });
		            });
		        </script>
				<script type="text/javascript">					
						document.getElementById("callbackURL").href = window.location.protocol + "//" + window.location.host + "/app/samlLogin?appRedirectUrl=" + window.location.href;					
				</script>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
