<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
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

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Strategic_Trend', 'Strategic_Trend_Implication')"/>
	<!-- END GENERIC LINK VARIABLES -->


	<!-- Get default geographic map -->
	<xsl:variable name="geoMapReportConstant" select="/node()/simple_instance[(type = 'Report_Constant') and (own_slot_value[slot_reference = 'name']/value = 'Default Geographic Map')]"/>
	<xsl:variable name="geoMapInstance" select="/node()/simple_instance[name = $geoMapReportConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="geoMapId">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0">
				<xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</xsl:when>
			<xsl:otherwise>world_mill</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="geoMapPath">
		<xsl:choose>
			<xsl:when test="count($geoMapInstance) > 0">
				<xsl:value-of select="$geoMapInstance[1]/own_slot_value[slot_reference = 'description']/value"/>
			</xsl:when>
			<xsl:otherwise>js/jvectormap/jquery-jvectormap-world-mill.js</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="allBusEnvCategories" select="/node()/simple_instance[type = 'Business_Environment_Category']"/>
	<xsl:variable name="allBusEnvFactors" select="/node()/simple_instance[type = 'Business_Environment_Factor']"/>
	<xsl:variable name="countryTaxTerm" select="/node()/simple_instance[(type = 'Taxonomy_Term') and (own_slot_value[slot_reference = 'name']/value = 'Country')]"/>
	<xsl:variable name="allCountries" select="/node()/simple_instance[own_slot_value[slot_reference = 'element_classified_by']/value = $countryTaxTerm/name]"/>

	<xsl:variable name="allStratTrends" select="/node()/simple_instance[type = 'Strategic_Trend']"/>
	<xsl:variable name="allTrendImpls" select="/node()/simple_instance[name = $allStratTrends/own_slot_value[slot_reference = 'strategic_trend_implications']/value]"/>
	<xsl:variable name="allBusEnvChanges" select="/node()/simple_instance[name = $allTrendImpls/own_slot_value[slot_reference = 'sti_business_environment_impacts']/value]"/>

	<xsl:variable name="allStratTrendImplStatii" select="/node()/simple_instance[type = 'Strategic_Trend_Implication_Lifecycle_Status']"/>

	<xsl:variable name="colourPrimary" select="$activeViewerStyle/own_slot_value[slot_reference = 'primary_header_colour_viewer']/value"/>


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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<script type="text/javascript" src="js/d3/d3_4-11/d3.min.js"/>
				<script type="text/javascript" src="js/handlebars-v4.0.8.js"/>
				<link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
				<script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
				<script src="{$geoMapPath}" type="text/javascript"/>
				<xsl:call-template name="dataTablesLibrary"/>
				<link rel="stylesheet" type="text/css" href="js/DataTables/checkboxes/dataTables.checkboxes.css"/>
				<script src="js/DataTables/checkboxes/dataTables.checkboxes.min.js"/>

				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>
					<xsl:value-of select="eas:i18n('Strategic Trends Dashboard')"/>
				</title>
				<style>
					.section-title{
						padding: 5px;
						color: white;
					}
					
					.map{
						width: 100%;
						height: 320px;
					}
					
					.bus-env-icon{
						font-size: 1.2em;
						padding: 5px 10px;
						border: 1px solid #ccc;
						margin-bottom: 5px;
						border-radius: 4px;
						background-color: #fff;
						color: #666;
					}
					
					.bus-env-icon.active {
						background-color: <xsl:value-of select="$colourPrimary"/>;
						color: #fff;
					}
					
					.dashboardPanel{
						padding: 10px;
						border: 1px solid #aaa;
						box-shadow: 2px 2px 4px #ccc;
						margin-bottom: 30px;
						float: left;
						width: 100%;
					}</style>
			</head>
			<body>
			<!-- Application Reference Model Template -->
			<script id="trend-summary-template" type="text/x-handlebars-template">
				<div class="row">
					<div class="col-xs-9">
						<h3 class="text-secondary">{{{link}}}</h3>
					</div>
					<div class="col-xs-3">
						<h3 class="text-secondary">From Year: <span class="text-primary">{{fromYear}}</span></h3>
					</div>
					<div class="col-xs-12">
						<p>{{description}}</p>
					</div>
				</div>
			</script>


			<!-- Application Reference Model Template -->
			<script id="bus-env-cat-template" type="text/x-handlebars-template">
            	<h3 class="text-secondary">Business Environment Impacts</h3>
				<div class="row">
		        	{{#each this}}
			            <div class="col-xs-4">
			            	<div class="bus-env-icon">
			            		<xsl:attribute name="eas-id">{{id}}</xsl:attribute>
			            		<i><xsl:attribute name="class">fa {{icon}} right-5</xsl:attribute></i><span>{{name}}</span>
			            	</div>
			            </div>
		            {{/each}}
		        </div>
		    </script>

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
										<xsl:value-of select="eas:i18n('Strategic Trends Dashboard')"/>
									</span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<!--<div class="col-xs-12">
              <h3 class="section-title bg-black"><xsl:value-of select="eas:i18n('Trend')"/>:&#32;<span id="trendTitle"/></h3>
            </div>-->
						<div class="col-xs-6">
							<div class="row">
								<div id="radarCanvas"/>
							</div>
						</div>
						<div class="col-xs-6">
							<div id="trend-summary-panel" class="dashboardPanel bg-offwhite hiddenDiv"/>
							<div class="clearfix"/>
							<div id="bus-env-cat-panel" class="dashboardPanel bg-offwhite">
								<!--<h2 class="text-secondary small">Business Environment Impacts</h2>
				                  <div class="col-xs-4 bus-env-icon">
				                    <i class="fa fa-building"/><span>&#32;Political</span>
				                  </div>
				                  <div class="col-xs-4 bus-env-icon">
				                    <i class="fa fa-money"/><span>&#32;Economic</span>
				                  </div>
				                  <div class="col-xs-4 bus-env-icon text-primary">
				                    <i class="fa fa-users"/><span>&#32;Social</span>
				                  </div>
				                  <div class="col-xs-4 bus-env-icon text-primary">
				                    <i class="fa fa-cogs"/><span>&#32;Technological</span>
				                  </div>
				                  <div class="col-xs-4 bus-env-icon">
				                    <i class="fa fa-globe"/><span>&#32;Environmental</span>
				                  </div>
				                  <div class="col-xs-4 bus-env-icon">
				                    <i class="fa fa-balance-scale"/><span>&#32;Legal</span>
				                  </div>-->
							</div>
							
							<div class="clearfix"/>
							<div class="dashboardPanel bg-offwhite">
								<h3 class="text-secondary">Geographic Scope</h3>
								<div class="map" id="mapScope"/>
							</div>
							
							<div class="clearfix"/>


							<!--<section class="add-to-list swing ">
                <div
                  style=";margin-left:24px;; padding-left:5px;color:#ffffff;background-color:#1b255c;width:80%;font-size:1.2em"
                  >Impacts</div>
                <ul id="list"> </ul>
              </section>-->
						</div>
						<div class="col-xs-12">
							<div class="dashboardPanel bg-offwhite">
								<h3 class="text-secondary">Strategic Implications</h3>
								<table class="small table table-striped table-bordered" id="implicationsTable">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Implication')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Probability')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Priority')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Status')"/>
											</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Implication')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Probability')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Priority')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Status')"/>
											</th>
										</tr>
									</tfoot>
									<tbody/>
								</table>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
 				<script type="text/javascript">
          var currentTrend, trendSummaryTemplate;
          
          var implicationsTable;
          
          var trendJSON = {
            'strategic-trends': [
              <xsl:apply-templates mode="RenderStratTrendsJSON" select="$allStratTrends"/>
            ]
          }
          
          var busEnvCatJSON = {
            'categories': [
              <xsl:apply-templates mode="RenderBusEnvCatsJSON" select="$allBusEnvCategories"><xsl:sort select="own_slot_value[slot_reference = 'enumeration_sequence_number']/value"/></xsl:apply-templates>
            ]
          }
          
          function refreshImplicationsTable() {
              if (implicationsTable != null) {
                  implicationsTable.clear();
                  implicationsTable.rows.add(currentTrend['implications']);
                  implicationsTable.draw();
              } else {
                  drawImplicationsTable();
              }
          }
          
          
          function drawImplicationsTable() {
              if (implicationsTable == null) {
                  
                  $('#implicationsTable tfoot th').each(function () {
                      var title = $(this).text();
                      $(this).html('<input type="text" placeholder="Search ' + title + '"/>');
                  });
                  
                  //create the table
                  implicationsTable = $('#implicationsTable').DataTable({
                      scrollY: "35vh",
                      scrollCollapse: false,
                      paging: false,
                      info: false,
                      sort: true,
                      responsive: false,
                      data: currentTrend['implications'],
                      rowId: 'id',
                      columns:[ {
                          "data": "link",
                          "width": "25%"
                      }, 
                      {
                          "data": "description",
                          "width": "35%",
                          "render": function (d) {
                              if (d != null) {
                                  return d;
                              } else {
                                  return "-";
                              }
                          }
                      }, 
                      {
                          "data": "confidence",
                          "width": "10%",
                          "render": function (d) {
                              if (d != null) {
                                  return Math.round(d * 100) + '%';
                              } else {
                                  return "-";
                              }
                          }
                      }, 
                      {
                          "data": "priorityRating",
                          "width": "10%",
                          "type": "html",
                          "render": function (d) {
                              if (d != null) {
                                  return d;
                              } else {
                                  return "-";
                              }
                          }
                      }, 
                      {
                          "data": "status",
                          "width": "10%",
                          "type": "html",
                          "render": function (d) {
                              if (d != null) {
                                  return d.label;
                              } else {
                                  return "-";
                              }
                          }
                      }],
                      "order":[[0, 'asc']],
                      dom: 'frtip'
                  });
                  
                  
                  
                  // Apply the search
                  implicationsTable.columns().every(function () {
                      var that = this;
                      
                      $('input', this.footer()).on('keyup change', function () {
                          if (that.search() !== this.value) {
                              that.search(this.value).draw();
                          }
                      });
                  });
                  
                  implicationsTable.columns.adjust();
                  
                  $(window).resize(function () {
                      implicationsTable.columns.adjust();
                  });
              }
          }
          
          function setBusEnvCatFootprint() {
            $('.bus-env-icon').removeClass('active');
            currentTrend.busEnvCatIds.forEach(function(aCatId) {
               $('.bus-env-icon[eas-id="' + aCatId + '"]').addClass('active');       
            });
          }
          
          
          function setCurrentTrend(aTrendNode) {
              currentTrend = trendJSON[ 'strategic-trends'].find(function (aTrend) {
                  return aTrend.id == aTrendNode[ 'eas-id'];
              });
              
              //console.log('CurrentTrend: ' + currentTrend.id);
              if(currentTrend != null) {
                  //update the trend summary panel
                  $('#trend-summary-panel').fadeIn(1000);
                  $('#trend-summary-panel').html(trendSummaryTemplate(currentTrend));
                  
                  //Update the Geographic Scope map
    						  setGeographicMap($('#mapScope').vectorMap('get', 'mapObject'), currentTrend.countries, 'hsla(200, 80%, 60%, 1)');
    						    						  
    						  //Refresh the implications table
    						  refreshImplicationsTable();
    						  
    						  //set the business environment category footprint
    						  setBusEnvCatFootprint();
  					  }
              
              //console.log(currentTrend);
          }
          
          
          
          var nodelist;
          
          function refreshTrendRadar() {
              
              nodelist = trendJSON[ 'strategic-trends'];
              
              var createNodes = function (ndcount, rn) {
                  
                  var shuffledArray = shuffle(nodelist);
                  
                  
                  function shuffle(sourceArray) {
                      for (var i = 0; i &lt; sourceArray.length - 1; i++) {
                          var j = i + Math.floor(Math.random() * (sourceArray.length - i));
                          
                          var temp = sourceArray[j];
                          sourceArray[j] = sourceArray[i];
                          sourceArray[i] = temp;
                      }
                      return sourceArray;
                  }
                  
                  var numNodes = nodelist.length;
                  var nodes =[],
                  width = (rn * 2) + 50,
                  height = (rn * 2) + 50,
                  radius = rn - 20,
                  angle,
                  x,
                  w,
                  y,
                  i;
                  
                  for (i = 0; i &lt; nodelist.length; i++) {
                      angle = (i / (numNodes/ 2)) * Math.PI;
                      // Calculate the angle at which the element will be placed.
                      // For a semicircle, we would use (i / numNodes) * Math.PI.
                      
                      
                      
                      radius = ((parseInt(nodelist[i].fromYear) - 2019) * 50) - 20
                      
                      var num = Math.floor(Math.random() * 30) + 1;
                      // this will get a number between 1 and 10;
                      num *= Math.floor(Math.random() * 2) == 1 ? 1: - 1;
                      
                      
                      x = (radius * Math.cos(angle)) + (width / 2) + num; // Calculate the x position of the element.
                      
                      y = (radius * Math.sin(angle)) + (width / 2) + num; // Calculate the y position of the element.
                      
                      nodes.push({
                          "eas-id": nodelist[i].id, 'id': i, 'x': x, 'y': y, 'name': nodelist[i].name, 'fromYear': nodelist[i].fromYear
                      });
                  }
                  
                  return nodes;
              }
              
              var createSvg = function (radius, callback) {
                  d3.selectAll('#radarCanvas > svg').remove();
                  var svg = d3.select('#radarCanvas').append('svg:svg').attr('width', (radius * 2) + 450).attr('height', (radius * 2) + 50);
                  
                  var rounds =[ {
                      "posn": 310, colour: "#f3f9ff"
                  },
                  {
                      "posn": 260, colour: "#e8f3ff"
                  },
                  {
                      "posn": 210, colour: "#dcedff"
                  },
                  {
                      "posn": 160, colour: "#d0e8ff"
                  },
                  {
                      "posn": 110, colour: "#c4e2ff"
                  },
                  {
                      "posn": 60, colour: "#f3f9ff"
                  }];
                  var roundsgrn =[ {
                      "posn": 310, colour: "#f6fae8"
                  },
                  {
                      "posn": 260, colour: "#f3f9e0"
                  },
                  {
                      "posn": 210, colour: "#eaf4c9"
                  },
                  {
                      "posn": 160, colour: "#e1f0b2"
                  },
                  {
                      "posn": 110, colour: "#d8ec9c"
                  },
                  {
                      "posn": 60, colour: "#c9e475"
                  }];
                  var dates =[2019, 2020, 2021, 2022, 2023, 2024, 2025];
                  
                  
                  
                  svg.selectAll("circle").data(rounds).enter().append("circle").attr("cy", 325).attr("cx", 325).attr("r", function (d) {
                      return (d.posn);
                  }).attr('fill', function (d) {
                      return (d.colour);
                  }).attr('stroke', '#d3d3d3');
                  
                  
                  svg.selectAll("text").data(dates).enter().append("text").attr("x", function (d, i) {
                      return (i * 50) + radius + 20
                  }).attr("y", 325).text(function (d, i) {
                      return d;
                  }).attr('fill', '#d3d3d3');
                  callback(svg);
              }
              
              
              
              var createElements = function (svg, nodes, elementRadius) {
                  var element = svg.selectAll('.dt').data(nodes).enter().append('g').attr("id", function (d) {
                      return d.name
                  }).on("click", function (d) {
                      d3.selectAll('.dt').transition().duration(300).attr('fill', "#fcc511").attr('stroke-width', "1px").attr('stroke', "#a07c37");
                      
                      d3.select(this).selectAll('circle').transition().duration(300).attr('fill', "#d3d3d3").attr('stroke-width', "2px").attr('stroke', "#ea2368");
                      
                      setCurrentTrend(d);
                  });
                  
                  element.append('svg:circle').attr("class", function (d, i) {
                      return d.id + ' dt';
                  }).attr("id", function (d, i) {
                      return 'n' + d.id;
                  }).attr('r', elementRadius).attr('cx', function (d, i) {
                      return d.x;
                  }).attr('cy', function (d, i) {
                      return d.y;
                  }).attr('fill', '#fcc511').attr('stroke-width', "1px").attr('stroke', "#a07c37");;
                  element.append('svg:text').attr('x', function (d, i) {
                      return d.x + 15;
                  }).attr('y', function (d, i) {
                      return d.y + 5;
                  }).text(function (d, i) {
                      return d.name;
                  });
              }
              
              
              var draw = function () {
                  var numNodes = $("#numNodes").val() || 100;
                  var radius = 300;
                  var nodes = createNodes(numNodes, radius);
                  createSvg(radius, function (svg) {
                      //console.log(nodes);
                      createElements(svg, nodes, 10);
                  });
              }
              
              $(document).ready(function () {
                  draw();
              });
              
              $("#radius, #numNodes").bind('keyup', function (e) {
                  draw();
              });
          };
          
          
          //funtion to set the Geographic Scope of the currently selected business units
      		function setGeographicMap(mapObject, collatedCountryList, countryColour) {
      			
         			var countrySet = {};
         			
         			for (i = 0; collatedCountryList.length > i; i += 1) {
         				countrySet[collatedCountryList[i]] = countryColour;
         			};
         
         			//console.log("Select Countries: " + collatedCountryList);
         			mapObject.reset();
         			mapObject.series.regions[0].setValues(countrySet);
      		
      		}
          
          
					$(document).ready(function(){
					     var trendSummaryFragment = $("#trend-summary-template").html();
                            trendSummaryTemplate = Handlebars.compile(trendSummaryFragment);
               
                        var busEnvFragment = $("#bus-env-cat-template").html();
                        var busEnvTemplate = Handlebars.compile(busEnvFragment);
                        $('#bus-env-cat-panel').html(busEnvTemplate(busEnvCatJSON.categories));
					 
					     $('#mapScope').vectorMap(
  							{
    								map: '<xsl:value-of select="$geoMapId"/>',
                   					zoomOnScroll: false,
    								backgroundColor: 'transparent',
    								hoverOpacity: 0.7,
    								hoverColor: false,
    								regionStyle: {
    								    initial: {
    									    fill: '#ccc',
    									    "fill-opacity": 1,
    									    stroke: 'none',
    									    "stroke-width": 0,
    									    "stroke-opacity": 1
    								    }
    							    },
    							    markerStyle: {
    							    	initial: {
    								        fill: 'yellow',
    								        stroke: 'black',
    							        }
    							    },
    							    <!--markers: [{latLng: [41.90, 12.45], name: 'My App'}],-->
    							    series: {
    							    regions: [{
    							    	values: {},
    							    	attribute: 'fill'
    							    }]
    							  }
    							}
    						);	
					 
					     refreshTrendRadar();
					
					
  						
					});
  
    </script>
        
			</body>
		</html>
	</xsl:template>


	<xsl:template mode="RenderStratTrendsJSON" match="node()">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisStratImpls" select="$allTrendImpls[name = current()/own_slot_value[slot_reference = 'strategic_trend_implications']/value]"/>
		<xsl:variable name="thisGeoScope" select="$allCountries[name = $thisStratImpls/own_slot_value[slot_reference = 'sti_geo_scope']/value]"/>
		<xsl:variable name="thisBusEnvChanges" select="$allBusEnvChanges[name = $thisStratImpls/own_slot_value[slot_reference = 'sti_business_environment_impacts']/value]"/>
		<xsl:variable name="thisBusEnvFactors" select="$allBusEnvFactors[name = $thisBusEnvChanges/own_slot_value[slot_reference = 'change_for_bus_env_factor']/value]"/>
		<xsl:variable name="thisBusEnvCats" select="$allBusEnvCategories[name = $thisBusEnvFactors/own_slot_value[slot_reference = 'bef_category']/value]"/>
		<xsl:variable name="thisFromYear" select="current()/own_slot_value[slot_reference = 'strategic_trend_from_year_iso8601']/value"/>
		{
		"id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>",
		"link": "<xsl:value-of select="$thisLink"/>",
		"fromYear": "<xsl:value-of select="$thisFromYear"/>",
		"description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"countries": [<xsl:for-each select="$thisGeoScope">"<xsl:value-of select="current()/own_slot_value[slot_reference = 'gr_region_identifier']/value"/>"<xsl:if test="not(position() = last())">, </xsl:if></xsl:for-each>],
		"busEnvCatIds": [<xsl:apply-templates mode="RenderElementIDListForJs" select="$thisBusEnvCats"/>],
		"implications": [<xsl:apply-templates select="$thisStratImpls" mode="RenderStratTrendImplJSON"/>] }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template mode="RenderStratTrendImplJSON" match="node()">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisLabel" select="current()/own_slot_value[slot_reference = 'sti_label']/value"/>
		<xsl:variable name="thisLink">
			<xsl:call-template name="RenderInstanceLinkForJS">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="displayString" select="$thisLabel"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisStatus" select="$allStratTrendImplStatii[name = current()/own_slot_value[slot_reference = 'sti_lifecycle_status']/value]"/>
		<xsl:variable name="thisConfidence" select="current()/own_slot_value[slot_reference = 'sti_implication_confidence_level']/value"/>
		<xsl:variable name="thisPriority" select="current()/own_slot_value[slot_reference = 'sti_priority_score']/value"/>
		{ "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>",
		"name": "<xsl:value-of select="eas:validJSONString($thisName)"/>", "label": "<xsl:value-of select="eas:validJSONString($thisLabel)"/>",
		"link": "<xsl:value-of select="$thisLink"/>", "description": "<xsl:value-of select="eas:validJSONString($thisDesc)"/>",
		"priorityRating": <xsl:value-of select="$thisPriority"/>,
		"status": <xsl:choose><xsl:when test="count($thisStatus) > 0"><xsl:call-template name="RenderStatusJSON"><xsl:with-param name="theStatus" select="$thisStatus"/></xsl:call-template></xsl:when><xsl:otherwise>null</xsl:otherwise></xsl:choose>,
		"confidence": <xsl:value-of select="$thisConfidence"/> 
		}<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template mode="RenderBusEnvCatsJSON" match="node()">
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisIcon" select="current()/own_slot_value[slot_reference = 'enumeration_icon']/value"/> { "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "name": "<xsl:value-of select="eas:validJSONString($thisName)"/>", "icon": "<xsl:value-of select="$thisIcon"/>" }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template name="RenderStatusJSON">
		<xsl:param name="theStatus"/>
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$theStatus"/></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisLabel" select="$theStatus/own_slot_value[slot_reference = 'enumeration_value']/value"/> { "id": "<xsl:value-of select="eas:getSafeJSString($theStatus/name)"/>", "name": "<xsl:value-of select="eas:validJSONString($thisName)"/>", "label": "<xsl:value-of select="eas:validJSONString($thisLabel)"/>" }
	</xsl:template>

</xsl:stylesheet>
