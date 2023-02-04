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


	<xsl:variable name="trendAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Strategic Trends and Implications API']"/>
	<xsl:variable name="trendAPIReportURL">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL" select="$trendAPIReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="dependencyAPIReport" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core: Strategic Trend Dependencies API']"/>
	<xsl:variable name="dependencyAPIReportURL">
		<xsl:call-template name="RenderLinkText">
			<xsl:with-param name="theXSL" select="$dependencyAPIReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
		</xsl:call-template>
	</xsl:variable>

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
				<script type="text/javascript" src="common/js/core_common_api_functions.js"/>
				<script type="text/javascript" src="js/d3/d3_4-11/d3.min.js"/>
				<script type="text/javascript" src="enterprise/js/ess_strategic_trend_radar.js"></script>
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
					<xsl:value-of select="eas:i18n('Strategic Trends and Implications Dashboard')"/>
				</title>
				<style>
					/*Spinner Starts*/
					#view-spinner {
						height: 100vh;
						width: 100vw;
						position: fixed;
						top: 0;
						left:0;
						z-index:999999;
						background-color: hsla(255,100%,100%,0.5);
					}
					
					#view-spinner-text {
						width: 100vw;
						position: fixed;
						top: 20%;
						left: 0;
						z-index:999999;
					}
					      
					.hm-spinner{
					  height: 115px;
					  width: 115px;
					  border: 6px solid transparent;
					  border-top-color: #000;
					  border-bottom-color: #000;
					  border-radius: 50%;
					  position: relative;
					  -webkit-animation: spin 3s linear infinite;
					  animation: spin 3s linear infinite;
					  top: 25%;
					  left: calc(50% - 58px);
					}
					
					.hm-spinner::before{
					  content: "";
					  position: absolute;
					  top: 20px;
					  right: 20px;
					  bottom: 20px;
					  left: 20px;
					  border: 6px solid transparent;
					  border-top-color: #000;
					  border-bottom-color: #000;
					  border-radius: 50%;
					  -webkit-animation: spin 1.5s linear infinite;
					  animation: spin 1.5s linear infinite;
					}
					
					@-webkit-keyframes spin {
					    from {
					      -webkit-transform: rotate(0deg);
					      transform: rotate(0deg);
					    }
					    to {
					      -webkit-transform: rotate(360deg);
					      transform: rotate(360deg);
					    }
					}
					
					@keyframes spin {
					    from {
					      -webkit-transform: rotate(0deg);
					      transform: rotate(0deg);
					    }
					    to {
					      -webkit-transform: rotate(360deg);
					      transform: rotate(360deg);
					    }
					}					
					/*Spinner Ends*/
					
					
					html {
					  scroll-behavior: smooth;
					}
							
					li {
					  margin: 25px 50px 0 0;
					}
					
					table {
					  width: 1400px;
					  margin: 0 50px 0 50px;
					}
					
					td {
					  width: 50%;
					  vertical-align: top;
					  padding-right: 60px;
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
					}
					
					div.radarTooltip {
					  position: absolute;
					  padding: 8px;
					  text-align: left;
					  font: 12px Helvetica, Arial, sans-serif !important;
					  background: rgba(0, 0, 0, .87);
					  color: #fff;
					  border: 0px;
					  width: 200px;
					  border-radius: 8px;
					  pointer-events: none;
					  user-select: none;
					}
					
					div.radarTooltip hr {
					  padding: 0;
					  margin: 8px 0;
					}
				</style>
			</head>
			<body>
			

				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<div id="view-spinner" class="hidden">			
					<div class="hm-spinner"/>
					<div id="view-spinner-text" class="text-center xlarge strong"/>
				</div>

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

						
						<div class="col-xs-12">
							<svg id="radar"></svg>
						</div>
						
						<div id="strat-trend-header" class="col-xs-12">
							<div id="trend-summary-panel" class="dashboardPanel bg-offwhite">
								<div class="row">
									<div class="col-xs-9">
										<h3 class="text-secondary">Internet of Things</h3>
									</div>
									<div class="col-xs-3">
										<h3 class="text-secondary">From Year: <span class="text-primary">2019</span></h3>
									</div>
									<div class="col-xs-12">
										<p>The increasing use of technology on assets, e.g. sensors, cameras, etc</p>
									</div>
								</div>
								<div class="row">
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
											<p>The increasing use of technology on assets, e.g. sensors, cameras, etc</p>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
									<div class="col-xs-4">
										<div class="bus-env-icon">
											<xsl:attribute name="eas-id">123</xsl:attribute>
											<i><xsl:attribute name="class">fa fa-truck right-5</xsl:attribute></i><span>An Implication</span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
 				<script type="text/javascript">
          var currentTrend, trendSummaryTemplate;
          
          var trendJSON = {}         
          var dependencyJSON = {}
          
          
          /**************************
          START STRATEGIC TREND RADAR
          ***************************/
          var stratTrendNodes = [];
          
          /* var stratTrendNodes = [
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "AWS EMR",
		        active: false,
		        link: "../data_processing/aws_emr.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Spark",
		        active: false,
		        link: "../data_processing/spark.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "Airflow",
		        active: false,
		        link: "../data_processing/airflow.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "AWS Data Pipeline",
		        active: false,
		        link: "../data_processing/aws_data_pipeline.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "Flink",
		        active: false,
		        link: "../data_processing/flink.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "Google BigQuery",
		        active: false,
		        link: "../data_processing/google_bigquery.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "Presto",
		        active: false,
		        link: "../data_processing/presto.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "Hadoop",
		        active: false,
		        link: "../data_processing/hadoop.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "YARN",
		        active: false,
		        link: "../data_processing/yarn.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "Esper",
		        active: false,
		        link: "../data_processing/esper.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "AWS S3",
		        active: false,
		        link: "../datastores/aws_s3.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Cassandra",
		        active: false,
		        link: "../datastores/cassandra.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Elasticsearch",
		        active: false,
		        link: "../datastores/elasticsearch.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "etcd",
		        active: false,
		        link: "../datastores/etcd.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "PostgreSQL",
		        active: false,
		        link: "../datastores/postgresql.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Redis",
		        active: false,
		        link: "../datastores/redis.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Solr",
		        active: false,
		        link: "../datastores/solr.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "AWS DynamoDB",
		        active: false,
		        link: "../datastores/aws_dynamodb.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "HDFS",
		        active: false,
		        link: "../datastores/hdfs.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "KairosDB",
		        active: false,
		        link: "../datastores/kairos.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "Consul",
		        active: false,
		        link: "../datastores/consul.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "Google Bigtable",
		        active: false,
		        link: "../datastores/google_bigtable.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "RocksDB",
		        active: false,
		        link: "../datastores/rocksdb.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "Aerospike",
		        active: false,
		        link: "../datastores/aerospike.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "CouchBase",
		        active: false,
		        link: "../datastores/couchbase.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "HBase",
		        active: false,
		        link: "../datastores/hbase.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "Memcached",
		        active: false,
		        link: "../datastores/memcached.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "MongoDB",
		        active: false,
		        link: "../datastores/mongodb.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "MySQL",
		        active: false,
		        link: "../datastores/mysql.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "Oracle DB",
		        active: false,
		        link: "../datastores/oracle_db.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "ZooKeeper",
		        active: false,
		        link: "../datastores/zookeeper.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "Akka (Scala)",
		        active: false,
		        link: "../frameworks/akka_scala.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "Node.js",
		        active: false,
		        link: "../frameworks/nodejs.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "Play (Scala)",
		        active: false,
		        link: "../frameworks/play_scala.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "ReactJS",
		        active: false,
		        link: "../frameworks/reactjs.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "RxJava (Android)",
		        active: false,
		        link: "../frameworks/rxjava_android.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "scikit-learn",
		        active: false,
		        link: "../frameworks/scikit_learn.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 0,
		        label: "Spring",
		        active: false,
		        link: "../frameworks/spring.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "Akka-Http",
		        active: false,
		        link: "../frameworks/akka_http.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "Angular",
		        active: false,
		        link: "../frameworks/angular.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "AspectJ",
		        active: false,
		        link: "../frameworks/aspectj.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "Camel",
		        active: false,
		        link: "../frameworks/camel.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "Camunda",
		        active: false,
		        link: "../frameworks/camunda.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "OpenNLP",
		        active: false,
		        link: "../frameworks/opennlp.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "TensorFlow",
		        active: false,
		        link: "../frameworks/tensorflow.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 1,
		        label: "Thymeleaf",
		        active: false,
		        link: "../frameworks/thymeleaf.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Aurelia",
		        active: false,
		        link: "../frameworks/aurelia.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Ember.js",
		        active: false,
		        link: "../frameworks/emberjs.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "gRPC",
		        active: false,
		        link: "../frameworks/grpc.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Http4s",
		        active: false,
		        link: "../frameworks/http4s.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "jOOQ",
		        active: false,
		        link: "../frameworks/jooq.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Redux",
		        active: false,
		        link: "../frameworks/redux.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Vert.x",
		        active: false,
		        link: "../frameworks/vertx.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 2,
		        label: "Vue.js",
		        active: false,
		        link: "../frameworks/vuejs.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 3,
		        label: "Activiti",
		        active: false,
		        link: "../frameworks/activiti.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 3,
		        label: "AngularJS 1.x",
		        active: false,
		        link: "../frameworks/angularjs_1x.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 3,
		        label: "BackboneJS",
		        active: false,
		        link: "../frameworks/backbonejs.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 3,
		        label: "Drools",
		        active: false,
		        link: "../frameworks/drools.html",
		        moved: 0
		      },
		      {
		        quadrant: 2,
		        ring: 3,
		        label: "Spray",
		        active: false,
		        link: "../frameworks/spray.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "Docker",
		        active: false,
		        link: "../infrastructure/docker.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "Hystrix",
		        active: false,
		        link: "../infrastructure/hystrix.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "Kubernetes",
		        active: false,
		        link: "../infrastructure/kubernetes.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "Nginx",
		        active: false,
		        link: "../infrastructure/nginx.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "OpenTracing",
		        active: false,
		        link: "../infrastructure/opentracing.html",
		        moved: 1
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "Tomcat",
		        active: false,
		        link: "../infrastructure/tomcat.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 0,
		        label: "ZMON",
		        active: false,
		        link: "../infrastructure/zmon.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 1,
		        label: "Failsafe",
		        active: false,
		        link: "../infrastructure/failsafe.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 1,
		        label: "Undertow",
		        active: false,
		        link: "../infrastructure/undertow.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 2,
		        label: "AWS Lambda",
		        active: false,
		        link: "../infrastructure/aws_lambda.html",
		        moved: 0
		      },
		      {
		        quadrant: 1,
		        ring: 3,
		        label: "STUPS",
		        active: false,
		        link: "../infrastructure/stups.html",
		        moved: -1
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "Go",
		        active: true,
		        link: "go.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "Java",
		        active: true,
		        link: "java.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "JavaScript",
		        active: true,
		        link: "javascript.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "OpenAPI (Swagger)",
		        active: true,
		        link: "openapi_swagger.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "Python",
		        active: true,
		        link: "python.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "Scala",
		        active: true,
		        link: "scala.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 0,
		        label: "Swift",
		        active: true,
		        link: "swift.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 1,
		        label: "Clojure",
		        active: true,
		        link: "clojure.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 1,
		        label: "GraphQL",
		        active: true,
		        link: "graphql.html",
		        moved: 1
		      },
		      {
		        quadrant: 0,
		        ring: 1,
		        label: "Haskell",
		        active: true,
		        link: "haskell.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 1,
		        label: "Kotlin",
		        active: true,
		        link: "kotlin.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 1,
		        label: "TypeScript",
		        active: true,
		        link: "typescript.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 2,
		        label: "Elm",
		        active: true,
		        link: "elm.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 2,
		        label: "R",
		        active: true,
		        link: "r.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 2,
		        label: "Rust",
		        active: true,
		        link: "rust.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "C languages",
		        active: true,
		        link: "c_languages.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "CoffeeScript",
		        active: true,
		        link: "coffeescript.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "Erlang",
		        active: true,
		        link: "erlang.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "Groovy",
		        active: true,
		        link: "groovy.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: ".NET languages",
		        active: true,
		        link: "net_languages.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "Perl",
		        active: true,
		        link: "perl.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "PHP",
		        active: true,
		        link: "php.html",
		        moved: 0
		      },
		      {
		        quadrant: 0,
		        ring: 3,
		        label: "Ruby",
		        active: true,
		        link: "ruby.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "AWS SNS",
		        active: false,
		        link: "../queues/aws_sns.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "AWS SQS",
		        active: false,
		        link: "../queues/aws_sqs.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Kafka",
		        active: false,
		        link: "../queues/kafka.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 0,
		        label: "Nakadi",
		        active: false,
		        link: "../queues/nakadi.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 1,
		        label: "RabbitMQ",
		        active: false,
		        link: "../queues/rabbitmq.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 2,
		        label: "AWS Kinesis",
		        active: false,
		        link: "../queues/aws_kinesis.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "ActiveMQ",
		        active: false,
		        link: "../queues/activemq.html",
		        moved: 0
		      },
		      {
		        quadrant: 3,
		        ring: 3,
		        label: "HornetQ",
		        active: false,
		        link: "../queues/hornetq.html",
		        moved: 0
		      },
		  ]; */
		  
		  var maxYears = 4;
		  var trendYears = [];
		  var trendRings = [];
		  
		  function getTrendYears() {
		  	let currentYearDate = moment();
		  	for(var i=0; i&lt; 4; ++i) {
		  		currentYearDate.add(1, 'years');
		  		let thisYear = currentYearDate.format('YYYY');
		  		trendYears.push(thisYear);
		  	}		  	
		  }
		  
		  
		  //function to format the strategic data for the radar
		  function formatTrendRadarData() {
		  
		  	let ringColours = ["#93c47d", "#93d2c2", "#fbdb84", "#efafa9"];
		  	
		  	trendYears.forEach(function(aYear, index) {
		  		let ringName = aYear;
		  		if(index == (trendYears.length - 1)) {
		  			ringName = ringName + '+';
		  		}
		  		let ringData = {
		  			"name": ringName,
		  			"color": ringColours[index],
		  			"index": index 
		  		}
		  		trendRings.push(ringData);
		  	});
		  
		  	if(trendJSON.strategicTrends != null) {
		  		stratTrendNodes = [];
		  		trendJSON.strategicTrends.forEach(function(aTrend, index) {
		  			let thisQuad = index % 4;
		  			let thisYear = aTrend.earliestImpactDate;
					if(thisYear == null) {
						thisYear = moment().add(5, 'years').format('YYYY');
					} else if(thisYear.length == 10) {
						thisYear = moment(thisYear).format('YYYY');
					}
					
					
					
					let trendYear = parseInt(thisYear);
					let thisRing = trendRings.find(function(aRing) {
						let ringYear = parseInt(aRing.name.substring(0, 4));		
						if(trendYear == ringYear) {
							//return the current ring if it is the same year as the trend
							return true;
						} else if((aRing.index == 0) &amp;&amp; (trendYear &lt;= ringYear)) {
							//return the current ring if it is the first and it is greater than the year of the trend
							return true;
						} else if((aRing.index == (trendRings.length - 1)) &amp;&amp; (trendYear >= ringYear)) {
							//return the current ring if it is the last and it is less than the year of the trend
							return true;
						} else {
							//otherwise reject the ring
							return false;
						}
						
						//return ringDate.startsWith(thisYear.format('YYYY'));
					});
					
					if(thisRing == undefined) {
						thisRing = trendRings[trendRings.length - 1];
					}
					
					let thisTrendCatScore = 0;
					aTrend.implications.forEach(function(anImpl) {
						let implCatScore = anImpl.categoryScore;
						
						if(implCatScore != null) {
							thisTrendCatScore = thisTrendCatScore + implCatScore;
						}
					});

					if(thisTrendCatScore > 0) {
					 	aTrend['categoryScore'] = 1;
					} else if(thisTrendCatScore &lt; 0) {
						aTrend['categoryScore'] = -1;
					} else {
						aTrend['categoryScore'] = 0;
					}
					
					
		  			
		  			let newTrendNode = {
				        quadrant: thisQuad,
				        ring: thisRing.index,
				        label: aTrend.name,
				        active: false,
				        link: "",
				        moved: aTrend['categoryScore']
				    }
				    
				    stratTrendNodes.push(newTrendNode);
		  		});		  		
		  	}
		  }
			
		  //function to display the strategic trend radar
		  function drawStrategicTrendRadar() {
		  	
		  	//console.log(trendRings);
		  
		  	radar_visualization({
			  svg_id: "radar",
			  width: 1450,
			  height: 850,
			  colors: {
			    background: "#fff",
			    grid: "#bbb",
			    inactive: "#ddd"
			  },
			  title: "Strategic Trends Radar",
			  quadrants: [
			    { name: "Quadrant 1" },
			    { name: "Quadrant 2" },
			    { name: "Quadrant 3" },
			    { name: "Quadrant 4" }
			  ],
			  rings: trendRings,
			  clickTargetId: "strat-trend-header",
			  print_layout: true,
			  // zoomed_quadrant: 0,
			  //ENTRIES
			  entries: stratTrendNodes
			  //ENTRIES
			});
		  }
		  
		  
          /**************************
          END STRATEGIC TREND RADAR
          ***************************/
          
          /*******************************
          START DATA SETUP FUNCTIONS
          ********************************/
          //function to set up the dashboard data
          function setupDashboardData() {
          	setupStratImplData();
          	setupBusEnvCategoriesData();
          	setupBusEnvFatorsData();
          	setupProductConceptsData();
          	setupProductTypesData();
          	setupInternalProductsData();
          	setupExternalProductsData();
          	setupExternalRolesData();
          	setupExternalOrgsData();
          	setupStrategicGoalsData();
          	setupStrategicObjsData();
          	setupRoadmapsData();
          	setupStrategicPlansData();
          	/***
          	setupBusServiceQualsData();
          	setupCostTypesData();
          	setupRevenueTypesData();
          	***/
          	setupValueStreamsData();
          	setupBusCapsData();
          	setupAppCapsData();
          	setupTechCapsData();
          }
          
          
          //set up strategic implications data
          function setupStratImplData() {
          	let stratTrends = trendJSON.strategicTrends;
          	if(stratTrends != null) {
          		stratTrends.forEach(function(aTrend) {
          			aTrend.implications.forEach(function(anImpl) {
          				if(anImpl.categoryId != null) {
          					anImpl.category = trendJSON.implCategories.find(function(aCat) {
	          					return aCat.id == anImpl.categoryId;
	          				});
          				}
          				        				
          				anImpl.busEnvFactorImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.busEnvFactors.find(function(aBEF) {
	          					return aBEF.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.costTypeImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.costTypes.find(function(aCT) {
	          					return aCT.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.revTypeImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.revenueTypes.find(function(aRT) {
	          					return aRT.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.svcQualityImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.busServiceQualities.find(function(aSQ) {
	          					return aSQ.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.productConceptImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.productConcepts.find(function(aPC) {
	          					return aPC.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.externalRoleImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.externalRoles.find(function(aRole) {
	          					return aRole.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.busCapImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.busCaps.find(function(aBC) {
	          					return aBC.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.appCapImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.appCaps.find(function(anAC) {
	          					return anAC.id == anImpact.id;
	          				});
          				});
          				
          				anImpl.techCapImpacts.forEach(function(anImpact) {
          					anImpact.element = dependencyJSON.techCaps.find(function(aTC) {
	          					return aTC.id == anImpact.id;
	          				});
          				});
				
          			});
          		
          			
          		});
          	}
          }
          
          
          //set up business environment category data
          function setupBusEnvCategoriesData() {
          		let busEnvCats = dependencyJSON.busEnvCategories;
          		if(busEnvCats != null) {
          			busEnvCats.forEach(function(aBEC) {
          				let busEnvFactors = aBEC.busEnvFactorIds.map(function(aBEFId) {
          					return dependencyJSON.busEnvFactors.find(function(aBEF) {
          						return aBEF.id == aBEFId;
          					});
          				});
          				aBEC['busEnvFactors'] = busEnvFactors;
          			});
          		}
          }
          
          
          //set up business environment factor data
          function setupBusEnvFatorsData() {
          		let busEnvFactors = dependencyJSON.busEnvFactors;
          		if(busEnvFactors != null) {
          			busEnvFactors.forEach(function(aBEF) {
          				aBEF['busCapDeps'] = [];
          				aBEF['appCapDeps'] = [];
          				aBEF['techCapDeps'] = [];
          				aBEF['prodConceptDeps'] = [];
          				aBEF['extRoleDeps'] = [];
          				aBEF.dependencyIds.forEach(function(aDepId) {
          					let aBusCap = dependencyJSON.busCaps.find(function(aBC) {
          						return aBC.id == aDepId;
          					});
          					if(aBusCap != null) {
          						aBEF['busCapDeps'].push(aBusCap);
          					} else {
          						let anAppCap = dependencyJSON.appCaps.find(function(anAC) {
	          						return anAC.id == aDepId;
	          					});
	          					if(anAppCap != null) {
	          						aBEF['appCapDeps'].push(anAppCap);
	          					} else {
	          						let aTechCap = dependencyJSON.techCaps.find(function(aTC) {
		          						return aTC.id == aDepId;
		          					});
		          					if(aTechCap != null) {
		          						aBEF['techCapDeps'].push(aTechCap);
		          					} else {
		          						let aProdConcept = dependencyJSON.productConcepts.find(function(aPC) {
			          						return aPC.id == aDepId;
			          					});
			          					if(aProdConcept != null) {
			          						aBEF['prodConceptDeps'].push(aProdConcept);
			          					} else {
			          						let anExtRole = dependencyJSON.externalRoles.find(function(anER) {
				          						return anER.id == aDepId;
				          					});
				          					if(anExtRole != null) {
				          						aBEF['extRoleDeps'].push(anExtRole);
				          					}
			          					}
		          					}     
	          					}          					
          					}
          				});
          			});
          		}
          }
          
          
          //set up product concept data
          function setupProductConceptsData() {
          	let prodConcepts = dependencyJSON.productConcepts;
          	if(prodConcepts != null) {
          		prodConcepts.forEach(function(aPC) {
          			let prodTypes = aPC.prodTypeIds.map(function(aPTId) {
          				return dependencyJSON.productTypes.find(function(aPT) {
          					return aPT.id == aPTId;
          				});
          			});
          			aPC['prodTypes'] = prodTypes;
          		});
          	}
          }
          
          
          //set up product type data
          function setupProductTypesData() {
          	//set products
          	let prodTypes = dependencyJSON.productTypes;
          	if(prodTypes != null) {
          		prodTypes.forEach(function(aPT) {
          			let internalProds = [];
          			aPT.productIds.forEach(function(prodId) {
          				let thisProd = dependencyJSON.internalProducts.find(function(aProd) {
          					return aProd.id == prodId;
          				});
          				if(thisProd !=- null) {
          					internalProds.push(thisProd);
          				}
          			});
          			aPT['internalProducts'] = internalProds;
          			
          			let externalProds = [];
          			aPT.productIds.forEach(function(prodId) {
          				let thisProd = dependencyJSON.externalProducts.find(function(aProd) {
          					return aProd.id == prodId;
          				});
          				if(thisProd !=- null) {
          					externalProds.push(thisProd);
          				}
          			});
          			aPT['externalProducts'] = externalProds;
          			
          		});
          	}
          }

          
          //set up internal product data
          function setupInternalProductsData() {
          	
          	let internalProds = dependencyJSON.internalProducts;
          	if(internalProds != null) {
          		internalProds.forEach(function(aProd) {
          			//set supporting external products
          			let extProds = aProd.suppExtProductIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			aProd['suppExtProducts'] = extProds;
          			
          			//set supporting external orgs
          			let extOrgs = aProd.suppExtOrgIds.map(function(orgId) {
          				return dependencyJSON.externalOrgs.find(function(anOrg) {
          					return anOrg.id == orgId;
          				});
          			});
          			aProd['suppExtOrgs'] = extOrgs;
          			
          		});
          	}
          
          }
          
          //set up external product data
          function setupExternalProductsData() {
          	let externalProds = dependencyJSON.externalProducts;
          	if(externalProds != null) {
          		externalProds.forEach(function(aProd) {
          			//set supporting external products
          			let extProds = aProd.suppExtProductIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			aProd['suppExtProducts'] = extProds;
          			
          			//set supporting external orgs
          			let extOrgs = aProd.suppExtOrgIds.map(function(orgId) {
          				return dependencyJSON.externalOrgs.find(function(anOrg) {
          					return anOrg.id == orgId;
          				});
          			});
          			aProd['suppExtOrgs'] = extOrgs;
          			
          			//set dependent internal products
          			let intProds = aProd.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.internalProducts.find(function(intProd) {
          					return intProd.id == prodId;
          				});
          			});
          			aProd['depIntProducts'] = intProds;
          			
          			//set dependent external products
          			let depExtProds = aProd.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			aProd['depExtProducts'] = depExtProds;
          			
          			//set dependent internal product types
          			let intProdTypes = aProd.depIntProductTypeIds.map(function(prodTypeId) {
          				return dependencyJSON.productTypes.find(function(intProdType) {
          					return intProdType.id == prodTypeId;
          				});
          			});
          			aProd['depIntProductTypes'] = intProdTypes;
          			
          			//set dependent bus caps
          			let depBusCaps = aProd.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			aProd['depBusCaps'] = depBusCaps;
          			
          		});
          	}
          }
          
          
          //set up external role data
          function setupExternalRolesData() {
          	let externalRoles = dependencyJSON.externalRoles;
          	if(externalRoles != null) {
          		externalRoles.forEach(function(aRole) {
          			//set external products assaociated with the role
          			let roleProds = aRole.productIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			aRole['products'] = roleProds;
          			
          			//set external orgs playing the role
          			let extOrgs = aRole.extOrgIds.map(function(orgId) {
          				return dependencyJSON.externalOrgs.find(function(anOrg) {
          					return anOrg.id == orgId;
          				});
          			});
          			aRole['extOrgs'] = extOrgs;
          			
          			//set dependent internal products
          			let intProds = aRole.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.internalProducts.find(function(intProd) {
          					return intProd.id == prodId;
          				});
          			});
          			aRole['depIntProducts'] = intProds;
          			
          			//set dependent external products
          			let extProds = aRole.depExtProductIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			aRole['depExtProducts'] = extProds;

          			
          			//set dependent internal product types
          			let intProdTypes = aRole.depIntProductTypeIds.map(function(prodTypeId) {
          				return dependencyJSON.productTypes.find(function(intProdType) {
          					return intProdType.id == prodTypeId;
          				});
          			});
          			aRole['depIntProductTypes'] = intProdTypes;
          			
          			//set dependent bus caps
          			let depBusCaps = aRole.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			aRole['depBusCaps'] = depBusCaps;
          			
          		});
          	}
          }
          
          
          //set up external org data
          function setupExternalOrgsData() {
          	let externalOrgs = dependencyJSON.externalOrgs;
          	if(externalOrgs != null) {
          		externalOrgs.forEach(function(anOrg) {
          			//set external products assaociated with the org
          			let orgProds = anOrg.productIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			anOrg['products'] = orgProds;
          			
          			//set roles played by the org
          			let orgRoles = anOrg.extRoleIds.map(function(roleId) {
          				return dependencyJSON.externalRoles.find(function(aRole) {
          					return aRole.id == roleId;
          				});
          			});
          			anOrg['roles'] = orgRoles;
          			
          			//set dependent internal products
          			let intProds = anOrg.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.internalProducts.find(function(intProd) {
          					return intProd.id == prodId;
          				});
          			});
          			anOrg['depIntProducts'] = intProds;
          			
          			//set dependent external products
          			let extProds = anOrg.depExtProductIds.map(function(prodId) {
          				return dependencyJSON.externalProducts.find(function(extProd) {
          					return extProd.id == prodId;
          				});
          			});
          			anOrg['depExtProducts'] = extProds;

          			
          			//set dependent internal product types
          			let intProdTypes = anOrg.depIntProductTypeIds.map(function(prodTypeId) {
          				return dependencyJSON.productTypes.find(function(intProdType) {
          					return intProdType.id == prodTypeId;
          				});
          			});
          			anOrg['depIntProductTypes'] = intProdTypes;
          			
          			//set dependent bus caps
          			let depBusCaps = anOrg.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			anOrg['depBusCaps'] = depBusCaps;         			
          		});
          	}
          }
          
          
          //set up strategic goal data
          function setupStrategicGoalsData() {
          	let stratGoals = dependencyJSON.strategicGoals;
          	if(stratGoals != null) {
          		stratGoals.forEach(function(aGoal) {
          			//set the objectives supporting the goal
          			let objs = aGoal.objectiveIds.map(function(objId) {
          				return dependencyJSON.strategicObjectives.find(function(anObj) {
          					return anObj.id == objId;
          				});
          			});
          			aGoal['objectives'] = objs;          			
          		});
          	}
          }
          
          
          //set up strategic objective data
          function setupStrategicObjsData() {
          	let stratObjs = dependencyJSON.strategicObjectives;
          	if(stratObjs != null) {
          		stratObjs.forEach(function(anObj) {
          			//set goals supported by the objective
          			let goals = anObj.depGoalIds.map(function(goalId) {
          				return dependencyJSON.strategicGoals.find(function(aGoal) {
          					return aGoal.id == goalId;
          				});
          			});
          			anObj['depGoals'] = goals;        			
          		});
          	}         
          }
          
          
          //set up roadmap data
          function setupRoadmapsData() {
          	let roadmaps = dependencyJSON.roadmaps;
          	if(roadmaps != null) {
          		roadmaps.forEach(function(aRM) {
          			//set strategic plans for the roadmap
          			let plans = aRM.stratPlanIds.map(function(planId) {
          				return dependencyJSON.strategicPlans.find(function(aPlan) {
          					return aPlan.id == planId;
          				});
          			});
          			aRM['strategicPlans'] = plans;        			
          		});
          	}
          }
          
          //set up strategic plans data
          function setupStrategicPlansData() {
          	let stratPlans = dependencyJSON.strategicPlans;
          	if(stratPlans != null) {
          		stratPlans.forEach(function(aPlan) {
          			//set dependent strategic goals
          			let depGoals = aPlan.depGoalIds.map(function(gaolId) {
          				return dependencyJSON.strategicGoals.find(function(aGoal) {
          					return aGoal.id == gaolId;
          				});
          			});
          			aPlan['depGoals'] = depGoals;
          			
          			//set dependent strategic objectives
          			let depObjectives = aPlan.depObjectiveIds.map(function(objId) {
          				return dependencyJSON.strategicObjectives.find(function(anObj) {
          					return anObj.id == objId;
          				});
          			});
          			aPlan['depObjectives'] = depObjectives;
          			
          			//set dependent roadmaps
          			let roadmaps = aPlan.depRoadmapIds.map(function(rmId) {
          				return dependencyJSON.roadmaps.find(function(aRM) {
          					return aRM.id == rmId;
          				});
          			});
          			aPlan['depRoadmaps'] = roadmaps;
          			
          			//set dependent strategic plans
          			let depStratPlans = aPlan.depStratPlanIds.map(function(planId) {
          				return dependencyJSON.strategicPlans.find(function(aPlan) {
          					return aPlan.id == planId;
          				});
          			});
          			aPlan['depStrategicPlans'] = depStratPlans;
          			
          			//set dependent bus caps
          			let depBusCaps = aPlan.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			aPlan['depBusCaps'] = depBusCaps; 
          			
          			//set dependent app caps
          			let depAppCaps = aPlan.depAppCapIds.map(function(appCapId) {
          				return dependencyJSON.appCaps.find(function(anAC) {
          					return anAC.id == appCapId;
          				});
          			});
          			aPlan['depAppCaps'] = depAppCaps; 
          			
          			//set dependent tech caps
          			let depTechCaps = aPlan.depTechCapIds.map(function(techCapId) {
          				return dependencyJSON.techCaps.find(function(aTC) {
          					return aTC.id == techCapId;
          				});
          			});
          			aPlan['depTechCaps'] = depTechCaps; 
          			
          		});
          	}
          }
          
          /****
          //set up service quality data
          function setupBusServiceQualsData() {
          
          }
          
          
          //set up cost type data
          function setupCostTypesData() {
          
          }
          
          
          //set up revenue type data
          function setupRevenueTypesData() {
          
          }
          *****/
          
          
          //set up value stream data
          function setupValueStreamsData() {
          	let valueStreams = dependencyJSON.valueStreams;
          	if(valueStreams != null) {
          		valueStreams.forEach(function(aValStr) {
          			//set supporting value stages
          			let valueStages = aValStr.valueStageIds.map(function(vsId) {
          				return dependencyJSON.valueStages.find(function(aVS) {
          					return aVS.id == vsId;
          				});
          			});
          			aValStr['valueStages'] = valueStages;
          			
          			
          			//set dependent internal products
          			let intProds = aValStr.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.internalProducts.find(function(intProd) {
          					return intProd.id == prodId;
          				});
          			});
          			aValStr['depIntProducts'] = intProds;

          			
          			//set dependent internal product types
          			let intProdTypes = aValStr.depIntProductTypeIds.map(function(prodTypeId) {
          				return dependencyJSON.productTypes.find(function(intProdType) {
          					return intProdType.id == prodTypeId;
          				});
          			});
          			aValStr['depIntProductTypes'] = intProdTypes;
          			
          		});
          	}
          }
          
          
          //set up value stage data
          function setupValueStagesData() {
          	let valueStages = dependencyJSON.valueStages;
          	if(valueStages != null) {
          		valueStages.forEach(function(aValStg) {
          			if(aValStg.parentValStreamId != null) {
	          			//set parent value stream
	          			let parentValStrm = dependencyJSON.valueStreams.find(function(aVS) {
	          				return aVS.id == aValStg.parentValStreamId;
	          			});
	          			aValStg['parentValueStream'] = parentValStrm;
					}
          			
          			
          			if(aValStg.parentValStageId != null) {
	          			//set parent value stream
	          			let parentValStage = dependencyJSON.valueStages.find(function(aVS) {
	          				return aVS.id == aValStg.parentValStageId;
	          			});
	          			aValStg['parentValueStage'] = parentValStage;
					}
          			
          		});
          	}
          }
          
          
          //set up business capability data
          function setupBusCapsData() {
          	let busCaps = dependencyJSON.busCaps;
          	if(busCaps != null) {
          		busCaps.forEach(function(aBC) {
          			//set dependent value streams
          			let valueStreams = aBC.depValueStreamIds.map(function(vsId) {
          				return dependencyJSON.valueStreams.find(function(aVS) {
          					return aVS.id == vsId;
          				});
          			});
          			aBC['depValueStreams'] = valueStreams;
          		
          			//set dependent value stages
          			let valueStages = aBC.depValueStageIds.map(function(vsgId) {
          				return dependencyJSON.valueStages.find(function(aVSg) {
          					return aVSg.id == vsgId;
          				});
          			});
          			aBC['depValueStages'] = valueStages;
          			
          			//set dependent strategic objectives
          			let depObjectives = aBC.depObjectiveIds.map(function(objId) {
          				return dependencyJSON.strategicObjectives.find(function(anObj) {
          					return anObj.id == objId;
          				});
          			});
          			aBC['depObjectives'] = depObjectives;
          			
          			//set dependent strategic goals
          			let depGoals = aBC.depGoalIds.map(function(goalId) {
          				return dependencyJSON.strategicGoals.find(function(aGoal) {
          					return aGoal.id == goalId;
          				});
          			});
          			aBC['depGoals'] = depGoals;
          			
          			//set dependent internal products
          			let intProds = aBC.depIntProductIds.map(function(prodId) {
          				return dependencyJSON.internalProducts.find(function(intProd) {
          					return intProd.id == prodId;
          				});
          			});
          			aBC['depIntProducts'] = intProds;

          			
          			//set dependent internal product types
          			let intProdTypes = aBC.depIntProductTypeIds.map(function(prodTypeId) {
          				return dependencyJSON.productTypes.find(function(intProdType) {
          					return intProdType.id == prodTypeId;
          				});
          			});
          			aBC['depIntProductTypes'] = intProdTypes;		
          		});
          	}
          }
          
          
          //set up application capability data
          function setupAppCapsData() {
          	let appCaps = dependencyJSON.appCaps;
          	if(appCaps != null) {
          		appCaps.forEach(function(anAC) {
          			//set dependent value streams
          			let valueStreams = anAC.depValueStreamIds.map(function(vsId) {
          				return dependencyJSON.valueStreams.find(function(aVS) {
          					return aVS.id == vsId;
          				});
          			});
          			anAC['depValueStreams'] = valueStreams;
          		
          			//set dependent value stages
          			let valueStages = anAC.depValueStageIds.map(function(vsgId) {
          				return dependencyJSON.valueStages.find(function(aVSg) {
          					return aVSg.id == vsgId;
          				});
          			});
          			anAC['depValueStages'] = valueStages;
          			
          			//set dependent strategic objectives
          			let depObjectives = anAC.depObjectiveIds.map(function(objId) {
          				return dependencyJSON.strategicObjectives.find(function(anObj) {
          					return anObj.id == objId;
          				});
          			});
          			anAC['depObjectives'] = depObjectives;
          			
          			//set dependent internal organisations
          			let depIntOrgs = anAC.depIntOrgIds.map(function(orgId) {
          				return dependencyJSON.internalOrgs.find(function(anOrg) {
          					return anOrg.id == orgId;
          				});
          			});
          			anAC['depIntOrgs'] = depIntOrgs;
          			
          			//set dependent bus caps
          			let depBusCaps = anAC.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			anAC['depBusCaps'] = depBusCaps; 			
          		});
          	}
          }
          
          
          //set up technology capability data
          function setupTechCapsData() {
          	let techCaps = dependencyJSON.techCaps;
          	if(techCaps != null) {
          		techCaps.forEach(function(aTC) {
          			//set dependent value streams
          			let valueStreams = aTC.depValueStreamIds.map(function(vsId) {
          				return dependencyJSON.valueStreams.find(function(aVS) {
          					return aVS.id == vsId;
          				});
          			});
          			aTC['depValueStreams'] = valueStreams;
          		
          			//set dependent value stages
          			let valueStages = aTC.depValueStageIds.map(function(vsgId) {
          				return dependencyJSON.valueStages.find(function(aVSg) {
          					return aVSg.id == vsgId;
          				});
          			});
          			aTC['depValueStages'] = valueStages;
          			
          			//set dependent strategic objectives
          			let depObjectives = aTC.depObjectiveIds.map(function(objId) {
          				return dependencyJSON.strategicObjectives.find(function(anObj) {
          					return anObj.id == objId;
          				});
          			});
          			aTC['depObjectives'] = depObjectives;
          			
          			//set dependent internal organisations
          			let depIntOrgs = aTC.depIntOrgIds.map(function(orgId) {
          				return dependencyJSON.internalOrgs.find(function(anOrg) {
          					return anOrg.id == orgId;
          				});
          			});
          			aTC['depIntOrgs'] = depIntOrgs;
          			
          			//set dependent bus caps
          			let depBusCaps = aTC.depBusCapIds.map(function(busCapId) {
          				return dependencyJSON.busCaps.find(function(aBC) {
          					return aBC.id == busCapId;
          				});
          			});
          			aTC['depBusCaps'] = depBusCaps;
          			
          			//set dependent app caps
          			let depAppCaps = aTC.depAppCapIds.map(function(appCapId) {
          				return dependencyJSON.appCaps.find(function(anAC) {
          					return anAC.id == appCapId;
          				});
          			});
          			aTC['depAppCaps'] = depAppCaps;
          		});
          	}
          }
          
          
          /*******************************
          END DATA SETUP FUNCTIONS
          ********************************/
          
           /*******************************
          START TREND IMPACT FUNCTIONS
          ********************************/
          var currentTrendImplications = [];
          
          //function to define the business context impacts
          function setBusContextImpacts() {
          
          }
          
          //function to define the eco-system impacts
          function setEcoSystemImpacts() {
          
          }
          
          //function to define the strategy impacts
          function setStrategyImpacts() {
          
          }
          
          //function to define the business outcome impacts
          function setBusOutcomeImpacts() {
          
          }
          
          //function to define the business impacts
          function setBusinessImpacts() {
          
          }
          
          //function to define the IT impacts
          function setITImpacts() {
          
          }
          
          
           /*******************************
          END TREND IMPACT FUNCTIONS
          ********************************/
          
          
          
          
    	  var trendSummaryTemplate;
          var draw = function () {
				drawStrategicTrendRadar();
          }
          
          var trendAPIReportURL = '<xsl:value-of select="$trendAPIReportURL"/>';
 		  var dependencyAPIReportURL = '<xsl:value-of select="$dependencyAPIReportURL"/>';
          
          function showViewSpinner(message) {
			    $('#view-spinner-text').text(message);                            
			    $('#view-spinner').removeClass('hidden');                         
			};
			
			function updateViewSpinner(message) {
			    $('#view-spinner-text').text(message);                                                    
			};
			
			function removeViewSpinner() {
			    $('#view-spinner').addClass('hidden');
			    $('#view-spinner-text').text('');
			};
          
          //set a variable to a Promise function that calls  API Report using the given path and returns the resulting data
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            let viewAPIData = JSON.parse(this.responseText);
                            resolve(viewAPIData);
                        }
                    };
                    xmlhttp.onerror = function () {
                        reject(false);
                    };
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(false);
                }
            });
        };
        

        $(document).ready(function () {
          	var trendSummaryFragment = $("#trend-summary-template").html();
          	trendSummaryTemplate = Handlebars.compile(trendSummaryFragment);
      
      		getTrendYears();
      		
      		//Get the API data required for the view
      		showViewSpinner('Loading data...');
            Promise.all([
                promise_loadViewerAPIData(trendAPIReportURL),
                promise_loadViewerAPIData(dependencyAPIReportURL)
            ])
            .then(function(responses) {
                //set the data variables
                trendJSON = responses[1];
                dependencyJSON = responses[0];
                
                //prepare the dashboard data
                removeViewSpinner();
                showViewSpinner('Preparing data...');
                //updateViewSpinner('Preparing dashboard data...');
                setupDashboardData();
                
                //format the trend data
                formatTrendRadarData();
                
                //render the view
                draw();
                removeViewSpinner();
            })
            .catch (function (error) {
            	removeViewSpinner();
            	console.log(error);
                //display an error somewhere on the page   
            });
        });

    </script>
				
				<!-- Application Reference Model Template -->
				<script id="trend-summary-template" type="text/x-handlebars-template">
				<div class="row">
					<div class="col-xs-9">
						<h3 class="text-secondary">Trend Name</h3>
					</div>
					<div class="col-xs-3">
						<h3 class="text-secondary">From Year: <span class="text-primary">2021</span></h3>
					</div>
					<div class="col-xs-12">
						<p>Description of the trend</p>
					</div>
				</div>
			</script>
				
        
			</body>
		</html>
	</xsl:template>


</xsl:stylesheet>
