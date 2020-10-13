<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../business/core_bl_bus_cap_model_include.xsl"/>

	<xsl:include href="../common/core_roadmap_functions.xsl"/>
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
	<xsl:variable name="linkClasses" select="('Value_Stream', 'Business_Capability', 'Product_Type', 'Group_Actor', 'Project', 'Application_Provider', 'Composite_Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- May 2011 Updated to support Essential Viewer version 3-->


	<!-- START VIEW SPECIFIC VARIABLES -->

	<xsl:variable name="currentValueStream" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="vsProductTypes" select="/node()/simple_instance[name = $currentValueStream/own_slot_value[slot_reference = 'vs_product_types']/value]"/>
	<xsl:variable name="vsValueStages" select="/node()/simple_instance[name = $currentValueStream/own_slot_value[slot_reference = 'vs_value_stages']/value]"/>
	<xsl:variable name="allValueStageLabels" select="/node()/simple_instance[name = $vsValueStages/own_slot_value[slot_reference = 'vsg_label']/value]"/>
	<xsl:variable name="allStakeholderRoles" select="/node()/simple_instance[name = ($currentValueStream, $vsValueStages)/own_slot_value[slot_reference = ('vs_trigger_business_roles', 'vsg_participants')]/value]"/>
	<xsl:variable name="allBusinessEvents" select="/node()/simple_instance[name = ($currentValueStream, $vsValueStages)/own_slot_value[slot_reference = ('vs_trigger_events', 'vs_outcome_events', 'vsg_entrance_events', 'vsg_exit_events')]/value]"/>
	<xsl:variable name="allBusinessConditions" select="/node()/simple_instance[name = ($currentValueStream, $vsValueStages)/own_slot_value[slot_reference = ('vs_trigger_conditions', 'vs_outcome_conditions', 'vsg_entrance_conditions', 'vsg_exit_conditions')]/value]"/>
	<xsl:variable name="allValueStage2EmotionRels" select="/node()/simple_instance[name = $vsValueStages/own_slot_value[slot_reference = 'vsg_emotions']/value]"/>
	<xsl:variable name="allEmotions" select="/node()/simple_instance[name = $allValueStage2EmotionRels/own_slot_value[slot_reference = 'value_stage_to_emotion_to_emotion']/value]"/>
	<xsl:variable name="allValueStagePerfMeasures" select="/node()/simple_instance[name = $vsValueStages/own_slot_value[slot_reference = 'performance_measures']/value]"/>
	<xsl:variable name="allValueStageKPIValues" select="/node()/simple_instance[name = $allValueStagePerfMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/>
	<xsl:variable name="allValueStageKPIs" select="/node()/simple_instance[name = $allValueStageKPIValues/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
	<xsl:variable name="allValueStageKPIUoMs" select="/node()/simple_instance[name = $allValueStageKPIValues/own_slot_value[slot_reference = 'service_quality_value_uom']/value]"/>
	<xsl:variable name="allValueStageBusCaps" select="/node()/simple_instance[name = $vsValueStages/own_slot_value[slot_reference = 'vsg_required_business_capabilities']/value]"/>

	<xsl:variable name="DEBUG" select="''"/>

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
				<title>Value Stream Summary for <xsl:value-of select="$currentValueStream/own_slot_value[slot_reference='name']/value"/></title>
				<!--<link type="text/css" rel="stylesheet" href="ext/apml/custom.css"/>-->
				<script src="js/jquery-migrate-1.4.1.min.js" type="text/javascript"/>
				<!--JQuery plugin to support tooltips-->
				<script src="js/jquery.tools.min.js" type="text/javascript"/>

				<!-- Start Templating Libraries -->

				<style type="text/css">
					.vs-outer-container{
						width: 100%;
						overflow: hidden;
						position: relative;
						margin-top
					}
					
					.vs-header-section{
						width: 100%;
						min-height: 100px;
						position: relative;
					}
					
					.vs-header-section-top{
						width: 100%;
						min-height: 20px;
						font-weight: 700;
						font-size: 1.2em;
						float: left;
						padding-left: 5px;
						border-top: 1px solid #ccc;
						border-left: 1px solid #ccc;
						border-right: 1px solid #ccc;
						border-bottom: 1px solid #ccc;
					}
					.vs-header-section-top > ul {
						margin-left: 30px;
						padding-right: 5px;
						line-height: 1.1em;
						margin-top: 5px;
					}
					
					.vs-header-section-bottom{
						width: 100%;
						min-height: 50px;
						float: left;
						padding: 5px;
						border-left: 1px solid #ccc;
						border-right: 1px solid #ccc;
						border-bottom: 1px solid #ccc;
						border-radius: 0 0 5px 5px;
					}
					
					.vs-header-section-bottom > ul{
						padding-left: 20px;
					}
					
					.vs-header-column{
						margin-right: 5px;
						width: 142px;
						position: relative;
					}
					
					.vs-column{
						margin-right: 5px;
						float: left;
						width: 250px;
						position: relative;
					}
					
					.vs-arrow-header{
						width: 130px;
						padding: 5px 20px 5px 5px;
						height: 50px;
						font-weight: 700;
						font-size: 1.2em;
						margin-bottom: 5px;
						text-align: left;
						background-color: white;
						position: relative;
					}
					
					.vs-detail-header{
						position: relative;
						width: 130px;
						min-height: 40px;
						overflow: hidden;
						padding: 5px;
						float: left;
						font-weight: 700;
						font-size: 1.1em;
						text-align: left;
						opacity: 1.0;
						line-height: 1.2em;
						border-radius: 5px 0 0 5px;
						box-shadow: 1px 1px 2px #ccc;
						border: 1px solid #f6f6f6;
						margin: 0 5px 5px 0;
					}
					
					.vs-arrow{
						width: 240px;
						padding: 5px 20px 5px 5px;
						height: 50px;
						font-weight: 700;
						font-size: 1.1em;
						margin-bottom: 5px;
						text-align: left;
						background: url(images/value_chain_arrow_end.png) no-repeat right center;
						background-color: hsla(220, 70%, 15%, 1);
						color: #fff;
						position: relative;
					}
					
					.vs-detail{
						position: relative;
						width: 225px;
						min-height: 40px;
						overflow: hidden;
						padding: 5px;
						float: left;
						text-align: left;
						opacity: 1.0;
						margin: 0 5px 5px 0;
						line-height: 1.2em;
						box-shadow: 1px 1px 2px #ccc;
						border: 1px solid #f6f6f6;
					}
					
					.vs-detail > ul{
						padding-left: 20px;
					}
					
					.vs-detail:hover,
					.vs-arrow:hover{
						opacity: 0.75;
						<!--cursor: pointer;-->
					}
					
					.vs-empty-detail{
						color: #ccc;
						font-style: italic;
					}
					.vs-scroller {
						position: relative;
						width: calc(100% - 150px);
						overflow-x: scroll;
					}
					.vs-scroller-inner{
						width: <xsl:value-of select="count($vsValueStages)*300"/>px;
					}
				</style>
			</head>
			<body>
				<!-- handlebars template to render the header details for the Value Stream -->
				<script id="vs-header-template" type="text/x-handlebars-template">
					<div class="row">
						<div class="col-xs-12 col-sm-6 col-md-2 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-flag"/>Initiators</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if triggerRoles.length}}
										<ul>
											{{#each triggerRoles}}
												<li>{{{link}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No initiators defined
									{{/if}}
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-2 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-paper-plane"/>Initiation Events</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if triggerEvents.length}}
										<ul>
											{{#each triggerEvents}}
												<li>{{{link}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No initiation events defined
									{{/if}}
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-2 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-question-circle"/>Initiation Conditions</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if triggerConditions.length}}
										<ul>
											{{#each triggerConditions}}
												<li>{{{name}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No initiation conditions defined
									{{/if}}
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-2 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-check"/>Outcome Conditions</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if outcomeConditions.length}}
										<ul>
											{{#each outcomeConditions}}
												<li>{{{name}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No outcome conditions defined
									{{/if}}
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-2 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-road"/>Outcomes</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if outcomeEvents.length}}
										<ul>
											{{#each outcomeEvents}}
												<li>{{{link}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No outcomes defined
									{{/if}}
								</div>
							</div>
						</div>
						<div class="col-xs-12 col-sm-6 col-md-10 top-15">
							<div class="vs-header-section">
								<div class="vs-header-section-top bg-darkblue-120">
									<ul class="fa-ul"><li><i class="fa fa-li fa-cubes"/>Impacted Business Services</li></ul>
								</div>
								<div class="vs-header-section-bottom">
									{{#if productTypes.length}}
										<ul>
											{{#each productTypes}}
												<li>{{{link}}}</li>
											{{/each}}
										</ul>
									{{else}}
										No products defined
									{{/if}}
								</div>
							</div>
						</div>
					</div>
					
				</script>

				<!-- handlebars template to render the Value Stages and their details for the Value Stream -->
				<script id="vs-template" type="text/x-handlebars-template">
					<div class="vs-header-column pull-left">
						<div class="vs-arrow-header small">Value Stages</div>
						<div class="vs-participants vs-detail-header small bg-lightblue-100">Participants</div>
						<div class="vs-buscaps vs-detail-header small bg-lightblue-100">Supporting Business Capabilities</div>
						<div class="vs-emotions vs-detail-header small bg-lightblue-100">Target Emotions</div>
						<div class="vs-entrance-events vs-detail-header small bg-lightgreen-100">Entrance Events</div>
						<div class="vs-entrance-conditions vs-detail-header small bg-lightgreen-100">Entrance Conditions</div>
						<div class="vs-exit-events vs-detail-header small bg-brightred-100">Exit Events</div>
						<div class="vs-exit-conditions vs-detail-header small bg-brightred-100">Exit Conditions</div>
						<div class="vs-kpis vs-detail-header small bg-orange-100">KPIs</div>
					</div>
					<div class="vs-scroller">
						<div class="vs-scroller-inner">
							{{#each valueStages}}
								<div class="vs-column pull-left">
									<!-- Value Stage Arrow -->
									<div class="vs-arrow small">{{{link}}}</div>
									
									<!-- Participants -->
									{{#if participants.length}}
										<div class="vs-participants vs-detail small bg-lightblue-20">
											<ul>
												{{#each participants}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</div>				        	
									{{else}}
										<div class="vs-participants vs-detail small vs-empty-detail">No Participants</div>				        	
									{{/if}}
									
									<!-- Supporting Bus Caps -->
									{{#if busCaps.length}}
										<div class="vs-buscaps vs-detail small bg-lightblue-20">
											<ul>
												{{#each busCaps}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</div>				        	
									{{else}}
										<div class="vs-buscaps vs-detail small vs-empty-detail">No Business Capabilities</div>				        	
									{{/if}}
									
									<!-- Target Emotions -->
									{{#if emotions.length}}
										<div class="vs-emotions vs-detail small bg-lightblue-20">
											<ul>
												{{#each emotions}}
													<li>{{name}}</li>
												{{/each}}
											</ul>
										</div>					        	
									{{else}}
										<div class="vs-emotions vs-detail small vs-empty-detail">No Target Emotions</div>					        	
									{{/if}}
									
									<!-- Entrance Events -->
									{{#if entranceEvents.length}}
										<div class="vs-entrance-events vs-detail small bg-lightgreen-20">
											<ul>
												{{#each entranceEvents}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</div>
									{{else}}
										<div class="vs-entrance-events vs-detail small vs-empty-detail">No Entrance Events</div>					        	
									{{/if}}
									
									<!-- Entrance Conditons -->
									{{#if entranceConditions.length}}
										<div class="vs-entrance-conditions vs-detail small bg-lightgreen-20">
											<ul>
												{{#each entranceConditions}}
													<li>{{name}}</li>
												{{/each}}
											</ul>
										</div>
									{{else}}
										<div class="vs-entrance-conditions vs-detail small vs-empty-detail">No Entrance Conditons</div>
									{{/if}}
									
									<!-- Exit Events -->
									{{#if exitEvents.length}}
										<div class="vs-exit-events vs-detail small bg-brightred-20">
											<ul>
												{{#each exitEvents}}
													<li>{{{link}}}</li>
												{{/each}}
											</ul>
										</div>
									{{else}}
										<div class="vs-exit-events vs-detail small vs-empty-detail">No Exit Events</div>
									{{/if}}
									
									<!-- Exit Conditons -->
									{{#if exitConditions.length}}
										<div class="vs-exit-conditions vs-detail small bg-brightred-20">
											<ul>
												{{#each exitConditions}}
													<li>{{name}}</li>
												{{/each}}
											</ul>
										</div>
									{{else}}
										<div class="vs-exit-conditions vs-detail small vs-empty-detail">No Exit Conditons</div>
									{{/if}}
									
									<!-- KPIs -->
									{{#if kpiValues.length}}
										<div class="vs-kpis vs-detail small bg-orange-20">
											<ul>
												{{#each kpiValues}}
													<li>{{kpi}}: {{value}}{{uom}}</li>
												{{/each}}
											</ul>
										</div>				        	
									{{else}}
										<div class="vs-kpis vs-detail small vs-empty-detail">No KPIs</div>					        	
									{{/if}}
								</div>
							{{/each}}
						</div>
					</div>
				</script>

				<script type="text/javascript">
					var valueStreamHeaderTemplate, valueStageTemplate;
					
					var valueStream = <xsl:call-template name="RenderValueStreamJSON"/>;
					
					var valueStageDetailsClasses = ['vs-participants', 'vs-buscaps', 'vs-emotions', 'vs-entrance-events', 'vs-entrance-conditions', 'vs-exit-events', 'vs-exit-conditions', 'vs-kpis'];
					
					function setValueStageDetailsHeights() {
						var greatestHeight, theHeight, aDetailsClass;
						
						for (var i = 0; valueStageDetailsClasses.length > i; i += 1) {
							aDetailsClass = '.' + valueStageDetailsClasses[i];
							greatestHeight = 0;
							$(aDetailsClass).each(function() {    // Select the elements you're comparing		
								theHeight = $(this).height();   // Grab the current height				
								if( theHeight > greatestHeight) {   // If theHeight > the greatestHeight so far,
									greatestHeight = theHeight;     //    set greatestHeight to theHeight
								}
							});
							
							// console.log('Setting height of ' + aDetailsClass + ' to ' + greatestHeight);
							$(aDetailsClass).height(greatestHeight);     // Update the elements you were comparing to have the same height
						}
					}
					
					
					$('document').ready(function(){
						
						var valueStreamHeaderFragment = $("#vs-header-template").html();
						valueStreamHeaderTemplate = Handlebars.compile(valueStreamHeaderFragment);				
						$('#vs-header').html(valueStreamHeaderTemplate(valueStream));
						
						var valueStageFragment = $("#vs-template").html();
						valueStageTemplate = Handlebars.compile(valueStageFragment);
						$('#vs-container').html(valueStageTemplate(valueStream)).promise().done(function(){
							setValueStageDetailsHeights();
						});
						
						<!--
						Match Height of Header Sections//-->
						$('.vs-header-section-top').matchHeight();
						$('.vs-header-section-bottom').matchHeight();
					});
				</script>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="viewName">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Value Stream Summary for </span>
									<span class="text-primary">
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$currentValueStream"/>
											<xsl:with-param name="anchorClass">text-primary</xsl:with-param>
										</xsl:call-template>
									</span>
								</h1>
								<xsl:value-of select="$DEBUG"/>
							</div>
						</div>


						<!--Setup Value Stream Section-->
						<div class="col-xs-12">
							<div class="pull-left">
								<div class="vs-outer-container pull-left">
									<div id="vs-header"/>
								</div>
							</div>
						</div>
						<div class="col-xs-12 top-30">
							<div class="vs-outer-container">
								<div id="vs-container"/>
							</div>		
						</div>
						<!--Setup Closing Tags-->
					</div>
				</div>

				<div class="clear"/>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>



	<!-- TEMPLATE TO RENDER A JSON OBJECT REPRESENTING A VALUE STREAM -->
	<xsl:template name="RenderValueStreamJSON">
		<xsl:variable name="this" select="$currentValueStream"/>
		<xsl:variable name="vsStakeholderRoles" select="$allStakeholderRoles[name = $currentValueStream/own_slot_value[slot_reference = 'vs_trigger_business_roles']/value]"/>
		<xsl:variable name="vsTriggerEvents" select="$allBusinessEvents[name = $currentValueStream/own_slot_value[slot_reference = 'vs_trigger_events']/value]"/>
		<xsl:variable name="vsTriggerConditions" select="$allBusinessConditions[name = $currentValueStream/own_slot_value[slot_reference = 'vs_trigger_conditions']/value]"/>
		<xsl:variable name="vsOutcomeEvents" select="$allBusinessEvents[name = $currentValueStream/own_slot_value[slot_reference = 'vs_outcome_events']/value]"/>
        <xsl:variable name="vsOutcomeConditions" select="$allBusinessConditions[name = $currentValueStream/own_slot_value[slot_reference = 'vs_outcome_conditions']/value]"/> { "id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>", "name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>", "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>", "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>", "productTypes": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsProductTypes"/> ], "triggerRoles": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsStakeholderRoles"/> ], "triggerEvents": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsTriggerEvents"/> ], "triggerConditions": [ <xsl:apply-templates mode="getSimpleJSONList" select="$vsTriggerConditions"/> ], "outcomeEvents": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsOutcomeEvents"/> ], "outcomeConditions": [ <xsl:apply-templates mode="getSimpleJSONList" select="$vsOutcomeConditions"/> ], "valueStages": [ <xsl:apply-templates mode="RenderValueStageJSON" select="$vsValueStages"><xsl:sort select="own_slot_value[slot_reference='vsg_index']/value" order="ascending"/></xsl:apply-templates> ] }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<!-- TEMPLATE TO RENDER A JSON OBJECT REPRESENTING A VALUE STAGE -->
	<xsl:template mode="RenderValueStageJSON" match="node()">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisLabel" select="$allValueStageLabels[name = $this/own_slot_value[slot_reference = 'vsg_label']/value]"/>
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisLabel"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="vsgParticipants" select="$allStakeholderRoles[name = $this/own_slot_value[slot_reference = 'vsg_participants']/value]"/>
		<xsl:variable name="vsgEntranceEvents" select="$allBusinessEvents[name = $this/own_slot_value[slot_reference = 'vsg_entrance_events']/value]"/>
		<xsl:variable name="vsgEntranceConditions" select="$allBusinessConditions[name = $this/own_slot_value[slot_reference = 'vsg_entrance_conditions']/value]"/>
		<xsl:variable name="vsgExitEvents" select="$allBusinessEvents[name = $this/own_slot_value[slot_reference = 'vsg_exit_events']/value]"/>
		<xsl:variable name="vsgExitConditions" select="$allBusinessConditions[name = $this/own_slot_value[slot_reference = 'vsg_exit_conditions']/value]"/>
		<xsl:variable name="vsgValueStage2EmotionRels" select="$allValueStage2EmotionRels[name = $this/own_slot_value[slot_reference = 'vsg_emotions']/value]"/>
		<xsl:variable name="vsgEmotions" select="$allEmotions[name = $vsgValueStage2EmotionRels/own_slot_value[slot_reference = 'value_stage_to_emotion_to_emotion']/value]"/>
		<xsl:variable name="vsgValueStagePerfMeasures" select="$allValueStagePerfMeasures[name = $this/own_slot_value[slot_reference = 'performance_measures']/value]"/>
		<xsl:variable name="vsgBusCaps" select="$allValueStageBusCaps[name = $this/own_slot_value[slot_reference = 'vsg_required_business_capabilities']/value]"/>
		<xsl:variable name="vsgValueStageKPIValues" select="$allValueStageKPIValues[name = $vsgValueStagePerfMeasures/own_slot_value[slot_reference = 'pm_performance_value']/value]"/> { "id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>", "name": "<xsl:value-of select="$thisName"/>", "description": "<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="theSubjectInstance" select="$this"/></xsl:call-template>", "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$this"/><xsl:with-param name="displayString" select="$thisName"/><xsl:with-param name="anchorClass">text-black</xsl:with-param></xsl:call-template>", "participants": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsgParticipants"/> ], "busCaps": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsgBusCaps"/> ], "entranceEvents": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsgEntranceEvents"/> ], "entranceConditions": [ <xsl:apply-templates mode="getSimpleJSONList" select="$vsgEntranceConditions"/> ], "exitEvents": [ <xsl:apply-templates mode="getSimpleJSONListWithLink" select="$vsgExitEvents"/> ], "exitConditions": [ <xsl:apply-templates mode="getSimpleJSONList" select="$vsgExitConditions"/> ], "emotions": [ <xsl:apply-templates mode="RenderEmotionJSON" select="$vsgValueStage2EmotionRels"><xsl:with-param name="theEmotions" select="$vsgEmotions"/></xsl:apply-templates> ], "kpiValues": [ <xsl:apply-templates mode="RenderKPIValueJSON" select="$vsgValueStageKPIValues"/> ] }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="RenderEmotionJSON">
		<xsl:param name="theEmotions"/>
		<xsl:variable name="thisEmotion" select="$theEmotions[name = current()/own_slot_value[slot_reference = 'value_stage_to_emotion_to_emotion']/value]"/>
		<xsl:variable name="thisName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisEmotion"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
			</xsl:call-template>
		</xsl:variable> { "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "name": "<xsl:value-of select="$thisName"/>", "link": "<xsl:call-template name="RenderInstanceLinkForJS"><xsl:with-param name="theSubjectInstance" select="$thisEmotion"/></xsl:call-template>", "description": "<xsl:value-of select="$thisDesc"/>" }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>


	<xsl:template match="node()" mode="RenderKPIValueJSON">
		<xsl:variable name="thisKPIVal" select="current()"/>
		<xsl:variable name="thisKPI" select="$allValueStageKPIs[name = $thisKPIVal/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"/>
		<xsl:variable name="thisKPIUoM" select="$allValueStageKPIUoMs[name = $thisKPIVal/own_slot_value[slot_reference = 'service_quality_value_uom']/value]"/>
		<xsl:variable name="thisKPIName">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="$thisKPI"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="thisDesc">
			<xsl:call-template name="RenderMultiLangInstanceDescription">
				<xsl:with-param name="theSubjectInstance" select="$thisKPI"/>
			</xsl:call-template>
		</xsl:variable> { "id": "<xsl:value-of select="eas:getSafeJSString(current()/name)"/>", "kpi": "<xsl:value-of select="$thisKPIName"/>", "description": "<xsl:value-of select="$thisDesc"/>", "value": "<xsl:value-of select="$thisKPIVal/own_slot_value[slot_reference = 'service_quality_value_value']/value"/>", "uom": "<xsl:value-of select="$thisKPIUoM/own_slot_value[slot_reference = 'enumeration_value']/value"/>" }<xsl:if test="not(position() = last())">, </xsl:if>
	</xsl:template>

</xsl:stylesheet>
