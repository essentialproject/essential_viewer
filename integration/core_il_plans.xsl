<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>  
 
	<!-- START GENERIC PARAMETERS -->

	<!-- END GENERIC PARAMETERS -->
   <xsl:variable name="apiPathPlanAPI" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Import Planning Data']"/>
    
         
	<!--
		* Copyright © 2008-2025 Enterprise Architecture Solutions Limited.
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
  
	<xsl:template name="planData">
         <xsl:variable name="apiPathPlan">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathPlanAPI"/>
            </xsl:call-template>
        </xsl:variable>
        
        var viewAPIPlanData = '<xsl:value-of select="$apiPathPlan"/>'; 
        var planDataByType;
        Promise.all([
            promise_loadViewerAPIData(viewAPIPlanData)
            ]).then(function(planResponses) {  
               let planData = planResponses[0];
 
 
				function groupImpactsByEleTypeWithMeta(data) {
					console.log('groupImpactsByEleTypeWithMeta', data);
					// 1) Build a quick map of plan metadata by plan ID
					const planMeta = {};
					for (const p of data.allPlans || []) {
						planMeta[p.id] = {
							name: 	 p.name,
							id:	 p.id,
							planStart:  p.validStartDate,
							planEnd:    p.validEndDate,
							planStatus: p.planStatus
						};
					}

					// 2) Collate impacts by elementId
					const elemMap = {}; // { elemId: { elemId, eletype, plansMap: {}, projects: [] } }

					for (const plan of data.allPlans || []) {
						const planId   = plan.id;
						const planName = plan.name;
						const meta     = planMeta[planId] || {};
  
						for (const imp of plan.planP2E || []) {
							const elem = imp.impactedElement;
							if (!elem) continue;
							const type = imp.eletype || 'Unknown';
							if (!elemMap[elem]) {
								elemMap[elem] = { elemId: elem, eletype: type, plansMap: {}, projects: [] };
							}
							const entry = elemMap[elem];

							if (!entry.plansMap[planName]) {
								entry.plansMap[planName] = {
									action:     imp.action,
									planStart:  meta.planStart,
									planEnd:    meta.planEnd,
									planStatus: meta.planStatus, 
									className: 'Enterprise_Strategic_Plan',
									name: meta.name || planName,
									id: meta.id || planId,
									projects:   plan.projects || []
								};
							} else {
								const pe = entry.plansMap[planName];
								if (!Array.isArray(pe.action)) pe.action = [pe.action];
								if (!pe.action.includes(imp.action)) pe.action.push(imp.action);
								pe.planStart  = pe.planStart || meta.planStart;
								pe.planEnd    = pe.planEnd || meta.planEnd;
								pe.planStatus = pe.planStatus || meta.planStatus;
							}
						}
					}
				 
					for (const proj of data.allProject || []) {
			 
						const projName      = proj.name;
						const projId      = proj.id;

						const projectStart  = proj.actualStartDate;
						const projectEnd    = proj.forecastEndDate || proj.targetEndDate;
						const projectStatus = proj.lifecycleStatus;

						for (const imp of proj.p2e || []) {
							const elem = imp.impactedElement;
							
							if (!elem) continue;
							const type = imp.eletype || 'Unknown';
							if (!elemMap[elem]) {
								elemMap[elem] = { elemId: elem, eletype: type, plansMap: {}, projects: [] };
							}
							const entry = elemMap[elem];

							// flat project list
							const projData = {
								name:      projName,
								id:		projId,
								description: proj.description,
								action:       imp.action,
								className: 'Project',
								projectStart,
								projectEnd,
								projectStatus
							};
							entry.projects.push(projData);
							const matchingFlat = entry.projects.find(p => p.project === projName &amp;&amp; p.action === imp.action);
							if (matchingFlat) {
								matchingFlat.linkedToPlan = true;
							}

							// nested under its plan if present
							const pe = Object.values(entry.plansMap).find(p => p.plan === imp.plan || imp.plan?.includes(p.plan));
							if (pe) {
								pe.projects.push(projData);
							}
						}
					}

					

					// 3) Convert to grouped by eletype
					const groups = {}; // { eletype: { elemId: { plans, projects } } }
					for (const elemId in elemMap) {
						const { eletype, plansMap, projects } = elemMap[elemId];
						if (!groups[eletype]) groups[eletype] = {};
						const plans = Object.entries(plansMap).map(([plan, info]) => ({
							plan,
							name: info.name,
							id:   info.id,
							planStart:  info.planStart,
							planEnd:    info.planEnd,
							planStatus: info.planStatus,
							className: 'Enterprise_Strategic_Plan',
							projects:   info.projects
						}));
						groups[eletype][elemId] = { plans, projects };
					}

					return groups;
				}


				// Usage:  planDataByType[TYPE][ELEMENT_ID]
				planDataByType = groupImpactsByEleTypeWithMeta(planData);
 
            })
		 

	 </xsl:template>

</xsl:stylesheet>
