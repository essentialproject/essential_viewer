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
	<!--<xsl:variable name="linkClasses" select="('Business_Capability','Application_Provider','Composite_Application_Provider')"/>-->
	<xsl:variable name="menuClasses" select="/node()/simple_instance[type='Report_Menu']/own_slot_value[slot_reference='report_menu_class']/value"/>
	<xsl:variable name="linkClasses" select="$menuClasses"/>
	<!-- END GENERIC LINK VARIABLES -->

    <xsl:variable name="nodeNIST" select="/node()/simple_instance[type='Security_Policy'][own_slot_value[slot_reference='name']/value='NIST']"/>
    <xsl:variable name="controls" select="/node()/simple_instance[type='Control'][own_slot_value[slot_reference='control_related_policy']/value=$nodeNIST/name]"/>
    <xsl:variable name="assessments" select="/node()/simple_instance[type='Control_Assessment'][own_slot_value[slot_reference='assessment_control']/value=$controls/name]"/>
    <xsl:variable name="externalLinks" select="/node()/simple_instance[type='External_Reference_Link']"/>
     <xsl:variable name="commentary" select="/node()/simple_instance[type='Commentary']"/>
    
     <xsl:variable name="basicQueryString">
		<xsl:call-template name="RenderLinkText">
            <xsl:with-param name="theXSL" select="'user/tree.xsl'"/>
			<xsl:with-param name="theXML">reportXML.xml</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
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
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>NIST Compliance</title>
				<script src="js/d3/d3.min.js?release=6.19"/>
                <style>

                </style> 
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
		<xsl:call-template name="dataTablesLibrary"/>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header"><h1>
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('NIST Cyber Controls Mapping')"/></span>
							</h1></div>
                  
						</div>

						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="sectionIcon">
								<i class="fa fa-lock icon-section icon-color"/>
							</div>
                              <div class="content-section">
                                                            
                                <div class="col-xs-12">
                                    <b><xsl:value-of select="eas:i18n('References Key')"/>:</b> <span style="background-color: rgba(0, 66, 247, 0.05)"><xsl:value-of select="eas:i18n('Process')"/> <xsl:text> </xsl:text><i class="fa fa-square" style="color: rgba(0, 66, 247, 0.85);"/><xsl:text> </xsl:text></span> <xsl:text> </xsl:text>¦<xsl:text> </xsl:text>
                                    <span style="background-color: rgba(252, 0, 213, 0.05)"><xsl:value-of select="eas:i18n('Applications')"/><xsl:text> </xsl:text><i class="fa fa-square" style="color: rgba(252, 0, 213, 0.85)"/><xsl:text> </xsl:text></span> <xsl:text> </xsl:text>¦<xsl:text> </xsl:text>
                                        <span style="background-color: rgba(255, 157, 0, 0.1)"><xsl:value-of select="eas:i18n('Technology')"/><xsl:text> </xsl:text><i class="fa fa-square" style="color: rgba(255, 157, 0, 0.85)"/><xsl:text> </xsl:text></span> <xsl:text> </xsl:text>¦<xsl:text> </xsl:text>
                                        <span style="background-color: rgba(128, 255, 0, 0.2)"><xsl:value-of select="eas:i18n('Information')"/><xsl:text> </xsl:text><i class="fa fa-square" style="color: rgba(128, 255, 0, 0.85)"/></span><xsl:text> </xsl:text> <xsl:text> </xsl:text>¦<xsl:text> </xsl:text>
                                        <span style="background-color: rgba(0, 0, 0, 0.05)"><xsl:value-of select="eas:i18n('Other Documentation')"/><xsl:text> </xsl:text><i class="fa fa-link"/></span><br/>
                                    <b><xsl:value-of select="eas:i18n('Assessment Key:')"/></b><xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Up to Date')"/> <i class="fa fa-check-circle" style="color: green"></i>  
                                        <xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Due')"/> <i class="fa fa-exclamation-triangle" style="color: #ffba00"></i>
                                    <xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Overdue')"/> <i class="fa fa-exclamation-triangle" style="color: red"></i>
                                    <xsl:text> </xsl:text>¦<xsl:text> </xsl:text><xsl:value-of select="eas:i18n('Comments')"/> <i class="fa fa-info-circle text-black"/>
                                    <script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_apps tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="&#xf002; '+title+'" style="font-family: FontAwesome, Source Sans Pro, Arial; font-style: normal" /&gt;' );
								    } );
									
									var table = $('#dt_apps').DataTable({
									paging: false,
									deferRender:    true,
						            scrollY:        350,
						            scrollCollapse: true,
									info: true,
									sort: true,
									responsive: false,
									columns: [
									    { "width": "5%" },
									    { "width": "30%" },
									    { "width": "30%" },
                                        { "width": "35%" }
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
                                    <table id="dt_apps" class="table table-striped table-condensed"> 
                                        <thead>  <th width="5%"><xsl:value-of select="eas:i18n('ID')"/></th> <th width="30%"><xsl:value-of select="eas:i18n('Control')"/></th><th><xsl:value-of select="eas:i18n('Informative References')"/></th><th width="30%"><xsl:value-of select="eas:i18n('Assessment')"/></th>
                                        </thead>
                                        <tbody>   
                                        <xsl:apply-templates select="$controls" mode="controlsList">
                                            <xsl:sort select="own_slot_value[slot_reference='name']/value" order="ascending"/>    
                                        </xsl:apply-templates>
                                        </tbody>
                                        <tfoot>  <th width="5%"><xsl:value-of select="eas:i18n('ID')"/></th> <th width="30%"><xsl:value-of select="eas:i18n('Control')"/></th><th><xsl:value-of select="eas:i18n('Informative References')"/></th><th width="30%"><xsl:value-of select="eas:i18n('Assessment')"/></th>
                                        </tfoot>
                                    </table>
                                        
                                </div>
						

               
						  </div>
						</div>

	
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>
    

    <xsl:template mode="controlsList" match="node()">
        <xsl:variable name="this" select="current()"/>  
        <tr>
            <td>
                <xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/>
            </td>
            <td>
                <xsl:value-of select="$this/own_slot_value[slot_reference='description']/value"/>
            </td>
            <td>
             
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_business']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_application']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_technology']/value" mode="supportingElementsList"></xsl:apply-templates>
                
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='control_supported_by_information']/value" mode="supportingElementsList"></xsl:apply-templates>
            
                <xsl:apply-templates select="$this/own_slot_value[slot_reference='external_reference_links']/value" mode="supportingExternalLinks"></xsl:apply-templates>
            </td>
            <td>
                 <xsl:apply-templates select="$assessments[own_slot_value[slot_reference='assessment_control']/value=$this/name]" mode="assessmentDetail"></xsl:apply-templates>    
            </td>
        </tr>
    </xsl:template>
    
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
        <xsl:text> </xsl:text>
    
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
          <i class="fa fa-link"/><xsl:text> </xsl:text><a href='{$link}'><xsl:value-of select="$this/own_slot_value[slot_reference='name']/value"/></a>
    </xsl:template>
    
     <xsl:template mode="supportingExternalLinks" match="node()">
        <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisNode" select="/node()/simple_instance[name=$this]"/>     
        <xsl:variable name="thisTarget" select="$externalLinks[name=$this/own_slot_value[slot_reference='external_reference_links']/value]"/>     
        <xsl:variable name="thisTargetS" select="string($thisTarget)"/>
        <xsl:variable name="thisName" select="$externalLinks[name=$thisNode/own_slot_value[slot_reference='external_reference_links']/value]/own_slot_value[slot_reference='name']/value"/>
         <xsl:apply-templates select="$thisNode" mode="URLs"/>
       <!-- <xsl:variable name="thisURL" select="$externalLinks[name=$thisNode/own_slot_value[slot_reference='external_reference_links']/value]/own_slot_value[slot_reference='external_reference_url']/value"/>
          <xsl:value-of select="$thisURL"/>
         <xsl:if test="$thisURL">
            <i class="fa fa-life-ring"/> 
                <xsl:text> </xsl:text>
            <a href="https://{$thisURL}"><xsl:value-of select="$thisName"/></a>
            <br/>
         </xsl:if>
    -->
    </xsl:template>
    
    <xsl:template match="node()" mode="URLs">
     <xsl:variable name="thisURL" select="own_slot_value[slot_reference='external_reference_url']/value"/>

     <xsl:if test="$thisURL">
            <i class="fa fa-life-ring"/> 
                <xsl:text> </xsl:text>
            <a href="https://{substring-after($thisURL,'//')}"><xsl:value-of select="own_slot_value[slot_reference='name']/value"/></a>
            <br/>
         </xsl:if>
    
    </xsl:template>
    
    <xsl:template mode="assessmentDetail" match="node()">
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
               
        Last Assessment:<xsl:text> </xsl:text>  <xsl:value-of select="substring-before(substring-after($dateCalc,'-'),'-')"/><xsl:choose><xsl:when test="$dateCalc='None'">None</xsl:when><xsl:otherwise>/</xsl:otherwise></xsl:choose><xsl:value-of select="substring-before($dateCalc,'-')"/>
        <xsl:variable name="passFail" select="/node()/simple_instance[type='Control_Assessment_Finding'][name=$thisStatus]/own_slot_value[slot_reference='name']/value"/>
        <xsl:text> </xsl:text>
    
        <xsl:choose>
            <xsl:when test="($daysSinceReview * -1) &gt; 720"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="$daysSinceReview = 2000"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="$passFail = 'Fail'"><i class="fa fa-exclamation-triangle" style="color: red"></i></xsl:when>
            <xsl:when test="(($daysSinceReview * -1) &gt; 360) and (($daysSinceReview * -1) &lt; 721)"><i class="fa fa-exclamation-triangle" style="color: #ffba00"></i> </xsl:when>

            <xsl:otherwise>
            <i class="fa fa-check-circle" style="color: green"></i>    
            </xsl:otherwise>     
        </xsl:choose>
            <xsl:text> </xsl:text><xsl:if test="current()/own_slot_value[slot_reference='assessment_comments']/value"><i class="fa fa-info-circle text-black"/>
            <xsl:call-template name="dataScopePopoverContent">
                <xsl:with-param name="currentObject" select="current()"/>
            </xsl:call-template></xsl:if>
    
      
         <br/>
        Assessor:<xsl:text> </xsl:text><xsl:value-of select="/node()/simple_instance[type='Individual_Actor'][name=$thisAssessor]/own_slot_value[slot_reference='name']/value"/><br/>
        <xsl:choose>
            <xsl:when test="$passFail='Fail'"><span style="color:red"><b>Status:<xsl:text> </xsl:text><xsl:value-of select="$passFail"/></b></span></xsl:when>
            <xsl:otherwise> Status:<xsl:text> </xsl:text><xsl:value-of select="$passFail"/></xsl:otherwise>
        </xsl:choose>
       <br/>
        

    </xsl:template>    

    
    <xsl:template name="dataScopePopoverContent">
	<xsl:param name="currentObject"/>
	<div class="text-default small hiddenDiv">
        <xsl:value-of select="$commentary[name=current()/own_slot_value[slot_reference='assessment_comments']/value]/own_slot_value[slot_reference='name']/value"/>
	</div>
</xsl:template>

     
</xsl:stylesheet>
