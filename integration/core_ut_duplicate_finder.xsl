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
	<xsl:param name="param2"/>
	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="mclasses" select="/node()/class[type = ':ESSENTIAL-CLASS' and own_slot_value[slot_reference = ':ROLE']/value = 'Concrete' and not(contains(name, 'RELATION')) and not(contains(name, ':'))]"/>

	<xsl:variable name="class" select="/node()/simple_instance[(type = $param1) or (supertype = $param1)]"/>
	<xsl:variable name="class2"> </xsl:variable>

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
				<title>Data Duplication Finder</title>
				<xsl:call-template name="dataTablesLibrary"/>
				<script src="js/fuse.min.js"/>
				<link href="js/select2/css/select2.min.css" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js"/>
				<script>
					$(document).ready(function(){
						$('select').select2({theme: "bootstrap"});
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
									<span class="text-darkgrey">Duplicate Finder - </span><span class="text-primary"><xsl:value-of select="replace($param1, '_', ' ')"/></span>
								</h1>
							</div>
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="row">
								<div class="col-xs-4">
									<label name="Class"> Class</label>
									<select id="myclasses" class="form-control" onchange="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA='+myclasses.value+'&amp;PMA2='+filterRange.value">
										<xsl:apply-templates select="$mclasses" mode="getOptions">
											<xsl:sort select="name"/>
										</xsl:apply-templates>
									</select>
								</div>
								<div class="col-xs-4">
									<label name="Sensitivity"> Sensitivity</label>
									<select id="filterRange" class="form-control" onchange="window.location='report?XML=reportXML.xml&amp;XSL=integration/core_ut_duplicate_finder.xsl&amp;PMA='+myclasses.value+'&amp;PMA2='+filterRange.value">
										<option value="0.00001">100%</option>
										<option value="0.1">90%</option>
										<option value="0.2">80%</option>
										<option value="0.3">70%</option>
									</select>
								</div>
							</div>
							<div class="clearfix"></div>
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
									    { "width": "40%" },
									    { "width": "40%" },
                                        { "width": "20%" }
									  ],
									dom: 'Bfrtip',
								    buttons: [
							            'copyHtml5', 
							            'excelHtml5',
							            'csvHtml5',
							            'pdfHtml5',
							            'print'
							        ]
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
								<table id="dt_objects" class="table table-striped table-bordered">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Focus')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Potential Duplicate')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Score')"/>
											</th>

										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Focus')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Potential Duplicate')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Score')"/>
											</th>
										</tr>
									</tfoot>
									<tbody> </tbody>
								</table>


								<script>
									console.log(<xsl:value-of select="$param2"/>)
									val ='<xsl:choose><xsl:when test="count($param2)&gt;0"><xsl:value-of select="$param2"/></xsl:when><xsl:otherwise>0.1</xsl:otherwise></xsl:choose>';
									if(val=''){val='0.1'}
									console.log('val',val)
									$('#filterRange').val(parseInt(val)); 
									console.log('filtr')
									var test;
                                    var applicationsJSON = [<xsl:apply-templates select="$class" mode="getJSON"/>];
                                <!-- remove characters that make it fail -->
                                    
                                    x =JSON.stringify(applicationsJSON);
                                    filter1 = x.replace("(","");
                                    filter2= filter1.replace(")","");
                                    filter3= filter2.replace("&#47;","");
                                    var applications = JSON.parse(filter3);
                                    
                                <!-- set options for logic -->    
                                    var options = {
                                      keys: ['name'],
                                      id: 'name',
                                      includeScore: true,
                                      threshold: parseInt(val),
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
                                    
                                    
                                    <!--  $("#results").append("&lt;tr style='background-color:#d3d3d3'&gt;&lt;td colspan='2'&gt;"+applications[j].name +"&lt;/td&gt;&lt;/tr&gt;")
                                     console.log(applications[j].name);-->
                                    for (var i=1; i &lt; myresults.length;i++){
                                        var thisthing = applications[j].name.length;
                                        var potentialmatch = myresults[i].item.length;
                   
                                       if (myresults[i].score &lt; 0.45){ 
                                        if((Math.abs(thisthing - potentialmatch)&lt;3)){   
                                            var colour;
                                            if (myresults[i].score &lt; 0.05){colour = 'rgba(255, 107, 107, 0.66)';}
                                            else if (myresults[i].score &lt; 0.1){colour = 'rgba(255, 220, 0, 0.48)';}
                                            else {colour = 'rgba(180, 218, 36, 0.53)';};
                                   
                                    
                                        $("#dt_objects").append("&lt;tr class='match'&gt;&lt;td&gt;"+applications[j].name +"&lt;/td&gt;&lt;td&gt;"+ myresults[i].item +"&lt;/td&gt;&lt;td style='background-color:"+colour+"'&gt;"+ ((1 - (myresults[i].score).toFixed(2)))*100 + "%&lt;/td&gt;&lt;/tr&gt;");
                                    
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    var t = $('#myclasses').find('option[value=<xsl:value-of select="$param1"/>]').length > 0;
                                    if(!(t)){console.log("no");$('#myclasses').append('&lt;option selected="true"&gt;<xsl:value-of select="$param1"/>&lt;/option&gt;')}
                                    </script>

							

							<div class="clearfix"/>
							<hr/>
						</div>

						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="getJSON">
		<xsl:variable name="this"><xsl:value-of select="translate(normalize-space(current()/own_slot_value[slot_reference = 'name']/value),'/&quot;','`')"/><xsl:value-of select="own_slot_value[slot_reference = 'relation_name']/value"/></xsl:variable> {"name":"<xsl:choose><xsl:when test="contains($this, '++')"><xsl:value-of select="substring-before($this, ' ')"/></xsl:when><xsl:otherwise><xsl:value-of select="replace($this, '&#47;', ' ')"/></xsl:otherwise></xsl:choose>","id":"<xsl:value-of select="name"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
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
