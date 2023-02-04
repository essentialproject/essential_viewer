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

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="allClasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete']"/>
	<xsl:variable name="allReportMenus" select="/node()/simple_instance[type = 'Report_Menu']"/>
	<xsl:variable name="linkClasses" select="$allClasses[name = $allReportMenus/own_slot_value[slot_reference = 'report_menu_class']/value]/name"/>
	<xsl:variable name="allSlots" select="/node()/slot"/>

	<!-- END GENERIC LINK VARIABLES -->
	<!--<xsl:variable name="thisObject" select="/node()/simple_instance[name = $param2]"/>
	<xsl:variable name="thisObjectClass " select="/node()/class[name = $thisObject/type]"/>
	<xsl:variable name="thisObjectSlots">
		<xsl:apply-templates select="$thisObject/own_slot_value" mode="seqslots"/>
	</xsl:variable>
-->
	<xsl:variable name="mclasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete' and not(contains(name, 'RELATION')) and not(contains(name, ':')) and not(contains(name, '-'))]"/>
	<xsl:variable name="thisClass" select="/node()/class[type = ':ESSENTIAL-CLASS'][(name = $param1) or (supertype = $param1)]"/>
	<xsl:variable name="thisClassslots">
		<xsl:apply-templates select="$thisClass/own_slot_value" mode="seqslots"/>
	</xsl:variable>
	<xsl:variable name="classInstances" select="/node()/simple_instance[type = $param1]"/>
	<xsl:variable name="classInstanceCount" select="count($classInstances)"/>
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
				<script src="js/chartjs/Chart.min.js"/>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<title>Repository Completeness Analysis</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<style>
					#dt_objects_wrapper{
						margin-top: -30px !important;
					}</style>

				<script>
					$(document).ready(function(){
						$('select').select2({
							placeholder: "Select a class",
							theme: "bootstrap"
						});
					});
				</script>
				<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
					    $('#dt_objects tfoot th').each( function () {
					        var title = $(this).text();
					        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
					    } );
						
						var table = $('#dt_objects').DataTable({
						paging: false,
						deferRender:    true,
			            scrollY:        400,
			            scrollCollapse: true,
						info: true,
						sort: true,
						responsive: false,
                        
						columns: [
						    { "width": "45%" },
						    { "width": "15%" },
						    { "width": "15%" },
                            { "width": "15%" }
						  ],
						dom: 'Bfrtip',
					    buttons: [
				            'copyHtml5', 
				            'excelHtml5',
				            'csvHtml5',
				            'pdfHtml5',
				            'print'
				        ],
                        order: [[ 2, 'desc' ],[1,'desc']]
						});
						
						
						// Apply the search
					    table.columns().every( function () {
					        var that = this;
					 
					        $( 'input', this.footer() ).on( 'keyup change', function () {
					            if ( that.search() !== this.value ) {
					                that
					                    .search( this.value )
					                    .draw();
					            }
					        } );
					    } );
					    
					    table.columns.adjust();
					    
					    $(window).resize( function () {
					        table.columns.adjust();
					    });
					});
				</script>
			</head>
			<body>
				<script src="js/d3/d3.min.js"/>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-darkgrey">Repository Completeness for Class: </span>
									<span class="text-primary">
										<xsl:value-of select="replace($param1, '_', ' ')"/>
									</span>
								</h1>
							</div>
						</div>
						<div class="col-xs-4">
							<h2 class="text-primary">Selected Class</h2>
							<div class="form-group">
								<select id="myclasses" style="width:100%;" class="selectBox form-control" onchange="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_completeness_view.xsl&amp;PMA='+myclasses.value">
									<option>Select a Class</option>
									<xsl:apply-templates select="$mclasses" mode="getOptions">
										<xsl:sort select="name"/>
									</xsl:apply-templates>
								</select>
							</div>
						</div>
						<div class="col-xs-4 col-xs-offset-1">
							<div class="pull-left right-15 top-15">
								<i class="fa fa-3x fa-sitemap text-primary"/>
							</div>
							<div class="pull-left">
								<div class="subtitle fontBlack text-primary">
									<xsl:value-of select="$classInstanceCount"/>
								</div>
								<div class="xlarge fontBlack text-midgrey" style="margin-top: -10px;">Instances</div>
							</div>
						</div>
						<div class="col-xs-12">
							<hr/>
						</div>
						<div class="col-sm-12 col-md-6">
							<h2 class="text-primary">Slots for Class</h2>
							<table id="dt_objects" class="table table-striped table-bordered table-condensed small">
								<thead>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Slot')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Completed')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Percentage')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Total Instances')"/>
										</th>

									</tr>
								</thead>
								<xsl:apply-templates select="$thisClass" mode="classSlots">
									<xsl:sort select="slot_reference" order="ascending"/>
								</xsl:apply-templates>
								<tfoot>
									<tr>
										<th>
											<xsl:value-of select="eas:i18n('Slot')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Completed')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Percentage')"/>
										</th>
										<th>
											<xsl:value-of select="eas:i18n('Total Instances')"/>
										</th>
									</tr>
								</tfoot>
							</table>

						</div>
						<div class="col-xs-5">
							<script>
								$(document).ready(function(){
								$('#tabList a').click(function (e) {
								  e.preventDefault()
								  $(this).tab('show')
								})
								});
							</script>
							<h2 class="text-primary">Analysis</h2>
							<!-- Nav tabs -->
							<ul class="nav nav-tabs" role="tablist" id="tabList">
								<li role="presentation" class="active">
									<a href="#chart" aria-controls="chart" role="tab" data-toggle="tab">Chart</a>
								</li>
								<li role="presentation">
									<a href="#instUnion" aria-controls="union" role="tab" data-toggle="tab">Instance Union</a>
								</li>
								<li role="presentation">
									<a href="#instInter" aria-controls="intersection" role="tab" data-toggle="tab">Instance Intersection</a>
								</li>
							</ul>
							<div class="tab-content">
								<div role="tabpanel" class="tab-pane fade in active" id="chart">
									<canvas id="myChart" width="100%" height="100%"/>
									<script>
                                        var myTableArray = [];

                                        $("table#dt_objects tr").each(function() {
                                            var arrayOfThisRow = [];
                                            var tableData = $(this).find('td');
                                            if (tableData.length > 0) {
                                                tableData.each(function() { arrayOfThisRow.push($(this).text()); });
                                                myTableArray.push(arrayOfThisRow);
                                            }
                                        });
                                        myTableArray.sort(compareSecondColumn);



                                        var result = [];
                                        for (var i = 0; i &lt; myTableArray.length; i++)
                                        {
                                            if (myTableArray[i][1] !== '0')
                                            {
                                                result.push(myTableArray[i]);
                                            }
                                        }
                                    

                                        function compareSecondColumn(a, b) {
                                            if (a[1] === b[1]) {
                                                return 0;
                                            }
                                            else {
                                                return (a[1] &lt; b[1]) ? -1 : 1;
                                            }
                                        }
                                        var labellist=[];
                                        var valuelist=[];
                                        for (i=0; i &lt; result.length;i++){
                                                labellist.push(''+result[i][0]+'');
                                                 valuelist.push(result[i][1]);                                    
                                            }           
                                            
                                        var ctx = document.getElementById("myChart");
                                        var myChart = new Chart(ctx, {
                                            type: 'horizontalBar',
                                            data: {
                                                labels: labellist,
                                                datasets: [{
                                                    label: '# of instances',
                                                    data: valuelist,
                                                    backgroundColor: "rgb(11, 168, 244)",
                                                    borderWidth: 1
                                                }]
                                            },
                                            options: {
                                                scales: {
                                                    yAxes: [{
                                                        ticks: {
                                                            beginAtZero:true,
                                                            fontSize:12
                                                        }
                                                    }]
                                                }
                                            }
                                        });
                                        </script>
								</div>
								<div role="tabpanel" class="tab-pane fade" id="instUnion">
									<h3>All Instances Using All Selected Slots</h3>
									<h5 class="text-secondary">
										<em>Click slot(s) in table to show.</em>
									</h5>
									<div id="nonPopulatedBoxIntersection">
										<table id="popIds" class="table table-condensed small"/>
									</div>

								</div>
								<div role="tabpanel" class="tab-pane fade" id="instInter">
									<h4>All Instances Not Using the Selected Slot(s) </h4>
									<h5 class="text-secondary">
										<em>Click slot(s) in the table to show.</em>
									</h5>
									<div id="nonPopulatedBox">
										<table id="popClasses" class="table table-condensed small"/>
									</div>

								</div>
							</div>
						</div>
						<hr/>

						<!--Setup Closing Tags-->
					</div>
				</div>
				<script>

                    
                function switchBut(ele){
                    if ($(ele).attr("class") ==='btn btn-primary' || $(ele).attr("class") ==='btn btn-primary collapsed'){$(ele).removeClass('btn btn-primary');$(ele).addClass('btn btn-default')}
                    else
                    {$(ele).removeClass('btn btn-default');$(ele).addClass('btn btn-primary')};
                    }
                    
				classJSON=[<xsl:apply-templates select="$classInstances" mode="getJSON"/>];
			 
                alphaJSON=classJSON.sort(function(x, y) {
                                return d3.ascending(x.name, y.name);
                            });
               
                function showComplete(className){
                  elementsToShow=[];   
                    clearRows();
                     var selectedClass = classJSON.filter(function (el) {
                          return el.name === className;
                                }); 
             
                    for (var i=0; i &lt; selectedClass[0].slots.length;i++){
                    
                     d3.selectAll('body').selectAll('#td'+selectedClass[0].slots[i])
                        .style("background-color",'#3fa3ac');                                  
                               } 
                    }
                    
               for (var i=0; i &lt; alphaJSON.length;i++) {
                   slotVal = '';
                   nameStr =  alphaJSON[i].id.replace(/\s/g, '');
                    for (var j=0; j &lt; alphaJSON[i].slots.length; j++)
                        {slotVal =slotVal + alphaJSON[i].slots[j]+" "}
                    
                    $("#popClasses").append("&lt;tr class='"+slotVal+"'&gt;&lt;td&gt;"+alphaJSON[i].link+"&lt;/td&gt;&lt;/tr&gt;");
               
                    $("#popIds").append("&lt;tr id='"+nameStr+"' &gt;&lt;td&gt;"+alphaJSON[i].link+"&lt;/td&gt;&lt;/tr&gt;");
                        }
                  
               elementsToShow=[];    
                    
              function clearRows(){
                    <!--d3.selectAll('body').selectAll('.rowColour')
                        .style("background-color",'#ffffff');-->
                    }    
                
              function elementUses(slotName){      
                    if (document.getElementById("td"+slotName).style.backgroundColor === 'rgb(63, 163, 172)')
                            {
                                $("#td"+slotName).css('background-color', '#ffffff');
                                $("."+slotName).show();
                                 const index = elementsToShow.indexOf(slotName);
                                    elementsToShow.splice(index, 1);
                            for (var i=0;i &lt; elementsToShow.length;i++){
                                 $("."+elementsToShow[i]).hide();
                                    }
                               }
                            else {
    
                                $("."+slotName).hide();
                                $("#td"+slotName).css('background-color', 'rgb(63, 163, 172)');
                                elementsToShow.push(slotName)
                            }
                  
                        }
                
               function elementUsesAll(){ 
                    $("table#popIds tr:gt(0)").hide();
                    for (var i=0;i &lt; alphaJSON.length;i++){
                        rowid=alphaJSON[i].id.replace(/\s/g, '');
                        document.getElementById(rowid).style.display='none';
                    } 
                    
                    
                    var numOfElements=0;
                    var selectedSlots=elementsToShow.length;
                    for (var i=0;i &lt; classJSON.length;i++){
                    numOfElements=0;
                        for (var j=0;j &lt; elementsToShow.length;j++){
                             for (var k=0;k &lt; classJSON[i].slots.length;k++){ 
               
                                    if(classJSON[i].slots[k]===elementsToShow[j]){numOfElements=numOfElements+1;
                                      };
                                    }
                                } 
        
                    if(numOfElements===selectedSlots){
                    nameStr =  alphaJSON[i].id.replace(/\s/g, '');
                    document.getElementById(nameStr).style.display='table-row';
                            }
                        }
                   
                    };

                    $('.Num0').remove();
                    
                </script>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="slots">
		<xsl:variable name="target" select="value"/>
		<tr>
			<td>
				<xsl:value-of select="slot_reference"/>
			</td>
			<td>
				<ul>
					<xsl:for-each select="$target">
						<li>
							<xsl:value-of select="current()"/>
						</li>
					</xsl:for-each>
				</ul>
			</td>
			<td> </td>
		</tr>

	</xsl:template>

	<xsl:template match="node()" mode="classSlots">
		<xsl:variable name="thissuperObject" select="superclass"/>
		<xsl:variable name="this" select="."/>

		<xsl:if test="position() = 1">
			<xsl:if test="superclass">
				<xsl:apply-templates select="/node()/class[name = $thissuperObject]" mode="classSlots"/>
			</xsl:if>
		</xsl:if>

		<xsl:apply-templates select="template_slot" mode="slotDetail"> </xsl:apply-templates>
	</xsl:template>

	<xsl:template match="node()" mode="slotDetail">
		<xsl:variable name="this" select="."/>
		<xsl:variable name="thisCount" select="count(/node()/simple_instance[type = $param1][own_slot_value[slot_reference = $this]/value])"/>
		<xsl:if test="not($this = 'external_repository_instance_reference')">
			<tr id="{$this}" class="rowColour Num{$thisCount}">
				<td id="td{$this}" class="comptdcolor" onClick="elementUses('{$this}');elementUsesAll()" style="cursor:pointer">
					<xsl:value-of select="$this"/>
				</td>
				<td>
					<xsl:value-of select="$thisCount"/>
				</td>
				<td>
					<xsl:choose>
						<xsl:when test="$classInstanceCount &gt; 0">
							<xsl:value-of select="format-number($thisCount div $classInstanceCount, '#%')"/>
						</xsl:when>
						<xsl:otherwise>0%</xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<xsl:value-of select="count(/node()/simple_instance[type = $param1]/own_slot_value[slot_reference = $this]/value)"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="getJSON"> {"name":"<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>",
	"link":"<xsl:call-template name="RenderInstanceLinkForJS">
			<xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>",
	"id":"<xsl:value-of select="name"/>","slots":[<xsl:apply-templates select="own_slot_value/slot_reference" mode="slots"/>]}<xsl:if test="not(position() = last())">,</xsl:if></xsl:template>

	<xsl:template match="node()" mode="slots">
		<xsl:if test="not(. = 'external_repository_instance_reference')">"<xsl:value-of select="."/>"</xsl:if>
		<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="options">
		<xsl:variable name="this" select="own_slot_value[slot_reference = 'name']/value"/>
		<option value="{$this}">
			<xsl:value-of select="$this"/>
		</option>
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
