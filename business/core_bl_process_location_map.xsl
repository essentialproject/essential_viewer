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
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->
 
  <xsl:variable name="allPhysProcessesCount" select="/node()/simple_instance[type='Physical_Process']"/> 
 
  
    <xsl:variable name="allBusProcesses" select="/node()/simple_instance[type='Business_Process'][own_slot_value[slot_reference = 'implemented_by_physical_business_processes']/value=$allPhysProcessesCount/name]"/>

    <xsl:variable name="processFamily" select="/node()/simple_instance[(type = 'Business_Process_Family')][own_slot_value[slot_reference = 'bpf_contained_business_process_types']/value=$allBusProcesses/name]"/>
    <xsl:variable name="processFamilytoBusProc" select="$allBusProcesses[name=$processFamily/own_slot_value[slot_reference = 'bpf_contained_business_process_types']/value]"/>
    <xsl:variable name="allSites" select="/node()/simple_instance[type='Site']"/>

    <xsl:key name="allPhysProcessestoBPKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'implements_business_process']/value"/>
    <xsl:variable name="allPhysProcessestobp" select="key('allPhysProcessestoBPKey',$allBusProcesses/name)"/>
    <xsl:key name="allPhysProcessesKey" match="/node()/simple_instance[type='Physical_Process']" use="own_slot_value[slot_reference = 'process_performed_at_sites']/value"/>
    <xsl:variable name="allPhysProcesses" select="key('allPhysProcessesKey',$allSites/name)"/>
    <xsl:variable name="allProcessSites" select="$allSites[name=$allPhysProcessesCount/own_slot_value[slot_reference = 'process_performed_at_sites']/value]"/>

    <xsl:key name="sitesKey" match="$allSites" use="own_slot_value[slot_reference = 'site_geographic_location']/value"/>
  
    <xsl:key name="costsKey" match="/node()/simple_instance[type='Cost']" use="own_slot_value[slot_reference = 'cost_for_elements']/value"/>
    <xsl:variable name="inScopeCosts" select="key('costsKey',$allPhysProcesses/name)"/>
    <xsl:variable name="inScopeCosts2" select="/node()/simple_instance[own_slot_value[slot_reference = 'cost_for_elements']/value = $allPhysProcesses/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostTypes" select="/node()/simple_instance[name = $inScopeCostComponents/own_slot_value[slot_reference = 'cc_cost_component_type']/value]"/>
    <xsl:variable name="defaultCurrencyConstant" select="eas:get_instance_by_name(/node()/simple_instance, 'Report_Constant', 'Default Currency')"/>
	<xsl:variable name="defaultCurrency" select="eas:get_instance_slot_values(/node()/simple_instance, $defaultCurrencyConstant, 'report_constant_ea_elements')"/>
	<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
    <xsl:variable name="allGeosRegions" select="/node()/simple_instance[type='Geographic_Region']"/>
    <xsl:variable name="allCtrySites" select="/node()/simple_instance[type='Site']"/>
    <xsl:variable name="geoLocation" select="/node()/simple_instance[type='Geographic_Location']"/> 
    <xsl:variable name="allGeo" select="$allGeosRegions union $geoLocation"/> 
    <xsl:variable name="geoCode" select="/node()/simple_instance[type='GeoCode'][name=$geoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
    <xsl:variable name="ctrySites" select="key('sitesKey',$allGeosRegions/name)"/>
     <xsl:variable name="theLocationSummaryReport" select="eas:get_report_by_name('Core: Location Summary')"/>

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
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Process Dashboard</title>
                    <link href="js/jvectormap/jquery-jvectormap-2.0.3.css" media="screen" rel="stylesheet" type="text/css"/>
                    <script src="js/jvectormap/jquery-jvectormap-2.0.3.min.js" type="text/javascript"/>
                    <script src="js/jvectormap/jquery-jvectormap-world-mill.js" type="text/javascript"/>
              <!--  <script src="user/jquery-jvectormap-dk-mill.js" type="text/javascript"/>-->
                    <style>
    				.tile-stats{
						transition: all 300ms ease-in-out;
                        
                        border-radius: 10px 10px 10px 10px;
                        border: 1pt solid #d3d3d3;
					}
					
					.tile-stats .icon{
						width: 60px;
						height: 60px;
						color: #BAB8B8;
						position: absolute;
						right: 30px;
						top: 10px;
						z-index: 1;
						opacity: 0.75;
					}
					
					.tile-stats .icon i{
						font-size: 60px;
					}
					
					.tile-stats .count{
						font-size: 38px;
						font-weight: bold;
						line-height: 1.65857
					}
					
					.tile-stats .count,
					.tile-stats h3,
					.tile-stats p{
						position: relative;
						margin: 0;
						margin-left: 10px;
						z-index: 5;
						padding: 0
					}
					
					.tile-stats h3{
						color: #BAB8B8
					}
					
					.tile-stats p{
						margin-top: 5px;
						font-size: 12px
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
									<span class="text-darkgrey">Process Dashboard</span>
								</h1>
							</div>
            </div>
           
						<!--Setup Description Section-->
						<div class="col-xs-12">
							<div class="content-section">
                                <div class="col-xs-6" style="padding-top:50px">
                                    <div class="col-xs-6">
                                        <div class="tile-stats">
                                            <div class="icon">
                                                <i class="fa fa-dot-circle-o"/>
                                            </div>
                                            <div class="count"><xsl:value-of select="count($allBusProcesses)"/></div>
                                            <h3>
                                                Business Processes
                                            </h3>
                                            <p>Overall number of active business processes across the organisation<br/><br/></p>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <div class="tile-stats">
                                                <div class="icon">
                                                    <i class="fa fa-pie-chart"/>
                                                </div>
                                                <div class="count"><xsl:value-of select="count($allPhysProcessestobp)"/></div>
                                                <h3>
                                                 Process Implementations
                                                </h3>
                                            <p>Number of implementations of business processes across the organisation<br/><br/></p>
                                        </div>
                                    </div>
                                    <div class="col-xs-12"><hr/></div>
                                    
                                    <div class="col-xs-6">
                                        <div class="tile-stats">
                                                <div class="icon">
                                                    <i class="fa fa-money"/>
                                                </div>
                                                <div class="count"><xsl:value-of select="$defaultCurrencySymbol"/><xsl:value-of select="format-number(sum($inScopeCostComponents/own_slot_value[slot_reference='cc_cost_amount']/value), '##,###,###')"/></div>
                                            
                                                <h3>
                                                    Total Process Cost
                                                </h3>
                                            <p>Total cost of all Processes across the organisation<br/><br/><br/></p>
                                        </div>
                                    </div>    
                                  
                                    <div class="col-xs-6">
                                        <div class="tile-stats">
                                            <div class="icon">
                                                <i class="fa fa-globe"/>
                                            </div>
                                            <div class="count"><xsl:value-of select="count($allProcessSites)"/></div>
                                            <h3>
                                                Locations
                                            </h3>
                                            <p>Number of locations in the organisation managing or performing processes<br/><br/></p>
                                        </div>
                                    </div>
                                    
                                </div>
                                <div class="col-xs-6">
                                    <h3>Locations</h3>
  <div id="world-map" style="width: 100%; height: 400px"></div>
                                    Click location to see associated processes
                                    
  <script>
<!-- order here has to map the markers order -->     
  processValue=[ <xsl:apply-templates select="$allSites" mode="processCount"></xsl:apply-templates> ];
    $(function(){
    $('#world-map').vectorMap({
    map: 'world_mill',
    series: {
        regions: [{
          values: {<xsl:apply-templates select="$ctrySites" mode="getCountries"/>},
          scale: ['#C8EEFF', '#0071A4'],
          normalizeFunction: 'polynomial'
        }]
      },
    normalizeFunction: 'polynomial',
    hoverOpacity: 0.7,
    hoverColor: false,
    markerStyle: {
      initial: {
        fill: '#537dc1',
        stroke: '#d3d3d3'
      }
    },markerLabelStyle: {
    initial: {
        // Add CSS properties here
        fill: 'black',
        'font-size':'8'
            }
        },
      color: '#f09d9d',
    backgroundColor: '#dddde2',
    markers: [ <xsl:apply-templates select="$allSites" mode="getMarkers"/> ],
       labels: {
        markers: {
          render: function(index){
            return processValue[index].name;
          }
      }},
      onMarkerClick: function(event, index) {
                      // alter the weburl
                      location.href=processValue[index].weburl;
                  },
      
      onMarkerTipShow: function(event, label, index){
        label.html(
          '<b># Processes:'+processValue[index].processes+'</b><br/>'
        );
        }
      });
    });

   
  </script>

                                </div>                     
                                
							</div>
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
 <xsl:template match="node()" mode="getMarkers">
      <xsl:variable name="this" select="current()"/>
       <xsl:variable name="thisgeoLocation" select="$geoLocation[name=$this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
      <xsl:variable name="thisgeoCode" select="$geoCode[name=$thisgeoLocation/own_slot_value[slot_reference = 'gl_geocode']/value]"/>
     <xsl:variable name="lat" select="$thisgeoCode/own_slot_value[slot_reference='geocode_latitude']/value"/>
     <xsl:variable name="long" select="$thisgeoCode/own_slot_value[slot_reference='geocode_longitude']/value"/>
     <xsl:if test="$lat"> {latLng: [<xsl:value-of select="$lat"/>,<xsl:value-of select="$long"/>], name: '<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference='name']/value"/>', style: {fill: '#faa053'}, id:'<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference='gl_identifier']/value"/>'},</xsl:if>
</xsl:template>     

<xsl:template match="node()" mode="getCountries">
        <xsl:variable name="this" select="current()"/>
         <xsl:variable name="thisgeoLocation" select="$allGeosRegions[name=$this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
           "<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference='gr_region_identifier']/value"/>":1<xsl:if test="position()!=last()">,</xsl:if>
  </xsl:template>  
   <xsl:template match="node()" mode="processCount">
      <xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisgeoLocation" select="$geoLocation[name=$this/own_slot_value[slot_reference = 'site_geographic_location']/value]"/>
       <xsl:variable name="processAtSite" select="key('allPhysProcessesKey',$this/name)"/>
     <xsl:if test="$thisgeoLocation"> {"name":"<xsl:value-of select="$thisgeoLocation/own_slot_value[slot_reference='name']/value"/>","processes":<xsl:value-of select="count($processAtSite)"/>, "weburl": "<xsl:call-template name="RenderLinkText">
                    <xsl:with-param name="theInstanceID"><xsl:value-of select="$thisgeoLocation/name"/></xsl:with-param>
                    <xsl:with-param name="theXSL" select="$theLocationSummaryReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>                         
                </xsl:call-template>"<!--'report?XML=reportXML.xml&amp;XSL=user/location_summary.xsl&amp;PMA='<xsl:value-of select="$thisgeoLocation/name"/>--> },</xsl:if>
</xsl:template>       
    
</xsl:stylesheet>
