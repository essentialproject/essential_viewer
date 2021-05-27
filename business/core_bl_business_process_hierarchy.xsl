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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Business_Process')"/>
 
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="businessCapability" select="/node()/simple_instance[type='Business_Capability']"/>
	<xsl:variable name="businessProcesses" select="/node()/simple_instance[type='Business_Process']"/>
	<xsl:variable name="subBusinessProcesses" select="$businessProcesses/own_slot_value[slot_reference='bp_sub_business_processes']/value"/>
	<xsl:variable name="topBusinessProcesses" select="$businessProcesses[not(name=$businessProcesses/own_slot_value[slot_reference='bp_sub_business_processes']/value)][count(own_slot_value[slot_reference='bp_sub_business_processes']/value)&gt;0]"/>
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


	<xsl:variable name="maxDepth" select="10"/>

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
				<title>APQC Process Hierarchy</title>
	
		<style>
			.front > ul,
			.front > ul > li > ul{
				padding: 0;
				list-style-type: none;
				margin: 0;
				display: flex;
			}
			
			.front > ul > li > ul{
				
				 <!--This value controls how capabilities are wrapped in columns-->
			}
			
			.front > ul > .l0_cap.double > div{
				width: 250px;
			}
			
			.front > ul > .l0_cap.triple > div{
				width: 380px;
			}
			
			.front > ul > .l0_cap.quad > div{
				width: 510px;
			}
			
			.front > ul > li > ul{
				flex-direction: column;
			}
			
			.back > div > ul,
			.back > div > ul > li > ul{
				padding: 0;
				list-style-type: none;
				margin: 0;
			}
			
			.back > div > ul > li > ul{
				display: flex;
				flex-wrap: wrap;
			}
			
			.back > ul > li > ul{
				max-width: 100%;
			}
			
			.back > ul > li > ul{
				flex-direction: row;
			}
			
			.l0_cap {
				font-weight: 700;
				border: 1px solid #ccc;
				margin: 0px;
				list-style-type: none;
				margin-right: 10px;
				margin-bottom: 10px;
				text-align: center;
			}
			
			.l0_cap > .l0_cap_content > .l0_cap_label > a {
				color: #fff;
			}
			
			.l1_cap{
				font-weight: 400;
				border: 1px solid #ccc;
				margin: 0px;
				list-style-type: none;
				margin-right: 10px;
				margin-bottom: 10px;
				text-align: center;
			}
			
			.front > ul > .l0_cap {
				width: 120px;
				height: 60px;
				
			}
			
			
			.l0_cap{
				font-size: 12px;
				width: 120px;
				min-width: 120px;
				height: 60px;
				max-height: 65px;
				position: relative;
				transition: margin-bottom 0.5s, height 0.5s line-height 0.5s;
				line-height: 1em;
				
			}
			
			.l1_cap{
				font-size: 12px;
				width: 120px;
				min-width: 120px;
				height: 60px;
				max-height: 65px;
				position: relative;
				transition: margin-bottom 0.5s, height 0.5s line-height 0.5s;
				line-height: 1em;
				
			}
			
			.l1_cap_label {
				padding: 2px;
			}
			
			.l0_cap_label {
				padding: 2px;
				font-weight:bold;
			}
			
			.l0_cap_content > i,.l1_cap_content > i {
				position: absolute;
				bottom: 5px;
				right: 5px;
			}
			
			.cp_header {
				margin-bottom:5px;
				padding: 5px;
			}
			
			.supportingCapsBox {
				border: 1px solid #ccc;
				padding: 5px;
			}
			
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
									<span class="text-darkgrey">Business Process Hierarchy</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">	
                             <xsl:if test="count($topBusinessProcesses)=0">
                                 <div class="col-xs-4" style="border:1pt solid #d3d3d3;border-radius:3px">
                                <i class="fa fa-warning" style="color:#e8a04d"></i>     
                                 No sub processes are defined.  This view requires a set of top level processes to have no parents, and to have children defined against the sub processes slot.  Sub processes can themselves have further sub processes defined against them</div>
                            </xsl:if>
							<div id="processModel"></div>
						</div>

<!-- Modal -->
<div class="modal fade" id="processModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h3 class="modal-title" id="exampleModalLabel">
        	<strong>Process Hierarchy</strong>
        	<button type="button" class="close" data-dismiss="modal" aria-label="Close"><i class="fa fa-times"/></button>	
        </h3>
      	<div><i class="fa fa-paperclip"></i> - process flow defined</div>		  
      </div>
      <div class="modal-body">
        <span id="modalContent"></span>
      </div>
    </div>
  </div>
</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		<script>
var model=[<xsl:apply-templates select="$topBusinessProcesses" mode="model"/>]
			$(document).ready(function() {                    
				var procFragmentFront   = $("#proc-template").html();
				procTemplateFront = Handlebars.compile(procFragmentFront);
			
			var modalFragmentFront   = $("#modal-template").html();
				modalTemplateFront = Handlebars.compile(modalFragmentFront);
			
			Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
			
	 
			$('#processModel').append(procTemplateFront(model));
			
			$('.fa-info-circle').click(function(){
				var thisId=$(this).attr('easid');
				var parentId=$(this).attr('parentid');
			 
			if(parentId){
				var thisProcess = model.filter(function(d){
					 return d.id == parentId;
					}) 
				var thisSubProcess = thisProcess[0].subProcess.filter(function(d){
						return d.id==thisId;
					});
				thisProcess=thisSubProcess;
				}else{
				var thisProcess = model.filter(function(d){
					 return d.id == thisId;
					}) 
			};
				 
			$('#modalContent').empty();
			$('#modalContent').append(modalTemplateFront(thisProcess))
		 $('#processModal').modal('show');
			
			});

		 
		});
		</script>	
 	    

<script id="modal-template" type="text/x-handlebars-template">
	<div class="row">
		{{#each this}} 
		<div class="col-md-8">
			<h4 class="text-primary">Selected Process: {{{link}}}</h4>
			<div class="impact bottom-10">Sub Processes</div>
			<ul class="fa-ul">
				{{#each this.subProcess}}
				<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
				<ul class="fa-ul">
					{{#each this.subProcess}}
					<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
					<ul class="fa-ul">
						{{#each this.subProcess}}
						<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
						<ul class="fa-ul">
							{{#each this.subProcess}}
							<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
							<ul class="fa-ul">
								{{#each this.subProcess}}
								<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
								<ul class="fa-ul">
									{{#each this.subProcess}}
									<li><i class="fa fa-li fa-caret-right"/>{{{link}}}{{#if this.flow}}<i class="fa fa-paperclip left-5"></i>{{/if}}</li>
									{{/each}}
								</ul>
								{{/each}}
							</ul>
							{{/each}}
						</ul>
						{{/each}}
					</ul>
					{{/each}}
				</ul>
				{{/each}}
			</ul>
	</div>
	<div class="col-md-4">
	{{#if this.capsSupporting}}
   		<div class="supportingCapsBox">
   			<h4 class="strong">Capabilities Supporting</h4>
	   		{{#each this.capsSupporting}}
	   			<div class="bottom-5"><i class="fa fa-circle-o right-5"/>{{{link}}}</div>
	   		{{/each}}
		</div>
	{{/if}}
	</div>
 {{/each}}

	</div>
</script>             				
<script id="proc-template" type="text/x-handlebars-template">
         	<div class="capModel">
				{{this.pos}}
				
				<div class="front" >
					<ul style="flex-wrap: wrap;">
						
                        {{#each this}}
						{{#ifEquals this.pos "Top"}}
                           <li class="l0_cap">  
                                <xsl:attribute name="class">{{capclass}}</xsl:attribute>
                                <div class="l0_cap bg-darkblue-80">
                                	<div class="l0_cap_content">
										<div class="l0_cap_label">{{{this.link}}} </div>
										<i class="fa fa-info-circle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute></i>
                                	</div>
                                </div>
                                <ul>
                                	{{#each this.subProcess}}
                                        <li class="l1_cap bg-offwhite"><xsl:attribute name="easid">{{id}}</xsl:attribute>
										 
                                        	<div class="l1_cap_content">
                                        		
	                                        	<div class="l1_cap_label"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>{{{link}}}</div>
												<div class="pull-right" style="position: absolute; top:45px;left:105px"><i class="fa fa-info-circle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="parentid">{{../this.id}}</xsl:attribute></i></div>
                                        	</div>
											 	
                                        </li>
                                     {{/each}}
                                </ul>
                            </li> 
							{{/ifEquals}}
                        {{/each}}
					</ul>
			
				</div>
				 
 	<div class="back">
					<div>
                    	{{#each this}}
							{{#ifEquals this.pos "Bottom"}}
							<ul>
							    <li class="l0_cap">  
							        <xsl:attribute name="class">
							        {{capclass}}
							        </xsl:attribute>
							        
							        <div class="bg-darkblue-40 impact large cp_header">
							            {{name}}
							        </div>
							        <ul>
							        	{{#each subProcess}}
							                <li class="l1_cap bg-offwhite"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
							                	<div class="l1_cap_content"><xsl:attribute name="eas-id">{{id}}</xsl:attribute>
		                                        	<div class="l1_cap_label">{{{this.link}}}</div>
		                                        	<i class="fa fa-info-circle"><xsl:attribute name="easid">{{this.id}}</xsl:attribute><xsl:attribute name="parentid">{{../this.id}}</xsl:attribute></i>
	                                        	</div>
	                                        </li>
							             {{/each}}
							        </ul>
							    </li>
							</ul>
							{{/ifEquals}}
                    	{{/each}}
					</div>
				</div>
			
			</div>
		</script>
				
		</html>
	</xsl:template>
<xsl:template match="node()" mode="model">
	<xsl:variable name="thissubBusinessProcesses" select="$businessProcesses[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
	<xsl:variable name="thisbusinessCapability" select="$businessCapability[name=current()/own_slot_value[slot_reference='realises_business_capability']/value]"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
	"pos":"<xsl:choose><xsl:when test="number(substring(current()/own_slot_value[slot_reference='business_process_id']/value,1,2))&lt;7">Top</xsl:when><xsl:otherwise><xsl:choose><xsl:when test="current()/own_slot_value[slot_reference='business_process_id']/value">Bottom</xsl:when><xsl:otherwise>Top</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
 "subProcess":[<xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"/>],
"capsSupporting":[<xsl:for-each select="$thisbusinessCapability">{"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>"}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>

<xsl:template match="node()" mode="subProcesses">
	<xsl:param name="depth" select="0"/>
	<xsl:variable name="thissubBusinessProcesses" select="$businessProcesses[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>
	<xsl:variable name="subBusinessProcesses" select="$businessProcesses[name=current()/own_slot_value[slot_reference='bp_sub_business_processes']/value]"/>	
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
 "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",	
<xsl:if test="current()/own_slot_value[slot_reference='defining_business_process_flow']/value">"flow":"yes",</xsl:if>	
	"subProcess":[
		<xsl:if test="$depth &lt;= $maxDepth"><xsl:apply-templates select="$thissubBusinessProcesses" mode="subProcesses"><xsl:with-param name="depth" select="$depth + 1"/></xsl:apply-templates></xsl:if>
	]}<xsl:if test="position()!=last()">,</xsl:if>	
	
</xsl:template>	
</xsl:stylesheet>
