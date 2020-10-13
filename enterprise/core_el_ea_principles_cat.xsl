<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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


	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<!-- param4 = the optional taxonomy term used to scope the view -->
	<!--<xsl:param name="param4" />-->
	<xsl:param name="targetReportId"/>
	<xsl:param name="targetMenuShortName"/>
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC CATALOGUE PARAMETERS -->


	<!-- START GENERIC CATALOGUE SETUP VARIABES -->
	<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname($targetMenuShortName)"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
 
	<xsl:variable name="linkClasses" select="('Business_Principle', 'Information_Principle', 'Application_Principle', 'Technology_Principle')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW-->
	<xsl:variable name="allBusPrinciples" select="/node()/simple_instance[type = 'Business_Principle']"/>
	<xsl:variable name="allAppPrinciples" select="/node()/simple_instance[type = 'Application_Architecture_Principle']"/>
	<xsl:variable name="allInfoPrinciples" select="/node()/simple_instance[type = 'Information_Architecture_Principle']"/>
	<xsl:variable name="allTechPrinciples" select="/node()/simple_instance[type = 'Technology_Architecture_Principle']"/>
	<xsl:variable name="allPrinciples" select="$allBusPrinciples union $allAppPrinciples union $allInfoPrinciples union $allTechPrinciples" ></xsl:variable>	

	<xsl:variable name="allBusPrinciplesAssessments" select="/node()/simple_instance[type = 'Business_Principle_Compliance_Assessment']"/>
	<xsl:variable name="allAppPrinciplesAssessments" select="/node()/simple_instance[type = 'Application_Principle_Compliance_Assessment']"/>
	<xsl:variable name="allInfoPrinciplesAssessments" select="/node()/simple_instance[type = 'Information_Principle_Compliance_Assessment']"/>
	<xsl:variable name="allTechPrinciplesAssessments" select="/node()/simple_instance[type = 'Technology_Principle_Compliance_Assessment']"/>
	<xsl:variable name="allDirectPrinciplesAssessments" select="$allBusPrinciplesAssessments union $allAppPrinciplesAssessments union $allInfoPrinciplesAssessments union $allTechPrinciplesAssessments"/>
	
	<xsl:variable name="allPolicy" select="/node()/simple_instance[supertype = 'Policy'][name=$allPrinciples/own_slot_value[slot_reference = 'principle_realisation_policies']/value]"/>
	<xsl:variable name="allControls" select="/node()/simple_instance[type = 'Control'][name=$allPolicy/own_slot_value[slot_reference = 'policy_controls']/value]"/>
	<xsl:variable name="allIndirectPrinciplesAssessments" select="/node()/simple_instance[type = 'Control_Assessment'][own_slot_value[slot_reference = 'assessment_control']/value=$allControls/name]"/>
    
    <xsl:variable name="principleLevels" select="/node()/simple_instance[type = 'Principle_Compliance_Level']"/>
	<xsl:variable name="assessmentLevels" select="/node()/simple_instance[type = 'Control_Assessment_Finding']"/>
	<xsl:variable name="allScoreLevels" select="$principleLevels union $assessmentLevels"/>
	<xsl:variable name="allassessmentLevelsMax" select="max($assessmentLevels/own_slot_value[slot_reference='enumeration_sequence_number']/value)"/>
	<xsl:variable name="allprincipleLevelsMax" select="max($principleLevels/own_slot_value[slot_reference='enumeration_sequence_number']/value)"/>
	<xsl:template match="knowledge_base">
		<!-- SET THE STANDARD VARIABLES THAT ARE REQUIRED FOR THE VIEW -->
		<xsl:choose>
			<xsl:when test="string-length($viewScopeTermIds) > 0">
				<xsl:variable name="orgScopeTerm" select="/node()/simple_instance[name = $viewScopeTerms/name]"/>
				<xsl:variable name="orgScopeTermName" select="$orgScopeTerm/own_slot_value[slot_reference = 'name']/value"/>
				<xsl:variable name="genericPageLabel">
					<xsl:value-of select="eas:i18n('EA Principles')"/>
				</xsl:variable>
				<xsl:variable name="pageLabel" select="concat($genericPageLabel, ' (', $orgScopeTermName, ')')"/>
				<xsl:call-template name="BuildPage">
					<xsl:with-param name="pageLabel" select="$pageLabel"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="BuildPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="BuildPage">
		<xsl:param name="pageLabel">
			<xsl:value-of select="eas:i18n('EA Principles')"/>
		</xsl:param>

		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="$pageLabel"/>
				</title>
				<script src="js/showhidediv.js" type="text/javascript"/>
				
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
                     .buttons{
                padding: 40px 0;
                }
                .nb-btn-circle{
                text-decoration: none;
                outline: none!important;
                position: relative;
                display: inline-block;
                height: 50px;
                width: 50px;
                margin: 0 10px 10px 0;
                color: #555;
                border-radius: 50%;
                -webkit-border-radius: 50%;
                -khtml-border-radius: 50%;
                border: 1px solid #ddd;
                background-color: #fff;
                background-image: -webkit-gradient(linear, left top, left bottom, from(#ffffff), to(#eeeeee));
                background-image: -webkit-linear-gradient(top, #ffffff, #eeeeee);
                background-image: -moz-linear-gradient(top, #ffffff, #eeeeee);
                background-image: -ms-linear-gradient(top, #ffffff, #eeeeee);
                background-image: -o-linear-gradient(top, #ffffff, #eeeeee);
                background-image: linear-gradient(to bottom, #ffffff, #eeeeee);
                transition:all 0.4s ease-in-out;
                }
 <!--               .nb-btn-circle:hover{
                background: #E91E63;
                border-color: #E91E63;
                color: #fff;
                }
-->
                .nb-btn-circle:focus{
                color: #E91E63;
                }


                .nb-btn-circle .fa {
                float: left;
                height: 100%;
                width: 100%;
                font-size: 20px;
                line-height: 49px;
                text-align: center;
                }
                .nb-btn-circle .indicator-dot {
                position: absolute;
                top: 0px;
                right: 0px;
                height: 16px;
                width: 16px;
                font-size: 10px;
                font-weight: bold;
                text-align: center;
                line-height: 14px;
                border-radius: 50%;
                -webkit-border-radius: 50%;
                -khtml-border-radius: 50%;
                -moz-border-radius: 50%;
                color: #fff;
                background-color: #D9534F;
                background-image: none;}
					.principleTable > td,
					.principleTable > th{
						vertical-align: top;
					}</style>
                
                <script>
                    $(document).ready(function(){
                        $('.fa-info-circle').click(function() {
                            $('[role="tooltip"]').remove();
                        });
                        $('.fa-info-circle').popover({
                            container: 'body',
                            html: true,
                            trigger: 'click',
                            content: function(){
                                return $(this).next().html();
                            }
                        });
                    });
                    
                     $(document).ready(function(){
                        $('.info-box').click(function() {
                            $('[role="tooltip"]').remove();
                        });
                        $('.info-box').popover({
                            container: 'body',
                            html: true,
                            trigger: 'click',
                            content: function(){
                                return $(this).next().html();
                            }
                        });
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
									<span class="text-darkgrey">
										<xsl:value-of select="$pageLabel"/>
									</span>
								</h1>
							</div>
						</div>
 
	 
               
            <xsl:variable name="panelID">#collapse<xsl:value-of select="position()"/></xsl:variable>                    
               <div class="panel panel-default">
                    <div class="col-xs-1">
                <div class="panel-heading">
                  <h4 class="panel-title">
                   <!--   <div class="col-xs-1">
                          <span style="font-size:14pt">Total Principles
                          </span>
                      </div>
                         <div class="col-xs-1" >
                             <span style="font-size:30pt;"><xsl:value-of select="count($allBusPrinciples) + count($allAppPrinciples) + count($allInfoPrinciples) + count($allTechPrinciples)"/></span>
                      </div>
      -->
                      <div style="float: left">
                          <span style="font-size:8pt;color:black" id="buts">Business</span><br/>
                          <a data-toggle="collapse" href="#collapse1" aria-expanded="true" aria-controls="collapseOne" class="nb-btn-circle">
                              <i class="fa fa-building-o"></i><span class="indicator-dot"> <xsl:value-of select="count($allBusPrinciples)"/> </span> 
                            </a> 
                          <span style="font-size:8pt;color:black" id="apps">Application</span><br/>
                              <a data-toggle="collapse" href="#collapse2" aria-expanded="true" aria-controls="collapseOne" class="nb-btn-circle" >
                              <i class="fa fa-tablet"></i><span class="indicator-dot"><xsl:value-of select="count($allAppPrinciples)"/> </span> 
                            </a>
                          <span style="font-size:8pt;color:black" id="info">Information</span><br/>
                          <a data-toggle="collapse" href="#collapse3" aria-expanded="true" aria-controls="collapseOne" class="nb-btn-circle"><span class="indicator-dot"> <xsl:value-of select="count($allInfoPrinciples)"/></span>
                            <i class="fa fa-file-code-o"></i>
                            </a> 
                          <span style="font-size:8pt;color:black" id="tech">Technology</span><br/>
                          <a data-toggle="collapse" href="#collapse4" aria-expanded="true" aria-controls="collapseOne" class="nb-btn-circle"><span class="indicator-dot"><xsl:value-of select="count($allTechPrinciples)"/></span>
                            <i class="fa fa-server"></i>
                            </a> 
                          
                            </div>  
        

                  </h4>
                </div>
                   </div>
                    <div class="col-xs-11">
                      <ul class="nav nav-tabs">
						  <li class="active"><a data-toggle="tab" href="#bus">Business</a></li>
						  <li><a data-toggle="tab" href="#app">Application</a></li>
						  <li><a data-toggle="tab" href="#techdiv">Technology</a></li>
						  <li><a data-toggle="tab" href="#infodiv">Information</a></li>						  
						</ul>   
					<div class="tab-content">	
                     <div id="bus" class="tab-pane fade in active">
                       <div class="panel-body">
                           <div class="container">
                               <div class="sectionIcon">
                                    <i class="fa fa-users icon-section icon-color"/>
                                </div>
                                <h2 class="text-primary">
                                    <xsl:value-of select="eas:i18n('Business Principles')"/>
                                </h2>
                                <div class="content-section">
                                    
                                <div class="col-xs-9">  
                                    <p><xsl:value-of select="eas:i18n('The following Business Principles guide and govern changes to the business architecture')"/>.</p>
                                    <xsl:choose>
                                        <xsl:when test="string-length($viewScopeTermIds) > 0">
                                            <xsl:variable name="busPrinciples" select="$allBusPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
                                            <xsl:apply-templates select="$busPrinciples" mode="BusinessPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="$allBusPrinciples" mode="BusinessPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>  
                                    <div class="col-xs-2" id="elements">  
                                                     
                                    </div>    
                                    
                               </div>
                           </div>
                       </div>
                    </div>     
                     <div id="app" class="tab-pane fade">
                       <div class="panel-body">
                           <div class="container">
                                <div class="sectionIcon">
                                    <i class="fa fa-tablet icon-section icon-color"/>
                                </div>
                                <h2 class="text-primary">
                                    <xsl:value-of select="eas:i18n('Application Principles')"/>
                                </h2>

                                <div class="content-section">
                                    <p><xsl:value-of select="eas:i18n('The following Application Principles guide and govern changes to the application architecture')"/>. </p>
                                    <xsl:choose>
                                        <xsl:when test="string-length($viewScopeTermIds) > 0">
                                            <xsl:variable name="appPrinciples" select="$allAppPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
                                            <xsl:apply-templates select="$appPrinciples" mode="ApplicationPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="$allAppPrinciples" mode="ApplicationPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                           </div>
                       </div>
                    </div>    
                     <div id="techdiv" class="tab-pane fade">
                       <div class="panel-body">
                           <div class="container">
                                <div class="sectionIcon">
                                    <i class="fa fa-database icon-section icon-color"/>
                                </div>

                                <h2 class="text-primary">
                                    <xsl:value-of select="eas:i18n('Information Principles')"/>
                                </h2>

                                <div class="content-section">
                                    <p><xsl:value-of select="eas:i18n('The following Information Principles guide and govern changes to the information and data architecture')"/>. </p>

                                    <xsl:choose>
                                        <xsl:when test="string-length($viewScopeTermIds) > 0">
                                            <xsl:variable name="infoPrinciples" select="$allInfoPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
                                            <xsl:apply-templates select="$infoPrinciples" mode="InformationPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="$allInfoPrinciples" mode="InformationPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                 </div>    
                           </div>
                       </div>
                    </div>    
                     <div id="infodiv" class="tab-pane fade">
                       <div class="panel-body">
                           <div class="container">
                                <div class="sectionIcon">
                                    <i class="fa essicon-server icon-section icon-color"/>
                                </div>
                                <h2 class="text-primary">
                                    <xsl:value-of select="eas:i18n('Technology Principles')"/>
                                </h2>
                                <div class="content-section">
                                    <p><xsl:value-of select="eas:i18n('The following Technology Principles guide and govern changes to the technology architecture')"/>. </p>
                                    <xsl:choose>
                                        <xsl:when test="string-length($viewScopeTermIds) > 0">
                                            <xsl:variable name="techPrinciples" select="$allTechPrinciples[own_slot_value[slot_reference = 'element_classified_by']/value = $viewScopeTerms/name]"/>
                                            <xsl:apply-templates select="$techPrinciples" mode="TechnologyPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="$allTechPrinciples" mode="TechnologyPrinciple">
                                                <xsl:sort order="ascending" select="own_slot_value[slot_reference = 'name']/value"/>
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                           </div>
                       </div>
                      
                    </div>    
                    </div>  
				   </div>
                  </div>   
                        
                        
                        
									<!--Start Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
                
                
                  <script>
					  
		var principles = [<xsl:apply-templates select="$allPrinciples" mode="principleRatings"/>];	
					  
		principles.forEach(function(e){
			var na=0,p1=0,p2=0,p3=0,p4=0;
				e.scores.forEach(function(d){
				if(d.assessmentPos&lt;0.26){
					  p4=p4+1;
					  }	 
				else if(d.assessmentPos&lt;0.51){
					  p3=p3+1;
					  }	
				else if(d.assessmentPos&lt;0.76){
					  p2=p2+1;
					  }	 
				else {
					  p1=p1+1;
					  }	 	  
				
					 
					   
			});		
					 e["p1"]=p1; 
					 e["p2"]=p2; 
					 e["p3"]=p3; 
					 e["p4"]=p4; 
		});				  
			console.log(principles)		
		principles.forEach(function(d){
					  console.log(d.principleID)
					$('.score[easid='+d.principleID+'p1]').text(d.p1);  
					 $('.score[easid='+d.principleID+'p2]').text(d.p2);  
					 $('.score[easid='+d.principleID+'p3]').text(d.p3);  
					 $('.score[easid='+d.principleID+'p4]').text(d.p4);   
					});			  
					  
                    $('a').on('click', function() {
                    $('div[id="' + $(this).data('div') + '"]').toggle(); 
                        });
                    
                 
                     $('.tog').click(function() {
                           $("i", this).toggleClass("fa-toggle-on fa-toggle-off");
                    });

                      
                    function butFunction(its) {
                        var x = document.getElementById(its);
 
                <!--        if (document.getElementById(its).className === 'btn btn-secondary btn-sm') {
                            document.getElementById(its).className = 'btn btn-primary btn-sm';-->
                      if (document.getElementById(its).style.color === 'black') {
                      
                        document.getElementById(its).style.color= 'red';      
                        } else {
                         document.getElementById(its).style.color = 'black';
                        }
                    }
    
                </script>
                
			</body>
		</html>
	</xsl:template>


	<xsl:template match="node()" mode="BusinessPrinciple">
		<!--<xsl:variable name="BusRationale" select="own_slot_value[slot_reference='business_principle_rationale']/value" />-->

		<xsl:variable name="multiLangRationale">
			<xsl:call-template name="RenderMultiLanguageRationale">
				<xsl:with-param name="aPrinciple" select="current()"/>
				<xsl:with-param name="defaultSlotName" select="'business_principle_rationale'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'business_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'bus_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'bus_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'bus_principle_tech_implications']/value"/>
        <xsl:variable name="thisAssessments" select="$allBusPrinciplesAssessments[own_slot_value[slot_reference='pca_principle_assessed']/value=current()/name]"/>
       
		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4> 
           	<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
  

            <xsl:call-template name="assessementTable">
                        <xsl:with-param name="thisAssessments" select="$thisAssessments"/>
				<xsl:with-param name="thisPrinciple" select="current()"/>
            </xsl:call-template>    
         <!--   
                principleLevels
    
        -->     

			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'business_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'business_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'bus_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'bus_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'bus_principle_tech_implications'"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="InformationPrinciple">
		<xsl:variable name="InfRationale" select="own_slot_value[slot_reference = 'information_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'inf_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'inf_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'inf_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'inf_principle_tech_implications']/value"/>
        <xsl:variable name="thisAssessments" select="$allInfoPrinciplesAssessments[own_slot_value[slot_reference='pca_principle_assessed']/value=current()/name]"/>
       
		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
            
     
            <xsl:call-template name="assessementTable">
                        <xsl:with-param name="thisAssessments" select="$thisAssessments"/>
				<xsl:with-param name="thisPrinciple" select="current()"/>
            </xsl:call-template>    
            
			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'information_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'inf_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'inf_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'inf_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'inf_principle_tech_implications'"/>
				</xsl:call-template>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="ApplicationPrinciple">
		<xsl:variable name="AppRationale" select="own_slot_value[slot_reference = 'application_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'app_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'app_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'app_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'app_principle_tech_implications']/value"/>
        <xsl:variable name="thisAssessments" select="$allAppPrinciplesAssessments[own_slot_value[slot_reference='pca_principle_assessed']/value=current()/name]"/>
       
		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
            
            <xsl:call-template name="assessementTable">
                        <xsl:with-param name="thisAssessments" select="$thisAssessments"/>
				<xsl:with-param name="thisPrinciple" select="current()"/>
            </xsl:call-template>    

			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'application_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'app_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'app_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'app_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'app_principle_tech_implications'"/>
				</xsl:call-template>

			</div>
		</div>
	</xsl:template>

	<xsl:template match="node()" mode="TechnologyPrinciple">
		<xsl:variable name="TechRationale" select="own_slot_value[slot_reference = 'technology_principle_rationale']/value"/>
		<xsl:variable name="BusImplications" select="own_slot_value[slot_reference = 'tech_principle_bus_implications']/value"/>
		<xsl:variable name="AppImplications" select="own_slot_value[slot_reference = 'tech_principle_app_implications']/value"/>
		<xsl:variable name="InfoImplications" select="own_slot_value[slot_reference = 'tech_principle_inf_implications']/value"/>
		<xsl:variable name="TechImplications" select="own_slot_value[slot_reference = 'tech_principle_tech_implications']/value"/>
        <xsl:variable name="thisAssessments" select="$allTechPrinciplesAssessments[own_slot_value[slot_reference='pca_principle_assessed']/value=current()/name]"/>
       
		<div class="largeThinRoundedBox">
			<h4>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</h4>
			<p class="text-default">
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
				<!--<xsl:value-of select="own_slot_value[slot_reference='description']/value" />-->
			</p>
            
            <xsl:call-template name="assessementTable">
                        <xsl:with-param name="thisAssessments" select="$thisAssessments"/>
						<xsl:with-param name="thisPrinciple" select="current()"/>
            </xsl:call-template>    

			<div class="ShowHideDivTrigger ShowHideDivOpen">
				<a class="ShowHideDivLink SmallBold small text-darkgrey" href="#">
					<xsl:value-of select="eas:i18n('Expand')"/>
				</a>
			</div>
			<div class="hiddenDiv">
				<br/>

				<xsl:call-template name="PrincipleImplications">
					<xsl:with-param name="aPrinciple" select="current()"/>
					<xsl:with-param name="RationaleSlot" select="'technology_principle_rationale'"/>
					<xsl:with-param name="BusImplicationSlot" select="'tech_principle_bus_implications'"/>
					<xsl:with-param name="InfoImplicationSlot" select="'tech_principle_inf_implications'"/>
					<xsl:with-param name="AppImplicationSlot" select="'tech_principle_app_implications'"/>
					<xsl:with-param name="TechImplicationSlot" select="'tech_principle_tech_implications'"/>
				</xsl:call-template>

			</div>
		</div>
	</xsl:template>

	<!-- GENERIC TEMPLATE TO PRINT OUT A BULLETED BUS/INFO/APP/TECH IMPLICATION -->
	<xsl:template match="node()" mode="Implications">
		<li>
			<xsl:value-of select="current()"/>
		</li>
	</xsl:template>

	<!-- GENERIC TEMPLATE TO PRINT OUT A BULLETED BUS/INFO/APP/TECH IMPLICATION -->
	<xsl:template name="RenderMultiLangImplications">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="defaultImplicationSlot"/>
		<xsl:param name="translationImplicationSlot"/>

		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:apply-templates select="$aPrinciple/own_slot_value[slot_reference = $defaultImplicationSlot]/value" mode="Implications"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="instanceSynonyms" select="$utilitiesAllSynonyms[(name = $aPrinciple/own_slot_value[slot_reference = $translationImplicationSlot]/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonyms) > 0">
						<xsl:apply-templates select="$instanceSynonyms/own_slot_value[slot_reference = 'name']/value" mode="Implications"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$aPrinciple/own_slot_value[slot_reference = $defaultImplicationSlot]/value" mode="Implications"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>



	<!-- GENECRIC TEMPLATE TO PRINT OUT THE BUS/INFO/APP/TECH IMPLICATIONS FOR A PRINCPLE -->
	<xsl:template name="PrincipleImplications">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="RationaleSlot"/>
		<xsl:param name="BusImplicationSlot"/>
		<xsl:param name="InfoImplicationSlot"/>
		<xsl:param name="AppImplicationSlot"/>
		<xsl:param name="TechImplicationSlot"/>
		<table class="noBorders principleTable">
			<tbody>
				<tr>
					<th class="cellWidth-15pc vAlignTop"><xsl:value-of select="eas:i18n('Rationale')"/>:</th>
					<td class="cellWidth-70pc">
						<xsl:choose>
							<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $RationaleSlot]/value) = 0">
								<em>-</em>
							</xsl:when>
							<xsl:otherwise>
								<ul>
									<li>
										<xsl:call-template name="RenderMultiLanguageRationale">
											<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
											<xsl:with-param name="defaultSlotName" select="$RationaleSlot"/>
										</xsl:call-template>
									</li>
								</ul>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $BusImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for the Business')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$BusImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_bus_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$BusImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $AppImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Applications')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$AppImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_app_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$AppImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $InfoImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Information')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$InfoImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_inf_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$InfoImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="count($aPrinciple/own_slot_value[slot_reference = $TechImplicationSlot]/value) > 0">
						<tr>
							<th class="vAlignTop"><xsl:value-of select="eas:i18n('Implications for Technology')"/>:</th>
							<td>
								<ul>
									<xsl:call-template name="RenderMultiLangImplications">
										<xsl:with-param name="aPrinciple" select="$aPrinciple"/>
										<xsl:with-param name="defaultImplicationSlot" select="$TechImplicationSlot"/>
										<xsl:with-param name="translationImplicationSlot" select="'principle_tech_implications_synonyms'"/>
									</xsl:call-template>
									<!--<xsl:apply-templates select="$TechImplications" mode="Implications" />-->
								</ul>
							</td>
						</tr>
					</xsl:when>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="RenderMultiLanguageRationale">
		<xsl:param name="aPrinciple"/>
		<xsl:param name="defaultSlotName"/>

		<xsl:choose>
			<xsl:when test="$currentLanguage/name = $defaultLanguage/name">
				<xsl:value-of select="$aPrinciple/own_slot_value[slot_reference = $defaultSlotName]/value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="instanceSynonym" select="$utilitiesAllSynonyms[(name = $aPrinciple/own_slot_value[slot_reference = 'principle_rationale_synonyms']/value) and (own_slot_value[slot_reference = 'synonym_language']/value = $currentLanguage/name)]"/>
				<xsl:choose>
					<xsl:when test="count($instanceSynonym) > 0">
						<xsl:value-of select="$instanceSynonym/own_slot_value[slot_reference = 'name']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$aPrinciple/own_slot_value[slot_reference = $defaultSlotName]/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template name="dataScopePopoverContent">
    	<xsl:param name="currentObject"/>
      <xsl:variable name="thisAssessments" select="$allBusPrinciplesAssessments[own_slot_value[slot_reference='pca_principle_assessed']/value=$currentObject]"/>
	<div class="text-default small hiddenDiv">
        <b>Assessed Elements</b>
        <ul> <xsl:apply-templates select="$currentObject" mode="list"/> </ul>

        
       
	</div>
</xsl:template>
    
<xsl:template match="node()" mode="list">
<xsl:variable name="this" select="current()"/>
<xsl:variable name="focusObject" select="/node()/simple_instance[name = $this/own_slot_value[slot_reference='pca_element_assessed']/value]"/>
    <li>
        <xsl:value-of select="$focusObject/own_slot_value[slot_reference='name']/value"></xsl:value-of><span style="font-size:8pt">(<xsl:value-of select="translate($focusObject/type,'_',' ')"></xsl:value-of>)</span>
    </li>    
</xsl:template>    
    
<xsl:template name="assessementTable">
    <xsl:param name="thisAssessments"/>
	<xsl:param name="thisPrinciple"/>
            <table width="400px" style="table-layout: fixed;">
            <tr><th width="200px"> </th><th colspan="5" width="120px" style="font-size:8pt">Principle Adherence</th><th></th></tr>
            <tr><th width="200px">Total Assessments</th> <th colspan="2" width="120px" style="font-size:8pt">Weak</th><th colspan="2"  width="80px" style="text-align:right;font-size:8pt">Strong</th><th></th></tr>
            <tr> 
                <td style="background-color:#ffffff;text-align:center" class="score">  
                  <span  class="info-box">  
                    </span>
                 </td>
                <td style="background-color:#fc6868;text-align:center;cursor:pointer" class="score"><xsl:attribute name="easid"><xsl:value-of select="$thisPrinciple/name"/>p1</xsl:attribute> 
                   
                </td>
                <td style="background-color:#ffd23b;text-align:center;cursor:pointer" class="score"><xsl:attribute name="easid"><xsl:value-of select="$thisPrinciple/name"/>p2</xsl:attribute>                 </td>
                <td style="background-color:#d8ff00;text-align:center;cursor:pointer" class="score"><xsl:attribute name="easid"><xsl:value-of select="$thisPrinciple/name"/>p3</xsl:attribute> 
                       </td>

                <td style="background-color:#99fc51;text-align:center;cursor:pointer" class="score">
					  <xsl:attribute name="easid"><xsl:value-of select="$thisPrinciple/name"/>p4</xsl:attribute>   
              </td>
                <td></td>
                </tr>
            </table>

</xsl:template>
<xsl:template match="node()" mode="principleRatings">
<xsl:variable name="thisDirectPrinciplesAssessments" select="$allDirectPrinciplesAssessments[own_slot_value[slot_reference = 'pca_principle_assessed']/value=current()/name]"/>
<xsl:variable name="thisPolicy" select="$allPolicy[name=current()/own_slot_value[slot_reference = 'principle_realisation_policies']/value]"/>
<xsl:variable name="thisControls" select="$allControls[name=$thisPolicy/own_slot_value[slot_reference = 'policy_controls']/value]"/>
<xsl:variable name="thisIndirectPrinciplesAssessments" select="$allIndirectPrinciplesAssessments[own_slot_value[slot_reference = 'assessment_control']/value=$thisControls/name]"/>
	{"principleID":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"scores":[<xsl:apply-templates select="$thisIndirectPrinciplesAssessments union $thisDirectPrinciplesAssessments" mode="assessments"/>]
	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="assessments">
	<xsl:variable name="prinScore" select="$allScoreLevels[name=current()/own_slot_value[slot_reference = 'pca_compliance_assessment_value']/value]"/>
	<xsl:variable name="assessScore" select="$allScoreLevels[name=current()/own_slot_value[slot_reference = 'assessment_finding']/value]"/>
	<xsl:variable name="thisScore" select="$prinScore union $assessScore"/>
{"assessment":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>",
 "assessmentID":"<xsl:value-of select="eas:getSafeJSString($thisScore/name)"/>",
 "assessmentScore":"<xsl:value-of select="$thisScore/own_slot_value[slot_reference='enumeration_sequence_number']/value"/>",
"assessmentPos":"<xsl:choose><xsl:when test="current()/type='Control_Assessment'"><xsl:value-of select="(($thisScore/own_slot_value[slot_reference='enumeration_sequence_number']/value) div $allassessmentLevelsMax)"/></xsl:when><xsl:otherwise><xsl:value-of select="(($thisScore/own_slot_value[slot_reference='enumeration_sequence_number']/value) div $allprincipleLevelsMax)"/></xsl:otherwise></xsl:choose>"	}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>	
</xsl:stylesheet>
