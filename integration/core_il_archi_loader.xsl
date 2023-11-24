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

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Application_Service', 'Business_Process', 'Business_Activity', 'Business_Task')"></xsl:variable>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->

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
				<title>Archi Data Loader</title>
				<style>
					@keyframes pulse {
							0% {
								transform: scale(1);
								opacity: 1;
							}
							50% {
								transform: scale(1.1);
								opacity: 0.7;
							}
							100% {
								transform: scale(1);
								opacity: 1;
							}
						}

						.pulsing {
							animation: pulse 1.5s infinite;
						}

				.cardBox{
					height:130px;
					width:100px;
					border:1pt solid #d3d3d3;
					border-radius:6px;
					text-align: center;
					vertical-align:top;
					display:inline-block;
					padding-top:15px;
					color:rgb(161, 132, 188, 0.2);
					margin:3px;
					box-shadow: 2px 2px 4px #d3d3d3;
				}
				.boldName{
					color:rgb(0, 0, 0, 0.2);
				}
				.warningClass{
					padding:3px;
					margin:3px;
					border-radius:5px;
					background-color:red;
					color:"#ffffff";
				}
				.infoBar{
					padding:3px;
					margin:3px;
					border-radius:5px;
					background-color:#e3e3e3;
					color:"#000000";
				}
				.feedbackPanel{
					width: 200px;
					border-radius: 6px;
					padding:10px;
					background-color:#eac946;
					font-size:1.3em;
				}
				</style>
				<script src='js/d3/d3.v5.9.7.min.js'></script>
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
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Archi')"/> <xsl:value-of select="eas:i18n('Data Load')"/></span>
								</h1>
							</div>
						</div>
						<ul class="nav nav-pills">
							<li class="active"><a data-toggle="pill" href="#home"><xsl:value-of select="eas:i18n('Mappings')"/></a></li>
							<li><a data-toggle="pill" href="#classes"><xsl:value-of select="eas:i18n('Classes')"/></a></li>
							<li><a data-toggle="pill" href="#relations" id="relationsTab"><xsl:value-of select="eas:i18n('Relations')"/></a></li>
						</ul>
						<div class="tab-content">
							<div id="home" class="tab-pane fade in active">
								<div class="col-xs-12">
									<div id="fetchMappings"><xsl:value-of select="eas:i18n('Fetching Mapping Data, Please Wait...')"/></div>
									<br/>
									<div class="mappings">
										<table id="mapTable" class="table table-striped">
											<thead>
												<tr>
													<th><xsl:value-of select="eas:i18n('Archi Concept')"/></th>
													<th><xsl:value-of select="eas:i18n('Essential Class')"/></th>
													<th></th>
												</tr>
											</thead>
											<tbody>
												<!-- fill this dynamically -->
											</tbody>
										</table>
										<div class="infoBar" id="infoBar">
											<span style="color:white"><xsl:value-of select="eas:i18n('You')"/><xsl:text> </xsl:text> <u><xsl:value-of select="eas:i18n('must')"/></u> <xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('save mappings for them to be applied next time you load the view')"/> </span><br/>
										</div>
										<button class="btn btn-info bt-sm pulsingButton" id="updateMappings"><xsl:value-of select="eas:i18n('Save Mappings in Table')"/></button>
										<xsl:text> </xsl:text>
										<button class="btn btn-primary bt-sm" id="addMapping"><xsl:value-of select="eas:i18n('Add New Mapping')"/></button>
										<div class="addMapp top-5">
											<form id="mapForm">
												<xsl:value-of select="eas:i18n('Archimate Class')"/>: <select id="arch"/> 
											<xsl:text> </xsl:text>
											<xsl:value-of select="eas:i18n('Essential Class')"/>:
											<input type="text" id="essential" name="essential"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="eas:i18n('Name')"/>:
											<input type="text" id="name" name="name"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="eas:i18n('Font-Awesome Icon')"/>
											<input type="text" id="faIcon" name="faIcon" placeholder="e.g. fa-home"/>
											
											<input type="button" value="Update Map" onclick="updateMappings()"/>
											</form>
										</div>
									</div>
								</div>
							</div>
						<div id="classes" class="tab-pane fade">
							
							<div class="col-xs-2">
								<h3>ArchiXML File to load:</h3>
									Filename:<br/>
									<input class="btn btn-sm btn-primary" type="file" id="filex"/><br/>
									<div class="pull-right">
										<button class="btn btn-xs btn-success" type="Button" id="fileButton">Load File</button>
									</div>
							</div>
							<div class="col-xs-10 cardPanel">
								<span id="spinBox"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i>Loading Data...</span>
								<h3>Catalogues</h3>
								<p>Data items found that can be added to the repository</p>
								<div id="cards"/>
							</div>	
						</div>
						<div id="relations" class="tab-pane fade">
							<span id="spinBox2"><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i><xsl:value-of select="eas:i18n('Structuring Data, this may take some time...')"/></span>
							<h4><xsl:value-of select="eas:i18n('Relations')"/></h4> 
								<div class="col-xs-12 cardPanel">
									
									<p><xsl:value-of select="eas:i18n('Create Relationships based on data.  Note: the data must have been loaded into Essential using the classes tab prior to creating the relationships')"/></p>
									<select id="relationPicker">
										<option>Choose</option>
										<option value="busCaps"><xsl:value-of select="eas:i18n('Business Capabilities')"/></option>
										<option value="Process2BusCaps"><xsl:value-of select="eas:i18n('Business Capabilities to Processes')"/></option>
									<!--	<option value="appDependency">Application Dependency</option>-->
										<option value="AppServices"><xsl:value-of select="eas:i18n('Application to Application Services')"/></option>
										<option value="actor2role"><xsl:value-of select="eas:i18n('Actors to Roles')"/></option>
									</select>

								<hr/>
								<div class="feedbackPanel" id="feedbackPanel">
									<xsl:value-of select="eas:i18n('Loaded')"/><xsl:text> </xsl:text> <span id="loadedItems"></span><xsl:text> </xsl:text> <xsl:value-of select="eas:i18n('Instances')"/>

								</div>
								</div>
						</div>
					
						<!--Setup Closing Tags-->
					</div>
				</div>
			</div>
<!-- modal -->
<div class="modal" id="listModal">
	<div class="modal-dialog">
	  <div class="modal-content">
  
		<!-- Modal Header -->
		<div class="modal-header">
		  <h4 class="modal-title"><xsl:value-of select="eas:i18n('Data to be loaded')"/></h4>
		</div>
  
		<!-- Modal body -->
		<div class="modal-body">
		  <div id="dataLoad" style="max-height: 400px;  overflow-y: auto;"/>
		  
		</div>
  
		<!-- Modal footer -->
		<div class="modal-footer">
		  <button type="button" class="btn btn-warning" id="loadData"><xsl:value-of select="eas:i18n('Load Data')"/></button>
		  <button type="button" class="btn btn-danger" data-dismiss="modal"><xsl:value-of select="eas:i18n('Close')"/></button>
		</div>
  
	  </div>
	</div>
  </div>			
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				
	<script id="modal-template" type="text/x-handlebars-template">
		<xsl:value-of select="eas:i18n('Items to be imported')"/>":<br/>
		{{#each this}}
			- <xsl:text> </xsl:text>{{this.name}}<br/>
		{{/each}}
	</script>		
	<script id="busCap-template" type="text/x-handlebars-template">
		{"instances":[{{#each this}}
		{ 
			"id": "{{this.key}}",
			"className": "Business_Capability",
			"contained_business_capabilities": [
			{{#each this.values}}
			{{#if this.targetId}}
			{
				"id": "{{this.targetId}}",
				"className": "Business_Capability"
			}
			{{else}}
			{
				"name": "{{this.target}}",
				"className": "Business_Capability"
			}
			{{/if}}
			{{#unless @last}},{{/unless}}
			{{/each}}
			]
		}{{#unless @last}},{{/unless}}
		{{/each}}
		]}
	</script>
    <script id="groupActor-template" type="text/x-handlebars-template">
    {"instances":[
    {{#each this}}
        {"name": "{{this.source}} as {{this.target}}",
        "className": "ACTOR_TO_ROLE_RELATION",		
            "": {
                "name": "{{this.source}}",
                "className": "Group_Actor",
                    "externalId": {	
                    "id": "{{this.sourceId}}",
                    "sourceName": "Archi"
                } 
            },
        
            "": {
                "name":"{{this.target}}",
                "className": "Group_Business_Role",
                "externalId": {	
                        "id": "{{this.targetId}}",
                        "sourceName": "Archi"
                    }
                }
        }{{#unless @last}},{{/unless}}
    {{/each}}
    ]}
    </script>

    <script id="apr-template" type="text/x-handlebars-template">
    {"instances":[
    {{#each this}}
        {"name": "{{this.source}} as {{this.target}}",
        "className": "Application_Provider_Role",		
            "implementing_application_service": {
                "name": "{{this.target}}",
                "className": "Application_Service",
                    "externalId": {	
                    "id": "{{this.targetId}}",
                    "sourceName": "Archi"
                } 
            },
        
            "role_for_application_provider": {
                "name":"{{this.source}}",
                "className": "Composite_Application_Provider",
                "externalId": {	
                        "id": "{{this.sourceId}}",
                        "sourceName": "Archi"
                    }
                }
        }{{#unless @last}},{{/unless}}
    {{/each}}
    ]}
    </script>				
<script id="supplier-template" type="text/x-handlebars-template">
	{{#each this}}
	{ 
		"name": "{{name}}",
		"className": "Supplier", 
		"description": "{{Description}}" 
	}{{#unless @last}},{{/unless}}
	{{/each}}
</script>
<script id="technologyproductfamilies-template" type="text/x-handlebars-template">
	{{#each this}}
	{ 
		"name": "{{Product_Family_Name}}",
		"className": "Technology_Product_Family"  
	}{{#unless @last}},{{/unless}}
	{{/each}}
</script>
 
<script id="card-template" type="text/x-handlebars-template">
	{{#each this}}
		<div class="cardBox"><xsl:attribute name="easid">{{this.essential}}</xsl:attribute>
			<i><xsl:attribute name="class">fa {{this.icon}} fa-3x</xsl:attribute></i><br/>
			<b class="boldName">{{this.name}}</b>
		</div>
	{{/each}}
</script>
<script id="lifecycle-template" type="text/x-handlebars-template">

</script>
<script id="appServ-template" type="text/x-handlebars-template">
	{"instances":[{{#each this}}
	{ 
		"name": "{{name}}",
		"className": "Application_Service",
		"externalId": {	
			"id": "{{this.sourceId}}",
			"sourceName": "Archi"
		}   
	}{{#unless @last}},{{/unless}}
	{{/each}}]}
</script>
<script id="application-template" type="text/x-handlebars-template">
	{"instances":[{{#each this}}
	{ 
		"name": "{{name}}",
		"className": "{{essential}}",
        "externalId": {	
            "id": "{{id}}",
			"sourceName": "Archi"
		} 
	}{{#unless @last}},{{/unless}}
	{{/each}}]}
</script>
      </body>
      <script>
		$('.addMapp').hide()
		var mappings=[
			{"archi":"ApplicationComponent","essential":"Composite_Application_Provider", "name":"Applications", "icon":"fa-solid fa-laptop"},
			{"archi":"ApplicationInterface","essential":"Application_Provider_Interface", "name":"APIs", "icon":"fa-solid fa-plug"},
			{"archi":"Capability","essential":"Business_Capability", "name":"Business Capability", "icon":"fa-solid fa-sitemap"},
			{"archi":"BusinessFunction","essential":"Application_Service", "name":"Application Services Business", "icon":"fa-regular fa-tasks"},
			{"archi":"ApplicationService","essential":"Application_Service", "name":"Application Services (IT)", "icon":"fa-regular fa-tasks"},				
			{"archi":"BusinessProcess","essential":"Business_Process", "name":"Business Process", "icon":"fa-solid fa-code-fork"},
			{"archi":"BusinessActor","essential":"Group_Actor", "name":"Group Actors", "icon":"fa-solid fa-user"},
			{"archi":"BusinessRole","essential":"Group_Business_Role", "name":"Business Roles", "icon":"fa-solid fa-users"},
			{"archi":"Goal","essential":"Business_Goal", "name":"Goals", "icon":"fa-solid fa-bullseye"},
			{"archi":"Driver","essential":"Business_Driver", "name":"Drivers", "icon":"fa-solid fa-diamond"},
			{"archi":"DataObject","essential":"Data_Object", "name":"Data Objects", "icon":"fa-solid fa-database"},
			{"archi":"Location","essential":"Site", "name":"Sites", "icon":"fa-solid fa-map-marker"},
			{"archi":"ValueStream","essential":"Value_Stream", "name":"applications", "icon":"fa-solid fa-angle-double-right"},
			{"archi":"Product","essential":"Product", "name":"Products", "icon":"fa-solid fa-archive"},
			{"archi":"Principle","essential":"Business_Principle", "name":"Principles", "icon":"fa-solid fa-th"},
			{"archi":"Requirement","essential":"Need", "name":"Requirements", "icon":"fa-solid fa-file-text-o"},
			{"archi":"BusinessService", "essential":"", "name":"Business Service", "icon":"fa-solid fa-briefcase"},
			{"archi":"Node", "essential":"Technology_Node", "name":"Node", "icon":"fa-solid fa-circle"},
			{"archi":"SystemSoftware", "essential":"", "name":"System Software", "icon":"fa-solid fa-database"},
			{"archi":"TechnologyService", "essential":"", "name":"Technology Service", "icon":"fa-solid fa-server"},
			{"archi":"ValueStream", "essential":"Value_Stream", "name":"Value Stream", "icon":"fa-solid fa-tasks"}
			];

			var storedMappings = localStorage.getItem('archiMappings');

			// If it does, parse and use it
			if (storedMappings) {
				mappings = JSON.parse(storedMappings);
			}


		var relationMapping=[
		{"type":"appDependency","sourceType":"ApplicationComponent","targetType":"ApplicationComponent","name":"Application Dependencies", "icon":"fa-solid fa-file-text-o", "essSourceType":"Composite_Application_Provider","essTargetType":"Composite_Application_Provider"},
		{"type":"actor2role","sourceType":"BusinessActor","targetType":"BusinessRole", "name":"Actor to Role", "icon":"fa-solid fa-file-text-o", "essSourceType":"Group_Actor","essTargetType":"Group_Business_Role"},
		{"type":"busCaps","sourceType":"Capability","targetType":"Capability", "name":"Business Capabilities", "icon":"fa-solid fa-file-text-o", "essSourceType":"Business_Capability","essTargetType":"Business_Capability"},
		{"type":"AppServices","sourceType":"ApplicationComponent","targetType":"ApplicationService", "name":"Applications to Services", "icon":"fa-solid fa-file-text-o", "essSourceType":"Composite_Application_Provider","essTargetType":"Application_Service"},
		{"type":"Process2BusCaps","sourceType":"Capability","targetType":"BusinessProcess", "name":"Processes", "icon":"fa-solid fa-file-text-o", "essSourceType":"Business_Capability","essTargetType":"Business_Process"}
		]
		var applicationTemplate, lifecycleTemplate, supplierTemplate
		var newElementList=[];
		var newRelationsList=[];	
		
		var archiElementTypes = [
				"BusinessActor",
				"BusinessRole",
				"BusinessCollaboration",
				"BusinessInterface",
				"BusinessProcess",
				"BusinessFunction",
				"BusinessInteraction",
				"BusinessEvent",
				"BusinessService",
				"BusinessObject",
				"Contract",
				"Representation",
				"Product",
				"ApplicationComponent",
				"ApplicationCollaboration",
				"ApplicationInterface",
				"ApplicationFunction",
				"ApplicationInteraction",
				"ApplicationProcess",
				"ApplicationEvent",
				"ApplicationService",
				"DataObject",
				"Node",
				"Device",
				"SystemSoftware",
				"TechnologyCollaboration",
				"TechnologyInterface",
				"Path",
				"CommunicationNetwork",
				"TechnologyFunction",
				"TechnologyProcess",
				"TechnologyInteraction",
				"TechnologyEvent",
				"TechnologyService",
				"Artifact",
				"Equipment",
				"Facility",
				"DistributionNetwork",
				"Material",
				"Stakeholder",
				"Driver",
				"Assessment",
				"Goal",
				"Outcome",
				"Principle",
				"Requirement",
				"Constraint",
				"Meaning",
				"Value",
				"Resource",
				"Capability",
				"CourseOfAction",
				"WorkPackage",
				"Deliverable",
				"ImplementationEvent",
				"Plateau",
				"Gap",
				"Grouping",
				"Location",
				"Junction"
				]
				archiElementTypes=archiElementTypes.sort()
console.log("archiElementTypes",archiElementTypes)

archiElementTypes.forEach(optionText => {
        // Create a new option element
        let option = document.createElement('option');
        option.value = optionText;
        option.textContent = optionText;

        // Append the option to the select box
        $('#arch').append(option);
		console.log('optionText',optionText)
    });
	$('#arch').select2();

	function saveMappings(){
		console.log('saving')
		var selects = document.querySelectorAll(".mappings select");
		$('#infoBar').removeClass('warningClass').addClass('infoBar')
 
		selects.forEach(function(select) {
			// Fetch the archiValue from the data attribute
			var archiValue = select.dataset.archi;
			
			// Find the corresponding mapping in the array based on the archiValue
			var mappingToUpdate = mappings.find(mapping => mapping.archi === archiValue);
			
			// Update the essential value for the found mapping
			if (mappingToUpdate) {
				mappingToUpdate.essential = select.value;
			}
		});

		console.log('mappings',mappings)
		localStorage.setItem('archiMappings', JSON.stringify(mappings));
	}
	
		$('#addMapping').off().on('click', function(){
			$('.addMapp').show()
			$('#infoBar').addClass('warningClass').removeClass('infoBar')
		})
		
		function updateMappings() {
			
			const arch = document.getElementById('arch').value;
			const essential = document.getElementById('essential').value;
			const name = document.getElementById('name').value;
			const faIcon = document.getElementById('faIcon').value;

			const mapObject = {
				archi: arch,
				essential: essential,
				name: name,
				icon: faIcon
			};
	
			mappings.push(mapObject);

		const table = document.getElementById('mapTable').getElementsByTagName('tbody')[0];
        const newRow = table.insertRow(table.rows.length);
        
        const cell1 = newRow.insertCell(0);
        const cell2 = newRow.insertCell(1);
		const deleteCell = newRow.insertCell(2);  // New cell for delete button

        cell1.innerHTML = arch;
        cell2.innerHTML = essential;
		deleteCell.innerHTML = '<button class="btn btn-warning btn-sm" onclick="deleteRow(this)">Delete</button>';  // Adding delete button
			
			$('.addMapp').hide()
			saveMappings()
		}

		function deleteRow(btn) {
			const row = btn.parentNode.parentNode;
			row.parentNode.removeChild(row);
		}	

			$(document).ready(function(){	
				$('#feedbackPanel').hide()
				$('#spinBox').hide();
				$('#spinBox2').hide();
				$('#relationsTab').hide();
				var cardFragment   = $("#card-template").html();
				cardTemplate = Handlebars.compile(cardFragment);

				var supplierFragment   = $("#supplier-template").html();
				supplierTemplate = Handlebars.compile(supplierFragment);

                var aprFragment   = $("#apr-template").html();
				aprTemplate = Handlebars.compile(aprFragment);

				var busCapFragment   = $("#busCap-template").html();
				busCapTemplate = Handlebars.compile(busCapFragment);

				var modalFragment   = $("#modal-template").html();
				modalTemplate = Handlebars.compile(modalFragment);

				var tpfFragment   = $("#technologyproductfamilies-template").html();
				tpfTemplate = Handlebars.compile(tpfFragment);

				var lifecycleFragment   = $("#lifecycle-template").html();
				lifecycleTemplate = Handlebars.compile(lifecycleFragment);

				var applicationFragment   = $("#application-template").html();
				applicationTemplate = Handlebars.compile(applicationFragment);


				var appServFragment   = $("#appServ-template").html();
				appServTemplate = Handlebars.compile(appServFragment);
			 
			
			$('.cardPanel').hide()
				$("#fileButton").on('click', function() { 

					let fileInput = $('#filex')[0];
					if (fileInput &amp;&amp; fileInput.files &amp;&amp; fileInput.files.length > 0) {
						let file = fileInput.files[0];
						
						var reader = new FileReader();
						reader.onload = function(event) {
							let content = event.target.result; // The content of the file
							createJSON(content); // Processing the XML content
							$('#relationsTab').show();
						};
						reader.onerror = function(event) {
							console.error("Error reading file!", event);
						};
						reader.readAsText(file); // Reading the file as text
						
					} else {
						console.error("No file selected!");
					}
 
					
				});


function createJSON(data){ 

	var parser = new DOMParser();
	var xml = parser.parseFromString(data, "text/xml");
	let newData=xmlToJson(xml)
 
	let elements=newData.model.elements.element;
	let relations=newData.model.relationships.relationship;

	$('#cards').html(cardTemplate(mappings));
	newElementList=[];
	newRelationsList=[];
	elements.forEach((e)=>{
 
		let essentialType=mappings.find((d)=>{
			return d.archi==e['@attributes']['xsi:type']
		})
 
		if(essentialType){
		newElementList.push({"id": e['@attributes'].identifier,"name":e['name']['#text'],"type": e['@attributes']['xsi:type'], "essential":essentialType.essential})
		 
		}else{
			newElementList.push({"id": e['@attributes'].identifier,"name":e['name']['#text'],"type": e['@attributes']['xsi:type'], "essential":"unknown"})
	
		}
	})

	let uniqueTypes = [...new Set(newElementList.map(item => item.essential))];

	uniqueTypes.forEach((s)=>{
		
		if(s=='unknown'){}else{
		$('[easid="'+s+'"]').children('.boldName').css('color', 'rgb(0, 0, 0)')
		$('[easid="'+s+'"]').css('color', 'rgb(161, 132, 188)')
		}
	})

	relations.forEach((rel)=>{
	 
		let srcEle = newElementList.find((e)=>{
			return rel['@attributes'].source == e.id;
		});

		let targEle = newElementList.find((e)=>{
			return rel['@attributes'].target == e.id;
		})
 
		if(targEle){
		newRelationsList.push({"sourceId":srcEle.id, "source":srcEle.name, "sourceType":srcEle.type, "target":targEle.name, "targetType":targEle.type, "targetId":targEle.id,})
		}
	})

    newRelationsList.forEach((r)=>{

        let src=mappings.find((e)=>{
            return e.archi==r.sourceType
        })
       
        if(src){
            r['essSource']=src.essential;
        }
        let tar=mappings.find((e)=>{
            return e.archi==r.targetType
        })
        if(tar){
            r['essTarget']=tar.essential;
        }
    })

$('#relationPicker').select2({width: '200px'})
	$('#relationPicker').off().on('change', function(){
		$('#spinBox2').show()

		$('#feedbackPanel').show();
	let selected = $(this).val();

	let { essSourceType, essTargetType } = relationMapping.find(e => e.type === selected);

	let allTargets = newRelationsList.filter(s => essSourceType === s.essSource &amp;&amp; essTargetType === s.essTarget);

// let allTargets = newRelationsList.filter(s => essSourceType === s.sourceType &amp;&amp; essTargetType === s.targetType);
		//App Dep - Not working
		//App Services - Working
		//
			if(selected=='appDependency'){
				//get Ids for apps

				essPromise_getAPIElements('/essential-utility/v3', '/classes/Composite_Application_Provider/instances', 'Composite_Application_Provider')
							.then(function (response) {
									 
										allTargets.forEach((e)=>{
											let mapped=response.instances.find((f)=>{
												return f.name==e.source
											})
											if(mapped){
												e['sourceId']=mapped.id
											}
											let mappedTarget=response.instances.find((f)=>{
												return f.name==e.target
											})
											if(mappedTarget){
												e['targetId']=mappedTarget.id
											}
										})
 
						allTargets.forEach((e, i)=>{
							if(i&lt;4){	 

							let sendToBody={"id": e.targetId};
  						
								essPromise_createAPIElement('/essential-core/v1', sendToBody, 'applications/'+e.sourceId+'/dependency-model/sends-to', 'Outbound Dependency')
									.then(function (response) {
											$('#loadedItems').text(response.instances.length)
												$('#spinBox2').hide()
								})
							
							}

						})
					})

				//setup JSON


				//send data
				/*
				
				*/

			}else if(selected=='actor2role'){
                let a2r=[]
                allTargets.forEach((d)=>{
                            a2r.push({
                                "name": d.source +' as '+  d.target,
                                "className": "ACTOR_TO_ROLE_RELATION",		
                                    "act_to_role_to_role": {
                                        "name":d.target,
                                        "className": "Group_Business_Role",
                                            "externalId": {	
                                            "id": d.targetId,
                                            "sourceName": "Archi"
                                        } 
                                    },
                                    "act_to_role_from_actor": {
                                    "name":d.source,
                                    "className": "Group_Actor",
                                    "externalId": {	
                                            "id": d.sourceId,
                                            "sourceName": "Archi"
                                        }
                                    }
                                })
                        })
                        console.log('a2r',a2r)
                   let jsonBody={"instances":a2r};
                    essPromise_createAPIElement('/essential-utility/v3', jsonBody, 'instances/batch?reuse=true')
                    .then(function (response) {
                        $('#spinBox2').hide()
						$('#loadedItems').text(response.instances.length)
                            console.log('response apr',response)
                            
                    }) 

			}
			else if(selected=='AppServices'){
                
                let apr=[];
                        allTargets.forEach((d)=>{
                            apr.push({
                                "name": d.source +' as '+  d.target,
                                "className": "Application_Provider_Role",		
                                    "implementing_application_service": {
                                        "name":d.target,
                                        "className": "Application_Service",
                                            "externalId": {	
                                            "id": d.targetId,
                                            "sourceName": "Archi"
                                        } 
                                    },
                                
                                "role_for_application_provider": {
                                    "id": d.id,
                                    "name":d.source,
                                    "className": "Composite_Application_Provider",
                                    "externalId": {	
                                            "id": d.sourceId,
                                            "sourceName": "Archi"
                                        }
                                    }
                                })
                        })

                    let jsonBody={"instances":apr};
                    essPromise_createAPIElement('/essential-utility/v3', jsonBody, 'instances/batch?reuse=true')
                    .then(function (response) {
                        $('#spinBox2').hide()
						$('#loadedItems').text(response.instances.length)
                            console.log('response apr',response)
                            
                    })
        }
			else if(selected=='busCaps'){
					
							var thisSources = d3.nest()
							.key(function(d) { return d.sourceId; })
							.entries(allTargets)

                       
							let capBody=[]
							thisSources.forEach((e)=>{
                                let thisCap=allTargets.find((f)=>{return f.sourceId==e.key})

								let subs=[];
								e.values.forEach((f)=>{
									subs.push({
                                    "name":f.target,
									"className": "Business_Capability",
                                     "externalId": {	
                                            "id": f.targetId,
                                            "sourceName": "Archi"
                                        }
								})
								})
								capBody.push({
                                "name":thisCap.source,
								"className": "Business_Capability",
								"contained_business_capabilities": subs,
                                 "externalId": {	
                                            "id": e.key,
                                            "sourceName": "Archi"
                                        }})
							
							})

							let jsonBody={"instances":capBody}
				
						essPromise_createAPIElement('/essential-utility/v3', jsonBody, 'instances/batch?reuse=true')
								.then(function (response) {
									$('#spinBox2').hide()
									$('#loadedItems').text(response.instances.length)
										console.log('response caps',response)
										
								}) 
			}
			else if(selected=='Process2BusCaps'){
					
				console.log('allTargets',allTargets)	
				var thisSources = d3.nest()
				.key(function(d) { return d.sourceId; })
				.entries(allTargets)


				let capBody=[]

				thisSources.forEach((e)=>{
					let thisCap=allTargets.find((f)=>{return f.sourceId==e.key})

					let subs=[];
					e.values.forEach((f)=>{
						subs.push({
						"name":f.target,
						"className": "Business_Process",
						"externalId": {	
								"id": f.targetId,
								"sourceName": "Archi"
							}
					})
					})
					capBody.push({
					"name":thisCap.source,
					"className": "Business_Capability",
					"realised_by_business_processes": subs,
					"externalId": {	
								"id": e.key,
								"sourceName": "Archi"
							}})
				
				})

	let jsonBody={"instances":capBody}
		console.log('jsonBody',jsonBody)
		essPromise_createAPIElement('/essential-utility/v3', jsonBody, 'instances/batch?reuse=true')
				.then(function (response) {
					$('#spinBox2').hide()
					$('#loadedItems').text(response.instances.length)
						console.log('response caps',response)


						
				}) 
		}
					
	})
	

					$('.cardPanel').show().slideDown().fadeIn(2000);
					$('.cardBox').off().on('click',  function(){
			
						let thisType=$(this).attr('easid');
						let box=$(this)
		
						let filtered=newElementList.filter((e)=>{
							return e.essential==thisType
						})
						$('#dataLoad').html(modalTemplate(filtered));
		
						$('#listModal').modal('show')
			
						$('#loadData').on('click', function(){	
							box.css('background-color','#d3d3d3');
							sendElements(filtered, thisType);
							$('#spinBox').show()
							$('#listModal').modal('hide')
						})
					 
						})


}			 
function xmlToJson(xml) {
	
	// Create the return object
	var obj = {};

	if (xml.nodeType == 1) { // element
		// do attributes
		if (xml.attributes.length > 0) {
		obj["@attributes"] = {};
			for (var j = 0; j &lt; xml.attributes.length; j++) {
				var attribute = xml.attributes.item(j);
				obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
			}
		}
	} else if (xml.nodeType == 3) { // text
		obj = xml.nodeValue;
	}

	// do children
	if (xml.hasChildNodes()) {
		for(var i = 0; i &lt; xml.childNodes.length; i++) {
			var item = xml.childNodes.item(i);
			var nodeName = item.nodeName;
			if (typeof(obj[nodeName]) == "undefined") {
				obj[nodeName] = xmlToJson(item);
			} else {
				if (typeof(obj[nodeName].push) == "undefined") {
					var old = obj[nodeName];
					obj[nodeName] = [];
					obj[nodeName].push(old);
				}
				obj[nodeName].push(xmlToJson(item));
			}
		}
	}
	return obj;
};

var classes;
		essPromise_getAPIElements('/essential-utility/v3', '/classes')
							.then(function(response) {
								return response.classes.filter((d) => {
									return d.isAbstract == false &amp;&amp; d.superClasses.includes('EA_Class')
								});
							})
							.then(function(classes) {
$('#fetchMappings').hide();
var tbody = document.querySelector(".mappings tbody");

mappings.forEach(function(currentMapping, index) {  

    var row = document.createElement("tr");

    var archiCell = document.createElement("td");
    archiCell.innerText = currentMapping.archi;
    row.appendChild(archiCell);

    var essentialCell = document.createElement("td"); 
    var select = document.createElement("select");
    select.dataset.archi = currentMapping.archi; 
	select.classList.add("essClass");

    var defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.innerText = "Choose";
    select.appendChild(defaultOption);

    // Create options for each class in the 'classes' array
    classes.forEach(function(className) {
        var option = document.createElement("option");
        option.value = className.name;
        option.innerText = className.name;
        if (className.name === currentMapping.essential) {
            console.log('match', className.name);
            option.selected = true;  // Default to the current essential
        }
        select.appendChild(option);
    });

    essentialCell.appendChild(select);
    row.appendChild(essentialCell);

	$(select).select2({width: "300px"});

    // Create delete cell with delete button
    var deleteCell = document.createElement("td");
    var deleteButton = document.createElement("button");
	deleteButton.className="btn btn-warning btn-sm";
    deleteButton.innerText = "Delete";
    deleteButton.addEventListener("click", function() {
        row.parentNode.removeChild(row);

        // Remove the item from the mappings array using the index
        mappings.splice(index, 1);

		$('#infoBar').addClass('warningClass').removeClass('infoBar')
    });
    deleteCell.appendChild(deleteButton);
    row.appendChild(deleteCell); // Appending the delete cell to the row

    tbody.appendChild(row);
});


$('#mapTable').DataTable()

$('.mappings select').on('change', function(){
	document.getElementById("updateMappings").classList.add("pulsing");
	$('#infoBar').addClass('warningClass').removeClass('infoBar')
})


$('#updateMappings').on('click', function (){
		document.getElementById("updateMappings").classList.remove("pulsing"); 
		saveMappings()
	})

	
})

			})

function sendElements(eles, eletype){
	
console.log('eletype',eletype)
	let list=eles.filter((s)=>{
		return s.essential == eletype
	})

 
	createClassInstances('Comp_Apps', applicationTemplate(list)) 
	
}

function createClassInstances(cls, data){
	let dt=JSON.parse(data)
	console.log('dt',dt)
		console.log(typeof dt)
		essPromise_createAPIElement('/essential-utility/v3', dt, 'instances/batch?reuse=true')
				.then(function (response) {
					console.log('r', response)
					$('#loadedItems').text(response.instances.length)
					$('#spinBox').hide()
				})
}
   
      </script>
		</html>
	</xsl:template>

	 
	</xsl:stylesheet>
	