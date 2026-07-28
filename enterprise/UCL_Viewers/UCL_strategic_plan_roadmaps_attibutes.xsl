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
	<xsl:variable name="roadmap1" select="/node()/simple_instance[name = 'store_39_Class230006']"></xsl:variable>
	<xsl:variable name="roadmap2" select="/node()/simple_instance[name = 'store_39_Class180050']"></xsl:variable>
	<xsl:variable name="roadmap3" select="/node()/simple_instance[name = 'store_39_Class160024']"></xsl:variable>
	<xsl:variable name="roadmap4" select="/node()/simple_instance[name = 'store_39_Class140000']"></xsl:variable>
	<xsl:variable name="allRoadmapPlanIds" select="$roadmap1/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value | $roadmap2/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value | $roadmap3/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value | $roadmap4/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value"></xsl:variable>
	<xsl:variable name="t0Plans" select="$allESPs[name = $allRoadmapPlanIds]"></xsl:variable>
	<xsl:variable name="excludedStatus" select="/node()/simple_instance[type = 'Planning_Status'][own_slot_value[slot_reference = 'name']/value = '0. Roadmap Idea (Outside DSP 25-32)']"></xsl:variable>
	<!-- exclude unwanted status AND plans with no start date -->
	<xsl:variable name="filteredPlans" select="$t0Plans[not(own_slot_value[slot_reference = 'strategic_plan_status']/value = $excludedStatus/name)][own_slot_value[slot_reference = 'strategic_plan_valid_from_date_iso_8601']/value != '']"></xsl:variable>
	<xsl:variable name="allPlanningStatus" select="/node()/simple_instance[type = 'Planning_Status']"></xsl:variable>
	<xsl:variable name="allObjectives" select="/node()/simple_instance[type = ('Information_Architecture_Objective','Technology_Architecture_Objective','Application_Architecture_Objective','Business_Objective')]"></xsl:variable>
	<xsl:variable name="allSQValues" select="/node()/simple_instance[supertype = 'Service_Quality_Value']"></xsl:variable>
	<xsl:variable name="allServiceQualities" select="/node()/simple_instance[supertype = 'Service_Quality']"></xsl:variable>
	<xsl:variable name="allP2E" select="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']"></xsl:variable>
	<xsl:variable name="allRisks" select="/node()/simple_instance[type = 'Risk']"></xsl:variable>
	<xsl:variable name="allApps" select="/node()/simple_instance[type = ('Application_Provider','Composite_Application_Provider')]"></xsl:variable>
	<xsl:variable name="allTechProds" select="/node()/simple_instance[type = 'Technology_Product']"></xsl:variable>
	<xsl:variable name="allPlanningActions" select="/node()/simple_instance[type = 'Planning_Action']"></xsl:variable>

	<xsl:key name="p2eByPlan" match="/node()/simple_instance[type = 'PLAN_TO_ELEMENT_RELATION']" use="own_slot_value[slot_reference = 'plan_to_element_plan']/value"></xsl:key>

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
				<title>UCL Digital Strategic Plan Initiatives by Roadmap</title>
				<script src="js/vis/vis.js"></script>
				<link href="js/vis/vis.css" rel="stylesheet" type="text/css"></link>
				<style>
					.view-wrapper{padding:20px;margin-top:70px;font-family:'DM Sans',sans-serif}
					.metric-box{border:1px solid #ddbdff;border-radius:6px;padding:15px 10px;background:#eedeff;box-shadow:0 2px 4px rgba(54,26,84,0.08)}
					.metric-number{font-size:36px;font-weight:bold;color:#361a54}
					.metric-label{font-size:13px;color:#361a54;margin-top:5px}
					.roadmap-filter{margin-bottom:20px}
					.roadmap-filter select{font-size:14px;padding:6px 12px;border:1px solid #361a54;border-radius:4px;color:#361a54;background:#fafafa}
					#visualization{width:100%;border:1px solid #ddbdff;border-radius:4px;margin-bottom:40px;}
				.roadmap-section{margin-bottom:40px;padding-bottom:20px}
					.section-title{font-size:18px;font-weight:bold;color:#361a54;margin:30px 0 15px 0;padding-bottom:8px;border-bottom:2px solid #993bff}
					td,th{vertical-align:top !important}
					td:first-child{max-width:300px;width:25%}
					td:not(:first-child){font-size:12px}
					th{background-color:#361a54 !important;color:#fafafa !important;font-size:12px}
					th[onclick]{user-select:none}
					th[onclick]:hover{background-color:#4a2570 !important}
					.pm-list,.sp-list{margin:0;padding-left:16px}
					.pm-item{margin-bottom:4px}
					.pm-value{display:inline-block;border-radius:3px;font-size:inherit;padding:1px 6px;margin-left:4px;color:#361a54}
					.plan-desc{font-size:12px;font-weight:normal;color:#555;margin-top:5px}
					.vis-item{border-color:#361a54 !important;background-color:#ddbdff !important;color:#361a54 !important;font-size:12px !important}
					.vis-item.vis-selected{border-color:#361a54 !important;background-color:#993bff !important;color:#fafafa !important}
					.vis-label{font-size:13px;font-weight:bold;color:#361a54}
					.page-header h1 .text-primary{color:#993bff}
					.page-header h1 .text-darkgrey{color:#361a54}
					a{color:#993bff}
					a:hover{color:#361a54}
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
					<xsl:variable name="thisP2Es" select="key('p2eByPlan', $pid)"></xsl:variable>
					<xsl:variable name="impactedElementIds" select="$thisP2Es/own_slot_value[slot_reference = 'plan_to_element_ea_element']/value"></xsl:variable>
					<xsl:variable name="impactedRisks" select="$allRisks[name = $impactedElementIds]"></xsl:variable>
					<xsl:variable name="impactedApps" select="$allApps[name = $impactedElementIds]"></xsl:variable>
					<xsl:variable name="impactedTechProds" select="$allTechProds[name = $impactedElementIds]"></xsl:variable>
					{"id":"<xsl:value-of select="$pid"/>",
					"roadmaps":[<xsl:if test="$roadmap1/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid">"technical"</xsl:if><xsl:if test="$roadmap1/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid and ($roadmap2/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid or $roadmap3/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid or $roadmap4/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid)">,</xsl:if><xsl:if test="$roadmap2/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid">"supporting"</xsl:if><xsl:if test="$roadmap2/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid and ($roadmap3/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid or $roadmap4/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid)">,</xsl:if><xsl:if test="$roadmap3/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid">"research"</xsl:if><xsl:if test="$roadmap3/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid and $roadmap4/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid">,</xsl:if><xsl:if test="$roadmap4/own_slot_value[slot_reference = 'roadmap_strategic_plans']/value = $pid">"education"</xsl:if>],
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
					"dependsOnPlans":[<xsl:for-each select="$dependsOnPlans">"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					<xsl:variable name="supportsPlans" select="$allESPs[name = current()/own_slot_value[slot_reference = 'supports_strategic_plan']/value]"></xsl:variable>
					"supportsPlans":[<xsl:for-each select="$supportsPlans">"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					"risks":[<xsl:for-each select="$impactedRisks"><xsl:variable name="thisP2E" select="$thisP2Es[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = current()/name]"></xsl:variable><xsl:variable name="changeAction" select="$allPlanningActions[name = $thisP2E/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"></xsl:variable>{"name":"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","change":"<xsl:value-of select="replace(translate($changeAction/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","rationale":"<xsl:value-of select="replace(replace(translate($thisP2E/own_slot_value[slot_reference = 'plan_to_element_rationale']/value, '&quot;&#xA;&#xD;', &quot;&apos;  &quot;), '&amp;', 'and'), '\\', '/')"
/>"}<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					"applications":[<xsl:for-each select="$impactedApps"><xsl:variable name="thisP2E" select="$thisP2Es[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = current()/name]"></xsl:variable><xsl:variable name="changeAction" select="$allPlanningActions[name = $thisP2E/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"></xsl:variable>{"name":"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","change":"<xsl:value-of select="replace(translate($changeAction/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","rationale":"<xsl:value-of select="replace(replace(translate($thisP2E/own_slot_value[slot_reference = 'plan_to_element_rationale']/value, '&quot;&#xA;&#xD;', &quot;&apos;  &quot;), '&amp;', 'and'), '\\', '/')"
/>"}<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>],
					"techProducts":[<xsl:for-each select="$impactedTechProds"><xsl:variable name="thisP2E" select="$thisP2Es[own_slot_value[slot_reference = 'plan_to_element_ea_element']/value = current()/name]"></xsl:variable><xsl:variable name="changeAction" select="$allPlanningActions[name = $thisP2E/own_slot_value[slot_reference = 'plan_to_element_change_action']/value]"></xsl:variable>{"name":"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","change":"<xsl:value-of select="replace(translate($changeAction/own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>","rationale":"<xsl:value-of select="replace(replace(translate($thisP2E/own_slot_value[slot_reference = 'plan_to_element_rationale']/value, '&quot;&#xA;&#xD;', &quot;&apos;  &quot;), '&amp;', 'and'), '\\', '/')"
/>"}<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>]
					}<xsl:if test="position() != last()">,</xsl:if>
				</xsl:for-each>
				]};

				/* All SR risks for coverage indicator */
				<xsl:variable name="srRisks" select="$allRisks[starts-with(own_slot_value[slot_reference = 'name']/value, 'SR')]"></xsl:variable>
				viewData.allSRRisks = [<xsl:for-each select="$srRisks"><xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"></xsl:sort>"<xsl:value-of select="replace(translate(own_slot_value[slot_reference = 'name']/value, '&quot;', &quot;&apos;&quot;), '&amp;', 'and')"/>"<xsl:if test="position() != last()">,</xsl:if></xsl:for-each>];

				/* Priority is extracted from performanceMeasures starting with 'Priority' same as Benefits/DSP */

				var currentSort = { column: 'startDate', direction: 'asc' };

				function getPriorityVal(plan){
					var val = '';
					if(plan.performanceMeasures.length &gt; 0){
						var priorityPMs = plan.performanceMeasures.filter(function(pm){ return pm.name.indexOf('Priority of') === 0; });
						if(priorityPMs.length &gt; 0 &amp;&amp; priorityPMs[0].values &amp;&amp; priorityPMs[0].values.length &gt; 0){
							priorityPMs[0].values.forEach(function(v){
								if(v.quality === 'DSP Priority'){ val = v.value || ''; }
							});
						}
					}
					return val;
				}

				function sortPlans(plans){
					var col = currentSort.column;
					var dir = currentSort.direction === 'asc' ? 1 : -1;
					return plans.slice().sort(function(a, b){
						var valA, valB;
						if(col === 'name'){ valA = a.name.toLowerCase(); valB = b.name.toLowerCase(); }
						else if(col === 'priority'){ valA = getPriorityVal(a).toLowerCase(); valB = getPriorityVal(b).toLowerCase(); }
						else if(col === 'status'){ valA = (a.status || '').toLowerCase(); valB = (b.status || '').toLowerCase(); }
						else if(col === 'startDate'){ valA = a.startDate || ''; valB = b.startDate || ''; }
						else if(col === 'endDate'){ valA = a.endDate || ''; valB = b.endDate || ''; }
						else if(col === 'sponsors'){ valA = a.sponsors.join(', ').toLowerCase(); valB = b.sponsors.join(', ').toLowerCase(); }
						else { valA = ''; valB = ''; }
						if(valA &lt; valB) return -1 * dir;
						if(valA &gt; valB) return 1 * dir;
						return 0;
					});
				}

				function handleSort(col){
					if(currentSort.column === col){
						currentSort.direction = currentSort.direction === 'asc' ? 'desc' : 'asc';
					} else {
						currentSort.column = col;
						currentSort.direction = 'asc';
					}
					renderTable();
				}

				function sortIndicator(col){
					if(currentSort.column !== col) return '';
					return currentSort.direction === 'asc' ? ' &#9650;' : ' &#9660;';
				}

				$(document).ready(function(){
					renderAll();
					$('#roadmapSelect').on('change', function(){ renderAll(); });
				});

				function getFilteredPlans(){
					var selected = document.getElementById('roadmapSelect').value;
					if(selected === 'all'){ return viewData.plans; }
					return viewData.plans.filter(function(plan){ return plan.roadmaps.indexOf(selected) !== -1; });
				}

				function renderAll(){
					renderMetrics();
					renderTimeline();
					renderTable();
				}

				function renderMetrics(){
					var plans = getFilteredPlans();
					var totalPlans = plans.length;
					var allRisks = [];
					var allAppsAndTech = [];
					plans.forEach(function(plan){
						plan.risks.forEach(function(r){ if(allRisks.indexOf(r.name) === -1){ allRisks.push(r.name); } });
						plan.applications.forEach(function(a){ if(allAppsAndTech.indexOf(a.name) === -1){ allAppsAndTech.push(a.name); } });
						plan.techProducts.forEach(function(t){ if(allAppsAndTech.indexOf(t.name) === -1){ allAppsAndTech.push(t.name); } });
					});
					var html = '&lt;div class="row" style="margin-bottom:20px;"&gt;';
					html += '&lt;div class="col-xs-3 text-center"&gt;&lt;div class="metric-box"&gt;&lt;div class="metric-number"&gt;' + totalPlans + '&lt;/div&gt;&lt;div class="metric-label"&gt;Strategic Plans&lt;/div&gt;&lt;/div&gt;&lt;/div&gt;';
					html += '&lt;div class="col-xs-6"&gt;&lt;div class="metric-box" style="text-align:left;padding:12px 16px;"&gt;&lt;div class="metric-label" style="margin-bottom:8px;font-weight:bold;"&gt;Strategic Risk Coverage&lt;/div&gt;';
					html += '&lt;div style="display:flex;flex-wrap:wrap;gap:6px;"&gt;';
					viewData.allSRRisks.forEach(function(risk){
						var count = 0;
						plans.forEach(function(plan){ if(plan.risks.some(function(r){ return r.name === risk; })){ count++; } });
						var bgColor = count &gt; 0 ? '#993bff' : '#eedeff';
						var textColor = count &gt; 0 ? '#fafafa' : '#999';
						html += '&lt;span style="display:inline-block;padding:4px 8px;border-radius:4px;font-size:11px;background:' + bgColor + ';color:' + textColor + ';"&gt;' + risk + ' (' + count + ')&lt;/span&gt;';
					});
					html += '&lt;/div&gt;&lt;/div&gt;&lt;/div&gt;';
					html += '&lt;div class="col-xs-3 text-center"&gt;&lt;div class="metric-box"&gt;&lt;div class="metric-number"&gt;' + allAppsAndTech.length + '&lt;/div&gt;&lt;div class="metric-label"&gt;Applications / Tech Products Impacted&lt;/div&gt;&lt;/div&gt;&lt;/div&gt;';
					html += '&lt;/div&gt;';
					document.getElementById('metricsContent').innerHTML = html;
				}

				function renderTimeline(){
					var plans = getFilteredPlans();
					var container = document.getElementById('visualization');
					container.innerHTML = '';
					if(plans.length === 0){
						container.innerHTML = '&lt;p style="padding:20px;color:#888;"&gt;No plans to display.&lt;/p&gt;';
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
						container,
						new vis.DataSet(items),
						new vis.DataSet(groupArr),
						options
					);
				}

				function renderTable(){
					var plans = sortPlans(getFilteredPlans());
					if(plans.length === 0){ document.getElementById('tableContent').innerHTML = ''; return; }
					var html = '&lt;table class="table table-bordered table-striped table-hover"&gt;';
					html += '&lt;thead&gt;&lt;tr&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'name\')"&gt;Plan Name' + sortIndicator('name') + '&lt;/th&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'priority\')"&gt;Priority' + sortIndicator('priority') + '&lt;/th&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'status\')"&gt;Status' + sortIndicator('status') + '&lt;/th&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'startDate\')"&gt;Start Date' + sortIndicator('startDate') + '&lt;/th&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'endDate\')"&gt;End Date' + sortIndicator('endDate') + '&lt;/th&gt;';
					html += '&lt;th style="cursor:pointer;" onclick="handleSort(\'sponsors\')"&gt;Sponsors' + sortIndicator('sponsors') + '&lt;/th&gt;';
					html += '&lt;th&gt;Benefits&lt;/th&gt;&lt;th&gt;DSP Metrics&lt;/th&gt;&lt;th&gt;Impacts&lt;/th&gt;&lt;th&gt;Supports&lt;/th&gt;&lt;th&gt;Depends On&lt;/th&gt;';
					html += '&lt;/tr&gt;&lt;/thead&gt;&lt;tbody&gt;';
					plans.forEach(function(plan){
						html += '&lt;tr&gt;';
						html += '&lt;td&gt;&lt;strong&gt;' + plan.name + '&lt;/strong&gt;';
						if(plan.description){
							html += '&lt;div class="plan-desc"&gt;' + plan.description + '&lt;/div&gt;';
						}
						html += '&lt;div style="margin-top:4px;"&gt;&lt;ul style="list-style:disc;padding-left:16px;margin:0;"&gt;&lt;li&gt;&lt;a href="report?XML=reportXML.xml&amp;PMA=' + plan.id + '&amp;cl=en-gb&amp;XSL=enterprise%2Fcore_el_strategic_plan_summary.xsl&amp;PAGEXSL=&amp;LABEL=Strategic+Plan+Summary+-' + plan.id + 'Link&amp;essscope=W10%253D" target="_blank" style="font-size:11px;color:#993bff;"&gt;View ' + plan.name + '&lt;/a&gt;&lt;/li&gt;';
						html += '&lt;li&gt;&lt;a href="report?XML=reportXML.xml&amp;PMA=' + plan.id + '&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;LABEL=Strategic%20Plan%20Editor&amp;EDITOR=store_110_Class30000&amp;SECTION=" target="_blank" style="font-size:11px;color:#993bff;"&gt;Edit ' + plan.name + '&lt;/a&gt;&lt;/li&gt;&lt;/ul&gt;&lt;/div&gt;';
						html += '&lt;/td&gt;';
						/* Priority column - same pattern as Benefits/DSP */
						var priorityVal = getPriorityVal(plan) || '-';
						html += '&lt;td&gt;' + priorityVal + '&lt;/td&gt;';
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
											html += '&lt;span class="pm-value" style="background:#eedeff;"&gt;' + v.value + (v.score ? ' (' + v.score + ')' : '') + '&lt;/span&gt;';
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
											html += '&lt;span class="pm-value" style="background:#eedeff;"&gt;' + v.value + (v.score ? ' (' + v.score + ')' : '') + '&lt;/span&gt;';
										});
									}
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;&lt;/td&gt;';
							} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
						} else { html += '&lt;td&gt;-&lt;/td&gt;&lt;td&gt;-&lt;/td&gt;'; }
						/* Impacts column - risks, applications, tech products with change action and rationale */
						var hasImpacts = (plan.risks.length &gt; 0 || plan.applications.length &gt; 0 || plan.techProducts.length &gt; 0);
						if(hasImpacts){
							html += '&lt;td&gt;';
							if(plan.risks.length &gt; 0){
								html += '&lt;strong style="font-size:11px;"&gt;Risks&lt;/strong&gt;&lt;ul class="pm-list"&gt;';
								plan.risks.forEach(function(r){
									html += '&lt;li&gt;' + r.name;
									if(r.change){ html += ' &lt;span class="pm-value" style="background:#eedeff;"&gt;' + r.change + '&lt;/span&gt;'; }
									if(r.rationale){ html += '&lt;div style="font-size:11px;color:#666;margin-top:2px;"&gt;' + r.rationale + '&lt;/div&gt;'; }
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;';
							}
							if(plan.applications.length &gt; 0){
								html += '&lt;strong style="font-size:11px;"&gt;Applications&lt;/strong&gt;&lt;ul class="pm-list"&gt;';
								plan.applications.forEach(function(a){
									html += '&lt;li&gt;' + a.name;
									if(a.change){ html += ' &lt;span class="pm-value" style="background:#eedeff;"&gt;' + a.change + '&lt;/span&gt;'; }
									if(a.rationale){ html += '&lt;div style="font-size:11px;color:#666;margin-top:2px;"&gt;' + a.rationale + '&lt;/div&gt;'; }
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;';
							}
							if(plan.techProducts.length &gt; 0){
								html += '&lt;strong style="font-size:11px;"&gt;Technology Products&lt;/strong&gt;&lt;ul class="pm-list"&gt;';
								plan.techProducts.forEach(function(t){
									html += '&lt;li&gt;' + t.name;
									if(t.change){ html += ' &lt;span class="pm-value" style="background:#eedeff;"&gt;' + t.change + '&lt;/span&gt;'; }
									if(t.rationale){ html += '&lt;div style="font-size:11px;color:#666;margin-top:2px;"&gt;' + t.rationale + '&lt;/div&gt;'; }
									html += '&lt;/li&gt;';
								});
								html += '&lt;/ul&gt;';
							}
							html += '&lt;/td&gt;';
						} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
						/* Supports column */
						if(plan.supportsPlans &amp;&amp; plan.supportsPlans.length &gt; 0){
							html += '&lt;td&gt;&lt;ul class="sp-list"&gt;';
							plan.supportsPlans.forEach(function(n){ html += '&lt;li&gt;' + n + '&lt;/li&gt;'; });
							html += '&lt;/ul&gt;&lt;/td&gt;';
						} else { html += '&lt;td&gt;-&lt;/td&gt;'; }
						/* Depends On column */
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
				</script>
			</head>
			<body>
				<xsl:call-template name="Heading"></xsl:call-template>
				<div class="view-wrapper container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1><span class="text-primary">UCL: </span><span class="text-darkgrey">Digital Strategic Plan Initiatives by Roadmap</span></h1>
							</div>
							<div style="margin-bottom:15px;">
								<a href="#section-roadmap" style="margin-right:15px;font-size:13px;">Jump to Roadmap</a>
								<a href="#section-plan-details" style="font-size:13px;">Jump to Plan Details</a>
							</div>
						</div>
					</div>
					<div class="row roadmap-filter">
						<div class="col-xs-12">
							<label for="roadmapSelect" style="font-size:14px;margin-right:10px;">Filter by Roadmap:</label>
							<select id="roadmapSelect">
								<option value="all">All Roadmaps</option>
								<option value="technical" selected="selected">Technology Capability - Initiatives</option>
								<option value="supporting">Supporting UCL - Initiatives</option>
								<option value="research">Research - Initiatives</option>
								<option value="education">Education - Initiatives</option>
							</select>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12">
							<div id="metricsContent"></div>
						</div>
					</div>
					<div class="row roadmap-section">
						<div class="col-xs-12">
							<p class="section-title" id="section-roadmap">Roadmap grouped by Objective</p>
							<div id="visualization"></div>
						</div>
					</div>
					<div class="row">
						<div class="col-xs-12">
							<p class="section-title" id="section-plan-details">Plan Details - Performance Measures &amp; Supported Plans</p>
							<div id="tableContent"><p class="text-muted">Loading...</p></div>
						</div>
					</div>
				</div>
				<xsl:call-template name="Footer"></xsl:call-template>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
