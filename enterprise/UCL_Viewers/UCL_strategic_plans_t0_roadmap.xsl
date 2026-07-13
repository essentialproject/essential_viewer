<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"></xsl:include>
	<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
	<xsl:include href="../common/core_header.xsl"></xsl:include>
	<xsl:include href="../common/core_footer.xsl"></xsl:include>
	<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

	<xsl:param name="param1"></xsl:param>
	<xsl:param name="viewScopeTermIds"></xsl:param>

	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"></xsl:variable>
	<xsl:variable name="linkClasses" select="('Enterprise_Strategic_Plan', 'Business_Objective', 'Individual_Actor', 'Group_Actor')"></xsl:variable>

	<xsl:variable name="allESPs" select="/node()/simple_instance[type = 'Enterprise_Strategic_Plan']"></xsl:variable>
	<xsl:variable name="t0Plans" select="$allESPs[starts-with(own_slot_value[slot_reference = 'name']/value, '[T0')]"></xsl:variable>
	<xsl:variable name="excludedStatus" select="/node()/simple_instance[type = 'Planning_Status'][own_slot_value[slot_reference = 'name']/value = '0. Roadmap Idea (Outside DSP 25-32)']"></xsl:variable>
	<!-- exclude unwanted status AND plans with no start date -->
	<xsl:variable name="filteredPlans" select="$t0Plans[not(own_slot_value[slot_reference = 'strategic_plan_status']/value = $excludedStatus/name)][own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value != '']"></xsl:variable>
	<xsl:variable name="allPlanningStatus" select="/node()/simple_instance[type = 'Planning_Status']"></xsl:variable>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = ('Information_Architecture_Objective','Technology_Architecture_Objective','Application_Architecture_Objective','Business_Objective')]"></xsl:variable>
	<xsl:variable name="allSQValues" select="/node()/simple_instance[supertype = 'Service_Quality_Value']"></xsl:variable>
	<xsl:variable name="allServiceQualities" select="/node()/simple_instance[supertype = 'Service_Quality']"></xsl:variable>

	<!-- objectives keyed by the plan they support (slot is on the objective) -->
	<xsl:key name="objsByPlan" match="/node()/simple_instance[type = ('Information_Architecture_Objective','Technology_Architecture_Objective','Application_Architecture_Objective','Business_Objective')]" use="own_slot_value[slot_reference = 'objective_supported_by_strategic_plan']/value"></xsl:key>
	<xsl:key name="a2rByName" match="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION']" use="name"></xsl:key>
	<xsl:key name="actorsByRole" match="/node()/simple_instance[type = 'Individual_Actor' or type = 'Group_Actor']" use="own_slot_value[slot_reference = 'actor_plays_role']/value"></xsl:key>
	<xsl:key name="pmByElement" match="/node()/simple_instance[supertype = 'Performance_Measure']" use="own_slot_value[slot_reference = 'pm_measured_element']/value"></xsl:key>

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"></xsl:call-template>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
				<title>UCL T0 Strategic Plans Roadmap</title>
				<script src="js/vis/vis.js"></script>
				<link href="js/vis/vis.css" rel="stylesheet" type="text/css"></link>
				<style>
					.view-wrapper{padding:20px;margin-top:70px}
					#visualization{width:100%;min-height:900px;border:1px solid #ddd;border-radius:4px;margin-bottom:60px;}
				.roadmap-section{margin-bottom:80px;padding-bottom:40px}
					.section-title{font-size:18px;font-weight:bold;color:#333;margin:30px 0 15px 0;padding-bottom:8px;border-bottom:2px solid #500778}
					td,th{vertical-align:top !important}
					td:first-child{max-width:300px;width:25%}
					td:not(:first-child){font-size:12px}
					.pm-list,.sp-list{margin:0;padding-left:16px}
					.pm-item{margin-bottom:4px}
					.pm-value{display:inline-block;background:#eee;border-radius:3px;font-size:inherit;padding:1px 6px;margin-left:4px;color:#333}
					.plan-desc{font-size:12px;font-weight:normal;color:#555;margin-top:5px;overflow:hidden;display:-webkit-box;-webkit-line-clamp:6;-webkit-box-orient:vertical}
					.plan-desc.expanded{-webkit-line-clamp:unset;display:block}
					.desc-toggle{font-size:11px;color:#500778;cursor:pointer;margin-top:3px;display:inline-block}
					.desc-toggle:hover{text-decoration:underline}
					.vis-item{border-color:#500778 !important;background-color:#c8b2d8 !important;color:#333 !important;font-size:12px !important}
					.vis-item.vis-selected{border-color:#500778 !important;background-color:#500778 !important;color:#fff !important}
					.vis-label{font-size:13px;font-weight:bold;color:#500778}
				</style>
				<script type="text/javascript">
				var viewData = { plans: [
				<xsl:for-each select="$filteredPlans">
					<xsl:sort select="own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value" order="ascending"></xsl:sort>
					<xsl:variable name="pid" select="current()/name"></xsl:variable>
					<xsl:variable name="pname" select="replace(translate(current()/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"></xsl:variable>
					<xsl:variable name="pdesc" select="replace(replace(translate(current()/own_slot_value[slot_reference = 'description']/value, '&quot;&#xA;&#xD;', &quot;&apos;  &quot;), '&amp;', 'and'), '\\', '/')"></xsl:variable>
					<xsl:variable name="pstart" select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value"></xsl:variable>
					<xsl:variable name="pend" select="current()/own_slot_value[slot_reference = 'strategic_plan_valid_to_date_iso_8601']/value"></xsl:variable>
					<xsl:variable name="pstatusInst" select="$allPlanningStatus[name = current()/own_slot_value[slot_reference = 'strategic_plan_status']/value]"></xsl:variable>
					<xsl:variable name="pstatus" select="translate($pstatusInst/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;)"></xsl:variable>
					<xsl:variable name="thisObjs" select="key('objsByPlan', $pid)"></xsl:variable>
					<xsl:variable name="thisA2Rs" select="key('a2rByName', current()/own_slot_value[slot_reference = 'stakeholders']/value)"></xsl:variable>
					<xsl:variable name="thisActors" select="key('actorsByRole', $thisA2Rs/name)"></xsl:variable>
					<xsl:variable name="thisPMs" select="key('pmByElement', $pid)"></xsl:variable>
					<xsl:variable name="dependsOnPlans" select="$allESPs[name = current()/own_slot_value[slot_reference = 'depends_on_strategic_plans']/value]"></xsl:variable>
					{"id":"<xsl:value-of select="$pid"/>",
					"name":"<xsl:value-of select="$pname"/>",
					"description":"<xsl:value-of select="$pdesc"/>",
					"startDate":"<xsl:value-of select="$pstart"/>",
					"endDate":"<xsl:value-of select="$pend"/>",
					"status":"<xsl:value-of select="$pstatus"/>",
					"sponsors":[<xsl:for-each select="$thisActors">"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					"objectives":[<xsl:for-each select="$thisObjs">{"id":"<xsl:value-of select="name"/>","name":"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"}<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					"performanceMeasures":[<xsl:for-each select="$thisPMs">
						<xsl:variable name="thisSQVs" select="$allSQValues[name = current()/own_slot_value[slot_reference = 'pm_performance_value']/value]"></xsl:variable>
						{"name":"<xsl:value-of select="replace(translate(current()/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>",
						"date":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'pm_measure_date_iso_8601']/value"/>",
						"values":[<xsl:for-each select="$thisSQVs">
							<xsl:variable name="thisSQ" select="$allServiceQualities[name = current()/own_slot_value[slot_reference = 'usage_of_service_quality']/value]"></xsl:variable>
							{"quality":"<xsl:value-of select="replace(translate($thisSQ/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>",
							"value":"<xsl:value-of select="replace(translate(current()/own_slot_value[slot_reference = 'service_quality_value_value']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>",
							"score":"<xsl:value-of select="current()/own_slot_value[slot_reference = 'service_quality_value_score']/value"/>"}<xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>]}<xsl:if test="position() != last()">,</xsl:if>
					</xsl:for-each>],
					"dependsOnPlans":[<xsl:for-each select="$dependsOnPlans">"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
					}<xsl:if test="position() != last()">,</xsl:if>
				</xsl:for-each>
				]};

				$(document).ready(function(){
					renderTimeline();
					renderTable();
				});

				function renderTimeline(){
					var plans = viewData.plans;
					if(plans.length === 0){
						document.getElementById('visualization').innerHTML = '&lt;p style="padding:20px;color:#888;"&gt;No plans to display.&lt;/p&gt;';
						return;
					}

					var groupMap = {};
					var groupArr = [];
					var noObjId = '__none__';

					plans.forEach(function(plan){
						var objList = (plan.objectives &amp;&amp; plan.objectives.length &gt; 0) ? plan.objectives : [{id: noObjId, name: 'No Objective Mapped'}];
						objList.forEach(function(obj){
							if(!groupMap[obj.id]){
								groupMap[obj.id] = { id: obj.id, content: obj.name };
								groupArr.push(groupMap[obj.id]);
							}
						});
					});

					var items = [];
					var itemId = 0;
					plans.forEach(function(plan){
						var endDate = plan.endDate || plan.startDate;
						var sponsor = plan.sponsors.length &gt; 0 ? plan.sponsors.join(', ') : '';
						var tooltip = '&lt;strong&gt;' + plan.name + '&lt;/strong&gt;' +
							(sponsor ? '&lt;br&gt;Sponsor: ' + sponsor : '') +
							'&lt;br&gt;' + plan.startDate + ' to ' + endDate +
							(plan.status ? '&lt;br&gt;Status: ' + plan.status : '');
						var objList = (plan.objectives &amp;&amp; plan.objectives.length &gt; 0) ? plan.objectives : [{id: noObjId}];
						objList.forEach(function(obj){
							items.push({ id: itemId++, group: obj.id, content: plan.name, title: tooltip, start: plan.startDate, end: endDate });
						});
					});

					var options = {
						orientation: 'top',
						stack: true,
						showMajorLabels: true,
						showMinorLabels: true,
						zoomKey: 'ctrlKey',
						autoResize: true,
						verticalScroll: false,
						tooltip: { followMouse: true, overflowMethod: 'cap' },
						start: items.reduce(function(min, i){ return i.start &lt; min ? i.start : min; }, items[0].start),
						end: items.reduce(function(max, i){ return i.end &gt; max ? i.end : max; }, items[0].end)
					};

					new vis.Timeline(
						document.getElementById('visualization'),
						new vis.DataSet(items),
						new vis.DataSet(groupArr),
						options
					);
					console.log('Groups:', JSON.stringify(groupArr));
					console.log('All items:', JSON.stringify(items));
					console.log('Plan objectives check:', viewData.plans.map(function(p){ return p.name + ' -> ' + JSON.stringify(p.objectives); }));
				}

				function renderTable(){
					var plans = viewData.plans;
					if(plans.length === 0){ return; }
					var html = '&lt;table class="table table-bordered table-striped table-hover"&gt;';
					html += '&lt;thead&gt;&lt;tr&gt;&lt;th&gt;Plan Name&lt;/th&gt;&lt;th&gt;Status&lt;/th&gt;&lt;th&gt;Start Date&lt;/th&gt;&lt;th&gt;End Date&lt;/th&gt;&lt;th&gt;Sponsors&lt;/th&gt;&lt;th&gt;Benefits&lt;/th&gt;&lt;th&gt;DSP Metrics&lt;/th&gt;&lt;th&gt;Supports Plans&lt;/th&gt;&lt;/tr&gt;&lt;/thead&gt;&lt;tbody&gt;';
					plans.forEach(function(plan, idx){
						html += '&lt;tr&gt;';
						html += '&lt;td&gt;&lt;strong&gt;&lt;a href="report?XML=reportXML.xml&amp;PMA=' + plan.id + '&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=Strategic%20Plan%20Editor&amp;EDITOR=store_110_Class30000&amp;SECTION=" target="_blank"&gt;' + plan.name + '&lt;/a&gt;&lt;/strong&gt;';
						if(plan.description){
							html += '&lt;div class="plan-desc" id="desc-' + idx + '"&gt;' + plan.description + '&lt;/div&gt;';
							html += '&lt;span class="desc-toggle" onclick="toggleDesc(' + idx + ')"&gt;Show more&lt;/span&gt;';
						}
						html += '&lt;/td&gt;';
						html += '&lt;td&gt;' + (plan.status || '-') + '&lt;/td&gt;';
						html += '&lt;td&gt;' + (plan.startDate || '-') + '&lt;/td&gt;';
						html += '&lt;td&gt;' + (plan.endDate || '-') + '&lt;/td&gt;';
						html += '&lt;td&gt;' + (plan.sponsors.length &gt; 0 ? plan.sponsors.join('&lt;br&gt;') : '-') + '&lt;/td&gt;';
						if(plan.performanceMeasures.length &gt; 0){
							var benefits = plan.performanceMeasures.filter(function(pm){ return pm.name.split(' of ')[0].indexOf('Benefit') === 0; }).sort(function(a,b){ return a.name.localeCompare(b.name); });
							var dspMetrics = plan.performanceMeasures.filter(function(pm){ return pm.name.split(' of ')[0].indexOf('DSP') === 0; }).sort(function(a,b){ return a.name.localeCompare(b.name); });
							if(benefits.length &gt; 0){
								html += '&lt;td&gt;&lt;ul class="pm-list"&gt;';
								benefits.forEach(function(pm){
									var label = pm.name.split(' of ')[0].replace('Benefit - ', '').replace('Benefit -', '');
									html += '&lt;li class="pm-item"&gt;' + label;
									if(pm.values &amp;&amp; pm.values.length &gt; 0){
										pm.values.forEach(function(v){
											html += '&lt;span class="pm-value"&gt;' + v.value + (v.score ? ' (' + v.score + ')' : '') + '&lt;/span&gt;';
										});
									}
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;&lt;/td&gt;';
							} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
							if(dspMetrics.length &gt; 0){
								html += '&lt;td&gt;&lt;ul class="pm-list"&gt;';
								dspMetrics.forEach(function(pm){
									var label = pm.name.split(' of ')[0].replace('DSP - ', '').replace('DSP -', '');
									html += '&lt;li class="pm-item"&gt;' + label;
									if(pm.values &amp;&amp; pm.values.length &gt; 0){
										pm.values.forEach(function(v){
											html += '&lt;span class="pm-value"&gt;' + v.value + (v.score ? ' (' + v.score + ')' : '') + '&lt;/span&gt;';
										});
									}
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;&lt;/td&gt;';
							} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
						} else { html += '&lt;td&gt;-&lt;/td&gt;&lt;td&gt;-&lt;/td&gt;'; }
						if(plan.dependsOnPlans.length &gt; 0){
							html += '&lt;td&gt;&lt;ul class="sp-list"&gt;';
							plan.dependsOnPlans.forEach(function(n){ html += '&lt;li&gt;' + n + '&lt;/li&gt;'; });
							html += '&lt;/ul&gt;&lt;/td&gt;';
						} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
						html += '&lt;/tr&gt;';
					});
					html += '&lt;/tbody&gt;&lt;/table&gt;';
					document.getElementById('tableContent').innerHTML = html;
				}

				function toggleDesc(idx){
					var el = document.getElementById('desc-' + idx);
					var toggle = el.nextElementSibling;
					if(el.classList.contains('expanded')){
						el.classList.remove('expanded');
						toggle.textContent = 'Show more';
					} else {
						el.classList.add('expanded');
						toggle.textContent = 'Show less';
					}
				}
				</script>
			</head>
			<body>
				<xsl:call-template name="Heading"></xsl:call-template>
				<div class="view-wrapper container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1><span class="text-primary">UCL: </span><span class="text-darkgrey">T0 Strategic Plans Roadmap</span></h1>
							</div>
						</div>
					</div>
					<div class="row roadmap-section">
						<div class="col-xs-12">
							<p class="section-title">Roadmap grouped by Objective</p>
							<div id="visualization"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12">
							<p class="section-title">Plan Details - Performance Measures &amp; Supported Plans</p>
							<div id="tableContent"><p class="text-muted">Loading...</p></div>
						</div>
					</div>
				</div>
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
