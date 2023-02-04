<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:include href="../common/core_roadmap_functions.xsl"></xsl:include>
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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider','Information_Representation','Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	
    <xsl:variable name="allApplications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider','Application_Provider_Interface')]"/>

	<xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allAPUs" select="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']"/>
    <xsl:variable name="allAppProtoInfo" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION'][name=$allAPUs/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
    <xsl:variable name="allInfo" select="/node()/simple_instance[type='Information_Representation'][name=$allAppProtoInfo/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
<!-- application capabilities -->
	<xsl:variable name="taxonomy" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Reference Model Layout')]"/> 
	<xsl:variable name="taxonomyCat" select="/node()/simple_instance[type='Taxonomy'][own_slot_value[slot_reference='name']/value=('Application Capability Category')]"/> 
	<xsl:variable name="taxonomyTerm" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomy/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
	<xsl:variable name="taxonomyTermCat" select="/node()/simple_instance[type='Taxonomy_Term'][name=$taxonomyCat/own_slot_value[slot_reference='taxonomy_terms']/value]"/> 
	<xsl:variable name="appCaps" select="/node()/simple_instance[type='Application_Capability']"/> 
 	<xsl:variable name="busCaps" select="/node()/simple_instance[type='Business_Capability']"/> 
	<xsl:variable name="busDomains" select="/node()/simple_instance[type='Business_Domain']"/> 
	<xsl:variable name="appServices" select="/node()/simple_instance[type='Application_Service']"/> 
	<xsl:variable name="aprRoles" select="/node()/simple_instance[type='Application_Provider_Role']"/> 
	<xsl:variable name="purpose" select="/node()/simple_instance[type='Application_Purpose']"/> 
	<xsl:variable name="applicationsRoadmap" select="$allApplications"/>
	<xsl:variable name="a2r" select="/node()/simple_instance[type='ACTOR_TO_ROLE_RELATION']"/>
	<xsl:variable name="actors" select="/node()/simple_instance[type='Group_Actor']"/>
	<xsl:variable name="codebases" select="/node()/simple_instance[type='Codebase_Status']"/>
	<xsl:variable name="deliveryTypes" select="/node()/simple_instance[type='Application_Delivery_Model']"/>
	<xsl:variable name="purposeTypes" select="/node()/simple_instance[type='Application_Purpose']"/>
	<xsl:variable name="family" select="/node()/simple_instance[type='Application_Family']"/>
	<xsl:variable name="elementStyle" select="/node()/simple_instance[type='Element_Style']"/>

	<xsl:variable name="appsData" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"></xsl:variable>

<!--	* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<xsl:variable name="allRoadmapInstances" select="$applicationsRoadmap"/>
    <xsl:variable name="isRoadmapEnabled" select="eas:isRoadmapEnabled($allRoadmapInstances)"/>
	<xsl:variable name="rmLinkTypes" select="$allRoadmapInstances/type"/>	


	<xsl:template match="knowledge_base">
			<xsl:variable name="apiApps">
					<xsl:call-template name="GetViewerAPIPath">
						<xsl:with-param name="apiReport" select="$appsData"></xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<script src="js/d3/d3.v5.7.0.min.js"/>
                <script src="js/dagre/dagre.min.js"></script>
				<script src="js/dagre/dagre-d3.min.js"></script> 
 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Data Dependencies</title>
                  <style>
                .clusters rect {
                          fill: #00ffd0;
                          stroke: #999;
                          stroke-width: 1.5px;
                        }

                        text {
                          font-weight: 300;
                          font-family: "Helvetica Neue", Helvetica, Arial, sans-serf;
                          font-size: 10px;
                        }

                        .node rect {
                          stroke: #999;
                          fill: #fff;
                          stroke-width: 1.5px;
                        }

                        .edgePath path {
                          stroke: #333;
                          stroke-width: 1.5px;
                        }
                 	
					   .ds {
						display: inline-block;
						 min-width: 100px;
						 background-color:#ffffff;
						 width: 100%;
						 border-radius:3px;
						 color:#000000;
						 text-transform: uppercase;
						 min-height:20px;
						 font-weight:700;
						 vertical-align: middle;
						 padding: 5px;
						 font-size:12px;
						 border-radius: 4px;
						 margin-bottom: 4px;
					  }

					  .dw{
					 	border:1px solid #ccc;
						margin-top:4px;
						color:#000;
						width: 100%;
						background-color:#ffffff;
						padding: 5px;
						font-size:12px;
						border-radius: 4px;
					  }

					  span.tp {
						display: inline-block;
						 font-weight:normal;
					  	color:#000;
					  }
					  span.tc {
						display: inline-block;
						 font-weight:normal;
					  	color:#000;
					  }

					 .apibadge {
						 border-radius:4px;
						 background-color: #7b0071;
						 color:#fff;
						 font-size:0.8em;
					 }
					 .appbadge {
						 border-radius:4px;
						 background-color: #333;
						 color:#fff;
						 padding: 5px;
					 }
					 
					 .key  {
						top: -30px;
						position: relative;
					}
                </style>
     
                 <script>
                        var nodeTemplate;
                       
                        $(document).ready(function() {
                            var nodeFragment = $("#node-template").html();
                            nodeTemplate = Handlebars.compile(nodeFragment);
                            
					 		var ifaceListFragment = $("#iface-list-template").html();
							ifaceListTemplate = Handlebars.compile(ifaceListFragment);
							
					 		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
							return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
						});
                        });

                </script>
				<xsl:call-template name="RenderRoadmapJSLibraries">
					<xsl:with-param name="roadmapEnabled" select="$isRoadmapEnabled"/>
				</xsl:call-template>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<xsl:call-template name="ViewUserScopingUI"></xsl:call-template>
				<xsl:if test="$isRoadmapEnabled">
					<xsl:call-template name="RenderRoadmapWidgetButton"/>
				</xsl:if>
				<div id="ess-roadmap-content-container">
					<xsl:call-template name="RenderCommonRoadmapJavscript">
						<xsl:with-param name="roadmapInstances" select="$allRoadmapInstances"/>
						<xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/>
					</xsl:call-template>
				
					<div class="clearfix"></div>
				</div>
		
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Application Connections')"/></span>
								</h1>
								<div class="key pull-right">
								<strong class="right-5">Key:</strong>	
									<span class="appbadge right-10" style="padding:5px;opacity:1;">Application in Scope</span>
									<span class="appbadge right-10" style="padding:5px;opacity:0.5;">Dependency</span>
									<i class="fa fa-info-circle" id="infoModal"></i>
								</div>
							</div>
							<div class="row">
								<div class="col-md-2">
									<label> Application Capabilities</label>
									<div><select class="form-control" id="caps" style="width:100%"><option value="all">Select</option><option value="all">All</option></select></div>
								</div>
								<div class="col-md-2">
									<label> Application Services</label>
									<div><select class="form-control" id="services" style="width:100%"><option value="all">All</option></select></div>
								</div>
								<div class="col-md-2">
									<div><button class="btn btn-default btn-sm right-15 top-15"  style="margin-top:25px" id="refresh"><i class="fa fa-refresh right-5"></i>Reset Image</button></div>
								</div>
							</div>
							 
							<hr/>
	
						
						</div>
						<!--Setup Description Section-->
						<div class="col-xs-12">                
								<div class="simple-scroller">
									<svg width="100" height="100" id="depGraph"><g/></svg>
								</div>
								<div id="explainModal" class="modal fade" role="dialog">
									<div class="modal-dialog"> 
										<div class="modal-content">
										<div class="modal-body">
											<h3 class="strong">Explainer</h3>
											<div class="appbadge" style="padding:5px;background-color:#333;display:inline-block">Application in Scope</div>
											<p>The applications in scope are those applications directly impacted by the selected filters.</p>
											<div class="appbadge" style="padding:5px;background-color:#cccccc;display:inline-block">Dependency</div>
											<p>The dependency applications are those that have a dependency <b>to</b> or <b>from</b> the applications in scope</p>
										</div>
										<div class="modal-footer">
											<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
										</div>
										</div>

									</div>
									</div>
							
							<hr/>
						</div>
 
						<!--Setup Closing Tags-->
					</div>
				</div>
				
<div id="relations" class="modal fade" role="dialog">
  <div class="modal-dialog modal-lg">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Interfaces</h4>
      </div>
      <div class="modal-body">
		 <div id="iface"></div>
      
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>	
<script id="iface-list-template" type="text/x-handlebars-template">
 {{#each this}}
 <div style="display:inline-block; width:240px;border:1pt solid #d3d3d3;min-height:150px;border-radius:3px; margin:2px;vertical-align:top">
	<b>Source:</b> {{this.from}}<br/>
	<b>Target:</b> {{this.to}}<br/>
	 <table id="interfaces">
		<thead><tr><th width="100%">Interface</th></tr></thead>
		 <tbody>
		 {{#each this.links}}	 
			<tr><td>{{{this.link}}}</td></tr>
		 {{/each}}
		 </tbody>
		  </table>	
</div>	 
 	{{/each}}
</script>				
	<script> 

	let	inScopeApps=[];
	let appCapList=[];
	let appList=[];
	let depList=[];
	let scopedAppsList=[];
	let thisstyles, thisPurpose, thisFamily;
	var roadmapApps = [ <xsl:apply-templates select="$applicationsRoadmap" mode="roadmapApps"/>];
 
	$(document).ready(function(){
		$('#infoModal').on('click', function(){
			$('#explainModal').modal('show');
		})
})



function setCaps(cap){
 
	let focusCap=appCapList.find((e)=>{
			return e.id==cap;
		});
		$('#services').empty();
		$('#services').append('<option value="all">All</option>');
		let thisCapSvcs=[];
		
		if(focusCap){
		if(focusCap.relatedServices){
		focusCap.relatedServices.forEach((d)=>{
				let thisSvc = svcList.find((e)=>{
					return e.id ==d
				});
				$('#services').append('<option value="'+thisSvc.id+'">'+thisSvc.name+'</option>');
				thisCapSvcs.push(thisSvc)
			});
		}
		else{
			focusCap['relatedServices']=[];
		}
		focusCap['scopedService']=focusCap.relatedServices;
	}

		$('#services').on('change',function(){
			let selectedSvc = $(this).find('option').filter(':selected').val()
			let svcObj=thisCapSvcs.find((cs)=>{
				return cs.id==selectedSvc;
			});
 
			if(svcObj){
	 		let svcApps = [];
			svcObj.relatedApps.forEach((d)=>{
				let inScopeSvc = scopedAppsList.find((e)=>{
					return e.appId==d;
				})
				if(inScopeSvc){
					svcApps.push(inScopeSvc)
				}
			})

		 		getDependencies(focusCap,svcList, svcApps)
			}
			else
			{
			 if(selectedSvc=='all'){
				
				$('#refresh').trigger("click")

			 	};
			};
		})
 
		getDependencies(focusCap,svcList, scopedAppsList)
}
function getDependencies(focusCap,svcList, apps){
 
	inScopeApps=[] 
	let newAppList=[];
	let coreAppList=[];

 
	if(focusCap){
		if(focusCap=='all'){	
			apps.forEach((a)=>{
					newAppList.push(a)
					coreAppList.push(a)
			});
		}
		else{
		
			getAppsArray(focusCap,svcList); 
			focusCap.childrenCaps.forEach((c)=>{
				let thisCap=appCapList.find((e)=>{
					return e.id==c;
				});
				getAppsArray(thisCap,svcList);
			});	 
	
			
			inScopeApps.forEach((a)=>{
				let getApp=apps.find((t)=>{
					return t.appId== a;
				});
				if(getApp){
					newAppList.push(getApp)
					coreAppList.push(getApp)
				}
			});
		}	

	  
		newDepList=[]; 
		newAppList.forEach((e)=>{ 
			 
			if(e){


			let thisNode = depList.find((f)=>{
				return f.ApplicationID==e.appId;
			});
			newDepList.push(thisNode); 
	 
			thisNode.From.forEach((f)=>{
		 
				let here=apps.find((ap)=>{
					return ap.appId==f.appid;
				})
				if(here){
					newAppList.push({"appId": f.appid, "appName": f.appName, "codebase": f.codebase, "codebaseName": f.codebaseName, "delivery":f.delivery, "type":f.type, "col":"#cccccc"});
				}  
			});
			thisNode.To.forEach((f)=>{
				let here=apps.find((ap)=>{
					return ap.appId==f.appid;
				})
				if(here){
					newAppList.push({"appId": f.appid, "appName": f.appName, "codebase": f.codebase, "codebaseName": f.codebaseName, "delivery":f.delivery, "type":f.type, "col":"#cccccc"});
				} 
				
			})
		}
		});
 
		newAppList=newAppList.filter((elem, index, self) => self.findIndex( (t) => {return (t.appId === elem.appId)}) === index)
 
		newAppList.forEach((e)=>{
			letIn = coreAppList.find((g)=>{
				return g.appId ==e.appId;
			})
			console.log('letIn',letIn)
			console.log(typeof letIn)
			if(typeof letIn=='undefined'){ 
				e.col="#999"
			}else{ 
				e.col="#000"
			}
 
		})
		console.log('newAppList',newAppList)
		console.log('coreAppList',coreAppList)
		newDepList=newDepList.filter((elem, index, self) => self.findIndex( (t) => {return (t.ApplicationID === elem.ApplicationID)}) === index)
	 
		createChart(newDepList, newAppList)
		
	}
	else
	{
 
		newDepList=[];
		newAppList=[];
		createChart(newDepList, newAppList)
	}
	
}

function getAppsArray(cap,svcList){
	if(cap){
		if(cap.relatedServices){
		cap.relatedServices.forEach((e)=>{
				let thisSvc = svcList.find((f)=>{ 
					return f.id == e
				});

				if(thisSvc.relatedApps){
					thisSvc.relatedApps.forEach((app)=>{
						inScopeApps.push(app)
					})
				}
			});
		}
	}
}

var redrawView = function () { 
				let scopedRMApps = [];
				appList.forEach((d) => {
					scopedRMApps.push(d)
				});
				let toShow = [];
			 
				// *** REQUIRED *** CALL ROADMAP JS FUNCTION TO SET THE ROADMAP STATUS OF ALL RELEVANT JSON OBJECTS
				if (roadmapEnabled) {
					//update the roadmap status of the caps passed as an array of arrays
					rmSetElementListRoadmapStatus([scopedRMApps]);

					// *** OPTIONAL *** CALL ROADMAP JS FUNCTION TO FILTER OUT ANY JSON OBJECTS THAT DO NOT EXIST WITHIN THE ROADMAP TIMEFRAME
					//filter caps to those in scope for the roadmap start and end date
					toShow = rmGetVisibleElements(scopedRMApps);
				} else {
					toShow = appList;
				}

 
				let appOrgScopingDef = new ScopingProperty('stakeholdersA2R', 'ACTOR_TO_ROLE_RELATION');
				let capOrgScopingDef = new ScopingProperty('orgUserIds', 'Group_Actor');
				let geoScopingDef = new ScopingProperty('geoIds', 'Geographic_Region'); 
				let visibilityDef = new ScopingProperty('visId', 'SYS_CONTENT_APPROVAL_STATUS');

                let scopedApps = essScopeResources(toShow, [capOrgScopingDef, appOrgScopingDef, visibilityDef, geoScopingDef].concat(dynamicAppFilterDefs));
 
				scopedAppsList = scopedApps.resources;  
 
				let thisId=$('#caps').val()
				if(thisId == 'all'){
					
						getDependencies(thisId,svcList, scopedAppsList)
						
					}
					else{
						setCaps(thisId)
					}

				
			}
	  
		function redrawView() {
			essRefreshScopingValues()
		}



<!-- create graph -->
function createChart(depList, appList){
	 console.log('appList2',appList)
	var g;
	g = new dagreD3.graphlib.Graph().setGraph({ rankdir: "LR"});
let attachedApps=[];
console.log('ddepList',depList)
depList.forEach((d)=>{   
	if(d.From.length&gt;0){
		d.From.forEach((fr)=>{ 
			let here=scopedAppsList.find((ap)=>{
					return ap.appId==fr.appid;
				})
				if(here){  
					attachedApps.push({"id":fr.appid,"name":fr.appName})
					attachedApps.push({"id":d.ApplicationID,"name":d.ApplicationName})
			g.setEdge(fr.appName,  d.ApplicationName,     { label: "",curve: d3.curveBundle.beta(0.5)  });
				}
		});
	}
	if(d.To.length&gt;0){
		d.To.forEach((to)=>{
			if(to){ 
				let here=scopedAppsList.find((ap)=>{
					return ap.appId==to.appid;
				})
				if(here){  
					attachedApps.push({"id":to.appid,"name":to.appName})
					attachedApps.push({"id":d.ApplicationID,"name":d.ApplicationName})
			g.setEdge(d.ApplicationName,  to.appName,     { label: "",curve:d3.curveBundle.beta(0.5)  });
				}
			}
		})
	}
	})
	attachedApps = [...new Set(attachedApps)];
	attachedApps= attachedApps.filter((value, index, self) =>
  index === self.findIndex((t) => (
    t.id === value.id  
  ))
)
 console.log('attachedApps',attachedApps)
// States and transitions from RFC 793
 
// Automatically label each of the nodes
var nodes = []; 
 console.log('scopedAppsList',scopedAppsList)
scopedAppsList.forEach((d)=>{

	let includeApp=attachedApps.find((a)=>{
		return a.id==d.appId
	})  
	if(includeApp){
	if(typeof includeApp.id !='undefined'){ 
	var niceLabel;
	let thisCodeColour ={};
	let thisDeliveryColour={}
	thisCodeColour=thisstyles.codebase.find((e)=>{
		return e.id == d.codebase;
	}); 

	if(thisCodeColour){
		if(thisCodeColour.colour){}else{thisCodeColour['colour']='#000000';}
		if(thisCodeColour.bgcolour){}else{thisCodeColour['bgcolour']='#ffffff';}
	}
	else{ 
		thisCodeColour ={};
		thisCodeColour['colour']='#000000';
		thisCodeColour['bgcolour']='#ffffff';
		if(d.codebaseName){
		thisCodeColour['name']=d.codebaseName;
		}else{
			thisCodeColour['name']='Codebase not set'
		}
	}

	thisDeliveryColour = thisstyles.delivery.find((e)=>{
		return e.id == d.delivery;
	}); 

	if(thisDeliveryColour){
		if(thisDeliveryColour.colour){}else{thisDeliveryColour['colour']='#000000';}
		if(thisDeliveryColour.bgcolour){}else{thisDeliveryColour['bgcolour']='#ffffff';}
	}
	else{ 
		thisDeliveryColour ={};
		thisDeliveryColour['colour']='#000000';
		thisDeliveryColour['bgcolour']='#ffffff';
		if(d.codebaseName){
		thisDeliveryColour['name']=d.delivery;
		}else{
			thisDeliveryColour['name']='Delivery model not set'
		}
	}

	let appColour=appList.find((a)=>{
		return a.appId==d.appId
	})
	console.log('appColour1',appColour)
	if(typeof appColour=='undefined'){
		 
		let appColour={}
		appColour['col']='red'
		console.log('appColour2',appColour)
	}else{
		console.log('appColour3',appColour)
	}
	
	 
 if(d.type !=='Application_Provider_Interface'){
	console.log('appColour4',appColour)
	if(typeof appColour=='undefined'){
		niceLabel='<div eascodebase="'+d.codebase+'" easdelivery="'+d.delivery+'"><div class="ds">'+d.appName+'</div><div class="appbadge"><xsl:attribute name="style">background-color:#999</xsl:attribute>Application</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisCodeColour.bgcolour+';color:'+thisCodeColour.colour+'</xsl:attribute>'+thisCodeColour.name +'</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisDeliveryColour.bgcolour+';color:'+thisDeliveryColour.colour+'</xsl:attribute>'+thisDeliveryColour.name +'</div>'; 
		niceLabel +='</div>';
		 
	 }else{
 niceLabel='<div eascodebase="'+d.codebase+'" easdelivery="'+d.delivery+'"><div class="ds">'+d.appName+'</div><div class="appbadge"><xsl:attribute name="style">background-color:'+appColour.col+'</xsl:attribute>Application</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisCodeColour.bgcolour+';color:'+thisCodeColour.colour+'</xsl:attribute>'+thisCodeColour.name +'</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisDeliveryColour.bgcolour+';color:'+thisDeliveryColour.colour+'</xsl:attribute>'+thisDeliveryColour.name +'</div>'; 
		niceLabel +='</div>';
	 }
	}
	else{ 
	niceLabel='<div eascodebase="'+d.codebase+'" easdelivery="'+d.delivery+'"><div class="ds">'+d.appName+'</div><div class="apibadge"><xsl:attribute name="style">background-color:'+appColour.col+'</xsl:attribute>API</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisCodeColour.name +';color:'+thisCodeColour.colour+'</xsl:attribute>'+d.codebaseName +'</div>';
		niceLabel +='<div class="dw"><xsl:attribute name="style">background-color:'+thisDeliveryColour.bgcolour+';color:'+thisDeliveryColour.colour+'</xsl:attribute>'+thisDeliveryColour.name +'</div>'
		niceLabel +='</div>';
	}

	nodes.push(g.setNode(d.appName, { labelType:"html", label: niceLabel }) );
 
	}	
}
});
  
// Set some general styles
g.nodes().forEach(function(v) {
		 
  var node = g.node(v); 
  node.rx = node.ry = 5;
});

// Add some custom colors based on state


var svg = d3.select("svg"),
    inner = svg.select("g");

// Set up zoom support
if(nodes.length &gt; 0){
var zoom = d3.zoom().on("zoom", function() {
      inner.attr("transform", d3.event.transform);
    });
svg.call(zoom);
}
// Create the renderer
var render = new dagreD3.render();

// Run the renderer. This is what draws the final graph.
render(inner, g);

// Center the graph
var initialScale = 1;
if(nodes.length &gt; 0){
 	svg.call(zoom.transform, d3.zoomIdentity.translate((svg.attr("width") - g.graph().width * initialScale) / 2, 20).scale(initialScale));
}
 
if(g.graph().height == -Infinity){
 
	g.graph().height = 600;
}
else
{
if(g.graph().height == 600){
	$('#refresh').trigger("click")
}
}
 
var windowHeight = $(window).height();
var windowWidth = $(window).width();
 
//svg.attr('height', g.graph().height * initialScale + 40);
svg.attr('width', windowWidth-30);
svg.attr('height', windowHeight-300);

}
</script>            
            <xsl:call-template name="nodeHandlebarsTemplate"/>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				<script>			
					<xsl:call-template name="RenderViewerAPIJSFunction"> 
						<xsl:with-param name="viewerAPIPathApps" select="$apiApps"></xsl:with-param>   
					</xsl:call-template>  
				</script>
	</body>
</html>
	</xsl:template>
    
<xsl:template name="nodeHandlebarsTemplate">
		<script id="node-template" type="text/x-handlebars-template">
              <div class="card" style='float:left'>
                  <div class="card-header">{{this.node}}</div>
                            <div class="card-main">
                                <div class="main-description"><xsl:attribute name="onclick">getChart('{{this.node}}',{{this.containedInstance}});</xsl:attribute><span class="badge badge-info" style="background-color:#7b8dc9">{{this.containedInstance}}</span></div>
                            </div>
                            <div class="card-tech">
                                <div class="tech-description">{{this.node_technology}}</div>
                            </div>
                        </div>

        </script>
	</xsl:template>    
 
	<xsl:template match="node()" mode="getApps">
		<xsl:variable name="usages"	select="$allArchUsages[own_slot_value[slot_reference='static_usage_of_app_provider']/value=current()/name]" />
		<xsl:variable name="subApps" select="$allApplications[name=current()/own_slot_value[slot_reference='contained_application_providers']/value]" />
		<xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=current()/name]" />	
		{"ApplicationName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"type":"<xsl:value-of select="current()/type"/>",
		"ApplicationID": "<xsl:value-of select="eas:getSafeJSString(current()/name)" />",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()" />
		</xsl:call-template>",
		"From":[<xsl:apply-templates select="$usages" mode="getFromUsages" />],
		"To":[<xsl:apply-templates select="$usages" mode="getToUsages" />], 
		"codebase":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
		"codebaseName":"<xsl:value-of select="$codebases[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"delivery":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
		"parent":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parent"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)" />"}<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:template>
		<xsl:template match="node()" mode="getToUsages">
			<xsl:variable name="TOs" select="$allAPUs[own_slot_value[slot_reference=':TO']/value=current()/name]"/>    

			<xsl:apply-templates select="$TOs" mode="gettoAPU"></xsl:apply-templates><xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template> 
	<xsl:template match="node()" mode="getFromUsages">
			<xsl:variable name="FROMs" select="$allAPUs[own_slot_value[slot_reference=':FROM']/value=current()/name]"/>    
		<xsl:apply-templates select="$FROMs" mode="getfromAPU"></xsl:apply-templates>
	</xsl:template> 
	
	<xsl:template match="node()" mode="gettoAPU">
		<xsl:variable name="ArchUsages" select="$allArchUsages[name=current()/own_slot_value[slot_reference=':FROM']/value]"/>
		<xsl:variable name="thisApplication" select="$allApplications[name=$ArchUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
		<xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=$thisApplication/name]"/>
		<xsl:variable name="thisAppProtoInfo" select="$allAppProtoInfo[name=current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
		<xsl:if test="$thisApplication/name">
		{"appid":"<xsl:value-of select="eas:getSafeJSString($thisApplication/name)"/>",
		"appName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"codebase":"<xsl:value-of select="eas:getSafeJSString($thisApplication/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
		"type":"<xsl:value-of select="$thisApplication/type"/>",
		"codebaseName":"<xsl:value-of select="$codebases[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"delivery":"<xsl:value-of select="eas:getSafeJSString($thisApplication/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
		"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/></xsl:call-template>", 
		"parent":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parent"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>", 
		"parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)"/>"<!--, "data":[<xsl:apply-templates select="$thisAppProtoInfo" mode="dataPassing"/>]-->},</xsl:if>
	</xsl:template> 
		<xsl:template match="node()" mode="getfromAPU">
			<xsl:variable name="ArchUsages" select="$allArchUsages[name=current()/own_slot_value[slot_reference=':TO']/value]"/>
			<xsl:variable name="thisApplication" select="$allApplications[name=$ArchUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/>
			<xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=$thisApplication/name]"/>
			<xsl:variable name="thisAppProtoInfo" select="$allAppProtoInfo[name=current()/own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value]"/>
			<xsl:if test="$thisApplication/name">
				{"appid":"<xsl:value-of select="eas:getSafeJSString($thisApplication/name)"/>",
				"appName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
				"type":"<xsl:value-of select="$thisApplication/type"/>",
				"codebase":"<xsl:value-of select="eas:getSafeJSString($thisApplication/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
				"codebaseName":"<xsl:value-of select="$codebases[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
				"delivery":"<xsl:value-of select="eas:getSafeJSString($thisApplication/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
				"link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisApplication"/></xsl:call-template>", "parent":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parent"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",  "parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)"/>"<!--,
				"data":[<xsl:apply-templates select="$thisAppProtoInfo" mode="dataPassing"/>]-->},</xsl:if>
	</xsl:template> 
	<xsl:template match="node()" mode="dataPassing">
		<xsl:variable name="thisInfo" select="$allInfo[name=current()/own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value]"/>
		{"name": "<xsl:value-of select="$thisInfo/own_slot_value[slot_reference='name']/value"/>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"link":"<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisInfo"/></xsl:call-template>"}, 
	</xsl:template>
	<xsl:template match="node()" mode="getContainedApps">
		<xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=current()/name]"/>
		{"subId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"subName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>", 
		"parent":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parent"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>", 
		"parentID":"<xsl:value-of select="eas:getSafeJSString($parent/name)"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template> 


	<xsl:template match="node()" mode="appList">
	<xsl:variable name="thisPurposes" select="$purpose[name=current()/own_slot_value[slot_reference='application_provider_purpose']/value]"/>
	<xsl:variable name="thisa2r" select="$a2r[name=current()/own_slot_value[slot_reference='stakeholders']/value]" />
	<xsl:variable name="thisFamily" select="$family[name=current()/own_slot_value[slot_reference='type_of_application']/value]"/>
		{"appName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"type":"<xsl:value-of select="current()/type"/>",
		"appId":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"codebase":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_codebase_status']/value)"/>",
		"codebaseName":"<xsl:value-of select="$codebases[name=current()/own_slot_value[slot_reference='ap_codebase_status']/value]/own_slot_value[slot_reference='enumeration_value']/value"/>",
		"delivery":"<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='ap_delivery_model']/value)"/>",
		"stakeholdersA2R":[<xsl:for-each select="$thisa2r">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"orgUserIds": [],
		"geoIds": [],
		"visId":["<xsl:value-of select="eas:getSafeJSString(current()/own_slot_value[slot_reference='system_content_lifecycle_status']/value)"/>"],
		"purpose":[<xsl:for-each select="$thisPurposes">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"family":[<xsl:for-each select="$thisFamily">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template> 
		<xsl:template match="node()" mode="appOptions">
			<xsl:variable name="ID" select="eas:getSafeJSString(current()/name)"/>
			<xsl:variable name="Name" select="current()/own_slot_value[slot_reference='name']/value"/>            
		<option name="{$Name}" value="{$ID}"><xsl:value-of select="$Name"/></option>
	</xsl:template> 
	<xsl:template match="node()" mode="appCapList">	 
		<xsl:variable name="thisChildCaps" select="eas:get_cap_descendants(current(), $appCaps, 0)"/>
		<xsl:variable name="supportedServices" select="$appServices[own_slot_value[slot_reference='realises_application_capabilities']/value=current()/name]"/>
		<xsl:variable name="supportedServiceswithKids" select="$appServices[own_slot_value[slot_reference='realises_application_capabilities']/value=$thisChildCaps/name]"/>
	
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"relatedServicesThis":[<xsl:for-each select="$supportedServices">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"relatedServices":[<xsl:for-each select="$supportedServiceswithKids">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
		"childrenCaps":[<xsl:for-each select="$thisChildCaps">"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,</xsl:if>
	</xsl:template> 

	<xsl:template match="node()" mode="svcList">
		<xsl:variable name="aprs" select="$aprRoles[name=current()/own_slot_value[slot_reference='provided_by_application_provider_roles']/value]"/>
		<xsl:variable name="apps" select="$aprs/own_slot_value[slot_reference='role_for_application_provider']/value"/>
		{"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
		"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"relatedApps":[<xsl:for-each select="$apps">"<xsl:value-of select="eas:getSafeJSString(.)"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>]}<xsl:if test="not(position()=last())">,</xsl:if>
	
	</xsl:template>


<xsl:function name="eas:get_cap_descendants" as="node()*">
<xsl:param name="parentNode"/> 
<xsl:param name="inScopeCaps"/>
<xsl:param name="level"/>

<xsl:copy-of select="$parentNode"/>
<xsl:if test="$level &lt; 5">
	<xsl:variable name="childCaps" select="$appCaps[name = $parentNode/own_slot_value[slot_reference = 'contained_app_capabilities']/value]" as="node()*"/>
		<xsl:for-each select="$childCaps">
		<xsl:copy-of select="eas:get_cap_descendants(current(), $appCaps, $level + 1)"/> 
	</xsl:for-each>
</xsl:if>

</xsl:function>
<xsl:template match="node()" mode="roadmapApps">
	{<xsl:call-template name="RenderRoadmapJSONProperties"><xsl:with-param name="isRoadmapEnabled" select="$isRoadmapEnabled"/><xsl:with-param name="theRoadmapInstance" select="current()"/><xsl:with-param name="theDisplayInstance" select="current()"/><xsl:with-param name="allTheRoadmapInstances" select="$allRoadmapInstances"/></xsl:call-template>,}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
</xsl:template>

<xsl:template match="node()" mode="elements">
<xsl:variable name="thiselementStyle" select="$elementStyle[name=current()/own_slot_value[slot_reference='element_styling_classes']/value]"/>
{"id":"<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
"name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="false()"/><xsl:with-param name="isForJSONAPI" select="true()"/></xsl:call-template>",
"colour":"<xsl:value-of select="$thiselementStyle[1]/own_slot_value[slot_reference='element_style_text_colour']/value"/>",
'bgcolour':"<xsl:value-of select="$thiselementStyle[1]/own_slot_value[slot_reference='element_style_colour']/value"/>"}<xsl:if test="position()!=last()">,</xsl:if>
		

</xsl:template>
<xsl:template name="RenderViewerAPIJSFunction"> 
		<xsl:param name="viewerAPIPathApps"></xsl:param>
		var viewAPIDataApps = '<xsl:value-of select="$viewerAPIPathApps"/>'; 
		//set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
		
		var promise_loadViewerAPIData = function (apiDataSetURL)
		{
			return new Promise(function (resolve, reject)
			{
				if (apiDataSetURL != null)
				{
					var xmlhttp = new XMLHttpRequest();
					xmlhttp.onreadystatechange = function ()
					{
						if (this.readyState == 4 &amp;&amp; this.status == 200){
							var viewerData = JSON.parse(this.responseText);
							resolve(viewerData);
							$('#ess-data-gen-alert').hide();
						}
						
					};
					xmlhttp.onerror = function ()
					{
						reject(false);
					};
					
					xmlhttp.open("GET", apiDataSetURL, true);
					xmlhttp.send();
				} else
				{
					reject(false);
				}
			});
		}; 

	 	function showEditorSpinner(message) {
			$('#editor-spinner-text').text(message);                            
			$('#editor-spinner').removeClass('hidden');                         
		};

		function removeEditorSpinner() {
			$('#editor-spinner').addClass('hidden');
			$('#editor-spinner-text').text('');
		};
 
		showEditorSpinner('Fetching Data...');
		var dynamicAppFilterDefs=[];
		$('document').ready(function (){
			Promise.all([ 
			promise_loadViewerAPIData(viewAPIDataApps)
			]).then(function (responses)
			{
			let apiApps = responses[0].applications;
			filters=responses[0].filters;
			responses[0].filters.sort((a, b) => (a.id > b.id) ? 1 : -1)
				  
			dynamicAppFilterDefs=filters?.map(function(filterdef){
				return new ScopingProperty(filterdef.slotName, filterdef.valueClass)
			});

		$('#caps').select2();
		$('#services').select2();
		$('#codebase').select2();
		$('#delivery').select2();
		$('#purpose').select2();
		$('#family').select2();
		const essLinkLanguage = '<xsl:value-of select="$i18n"/>';

	appCapList=[<xsl:apply-templates select="$appCaps" mode="appCapList"></xsl:apply-templates>]
	svcList=[<xsl:apply-templates select="$appServices" mode="svcList"/>];  
	appList=[<xsl:apply-templates select="$allApplications" mode="appList"/>];  
	depList=[<xsl:apply-templates select="$allApplications" mode="getApps"/> ];    
		
//console.log('appCapList',appCapList)
let tempApp=[];
	appList.forEach((d)=>{
	 
		let thisIDs= apiApps.find((e)=>{
			return e.id==d.appId
		}); 
		if(thisIDs){ 
		if(thisIDs.orgUserIds.length&gt;0){
			thisIDs.orgUserIds =  thisIDs.orgUserIds.filter((elem, index, self) => self.findIndex( (t) => {return(t === elem)}) === index)
		d['orgUserIds']=thisIDs.orgUserIds 		
		}
		if(thisIDs.geoIds.length&gt;0){
			d['geoIds']=thisIDs.geoIds
		}
		var obj = Object.assign({}, d, thisIDs); 
        tempApp.push(obj);
		
	}else{
		tempApp.push(d)
	}
		  
	});
	 
	appList=tempApp;		
	thisstyles ={"codebase":[<xsl:apply-templates select="$codebases" mode="elements"/>],
				 "delivery":[<xsl:apply-templates select="$deliveryTypes" mode="elements"/>]
				}

	thisPurpose = [<xsl:apply-templates select="$purposeTypes" mode="elements"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>]
	thisFamily = [<xsl:apply-templates select="$family" mode="elements"><xsl:sort select="own_slot_value[slot_reference='name']/value"/></xsl:apply-templates>]
	thisstyles.codebase.forEach((d)=>{			
		$('#codebase').append('<option value="'+d.id+'">'+d.name+'</option>');
	});
	thisstyles.delivery.forEach((d)=>{	
		$('#delivery').append('<option value="'+d.id+'">'+d.name+'</option>');
	});
	thisPurpose.forEach((d)=>{	
		$('#purpose').append('<option value="'+d.id+'">'+d.name+'</option>');
	});	
	thisFamily.forEach((d)=>{	
		$('#family').append('<option value="'+d.id+'">'+d.name+'</option>');
	});		

	appList.forEach((d) => {
 
					//required for roadmap
					var thisRoadmap = roadmapApps.filter((rm) => {
						return d.appId == rm.id;
					});
 
					if (thisRoadmap[0]) {
						d['roadmap'] = thisRoadmap[0].roadmap;
					} else {
						d['roadmap'] = [];
					}
	});
 	
	appCapList=appCapList.sort((a, b) => (a.name > b.name) ? 1 : -1);
	appList=appList.sort((a, b) => (a.appName > b.appName) ? 1 : -1);
	svcList=svcList.sort((a, b) => (a.name > b.name) ? 1 : -1)
	appCapList.forEach((d)=>{
		$('#caps').append('<option value="'+d.id+'">'+d.name+'</option>');
	})
	
	scopedAppsList=appList;
	<!-- on caps filter select the focus cap and select the relevant Cap -->
	$('#caps').on('change',function(){
		 
		let thisId=$(this).val();
		if(thisId == 'all'){
			//console.log('all',thisId)
			redrawView()
		//	getDependencies(thisId,svcList, appList)
			
		}
		else{
			setCaps(thisId)
		}
	});

	$('#refresh').on('click', function(){
		let thisId=$('#caps').val();

		if(thisId == 'all'){
			//console.log('allrefresh')
			redrawView();
			
		}
		else{
  //console.log('svcrefresh')
			let getSvc=$('#services').find('option').filter(':selected').val()
			setCaps($('#caps').val())
			if(getSvc=='all'){

			}
			else
			{
				$('#services').val(getSvc).trigger("change")
			}
		}
	});
				

	//createChart(depList, appList)

	essInitViewScoping(redrawView,['Group_Actor', 'SYS_CONTENT_APPROVAL_STATUS','ACTOR_TO_ROLE_RELATION','Geographic_Region'], responses[0].filters);

	$('#codebase').on('change',function(){ 
		redrawView();
	});

	$('#delivery').on('change',function(){ 
		redrawView();
	});

	$('#purpose').on('change',function(){ 
		redrawView();
	});
	$('#family').on('change',function(){ 
		redrawView();
	});
	redrawView();
			})
		})
	</xsl:template>
	<xsl:template name="GetViewerAPIPath">
		<xsl:param name="apiReport"></xsl:param>

		<xsl:variable name="dataSetPath">
			<xsl:call-template name="RenderAPILinkText">
				<xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$dataSetPath"></xsl:value-of>

	</xsl:template>
			 
</xsl:stylesheet>
