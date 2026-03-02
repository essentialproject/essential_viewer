<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
    
	<xsl:import href="../common/core_js_functions.xsl"/>
	<xsl:import href="../common/core_el_ref_model_include.xsl"/>
    <xsl:include href="../common/core_roadmap_functions.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
    <xsl:include href="../common/core_api_fetcher.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>

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
  
	<xsl:template match="knowledge_base">
	
		<html lang="en">
			<head>
				<xsl:call-template name="commonHeadContent"/>
				<meta name="viewport" content="width=device-width, initial-scale=1" />
				<meta charset="UTF-8" />
				<title>TEMPLATE</title>
				<!-- ANY LINKS TO JAVASCRIPT LIBRARIES-->
				<style>
					 :root{
            --bg-page: #f8fafc;
            --glass-bg: rgba(255, 255, 255, 0.75);
            --glass-stroke: rgba(255, 255, 255, 0.5);
            --ink: #0f172a;
            --muted: #64748b;
            --primary: #4f46e5;     /* indigo 600 */
            --primary-light: #818cf8; /* indigo 400 */
            --primary-soft: rgba(79, 70, 229, 0.08);
            --accent: #10b981;      /* emerald 500 */
            --accent-soft: rgba(16, 185, 129, 0.1);
            --danger: #ef4444;      /* red 500 */
            --danger-soft: rgba(239, 68, 68, 0.1);
            --info: #0ea5e9;        /* sky 500 */
            --warm: #f59e0b;        /* amber 500 */
            --ring: rgba(79, 70, 229, 0.2);
            --radius-lg: 24px;
            --radius-md: 16px;
            --radius-sm: 8px;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        }

        * { margin:0; padding:0; box-sizing:border-box; }

        html, body { 
            height:100%; 
            font-size: 14px; 
            scrollbar-gutter: stable; 
            background-color: var(--bg-page);
            font-family: "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: var(--ink);
        }

        .container {
            width: 100%;
            max-width: 1440px;
            margin: 20px auto;
            padding: 0;
            background: var(--glass-bg);
            border-radius: var(--radius-lg);
            border: 1px solid var(--glass-stroke);
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(12px) saturate(150%);
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white; 
            padding: 48px 24px; 
            text-align:center; 
            position: relative;
        }

        .header h1 { 
            font-size: 2.25rem; 
            font-weight: 800; 
            letter-spacing: -0.025em; 
            margin: 0;
        }
        .header p { 
            opacity: 0.9; 
            font-size: 1.1rem; 
            margin-top: 12px; 
            max-width: 600px; 
            margin-left: auto; 
            margin-right: auto;
        }

        .filter-toggle {
            position: absolute;
            right: 24px;
            top: 24px;
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(8px);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: var(--radius-md);
            padding: 12px 20px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s ease;
        }
        .filter-toggle:hover { 
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .slider-region { 
            padding: 24px 48px; 
            background: rgba(255, 255, 255, 0.4);
            border-bottom: 1px solid var(--glass-stroke);
        }

        .roadmap { 
            display: flex; 
            gap: 24px; 
            padding: 32px; 
            min-height: 700px; 
            align-items: stretch; 
            width: 100%; 
        }

        .column {
            background: rgba(255, 255, 255, 0.5);
            border-radius: var(--radius-md); 
            padding: 20px;
            border: 1px solid var(--glass-stroke);
            box-shadow: var(--shadow-md);
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .column.plans { flex: 2; min-width: 500px; position: relative; background: #fff; }

        .column-header { 
            text-align: left; 
            margin-bottom: 8px; 
            padding-bottom: 12px;
            border-bottom: 2px solid var(--glass-stroke);
        }
        .column-header h2 { 
            color: var(--ink); 
            font-size: 1.25rem; 
            font-weight: 800; 
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .capability-box {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: var(--radius-md); 
            padding: 16px; 
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
            position: relative;
        }
        .capability-box:hover {
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }

        .l3head { 
            display: block;
            font-size: 1.1rem; 
            font-weight: 700; 
            color: var(--ink); 
            margin-bottom: 12px;
        }

        .app-list { 
            display: flex; 
            flex-wrap: wrap; 
            gap: 8px; 
        }

        .app {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
            transition: all 0.2s ease;
            cursor: default;
        }
        .app:hover { 
            background: #e2e8f0;
            transform: translateY(-1px);
            color: var(--ink);
        }

        .app--enhance { background: var(--accent-soft); color: #065f46; border-color: #a7f3d0; }
        .app--new { background: #059669; color: white; border-color: #059669; }
        .app--removal { background: var(--danger-soft); color: #991b1b; border-color: #fecaca; }

        .timeline-container { 
            position: relative; 
            flex: 1;
            min-height: 500px;
            background: #fcfdfe;
            border-radius: var(--radius-sm); 
            padding: 40px 0 20px; 
            border: 1px solid #f1f5f9; 
            overflow-x: hidden;
            overflow-y: auto;
        }

        .timeline-top-labels {
            position: absolute; 
            left: 0; right: 0; top: 0; 
            height: 40px; 
            border-bottom: 1px solid #f1f5f9;
            background: #f8fafc;
            z-index: 5;
        }
        .timeline-top-labels span {
            position: absolute; 
            transform: translateX(-50%); 
            font-size: 0.75rem; 
            font-weight: 700;
            color: var(--muted); 
            white-space: nowrap;
            top: 12px;
        }

        .timeline-vline {
            position: absolute; 
            top: 40px; bottom: 0; 
            width: 1px; 
            background: #f1f5f9;
            pointer-events: none;
        }
        .timeline-vline--today {
            background: var(--danger);
            width: 2px;
            z-index: 4;
            opacity: 0.5;
        }

        .plan-chevron {
            background: #e0e7ff;
            color: #3730a3; 
            padding: 0 16px; 
            margin: 4px 0; 
            border-radius: var(--radius-sm); 
            cursor: pointer; 
            position: absolute; 
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); 
            height: 48px; 
            display: flex; 
            align-items: center; 
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
            border: 1px solid #c7d2fe;
            z-index: 3;
        }
        .plan-chevron:hover {
            transform: scale(1.02);
            z-index: 10;
            box-shadow: var(--shadow-md);
            border-color: var(--primary);
        }
        .plan-chevron.active { 
            background: var(--primary); 
            color: white; 
            border-color: var(--primary);
            box-shadow: var(--shadow-lg);
        }

        .plan-chevron h4 { 
            font-size: 0.85rem; 
            font-weight: 700; 
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .plan-highlight-btn {
            width: 20px;
            height: 20px;
            border-radius: 4px;
            border: 1px solid rgba(0,0,0,0.1);
            background: white;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .plan-highlight-btn.active {
            background: var(--accent);
            color: white;
            border-color: var(--accent);
        }

        .plan-dates { 
            font-size: 0.7rem; 
            opacity: 0.8; 
            position: absolute;
            bottom: 4px;
            left: 16px;
        }

        .slider-bar {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .playback-btn {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            border: none;
            background: var(--primary);
            color: white;
            font-size: 1.25rem;
            cursor: pointer;
            box-shadow: var(--shadow-md);
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .playback-btn:hover { transform: scale(1.1); background: #4338ca; }
        .playback-btn.is-playing { background: var(--danger); }

        .slider-track-wrap { position: relative; flex: 1; padding: 10px 0; }
        
        #target-slider {
            -webkit-appearance: none;
            width: 100%;
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            outline: none;
        }
        #target-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 24px;
            height: 24px;
            background: white;
            border: 2px solid var(--primary);
            border-radius: 50%;
            cursor: pointer;
            box-shadow: var(--shadow-md);
            transition: all 0.2s ease;
        }
        #target-slider::-webkit-slider-thumb:hover { transform: scale(1.2); }

        .today-dot {
            position: absolute;
            top: 50%;
            transform: translate(-50%, -50%);
            width: 12px;
            height: 12px;
            background: var(--danger);
            border: 2px solid white;
            border-radius: 50%;
            z-index: 2;
        }

        .tick-labels-pos {
            position: absolute;
            top: 28px;
            left: 0; right: 0;
            height: 20px;
        }
        .tick-labels-pos span {
            position: absolute;
            transform: translateX(-50%);
            font-size: 0.7rem;
            font-weight: 600;
            color: var(--muted);
        }

        .plan-drawer {
            position: fixed;
            top: 0; right: -450px;
            width: 420px;
            height: 100%;
            background: white;
            box-shadow: -10px 0 30px rgba(0,0,0,0.1);
            transition: right 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1100;
            display: flex;
            flex-direction: column;
        }
        .plan-drawer.is-visible { right: 0; }
        .plan-drawer__header {
            padding: 24px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .plan-drawer__title { font-size: 1.5rem; font-weight: 800; margin: 0; }
        .plan-drawer__body { padding: 24px; overflow-y: auto; flex: 1; }
        .plan-drawer__section-title { 
            font-size: 1.1rem; 
            font-weight: 800; 
            margin: 24px 0 12px; 
            padding-bottom: 8px;
            border-bottom: 1px solid #e2e8f0;
        }
        .plan-drawer__meta { margin-bottom: 12px; font-size: 0.95rem; line-height: 1.5; }
        .plan-drawer__meta strong { color: var(--muted); display: block; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; }

        .filter-panel {
            position: fixed;
            top: 0; left: -350px;
            width: 320px;
            height: 100%;
            background: white;
            box-shadow: 10px 0 30px rgba(0,0,0,0.1);
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1200;
            display: flex;
            flex-direction: column;
        }
        .filter-panel.is-open { left: 0; }

        .filter-panel__header {
            padding: 24px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .filter-panel__header h3 { font-size: 1.25rem; font-weight: 800; margin: 0; color: var(--ink); }
        .filter-panel__close {
            background: none;
            border: none;
            font-size: 1.25rem;
            color: var(--muted);
            cursor: pointer;
            padding: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }
        .filter-panel__close:hover { color: var(--danger); transform: scale(1.1); }
        
        .filter-panel__body {
            padding: 32px 24px;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 32px;
            overflow-y: auto;
        }

        .app.highlighted-app { 
            background: var(--primary); 
            color: white; 
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--ring);
            transform: scale(1.1);
        }
        .app.dimmed { opacity: 0.3; filter: grayscale(1); }

        .plan-drawer__backdrop {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(4px);
            z-index: 1090;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
        }
        .plan-drawer__backdrop.is-visible {
            opacity: 1;
            pointer-events: auto;
        }

        @media (max-width: 1200px) {
            .roadmap { flex-direction: column; }
            .column.plans { min-width: auto; }
        }
				</style>
			</head>
			<body role="document" aria-labelledby="main-heading">
				
				
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>
				
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1 id="main-heading">
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Strategic Plan - Capability Impacts</span><xsl:text> </xsl:text>:<xsl:text> </xsl:text>
                  <span id="capName"/>
								</h1>
							</div>
						</div>
					<div class="container" id="app"></div>
            <div id="plan-drawer" class="plan-drawer" aria-hidden="true">
              <div class="plan-drawer__header">
                  <h3 class="plan-drawer__title">Strategic Plan</h3>
                  <button type="button" id="plan-drawer-close" class="plan-drawer__close" aria-label="Close plan details"><i class="fa fa-times"></i></button>
              </div>
              <div id="plan-drawer-content" class="plan-drawer__body"></div>
            </div>
            <div id="plan-drawer-backdrop" class="plan-drawer__backdrop" aria-hidden="true"></div>

            <!-- Handlebars Template -->
          <script id="roadmap-template" type="text/x-handlebars-template">
<xsl:text disable-output-escaping="yes"><![CDATA[
            <div id="filter-panel" class="filter-panel" aria-hidden="true">
              <div class="filter-panel__header">
                <h3>Filters &amp; Legend</h3>
                <button id="filter-panel-close" class="filter-panel__close" type="button" aria-label="Close filters"><i class="fa fa-times"></i></button>
              </div>
              <div class="filter-panel__body">
                <div class="filter-bar" style="display:flex; flex-direction:column; gap:32px;">
                  <div style="padding:4px 0;">
                    <label for="l2-select" style="font-weight:700; color:var(--muted); font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; display:block; margin-bottom:12px;">Focus Capability</label>
                    <select id="l2-select" style="width:100%; padding:12px; border-radius:var(--radius-sm); border:1px solid #e2e8f0; background:white; font-weight:600; font-family:inherit; box-shadow:var(--shadow-sm);">
                      {{#each l2Options}}
                        <option value="{{id}}">{{name}}</option>
                      {{/each}}
                    </select>
                  </div>
                  
                  <div style="display:flex; align-items:center; gap:12px; background:#f8fafc; padding:16px; border-radius:var(--radius-sm); border:1px solid #e2e8f0;">
                      <input id="lower-toggle" type="checkbox" style="width:18px; height:18px; cursor:pointer;" {{#if includeLowerLevel}}checked{{/if}}></input> 
                      <label for="lower-toggle" style="font-weight:600; cursor:pointer; margin:0;">Show Level 4 Capabilities</label>
                  </div>
                </div>

                <div class="legend-key" style="margin-top:auto; background:#f8fafc; border:1px solid #e2e8f0; border-radius:var(--radius-sm); padding:20px;">
                  <h4 style="font-size:0.75rem; text-transform:uppercase; letter-spacing:1px; color:var(--muted); margin-bottom:16px;">App Lifecycle Key</h4>
                  <ul style="list-style:none; padding:0; display:flex; flex-direction:column; gap:12px;">
                    <li style="display:flex; align-items:center; gap:10px; font-size:0.9rem;"><span class="app app--removal" style="width:16px; height:16px; padding:0;"></span> Removed / Decommissioned</li>
                    <li style="display:flex; align-items:center; gap:10px; font-size:0.9rem;"><span class="app app--enhance" style="width:16px; height:16px; padding:0;"></span> Enhanced / Impacted</li>
                    <li style="display:flex; align-items:center; gap:10px; font-size:0.9rem;"><span class="app app--new" style="width:16px; height:16px; padding:0;"></span> New Application</li>
                  </ul>
                </div>
              </div>
            </div>
            <div id="filter-panel-backdrop" class="plan-drawer__backdrop" aria-hidden="true" style="z-index:1190;"></div>

            <div class="slider-region">
              <div class="slider-bar">
                <button id="playback-btn" class="playback-btn" type="button" title="Play animation">
                  <i class="fa fa-play"></i>
                </button>
                <div style="display:flex; flex-direction:column; gap:4px; min-width:120px;">
                    <span style="font-weight:800; color:var(--primary); font-size:1.1rem;">TIME HORIZON</span>
                    <span id="target-date-display" style="font-size:0.85rem; color:var(--muted); font-weight:600;">{{targetDateISO}}</span>
                </div>
                <div class="slider-track-wrap">
                  <input id="target-slider" type="range" min="0" max="60" step="1" value="{{targetOffsetMonths}}"></input>
                      
                  <div class="today-dot" aria-hidden="true" style="left: {{todayPct}}%"></div>
                  
                  <div class="tick-labels-pos">
                    {{#each yearTicks}}
                      <span style="left: {{pct}}%">{{label}}</span>
                    {{/each}}
                  </div>
                </div>
                <button id="filter-panel-toggle" class="filter-toggle" type="button" style="position:static; transform:none; background:white; color:var(--primary); border-color:#e2e8f0; box-shadow:var(--shadow-sm);">
                  <i class="fa fa-sliders"></i> <span>FILTERS</span>
                </button>
              </div>
            </div>

            <div class="roadmap">
                <!-- Column 1: Current State -->
                <div class="column current-state">
                    <div class="column-header">
                        <h2>Current State</h2> 
                    </div>
                     
                    {{#each currentL3}}
                      <div class="capability-box" data-capability="{{id}}">
                        <span class="l3head">{{name}}</span>
                        <div class="app-list">
                          {{#each apps}}
                            <span data-app="{{id}}" class="app {{className}}" title="{{id}}">{{name}}</span>
                          {{/each}}
                        </div>
                        {{#if ../includeLowerLevel}}
                          {{#if subCaps.length}}
                            <div style="margin-top:16px; padding-top:12px; border-top:1px dashed #e2e8f0; display:flex; flex-direction:column; gap:12px;">
                              {{#each subCaps}}
                                <div style="background:#f8fafc; border-radius:var(--radius-sm); padding:10px; border:1px solid #f1f5f9;">
                                  <h4 style="font-size:0.8rem; font-weight:700; color:var(--muted); margin-bottom:8px; text-transform:uppercase;">{{name}}</h4>
                                  <div class="app-list">
                                    {{#each apps}}
                                      <span data-app="{{id}}" class="app {{className}}" title="{{id}}">{{name}}</span>
                                    {{/each}}
                                  </div>
                                </div>
                              {{/each}}
                            </div>
                          {{/if}}
                        {{/if}}
                      </div>
                    {{/each}}
                </div>

                <!-- Column 2: Strategic Plans -->
                <div class="column plans">
                    <div class="column-header">
                        <h2>Strategic Roadmap</h2> 
                    </div>
                    <div class="timeline-container" id="timeline-container">
                    {{#if plans.length}}
                          <div class="timeline-top-labels">
                              {{#each timelineTicks}}
                              <span style="left: {{pct}}%">{{label}}</span>
                              {{/each}}
                          </div>
                          {{#each timelineTicks}}
                              <div class="timeline-vline" style="left: {{pct}}%"></div>
                          {{/each}}
                          
                          <!-- Today vertical line -->
                          <div class="timeline-vline timeline-vline--today" style="left: {{todayPct}}%"></div>

                          {{#each plansDetail}}
                              <div class="plan-chevron" role="button" data-plan-id="{{id}}" aria-label="View details for plan {{name}}" style="left: {{leftPct}}%; width: {{widthPct}}%; top: {{topPx}}px;">
                                  <h4> 
                                    <button class="plan-highlight-btn" type="button" title="Toggle impacted highlights"><i class="fa fa-bolt"></i></button>
                                    {{name}} 
                                  </h4>
                                  <div class="plan-dates">{{clampedStartISO}} → {{clampedEndISO}}</div>
                              </div>
                          {{/each}}
                    {{else}}
                        <div style="display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; color:var(--muted); gap:16px; opacity:0.6;">
                          <i class="fa fa-map-o" style="font-size:3rem;"></i>
                          <p style="font-weight:600;">No strategic plans referenced for this capability focus.</p>
                        </div>
                    {{/if}}
                    </div>
                </div>

                <!-- Column 3: Target State -->
                <div class="column target-state">
                    <div class="column-header">
                        <h2>Target State</h2> 
                    </div> 
                    {{#each targetL3}}
                      <div class="capability-box" data-capability="{{id}}">
                        <span class="l3head">{{name}}</span>
                        <div class="app-list">
                          {{#each apps}}
                            <span data-app="{{id}}" class="app {{className}}" title="{{id}}">{{name}}</span>
                          {{/each}}
                        </div>
                        {{#if ../includeLowerLevel}}
                          {{#if subCaps.length}}
                            <div style="margin-top:16px; padding-top:12px; border-top:1px dashed #e2e8f0; display:flex; flex-direction:column; gap:12px;">
                              {{#each subCaps}}
                                <div style="background:#f8fafc; border-radius:var(--radius-sm); padding:10px; border:1px solid #f1f5f9;">
                                  <h4 style="font-size:0.8rem; font-weight:700; color:var(--muted); margin-bottom:8px; text-transform:uppercase;">{{name}}</h4>
                                  <div class="app-list">
                                    {{#each apps}}
                                      <span data-app="{{id}}" class="app {{className}}" title="{{id}}">{{name}}</span>
                                    {{/each}}
                                  </div>
                                </div>
                              {{/each}}
                            </div>
                          {{/if}}
                        {{/if}}
                      </div>
                    {{/each}}
                </div>
            </div>
]]></xsl:text>
          </script>
          <script id="plan-detail-template" type="text/x-handlebars-template">
<xsl:text disable-output-escaping="yes"><![CDATA[
              <div class="plan-drawer__section">
                  <h4 class="plan-drawer__section-title">Overview</h4>
                  <div class="plan-drawer__meta"><strong>Plan Name</strong> {{name}}</div>
                  {{#if description}}
                  <div class="plan-drawer__meta"><strong>Description</strong> {{description}}</div>
                  {{/if}}
                  <div style="display:flex; gap:16px; margin-top:16px;">
                    <div class="plan-drawer__meta" style="flex:1;"><strong>Status</strong> <span style="display:inline-block; padding:4px 12px; border-radius:12px; background:var(--primary-soft); color:var(--primary); font-weight:700; font-size:0.8rem;">{{status}}</span></div>
                  </div>
                  <div style="display:flex; gap:16px; margin-top:8px;">
                    <div class="plan-drawer__meta" style="flex:1;"><strong>Start Date</strong> {{startDate}}</div>
                    <div class="plan-drawer__meta" style="flex:1;"><strong>End Date</strong> {{endDate}}</div>
                  </div>
              </div>

              <h4 class="plan-drawer__section-title">Supporting Projects</h4>
              {{#if projects.length}}
              <div style="display:flex; flex-direction:column; gap:12px;">
                  {{#each projects}}
                  <div style="background:#f8fafc; border-radius:var(--radius-sm); padding:16px; border:1px solid #e2e8f0;">
                      <div style="display:flex; justify-content:space-between; align-items:start; margin-bottom:8px;">
                        <strong style="font-size:1rem; color:var(--ink);">{{name}}</strong>
                        {{#if status}} <span style="font-size:0.7rem; font-weight:800; padding:2px 8px; border-radius:4px; background:#e2e8f0; color:#475569;">{{status}}</span>{{/if}}
                      </div>
                      <div style="font-size:0.85rem; color:var(--muted);">
                        <i class="fa fa-calendar-o"></i> {{#if startDate}}{{startDate}}{{else}}n/a{{/if}} — {{#if endDate}}{{endDate}}{{else}}n/a{{/if}}
                      </div>
                  </div>
                  {{/each}}
              </div>
              {{else}}
              <div style="text-align:center; padding:24px; color:var(--muted); background:#f8fafc; border-radius:var(--radius-sm); border:1px dashed #e2e8f0;">No supporting projects recorded</div>
              {{/if}}

              <h4 class="plan-drawer__section-title">Impacted Elements</h4>
              {{#if impactedCapabilities.length}}
                {{#each impactedCapabilities}}
                <div style="display:flex; align-items:center; gap:12px; padding:12px; border-radius:var(--radius-sm); border:1px solid #f1f5f9; margin-bottom:8px;">
                   <div style="width:8px; height:8px; border-radius:50%; background:var(--primary-light);"></div>
                   <div style="flex:1;">
                      <div style="font-weight:700;">{{name}}</div>
                      <div style="font-size:0.75rem; color:var(--muted);">{{type}} • {{action}}</div>
                   </div>
                </div>
                {{/each}}
              {{/if}}

              {{#if impactedApplications.length}}
                {{#each impactedApplications}}
                <div style="display:flex; align-items:center; gap:12px; padding:12px; border-radius:var(--radius-sm); border:1px solid #f1f5f9; margin-bottom:8px;">
                   <div style="width:8px; height:8px; border-radius:50%; background:var(--accent);"></div>
                   <div style="flex:1;">
                      <div style="font-weight:700;">{{name}}</div>
                      <div style="font-size:0.75rem; color:var(--muted);">{{type}} • {{action}}</div>
                   </div>
                </div>
                {{/each}}
              {{/if}}

              {{#unless impactedCapabilities.length}}
                {{#unless impactedApplications.length}}
                  <div style="text-align:center; padding:24px; color:var(--muted); background:#f8fafc; border-radius:var(--radius-sm); border:1px dashed #e2e8f0;">No direct impacts recorded</div>
                {{/unless}}
              {{/unless}}
]]></xsl:text>
          </script>
						<!--Setup Closing Tags-->
					</div>
				</div>

			            <script type="text/javascript">
                    <xsl:call-template name="RenderViewerAPIJSFunction"/>	
                 
					<!-- DEFINE YOUR VARIABLES - If GPT doesn't provide then just replicate the apiList names-->
					let appMartAPI, infoMartAPI, ImpTechProdApi, planDataAPI;
 

$(document).ready(function() {
  apiList = ['busCapAppMartCaps', 'busCapAppMartApps', 'planChangsSys', 'planDataAPI'];

  async function executeFetchAndRender() {
    try {

      let responses = await fetchAndRenderData(apiList);
      ({ busCapAppMartCaps, busCapAppMartApps, planChangsSys, planDataAPI } = responses);

      console.log('responses', responses);

      // ---------------- Build lookups ----------------
      // A) Capability detailsand hierarchy
      const capDetailsArr = (busCapAppMartCaps &amp;&amp;busCapAppMartCaps.busCaptoAppDetails) ? busCapAppMartCaps.busCaptoAppDetails : [];
      const capNameById = new Map();
      const capToAppIds = new Map();
      for (const cd of capDetailsArr) {
        if (!cd || !cd.id) continue;
        if (cd.name) capNameById.set(cd.id, cd.name);
        const listA = Array.isArray(cd.apps) ? cd.apps : [];
        const listB = Array.isArray(cd.thisapps) ? cd.thisapps : [];
        const appIds = Array.from(new Set([...listA, ...listB].filter(Boolean)));
        capToAppIds.set(cd.id, appIds);
      }

      const rawHierarchy = busCapAppMartCaps &amp;&amp;busCapAppMartCaps.busCapHierarchy;
      const roots = Array.isArray(rawHierarchy) ? rawHierarchy : (rawHierarchy ? [rawHierarchy] : []);

      // Build cap index and parent map for roll-ups
      const capById = new Map();
      const capParent = new Map(); // childCapId -> parentCapId
      (function indexCaps(nodes, parentId = null){
        (nodes || []).forEach(n => {
          if (!n || !n.id) return;
          capById.set(n.id, n);
          if (parentId) capParent.set(n.id, parentId);
          const kids = Array.isArray(n.childrenCaps) ? n.childrenCaps : [];
          indexCaps(kids, n.id);
        });
      })(roots, null);

      function allAncestors(capId){
        const out = [];
        let cur = capId;
        while (capParent.has(cur)){
          const p = capParent.get(cur);
          if (p) out.push(p);
          cur = p;
        }
        return out;
      }

      // Also ingest names present in hierarchy for quick fallback
      function ingestNamesFromTree(node) {
        if (!node) return;
        if (node.id &amp;&amp;node.name &amp;&amp;!capNameById.has(node.id)) capNameById.set(node.id, node.name);
        const kids = Array.isArray(node.childrenCaps) ? node.childrenCaps : [];
        for (const k of kids) ingestNamesFromTree(k);
      }
      roots.forEach(ingestNamesFromTree);

      // B) Applications (names + capability mapping via roles/services)
      const apps = (busCapAppMartApps &amp;&amp;busCapAppMartApps.applications) || [];
      const appById = new Map();
      const appIdToCapIds = new Map();
      for (const app of apps) {
        if (!app || !app.id) continue;
        appById.set(app.id, { id: app.id, name: app.name || '' });

        const roles = Array.isArray(app.allServices) ? app.allServices : [];
        const capSet = new Set();
        for (const role of roles) {
          const rCaps = Array.isArray(role &amp;&amp;role.capabilities) ? role.capabilities : [];
          rCaps.forEach(cid => { if (cid) capSet.add(cid); });
        }
        appIdToCapIds.set(app.id, Array.from(capSet));
      }

      // Helper: apps for a capability (IDs from capToAppIds, resolve to {id,name}), duplicate-safe and name-sorted
      function appsForCap(capId) {
        const ids = capToAppIds.get(capId) || [];
        const seen = new Set();
        const out = [];
        for (const id of ids) {
          if (!id || seen.has(id)) continue;
          const app = appById.get(id);
          if (app) {
            seen.add(id);
            out.push(app);
          }
        }
        // Optional: stable alphabetical sort by name
        out.sort((a, b) => (a.name || '').localeCompare(b.name || ''));
        return out;
      }

      // ---------------- Collect plan impacts from planChangsSys.plans -> changesByCap ----------------
      const plans = (planChangsSys &amp;&amp; Array.isArray(planChangsSys.plans)) ? planChangsSys.plans : [];
      // Enterprise Strategic Plans (ESP) - accept flexible shapes
      const stratPlansRaw = (planDataAPI &amp;&amp; (
        Array.isArray(planDataAPI) ? planDataAPI
                                   : (planDataAPI.allPlans || planDataAPI.plans || [])
      )) || [];
      const stratPlans = Array.isArray(stratPlansRaw) ? stratPlansRaw : [];
      // Fast lookup for plan metadata (name, valid dates) by id
      const stratPlanById = new Map();
      for (const sp of stratPlans) {
        if (sp &amp;&amp; sp.id) stratPlanById.set(sp.id, sp);
      }
      const changesByCap = new Map();
      
  
      function ensureCapBucket(capId) {
        if (!changesByCap.has(capId)) {
          changesByCap.set(capId, {
            id: capId,
            name: capNameById.get(capId) || '',
            changes: {
              applications: [],
              capabilities: []
            }
          });
        }
        return changesByCap.get(capId);
      }

      const toISO = (d) => (d ? new Date(d).toISOString().slice(0,10) : null);
      const changeKey = (c) => [c.type, c.targetId || '', c.actionId || '', c.planId || '', c.endDate || ''].join('|');

      function addChangeToCap(capId, change){
        const bucket = ensureCapBucket(capId);
        const changeType = change.type === 'Application' ? 'applications' : 'capabilities';
        const changesArray = bucket.changes[changeType];
        const seen = new Set(changesArray.map(changeKey));
        const k = changeKey(change);
        if (!seen.has(k)){
          changesArray.push(change);
          changesArray.sort((a,b)=>{
            if (!a.endDate &amp;&amp; !b.endDate) return 0;
            if (!a.endDate) return 1;
            if (!b.endDate) return -1;
            return a.endDate.localeCompare(b.endDate);
          });
        }
      }

      function rollUpToAncestors(capId, change){
        addChangeToCap(capId, change);
        const ancestors = allAncestors(capId);
        ancestors.forEach(aid => addChangeToCap(aid, change));
      }

      // ---------- Ingest Enterprise Strategic Plans (ESP) ----------
      // We only map: Application-like targets via app->cap mapping, and Capability targets directly.
      // Other eletype values (e.g., Business_Process, Group_Actor, Technology_Product) are ignored here
      // unless there is an app/cap mapping available.
      (function ingestEnterprisePlans() {
        if (!stratPlans.length) return;

        const toISO = d => (d ? new Date(d).toISOString().slice(0,10) : null);
        const todayISO = toISO(new Date());

        // Local dedupe set across all plan injections to avoid duplicates by our changeKey logic
        const seenGlobal = new Set();

        function asAppChangeBase(sp, pe) {
          return {
            type: 'Application',
            targetId: pe.impactedElement || '',
            appName: (appById.get(pe.impactedElement || '') || {}).name || '',
            // tie back to plan and project
            planId: sp.id || null,
            planName: sp.name || '',
            projectId: pe.projectId || null,
            actionId: pe.actionid || null,
            actionType: pe.action || null,
            relation_description: pe.relation_description || '',
            // carry plan validity if present
            validStartDate: sp.validStartDate ? toISO(sp.validStartDate) : null,
            validEndDate: sp.validEndDate ? toISO(sp.validEndDate) : null,
            endDate: sp.validEndDate ? toISO(sp.validEndDate) : null
          };
        }

        function asCapChangeBase(sp, pe) {
          return {
            type: 'Capability',
            targetId: pe.impactedElement || '',
            // tie back to plan and project
            planId: sp.id || null,
            planName: sp.name || '',
            projectId: pe.projectId || null,
            actionId: pe.actionid || null,
            actionType: pe.action || null,
            relation_description: pe.relation_description || '',
            validStartDate: sp.validStartDate ? toISO(sp.validStartDate) : null,
            validEndDate: sp.validEndDate ? toISO(sp.validEndDate) : null,
            endDate: sp.validEndDate ? toISO(sp.validEndDate) : null
          };
        }

        function eletypeToKind(t) {
          if (!t) return null;
          if (t === 'Composite_Application_Provider' || t === 'Application_Provider' || t === 'Application') return 'Application';
          if (t === 'Business_Capability' || t === 'Capability') return 'Capability';
          return null;
        }

        for (const sp of stratPlans) {
          const p2e = Array.isArray(sp.planP2E) ? sp.planP2E : [];
          for (const pe of p2e) {
            const kind = eletypeToKind(pe.eletype);
            const targetId = pe.impactedElement;
            if (!targetId) continue;

            if (kind === 'Application') {
              // map application to capabilities via appIdToCapIds plus fallback against capToAppIds
              const mapped = appIdToCapIds.get(targetId) || [];
              let fallbackCaps = [];
              if (!mapped.length) {
                // fallback: scan capToAppIds once; use an index for O(1)
                // Build a reverse index lazily
                if (!window.__capReverseAppIndex) {
                  window.__capReverseAppIndex = new Map();
                  for (const [cid, ids] of capToAppIds.entries()) {
                    for (const aid of (ids || [])) {
                      if (!window.__capReverseAppIndex.has(aid)) window.__capReverseAppIndex.set(aid, new Set());
                      window.__capReverseAppIndex.get(aid).add(cid);
                    }
                  }
                }
                const setCaps = window.__capReverseAppIndex.get(targetId);
                fallbackCaps = setCaps ? Array.from(setCaps) : [];
              }
              const capIds = [...new Set([...(mapped || []), ...fallbackCaps])];
              const base = asAppChangeBase(sp, pe);

              for (const cid of capIds) {
                // Add to cap and roll up to ancestors
                rollUpToAncestors(cid, base);
              }
              continue;
            }

            if (kind === 'Capability') {
              // direct capability impact
              const base = asCapChangeBase(sp, pe);
              rollUpToAncestors(targetId, base);
              continue;
            }

            // Other kinds are currently not mappable with available indices – skip
          }
        }
      })();

      for (const p of plans){
        if (!p || !p.instId) continue;
        const endDate = toISO(p.end);
        // Enrich from Enterprise Strategic Plan metadata if available
        const spMeta = p.planId ? stratPlanById.get(p.planId) : null;
        const base = {
          actionId: p.actionId || null,
          actionType: p.actionType || null,
          planId: p.planId || null,
          planName: spMeta &amp;&amp; spMeta.name ? spMeta.name : null,
          roadmapIds: Array.isArray(p.roadmapIds) ? p.roadmapIds.slice() : [],
          changeActivityId: p.changeActivityId || null,
          // Keep original change end date and add plan validity window if present
          validStartDate: spMeta &amp;&amp; spMeta.validStartDate ? toISO(spMeta.validStartDate) : null,
          validEndDate: spMeta &amp;&amp; spMeta.validEndDate ? toISO(spMeta.validEndDate) : null,
          endDate
        };

        const targetId = p.instId;

        // If the instId is an Application we know about
        if (appById.has(targetId) || appIdToCapIds.has(targetId) || Array.from(capToAppIds.values()).some(appIds => appIds.includes(targetId))){
          const appInfo = appById.get(targetId) || { id: targetId, name: '' };
          const mappedCaps = appIdToCapIds.get(targetId) || [];

          // Get capabilities from service mappings
          let capIds = mappedCaps;
          
          // Always also check capToAppIds mapping as fallback/additional source
          const fallback = [];
          for (const [cid, ids] of capToAppIds.entries()){
            if (Array.isArray(ids) &amp;&amp; ids.indexOf(targetId) &gt; -1) fallback.push(cid);
          }
          
          // Combine both sources and remove duplicates
          const allCapIds = [...new Set([...capIds, ...fallback])];
          capIds = allCapIds;
 

          capIds.forEach(cid => {
            const change = Object.assign({ type: 'Application', targetId: appInfo.id, appName: appInfo.name || '' }, base);
            rollUpToAncestors(cid, change);
          });
          continue;
        }

        // If the instId is a Capability we know about
        if (capById.has(targetId)){
          const change = Object.assign({ type: 'Capability', targetId }, base);
          rollUpToAncestors(targetId, change);
          continue;
        }

        // Unknown target: ignore silently
      }

      // ---------------- Filter out removed applications ----------------
      // Helper function to get apps for a capability, filtering out removed applications
      function getFilteredAppsForCap(capId) {
        const ids = capToAppIds.get(capId) || [];
        const seen = new Set();
        const out = [];
        
        // Get the current date for comparison
        const today = new Date().toISOString().slice(0, 10);
        
        // Get changes for this capability to check for removals
        const capChanges = changesByCap.get(capId);
        const removedAppIds = new Set();
        
        if (capChanges &amp;&amp; capChanges.changes &amp;&amp; capChanges.changes.applications) {
          capChanges.changes.applications.forEach(change => {
            if (change.type === 'Application' &amp;&amp; 
                change.actionType === 'Removal Change' &amp;&amp; 
                change.endDate &amp;&amp; 
                change.endDate &lt;= today) {
              removedAppIds.add(change.targetId);
              }
          });
        }
        
        for (const id of ids) {
          if (!id || seen.has(id) || removedAppIds.has(id)) continue;
          const app = appById.get(id);
          if (app) {
            seen.add(id);
            out.push(app);
          }
        }
        // Optional: stable alphabetical sort by name
        out.sort((a, b) => (a.name || '').localeCompare(b.name || ''));
        return out;
      }

      // ---------------- Compose the combined structure with one more level (L2) ----------------
      function mapLevel2Children(level1Cap) {
        const level2 = Array.isArray(level1Cap.childrenCaps) ? level1Cap.childrenCaps : [];
        return level2.map(c2 => ({
          id: c2.id,
          name: c2.name || capNameById.get(c2.id) || '',
          apps: getFilteredAppsForCap(c2.id),
          changes: (changesByCap.get(c2.id) || { changes: { applications: [], capabilities: [] } }).changes
        }));
      }

      const combined = roots
        .filter(root => (root &amp;&amp;(root.level === '0' || root.level === 0 || root.level === undefined)))
        .map(root => {
          const level1 = Array.isArray(root.childrenCaps) ? root.childrenCaps : [];
          return {
            id: root.id,
            name: root.name || capNameById.get(root.id) || '',
            apps: getFilteredAppsForCap(root.id),
            changes: (changesByCap.get(root.id) || { changes: { applications: [], capabilities: [] } }).changes,
            childCaps: level1.map(c1 => ({
              id: c1.id,
              name: c1.name || capNameById.get(c1.id) || '',
              apps: getFilteredAppsForCap(c1.id),
              changes: (changesByCap.get(c1.id) || { changes: { applications: [], capabilities: [] } }).changes,
              childCaps: mapLevel2Children(c1) // one more level down (L2)
            }))
          };
        });

      // Expose for consumers
      window.busCapTop3WithAppsAndChanges = combined;
      console.log('Top 3 levels with apps + plan changes:', combined);

roadmapJSON = combined;
plansJSON = Array.isArray(planDataAPI) ? planDataAPI : ((planDataAPI &amp;&amp; planDataAPI.allPlans) ? planDataAPI.allPlans : ((planDataAPI &amp;&amp; planDataAPI.plans) ? planDataAPI.plans : []));
      //View CODE
console.log('plansJSON',plansJSON)

const today = new Date();
  const yearStart = new Date(today.getFullYear(), 0, 1); // 1 Jan of this year
  // show/hide lower (L4) sub-capabilities beneath each L3
  let includeLowerLevel = false;
  const APPLICATION_REGEX = /application/i;
  const CAPABILITY_REGEX = /capability/i;
  let planDetailTemplate;
  let initialRenderDone = false;
  let waitingForDomReady = false;
  let filterPanelKeyHandler = null;
  let currentL2Id = null;
  // months from 1 Jan to today (integer months)
  function monthsFromYearStart(date){
    return (date.getFullYear() - yearStart.getFullYear()) * 12 + (date.getMonth() - yearStart.getMonth());
  }

  // Target offset is now measured from 1 Jan this year (range 0..60)
  // Default remains +3 years from today
  let targetOffsetMonths = Math.min(60, monthsFromYearStart(today) + 36);
  let targetDate;    // computed from yearStart + offset
  let targetDateISO; // ISO string for display
  let latestRemovalIds = new Set();
  let latestRemovalCapIds = new Set();
  let playbackInterval = null;
  const PLAY_ICON = 'fa-play';
  const STOP_ICON = 'fa-stop';

  function stopPlayback() {
    if (playbackInterval) {
      clearInterval(playbackInterval);
      playbackInterval = null;
    }
    const btn = document.getElementById('playback-btn');
    if (btn) {
      btn.classList.remove('is-playing');
      const icon = btn.querySelector('i');
      if (icon) {
        icon.classList.remove(STOP_ICON);
        icon.classList.add(PLAY_ICON);
      }
    }
  }

  function startPlayback() {
    const btn = document.getElementById('playback-btn');
    if (btn) {
      btn.classList.add('is-playing');
      const icon = btn.querySelector('i');
      if (icon) {
        icon.classList.remove(PLAY_ICON);
        icon.classList.add(STOP_ICON);
      }
    }

    playbackInterval = setInterval(() => {
      targetOffsetMonths++;
      if (targetOffsetMonths > 60) {
        targetOffsetMonths = 0;
      }
      computeTargetDate();
      
      const slider = document.getElementById('target-slider');
      if (slider) {
        slider.value = targetOffsetMonths;
        render(currentL2Id);
      }
    }, 300); 
  }

  function togglePlayback() {
    if (playbackInterval) stopPlayback();
    else startPlayback();
  }

  function computeTargetDate(){
    const d = new Date(yearStart);
    d.setMonth(d.getMonth() + targetOffsetMonths);
    targetDate = d;
    targetDateISO = targetDate.toISOString().slice(0,10);
  }
  computeTargetDate();

  // ---------- SAFETY: normalise input to a root with childCaps (L2s) ----------
  function getRootFromRoadmap(){
    if(Array.isArray(window.roadmapJSON)){
      return { id:'root', name:'Capabilities', childCaps: window.roadmapJSON };
    }
    return window.capHierarchy || { id:'root', name:'Capabilities', childCaps: [] };
  }

  // ---------- HELPERS ----------
  function ensurePlanDetailTemplate(){
    if(!planDetailTemplate){
        const tplEl = document.getElementById('plan-detail-template');
        if(tplEl){
            planDetailTemplate = Handlebars.compile(tplEl.innerHTML);
        }
    }
    return planDetailTemplate;
  }

  function getPlanDrawerElements(){
    return {
        drawer: document.getElementById('plan-drawer'),
        backdrop: document.getElementById('plan-drawer-backdrop'),
        content: document.getElementById('plan-drawer-content')
    };
  }

  function buildPlanProjects(plan){
    const projectMap = new Map();
    if(Array.isArray(plan.projects)){
        plan.projects.forEach(prj => {
            if(!prj) return;
            const key = prj.id || prj.name;
            if(!key || projectMap.has(key)) return;
            projectMap.set(key, {
                id: key,
                name: prj.name || 'Unnamed project',
                startDate: prj.actualStartDate || prj.proposedStartDate || '',
                endDate: prj.forecastEndDate || prj.targetEndDate || '',
                status: prj.lifecycleStatus || prj.approvalStatus || ''
            });
        });
    }
    if(projectMap.size === 0 &amp;&amp; Array.isArray(plan.planP2E)){
        plan.planP2E.forEach(rel => {
            if(!rel) return;
            const key = rel.projectId || rel.projectname;
            if(!key || projectMap.has(key)) return;
            projectMap.set(key, {
                id: key,
                name: rel.projectname || 'Linked project',
                startDate: rel.projectStartDate || '',
                endDate: rel.projectEndDate || '',
                status: rel.projectStatus || ''
            });
        });
    }
    return Array.from(projectMap.values());
  }

  function buildPlanImpacts(plan, regex, removalSet){
    if(!Array.isArray(plan.planP2E)) return [];
    return plan.planP2E
        .filter(rel => rel &amp;&amp; regex.test(rel.eletype || ''))
        .filter(rel => {
            if(!removalSet || !rel) return true;
            const relId = rel.impactedElement || rel.id;
            return !relId || !removalSet.has(relId);
        })
        .map(rel => ({
            id: rel.impactedElement || rel.id,
            name: rel.name || rel.impactedElement || 'Unnamed element',
            type: rel.eletype || 'Unknown',
            action: rel.action || '',
            project: rel.projectname || ''
        }));
  }

  function setupFilterPanel(){
    if(filterPanelKeyHandler){
        document.removeEventListener('keyup', filterPanelKeyHandler);
        filterPanelKeyHandler = null;
    }
    document.body.classList.remove('filter-panel-open');
    const panel = document.getElementById('filter-panel');
    const backdrop = document.getElementById('filter-panel-backdrop');
    const toggle = document.getElementById('filter-panel-toggle');
    const closeBtn = document.getElementById('filter-panel-close');
    if(!panel || !backdrop || !toggle){
        return;
    }
    const openPanel = () => {
        panel.classList.add('is-open');
        backdrop.classList.add('is-visible');
        panel.setAttribute('aria-hidden','false');
        document.body.classList.add('filter-panel-open');
    };
    const closePanel = () => {
        panel.classList.remove('is-open');
        backdrop.classList.remove('is-visible');
        panel.setAttribute('aria-hidden','true');
        document.body.classList.remove('filter-panel-open');
        
        // Reset visual state when closing
        document.querySelectorAll('.plan-chevron').forEach(p=> p.classList.remove('active'));
        clearPlanHighlights();
    };
    toggle.addEventListener('click', () => {
        if(panel.classList.contains('is-open')){
            closePanel();
        } else {
            openPanel();
        }
    });
    if(closeBtn){
        closeBtn.addEventListener('click', closePanel);
    }
    backdrop.addEventListener('click', closePanel);
    filterPanelKeyHandler = (evt) => {
        if(evt.key === 'Escape' &amp;&amp; panel.classList.contains('is-open')){
            closePanel();
        }
    };
    document.addEventListener('keyup', filterPanelKeyHandler);
  }

  function attemptInitialRender(){
    if(initialRenderDone){
        return;
    }
    if(document.readyState === 'loading'){
        if(!waitingForDomReady){
            waitingForDomReady = true;
            document.addEventListener('DOMContentLoaded', () => {
                waitingForDomReady = false;
                attemptInitialRender();
            }, { once: true });
        }
        return;
    }
    const root = getRootFromRoadmap();
    const firstL2 = (root.childCaps||[])[0] ? root.childCaps[0].id : null;
    if(!firstL2){
        console.warn('Roadmap JSON loaded but no L2 capabilities are available to render.');
        return;
    }
    initialRenderDone = true;
    render(firstL2);
  }

  attemptInitialRender();

  function buildPlanDetailContext(plan){
    return {
        name: plan.name || 'Untitled plan',
        description: plan.description || '',
        startDate: plan.validStartDate || 'n/a',
        endDate: plan.validEndDate || 'n/a',
        status: plan.planStatus || 'n/a',
        projects: buildPlanProjects(plan),
        impactedApplications: buildPlanImpacts(plan, APPLICATION_REGEX, null),
        impactedCapabilities: buildPlanImpacts(plan, CAPABILITY_REGEX, null)
    };
  }

  function openPlanDrawerForPlan(plan){
    const tpl = ensurePlanDetailTemplate();
    if(!tpl || !plan) return;
    const {drawer, backdrop, content} = getPlanDrawerElements();
    if(!drawer || !backdrop || !content) return;
    content.innerHTML = tpl(buildPlanDetailContext(plan));
    drawer.classList.add('is-visible');
    backdrop.classList.add('is-visible');
    drawer.setAttribute('aria-hidden', 'false');
    backdrop.setAttribute('aria-hidden', 'false');
    document.body.classList.add('drawer-open');
  }

  function closePlanDrawer(){
    const {drawer, backdrop} = getPlanDrawerElements();
    if(!drawer || !backdrop) return;
    drawer.classList.remove('is-visible');
    backdrop.classList.remove('is-visible');
    drawer.setAttribute('aria-hidden', 'true');
    backdrop.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('drawer-open');
    
    // Reset visual state when closing
    document.querySelectorAll('.plan-chevron').forEach(p=> p.classList.remove('active'));
    clearPlanHighlights();
  }

  function handlePlanSelection(planId, el){
    if(!planId) return;
    const plan = (Array.isArray(plansJSON) ? plansJSON : []).find(p => p.id === planId);
    if(!plan) return;
    document.querySelectorAll('.plan-chevron').forEach(btn => btn.classList.remove('active'));
    if(el){ el.classList.add('active'); }
    openPlanDrawerForPlan(plan);
  }

  function applyPlanHighlights(plan, shouldHighlight){
    if(!plan){
        clearPlanHighlights();
        return;
    }
    const appImpacts = new Set(buildPlanImpacts(plan, APPLICATION_REGEX, null).map(item => item.id));
    const capImpacts = new Set(buildPlanImpacts(plan, CAPABILITY_REGEX, null).map(item => item.id));

    document.querySelectorAll('.app').forEach(appEl => {
        const attr = appEl.getAttribute('data-app') || '';
        const ids = attr.split(/[\s,|]+/).filter(Boolean);
        const isImpacted = shouldHighlight &amp;&amp; ids.some(id => appImpacts.has(id));
        if(isImpacted){
            appEl.classList.add('highlighted-app');
            appEl.classList.remove('dimmed');
        } else if(shouldHighlight){
            appEl.classList.remove('highlighted-app');
            appEl.classList.add('dimmed');
        } else {
            appEl.classList.remove('highlighted-app','dimmed');
        }
    });
  }

  function clearPlanHighlights(){
    document.querySelectorAll('.app').forEach(appEl => appEl.classList.remove('highlighted-app','dimmed'));
    document.querySelectorAll('.capability-box').forEach(capEl => capEl.classList.remove('highlighted','dimmed'));
    document.querySelectorAll('.plan-highlight-btn').forEach(btn => btn.classList.remove('active'));
  }

  function attachPlanClickHandlers(){
    document.querySelectorAll('.plan-chevron[data-plan-id]').forEach(btn => {
        const planId = btn.getAttribute('data-plan-id');
        const highlightBtn = btn.querySelector('.plan-highlight-btn');
        btn.addEventListener('click', (evt) => {
            if(evt.target === highlightBtn){
                return;
            }
            handlePlanSelection(planId, btn);
        });
        btn.addEventListener('keydown', (evt) => {
            if(evt.key === 'Enter' || evt.key === ' '){
                evt.preventDefault();
                handlePlanSelection(planId, btn);
            }
        });
        if(highlightBtn){
            highlightBtn.addEventListener('click', (evt) => {
                evt.stopPropagation();
                const plan = plansJSON.find(p => p.id === planId);
                const wasActive = highlightBtn.classList.contains('active');
                clearPlanHighlights();
                if(!wasActive &amp;&amp; plan){
                    highlightBtn.classList.add('active');
                    applyPlanHighlights(plan, true);
                }
            });
        }
    });
  }

  function toDate(d){
    return d ? new Date(d) : null;
  }
  function isRemoval(change){
    return !!change &amp;&amp; typeof change.actionType === 'string' &amp;&amp; change.actionType.toLowerCase().includes('removal');
  }
  function isCreation(change){
    return !!change &amp;&amp; typeof change.actionType === 'string' &amp;&amp; change.actionType.toLowerCase().includes('creation');
  }
  function isEnhance(ch){
    if(!ch) return false;
    const a = (ch.actionType || ch.action || '').toLowerCase();
    if(!a) return false;
    // enhancement = anything that's not create/establish or removal/decommission
    return !(a.includes('creation') || a.includes('establish') || a.includes('create') || a.includes('removal') || a.includes('decommission'));
  }
function collectL2Options(root){
    return (root.childCaps||[]).map(c=>({id:c.id, name:c.name}));
  }

  function findL2(root, id){
    return (root.childCaps||[]).find(c=>c.id===id) || null;
  }

  // Walk the subtree of an L2 and collect: L3 nodes, app removals up to target date, and all planIds
  function walkL2Subtree(l2){
    const l3 = [];
    const l3ById = new Map();
    const removalIds = new Set();
    const removalCapIds = new Set();
    const removalSchedule = new Map();
    const planIds = new Set();
    const enhancedIds = new Set();
    const creationDates = new Map(); // appId -> Date of creation (earliest if multiple)

    function visit(node, depth, currentL3Id){
      if(node &amp;&amp; node.changes){
        const appChanges = Array.isArray(node.changes.applications) ? node.changes.applications : [];
        const capChanges = Array.isArray(node.changes.capabilities) ? node.changes.capabilities : [];
        for(const ch of [...appChanges, ...capChanges]){
          if(ch &amp;&amp; ch.planId) planIds.add(ch.planId);

          if(ch){
            const lowerType = (ch.type || '').toLowerCase();
            const startDate = toDate(ch.startDate);
            const endDate = toDate(ch.endDate);
            const removalDate = endDate || startDate;
            const creationDate = startDate || endDate;
            const enhanceDate = endDate || startDate;

            if(isRemoval(ch)){
              if(removalDate &amp;&amp; ch.targetId){
                removalSchedule.set(ch.targetId, removalDate);
              }
              if(removalDate &amp;&amp; removalDate &lt;= targetDate &amp;&amp; ch.targetId){
                if(lowerType.includes('application')){
                  removalIds.add(ch.targetId);
                } else if(lowerType.includes('capability')){
                  removalCapIds.add(ch.targetId);
                }
              }
            } else if(isCreation(ch)){
              if(creationDate &amp;&amp; ch.targetId){
                const existing = creationDates.get(ch.targetId);
                // keep the earliest known creation date for this app
                if(!existing || creationDate &lt; existing){
                  creationDates.set(ch.targetId, creationDate);
                }
              }
            } else if(isEnhance(ch)){
              if(ch.targetId){
                if(!enhanceDate || enhanceDate &lt;= targetDate){
                  enhancedIds.add(ch.targetId);
                }
              }
            }
          }
        }
      }

      if(depth === 1){
        const rec = { id: node.id, name: node.name, apps: Array.isArray(node.apps) ? node.apps.slice() : [], subCaps: [] };
        l3.push(rec);
        l3ById.set(node.id, rec);
      }

      // Collect next-level sub-capabilities (depth 2) for each L3
      if(depth === 2 &amp;&amp; currentL3Id &amp;&amp; l3ById.has(currentL3Id)){
        const rec = l3ById.get(currentL3Id);
        const childApps = Array.isArray(node.apps) ? node.apps : [];
        const sub = { id: node.id, name: node.name, apps: childApps.slice() };
        rec.subCaps.push(sub);
      }

      const kids = Array.isArray(node.childCaps) ? node.childCaps : [];
      kids.forEach(k => visit(k, depth + 1, depth === 1 ? node.id : currentL3Id));
    }

    visit(l2, 0, null);
    return { l3, removalIds, removalCapIds, planIds, creationDates, enhancedIds, removalSchedule };
  }

  function buildCurrentVM(l2, l3List, creationDates, removalIds, removalCapIds, removalSchedule){
    const filteredL3List = l3List
      .map(c => ({
        ...c,
        subCaps: (c.subCaps || [])
      }));

    const currentL3 = filteredL3List.map(c => {
      const apps = (c.apps||[])
        .filter(a => {
          const cd = creationDates.get(a.id);
          if(cd &amp;&amp; cd > today) return false;
          return true;
        })
        .map(a => {
          const classes = [];
          const removalDate = removalSchedule.get(a.id);
          if(removalDate){
            if(removalDate &lt;= targetDate){
              classes.push('app--removal');
              classes.push('app--removal-past');
            }
          }
          return { id:a.id, name:a.name, className: classes.join(' ') };
        });

      // If we're showing lower level, hide parent (L3) apps to avoid duplication
      if (includeLowerLevel &amp;&amp; Array.isArray(c.subCaps) &amp;&amp; c.subCaps.length > 0) {
        // override apps to an empty list when lower level is visible
        // so only subcap apps render
        // (template already handles empty lists gracefully)
        apps.length = 0;
      }

      let subCaps = [];
      if(includeLowerLevel &amp;&amp; Array.isArray(c.subCaps)){
        subCaps = c.subCaps.map(sc => {
          const scApps = (sc.apps||[])
            .filter(a => {
              const cd = creationDates.get(a.id);
              if(cd &amp;&amp; cd > today) return false;
              return true;
            })
            .map(a => {
              const classes = [];
              const removalDate = removalSchedule.get(a.id);
              if(removalDate){
                if(removalDate &lt;= targetDate){
                  classes.push('app--removal');
                  classes.push('app--removal-past');
                }
              }
              return { id:a.id, name:a.name, className: classes.join(' ') };
            });
          return { id: sc.id, name: sc.name, apps: scApps };
        }).filter(sc => sc.apps.length > 0);
      }

      return { id:c.id, name:c.name, apps, subCaps };
    });
    return { currentL2:{ id:l2.id, name:l2.name }, currentL3 };
  }

  function buildTargetVM(l2, l3List, removalIds, creationDates, enhancedIds, removalCapIds){
    const filteredL3List = l3List
      .filter(c => !removalCapIds.has(c.id))
      .map(c => ({
        ...c,
        subCaps: (c.subCaps || []).filter(sc => !removalCapIds.has(sc.id))
      }));

    const targetL3 = filteredL3List.map(c => {
      const apps = (c.apps||[])
        .filter(a => {
          const cd = creationDates.get(a.id);
          if(cd &amp;&amp; cd > targetDate) return false;
          if(removalIds.has(a.id)) return false;
          return true;
        })
        .map(a => {
              const cd = creationDates.get(a.id);
              const isNewAtTarget = cd &amp;&amp; cd > today &amp;&amp; cd &lt;= targetDate;
              const isEnh = enhancedIds &amp;&amp; enhancedIds.has(a.id);
              const cls = isNewAtTarget ? 'app--new' : (isEnh ? 'app--enhance' : '');
              return { id:a.id, name:a.name, className: cls };
            });

      // If we're showing lower level, hide parent (L3) apps to avoid duplication
      if (includeLowerLevel &amp;&amp; Array.isArray(c.subCaps) &amp;&amp; c.subCaps.length > 0) {
        apps.length = 0;
      }

      let subCaps = [];
      if(includeLowerLevel &amp;&amp; Array.isArray(c.subCaps)){
        subCaps = c.subCaps.map(sc => {
          const scApps = (sc.apps||[])
            .filter(a => {
              const cd = creationDates.get(a.id);
              if(cd &amp;&amp; cd > targetDate) return false;
              if(removalIds.has(a.id)) return false;
              return true;
            })
            .map(a => {
              const cd = creationDates.get(a.id);
              const isNewAtTarget = cd &amp;&amp; cd > today &amp;&amp; cd &lt;= targetDate;
              const isEnh = enhancedIds &amp;&amp; enhancedIds.has(a.id);
              const cls = isNewAtTarget ? 'app--new' : (isEnh ? 'app--enhance' : '');
              return { id:a.id, name:a.name, className: cls };
            });
          return { id: sc.id, name: sc.name, apps: scApps };
        }).filter(sc => sc.apps.length > 0);
      }

      return { id:c.id, name:c.name, apps, subCaps };
    });
    return { targetL2:{ id:l2.id, name:l2.name }, targetL3 };
  }

  function buildTemplateData(root, selectedL2Id){
    const l2Options = collectL2Options(root).map(o => ({...o, selected: o.id === selectedL2Id}));
    const l2 = findL2(root, selectedL2Id) || (root.childCaps||[])[0] || { id:'-', name:'-' };
    const { l3, removalIds, removalCapIds, planIds, creationDates, enhancedIds, removalSchedule } = walkL2Subtree(l2);
    latestRemovalIds = new Set(removalIds);
    latestRemovalCapIds = new Set(removalCapIds);
    const currentVM = buildCurrentVM(l2, l3, creationDates, removalIds, removalCapIds, removalSchedule);
    const targetVM  = buildTargetVM(l2, l3, removalIds, creationDates, enhancedIds, removalCapIds);
    // STATIC ticks from 1 Jan (this year) to +60 months (5 years)
    const fixedSpanMonths = 60;
    const ticks = [];
    const windowEndFixed = new Date(yearStart);
    windowEndFixed.setMonth(windowEndFixed.getMonth() + fixedSpanMonths);

    let tickDate = new Date(yearStart);
    while (tickDate &lt;= windowEndFixed) {
      const months = monthsFromYearStart(tickDate);
      const pct = (months / fixedSpanMonths) * 100;
      const yearLabel = String(tickDate.getFullYear());
      if (ticks.length === 0 || ticks[ticks.length - 1].label !== yearLabel) {
        ticks.push({ label: yearLabel, offset: months, pct: pct.toFixed(4) });
      }
      tickDate = new Date(tickDate.getFullYear() + 1, 0, 1);
    }
    const yearTicks = ticks;

    // Position of today relative to the STATIC 60-month window
    const todayMonthsFromStart = monthsFromYearStart(today);
    const todayPct = Math.max(0, Math.min(100, (todayMonthsFromStart / fixedSpanMonths) * 100));

    return {

      title: 'Capabilities Roadmap',
      subtitle: 'Focus an L2; left shows current (L3 + apps), right shows target (removals applied by target date).',
      targetDate: targetDateISO,
      targetOffsetMonths,
      targetYears: (targetOffsetMonths/12).toFixed(1),
      todayPct,
      yearTicks,
      l2Options,
      ...currentVM,
      ...targetVM,
      includeLowerLevel,
      plans: Array.from(planIds)
    };
  }

  // ---------- RENDER ----------
  function render(selectedL2Id){
    const root = getRootFromRoadmap();
    const src = document.getElementById('roadmap-template').innerHTML;
    const tpl = Handlebars.compile(src);
    const fallbackL2 = (root.childCaps||[])[0] ? root.childCaps[0].id : null;
    const activeL2Id = selectedL2Id || currentL2Id || fallbackL2;
    currentL2Id = activeL2Id;
    const vm = buildTemplateData(root, activeL2Id);
    let plansDetail = [];
    const windowStart = new Date(yearStart);
    const windowEnd = new Date(yearStart);
    // Timeline window ends at the slider's target date (dynamic span)
    const spanMonths = Math.max(1, targetOffsetMonths);
    windowEnd.setMonth(windowEnd.getMonth() + spanMonths);

    const clamp = (d, min, max) => new Date(Math.min(Math.max(+d, +min), +max));
    const monthsFrom = (anchor, d) =>
      (d.getFullYear() - anchor.getFullYear()) * 12 + (d.getMonth() - anchor.getMonth());

    const formatTickLabel = (date, includeMonth) => {
      const y = date.getFullYear();
      if (!includeMonth) return String(y);
      return date.toLocaleDateString(
        'en-GB',
        { month: 'short', year: 'numeric' }
      );
    };

    const timelineTicks = []; // show only the dates between the start of the window and the slider target
    const pushTimelineTick = (date, includeMonth = false) => {
      const months = monthsFrom(windowStart, date);
      const pct = (months / spanMonths) * 100;
      timelineTicks.push({
        label: formatTickLabel(date, includeMonth),
        pct: Math.max(0, Math.min(100, pct)).toFixed(3)
      });
    };

    pushTimelineTick(windowStart, true);
    let nextYear = new Date(windowStart.getFullYear() + 1, 0, 1);
    while (nextYear &lt; windowEnd) {
      pushTimelineTick(nextYear);
      nextYear = new Date(nextYear.getFullYear() + 1, 0, 1);
    }
    pushTimelineTick(windowEnd, true);

    const pctFromDate = (d) =>
      Math.max(0, Math.min(100, (monthsFrom(windowStart, d) / spanMonths) * 100));

        vm.plans.forEach((pId) => {
        const plan = (Array.isArray(plansJSON) ? plansJSON : []).find(pl => pl.id === pId);
        if (!plan) return;

        const rawStart = plan.validStartDate ? new Date(plan.validStartDate) : windowStart;
        const rawEnd   = plan.validEndDate   ? new Date(plan.validEndDate)   : windowEnd;

        // If start &lt; 1 Jan current year, start at 1 Jan current year; otherwise use its real date
        if(rawEnd &amp;&amp; rawEnd &lt; windowStart){
            return;
        }

        const clampedStart = clamp(rawStart &lt; windowStart ? windowStart : rawStart, windowStart, windowEnd);
        const clampedEnd   = clamp(rawEnd, windowStart, windowEnd);

        // guard: ensure end >= start
        const safeEnd = clampedEnd &lt; clampedStart ? clampedStart : clampedEnd;

        const leftPct  = pctFromDate(clampedStart);
        const rightPct = pctFromDate(safeEnd);
        const widthPct = Math.max(1, rightPct - leftPct); // always at least 1% wide

        // simple vertical stacking (one per row)
        const topPx = 34 + plansDetail.length * 56; // 50px height + 6px gap
          // Determine if plan has ended before the current slider position (target)
        const isGreyed = !!rawEnd &amp;&amp; rawEnd &lt; targetDate;

        plansDetail.push({
            ...plan,
            leftPct: leftPct.toFixed(3),
            widthPct: widthPct.toFixed(3),
            topPx,
            clampedStartISO: clampedStart.toISOString().slice(0,10),
            clampedEndISO: safeEnd.toISOString().slice(0,10),
            isGreyed,
            disabled: isGreyed ? 'true' : 'false'
        });
        });

        vm['plansDetail'] = plansDetail;
    vm['timelineTicks'] = timelineTicks;

    console.log('vm', vm)
    document.getElementById('app').innerHTML = tpl(vm);
    setupFilterPanel();

    const sel = document.getElementById('l2-select');
    if(sel){
        if(currentL2Id &amp;&amp; sel.value !== currentL2Id){
            sel.value = currentL2Id;
        }
        $('#capName').text(sel.options[sel.selectedIndex].text);
        sel.addEventListener('change', e => render(e.target.value));
    }

    // Handle lower-level toggle
  const lowerTgl = document.getElementById('lower-toggle');
  if (lowerTgl) {
    lowerTgl.checked = !!includeLowerLevel;
    lowerTgl.addEventListener('change', (e) => {
      includeLowerLevel = !!e.target.checked;
      const l2Sel = document.getElementById('l2-select');
      render(l2Sel ? l2Sel.value : currentL2Id);
    });
    }

    const slider = document.getElementById('target-slider');
    const progressLine = document.getElementById('slider-progress-line');

    function updateSliderFill(){
        if(!slider) return;
        const pct = (targetOffsetMonths/60)*100;
        slider.style.setProperty('--pct', pct + '%');
        if(progressLine){ progressLine.style.width = pct + '%'; }
    }
    function updateSelectorLine(){
        const pct = (targetOffsetMonths/60)*100;
        const line = document.getElementById('slider-selector-line');
        if(line){ line.style.left = pct + '%'; }
    }

    if (slider) {
        // initial
        slider.value = String(targetOffsetMonths);
        updateSliderFill();
        updateSelectorLine();
        updateSelectorLine();

    const dateDisplay = document.getElementById('target-date-display');

    let rafId = null;
    let pendingVal = targetOffsetMonths;

    function applyPending(){
        rafId = null;
        targetOffsetMonths = pendingVal;
        computeTargetDate();
        updateSliderFill();
        updateSelectorLine();
        if (dateDisplay) dateDisplay.textContent = targetDateISO;
    }

    // Smooth live feedback using RAF; no full render while dragging
    slider.addEventListener('input', (e) => {
        const newVal = parseInt(e.target.value, 10);
        if (Number.isNaN(newVal)) return;
        pendingVal = newVal;
        if (rafId === null) rafId = requestAnimationFrame(applyPending);
    }, { passive: true });

    // Do the heavy re-render once the user releases the thumb
    const triggerRender = () => {
        const l2Sel = document.getElementById('l2-select');
        render(l2Sel ? l2Sel.value : currentL2Id);
    };
    slider.addEventListener('change', triggerRender);
    slider.addEventListener('mouseup', triggerRender);
    slider.addEventListener('touchend', triggerRender, { passive: true });
    slider.addEventListener('mousedown', stopPlayback);
    slider.addEventListener('touchstart', stopPlayback, { passive: true });
    }

    attachPlanClickHandlers();

    const playBtn = document.getElementById('playback-btn');
    if (playBtn) {
        playBtn.addEventListener('click', togglePlayback);
        if (playbackInterval) {
            playBtn.classList.add('is-playing');
            const icon = playBtn.querySelector('i');
            if (icon) {
                icon.classList.remove(PLAY_ICON);
                icon.classList.add(STOP_ICON);
            }
        }
    }
  }

function resetHighlighting(){
  document.querySelectorAll('.plan-chevron').forEach(p=> p.classList.remove('active'));
  clearPlanHighlights();
  closePlanDrawer();
}

  function initStaticHandlers(){
    const closeBtn = document.getElementById('plan-drawer-close');
    const {backdrop} = getPlanDrawerElements();
    if(closeBtn){ closeBtn.addEventListener('click', closePlanDrawer); }
    if(backdrop){ backdrop.addEventListener('click', closePlanDrawer); }
    document.addEventListener('keyup', (evt) => {
        if(evt.key === 'Escape'){
            closePlanDrawer();
        }
    });
    attemptInitialRender();
  }

  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', initStaticHandlers);
  } else {
    initStaticHandlers();
  }




      // If you need JSON strings:
      // console.log(JSON.stringify(combined, null, 2));
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  executeFetchAndRender();
});

                          
                </script>
			
			</body>
            
		</html>
	</xsl:template>


</xsl:stylesheet>
