<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
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
	<!-- 23.07.2013 JWC	Filter out irrelevant (e.g. closed) projects from the view -->

	<!-- param1 = the id of the project or project stakeholder whose network is to be displayed -->
	<xsl:param name="param1"/>
	<!-- param2 = the id of the programme who's to scope the projects to relate -->
	<xsl:param name="param2"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'" />
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')" />-->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Individual_Actor', 'Group_Actor', 'Project', 'Programme')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!--<xsl:variable name="parentProgramme" select="/node()/simple_instance[name = $param2]" />
	<xsl:variable name="programmeName" select="$parentProgramme/own_slot_value[slot_reference='name']/value" />-->

	<!-- Define the Project Status settings that exclude Projects from this View -->
	<xsl:variable name="anExcludeStatus" select="/node()/simple_instance[type = 'Project_Lifecycle_Status' and own_slot_value[slot_reference = 'name']/value = 'Closed']"/>

	<xsl:variable name="allProjects" select="/node()/simple_instance[type = 'Project' and not(own_slot_value[slot_reference = 'project_lifecycle_status']/value = $anExcludeStatus/name)]"/>
	<!--<xsl:variable name="allProjects" select="/node()/simple_instance[name = $parentProgramme/own_slot_value[slot_reference='projects_for_programme']/value]" />-->
	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $allProjects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[(type = 'Individual_Actor') and (name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value)]"/>
	<xsl:variable name="centralNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="networkDepth" select="4"/>


	<xsl:template match="pro:knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Project Network')"/>
				</title>
				<xsl:text disable-output-escaping="yes">&lt;!--[if IE]&gt;&lt;script language="javascript" type="text/javascript" src="js/excanvas.js?release=6.19"&gt;&lt;/script&gt;&lt;![endif]--&gt;</xsl:text>
				<script language="javascript" type="text/javascript" src="js/jit-yc.js?release=6.19"/>
				<!--<link type="text/css" href="css/essential_infovis_rgraph.css?release=6.19" rel="stylesheet"/>-->
				<style>
					#left-container{
						height: 590px;
						background-color: #fff;
						float: left;
						border: 1px solid #ccc;
						overflow: hidden;
						padding: 0;
					}
					
					#right-container{
						height: 600px;
						padding-left: 10px;
						overflow: auto;
					}
					
					#infovis{
						position: relative;
						width: 100%;
						height: 600px;
						overflow: hidden;
						margin: 0 auto;
					}
					
					#log{
						width: 100%;
						height: 30px;
						padding: 5px;
						background-color: #ddd;
						text-align: left;
						font-weight: bold;
						color: #fff;
						border-bottom: 1px solid #fff;
					}
					/*TOOLTIPS*/
					
					.tip{
						color: #111;
						width: 139px;
						background-color: white;
						border: 1px solid #ccc;
						-moz-box-shadow: #555 2px 2px 8px;
						-webkit-box-shadow: #555 2px 2px 8px;
						-o-box-shadow: #555 2px 2px 8px;
						box-shadow: #555 2px 2px 8px;
						opacity: 0.9;
						filter: alpha(opacity=90)
					
					;
						font-size: 10px;
						font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
						padding: 7px;
					}</style>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
			</head>
			<body onload="init();">
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading">
					<xsl:with-param name="contentID" select="$param1"/>
				</xsl:call-template>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">
										<xsl:value-of select="eas:i18n('Project Network')"/>
									</span>
								</h1>
							</div>
						</div>
						<!--Setup Chart Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa essicon-radialdots icon-section icon-color"/>
							</div>
							<h2 class="text-primary">
								<xsl:value-of select="eas:i18n('Project Network')"/>
							</h2>
							<p><xsl:value-of select="eas:i18n('This view shows relationships between people and currently active projects')"/>.</p>
							<xsl:call-template name="Index"/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="Index">

		<div id="left-container" class="col-xs-12 col-md-9">
			<div id="log"><xsl:value-of select="eas:i18n('Loading')"/>...</div>
			<div id="infovis"/>
		</div>
		<div id="right-container" class="col-xs-12 col-md-3">
			<div id="inner-details"/>
		</div>

		<script type="text/javascript">	
		var labelType, useGradients, nativeTextSupport, animate;
		
		(function() {
		  var ua = navigator.userAgent,
		      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
		      typeOfCanvas = typeof HTMLCanvasElement,
		      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
		      textSupport = nativeCanvasSupport 
		        &amp;&amp; (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
		  //I'm setting this based on the fact that ExCanvas provides text support for IE
		  //and that as of today iPhone/iPad current text support is lame
		  labelType = (!nativeCanvasSupport || (textSupport &amp;&amp; !iStuff))? 'Native' : 'HTML';
		  nativeTextSupport = labelType == 'Native';
		  useGradients = nativeCanvasSupport;
		  animate = !(iStuff || !nativeCanvasSupport);
		})();
		
		var Log = {
		  elem: false,
		  write: function(text){
		    if (!this.elem) 
		      this.elem = document.getElementById('log');
		    this.elem.innerHTML = text;
		    this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
		  }
		};
		
		<xsl:variable name="centralNodeName" select="$centralNode/own_slot_value[slot_reference = 'name']/value"/>
			
		function init(){
		   //init data
		    var json = 
		    {
		    	id: "<xsl:value-of select="$centralNode/name"/>",
		        name: "<xsl:value-of select="$centralNodeName"/>",
		        children: 
		        [
		        <!--
				Start Children//-->
				<xsl:choose>
					<xsl:when test="$centralNode/type = 'Project'">
						<xsl:call-template name="PrintProjectNetwork">
							<xsl:with-param name="currentProject" select="$centralNode"/>
							<xsl:with-param name="currentDepth" select="1"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$centralNode/type = 'Individual_Actor'">
						<xsl:call-template name="PrintActorNetwork">
							<xsl:with-param name="currentActor" select="$centralNode"/>
							<xsl:with-param name="currentDepth" select="1"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose> 
		        
		        <!--
				End Children//-->
		        ],
		        data: {
		            
		            <xsl:choose>
		            	<xsl:when test="$centralNode/type = 'Project'">
		            		<xsl:variable name="centralNodeStakeholders" select="$allStakeholders[name = $centralNode/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		            		<xsl:variable name="centralNodeActors" select="$allActors[name = $centralNodeStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
		            		<xsl:value-of select="eas:i18n('relation')"/>: 
		            		"<h3><xsl:value-of select="$centralNodeName"/></h3>
		            		<strong><xsl:value-of select="eas:i18n('People')"/>:</strong>
		            		<ul>
		            			<xsl:apply-templates mode="PrintActorName" select="$centralNodeActors">
		            				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
		            			</xsl:apply-templates>
		            		</ul>"
		            	</xsl:when>
		            	<xsl:when test="$centralNode/type = 'Individual_Actor'">
		            		<xsl:variable name="centralActorStakeholders" select="$allStakeholders[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $centralNode/name]"/>
		            		<xsl:variable name="relatedProjects" select="$allProjects[own_slot_value[slot_reference = 'stakeholders']/value = $centralActorStakeholders/name]"/>
		            		<xsl:variable name="relatedStakeholders" select="$allStakeholders[name = $relatedProjects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
		            		<xsl:variable name="relatedActors" select="$allActors[name = $relatedStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value] except $centralNode"/>
		            		<xsl:value-of select="eas:i18n('relation')"/>: 
		            		"<h3><xsl:value-of select="$centralNodeName"/></h3>
		            		<strong><xsl:value-of select="eas:i18n('Projects')"/>:</strong>
		            		<ul>
		            			<xsl:apply-templates mode="PrintProjectName" select="$relatedProjects">
		            				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
		            			</xsl:apply-templates>
		            		</ul>
		            		<strong><xsl:value-of select="eas:i18n('Project Colleagues')"/>:</strong>
		            		<ul>
		            			<xsl:apply-templates mode="PrintActorName" select="$relatedActors">
		            				<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
		            			</xsl:apply-templates>
		            		</ul>"
		            	</xsl:when>
		            </xsl:choose>
		        }
		    };
		    //end
		    
		    //init RGraph
		    var rgraph = new $jit.RGraph({
		        //Where to append the visualization
		        injectInto: 'infovis',
		        //Optional: create a background canvas that plots
		        //concentric circles.
		        background: {
		          CanvasStyles: {
		            strokeStyle: '#ddd'
		          }
		        },
		        //Add navigation capabilities:
		        //zooming by scrolling and panning.
		        Navigation: {
		          enable: true,
		          panning: true,
		          zooming: 10
		        },
		        //Set Node and Edge styles.
		        Node: {
		            color: '#4b306a'
		        },
		        
		        Edge: {
		          color: '#ccc',
		          lineWidth:1.5
		        },
		
		        onBeforeCompute: function(node){
		            Log.write("Focusing on " + node.name + "...");
		            //Add the relation list in the right column.
		            //This list is taken from the data property of each JSON node.
		            $jit.id('inner-details').innerHTML = node.data.relation;
		        },
		        
		        onAfterCompute: function(){
		            Log.write("Done");
		        },
		        //Add the name of the node in the correponding label
		        //and a click handler to move the graph.
		        //This method is called once, on label creation.
		        onCreateLabel: function(domElement, node){
		            domElement.innerHTML = node.name;
		            domElement.onclick = function(){
		                rgraph.onClick(node.id);
		            };
		        },
		        //Change some label dom properties.
		        //This method is called each time a label is plotted.
		        onPlaceLabel: function(domElement, node){
		            var style = domElement.style;
		            style.display = '';
		            style.cursor = 'pointer';
		
		            if (node._depth &lt;= 1) {
		                style.fontSize = "85%";
		                style.color = "#333";
		            
		            } else if(node._depth == 2){
		                style.fontSize = "70%";
		                style.color = "#bbb";
		            
		            } else if(node._depth == 3){
		            style.fontSize = "70%";
		            style.color = "#bbb";
		            
		            }
		            else {
		                style.display = 'none';
		            }
		
		            var left = parseInt(style.left);
		            var w = domElement.offsetWidth;
		            style.left = (left - w / 2) + 'px';
		        }
		    });
		    //load JSON data
		    rgraph.loadJSON(json);
		    //trigger small animation
		    rgraph.graph.eachNode(function(n) {
		      var pos = n.getPos();
		      pos.setc(-200, -200);
		    });
		    rgraph.compute('end');
		    rgraph.fx.animate({
		      modes:['polar'],
		      duration: 2000
		    });
		    //end
		    //append information about the root relations in the right column
		    $jit.id('inner-details').innerHTML = rgraph.graph.getNode(rgraph.root).data.relation;
		}
	
		</script>
	</xsl:template>


	<xsl:template name="PrintProjectNetwork">
		<xsl:param name="currentProject"/>
		<xsl:param name="currentDepth"/>
		<xsl:param name="parentActor"/>
		<xsl:if test="$currentDepth &lt;= $networkDepth">
			<xsl:variable name="relatedStakeholders" select="$allStakeholders[name = $currentProject/own_slot_value[slot_reference = 'stakeholders']/value]"/>
			<xsl:variable name="relatedActors" select="$allActors[name = $relatedStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
			<xsl:choose>
				<xsl:when test="string-length($parentActor) = 0">
					<xsl:for-each select="$relatedActors">
						<xsl:variable name="actorName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<!--<xsl:variable name="actorPeople" select="$relatedActors except current()"/>-->
						<xsl:variable name="actorAsRoles" select="$allStakeholders[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
						<xsl:variable name="actorProjects" select="$allProjects[own_slot_value[slot_reference = 'stakeholders']/value = $actorAsRoles/name]"/>
						<xsl:variable name="otherStakeholders" select="$allStakeholders[name = $actorProjects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
						<xsl:variable name="otherActors" select="$allActors[name = $otherStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value] except current()"/> { id: "<xsl:value-of select="current()/name"/>", name: "<xsl:value-of select="$actorName"/>", data: { relation: "<h3><xsl:value-of select="$actorName"/></h3>
						<strong><xsl:value-of select="eas:i18n('Projects')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintProjectName" select="$actorProjects">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
						<strong><xsl:value-of select="eas:i18n('Project Colleagues')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintActorName" select="$otherActors">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>" }, children: [ <xsl:call-template name="PrintActorNetwork">
							<xsl:with-param name="currentActor" select="current()"/>
							<xsl:with-param name="currentDepth" select="$currentDepth + 1"/>
							<xsl:with-param name="parentProject" select="$currentProject"/>
						</xsl:call-template> ] }<xsl:if test="not(position() = count($relatedActors))">,</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$relatedActors except $parentActor">
						<xsl:variable name="actorName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<!--<xsl:variable name="actorPeople" select="$relatedActors except current()"/>-->
						<xsl:variable name="actorAsRoles" select="$allStakeholders[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = current()/name]"/>
						<xsl:variable name="actorProjects" select="$allProjects[own_slot_value[slot_reference = 'stakeholders']/value = $actorAsRoles/name]"/>
						<xsl:variable name="otherStakeholders" select="$allStakeholders[name = $actorProjects/own_slot_value[slot_reference = 'stakeholders']/value]"/>
						<xsl:variable name="otherActors" select="$allActors[name = $otherStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value] except current()"/> { id: "<xsl:value-of select="current()/name"/>", name: "<xsl:value-of select="$actorName"/>", data: { relation: "<h3><xsl:value-of select="$actorName"/></h3>
						<strong><xsl:value-of select="eas:i18n('Projects')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintProjectName" select="$actorProjects">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>
						<strong><xsl:value-of select="eas:i18n('Project Colleagues')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintActorName" select="$otherActors">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>" }, children: [ <xsl:call-template name="PrintActorNetwork">
							<xsl:with-param name="currentActor" select="current()"/>
							<xsl:with-param name="currentDepth" select="$currentDepth + 1"/>
							<xsl:with-param name="parentProject" select="$currentProject"/>
						</xsl:call-template> ] }<xsl:if test="not(position() = count($relatedActors except $parentActor))">,</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>




	<xsl:template name="PrintActorNetwork">
		<xsl:param name="currentActor"/>
		<xsl:param name="currentDepth"/>
		<xsl:param name="parentProject"/>
		<xsl:if test="$currentDepth &lt;= $networkDepth">
			<xsl:variable name="actorStakeholders" select="$allStakeholders[own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $currentActor/name]"/>
			<xsl:variable name="relatedProjects" select="$allProjects[own_slot_value[slot_reference = 'stakeholders']/value = $actorStakeholders/name]"/>
			<xsl:choose>
				<xsl:when test="string-length($parentProject) = 0">
					<xsl:for-each select="$relatedProjects">
						<xsl:variable name="projectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="projectStakeholders" select="$allStakeholders[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
						<xsl:variable name="projectActors" select="$allActors[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/> { id: "<xsl:value-of select="current()/name"/>", name: "<xsl:value-of select="$projectName"/>", data: { relation: "<h3><xsl:value-of select="$projectName"/></h3>
						<strong><xsl:value-of select="eas:i18n('People')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintActorName" select="$projectActors">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>" }, children: [ <xsl:call-template name="PrintProjectNetwork">
							<xsl:with-param name="currentProject" select="current()"/>
							<xsl:with-param name="currentDepth" select="$currentDepth + 1"/>
							<xsl:with-param name="parentActor" select="$currentActor"/>
						</xsl:call-template> ] }<xsl:if test="not(position() = count($relatedProjects))">,</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="$relatedProjects except $parentProject">
						<xsl:variable name="projectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
						<xsl:variable name="projectStakeholders" select="$allStakeholders[name = current()/own_slot_value[slot_reference = 'stakeholders']/value]"/>
						<xsl:variable name="projectActors" select="$allActors[name = $projectStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/> { id: "<xsl:value-of select="current()/name"/>", name: "<xsl:value-of select="$projectName"/>", data: { relation: "<h3><xsl:value-of select="$projectName"/></h3>
						<strong><xsl:value-of select="eas:i18n('People')"/>:</strong>
						<ul>
							<xsl:apply-templates mode="PrintActorName" select="$projectActors">
								<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
							</xsl:apply-templates>
						</ul>" }, children: [ <xsl:call-template name="PrintProjectNetwork">
							<xsl:with-param name="currentProject" select="current()"/>
							<xsl:with-param name="currentDepth" select="$currentDepth + 1"/>
							<xsl:with-param name="parentActor" select="$currentActor"/>
						</xsl:call-template> ] }<xsl:if test="not(position() = count($relatedProjects except $parentProject))">,</xsl:if>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="PrintActorName">
		<!--<xsl:variable name="actorName" select="current()/own_slot_value[slot_reference='name']/value" />-->
		<li>
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>


	<xsl:template match="node()" mode="PrintProjectName">
		<xsl:variable name="projectName" select="current()/own_slot_value[slot_reference = 'name']/value"/>


		<li>
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>
	</xsl:template>
</xsl:stylesheet>
