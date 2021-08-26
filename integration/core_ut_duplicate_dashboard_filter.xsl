<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>
	<xsl:param name="param2">null</xsl:param>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="apps" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
	<xsl:variable name="busProcess" select="/node()/simple_instance[type = ('Business_Process', 'Business_Activity', 'Business_Task')]"/>
	<xsl:variable name="busCaps" select="/node()/simple_instance[type = ('Business_Capability')]"/>
	<xsl:variable name="appCaps" select="/node()/simple_instance[type = ('Application_Capability')]"/>
	<xsl:variable name="techProds" select="/node()/simple_instance[type = ('Technology_Product')]"/>
	<xsl:variable name="techNodes" select="/node()/simple_instance[type = ('Technology_Node')]"/>
	<xsl:variable name="busRoleJSON" select="/node()/simple_instance[type = ('Group_Business_Role', 'Individual_Business_Role')]"/>
	<xsl:variable name="productJSON" select="/node()/simple_instance[type = ('Product', 'Composite_Product')]"/>
	<xsl:variable name="actorJSON" select="/node()/simple_instance[type = ('Group_Actor', 'Individual_Actor')]"/>
	<xsl:variable name="appServiceJSON" select="/node()/simple_instance[type = ('Application_Service', 'Composite_Application_Service')]"/>
	<xsl:variable name="swComponentJSON" select="/node()/simple_instance[type = ('Software_Component')]"/>
	<xsl:variable name="projectJSON" select="/node()/simple_instance[type = ('Project')]"/>
	<xsl:variable name="programmeJSON" select="/node()/simple_instance[type = ('Programme')]"/>

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
				<title>Data Duplication Dashboard</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<script src="js/fuse.min.js"/>
				<style>
					.score{
						width: 70px;
						height: 60px;
						padding-top: 5px;
						margin-bottom: 10pt;
						font-size: 24pt;
						color: #000000;
						border: 1pt solid #d3d3d3;
						border-radius: 15px;
						text-align: center;
						margin: 0 auto;
					}
					
					.scorebox{
						font-size: 14pt;
						margin-bottom: 20px;
					}
					
					.score-icon {
						width: 70px;
					}
					
					.scoreContainer{
						padding: 10px;
						width: 200px;
						color: #e95680;
						display: block;
						font-family: verdana;
						height: 50px;
					}
					
					.loadingtext{
						width: 90px;
						margin: 4px 0px 0px 15px;
						color: #2d2d2d;
					}
					
					.pleasewait{
						font-size: 16px;
						cursor: pointer;
						padding: 2px;
					}
					
					.processing{
						text-transform: uppercase;
						font-size: 10px;
						color: #2d2d2d;
					}</style>

			</head>
			<body>
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Duplicate Dashboard - Key Classes</span>
								</h1>
							</div>
						</div>
						<div class="col-xs-10">
							<label name="Sensitivity">Sensitivity</label>
							<select id="filterRange" class="selectBox" onchange="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_dashboard_filter.xsl&amp;PMA=&amp;PMA2='+filterRange.value;">
								<option value="0.00001" name="Essential=essential" selected="selected">100%</option>
								<option value="0.1" name="Essential=essential1">90%</option>
								<option value="0.2" name="Essential=essential 1">80%</option>
								<option value="0.3" name="Essential=essential one">70%</option>
							</select>
						</div>
						<div class="col-xs-2">
							<button type="button" class="btn btn-default btn-sm pull-right" id="toggleFilter">Toggle Filters</button>
						</div>
						<div class="col-xs-12">
							<div id="filterPanel" style="display:none;margin-bottom: 15px;">
								<div class="row">
									<div class="col-xs-2">
										<input type="checkbox" name="buscaps" id="buscapselect"> Business Capabilities</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="busprocs" id="busprocselect" checked="true"> Business Processes</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="appcaps" id="appcapselect" checked="true"> Application Capabilities</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="apps" id="appsselect" checked="true"> Applications</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="techprods" id="techprodselect" checked="true"> Technology Products</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="technodes" id="technodeselect" checked="true"> Technology Nodes</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="BusRoles" id="busroleselect" checked="true"> Business Roles</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="product" id="productselect" checked="true"> Products</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="actor" id="actorselect" checked="true"> Actor</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="appService" id="appServiceselect" checked="true"> Application Service </input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="swComponent" id="swComponentselect" checked="true"> Software Component</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="project" id="projectselect" checked="true"> Project</input>
									</div>
									<div class="col-xs-2">
										<input type="checkbox" name="programme" id="programmeselect" checked="true"> Programme</input>
									</div>
									<div class="col-xs-12 top-10">
										<button type="button" class="btn btn-primary btn-sm" onclick="setSelects();window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_dashboard_filter.xsl&amp;PMA=&amp;PMA2='+filterRange.value;">Store Settings</button>
									</div>
								</div>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="row">
								<div class="col-xs-3 scorebox" id="buscapdiv">
									<div class="scoreContainer" id="buscapdiv">
										<div class="pull-left score-icon">
											<i class="fa fa-bookmark fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="busCap" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Business_Capability&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Business Capabilities</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="busprocsdiv">
									<div class="scoreContainer" id="busprocsdiv">
										<div class="pull-left score-icon">
											<i class="fa fa-gear fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="busProcess" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Business_Process_Type&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Business Process</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="busroledivs">
									<div class="scoreContainer" id="busroledivs">
										<div class="pull-left score-icon">
											<i class="fa fa-user fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="BusRoles" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Business_Role&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Business Roles</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="actordivs">
									<div class="scoreContainer" id="actordivs">
										<div class="pull-left score-icon">
											<i class="fa fa-users fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="actor" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Actor&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Actor</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-3 scorebox" id="productdivs">
									<div class="scoreContainer" id="productdivs">
										<div class="pull-left score-icon">
											<i class="fa fa-cube fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="product" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Product&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Products</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>

								<div class="col-xs-3 scorebox" id="appcapdiv">
									<div class="scoreContainer" id="appcapdiv">
										<div class="pull-left score-icon">
											<i class="fa fa-bookmark-o fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="appCap" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Application_Capability&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Application Capabilities</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="appsdiv">
									<div class="scoreContainer" id="appsdiv">
										<div class="pull-left score-icon">
											<i class="fa fa-archive fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="applications" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Application_Provider&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Application Providers</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="appServicedivs">
									<div class="scoreContainer" id="appServicedivs">
										<div class="pull-left score-icon">
											<i class="fa fa-ellipsis-h fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="appService" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Application_Service&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Application Service</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-3 scorebox" id="swComponentdivs">
									<div class="scoreContainer" id="swComponentdivs">
										<div class="pull-left score-icon">
											<i class="fa fa-code fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="swComponent" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Software_Component&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Software Component </div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="techproddivs">
									<div class="scoreContainer" id="techproddivs">
										<div class="pull-left score-icon">
											<i class="fa fa-cubes fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="techProds" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Technology_Product&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Technology Products</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="technodedivs">
									<div class="scoreContainer" id="technodedivs">
										<div class="pull-left score-icon">
											<i class="fa fa-circle-o fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="techNodes" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Technology_Node&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Technology Nodes</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
								<div class="col-xs-3 scorebox" id="projectdivs">
									<div class="scoreContainer" id="projectdivs">
										<div class="pull-left score-icon">
											<i class="fa fa-tasks fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="project" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Project&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Project</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="col-xs-3 scorebox" id="programmedivs">
									<div class="scoreContainer" id="programmedivs">
										<div class="pull-left score-icon">
											<i class="fa fa-list fa-3x"/>
										</div>
										<div class="pull-left loadingtext">
											<div class="pleasewait" id="programme" onclick="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA=Programme&amp;PMA2='+filterRange.value;">Please wait</div>
											<div class="processing">Programme</div>
										</div>
										<div class="clearfix"/>
									</div>
								</div>
							</div>
						</div>




						<script>
       
                                    
                                    $("#toggleFilter").click(function(){
                                        $("#filterPanel").toggle();
                                    }); 
                                    val =<xsl:value-of select="$param2"/>;
                                    $('#filterRange').val(val); 
                                    
                                    
                                    var busCapJSON = [<xsl:apply-templates select="$busCaps" mode="getJSON"/>];
                                    var busProcessJSON = [<xsl:apply-templates select="$busProcess" mode="getJSON"/>];
                                    var applicationsJSON = [<xsl:apply-templates select="$apps" mode="getJSON"/>];
                                    var appCapJSON = [<xsl:apply-templates select="$appCaps" mode="getJSON"/>];
                                    var techProdJSON = [<xsl:apply-templates select="$techProds" mode="getJSON"/>];
                                    var techNodesJSON = [<xsl:apply-templates select="$techNodes" mode="getJSON"/>];
                                    var busRoleJSON = [<xsl:apply-templates select="$busRoleJSON" mode="getJSON"/>];
                                    var productJSON = [<xsl:apply-templates select="$productJSON" mode="getJSON"/>];
                                    var	actorJSON = [<xsl:apply-templates select="$actorJSON" mode="getJSON"/>];
                                    var	appServiceJSON = [<xsl:apply-templates select="$appServiceJSON" mode="getJSON"/>];		
                                    var	swComponentJSON = [<xsl:apply-templates select="$swComponentJSON" mode="getJSON"/>];		
                                    var	projectJSON = [<xsl:apply-templates select="$projectJSON" mode="getJSON"/>];			
                                    var	programmeJSON = [<xsl:apply-templates select="$programmeJSON" mode="getJSON"/>];			

                                    
                                    <!-- remove characters that make it fail -->
                                
                                                          
                                    
                                    function update(dataList,divid){  
                                     var divname=divid;
                                     var counter=0;
                                    x =JSON.stringify(dataList);
                                    filter1 = x.replace("(","");
                                    filter2= filter1.replace(")","");
                                    filter3= filter2.replace("&#47;","");
                                    var applications = JSON.parse(filter3);
                                    
                                <!-- set options for logic -->    
                                    var options = {
                                      keys: ['name'],
                                      id: 'name',
                                      includeScore: true,
                                      threshold:<xsl:value-of select="$param2"/>,
                                        minMatchCharLength: 5
                                    }
                                <!-- create fuzzy logic -->    
                                    var fuse = new Fuse(applications, options);
                                    var myresults;
                                    for (var j=0; j &lt; applications.length;j++){
                                    
                                    <!-- criteria for logic to match to -->
                                    name=applications[j].name;
                                    if (name.indexOf("&#40;")>=0){myresults = []}
                                    else
                                    {
                                    myresults = fuse.search(applications[j].name);
                                     }

                                 if(myresults.length &lt;2){  }
                                        else{
                                    
                        
                                    for (var i=1; i &lt; myresults.length;i++){
                                        var thisthing = applications[j].name.length;
                                        var potentialmatch = myresults[i].item.length;
                   
                                       if (myresults[i].score &lt; 0.45){ 
                                        if((Math.abs(thisthing - potentialmatch)&lt;3)){   
                                           counter=counter+1;
                                    
                                                    }
                                                }
                                            }
                                    
                                        }
                                    }
                             
                                    document.getElementById(divid).innerHTML=counter;
                                    if (counter &lt; 5){
                                      document.getElementById(divid).style.backgroundColor='#b4edc8';                
                                    }
                                    else if ((counter &gt; 5) &amp;&amp; (counter &lt; 10)){
                                        document.getElementById(divid).style.backgroundColor='#ffec7f';
                                    }
                                    else{ document.getElementById(divid).style.backgroundColor='#ff878b';}
                                    
                                    }
                                      
                                       
                                    
                                      
                                     
                                    
                                    function setSelects(){
                                    
                                        localStorage.setItem("busCapSel", document.getElementById('buscapselect').checked);
                                        localStorage.setItem("busProcSel", document.getElementById('busprocselect').checked);
                                        localStorage.setItem("appCapSel", document.getElementById('appcapselect').checked);
                                        localStorage.setItem("appsSel", document.getElementById('appsselect').checked);
                                        localStorage.setItem("techNodeSel", document.getElementById('technodeselect').checked);
                                        localStorage.setItem("techProdSel", document.getElementById('techprodselect').checked);
                                        localStorage.setItem("busRoleSel", document.getElementById('busroleselect').checked);
                                      localStorage.setItem("productSel", document.getElementById('productselect').checked);
                                      localStorage.setItem("actorSel", document.getElementById('actorselect').checked);
                                      localStorage.setItem("appServiceSel", document.getElementById('appServiceselect').checked);	
                                      localStorage.setItem("swComponentSel", document.getElementById('swComponentselect').checked);	
                                      localStorage.setItem("programmeSel", document.getElementById('programmeselect').checked);	
                                      localStorage.setItem("projectSel", document.getElementById('projectselect').checked);	


                                    }
                                    
                                    
                                    
                                    if (localStorage.getItem("busCapSel")==='true' || localStorage.getItem("busCapSel")=== null ){
                                     document.getElementById('buscapdiv').style.display = 'block';  
                                     $("#buscapselect").prop('checked', true); 
                                      update(busCapJSON,'busCap');  
                                    }
                                    else
                                    {document.getElementById('buscapdiv').style.display = 'none'; 
                                     $("#buscapselect").prop('checked', false); }

                                    if (localStorage.getItem("busProcSel")==='true' || localStorage.getItem("busProcSel")=== null){
                                     document.getElementById('busprocsdiv').style.display = 'block';  
                                     $("#busprocselect").prop('checked', true); 
                                      update(busProcessJSON,'busProcess');    
                                    }
                                    else
                                    {document.getElementById('busprocsdiv').style.display = 'none'; 
                                     $("#busprocselect").prop('checked', false); }
                                    
                                    if (localStorage.getItem("appCapSel")==='true' || localStorage.getItem("appCapSel")=== null){
                                     document.getElementById('appcapdiv').style.display = 'block';  
                                     $("#appcapselect").prop('checked', true);   
                                        update(appCapJSON,'appCap');  
                                    }
                                    else
                                    {document.getElementById('appcapdiv').style.display = 'none'; 
                                     $("#appcapselect").prop('checked', false); 
                                    };
                                    
                                    if (localStorage.getItem("appsSel")==='true' || localStorage.getItem("appsSel")=== null){
                                     document.getElementById('appsdiv').style.display = 'block';  
                                     $("#appsselect").prop('checked', true);   
                                      update(applicationsJSON,'applications');
                                    }
                                    else
                                    {document.getElementById('appsdiv').style.display = 'none'; 
                                     $("#appsselect").prop('checked', false); }
                                   
                                      
                                    if (localStorage.getItem("techProdSel")==='true' || localStorage.getItem("techProdSel")=== null){
                                     document.getElementById('techproddivs').style.display = 'block';  
                                     $("#techprodselect").prop('checked', true);   
                                       update(techProdJSON,'techProds');   
                                    }
                                    else
                                    {document.getElementById('techproddivs').style.display = 'none'; 
                                     $("#techprodselect").prop('checked', false); }
                                 
                                    if (localStorage.getItem("techNodeSel")==='true' || localStorage.getItem("techNodeSel")=== null){
                                     document.getElementById('technodedivs').style.display = 'block';  
                                     $("#technodeselect").prop('checked', true);   
                                       update(techNodesJSON,'techNodes');
                                    }
                                    else
                                    {document.getElementById('technodedivs').style.display = 'none'; 
                                     $("#technodeselect").prop('checked', false); };
                                                                        
                                    
                                    if(localStorage.getItem("busRoleSel")==='true' || localStorage.getItem("busRoleSel")=== null){		
                                        document.getElementById('busroledivs').style.display = 'block';  		
                                        $("	busroleselect").prop('checked', true);   	
                                        update(	busRoleJSON	,'BusRoles');}		
                                        else
                                        {document.getElementById('busroledivs').style.display = 'none';  		
                                        $("busroleselect").prop('checked',false);  
                                        }

                                    if(localStorage.getItem("productSel")==='true' || localStorage.getItem("productSel")=== null){
                                        document.getElementById('productdivs').style.display = 'block';  
                                        $("productselect").prop('checked', true);   
                                        update(productJSON,'product');}
                                        else{
                                        document.getElementById('productdivs').style.display = 'none';  
                                        $("product").prop('checked',false);   }	

                                    if(localStorage.getItem("actorSel")==='true' || localStorage.getItem("actorSel")=== null){
                                        document.getElementById('actordivs').style.display = 'block';  
                                        $("actorselect").prop('checked', true);   
                                        update(actorJSON,'actor');}
                                        else{
                                        document.getElementById('actordivs').style.display = 'none';  
                                        $("actor").prop('checked',false);   }	

                                    if(localStorage.getItem("appServiceSel")==='true' || localStorage.getItem("appServiceSel")=== null){
                                    document.getElementById('appServicedivs').style.display = 'block';  
                                    $("appServiceselect").prop('checked', true);   
                                    update(appServiceJSON,'appService');}
                                    else{
                                    document.getElementById('appServicedivs').style.display = 'none';
                                    
                                    $("appService").prop('checked',false);   }
                                        if(localStorage.getItem("swComponentSel")==='true'|| localStorage.getItem("swComponentSel")=== null){		
                                        document.getElementById('swComponentdivs').style.display = 'block';  		
                                        $("swComponentselect").prop('checked', true);   				
                                        update(swComponentJSON,'swComponent');}		
                                        else{						
                                        document.getElementById('swComponentdivs').style.display = 'none';  		
                                        $("swComponent").prop('checked',false);   }				

                                    if(localStorage.getItem("projectSel")==='true' || localStorage.getItem("projectSel")=== null){
                                        document.getElementById('projectdivs').style.display = 'block';  
                                        $("projectselect").prop('checked', true);   
                                        update(projectJSON,'project');}
                                        else{
                                        document.getElementById('projectdivs').style.display = 'none';  
                                        $("project").prop('checked',false);   }

                                     if(localStorage.getItem("programmeSel")==='true' || localStorage.getItem("programmeSel")=== null){
                                        document.getElementById('programmedivs').style.display = 'block';  
                                        $("programmeselect").prop('checked', true);   
                                        update(programmeJSON,'programme');}
                                        else{
                                        document.getElementById('programmedivs').style.display = 'none';  
                                        $("programme").prop('checked',false);   }			


                                    
                                    </script>



						<div class="clearfix"/>
						<hr/>
					</div>

					<!--Setup Closing Tags-->
				</div>


				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="getJSON"> {"name":"<xsl:call-template name="RenderMultiLangInstanceName">
                <xsl:with-param name="theSubjectInstance" select="current()"/>
                <xsl:with-param name="isRenderAsJSString" select="true()"/>
            </xsl:call-template>","id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="getOptions">
		<xsl:variable name="this" select="name"/>
		<option value="{$this}">
			<xsl:if test="$this = $param1">
				<xsl:attribute name="selected">true</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="$this"/>
		</option>
	</xsl:template>

</xsl:stylesheet>
