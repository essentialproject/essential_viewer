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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider', 'Composite_Application_Provider', 'Business_Process', 'Physical_Process','Application_Capability','Technology_Capability','Technology_Component','Technology_Product','Technology_Provider_Role')"/>

	<!-- END GENERIC LINK VARIABLES -->
	<xsl:variable name="standard" select="/node()/simple_instance[type = 'Control_Framework']"/>
	<xsl:variable name="thisStandard" select="$standard[name = $param1]"/>
	<xsl:variable name="controls" select="/node()/simple_instance[type = 'Control'][name = $thisStandard/own_slot_value[slot_reference = 'cf_controls']/value]"/>
	<xsl:variable name="assessments" select="/node()/simple_instance[type = 'Control_Assessment'][own_slot_value[slot_reference = 'assessment_control']/value = $controls/name]"/>
	<xsl:variable name="dates" select="/node()/simple_instance[type = 'Gregorian']"/>
	<xsl:variable name="actors" select="/node()/simple_instance[type = 'Individual_Actor'][name = $assessments/own_slot_value[slot_reference = 'control_assessor']/value]"/>
	<xsl:variable name="commentary" select="/node()/simple_instance[type = 'Commentary']"/>
	<xsl:variable name="findings" select="/node()/simple_instance[type = 'Control_Assessment_Finding']"/>


	<!--
		* Copyright © 2008-2016 Enterprise Architecture Solutions Limited.
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
	<!-- May 2011 Updated to support Essential Viewer version 3-->


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
				<title>Security Compliance</title>
				<style>					
					.assessmentHeading{
						font-size: 10pt;
						font-weight: bold
					}
					
					.Pass{
						background-color: green;
						color: #ffffff
					}
					
					.Fail{
						background-color: red;
						color: #ffffff
					}
					
					.panel{
						margin: 3px;
					}
					
					.circle-icon{
						background: #f2f2f2;
						border: 1pt solid d3d3d3;
						width: 50px;
						height: 50px;
						border-radius: 50%;
						text-align: center;
						line-height: 30px;
						vertical-align: middle;
						padding: 10px;
						box-shadow: 1px 1px rgba(142, 142, 142, 0.6);
						-moz-box-shadow: 1px 1px rgba(142, 142, 142, 0.6);
					}
					
					.filterPanel{
						border: 1pt solid #d3d3d3;
						border-radius: 4px;
						background-color: #efefef;
						padding: 5px 10px;
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
								<span class="pull-right"> Change Framework:<select id="stdSelect" class="pull-right">
										<option id="">Choose</option>
										<xsl:apply-templates select="$standard" mode="options">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
										</xsl:apply-templates>
									</select>
								</span>
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Standards Controls Mapping using </span>
									<span class="text-primary"><xsl:value-of select="$thisStandard/own_slot_value[slot_reference = 'name']/value"/></span>
								</h1>
							</div>
						</div>
						<div class="col-xs-12">
							<div class="filterPanel">
								<label class="uppercase right-30">Filter by:</label>
								<label class="right-5">Control ID:</label>
								<input type="text" id="idFilter" class="right-15"/>
								<label class="right-5">Assessor:</label>
								<select id="assessFilter" class="right-15">
									<option id="all">All</option>
									<xsl:apply-templates select="$actors" mode="options">
										<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
									</xsl:apply-templates>
								</select>
								<label class="right-5">Status:</label>
								<select id="statusFilter" class="right-15">
									<option id="all">All</option>
									<option id="aPass">Pass</option>
									<option id="aFail">Fail</option>
								</select>
								<select id="worryFilter">
									<option id="all">All</option>
									<option id="due">Due</option>
									<option id="late">Overdue</option>
									<option id="notDone">No Assessment</option>
								</select>
							</div>
						</div>
						<div class="col-xs-12 top-10 bottom-10">
							<div class="row">
								<div class="col-xs-6">
									<label class="right-15">Assessment Key:</label>
									<i class="fa fa-check-circle right-5" style="color: green"/>
									<label class="right-15">Up to Date</label> 
									<i class="fa fa-exclamation-triangle right-5" style="color: #ffba00"/>
									<label class="right-15">Due</label>
									<i class="fa fa-exclamation-triangle right-5" style="color: #ff0031"/>
									<label class="right-15">Overdue</label> 
								<!--	<i class="fa fa-minus-square right-5" style="color: #ad7c7c"/>
									<label class="right-15">No Assessment</label> -->
								</div>
								<div class="col-xs-6">
									<span class="pull-right">
										<i class="fa fa-calendar right-5" />
										<label class="right-15">Assessment Date</label>
										<i class="fa fa-user right-5" />
										<label class="right-15">Assessor</label>
										<i class="fa fa-check-circle-o right-5"/>
										<label>Status</label>
									</span>
								</div>
							</div>
						</div>
						<div class="col-xs-12">
							<div id="controls" class="top-10"/>	
							<div id="analysis" class="top-10">
								<div id="analysisPane"/>
							</div>
						</div>
					</div>
				</div>
				<script>
var dataJSON = [ <xsl:apply-templates select = "$controls"
        mode = "getData"> <xsl:sort select = "own_slot_value[slot_reference='name']/value"
        order = "ascending" /> </xsl:apply-templates> ]
        let today = new Date();
        dataJSON.forEach(function(d) {
            var dateVal;
            if (d.assessments.length &gt; 0) {
                dateVal = d.assessments[0].assessmentDate;
                d.assessments.forEach(function(e) {
                    if (e.assessmentDate &lt; dateVal) {
                        dateVal = e.assessmentDate;
                    }

                })
            } else {
                dateVal = 0
            }

            if (dateVal) {
                let dateToShow = new Date(dateVal);

                diff = (((((today - dateToShow) / 1000) / 60) / 60) / 24);
                if (diff > 365) {
                    {
                        d['colour'] = 'red';
                        d['textColour'] = '#ffffff';
                        d['icon'] = 'exclamation-triangle'
                    }
                } else
                if (diff > 250) {
                    {
                        d['colour'] = '#ffc400';
                        d['textColour'] = '#000000';
                        d['icon'] = 'exclamation-triangle'
                    }
                } else if (diff &lt; 250) {
                    {
                        d['colour'] = 'green';
                        d['textColour'] = '#ffffff';
                        d['icon'] = 'check-circle'
                    }
                } else {
                    {
                        d['colour'] = '#ad7c7c';
                        d['textColour'] = '#ffffff';
                        d['icon'] = 'minus-square'
                    }
                }
            } else {
                d['colour'] = 'red';
                d['textColour'] = '#ffffff';
                d['icon'] = 'exclamation-triangle'
            }

            if (d.status === 'Pass') {
                d['statusColour'] = 'green';
                d['statusTextColour'] = '#ffffff';
            } else if (d.status === 'Fail') {
                d['statusColour'] = 'red';
                d['statusTextColour'] = '#ffffff';
            } else {
                d.status = 'Unknown';
                d['statusColour'] = 'red';
                d['statusTextColour'] = '#ffffff';
            }
        })

        let allAssessment = dataJSON.map(function(d) {

            return d.assessments;
        });

        allAssessment = allAssessment.flat();

        let allElements = allAssessment.filter(function(d) {
            return d.status === 'Fail';
        });


        $(document).ready(function() {
            var summaryFragment = $("#summary-template").html();
            summaryTemplate = Handlebars.compile(summaryFragment);

            var analysisFragment = $("#analysis-template").html();
            analysisTemplate = Handlebars.compile(analysisFragment);

            $('#analysisPane').append(analysisTemplate(allElements));

            $('#controls').append(summaryTemplate(dataJSON));

        });

        function doControl() {
            filterList = $('#idFilter').val().toUpperCase();

            if (filterList === '') {
                $(".ctrl").show();
            } else {
                $(".ctrl").hide();

                $("[class*='fil" + filterList + "']").show();
            }
        }

        $('#myFilter').click(function() {


        })
        $('#idFilter').keyup(function() {
            doControl();
        })
        $('#assessFilter').change(function() {
            doFilter();
        });
        $('#statusFilter').change(function() {
            doFilter();
        });
        $('#worryFilter').change(function() {
            doFilter();
        });

        function doFilter() {
            var worryFilterList = $('#worryFilter option:selected').attr("id");
            var statusfilterList = $('#statusFilter option:selected').val();
            var assessfilterList = $('#assessFilter option:selected').attr("id");
            var outputList = [];
            var assessList = [];
            var worryList = [];
            var workingList = JSON.parse(JSON.stringify(dataJSON));

            if (statusfilterList != 'All') {
                var toShow = workingList.filter(function(d) {
                    var list = d.assessments.filter(function(e) {
                        return e.status === statusfilterList;
                    });

                    if (list.length &gt; 0) {
                        d['assessments'] = list;

                        outputList.push(d);
                    }

                });
            } else {
                outputList = workingList;
            }
            if (assessfilterList != 'all') {
                var toShow = outputList.filter(function(d) {
                    var assesslist = d.assessments.filter(function(e) {
                        console.log(e);
                        return e.assessorID === assessfilterList;
                    });

                    if (assesslist.length &gt; 0) {
                        d['assessments'] = assesslist;

                        assessList.push(d);
                    }
                });
            } else {
                assessList = outputList;
            }


            if (worryFilterList === 'due') {
                var toShow = assessList.filter(function(d) {
                    var thisworryList = [];
                    d.assessments.forEach(function(e) {

                        var thisDate = new Date(e.assessmentDate);
                        diff = (((((today - thisDate) / 1000) / 60) / 60) / 24);

                        if ((diff &lt; 366) &amp;&amp;
                            (diff &gt; 250)) {
                            thisworryList.push(e);
                        }
                    })

                    if (thisworryList.length &gt; 0) {
                        d['assessments'] = thisworryList;
                        worryList.push(d);
                    }
                });
            } else if (worryFilterList === 'late') {

                var toShow = assessList.filter(function(d) {
                    var thisworryList = [];
                    d.assessments.forEach(function(e) {

                        var thisDate = new Date(e.assessmentDate);
                        diff = (((((today - thisDate) / 1000) / 60) / 60) / 24);

                        if (diff &gt; 365) {
                            thisworryList.push(e);
                        }
                    })

                    if (thisworryList.length &gt; 0) {
                        d['assessments'] = thisworryList;
                        worryList.push(d);
                    }
                });

            } else if (worryFilterList === 'notDone') {
                var thisworryList = [];
                var toShow = assessList.filter(function(d) {

                    if (d.assessments.length === 0) {
                        worryList.push(d);
                    }
                })
            } else {
                worryList = assessList;
            }
         
            $('#controls').empty();
            $('#controls').append(summaryTemplate(worryList));
               doControl() ;
        };

        $('#stdSelect').change(function() {
            let fwork = $('#stdSelect option:selected').attr("id");

            window.open("report?XML=reportXML.xml&amp;XSL=enterprise/core_el_standards.xsl&amp;PMA=" + fwork, "_self")
        })         
    </script>
										
				<script id="summary-template" type="text/x-handlebars-template">
	<div class="row">
        <div class="col-xs-1">
        	<div class="bg-lightgrey impact medPadding" width="100%">ID</div>
        </div>
        <div class="col-xs-3">
        	<div class="bg-lightgrey impact medPadding" width="100%">Control</div>
        </div>
        <div class="col-xs-8">
        	<div class="bg-lightgrey impact medPadding" width="100%">Assessments</div>
        </div>
    </div>       
    {{#each this}}
    <div class="row top-5">
        <div>
            <xsl:attribute name="class">col-xs-1 fil{{controlName}} ctrl {{#each this.assessments}}{{this.assessorID}} {{/each}}</xsl:attribute>
        	<strong>{{controlName}}</strong>
            <div class="top-10">
            	<i>
                	<xsl:attribute name="class">fa fa-{{icon}} fa-2x circle-icon</xsl:attribute>
                	<xsl:attribute name="style">color:{{colour}}</xsl:attribute>
            	</i>
            </div>
        </div>
        <div>
            <xsl:attribute name="class">col-xs-3 fil{{controlName}} ctrl {{#each this.assessments}}{{this.assessorID}} {{/each}}</xsl:attribute><span>{{desc}}</span>
        </div>
        <div>
        	<xsl:attribute name="class">col-xs-8 fil{{controlName}} ctrl {{#if this.assessments}}{{#each this.assessments}}{{this.assessorID}} {{/each}}{{else}}noassess{{/if}} </xsl:attribute>
            <div class="row">
            	<div class="col-xs-3">
            		<span class="xsmall strong">Assessment</span>
            	</div>
            	<div class="col-xs-4">
            		<span class="xsmall strong">Assessed</span>
            	</div>
            	<div class="col-xs-4">
            		<span class="xsmall strong">Comments</span>
            	</div>
            </div>
            {{#each this.assessments}}
            <div class="row">
	            <div>
	                <xsl:attribute name="class">col-xs-3 fil{{controlName}} {{this.assessorID}} a{{status}} assess status </xsl:attribute>
	                <table class="table-condensed">
	                	<tbody>
	                		<tr>
	                			<td><i class="fa fa-calendar" /></td>
	                			<td>
	                				{{#if assessmentDate}}
	                				<span class="label label-primary">
		                        		<xsl:attribute name="style">background-color:{{colour}};color:{{textColour}}</xsl:attribute>{{assessmentDate}}
		                    		</span>
	                				{{/if}}
	                			</td>
	                		</tr>
		                    <tr>
		                    	<td>
		                    		<i class="fa fa-user"/>
		                    	</td>
		                    	<td>
		                    		<span class="label label-primary">{{assessor}}</span>
		                    	</td>
		                    </tr>
		                    <tr>
		                    	<td>
		                    		<i class="fa fa-check-circle-o"/>
		                    	</td>
		                    	<td>
		                    		<span><xsl:attribute name="class">label label-primary {{status}}</xsl:attribute>{{status}}</span>
		                    	</td>
		                    </tr>
	                	</tbody>
	                </table>
	            </div>
            	<div>
					<xsl:attribute name="class">col-xs-4 fil{{controlName}} a{{status}} {{this.assessorID}} assess status</xsl:attribute>
					{{#each assessedElements}}
						<i class="fa fa-caret-right"/> {{{this}}}<br/>
					{{/each}}
            	</div>
            	<div>
            		<xsl:attribute name="class">col-xs-4 fil{{controlName}} a{{status}} {{this.assessorID}} assess status</xsl:attribute>
	            	{{#if comments}}
	            		{{#each comments}}
	                		<i class="fa fa-comment-o right-5"/><em>{{this}}</em><br/>
	            		{{/each}}
	            		{{else}}
	                	<span>-</span>
	            	{{/if}}
        		</div> 
            	<div><xsl:attribute name="class">col-xs-12 {{this.assessorID}} a{{status}} assess</xsl:attribute>
            		{{#unless @last}}<hr class="tight"/>{{/unless}}
            		
            	</div>
            </div>
            {{/each}}
        </div>    
    	<div>
    		<xsl:attribute name="class">col-xs-12  fil{{controlName}} ctrl</xsl:attribute>
    		<hr class="tight"/>
    	</div>
    </div>  
    {{/each}}
</script>

				<script id="analysis-template" type="text/x-handlebars-template">
          {{#each this}}
               {{#each assessedElements}}
                    <i class="fa fa-caret-right"/> {{{this}}} failed the control {{../controlBeingAssessed}}<br/>
               {{/each}}
          {{/each}}
        </script>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!--  <xsl:template mode="controlsList" match="node()">
        <xsl:variable name="this" select="current()"/>  
      
              <div class="col-xs-1"> <xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></div>             
              <div class="col-xs-4"><xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/></div>           
            <div class="col-xs-2"> <xsl:apply-templates select="$assessments[own_slot_value[slot_reference='assessment_control']/value=$this/name]" mode="assessmentDetail"></xsl:apply-templates>    </div>
                <div class="col-xs-5 "><xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_business']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_application']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_technology']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_information']/value" mode="supportingElementsList"></xsl:apply-templates>
            
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='external_reference_links']/value" mode="supportingExternalLinks"></xsl:apply-templates></div>
        
        <div class="clearfix"></div>
                
         
    </xsl:template>-->
	<!-- 
    <xsl:template mode="supportingElementsList" match="node()">
      <xsl:variable name="this" select="current()"/>  
      <xsl:variable name="thisTarget" select="/node()/simple_instance[name=$this]"/>    
         
       <xsl:variable name="thisTargetS" select="string($thisTarget)"/>
        <xsl:choose>
            <xsl:when test="contains($thisTargetS,'Application_Layer')"><i class="fa fa-square" style="color: rgba(252, 0, 213, 0.85)"/></xsl:when>
            <xsl:when test="contains($thisTargetS,'Business_Layer')"><i class="fa fa-square" style="color: rgba(0, 66, 247, 0.85)"/></xsl:when>
            <xsl:when test="contains($thisTargetS,'Technology_Layer')"><i class="fa fa-square" style="color: rgba(255, 157, 0, 0.85)"/></xsl:when>
            <xsl:when test="contains($thisTargetS,'Information_Layer')"><i class="fa fa-square" style="color: rgba(128, 255, 0, 0.85)"/></xsl:when>
         </xsl:choose>
        
    
                <xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisTarget"/>
				</xsl:call-template>
        <br/>
        <xsl:apply-templates select="$externalLinks[own_slot_value[slot_reference='referenced_ea_instance']/value=$this]" mode="externalLinks"/>
        <br/>
    </xsl:template>
      <xsl:template mode="externalLinks" match="node()">
        <xsl:variable name="this" select="current()"/>
           <xsl:variable name="link" select="$this/own_slot_value[slot_reference='external_reference_url']/value"/>
          <i class="fa fa-link"/><a href='{$link}'><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></a>
    </xsl:template>
    
     <xsl:template mode="supportingExternalLinks" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisNode" select="/node()/simple_instance[name=$this]"/>     
        <xsl:variable name="thisTarget" select="$externalLinks[name=$this/own_slot_value[slot_reference='external_reference_links']/value]"/>     
        <xsl:variable name="thisTargetS" select="string($thisTarget)"/>
        <xsl:variable name="thisName" select="$externalLinks[name=$thisNode/own_slot_value[slot_reference='external_reference_links']/value]/own_slot_value[slot_reference='name']/value"/>
         <xsl:apply-templates select="$thisNode" mode="URLs"/>-->
	<!-- <xsl:variable name="thisURL" select="$externalLinks[name=$thisNode/own_slot_value[slot_reference='external_reference_links']/value]/own_slot_value[slot_reference='external_reference_url']/value"/>
          <xsl:value-of select="$thisURL"/>
         <xsl:if test="$thisURL">
            <i class="fa fa-life-ring"/> 
                
            <a href="https://{$thisURL}"><xsl:value-of select="$thisName"/></a>
            <br/>
         </xsl:if>
    -->
	<!--   </xsl:template>
    
    <xsl:template match="node()" mode="URLs">
     <xsl:variable name="thisURL" select="own_slot_value[slot_reference='external_reference_url']/value"/>

     <xsl:if test="$thisURL">
            <i class="fa fa-life-ring"/> 
                
            <a href="https://{substring-after($thisURL,'//')}"><xsl:value-of select="own_slot_value[slot_reference='name']/value"/></a>
            <br/>
         </xsl:if>
    
    </xsl:template>
    -->
	<!--   <xsl:template mode="assessmentDetail" match="node()">
        <xsl:variable name="this" select="current()"/>  
        <xsl:variable name="thisDate" select="$this/own_slot_value[slot_reference='assessment_date']/value"/>
        <xsl:variable name="fullDate" select="/node()/simple_instance[type='Gregorian'][name=$thisDate]"/>
        <xsl:variable name="assessDateM" select="number(/node()/simple_instance[type='Gregorian'][name=$thisDate]/own_slot_value[slot_reference='time_month']/value)"/>
        <xsl:variable name="assessDateY" select="number(/node()/simple_instance[type='Gregorian'][name=$thisDate]/own_slot_value[slot_reference='time_year']/value)"/> 
        <xsl:variable name="assessDateM" select="number(/node()/simple_instance[type='Gregorian'][name=$thisDate]/own_slot_value[slot_reference='time_month']/value)"/> 
     
         <xsl:variable name="dateCalc">
             <xsl:choose><xsl:when test="$fullDate/own_slot_value[slot_reference='time_year']/value='1900'">None</xsl:when>
            <xsl:otherwise><xsl:value-of select="eas:get_date_for_essential_time($fullDate)"/></xsl:otherwise>
             </xsl:choose>
        </xsl:variable>
        <xsl:variable name="daysSinceReview">
            <xsl:choose>
            <xsl:when test="$fullDate/own_slot_value[slot_reference='time_year']/value='1900'">2000</xsl:when>
            <xsl:otherwise><xsl:value-of select="functx:total-days-from-duration(xs:dayTimeDuration((eas:get_date_for_essential_time($fullDate)-eas:get_date_for_essential_time(today))))"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable> 
        
        <xsl:variable name="thisAssessor" select="$this/own_slot_value[slot_reference='control_assessor']/value"/>  
        <xsl:variable name="thisStatus" select="$this/own_slot_value[slot_reference='assessment_finding']/value"/>  
               
        Last Assessment:  <xsl:value-of select="substring-before(substring-after($dateCalc,'-'),'-')"/><xsl:choose><xsl:when test="$dateCalc='None'">None</xsl:when><xsl:otherwise>/</xsl:otherwise></xsl:choose><xsl:value-of select="substring-before($dateCalc,'-')"/>
        <xsl:variable name="passFail" select="/node()/simple_instance[type='Control_Assessment_Finding'][name=$thisStatus]/own_slot_value[slot_reference='name']/value"/>
        
    
        <xsl:choose>
            <xsl:when test="($daysSinceReview * -1) &gt; 720"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="$daysSinceReview = 2000"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="$passFail = 'Fail'"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="(($daysSinceReview * -1) &gt; 360) and (($daysSinceReview * -1) &lt; 721)"><i class="fa fa-exclamation-triangle" style="color: #ffba00"></i> </xsl:when>

            <xsl:otherwise>
            <i class="fa fa-check-circle" style="color: green"></i>    
            </xsl:otherwise>     
        </xsl:choose>
            <xsl:if test="current()/own_slot_value[slot_reference='assessment_comments']/value"><i class="fa fa-info-circle text-black"/>
            <xsl:call-template name="dataScopePopoverContent">
                <xsl:with-param name="currentObject" select="current()"/>
            </xsl:call-template></xsl:if>
    
      
         <br/>
        Assessor:<xsl:value-of select="/node()/simple_instance[type='Individual_Actor'][name=$thisAssessor]/own_slot_value[slot_reference='name']/value"/><br/>
        <xsl:choose>
            <xsl:when test="$passFail='Fail'"><span style="color:red"><b>Status:<xsl:value-of select="$passFail"/></b></span></xsl:when>
            <xsl:otherwise> Status:<xsl:value-of select="$passFail"/></xsl:otherwise>
        </xsl:choose>
       <br/>
        

    </xsl:template>    -->


	<!--  <xsl:template name="dataScopePopoverContent">
	<xsl:param name="currentObject"/>
	<div class="text-default small hiddenDiv">
        <xsl:value-of select="$commentary[name=current()/own_slot_value[slot_reference='assessment_comments']/value]/own_slot_value[slot_reference='name']/value"/>
	</div>
</xsl:template>
-->
	<xsl:template match="node()" mode="getData">
		<xsl:variable name="this" select="current()"/> {"id":"<xsl:value-of select="$this/name"/>", "controlName":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>", "desc":"<xsl:value-of select="$this/own_slot_value[slot_reference = 'description']/value"/>", "assessments":[ <xsl:apply-templates select="$assessments[own_slot_value[slot_reference = 'assessment_control']/value = $this/name]" mode="assessmentJSON"><xsl:with-param name="ctrl" select="$this/own_slot_value[slot_reference = 'name']/value"/></xsl:apply-templates>]}, </xsl:template>
	<xsl:template mode="assessmentJSON" match="node()">
		<xsl:param name="ctrl"/>
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisDate" select="$this/own_slot_value[slot_reference = 'assessment_date']/value"/>
		<xsl:variable name="isoDate" select="$this/own_slot_value[slot_reference = 'assessment_date_iso_8601']/value"/>
		<xsl:variable name="fullDate" select="$dates[name = $thisDate]"/>
		<xsl:variable name="thisAssessor" select="$this/own_slot_value[slot_reference = 'control_assessor']/value"/>
		<xsl:variable name="thisStatus" select="$this/own_slot_value[slot_reference = 'assessment_finding']/value"/>
		<xsl:variable name="passFail" select="$findings[name = $thisStatus]/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="thisComments" select="$commentary[name = current()/own_slot_value[slot_reference = 'assessment_comments']/value]"/>
		<xsl:variable name="thisElements" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'assessment_for_elements']/value]"/> {"assessmentDate":"<xsl:choose><xsl:when test="$isoDate"><xsl:value-of select="$isoDate"/></xsl:when><xsl:otherwise>
				<xsl:choose><xsl:when test="contains($fullDate/own_slot_value[slot_reference = 'name']/value, '1900')"/><xsl:otherwise><xsl:value-of select="$fullDate/own_slot_value[slot_reference = 'name']/value"/></xsl:otherwise></xsl:choose>
			</xsl:otherwise></xsl:choose>","assessor":"<xsl:value-of select="$actors[name = $thisAssessor]/own_slot_value[slot_reference = 'name']/value"/>", "assessorID":"<xsl:value-of select="$actors[name = $thisAssessor]/name"/>","status":"<xsl:value-of select="$passFail"/>","controlBeingAssessed":"<xsl:value-of select="$ctrl"/>","comments":[<xsl:apply-templates select="$thisComments" mode="comments"/>], "assessedElements":[<xsl:apply-templates select="$thisElements" mode="assessedElements"/>]}, </xsl:template>
	<xsl:template mode="comments" match="node()"> "<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/>"<xsl:if test="position != last()">,</xsl:if>
	</xsl:template>

	<xsl:template mode="assessedElements" match="node()"> "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>", </xsl:template>

	<xsl:template mode="options" match="node()">
		<xsl:variable name="this" select="current()"/>
		<option id="{$this/name}">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</option>
	</xsl:template>
</xsl:stylesheet>
