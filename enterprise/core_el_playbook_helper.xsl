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
    <!-- Get an API Report instance using the common list of API Reports already captured by core_utilities.xsl -->
	<xsl:variable name="anAPIClassInstance" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Class to Slot Count']"/>
    <xsl:key name="configuredEditors" match="simple_instance[type=('Configured_Editor', 'Report', 'Editor')]" use="own_slot_value[slot_reference='name']/value"/>
    <xsl:variable name="appEditor" select="key('configuredEditors', 'Config: Application Editor')"/>
    <xsl:variable name="bpmnEditor" select="key('configuredEditors', 'Core: BPMN Process Flow Modeler')"/>
    <xsl:variable name="bcmEditor" select="key('configuredEditors', 'Core: Business Capability Model Editor')"/>
    <xsl:variable name="setupEditor" select="key('configuredEditors', 'Core: Essential Set-Up')"/>
    <xsl:variable name="bpEditor" select="key('configuredEditors', 'Core: Business Process Editor')"/>
    <xsl:variable name="trmEditor" select="key('configuredEditors', 'Core: Technology Reference Model Editor')"/>
    <xsl:variable name="tpEditor" select="key('configuredEditors', 'Core Config: Technology Product Editor')"/>
    <xsl:variable name="projectImpactsEditor" select="key('configuredEditors', 'Core: Project Impacts Editor')"/>
    <xsl:variable name="eaAssist" select="key('configuredEditors', 'ext: EA Assistant')"/>
    <xsl:variable name="strategicPlanEditor" select="key('configuredEditors', 'Config: Strategic Plan Editor')"/>
    <xsl:variable name="roadmapEditor">
    <xsl:for-each select="key('configuredEditors', *)">
      <xsl:if test="contains(., 'Roadmap Editor')">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="proposalEditor">
    <xsl:for-each select="key('configuredEditors', *)">
      <xsl:if test="contains(., 'Proposal Editor')">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="busModelManager">
    <xsl:for-each select="key('configuredEditors', *)">
      <xsl:if test="contains(., 'Business Model Portfolio Manager')">
        <xsl:sequence select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable> 
    <xsl:variable name="vendorLifeEditor" select="key('configuredEditors', 'Core: Vendor Lifecycle Editor')"/>

   	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
    <xsl:template match="knowledge_base">
        <xsl:call-template name="docType"/> 
		 <xsl:variable name="apiPathClass">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$anAPIClassInstance"/>
            </xsl:call-template>
        </xsl:variable>
        <html>
            <head>
            	<xsl:call-template name="commonHeadContent"/>
              <title>Essential Playbook</title>
		        <script src="js/d3/d3.v7.9.0.min.js"></script>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderEditorInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
						<xsl:with-param name="newWindow" select="true()"/>
					</xsl:call-template>
				</xsl:for-each>
      <style>
          .node {
              fill: #ffffff;
              stroke: #333;
              stroke-width: 3px;
              cursor: pointer; /* Change cursor to indicate draggable nodes */
          }
          .link {
              stroke-width: 5px;
              fill: none;
          }
          .label {
              font-size: 10px;
              text-anchor: middle;
              fill: black;
              font-family: Arial, sans-serif;
          }
          .node-label {
              font-size: 12px;
              font-family: Arial, sans-serif;
              fill: rgb(0, 0, 0);
              text-anchor: middle;
              pointer-events: none;
          }
          /* Optional: Hover effects for better interactivity */
          .node:hover {
              fill: orange;
          }
          .link:hover {
              stroke: orange;
          }
          /* Tooltip styling */
          .tooltip {
              position: absolute;
              text-align: center;
              padding: 6px;
              font: 12px sans-serif;
              background: lightsteelblue;
              border: 0px;
              border-radius: 4px;
              pointer-events: none;
              opacity: 0;
          }

          svg {
              margin: 0;
              padding: 0;
              display: block;
          }

        .playbook-header {
          margin-bottom: 30px;
        }
        .play-card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 20px;
            cursor: pointer;
            transition: box-shadow 0.2s ease-in-out;
        }
        .play-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .play-card h3 {
            margin-top: 0;
            color: #337ab7; /* Bootstrap primary color */
        }
        .play-card .category-tag {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 4px;
            background-color: #1a1a1a; /* Bootstrap info color */
            color: white;
            margin-right: 5px;
        }

       .detail-box .category-tag {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 4px;
            background-color: #1a1a1a; /* Bootstrap info color */
            color: white;
            margin-right: 5px;
        }
        .detail-box .priority-tag {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 4px;
            background-color: #d9534f; /* Bootstrap danger color */
            color: white;
        }
        .play-card .priority-tag {
            font-size: 12px;
            padding: 3px 8px;
            border-radius: 4px;
            background-color: #d9534f; /* Bootstrap danger color */
            color: white;
        }
        .play-card .play-icon {
            font-size: 24px;
            color: #337ab7;
        }
        .play-card-footer {
            margin-top: 5px;
            font-size: 15px;
            color: #777;
            border-top: 1px solid #eee;
            padding-top: 10px;
        }
        .view-section {
            display: none; /* Hidden by default, shown by JS */
        }
        .step-item {
            border: 1px solid #eee;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 6px;
            cursor: pointer;
            background-color: #fff;
        }
        .step-item:hover {
            background-color: #f9f9f9;
            color: black;
        }
        .step-item .step-number {
            display: inline-block;
            width: 30px;
            height: 30px;
            line-height: 25px;
            text-align: center;
            border-radius: 50%;
            border: 2px solid #337ab7;
            color: #ffffff;
            font-weight: bold;
            margin-right: 10px;
        }
        .step-item.completed .step-number { /* Note: .completed class on step-item itself */
            background-color: #5cb85c; /* Bootstrap success color */
            border-color: #5cb85c;
            color: white;
        }
        .step-item.completed .fa-check-circle { /* Note: .completed class on step-item itself */
            color: #5cb85c;
        }

        .task-list { list-style: none; padding: 0; margin: 12px 0 0; display: flex; flex-direction: column; gap: 10px; }
        .task-card { border: 1px solid #e5e7eb; border-radius: 10px; padding: 12px; background: #fff; box-shadow: 0 2px 6px rgba(0,0,0,0.03); }
        .task-card .task-header { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; margin-bottom: 8px; }
        .task-card .task-title { font-weight: 700; }
        .task-card .task-description { display: block; margin: 4px 0 6px; color: #4b5563; font-size: 13px; font-weight: 400; }
        
        .task-card .task-bullets { margin: 6px 0 0; padding-left: 18px; }
        .task-card .task-subhead { font-weight: 700; margin-top: 6px; }
        .task-card .task-resource { display: inline-flex; align-items: center; gap: 6px; margin-right: 8px; padding: 4px 8px; border-radius: 8px; background: #f8fafc; border: 1px solid #e5e7eb; text-decoration: none; color: inherit; }
        .task-card .task-resource:hover { background: #eef2ff; border-color: #cbd5e1; }
        .task-resource-grid { display: grid; gap: 10px; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); margin-top: 8px; }
        .task-resource-card { border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; background: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.04); cursor: pointer; display: flex; flex-direction: column; height: 100%; transition: transform .12s ease, box-shadow .12s ease; }
        .task-resource-card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0,0,0,0.06); }
        .task-resource-card img { width: 100%; height: 120px; object-fit: cover; background: #f8fafc; }
        .task-resource-body { padding: 10px 12px; display: flex; flex-direction: column; gap: 4px; }
        .task-resource-type { font-size: 12px; color: #6b7280; text-transform: uppercase; letter-spacing: .3px; position:relative }
        .task-resource-title { font-weight: 700; color: #111827; font-size: 14px; }

        .list-group-item.step-item {
          position: relative;
          overflow: hidden;     
          background-color: rgb(80, 80, 80);
        }

        .list-group-item.step-item::before {
          content: attr(data-step-index); /* grabs the step index from your XSL attribute */
          position: absolute;
          top: 50%;
          right: 0%;
          transform: translate(-50%, -50%) rotate(10deg);
          font-size: 110px;
          font-weight: bold;
          color: rgba(225, 225, 225, 0.3);     /* very light so it’s in the background */
          z-index: 0;
          pointer-events: none;          /* so it won’t interfere with clicks */
        }
              
        .list-group-item.step-item .media {
          position: relative;            /* stack your normal content above the background */
          z-index: 1;
        }
        

        .list-group-item-step{
            font-family: Verdana, Geneva, Tahoma, sans-serif;
            color: #dddddd !important;
        }

        .list-group-item-heading{
            color: #d3d3d3 !important;
        }
        
        .detail-box {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .detail-box h2, .detail-box h3 {
            margin-top: 0;
        }
        .tasks-list input[type="checkbox"] {
            margin-right: 10px;
        }
        .task-completed label {
            text-decoration: line-through;
            color: #999;
        }
        .resource-item, .communication-item-play { /* Renamed to avoid conflict if step communication is re-added */
            display: flex;
            align-items: center;
            padding: 8px;
            border: 1px solid #eee;
            border-radius: 4px;
            margin-bottom: 8px;
        }
        .resource-item .fa, .communication-item-play .fa {
            margin-right: 10px;
            font-size: 1.2em;
        }
        .insights-box {
            background-color: #fcf8e3; /* Bootstrap warning background */
            border: 1px solid #faebcc; /* Bootstrap warning border */
            color: #8a6d3b; /* Bootstrap warning text */
            padding: 15px;
            border-radius: 4px;
            margin-top: 15px;
            font-family: Verdana, Geneva, Tahoma, sans-serif;
        }
        .insights-box .fa-info-circle {
            margin-right: 10px;
        }
        .nav-buttons button {
            margin-right: 10px;
        }
        .filter-controls .form-group {
            margin-right: 15px;
        }
        .search-bar .input-group-addon {
            background-color: #fff;
        }
        .margin-bottom-20 { margin-bottom: 20px; }
        .margin-bottom-10 { margin-bottom: 10px; }
        .margin-top-10 { margin-top: 20px; }

        /* Card 2 */
        .card-blue {
            background-color: #3498db;
            color: white;
            border-left: 3px solid #3498db;
        }
        .card-purple {
            background-color: #b16ce6;
            color: white;
            border-left: 3px solid #b16ce6;
        }
        .card-teal {
            background-color: #6bcfd3;
            color: white;
            border-left: 3px solid #6bcfd3;
        }

        .card-amber {
            background-color: #f0b062;
            color: white;
            border-left: 3px solid #f0b062;
        }
        .card-2 {
            width: 250px;
            height: 110px;
            border-radius: 8px 8px 8px 3px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            background-color: white;
            margin: 5px;   
            display:inline-block;
        }
        .card-wide{
            width: 32%
        }
        .card-tall{
            height: 200px;
            width: 190px;
            overflow: auto;
        }
        .card-2 .title {
            color: white;
            padding: 4px 30px 4px 2px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;

  
        }
        
        .card-2 .title-text {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 2px 6px;
            border-radius: 10px;
        }
        
        .card-2 .content {
            padding: 5px 5px;
            font-size: 12px;
            color: #444;
            font-family: Verdana, Geneva, Tahoma, sans-serif;
        }

        .timeline-container {
            margin: 0 auto;
            position: relative;
            overflow-x: hidden;
        }

        .timeline-header {
            text-align: center;
            margin-bottom: 60px;
            color: white;
        }

        .timeline-header h1 {
            font-size: 1.5rem;
            font-weight: 300;
            margin-bottom: 10px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .timeline-header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .timeline {
            position: relative;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 100px;
            gap: 120px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: calc(100% - 400px);
            top: 50%;
            height: 4px;
            background: linear-gradient(to right, #ffffff, #e0e0e0, #ffffff);
            transform: translateX(-50%) translateY(-50%);
            border-radius: 2px;
            box-shadow: 0 0 20px rgba(255,255,255,0.3);
            z-index: 1;
        }

        .timeline-item {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            opacity: 0;
            animation: fadeInUp 0.8s ease forwards;
            z-index: 2;
            height: 100%;
            margin: 10px;
        }

        .timeline-item:nth-child(1) { animation-delay: 0.2s; }
        .timeline-item:nth-child(2) { animation-delay: 0.4s; }
        .timeline-item:nth-child(3) { animation-delay: 0.6s; }
        .timeline-item:nth-child(4) { animation-delay: 0.8s; }
        .timeline-item:nth-child(5) { animation-delay: 1.0s; }

        .timeline-content {
            width: 240px;
            padding: 25px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
            position: relative;
        }

        .timeline-content:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 45px rgba(0,0,0,0.15);
        }

        /* Alternating positions - above and below the center line */
        .timeline-item:nth-child(odd) .timeline-content {
            position: absolute;
            bottom: 50%;
            margin-bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
        }

        .timeline-item:nth-child(even) .timeline-content {
            position: absolute;
            top: 50%;
            margin-top: 20px;
            left: 50%;
            transform: translateX(-50%);
        }

        /* Callout arrows pointing to the timeline */
        .timeline-content::after {
            content: '';
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
            width: 0;
            height: 0;
            border: 12px solid transparent;
        }

        .timeline-item:nth-child(odd) .timeline-content::after {
            bottom: -24px;
            border-top-color: rgba(255, 255, 255, 0.95);
        }

        .timeline-item:nth-child(even) .timeline-content::after {
            top: -24px;
            border-bottom-color: rgba(255, 255, 255, 0.95);
        }

        .step-number {
            width: 37px;
            height: 25px;
            background: linear-gradient(135deg, #6bcfd3, #62898a);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 14px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            border: 4px solid white;
            z-index: 10;
            position: absolute;
            top: 50%;
            left: 95%;
            transform: translate(-50%, -50%);
        }

        .step-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            line-height: 1.3;
        }

        .step-description {
            color: #666;
            line-height: 1.2rem;
            font-size: 12px;
        }

        .step-phase {
            display: inline-block;
            padding: 4px 10px;
            background: linear-gradient(135deg, #6bcfd3, #15ccd3);
            color: white;
            border-radius: 15px;
            font-size:10px;
            font-weight: 500;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Mobile responsive - falls back to vertical */
        @media (max-width: 1250px) {
            body {
                overflow-x: scroll;
            }
            
            .timeline-container {
                min-width: 1200px;
            }
        }

        @media (max-width: 768px) {
            body {
                overflow-x: visible;
                padding: 20px 10px;
            }
            
            .timeline-container {
                min-width: auto;
            }
            
            .timeline {
                flex-direction: column;
                height: auto;
                gap: 60px;
                padding: 40px 0;
            }
            
            .timeline::before {
                left: 50%;
                right: auto;
                top: 0;
                bottom: 0;
                width: 4px;
                height: 100%;
                transform: translateX(-50%);
            }

            .timeline-item {
                width: 100%;
                max-width: 400px;
            }

            .timeline-content {
                width: 80%;
                margin: 0 !important;
            }

            .timeline-item:nth-child(odd) .timeline-content {
                margin-left: 0 !important;
                margin-right: auto !important;
            }

            .timeline-item:nth-child(even) .timeline-content {
                margin-left: auto !important;
                margin-right: 0 !important;
                order: 0 !important;
            }

            .timeline-content::after {
                top: 30px !important;
                bottom: auto !important;
                left: auto !important;
                transform: none !important;
            }

            .timeline-item:nth-child(odd) .timeline-content::after {
                right: -30px;
                border-left-color: rgba(255, 255, 255, 0.95);
                border-top-color: transparent;
            }

            .timeline-item:nth-child(even) .timeline-content::after {
                left: -30px;
                border-right-color: rgba(255, 255, 255, 0.95);
                border-bottom-color: transparent;
            }

            .step-number {
                position: absolute !important;
                left: 50% !important;
                top: 20px !important;
                transform: translateX(-50%) !important;
                margin: 0 !important;
                order: 0 !important;
            }

            .timeline-header h1 {
                font-size: 2rem;
            }
        }
        .playLead{
          font-size:16px;
        }
        .infobox{
          border-radius:6px;
          border-left:1pt solid #d3d3d3;
          border-right:1pt solid #d3d3d3;
        }

        .info-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .info-cards-grid {
            display: flex;
            gap: 20px;
            margin-top: 20px;
            overflow-x: auto;
            padding-bottom: 10px;
        }

        .info-card {
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            width: 200px;
            height: 300px;
            flex-shrink: 0;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .info-card-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
            }

            .info-card-image {
                 width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
                animation: fadeUp 0.6s ease forwards;
                animation-delay: var(--delay, 0s);
                    filter: brightness(2.2);
                    opacity: 0.6
            }

        .info-card:hover .info-card-image {
            transform: scale(1.05);
        }

        .info-card-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(
                to bottom,
                rgba(0, 0, 0, 0.1) 0%,
                rgba(0, 0, 0, 0.3) 50%,
                rgba(0, 0, 0, 0.8) 100%
            );
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 15px;
            color: white;
            border-bottom: 4px solid #c8b322;
        }
 
        .info-card-tag {
            background: #FFD700;
            color: #000;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            align-self: flex-start;
            margin-bottom: 10px;
        }
        .info-card-tag-blue {
            background: #b9e0ef;
            color: #000;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            align-self: flex-start;
            margin-bottom: 10px;
        }

        .info-card-content {
            margin-top: auto;
        }

        .info-card-duration {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            margin-bottom: 8px;
            opacity: 0.9;
        }

        .info-play-icon {
            width: 0;
            height: 0;
            border-left: 8px solid white;
            border-top: 5px solid transparent;
            border-bottom: 5px solid transparent;
        }

        .info-card-title {
            font-size: 16px;
            font-weight: bold;
            line-height: 1.3;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }

        .info-card-subtitle {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 4px;
            font-weight: 500;
        }

        /* Specific card background colors for demo */
        .info-card-1 { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .info-card-2 { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .info-card-3 { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .info-card-4 { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
        .info-card-5 { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .info-card-6 { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }

        @media (max-width: 768px) {
            .info-cards-grid {
                gap: 15px;
            }
        }

          .enterprise-card {
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            max-width: 1200px;
            margin: 0 auto;
            border: 1px solid #e2e8f0;
        }

        .card-grid {
            display: grid;
            grid-template-columns: 1fr 1fr auto;
            gap: 2rem;
            align-items: start;
        }

        .section {
            padding: 0;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            font-size: 18x;
            font-weight: 600;
            color: #1e293b;
        }

        .section-icon {
            margin-right: 0.75rem;
            font-size: 14px;
            color: #64748b;
        }

        .section-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .section-list li {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f5f9;
            font-size: 14x;
            line-height: 1.5;
        }

        .section-list li:last-child {
            border-bottom: none;
        }

        .section-list li:before {
            font-family: verdana, sans-serif;
            font-weight: 900;
            content: "\f061";
            color: #16d340;
            margin-right: 0.75rem;
            font-size: 0.8rem;
        }

        .duration-section {
            text-align: center;
            padding: 1rem;
            background: #f8fafc;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }

        .duration-text {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin-top: 0.5rem;
        }

        @media (max-width: 768px) {
            .card-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
            
            .enterprise-card {
                padding: 1rem;
            }
        }

        .play-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
            margin-top: 32px;
        }

       .play-card {
            position: relative;      /* establish a local containing block */
            overflow: hidden;        /* hide anything that bleeds outside */
            background: #fff;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            padding: 24px;
            cursor: pointer;
            transition: all 0.15s ease;
            min-height: 280px;
            display: flex;
            flex-direction: column;
            z-index: 0;              /* ensure content sits above the pseudo-element */
            }

        .play-card::before {
        content: "";
        position: absolute;
        top: 0; left: 0; right: 0; bottom: 0;
        border-left: 13px solid palevioletred;
        z-index: -1;
        border-radius: inherit;   /* keep your rounded corners */
        }

        .play-card:hover {
            border-color: #d1d5db;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .play-card-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 16px;
        }

        .play-category-tag {
            background: #f3f4f6;
            color: #6b7280;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .play-id-tag {
            background: #eff6ff;
            color: #2563eb;
        }

        .play-priority-tag {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: #fef2f2;
            color: #dc2626;
        }

        .play-priority-medium {
            background: #fffbeb;
            color: #d97706;
        }

        .play-priority-low {
            background: #f0f9ff;
            color: #0284c7;
        }

        .play-card-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .play-card-title {
            font-size: 18px;
            font-weight: 600;
            color: #111827;
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .play-card-summary {
            font-size: 14px;
            color: #6b7280;
            line-height: 1.5;
            margin-bottom: 20px;
            flex: 1;
        }

        .play-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 16px;
            border-top: 1px solid #f3f4f6;
            margin-top: auto;
        }

        .play-footer-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #6b7280;
            font-weight: 500;
        }

        .play-icon {
            width: 14px;
            height: 14px;
            opacity: 0.7;
        }

        .play-view-play {
            text-align: right;
            margin-top: 12px;
            font-size: 14px;
            font-weight: 500;
            color: #2563eb;
            transition: color 0.15s ease;
        }

        .play-view-play:hover {
            color: #1d4ed8;
        }

        .play-chevron-right {
            margin-left: 4px;
            transition: transform 0.15s ease;
        }

        .play-view-play:hover .play-chevron-right {
            transform: translateX(2px);
        }

     
        .subtitle {
            text-align: left;
            color: #6b7280;
            font-size: 16px;
            margin-bottom: 24px;
        }

        @media (max-width: 768px) {
            body {
                padding: 16px;
            }
            
            .play-cards-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .play-card {
                padding: 20px;
                min-height: 260px;
            }
            
            .play-card-title {
                font-size: 16px;
            }
             
        }
        .blob{ display: inline-block; margin: 4px; font-size:10px;}
       .countBlob {
          //  display: inline-flex;       /* make it shrink‐to‐fit but still flex */
           // justify-content: centre;    /* horizontal centring */
          //  align-items: centre;        /* vertical centring */
            border-radius: 16px;
            border: 2pt solid rgb(142, 14, 14);  
            background-color: rgb(247, 247, 247);
            color: black;
            padding: 1px;
            margin-right: 5px;
            font-size: 13px;
            min-width: 25px;
            height: 26px;
            text-align: center;         /* fallback for older browsers */
        }

        .classBlob{border-radius:6px; border: 1pt solid  purple; background-color: rgb(169, 89, 154); color: white; font-weight bold; padding:3px; margin-right:5px}
        .slotBlob{border-radius:6px; border: 1pt solid blue; background-color: rgb(70, 126, 205); color: white; font-weight bold;  padding:3px; margin-right:5px}
        .slotBlobRed{border-radius:6px; border: 1pt solid rgb(255, 25, 0); background-color: rgb(205, 74, 70); color: white; font-weight bold;  padding:3px; margin-right:5px}
        .panel-heading{
            background-color: #797979 !important;
            color: white !important;
        }
        .txtBox{
            font-size:14px;
            font-family: Verdana, Geneva, Tahoma, sans-serif;
        }

        /* HUD playbook styles (from polished vanilla JS template) */
        :root {
          --bg: #fbfbfd;
          --panel: #ffffff;
          --ink: #1c1c1e;
          --muted: #6e6e73;
          --hairline: rgba(0, 0, 0, .08);
          --hairline-strong: rgba(0, 0, 0, .12);
          --focus: #0a84ff;
          --accent: #dbdbdb;
          --accent-ink: #8a5d00;
          --accent-2: #7c3aed;
          --accent-soft: color-mix(in oklab, var(--accent) 10%, #ffffff);
        }
        .hud-root {
          margin: 0;
          background: var(--bg);
          color: var(--ink);
          font: 14px/1.55 system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Inter, Roboto, Arial, sans-serif;
          -webkit-font-smoothing: antialiased;
          text-rendering: optimizeLegibility;
          opacity: 1;
        }
        .hud-root .container {
          width: 100%;
          margin: 0;
          padding: 0 20px;
        }
        .hud-root .pbheader {
          position: sticky;
          top: 0;
          z-index: 40;
          background: rgba(255, 255, 255, 0.92);
          border-bottom: 1px solid var(--hairline);
        }
        .hud-root .hstack { display:flex; align-items:center; gap:12px; }
        .hud-root .vstack { display:flex; flex-direction:column; gap:10px; }
        .hud-root .spacer { flex:1; }
        .hud-root .title { font-weight:900; letter-spacing:-.02em; }
        .hud-root .subtitle { color: var(--muted); }
        .hud-root select { border:1px solid var(--hairline-strong); border-radius:12px; padding:8px 12px; background:#fff; font-weight:600; }
        .hud-root select:focus { outline:none; box-shadow:0 0 0 3px color-mix(in oklab, var(--focus) 35%, transparent); }
        /* HUD layout grid */
        .hud-root .row { display:grid; grid-template-columns:1fr; gap:24px; }
        .hud-root .hud-grid { display:grid; grid-template-columns:minmax(320px, 0.9fr) 2.1fr; gap:24px; align-items:start; }
        @media(max-width:1023px){ .hud-root .hud-grid { grid-template-columns:1fr; } }
        .hud-root .rowWide { display:grid; grid-template-columns:1fr; }
        .hud-root .panel { background: var(--panel); border:1px solid var(--hairline); border-radius:18px; box-shadow:0 1px 0 rgba(0,0,0,.02),0 8px 24px rgba(0,0,0,.04); transition:transform .18s ease, box-shadow .18s ease, max-height .25s ease, padding .25s ease; }
        .hud-root .panel:hover { transform:translateY(-1px); box-shadow:0 2px 0 rgba(0,0,0,.02),0 12px 28px rgba(0,0,0,.06); }
        .hud-root .p16 { padding:16px; }
        .hud-root .p20 { padding:20px; }
        .hud-root .pb8 { padding-bottom:8px; }
        .hud-root .chip { display:inline-flex; align-items:center; gap:6px; padding:4px 10px; border-radius:999px; border:1px solid var(--hairline-strong); background:#b6e7e7; font-size:12px; margin:2px; }
        .hud-root .btn { border:1px solid var(--hairline-strong); background:#fff; border-radius:12px; padding:8px 12px; font-weight:700; cursor:pointer; transition:transform .16s ease, box-shadow .16s ease, background .16s ease, border-color .16s ease; }
        .hud-root .btn:hover { background:rgba(214,160,25,.08); border-color:var(--accent); box-shadow:0 6px 18px rgba(214,160,25,.15); transform:translateY(-1px); }
        .hud-root .grid-steps { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:8px; list-style:none !important; padding:0 !important; margin:0 !important; }
        .hud-root .grid-steps li { list-style:none; margin:0; padding:0; }
        @media(min-width:640px){ .hud-root .grid-steps { grid-template-columns:repeat(3,1fr); } }
        @media(min-width:768px){ .hud-root .grid-steps { grid-template-columns:repeat(4,1fr); } }
        @media(min-width:1024px){ .hud-root .grid-steps { grid-template-columns:repeat(6,1fr); } }
        .hud-root .step { border:1px solid #e9ecef; border-radius:0.75rem; background-color:#fff; box-shadow:0 4px 12px rgba(0,0,0,0.05); transition:all 0.2s ease-in-out; cursor:pointer; min-height:110px; width:100%; font-size:15px; position:relative; overflow:hidden; display:flex; flex-direction:column; justify-content:center; text-align:center; }
        .hud-root .step.small { font-size:15px; }
        .hud-root .step small { display:block; color:#d54760 ; font-weight: bold; font-size:11px; }
        .hud-root .step:hover { transform:translateY(-1px); border-color:var(--accent); box-shadow:0 6px 16px rgba(228,228,228,0.12); }
        .hud-root .step.active { border-color:var(--accent); background:linear-gradient(135deg, color-mix(in oklab, var(--accent) 12%, #fff), #fff); }
        .hud-root .tabs { position:relative; display:flex; gap:8px; border-bottom:1px solid var(--hairline); }
        .hud-root .tab { padding:10px 12px; font-weight:800; color:var(--muted); cursor:pointer; border-radius:10px; }
        .hud-root .tab[aria-selected=\"true\"] { color:var(--accent-ink); }
        .hud-root .underline { position:absolute; bottom:0; height:3px; background:linear-gradient(90deg,var(--accent),var(--accent-2)); border-radius:999px; transition:transform .22s cubic-bezier(.2,.8,.2,1), width .22s cubic-bezier(.2,.8,.2,1); }
        .hud-root .donut-shell {
          display:inline-block;
          width:60px;
          height:60px;
          padding:4px;
          box-sizing:border-box;
          border-radius:50%;
          background:transparent;
        }
        .hud-root .donut-svg { width:52px; height:52px; display:block; border-radius:50%; }
        .hud-root .donut-ring { stroke:var(--hairline-strong); stroke-width:8; fill:none; }
        .hud-root .donut-meter { stroke:var(--accent); stroke-width:8; fill:none; stroke-linecap:round; transform:rotate(-90deg); transform-origin:50% 50%; stroke-dasharray:0 100; }
        .hud-root .pop { position:fixed; top:18px; right:18px; max-width:520px; width:calc(100% - 36px); z-index:999; opacity:0; pointer-events:none; transition:opacity .18s ease, transform .18s ease; transform:translateY(8px); }
        .hud-root .pop.open { opacity:1; pointer-events:auto; transform:translateY(0); }
        .hud-root .pop-card { background:#fff; border:1px solid rgba(0,0,0,0.05); border-radius:18px; box-shadow:0 24px 60px rgba(15,23,42,.18), 0 1px 0 rgba(255,255,255,.8) inset; overflow:hidden; position:relative; }
        .hud-root .pop-card::before { content:""; display:none; }
        .hud-root .pop-head { position:relative; display:flex; align-items:center; justify-content:space-between; gap:8px; padding:14px 16px; cursor:grab; z-index:1; }
        .hud-root .pop-head.dragging { cursor:grabbing; }
        .hud-root .pop-body { position:relative; padding:18px; font-size:13px; color:var(--ink); max-height:70vh; overflow:auto; text-align:left; z-index:1; }
        .hud-root .pop-chip { position:relative; display:inline-flex; align-items:flex-start; justify-content:flex-start; gap:10px; padding:16px 16px 16px 30px; border-radius:14px; border:1px solid rgba(99,102,241,0.18); background:#fff; box-shadow:0 12px 30px rgba(99,102,241,.14), inset 0 1px 0 rgba(255,255,255,.9); text-align:left; transition:transform .12s ease, box-shadow .12s ease; }
        .hud-root .pop-chip:hover { transform:translateY(-2px); box-shadow:0 8px 18px rgba(0,0,0,.08); }
        .hud-root .pop-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:10px; justify-items:start; }
        .hud-root .pop-icon { width:30px; height:30px; border-radius:14px; position:absolute; top:0; left:0; transform:translate(-30%,-30%); display:flex; align-items:center; justify-content:center; background:linear-gradient(135deg,#22c55e,#0ea5e9); color:#fff; font-weight:800; box-shadow:0 6px 16px rgba(14,165,233,.25), inset 0 1px 0 rgba(255,255,255,.6);    padding-top: 2px;  }
        .hud-root .pop-icon i { font-size:18px; line-height:1; }
        .hud-root .pop-empty { color:var(--muted); font-style:italic; padding:6px 0; }
        .hud-root .left-panel { position:sticky; top:82px; align-self:start; max-height:calc(100vh - 120px); overflow:auto; }
        .hud-root .timeline-panel { transition:max-height .25s ease, padding .25s ease; min-height:140px; }
        .hud-root.timeline-collapsed .timeline-panel { max-height:80px; overflow:hidden; padding-top:8px; padding-bottom:8px; }
        .hud-root.timeline-collapsed .step { min-height:60px; font-size:13px; }
        .hud-root.timeline-collapsed .step small { font-size:10px; }
        .idBox{
          position: absolute;
          top:2px;
          left: 2px;
        }
                .meta-tabs {
          margin-top: 8px;
          display: inline-flex;
          gap: 4px;
          padding: 2px;
          border-radius: 999px;
          background: #f3f4f6;
        }
        .meta-tab-button {
          border: none;
          background: transparent;
          padding: 4px 10px;
          border-radius: 999px;
          font-size: 12px;
          cursor: pointer;
          color: #6b7280;
          font-weight: 500;
        }
        .meta-tab-button.meta-tab-active {
          background: #ffffff;
          color: #111827;
          box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        .meta-tab-panels {
          margin-top: 8px;
        }
        .meta-tab-panel {
          display: none;
        }
        .meta-tab-panel.meta-tab-panel-active {
          display: block;
        }
        .meta-edge-list {
          margin-top: 8px;
          font-family: verdana, sans-serif;
          font-size: 12px;
        }
        .meta-edge-row {
          padding: 4px 0;
          border-bottom: 1px solid #e5e7eb;
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          align-items: center;
        }
        .meta-edge-node {
          font-weight: 600;
        }
        .meta-edge-label {
          font-style: italic;
          color: #6b7280;
        }
        .cloud_lozenge{
          border-radius: 6px;
          position: absolute;
          padding:3px;
          top: -2px;
          right: -2px;
          background-color: #ffd40a;
          color: black;
        }
                </style>
            	 
            </head>
            <body>
              <xsl:call-template name="Heading"/>

              <div class="hud-root">
                <!-- New polished HUD playbook layout -->
                <header class="pbheader">
                  <div class="container p16">
                    <div class="hstack" style="justify-content:space-between">
                      <div>
                        <div class="title" style="font-size:20px;">Essential Playbook</div>
                        <div class="subtitle" id="play-subtitle"></div>
                      </div>
                      <div class="hstack" style="align-items:center; gap:10px;">
                        <label class="subtitle" for="playSel" style="margin:0;">Select play</label>
                        <select id="playSel" aria-label="Select play"></select>
                      </div>
                    </div>
                  </div>
                </header>

                <main class="container" style="padding-top:24px;padding-bottom:32px">
                  <div class="hud-grid">
                    <section class="panel p20 left-panel" id="left-panel" aria-labelledby="play-heading" style="height:100%;"></section>
                    <div class="vstack" style="gap:4px">
                      <section class="panel p20 timeline-panel" id="timeline-panel" aria-labelledby="timeline-heading"></section>
                      <section class="panel" id="step-details" aria-live="polite"></section>
                    </div>
                  </div>
                </main>

                <div class="pop" id="pop-panel" aria-live="polite" aria-atomic="true">
                  <div class="pop-card" role="dialog" aria-modal="false" aria-labelledby="pop-title">
                    <div class="pop-head">
                      <div id="pop-title" style="font-weight:800;font-size:14px"></div>
                      <button id="pop-close" class="btn" style="font-size:12px;padding:6px 10px" aria-label="Close info panel">Close</button>
                    </div>
                    <div class="pop-body" id="pop-body"></div>
                  </div>
                </div>

              <!-- HUD templates -->
              <script id="tpl-left" type="text/x-handlebars-template">
                <div class="hstack" style="justify-content:space-between" aria-live="polite">
                  <div>
                    <h4>Description</h4>
                    <p class="subtitle" style="margin:6px 0 0">{{summary}}</p>
                  </div>
                  <!--
                  <div class="donut-shell"><xsl:attribute name="aria-label">Completeness {{percent completeness}}</xsl:attribute>{{{donut completeness}}}</div>
                -->
                </div>
                <div style="height:10px"></div>
                <div>
                  <span class="chip" aria-label="Category">{{category}}</span>
                  <span class="chip" aria-label="Priority">Priority: {{priority}}</span>
                  <span class="chip" aria-label="Duration">Duration: {{duration}}</span>
                </div>
                <div style="height:10px"></div>
                <div class="hstack" style="flex-wrap:wrap;gap:8px">
                  <button class="btn pop-btn" data-open-pop="prereqs" aria-controls="pop-panel" aria-expanded="false">Prereqs</button>
                   <button class="btn pop-btn" data-open-pop="impacts" aria-controls="pop-panel" aria-expanded="false">Impacts</button>
                   <button class="btn pop-btn" data-open-pop="initiators" aria-controls="pop-panel" aria-expanded="false">Initiators</button>
                   <button class="btn pop-btn" data-open-pop="inputs" aria-controls="pop-panel" aria-expanded="false">Inputs</button>
                   <button class="btn pop-btn" data-open-pop="start" aria-controls="pop-panel" aria-expanded="false">Starting Position</button>
                  <button class="btn pop-btn" data-open-pop="target" aria-controls="pop-panel" aria-expanded="false">Target State</button>
                  <button class="btn pop-btn" data-open-pop="outcomes" aria-controls="pop-panel" aria-expanded="false">Outcomes</button>
                
                   <button class="btn pop-btn" data-open-pop="comm" aria-controls="pop-panel" aria-expanded="false">Communication</button>
                  <button class="btn pop-btn" data-open-pop="plan" aria-controls="pop-panel" aria-expanded="false">Plan</button>
                </div>
              </script>

              <script id="tpl-timeline" type="text/x-handlebars-template">
                <div id="timeline-heading" style="font-weight:800">Action Plan Steps</div>
                <div style="height:10px"></div>
                <ul class="grid-steps" role="tablist" aria-label="Steps">
                  {{#each plan}}
                    <li>
                      <button role="tab" ><xsl:attribute name="class">step {{#if (eq id ../activeId)}}active{{/if}} {{#if small}}small{{/if}}</xsl:attribute><xsl:attribute name="aria-selected">{{#if (eq id ../activeId)}}true{{else}}false{{/if}}</xsl:attribute><xsl:attribute name="data-step">{{id}}</xsl:attribute><xsl:attribute name="aria-label">Step {{id}}: {{title}}</xsl:attribute>
                        <div style="font-weight:800">{{title}}</div>
                        <div class="idBox"><small>{{id}}</small></div>
                      </button>
                    </li>
                  {{/each}}
                </ul>
              </script>

              <script id="tpl-step" type="text/x-handlebars-template">
                <div class="p20 pb8 hstack" style="justify-content:space-between">
                  <div style="font-size:18px;font-weight:900">Step {{id}}: {{title}}</div>
                <!--  <div class="hstack subtitle" style="font-size:12px"><span>Completeness</span><div class="donut">{{{donut completeness}}}</div></div>-->
                </div>
                <div class="p16">
                  <div class="tabs" id="tabs" role="tablist">
                    {{#each tabs}}
                      {{#unless (and (eq this.label "Resources") (eq ../resources.length 0))}}
                        <div class="tab" role="tab">
                          <xsl:attribute name="tabindex">{{#if active}}0{{else}}-1{{/if}}</xsl:attribute>
                          <xsl:attribute name="aria-selected">{{#if active}}true{{else}}false{{/if}}</xsl:attribute>
                          <xsl:attribute name="data-tab-index">{{@index}}</xsl:attribute>
                            {{this.label}}
                        </div>
                      {{/unless}}
                    {{/each}}
                    <div class="underline" id="underline" style="width:0;transform:translateX(0)"></div>
                  </div>
                  <div id="tab-content" style="padding:16px 4px"></div>
                </div>
              </script>

              <script id="tpl-tab-0" type="text/x-handlebars-template">
                <div class="rowWide" style="gap:16px">
                  <div>
                    <div style="font-weight:800">Step Description</div>
                    <p class="subtitle">{{description}}</p>
                    <div style="font-weight:800;margin-top:8px">Data Requirements</div>
                    <ul>
                      {{#each dataRequirements}}<li>{{this}}</li>{{/each}}
                    </ul>
                  </div>
                  <div>
                    <div style="border:1px solid var(--hairline);border-radius:14px;padding:12px">
                    </div>
                  </div>
                </div>
              </script>
              <script id="tpl-tab-05" type="text/x-handlebars-template">
                <div class="rowWide" style="gap:16px">
                  <div>
                    <div style="font-weight:800">Tasks</div>
                    <p class="subtitle">{{description}}</p>
                    <div class="task-list">
                      {{#if tasks.length}}
                        {{#each tasks}}
                          <div class="task-card">
                            <div class="task-header">
                              <span class="chip">{{id}}</span>
                              <span class="task-title">{{title}}</span>
                              {{#if completed}}<span class="chip" aria-label="Task completed" style="background:#e7f5ed;color:#15803d;border-color:#bbf7d0;">Completed</span>{{/if}}
                            </div>
                            <div class="task-description">{{description}}</div>
                            {{#if method.length}}
                              <div class="task-subhead">Methods</div>
                              <ul class="task-bullets">
                                {{#each method}}
                                  <li>
                                    {{#if tool}}<strong>{{tool}}:</strong> {{/if}}
                                    {{#if name}}{{name}}{{else}}{{this}}{{/if}}
                                  </li>
                                {{/each}}
                              </ul>
                            {{/if}}
                            {{#if taskResources.length}}
                              <div class="task-subhead">Resources</div>
                              <div class="task-resource-grid">
                                {{#each taskResources}}
                                  <div class="task-resource-card" role="button" tabindex="0">
                                    <xsl:attribute name="data-link">{{link}}</xsl:attribute>
                                    <xsl:attribute name="aria-label"></xsl:attribute>
                                    {{#if image}}
                                      <img style="border-bottom: red solid 2px;">
                                        <xsl:attribute name="src">{{image}}</xsl:attribute>
                                        <xsl:attribute name="alt">{{title}}</xsl:attribute>
                                      </img>
                                    {{/if}}
                                    <div class="task-resource-body">
                                      <div class="task-resource-type">
                                        {{type}}
                                        {{!-- Cloud/Docker-only hint if this resource has an editor and we are not on EIP --}}
                                        {{#if editorId}}
                                          {{#unless @root.eip}}
                                              <div class="cloud_lozenge" style="font-weight:600">Cloud/Docker only</div>
                                          {{/unless}}
                                        {{/if}}
                                      </div>
                                      <div class="task-resource-title">{{title}}</div>
                                      <div class="task-resource-actions" style="margin-top:6px;display:flex;flex-wrap:wrap;gap:6px;">
                                        {{!-- Primary action based on link type (Watch/Read) --}}
                                        {{#if link}}
                                          {{#if (contains link "youtu.be")}}
                                            <a class="video-popup">
                                              <xsl:attribute name="href">{{link}}</xsl:attribute>
                                              <xsl:attribute name="data-video-url">{{link}}</xsl:attribute>
                                              <button class="btn btn-xs">
                                                <xsl:value-of select="eas:i18n('Watch')"/>
                                              </button>
                                            </a>
                                          {{else}}
                                            <a>
                                              <xsl:attribute name="onclick">
                                                window.open('{{link}}', '_blank', 'width=800,height=600')
                                              </xsl:attribute>
                                              <button class="btn btn-xs">
                                                {{#if (contains link "youtu.be")}}
                                                  <xsl:value-of select="eas:i18n('Watch')"/>
                                                {{else}}
                                                  <xsl:value-of select="eas:i18n('Read')"/>
                                                {{/if}}
                                              </button>
                                            </a>
                                          {{/if}}
                                        {{/if}}
                                        {{!-- Editor launch actions (only when running on EIP) --}}
                                        {{#if @root.eip}}
                                          {{#if editorId}}
                                            {{#if (eq title "BPMN - Flow Editor")}}
                                              <a>
                                                <xsl:attribute name="href">{{editorId}}</xsl:attribute>
                                                <xsl:attribute name="target">_blank</xsl:attribute>
                                                <button class="btn btn-xs">BPMN Editor</button>
                                              </a>
                                            {{else}}
                                              {{#if (eq title "Essential Set up Manager - Cloud/Docker")}}
                                                <a>
                                                  <xsl:attribute name="href">{{editorId}}</xsl:attribute>
                                                  <xsl:attribute name="target">_blank</xsl:attribute>
                                                  <button class="btn btn-xs">Setup Manager</button>
                                                </a>
                                              {{else}}
                                                <a>
                                                  <xsl:attribute name="href">report?XML=reportXML.xml&amp;PMA=&amp;cl=en-gb&amp;XSL=ess_editor.xsl&amp;EDITOR={{editorId}}&amp;SECTION=main_section</xsl:attribute>
                                                  <xsl:attribute name="target">_blank</xsl:attribute>
                                                  <button class="btn btn-xs">Editor</button>
                                                </a>
                                              {{/if}}
                                            {{/if}}
                                          {{/if}}
                                        {{/if}}
                                      </div>
                                    </div>
                                  </div>
                                {{/each}}
                              </div>
                            {{/if}}
                          </div>
                        {{/each}}
                      {{else}}
                        <em class="subtitle">No tasks captured for this step yet.</em>
                      {{/if}}
                    </div>
                  </div>
                </div>
              </script>

              <script id="tpl-tab-1" type="text/x-handlebars-template">
                <div class="rowWide" style="gap:16px">
                  <div>
                    <div style="font-weight:800">Key Views Generated</div>
                    <ul>
                      {{#each views}}<li>{{this}}</li>{{/each}}
                    </ul>
                  </div>
                  <div>
  <div style="font-weight:800">Meta Model Dependencies</div>
  <small>Drag nodes, drag the page and zoom as necessary.  A grey line means no relationships found</small>
  <br/>
  <div class="meta-tabs">
    <button type="button" class="meta-tab-button meta-tab-active" data-meta-tab="graph">Graph</button>
    <button type="button" class="meta-tab-button" data-meta-tab="list">List</button>
  </div>

  <div class="meta-tab-panels">
    <div class="meta-tab-panel meta-tab-panel-active" data-meta-panel="graph">
      <ul style="font-family:verdana">
        <!-- FUTURE
        <div id="controls">
          <button id="export-svg">Export as SVG</button>
          <button id="export-png">Export as PNG</button> 
        </div>
        -->
        <svg width="100%" height="1200" viewBox="0 0 1000 1200" preserveAspectRatio="xMidYMid meet" style="max-width: 100%; display: block;"></svg>
      </ul>
    </div>
    <div class="meta-tab-panel" data-meta-panel="list">
      <div id="edgeList" class="meta-edge-list"></div>
    </div>
  </div>
</div>
                </div>
              </script>

              <script id="tpl-tab-2" type="text/x-handlebars-template">
                <div class="rowWide" style="gap:16px">
                  <div>
                    <div style="font-weight:800">Primary Stakeholders</div>
                    <div>
                      {{#each stakeholders}}<span class="chip">{{this}}</span>{{/each}}
                    </div>
                  </div>
                  <div>
                    <div style="font-weight:800">Insights</div>
                    <div>
                      {{#each insights}}
                        <div style="border:1px solid var(--hairline);border-radius:12px;padding:10px;background:rgba(255,255,255,.6);margin-bottom:3px">
                          {{#if text}}
                            {{text}}
                            {{#if subBullets}}
                              <ul style="margin-top:6px;padding-left:18px">
                                {{#each subBullets}}<li>{{this}}</li>{{/each}}
                              </ul>
                            {{/if}}
                          {{else}}
                            {{this}}
                          {{/if}}
                        </div>
                      {{/each}}
                    </div>
                  </div>
                </div>
              </script>

              <script id="tpl-tab-3" type="text/x-handlebars-template">
                {{#if resources.length}}
                  <div style="display:grid;gap:8px">
                  {{#each resources}}
                    <a href="{{link}}" target="_blank" rel="noreferrer" class="btn" style="display:flex;justify-content:space-between;align-items:center;text-decoration:none">
                      <span>
                        <div style="font-weight:800">{{title}}</div>
                        <div class="subtitle" style="font-size:12px">{{type}}</div>
                      </span>
                      <span style="color:var(--accent-ink)">Open →</span>
                    </a>
                  {{/each}}
                  </div>
                {{else}}
                  <em class="subtitle">No task‑specific resources.</em>
                {{/if}}
              </script>

               <script id="counts-card-template" type="text/x-handlebars-template">
                  <div class="blob classBlob">{{source}}</div>
                  {{#ifEquals count 0}}
                  <div class="blob slotBlobRed">{{slot}}</div>
                  {{else}}
                  <div class="blob slotBlob">{{slot}}</div>
                  {{/ifEquals}}
                  <div class="blob classBlob">{{target}}</div>
                  <div class="blob countBlob">{{count}}</div><br/>
              </script>

              
              <!-- Legacy layout removed -->
              </div><!-- /.hud-root -->




  <!-- spares -->
  <!-- 
   
          {
            "id": "B1.1.1",
            "title": "Define the Business Domains in your Organisation",
            "completed": false,
            "method": [
              {
                "tool": "Analysis",
                "name": "Discuss with the Business Analysts",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University ",
                "title": "Business Modelling",
                "link": "https://enterprise-architecture.org/university/business-modelling/",
              "image": "images/reading3.webp"
              }
            ]
          },

   -->

  <script>
 
    let viewsData = { viewData: [] };
    let hudInitialized = false;
    let countCardTemplate;
let viewAPIData ='<xsl:value-of select="$apiPathClass"/>'; 

    // Cache counts to avoid repeated API calls for the same slot/class combination
    const countCache = new Map();
    const toggleSpinner = (show) => {
      if (typeof $ === 'undefined') return;
      const $spinner = $('#spinner');
      if ($spinner.length) {
        show ? $spinner.show() : $spinner.hide();
      }
    };

        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            <!--$('#ess-data-gen-alert').hide();-->
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
 
    <!-- map functions -->

function createSlotClassArray(dataset) { 
    // Create a lookup for node information by ID for easy access
    const nodeLookup = Object.fromEntries(
        dataset.nodes.map(node => [node.id, node])
    );

    // Iterate over edges and map to the required structure
    const slotClassArray = dataset.edges.map(edge => {
        const sourceNode = nodeLookup[edge.source];
        const targetNode = nodeLookup[edge.target];
        let classLookup = sourceNode?.class 
        let inverse = false;
        if(edge.query){
             
             classLookup = edge.query;
             inverse=true;
        }
      
        return {
            slot: edge.label,
            inverse: inverse,
            class: classLookup || null,
            target: targetNode?.class || null,
            sourceid: edge.source,
            targetid: edge.target
        };
    });

    return slotClassArray;
}


function getData(dta){
  console.log('getData')
    return promise_loadViewerAPIData(dta)
        .then(function(response1) {
        
            //after the first data set is retrieved, set a global variable and render the view elements from the returned JSON data (e.g. via handlebars templates)
            thisviewAPIData = response1; 

            return thisviewAPIData
    

        }).catch (function (error) {
            console.error('Error loading data set', error);
            //display an error somewhere on the page   
        });
    }   
    
async function fetchCountForKey(slot, cls) {
  const slotParam = slot || '';
  const classParam = cls || '';
  const cacheKey = `${slotParam}::${classParam}`;
  if (countCache.has(cacheKey)) {
    return countCache.get(cacheKey);
  }

  const datapath = viewAPIData + '&amp;PMA=' + slotParam + '&amp;PMA2=' + classParam;
  const promise = getData(datapath)
    .then(result => {
      const safeResult = result || {};
      const count = (safeResult.count || 0) + (safeResult.supercount || 0);
      countCache.set(cacheKey, count);
      return count;
    })
    .catch(err => {
      console.error('Error retrieving data for', cacheKey, err);
      countCache.set(cacheKey, 0);
      return 0;
    });

  countCache.set(cacheKey, promise);
  return promise;
}

async function fetchCountsAndMerge(nodeData) {
  const slotClassArray = createSlotClassArray(nodeData);
  toggleSpinner(true);

  try {
    const counts = await Promise.all(
      slotClassArray.map(async d => {
        const count = await fetchCountForKey(d.slot, d.class);
        return { ...d, count };
      })
    );

    const countMap = counts.reduce((map, entry) => {
      map[`${entry.sourceid}-${entry.targetid}`] = entry.count;
      return map;
    }, {});

    return nodeData.edges.map(edge => {
      const key = `${edge.source}-${edge.target}`;
      return {
        ...edge,
        count: countMap[key] != null ? countMap[key] : 0
      };
    });
  } finally {
    toggleSpinner(false);
  }
}

function createMap(nodeData, savedTransform) {
console.log('createMap')
    const nodesData = nodeData.nodes || [];
    let edgesData = nodeData.edges || [];
    const svg = d3.select('#tab-content svg');
    if (svg.empty()) return;
    svg.selectAll('*').remove();
    const container = svg.append('g').attr('class', 'map-root');
    // Enable zoom/pan on the SVG
    const zoom = d3.zoom()
      .scaleExtent([0.25, 4])
      .on('zoom', (event) => container.attr('transform', event.transform));
    svg.call(zoom).call(zoom.transform, d3.zoomIdentity); // reset any previous transform
 
    // Layout parameters
    const xSpacing = 170;    // horizontal spacing per depth
    const ySpacing = 100;    // vertical spacing per level
    const branchOffsetX = 50; // extra X offset for branches
    const startX = 100;
    const startY = 100;

    // Quick lookup
    const nodeMap = {};
    nodesData.forEach(n => nodeMap[n.id] = n);

    // Group edges by source
    const edgesBySource = d3.group(edgesData, e => e.source);

    // —————————————————————————————————————————
    // 1) GROUP NODES INTO PATHS (for branches)
    // —————————————————————————————————————————
    function groupNodes(edges) {
        const graph = {};
        edges.forEach(e => {
            if (!graph[e.source]) graph[e.source] = [];
            graph[e.source].push(e.target);
        });

        const targets = new Set(edges.map(e => e.target));
        const sources = Array.from(new Set(edges.map(e => e.source)));
        const roots = sources.filter(s => !targets.has(s));

        const groups = [];
        function dfs(node, grp) {
            grp.push(node);
            const neigh = graph[node] || [];
            if (neigh.length > 1) {
                neigh.forEach((tgt, i) => {
                    if (i === 0) {
                        dfs(tgt, grp);
                    } else {
                        const newGrp = [node];
                        dfs(tgt, newGrp);
                        groups.push(newGrp);
                    }
                });
            } else if (neigh.length === 1) {
                dfs(neigh[0], grp);
            }
        }

        roots.forEach(r => {
            const g = [];
            dfs(r, g);
            groups.push(g);
        });
        return groups;
    }

    // 2) ASSIGN BRANCH NUMBERS TO EDGES
    function assignBranchesToEdges(edges, groups) {
        let branchNum = 1;
        const updated = edges.map(e => ({ ...e, branch: null }));
        groups.forEach(g => {
            for (let i = 0; i &lt; g.length - 1; i++) {
                const src = g[i], tgt = g[i+1];
                const edge = updated.find(e => e.source === src &amp;&amp; e.target === tgt &amp;&amp; e.branch === null);
                if (edge) edge.branch = branchNum;
            }
            branchNum++;
        });
        return updated;
    }

    const routes = groupNodes(edgesData);
    edgesData = assignBranchesToEdges(edgesData, routes);

    // ——————————————————————————————
    // 3) ASSIGN INITIAL POSITIONS
    // ——————————————————————————————

    let nodePositions = {};

    let nextAvailableY = 1;

        // Function to assign positions using BFS
        function assignPositions() {
          const adjacency = d3.group(edgesData, d => d.source);
          nodePositions = {};

          const roots = findRoots(nodesData, edgesData);
          const startX = 100;
          const startY = 100;
          const xStep = 170;
          const yStep = 120;

          let yLevel = 0;

          roots.forEach(root => {
            const queue = [];
            nodePositions[root.id] = { x: startX, y: startY + yLevel * yStep };
            queue.push({ node: root, depth: 0 });

            while (queue.length) {
              const { node, depth } = queue.shift();
              const children = adjacency.get(node.id) || [];

              children.forEach((edge, i) => {
                const child = nodesData.find(n => n.id === edge.target);
                if (!child || nodePositions[child.id]) return;

                nodePositions[child.id] = {
                  x: startX + (depth + 1) * xStep,
                  y: startY + (yLevel * yStep) + i * yStep
                };

                queue.push({ node: child, depth: depth + 1 });
              });
            }

            yLevel += 1; // next root on a new row if you have multiple roots
          });
        }

    

    if (savedTransform) {
        Object.assign(nodePositions, savedTransform);
    } else {
        assignPositions();
    }

  const firstBranches = {};
        edgesData.forEach(edge => {
            if (!firstBranches[edge.source]) {
                firstBranches[edge.source] = edge.target;
                edge.isFirstBranch = true;
            } else {
                edge.isFirstBranch = false;
            }
        });

        // Function to generate vertical + smooth horizontal curve path for branches
        function generateBranchPath(source, target) {
            const sourcePos = nodePositions[source];
            const targetPos = nodePositions[target];

            // If source and target y positions are the same, draw a straight line
            if (sourcePos.y === targetPos.y) {
                return `M${sourcePos.x},${sourcePos.y} H${targetPos.x}`;
            }

            // Otherwise, draw a curved path
            const midY = (sourcePos.y + targetPos.y) / 2;

            // Path: Move vertically down from source, then smooth curve horizontally to target
            return `M${sourcePos.x},${sourcePos.y}
                    V${targetPos.y - 30}
                    C${sourcePos.x},${targetPos.y - 20} ${sourcePos.x},${targetPos.y} ${sourcePos.x + 30},${targetPos.y} H${targetPos.x}`;
        }

        function findRoots(nodes, edges) {
          const hasIncoming = new Set(edges.map(e => e.target));
          return nodes.filter(n => !hasIncoming.has(n.id));
        }


        // Ensure minimum horizontal spacing of 100px between nodes on the same Y-level
   function adjustPositions() { 

  // Only work with nodes that actually have a position
  const positionedNodes = nodesData.filter(d => nodePositions[d.id]);

  const nodesByY = d3.group(
    positionedNodes,
    d => nodePositions[d.id].y
  );

  nodesByY.forEach(group => {
    const sortedNodes = Array.from(group)
      .sort((a, b) => nodePositions[a.id].x - nodePositions[b.id].x);

    let prevX = -Infinity;

    sortedNodes.forEach(node => {
      const pos = nodePositions[node.id];
      if (pos.x - prevX &lt; 100) {
        pos.x = prevX + 100;
      }
      prevX = pos.x;
    });
  });
}

        adjustPositions();

        // Redefine nodeMap after adjusting positions (if necessary)
        nodesData.forEach(node => {
            nodeMap[node.id] = node;
        });

        // Define a color scale for branches
        const color = d3.scaleOrdinal(d3.schemeCategory10);

    // ——————————————————————————————
    // 5) DRAG HANDLERS
    // ——————————————————————————————
    function dragstarted(event, d) {
        d3.select(this).raise().attr("stroke", "black");
    }

    function dragged(event, d) {
        // update data
        nodePositions[d.id] = { x: event.x, y: event.y };

        // move circle + label
        d3.select(this)
          .attr("cx", event.x)
          .attr("cy", event.y);
        d3.select(`#node-label-${d.id}`)
          .attr("x", event.x)
          .attr("y", event.y - 20);

        // redraw links
    // Redraw only affected links
container.selectAll(".link")
    .filter(l => l.source === d.id || l.target === d.id)
    .attr("d", l => {
    const s = nodePositions[l.source];
    const t = nodePositions[l.target];

    const dx = t.x - s.x;
    const dy = t.y - s.y;
    const absDx = Math.abs(dx);
    const absDy = Math.abs(dy);
    const corner = 30;
    const tolerance = 12;

    // Snap to horizontal line
    if (absDy &lt; tolerance) {
        return `M${s.x},${s.y} H${t.x}`;
    }

    // Snap to vertical line
    if (absDx &lt; tolerance) {
        return `M${s.x},${s.y} V${t.y}`;
    }

    // Right/Left then Down/Up (curve near target)
    if (absDx > absDy) {
        const midX = t.x - corner * Math.sign(dx);
        const ctrlX = t.x - 10 * Math.sign(dx);
        const ctrlY = s.y + 10 * Math.sign(dy);
        return `M${s.x},${s.y}
                H${midX}
                C${ctrlX},${s.y} ${t.x},${s.y} ${t.x},${s.y + corner * Math.sign(dy)}
                V${t.y}`;
    }

    // Down/Up then Right/Left (curve near target)
    const midY = t.y - corner * Math.sign(dy);
    const ctrlY = t.y - 10 * Math.sign(dy);
    const ctrlX = s.x + 10 * Math.sign(dx);
    return `M${s.x},${s.y}
            V${midY}
            C${s.x},${ctrlY} ${s.x},${t.y} ${s.x + corner * Math.sign(dx)},${t.y}
            H${t.x}`;
});


// Reposition affected labels
container.selectAll(".label")
    .filter(l => l.source === d.id || l.target === d.id)
    .attr("x", l => {
        const s = nodePositions[l.source], t = nodePositions[l.target];
        return l.isFirstBranch
            ? (s.x + t.x) / 2
            : (s.x + t.x) / 2 + 15;
    })
    .attr("y", l => {
        const s = nodePositions[l.source], t = nodePositions[l.target];
        return l.isFirstBranch
            ? (s.y + t.y) / 2 + 15
            : t.y + 15;
    });

    }

    function dragended(event, d) {
        d3.select(this).attr("stroke", "#333");
    }

    function dragstartedLabel(event, d) {
        d3.select(this).raise().attr("font-weight", "bold");
    }
    function draggedLabel(event, d) {
        d3.select(this)
          .attr("x", event.x)
          .attr("y", event.y);
    }
    function dragendedLabel(event, d) {
        d3.select(this).attr("font-weight", "normal");
    }

    // ——————————————————————————————
    // 6) RENDER LINKS (one‐time draw-on + clear dash)
    // ——————————————————————————————
    container.selectAll(".link")
        .data(edgesData)
        .enter()
      .append("path")
        .attr("class", "link")
        .attr("d", d => d.isFirstBranch
             ? (() => {
                 const s = nodePositions[d.source], t = nodePositions[d.target];
                 return `M${s.x},${s.y} L${t.x},${t.y}`;
               })()
             : generateBranchPath(d.source, d.target))
        .attr("stroke", d => {
            const lane = nodePositions[d.target].y / ySpacing;
            return color(lane);
        })
        .attr("stroke-width", 5)
        .attr("fill", "none")
      .each(function() {
        const path = d3.select(this);
        const len = this.getTotalLength();
        path
          .attr("stroke-dasharray", `${len} ${len}`)
          .attr("stroke-dashoffset", len)
          .transition()
            .duration(1000)
            .ease(d3.easeLinear)
            .attr("stroke-dashoffset", 0)
            .on("end", () => path.attr("stroke-dasharray", null));
      });

    // ——————————————————————————————
    // 7) RENDER EDGE LABELS
    // ——————————————————————————————
    container.selectAll(".label")
        .data(edgesData)
        .enter()
      .append("text")
        .attr("class", "label")
        .attr("x", d => {
            const s = nodePositions[d.source], t = nodePositions[d.target];
            return d.isFirstBranch
                ? (s.x + t.x) / 2
                : (s.x + t.x) / 2 + 15;
        })
        .attr("y", d => {
            const s = nodePositions[d.source], t = nodePositions[d.target];
            return d.isFirstBranch
                ? (s.y + t.y) / 2 + 15
                : t.y + 15;
        })
        .text(d => d.label)
        .call(d3.drag()
            .on("start", dragstartedLabel)
            .on("drag", draggedLabel)
            .on("end", dragendedLabel)
        );

    // ——————————————————————————————
    // 8) RENDER NODES + NODE LABELS
    // ——————————————————————————————
    container.selectAll(".node")
        .data(nodesData.filter(d => nodePositions[d.id]))
        .enter()
      .append("circle")
        .attr("class", "node")
        .attr("cx", d => nodePositions[d.id].x)
        .attr("cy", d => nodePositions[d.id].y)
        .attr("r", 10)
        .attr("fill", "#fff")
        .attr("stroke", "#333")
        .attr("stroke-width", 3)
        .call(d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended)
        );

    container.selectAll(".node-label")
        .data(nodesData)
        .enter()
      .append("text")
        .attr("class", "node-label")
        .attr("id", d => `node-label-${d.id}`)
        .attr("x", d => nodePositions[d.id].x)
        .attr("y", d => nodePositions[d.id].y - 20)
        .attr("fill", "#000")
        .attr("font-family", "Arial")
        .text(d => d.name);

    // (optional: tooltips, viewBox adjustment, etc.)
        const nodeLookup = Object.fromEntries(
        nodeData.nodes.map(node => [node.id, node])
        );
            fetchCountsAndMerge(nodeData)
        .then(merged => {
           $('#dataCounts').empty(); 

            const $edgeList = $('#edgeList');
            if ($edgeList.length) {
              $edgeList.empty();
            }

            // Update edge labels with counts
            container.selectAll(".label")
              .data(merged)
              .text(d => `${d.label}${d.count ? ` (${d.count})` : ''}`);

            container.selectAll(".link")
              .data(merged)
              .attr("stroke", d => d.count === 0 ? "#d3d3d3" : color(nodePositions[d.target].y / ySpacing))
              .attr("stroke-dasharray", d => d.count === 0 ? "6,4" : null);

            // dataCounts + edge list
            merged.forEach((n) => {
              thisNode = {
                source: nodeLookup[n.source].name,
                target: nodeLookup[n.target].name,
                slot: n.label,
                count: n.count
              };

              $('#dataCounts').append(countCardTemplate(thisNode));

              if ($edgeList &amp;&amp; $edgeList.length) {
                const rowHtml = `
                  <div class="meta-edge-row">
                    <span class="meta-edge-node">${thisNode.source}</span>
                    <span class="meta-edge-label">${thisNode.slot || ''}</span>
                    <span class="meta-edge-node">${thisNode.target}</span>
                    ${typeof thisNode.count === 'number' ? `<span>(${thisNode.count})</span>` : ''}
                  </div>`;
                $edgeList.append(rowHtml);
              }
            });
        })
        .catch(err => {
            console.error('Something went wrong:', err);
        }); 
}
  
   
    // Convert YouTube links to an embeddable URL
    function convertToEmbedUrl(url) {
      const match = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&amp;]+)/);
      return match ? `https://www.youtube.com/embed/${match[1]}?autoplay=1` : url;
    }

    // Lazy-create a simple modal to host video iframes
    function ensureVideoModal() {
      if (document.getElementById('videoModal')) return;
      const modal = document.createElement('div');
      modal.id = 'videoModal';
      modal.setAttribute('style', 'display:none;position:fixed;z-index:9999;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.75);align-items:center;justify-content:center;');
      modal.innerHTML = `
        <div style="position:relative;width:80%;max-width:960px;aspect-ratio:16/9;background:#000;box-shadow:0 10px 30px rgba(0,0,0,0.3);">
          <button id="videoModalClose" style="position:absolute;top:-36px;right:0;padding:6px 10px;border:1px solid #ccc;border-radius:6px;background:#fff;cursor:pointer;">Close</button>
          <iframe id="videoIframe" src="" title="Video" allow="fullscreen; autoplay; encrypted-media" style="width:100%;height:100%;border:0;"></iframe>
        </div>`;
      document.body.appendChild(modal);
    }

    function openVideoModal(videoUrl) {
      ensureVideoModal();
      const modal = document.getElementById('videoModal');
      const iframe = document.getElementById('videoIframe');
      if (iframe) iframe.src = convertToEmbedUrl(videoUrl || '');
      if (modal) modal.style.display = 'flex';
    }

    function closeVideoModal() {
      const modal = document.getElementById('videoModal');
      const iframe = document.getElementById('videoIframe');
      if (iframe) iframe.src = '';
      if (modal) modal.style.display = 'none';
    }

    $(document).ready(function () {
      // Helpers
      Handlebars.registerHelper('eq', function (a, b) {
        return String(a) === String(b);
      });

      Handlebars.registerHelper('and', function(a, b) {
        return a &amp;&amp; b;
      });

      Handlebars.registerHelper('percent', function (n) {
        const num = typeof n === 'number' ? n : parseFloat(n || 0);
        const val = Math.max(0, Math.min(1, isNaN(num) ? 0 : num));
        return `${Math.round(val * 100)}%`;
      });
      <![CDATA[
       const countCard = document.getElementById('counts-card-template').innerHTML;
        countCardTemplate = Handlebars.compile(countCard);

         Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
				return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
			});
        Handlebars.registerHelper('contains', function (str, substr) {
            if (typeof str !== 'string' || typeof substr !== 'string') return false;
            return str.indexOf(substr) !== -1;
        });

      Handlebars.registerHelper('donut', function (n) {
        const num = typeof n === 'number' ? n : parseFloat(n || 0);
        const val = Math.max(0, Math.min(1, isNaN(num) ? 0 : num));
        const dash = (val * 100).toFixed(1);
        const rest = (100 - val * 100).toFixed(1);
        return `
<svg viewBox="0 0 36 36" class="donut-svg" role="img" aria-label="${Math.round(val * 100)}% complete">
  <circle class="donut-ring" cx="18" cy="18" r="15.9155"></circle>
  <circle class="donut-meter" cx="18" cy="18" r="15.9155" data-dash="${dash}" data-rest="${rest}" style="stroke-dasharray:0 ${rest}"></circle>
  <text x="18" y="20.35" class="donut-text" text-anchor="middle" font-size="10" fill="currentColor">${Math.round(val * 100)}%</text>
</svg>`;
      });
]]>
      $.getJSON('enterprise/viewsData.json', function(data) {
        console.log('Loaded JSON:', data);
        viewsData = data || { viewData: [] };
        initHud();
      }).fail(function(jqxhr, textStatus, error) {
        console.error("Error loading viewsData.json:", textStatus, error);
        initHud();
      });

      console.log('samplePlays',samplePlays)
      // Data normalisation
      const playsRaw = (typeof samplePlays !== 'undefined' &amp;&amp; Array.isArray(samplePlays)) ? samplePlays : [];
      const stepsRaw = (typeof stepsList !== 'undefined' &amp;&amp; Array.isArray(stepsList.steps)) ? stepsList.steps : [];
      const stepsById = Object.fromEntries(stepsRaw.map(s => [s.id, s]));
console.log('stepsById',stepsById)
      function toTextList(arr, mapFn) {
        if (!Array.isArray(arr)) return [];
        return arr.map(item => {
          if (typeof mapFn === 'function') return mapFn(item);
          if (typeof item === 'string') return item;
          if (item &amp;&amp; typeof item === 'object') {
            const first = Object.values(item).find(Boolean);
            return typeof first === 'string' ? first : JSON.stringify(item);
          }
          return String(item || '');
        });
      }

      function getCompletenessFromTasks(tasks) {
        if (!Array.isArray(tasks) || tasks.length === 0) return 0.6;
        const done = tasks.filter(t => t.completed).length;
        return Math.max(0, Math.min(1, done / tasks.length));
      }
      let eip=false;
      <xsl:if test="$eipMode = 'true'">eip=true</xsl:if>

      function normalizeStep(stepId) {
        const step = stepsById[stepId] || { id: stepId, title: title };
        const views = (step.viewsEnabled || []).map(v => (typeof v === 'string' ? v : v.name || JSON.stringify(v)));
        const model = step.model || [];
        const tasks = Array.isArray(step.tasks) ? step.tasks : [];
        const stakeholders = toTextList(step.stakeholders);
        const insights = (step.insights || []).map(i => {
          if (typeof i === 'string') return { text: i };
          return i;
        });
        const resources = step.resources || [];
        const completeness = step.completeness || getCompletenessFromTasks(tasks);
        return { ...step, views, model, tasks, stakeholders, insights, resources, completeness };
      }

      function normalizePlay(play) {
        
        const planSteps = play.plan || play.planSteps || [];
        const timelineSteps = Array.isArray(play.steps) ? play.steps : [];
        const plan = timelineSteps.map(id => {
          const s = stepsById[id];
          console.log('s',s)
          return { id, title: (s &amp;&amp; s.title) || id, small: ((s &amp;&amp; (s.title || '') || '').length > 20) };
        });
        const communication = toTextList(play.communication, item => {
          if (item &amp;&amp; item.channel &amp;&amp; item.purpose) return `${item.channel}: ${item.purpose}`;
          return typeof item === 'string' ? item : '';
        });
        const inputs = toTextList(play.inputs, item => {
          if (item &amp;&amp; item.person &amp;&amp; item.purpose) return `${item.person} – ${item.purpose}`;
          return typeof item === 'string' ? item : '';
        });
        const target = play.target_state || play.maturity || [];
        const completeness = play.completeness || 0.7;
        
        return {
          ...play,
          planSteps,
          plan: plan.length ? plan : planSteps.map((txt, i) => ({ id: `P${i + 1}`, title: txt })),
          communication,
          inputs,
          target_state: target,
          category: play.category || 'Play',
          priority: play.priority || 'Medium',
          completeness
        };
      }

      const plays = playsRaw.map(normalizePlay);
      if (!plays.length) return;

      // Templates
      function safeCompile(id) {
        const node = document.getElementById(id);
        return Handlebars.compile(node.innerHTML);
      }
      const tplLeft = safeCompile('tpl-left');
      const tplTimeline = safeCompile('tpl-timeline');
      const tplStep = safeCompile('tpl-step');
      const tplTab0 = safeCompile('tpl-tab-0');
      const tplTab05 = safeCompile('tpl-tab-05');
      const tplTab1 = safeCompile('tpl-tab-1');
      const tplTab2 = safeCompile('tpl-tab-2');
      const tplTab3 = safeCompile('tpl-tab-3');

      // State
      let activePlay = plays[0];
      let activeStepId = activePlay.plan[0] ? activePlay.plan[0].id : (activePlay.steps ? activePlay.steps[0] : '');
      let activeTab = 0;
      let currentPopKind = null;

      function animateDonuts(root = document) {
        const meters = root.querySelectorAll('.donut-meter');
        meters.forEach(m => {
          const dash = parseFloat(m.getAttribute('data-dash'));
          const rest = parseFloat(m.getAttribute('data-rest'));
          m.style.transition = 'stroke-dasharray .6s ease';
          void m.getBBox();
          m.style.strokeDasharray = `${dash} ${rest}`;
        });
      }

      function renderHeader() {
        document.getElementById('play-subtitle').textContent = `${activePlay.busTitle || ''}`;
        const sel = document.getElementById('playSel');
        sel.innerHTML = plays.map(p => `&lt;option value="${p.id}" ${p.id === activePlay.id ? 'selected' : ''}>Play ${p.id}: ${p.title}&lt;/option>`).join('');
      }

      function renderLeft() {
        const el = document.getElementById('left-panel');
        el.innerHTML = tplLeft(activePlay);
        el.querySelectorAll('.pop-btn').forEach(btn => {
          const kind = btn.getAttribute('data-open-pop');
          btn.setAttribute('aria-expanded', String(currentPopKind === kind));
        });
        animateDonuts(el);
      }

      function renderTimeline() {
        document.getElementById('timeline-panel').innerHTML = tplTimeline({ plan: activePlay.plan, activeId: activeStepId });
        document.querySelectorAll('#timeline-panel .step').forEach(btn => {
          btn.tabIndex = btn.classList.contains('active') ? 0 : -1;
        });
      }

      function renderStep() {
        const step = normalizeStep(activeStepId);
        const tabs = ["Details &amp; Data", "Tasks", "Views &amp; Model", "Stakeholders &amp; Insights", "Resources"].map((t, i) => ({ label: t, active: i === activeTab }));
        document.getElementById('step-details').innerHTML = tplStep({ id: step.id, title: step.title, completeness: step.completeness, eip, tabs });
        renderTabContent(step);
        requestAnimationFrame(() => { positionUnderline(); animateDonuts(document.getElementById('step-details')); });
      }

      function renderTabContent(step) {
        const map = [tplTab0, tplTab05, tplTab1, tplTab2, tplTab3];
        const el = document.getElementById('tab-content');

        el.innerHTML = map[activeTab](step);
       
        animateDonuts(el);
        bindTaskResourceCards(el);
        if (activeTab === 2 &amp;&amp; viewsData &amp;&amp; viewsData.viewData &amp;&amp; step.view) {
          const match = viewsData.viewData.find(v => v.name === step.view);
          if (match) {
            $('#viewDescription').text(match.description || '');
            createMap(match);
          }
        }
      }

      function positionUnderline() {
        const tabsEl = document.getElementById('tabs');
        const current = tabsEl &amp;&amp; tabsEl.querySelector(`.tab[data-tab-index="${activeTab}"]`);
        const ul = document.getElementById('underline');
        if (!tabsEl || !current || !ul) return;
        const rect = current.getBoundingClientRect();
        const parentRect = tabsEl.getBoundingClientRect();
        ul.style.width = rect.width + 'px';
        ul.style.transform = `translateX(${rect.left - parentRect.left}px)`;
      }

      const popIcons = {
        prereqs: '<i class="fa fa-bolt"></i>',
        outcomes: '<i class="fa fa-star"></i>',
        impacts: '<i class="fa fa-exclamation-triangle"></i>',
        target: '<i class="fa fa-bullseye"></i>',
        initiators: '<i class="fa fa-rocket"></i>',
        start: '<i class="fa fa-flag-checkered"></i>',
        inputs: '<i class="fa fa-inbox"></i>',
        comm: '<i class="fa fa-comments"></i>',
        plan: '<i class="fa fa-map-signs"></i>'
      };

      function renderPopGrid(list, kind) {
        const items = (list || []).filter(Boolean);
        if (!items.length) return `<div class="pop-empty">No details captured yet.</div>`;
        const icon = popIcons[kind] || '<i class="fa fa-circle"></i>';
        const useCount = icon.indexOf('fa-map-signs') !== -1;
        let count = 0;
        return `<div class="pop-grid">${items.map(item => {
          const badge = useCount ? (++count) : icon;
          return `
          <div class="pop-chip">
            <span class="pop-icon">${badge}</span>
            <span>${item}</span>
          </div>`;
        }).join('')}</div>`;
      }

      function enablePopDrag() {
        const pop = document.getElementById('pop-panel');
        const head = pop ? pop.querySelector('.pop-head') : null;
        if (!pop || !head) return;
        if (head.dataset.dragBound === 'true') return;
        head.dataset.dragBound = 'true';
        let dragging = false;
        let offsetX = 0;
        let offsetY = 0;

        const onMove = e => {
          if (!dragging) return;
          const nextX = e.clientX - offsetX;
          const nextY = e.clientY - offsetY;
          pop.style.left = Math.max(8, nextX) + 'px';
          pop.style.top = Math.max(8, nextY) + 'px';
        };

        const onUp = () => {
          if (!dragging) return;
          dragging = false;
          head.classList.remove('dragging');
          document.removeEventListener('mousemove', onMove);
          document.removeEventListener('mouseup', onUp);
        };

        head.addEventListener('mousedown', e => {
          if (e.button !== 0) return;
          const rect = pop.getBoundingClientRect();
          dragging = true;
          offsetX = e.clientX - rect.left;
          offsetY = e.clientY - rect.top;
          head.classList.add('dragging');
          pop.style.left = rect.left + 'px';
          pop.style.top = rect.top + 'px';
          pop.style.right = 'auto';
          pop.style.bottom = 'auto';
          document.addEventListener('mousemove', onMove);
          document.addEventListener('mouseup', onUp);
        });
      }

      function bindTaskResourceCards(root = document) {
        const cards = root.querySelectorAll('.task-resource-card[data-link]');
        cards.forEach(card => {
          const href = card.getAttribute('data-link');
          if (!href) return;
          const openLink = () => window.open(href, 'taskResource', 'width=1100,height=800,noopener,noreferrer');
          card.addEventListener('click', e => {
            if (e.target.closest('a, button')) return; // let inner actions handle their own clicks
            e.preventDefault();
            openLink();
          });
          card.addEventListener('keydown', e => {
            if (e.target.closest('a, button')) return;
            if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); openLink(); }
          });
        });
      }

      // Delegated handlers so only video links trigger the popup modal
      $(document).on('click', '.video-popup', function(e) {
        e.preventDefault();
        const videoUrl = $(this).data('video-url') || $(this).attr('href');
        openVideoModal(videoUrl);
      });

      $(document).on('click', '#videoModalClose', function() {
        closeVideoModal();
      });

      $(document).on('click', '#videoModal', function(e) {
        if (e.target.id === 'videoModal') {
          closeVideoModal();
        }
      });

      $(document).on('keydown', function(e) {
        if (e.key === 'Escape') {
          closeVideoModal();
        }
      });

      function openPop(kind) {
        const pop = document.getElementById('pop-panel');
        const titleEl = document.getElementById('pop-title');
        const bodyEl = document.getElementById('pop-body');
        if (currentPopKind === kind &amp;&amp; pop.classList.contains('open')) { closePop(); return; }
        currentPopKind = kind;
        document.querySelectorAll('.pop-btn').forEach(btn => {
          const k = btn.getAttribute('data-open-pop');
          btn.setAttribute('aria-expanded', String(k === currentPopKind));
        });
        if (kind === 'prereqs') { titleEl.textContent = 'Critical Prerequisites'; bodyEl.innerHTML = renderPopGrid(activePlay.prerequisites, kind); }
        else if (kind === 'outcomes') { titleEl.textContent = 'Expected Outcomes'; bodyEl.innerHTML = renderPopGrid(activePlay.outcomes, kind); }
        else if (kind === 'impacts') { titleEl.textContent = 'Impact'; bodyEl.innerHTML = renderPopGrid(activePlay.maturity, kind); }
        else if (kind === 'target') { titleEl.textContent = 'Target State'; bodyEl.innerHTML = renderPopGrid(activePlay.target_state, kind); }
        else if (kind === 'initiators') { titleEl.textContent = 'Initiators'; bodyEl.innerHTML = renderPopGrid(activePlay.initiators, kind); }
        else if (kind === 'start') { titleEl.textContent = 'Starting Position'; bodyEl.innerHTML = renderPopGrid(activePlay.starting_position, kind); }
        else if (kind === 'inputs') { titleEl.textContent = 'Inputs'; bodyEl.innerHTML = renderPopGrid(activePlay.inputs, kind); }
        else if (kind === 'comm') { titleEl.textContent = 'Communication Plan'; bodyEl.innerHTML = renderPopGrid(activePlay.communication, kind); }
        else if (kind === 'plan') { titleEl.textContent = 'Plan'; bodyEl.innerHTML = renderPopGrid(activePlay.planSteps, kind); }
        pop.classList.add('open');
        enablePopDrag();
      }

      function closePop() {
        const pop = document.getElementById('pop-panel');
        pop.classList.remove('open');
        currentPopKind = null;
        document.querySelectorAll('.pop-btn').forEach(btn => btn.setAttribute('aria-expanded', 'false'));
      }

      function attachEvents() {
        document.getElementById('playSel').addEventListener('change', e => {
          const next = plays.find(p => p.id === e.target.value) || plays[0];
          activePlay = next;
          activeStepId = next.plan[0] ? next.plan[0].id : (next.steps ? next.steps[0] : '');
          activeTab = 0;
          closePop();
          renderAll();
        });

        document.getElementById('left-panel').addEventListener('click', e => {
          const t = e.target.closest('[data-open-pop]'); if (!t) return; openPop(t.getAttribute('data-open-pop'));
        });

        document.getElementById('timeline-panel').addEventListener('click', e => {
          const b = e.target.closest('[data-step]'); if (!b) return;
          activeStepId = b.getAttribute('data-step');
          renderTimeline();
          renderStep();
          document.getElementById('step-details').scrollIntoView({ behavior: 'smooth', block: 'start' });
        });

        document.getElementById('timeline-panel').addEventListener('keydown', e => {
          const buttons = Array.from(document.querySelectorAll('#timeline-panel .step'));
          const currentIndex = buttons.findIndex(b => b.classList.contains('active'));
          if (['ArrowRight', 'ArrowDown'].includes(e.key)) {
            e.preventDefault();
            const next = buttons[Math.min(buttons.length - 1, currentIndex + 1)]; next.focus(); next.click();
          } else if (['ArrowLeft', 'ArrowUp'].includes(e.key)) {
            e.preventDefault();
            const prev = buttons[Math.max(0, currentIndex - 1)]; prev.focus(); prev.click();
          }
        });

        document.getElementById('step-details').addEventListener('click', e => {
          const t = e.target.closest('.tab'); if (!t) return;
          activeTab = parseInt(t.getAttribute('data-tab-index'), 10);
          document.querySelectorAll('#tabs .tab').forEach(el => { el.setAttribute('aria-selected', 'false'); el.tabIndex = -1; });
          t.setAttribute('aria-selected', 'true'); t.tabIndex = 0; t.focus();
          positionUnderline();
          renderTabContent(normalizeStep(activeStepId));
        });

        document.getElementById('step-details').addEventListener('keydown', e => {
          if (!e.target.classList.contains('tab')) return;
          const tabs = Array.from(document.querySelectorAll('#tabs .tab'));
          const idx = tabs.indexOf(e.target);
          if (['ArrowRight', 'ArrowDown'].includes(e.key)) {
            e.preventDefault(); tabs[Math.min(tabs.length - 1, idx + 1)].click();
          } else if (['ArrowLeft', 'ArrowUp'].includes(e.key)) {
            e.preventDefault(); tabs[Math.max(0, idx - 1)].click();
          }
        });

        document.getElementById('pop-close').addEventListener('click', closePop);
        document.getElementById('pop-panel').addEventListener('click', e => { if (e.target.id === 'pop-panel') closePop(); });
        document.addEventListener('keydown', e => { if (e.key === 'Escape') closePop(); });
        window.addEventListener('resize', positionUnderline);
      }

      function renderAll() { renderHeader(); renderLeft(); renderTimeline(); renderStep(); }

      function setupTimelineScroll() {
        const hudRoot = document.querySelector('.hud-root');
        const headerEl = document.querySelector('.pbheader');
        const buffer = 20; // px buffer around header height
        let timelineCollapsed = false;
        window.addEventListener('scroll', function () {
          if (!hudRoot || !headerEl) return;
          const headerHeight = headerEl.offsetHeight || 0;
          const y = window.scrollY || window.pageYOffset || 0;
          const collapseAt = headerHeight + buffer;
          const expandAt = Math.max(0, headerHeight - buffer);
          if (!timelineCollapsed &amp;&amp;  y > collapseAt) {
            hudRoot.classList.add('timeline-collapsed');
            timelineCollapsed = true;
          } else if (timelineCollapsed &amp;&amp;  y &lt; expandAt) {
            hudRoot.classList.remove('timeline-collapsed');
            timelineCollapsed = false;
          }
        });
      }

      function initHud() {
        if (hudInitialized) return;
        hudInitialized = true;
        renderAll();
        attachEvents();
        const activeStepBtn = document.querySelector('#timeline-panel .step.active');
        if (activeStepBtn) activeStepBtn.focus();
        setupTimelineScroll();
      }


            // Inner meta-model tabs (Graph / Edge List)
      $(document).on('click', '.meta-tab-button', function () {
        const $btn = $(this);
        const tab = $btn.data('meta-tab');

        // The immediate container that holds both the buttons and the panels
        const $container = $btn.closest('div').parent(); // move from .meta-tabs to the parent that includes .meta-tab-panels

        $container.find('.meta-tab-button').removeClass('meta-tab-active');
        $btn.addClass('meta-tab-active');

        $container.find('.meta-tab-panel').removeClass('meta-tab-panel-active');
        $container.find('.meta-tab-panel[data-meta-panel="' + tab + '"]').addClass('meta-tab-panel-active');
      });
    });

  

const samplePlays =[
   {
    "id": "1",
    "busTitle": "Understand Business Application Usage and Rationalisation Opportunities",
    "title": "Anchor on Applications, Bring in Business Elements",
    "summary": " Difficulty: Easy to moderate, This play starts with capturing an application catalogue and application reference model, creating the mapping to the business and enriching with costs and dependencies to enable gap analysis, rationalisation and cost saving",
    "category": "Business to Application",
    "initiators": [
      "There is no enterprise architecture",
      "Application Rationalisation is an initiative",
      "An efficiency drive",
      "There is little visibility of IT",
      "A want to build credibility"
    ],
    "prerequisites": [
      "Communication to relevant IT teams from senior leader",
      "A business contact with knowledge of the business"
    ],
    "outcomes": [
      "Having a single accessible application list is always well received",
      "The CIO initiates detailed investigation into rationalisation against the identified applications – architecture credibility builds",
      "The business begin to understand their applications and ask IT how to rationalise – architecture begins to become a business partner"
    ],
    "starting_position": [
      "No single application catalogue",
      "Disparate applications list",
      "Limited business capability knowledge"
    ],
    "duration": "4-8 weeks",
    "priority": "High",
    "plan": [
      "Publish an up to date application catalogue",
      "Engage the CIO by using the application catalogue as an anchor to create an application reference model and then identify duplication within the application estate from a capability perspective",
      "Engage the business and overlay the business perspective and identify where they have potential duplication within their architecture.",
      "Start with one business area and complete that first as a demonstrator",
      "Bring in costs for applications",
      "Overlay application interdependencies to see complexity"
    ],
    "maturity": [
      "Maturity: 0 - 1 to 1 - 2",
      "EA Team in place",
      "Enterprise Architecture begins to get visibility",
      "Ability to plan development to meet short term business need – clarity as to why things are being delivered"
    ],
    "inputs": [
      {
        "person": "Business Executive",
        "purpose": "Capability Model validation"
      },
      {
        "person": "Business Analyst",
        "purpose": "Capability model creation and high-level processes"
      },
      {
        "person": "Application Owners",
        "purpose": "Application information"
      },
      {
        "person": "Service Management Teams",
        "purpose": "Application information"
      },
      {
        "person": "Finance",
        "purpose": "Costs"
      }
    ],
    "communication": [
      {
        "channel": "Face to Face Meetings",
        "purpose": "Engage and have regular updates with the CIO and a ‘friendly’ business area executive"
      },
      {
        "channel": "Face to Face Meetings, Lunch and Learn type sessions",
        "purpose": "Once the application catalogue has a reasonable set of applications, begin to communicate more widely"
      },
      {
        "channel": "Face to Face Meetings, Lunch and Learn type sessions",
        "purpose": "Engage other business areas once you have one done"
      }
    ],
    "steps":["A1.1", "A1.2", "B1.1", "B1.2", "S1.5", "A1.4"]
  },
  {
    "id": "2",
    "busTitle": "Understand Technology Risk Impact on the Business",
    "title": "Anchor on applications, link to technology, bring in business elements",
    "summary": "Difficulty: Easy to moderate.  This play starts with capturing an Application Catalogue and Application Reference Model, then creating a Technology Reference Model and mapping the Applications to the Technology Products and Nodes.  Following this the links to the Business Capabilities and Processes are defined.  This allows identification of Application gaps and rationalisation opportunities, and identification of Technology risk and adherence to standards.",
    "category": "Application to Technology to Business",
    "initiators": [
      "A risk reduction drive",
      "An efficiency drive",
      "There is little visibility of IT",
      "EA want to build credibility"
    ],
    "prerequisites": [
      "Communication to relevant IT teams from senior leader",
      "A business contact with knowledge of the business",
      "Accessibility to disparate lists and CMDB(s)"
    ],
    "outcomes": [
      "Having a single accessible application list is always well received",
      "The CIO initiates detailed investigation into rationalisation or risk reduction, against the identified applications and technology – architecture credibility builds",
      "The business begin to understand where they have inefficiency and risk and initiate impact analysis initiatives"
    ],
    "starting_position": [
      "A comprehensive list of applications, even if disparate and not 100% complete",
      "Accessible list of recent, if not up to date, technologies, e.g. in a CMDB"
    ],
    "duration": "6-10 weeks",
    "priority": "High",
    "plan": [
      "Publish an up to date application catalogue",
      "Get an application and a technology reference model created and linked to applications and products used",
      "Engage the CIO by using the reference models to identify duplication",
      "Engage the business, overlay the business perspective and identify where they have potential duplication and/or risk within their processes. Start with one business area and complete that first as a demonstrator",
      "Engage Support to show impact of a technology failure on the business, e.g. this server failing means this team in this business area cannot function"
    ],
    "maturity": [
      "1 to 2 to 2 to 3",
      "EA Team in place",
      "EA advocacy from across areas, inc. Support will begin"
    ],
    "inputs": [
      {
        "person": "CIO",
        "purpose": "Key areas of concern"
      },
      {
        "person": "Business Executive",
        "purpose": "Capability Model validation"
      },
      {
        "person": "Business Analyst",
        "purpose": "Capability model creation and high-level processes"
      },
      {
        "person": "Application Owners",
        "purpose": "Application information"
      },
      {
        "person": "Service Management Teams",
        "purpose": "Application and technology information"
      },
      {
        "person": "Service Management Teams",
        "purpose": "CMDB, e.g. ServiceNow, for data"
      }
    ],
    "communication": [
      {
        "channel": "Face to Face Meetings",
        "purpose": "Engage and regular updates with the CIO and a ‘friendly’ business area executive"
      },
      {
        "channel": "Face to Face Meetings, Lunch and Learn type sessions",
        "purpose": "Once the application catalogue has a reasonable set of applications, begin to communicate more widely"
      },
      {
        "channel": "Face to Face Meetings",
        "purpose": "If very high risk appears communicate early"
      },
      {
        "channel": "Face to Face Meetings, Lunch and Learn type sessions",
        "purpose": "Engage other business areas once you have one done"
      }
    ],
    "steps": ["A1.1","A1.2", "T1.1", "T1.2", "T1.3", "A1.3", "B1.1", "B1.2"]
  },
  {
  "id": "3",
  "busTitle": "Simple Governance Anchored on Applications and Technology",
  "title": "Build Simple Governance, Anchored Around Applications Then Technology",
  "summary": "Difficulty: Moderate\nTarget time: 6-10 weeks\nMaturity: 1 to 2 >> 2 to 3",
  "category": "",
  "initiators": [
    "Need to control technologies in the enterprise",
    "Desire to reduce applications or technologies being used",
    "People creating/buying applications for capabilities which existing applications have",
    "Lots of duplicate technologies being used"
  ],
  "prerequisites": [
    "Communication to relevant IT teams from senior leader",
    "Engagement of the impacted teams, or awareness"
  ],
  "outcomes": [
    "Teams may be resistant to be governed at first but demonstration of value (pick some obvious wins) and exec backing of success will help gain traction",
    "Self-governance gives teams some freedom and EA is not seen as bureaucracy",
    "Teams see value when you present other options, or speed their delivery through having candidates ready for them"
  ],
  "starting_position": [
    "A broad list of applications, even if disparate and not 100% complete"
  ],
  "duration": "6-10 Weeks",
  "priority": "High",
  "plan": [
    "Communicate the objectives to the impacted teams, engage and gain input on the scope of governance",
    "Define architecture principles",
    "Capture the application list",
    "Communicate the principles: For applications being created or changed, teams should validate them against the principles",
    "Communicate the principles: Set a criteria for when teams must engage EA – keep it simple (e.g. major projects, key apps only, spend over X amount)",
    "Let teams generally self govern, engage projects informally to track adherence",
    "Capture applications costs to provide an anchor for discussion, and to help identify applications which must be referred",
    "Move to the technology layer (product duplication or standards) as the next step for governing"
  ],
  "maturity": [],
  "inputs": [
    {
      "person": "CIO",
      "purpose": "Success Criteria, Principles"
    },
    {
      "person": "IT Management",
      "purpose": "Principles, Team Engagement"
    },
    {
      "person": "Finance",
      "purpose": "Costs"
    }
  ],
  "communication": [
    {
      "channel": "Meeting",
      "purpose": "Engage and regular updates with the CIO"
    },
    {
      "channel": "Report",
      "purpose": "Monthly report on adherence"
    },
    {
      "channel": "Meeting",
      "purpose": "Engagement and reviews with teams"
    },
    {
      "channel": "Meeting",
      "purpose": "Monthly review for 2/3 months with IT management to get feedback on the process"
    }
  ],
  "steps": [
    "A1.1",
    "S1.1",
    "S1.6",
    "S1.5",
    "T1.1",
    "T1.2"
  ]
},
  {
  "id": "4",
  "busTitle": "Understand Technology and Grow the Architecture from There",
  "title": "Anchor On Technology And Build The Architecture Out From There",
  "summary": "Difficulty: Moderate\nTarget time: 12-24 weeks\nMaturity: 0 to 2 >> 1 to 3",
  "category": "",
  "initiators": [
    "Impact of IT failures on the business not understood",
    "Lots of duplicate or legacy technologies being used, but the impact of their removal/replacement not understood",
    "Desire to reduce the applications or technologies being used"
  ],
  "prerequisites": [
    "Communication to relevant IT teams holding data from a senior leader"
  ],
  "outcomes": [
    "Knowing where you have duplication of applications or technologies is useful and leads to initiatives to rationalise.  The real power comes when you overlay lifecycles and associate these with applications, as you can start to see technology risk. This builds credibility within IT, if you find opportunities",
    "Support will look to use the data to understand the impacts of incidents , and also to see the impact of change prior to acceptance into service",
    "Once you have captured the business capabilities, the business may spot rationalisation opportunities and engage, again building EA reputation"
  ],
  "starting_position": [
    "Technology lists exist in CMDB(s) or in spreadsheets. Information may be dispersed in several places",
    "Some application information exists, but needs collating"
  ],
  "duration": "12-24 Weeks",
  "priority": "High",
  "plan": [
    "Collate the products you use, map their components, and define whether products are standard or off-strategy",
    "Create the technology reference architecture (capabilities and supporting components required)",
    "Collate your technology nodes and communicate this information",
    "You could overlay vendor lifecycles at this point to show risks, or begin to look at defining product standards",
    "Capture your applications (and application services), and map these to technology nodes",
    "Capture your high-level business processes",
    "Map your business capabilities to the business processes"
  ],
  "maturity": [
    "Engagement with IT",
    "Stakeholders bought in to EA",
    "Enterprise Architecture delivering clear value"
  ],
  "inputs": [
    {
      "person": "CIO",
      "purpose": "Key areas of concern"
    },
    {
      "person": "Infrastructure Owners",
      "purpose": "Servers and technology products"
    },
    {
      "person": "Application Owners",
      "purpose": "Application information"
    },
    {
      "person": "Support",
      "purpose": "Ideas on what would be useful"
    },
    {
      "person": "Business Executive",
      "purpose": "Capability Model validation"
    },
    {
      "person": "Business Analyst",
      "purpose": "Capability model creation and high-level processes"
    }
  ],
  "communication": [
    {
      "channel": "Meeting",
      "purpose": "Engage and have regular updates with the CIO"
    },
    {
      "channel": "Meeting",
      "purpose": "Share output with Technology Support once the technology to application links are completed, and again once the business layer is mapped"
    },
    {
      "channel": "Engaging Business",
      "purpose": "Engage with the business for the capability and process modelling, using that work to look at potential duplication and efficiency improvements"
    }
  ],
  "steps": [
    "T1.2",
    "T1.1",
    "A1.1",
    "T1.3",
    "B1.1",
    "B1.2"
  ]
},
  {
  "id": "5",
  "busTitle": "Understand Data for Better Decision Making",
  "title": "Get Data In Shape",
  "summary": "Difficulty: Moderate to Hard\nTarget time: 12-24 weeks\nMaturity: 2 to 3 >> 3 to 4/4.5",
  "category": "",
  "initiators": [
    "Inconsistent data within the organisation ",
    "Management information is often wrong",
    "Teams have no idea from where to source data"
  ],
  "prerequisites": [
    "Communication to relevant IT teams holding data from a senior leader",
    "Business support agreed",
    "An agreed overall nominee to make the final decision where disagreement",
    "An initial area of focus is agreed"
  ],
  "outcomes": [
    "Consistency of data definitions helps projects with their data modelling",
    "The mapping to applications helps speed project delivery with better information flow knowledge",
    "Understanding sources of data ensures that MI can be delivered with knowledge as to the source of data (system or manual). If you overlay data quality scores then you can also measure the quality of reports. This often leads to initiatives to remedy data quality issues."
  ],
  "starting_position": [
    "Databases known",
    "Applications known",
    "Areas of biggest concern known",
    "Processes using &amp; creating data broadly known",
    "No overall data model",
    "Data mastered in multiple places",
    "Lots of differing opinions on data and definitions (which makes data hard to manage)"
  ],
  "duration": "12-24 Weeks",
  "priority": "High",
  "plan": [
    "Create a data catalogue for key data items in the organisation. Agree the definitions with the business",
    "Communicate the data dictionary for projects to utilise in their design",
    "In parallel, gather the data stores that hold the data and the applications that use those data stores (just worry about the key data, not everything)",
    "Identify the applications mastering data and show where multiple masters exist and the outputs of that data",
    "You need to identify the data masters, but you will need to understand your processes to do that reliably (not in this play). Once data masters are identified, then projects can source their data from the correct applications",
    "Capture data flows into and out of applications"
  ],
  "maturity": [
    "Engagement across the business, and reduction of data errors, brings EA credibility",
    "IT projects engage EA leveraging the enterprise architecture data artefacts to speed project delivery",
    "Exposure to senior management using MI means senior awareness of capabilities"
  ],
  "inputs": [
    {
      "person": "CIO",
      "purpose": "Key areas of concern"
    },
    {
      "person": "Business Owners",
      "purpose": "Data definitions"
    },
    {
      "person": "Application Owners",
      "purpose": "Application information and dependencies"
    },
    {
      "person": "DBAs",
      "purpose": "Data stores supporting applications and data stored"
    }
  ],
  "communication": [
    {
      "channel": "Meeting",
      "purpose": "Engage and hold regular updates with the CIO"
    },
    {
      "channel": "Report",
      "purpose": "Share data catalogue and dependencies with project teams"
    },
    {
      "channel": "Communicate",
      "purpose": "Once applications that master data are identified and the reports/business outputs are understood, communicate areas of business risk, e.g. “sales report is missing key data for regions X, Y &amp; Z?” (this is a real example from a CEO report)"
    }
  ],
  "steps": [
    "D1.1",
    "D1.3",
    "A1.1"
  ]
},
  {
  "id": "6",
  "busTitle": "Define Technology Standards to Support Better Technology Choices",
  "title": "Bring In Standards For Technology, Anchored Around Applications",
  "summary": "Difficulty: Easy to Moderate\nTarget time: 6-12 weeks\nMaturity: 0 to 2",
  "category": "",
  "initiators": [
    "Projects implementing applications with no oversight",
    "Duplicate applications being built/acquired",
    "Need for rationalisation to reduce costs",
    "Concerns that people are choosing inappropriate technologies"
  ],
  "prerequisites": [
    "Communication to relevant IT teams from senior leader",
    "Clarity on who the application owners within IT are",
    "Engagement with infrastructure team(s)"
  ],
  "outcomes": [
    "Projects engage and use the technology selector as a starting point",
    "The CIO sees risks across the estate and can engage the business on mitigation",
    "Technologies become controlled",
    "Build out of technology costs of unnecessary technologies and plans to mitigate risk emerge",
    "Technology Alignment"
  ],
  "starting_position": [
    "Technology list available, in Excel or a CMDB",
    "Technology not mapped to applications",
    "No/Few standards defined"
  ],
  "duration": "6-12 Weeks",
  "priority": "High",
  "plan": [
    "Work with the infrastructure teams to tidy up the technology list and define standards for the technologies, leaving aside the ones that are off strategy",
    "Identify the technology components the organisation needs, working back from the products if necessary",
    "Map the products to the technology components",
    "Prioritise the applications list based on risk or importance, and identify the technologies used by those applications",
    "Create the technology architecture to support the applications",
    "Provide the Technology Product Selector as a tool for projects and change initiatives",
    "Highlight application/technology risks"
  ],
  "maturity": [
    "Engagement between IT – infrastructure and Projects",
    "IT projects engage EA, leveraging the enterprise architecture artefacts to speed project delivery",
    "EA adding clear, demonstrable value"
  ],
  "inputs": [
    {
      "person": "CIO",
      "purpose": "Key Areas of Concern"
    },
    {
      "person": "Infrastructure Teams",
      "purpose": "Technologies and Standards"
    },
    {
      "person": "Application Owners",
      "purpose": "Application Information"
    }
  ],
  "communication": [
    {
      "channel": "Engage and regular updates with the CIO",
      "purpose": "Discuss risk and non-strategic technology"
    },
    {
      "channel": "Engage the PMO and Change",
      "purpose": "Discuss the use of the Product Selector to speed projects – don’t impose, suggest usage initially"
    },
    {
      "channel": "Engage Infrastructure",
      "purpose": "Identify technology risks and mitigation options"
    }
  ],
  "steps": [
    "A1.1",
    "T1.1",
    "T1.2",
    "S1.4",
    "A1.3"
  ]
},
  {
  "id": "7",
  "busTitle": "Get Clarity on Project Application Impacts for Better Delivery Planning",
  "title": "Map Applications To Projects For Impact Analysis",
  "summary": "Difficulty: Easy to Moderate\nTarget time: 4-10 weeks\nMaturity: 0 to 2",
  "category": "",
  "initiators": [
    "Inadequate understanding of the dependencies between projects and applications with adverse impact on delivery schedules"
  ],
  "prerequisites": [
    "Engagement with Project teams/PMO"
  ],
  "outcomes": [
    "By plan, you can see the projects impacting different applications, and by application, you can see the projects impacting the focus application",
    "Enables discussion on dependencies and mitigation",
    "Projects begin to work on optimal delivery schedules"
  ],
  "starting_position": [
    "Application Catalogue",
    "Project List"
  ],
  "duration": "4-10 Weeks",
  "priority": "High",
  "plan": [
    "Create strategic plans with the architecture elements they will be impacting – applications, others if feasible",
    "Create a project list with dates",
    "Tie the plans to the projects that will implement them"
  ],
  "maturity": [
    "EA closer to the project teams with value add through dependency analysis",
    "This builds credibility with projects and a keenness to engage architects",
    "Credibility with the CIO as EA can demonstrate impacts on projects and dependencies, spotting potential threats to overall project delivery"
  ],
  "inputs": [
    {
      "person": "PMO",
      "purpose": "Project Portfolio"
    },
    {
      "person": "Projects",
      "purpose": "Project Dates and Architecture Impacts"
    }
  ],
  "communication": [
    {
      "channel": "Engage PMO and Projects",
      "purpose": "highlight dependencies and impacts"
    },
    {
      "channel": "Engage Business",
      "purpose": "How project portfolio can be reshaped to deliver quicker or at lower cost"
    }
  ],
  "steps": [
    "A1.1",
    "S1.2",
    "S1.3"
  ]
},
{
  "id": "8",
  "busTitle": "Show Where You Are Today and Where You Are Going",
  "title": "Create Your Roadmaps",
  "summary": "Difficulty: Easy to Moderate\nTarget time: 6-10 weeks\nMaturity: 0 to 4",
  "category": "",
  "initiators": [
    "Lack of clarity on what IT is delivering when",
    "A need to reflect the business strategy and the impact on IT"
  ],
  "prerequisites": [
    "Engagement with the Project Office",
    "Understanding of the business strategy"
  ],
  "outcomes": [
    "By plan, you can see the projects impacting different elements of the architecture and when",
    "Enables discussion on dependencies and mitigation",
    "Enables discussion on dependencies and mitigation"
  ],
  "starting_position": [
    "An application catalogue",
    "A list of projects",
    "A list of technologies",
    "High-level business processes (if possible)"
  ],
  "duration": "6-10 Weeks",
  "priority": "High",
  "plan": [
    "Create strategic plans with the architecture elements they will be impacting",
    "Work with the project teams to identify the plans they will be implementing",
    "Identify points where project plans conflict because of poor appreciation of dependencies between workstreams",
    "Identify the gaps where plans have no implementing projects"
  ],
  "maturity": [
    "EA closer to the project teams with value add through dependency analysis",
    "This builds credibility with projects and a keenness to engage architects",
    "Credibility with the CIO as EA can demonstrate impacts on projects and dependencies, spotting potential threats to overall project delivery"
  ],
  "inputs": [
    {
      "person": "PMO",
      "purpose": "Project Portfolio"
    },
    {
      "person": "Projects",
      "purpose": "Project Dates and Architecture Impacts"
    }
  ],
  "communication": [
    {
      "channel": "Engage PMO and projects",
      "purpose": "highlight dependencies and impacts"
    },
    {
      "channel": "Engage Business",
      "purpose": "How project portfolio can be reshaped to deliver faster, at lower cost or at lower risk"
    }
  ],
  "steps": [
    "A1.1",
    "T1.2",
    "B1.1",
    "B1.2",
    "S1.2",
    "A1.3"
  ]
}
]

var stepsList={"steps":[
    {
        "id": "A1.1",
        "title": "Application Catalogue",
        "view": "Application Catalogue",
        <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture the applications with basic details and services",
        "dataRequirements": [
          "List of Applications",
          "As many details as possible from: Codebase, e.g. package, bespoke, Lifecycle status, e.g. production, sunset, Delivery Model, e.g. onsite, cloud, Owners – business and application",
          "If possible, Application Services - services the application provides and those used by the organisation in processes "
        ],
        "stakeholders": [
          "Application Owners",
          "IT Service Management",
          "Business Rep/Users"
        ],
        "infoSources": [
          "CMDB",
          "Service Management Spreadsheets",
          "IT Finance Spreadsheets",
          "Business Rep/User Spreadsheets"
        ],
        "viewsEnabled": [
          {"name": "Application Catalogue", "image":"images/screenshots/application-catalogue.png"},
          {"name":"Application Summary", "image":"images/screenshots/application-provider-summary.png"},
          {"name":"Feeds into views like the Business Capability Dashboard and Application Rationalisation", "image":"images/screenshots/bus-cap-dashboard.png"}
        ],
        "resources": [],
        "insights": [
          {
            "text": "The application catalogue is another key anchor for your enterprise architecture. Understanding the applications, what they are used for and who they are used by in your estate provides the basis for understanding:",
            "subBullets": [
              "How IT supports the business",
              "Where you have duplication",
              "Where you have shadow IT",
              "How you can reduce costs",
              "How you can increase agility"
            ]
          },
          {
            "text": "For low maturity EA teams, the application catalogue is often a good starting point for any initiative, primarily as the data is often spread across the organisation and having a single consolidated list helps projects to understand impacts better, helps the business know what they have got, helps give the CIO sight of what they have to manage for the business, etc. As an EA team, it can become the anchor around which you can pivot other initiatives, such as rationalisation, business transformation and risk management."
          }
        ],
        "tasks": [
          {
            "id": "A1.1.1",
            "title": "Consolidate Application information sources",
            "description": "Gather all the disparate application information you can find into one place",
            "completed": false,
            "method": [],
            "taskResources": []
          },
          {
            "id": "A1.1.2",
            "title": "Review with stakeholders",
            "description": "Using the consolidated information, work with stakeholders to review, de-duplicate and add missing details",
            "completed": false,
            "method": [
              {
                "tool": "Stakeholder Spreadsheets",
                "name": "Review with stakeholders, understand Applications in use by the organisation",
                "link": ""
              },
              {
                "tool": "Launchpad Spreadsheets - Application tab",
                "name": "De-duplicate the data in the sheets and add additional data",
                "link": ""
              },
              {
                "tool": "Launchpad Spreadsheets - Organisation, App to Org User tabs",
                "name": "Add the organisation details and map the organisations to the applications they use",
                "link": ""
              },
              {
                "tool": "Application Editor",
                "name": "Use the Application editor to enrich data - it is not recommended to use it for bulk capture",
                "link": "",
                "editorId": "<xsl:value-of select="$appEditor/name"/>",
                "image": "images/video4.webp"
              }
            ],
            "taskResources": [
              { "type": "Reading",
              "title": "Modelling Application Providers",
              "link": "https://enterprise-architecture.org/university/application-modelling/",
                "image": "images/reading1.webp" 
             },
              {
                "type": "Video",
                "title": "Using Launchpad to capture Applications, Organisations and mapping together",
                "link": "https://youtu.be/CKsI0n5HlOA",
                "image": "images/video.webp"
              },
              {
                "type": "Video",
                "title": "Using the Application Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/iEAUJEnwtLI",
                "editorId": "<xsl:value-of select="$appEditor/name"/>"
              }
            ]
          },
          {
            "id": "A1.1.3",
            "title": "Capture/create Application Services",
            "description": "Create Application Services that represent the business functionality the applications provide",
            "completed": false,
            "method": [
              {
                "tool": "Interview IT Representitives",
                "name": "IT reps should understand the concept of Application Services.",
                "link": ""
              },
              {
                "tool": "Interview Business Reps",
                "name": "Business Users may not, so ask them what they are doing when they use the application and create services from their answers, e.g.  “We use Workday for talent acquisition, to manage employee performance, and to manage payroll”, which would lead to services for Talent Acquisition, Performance Management and Payroll Management (which could potentially be decomposed further).",
                "link": ""
              },
              {
                "tool": "Launchpad Spreadsheets - Application Services tab",
                "name": "Create a consolidated list of Application Services, you could also do this in the Application Editor but it is easier to do bulk capture in the spreadsheet",
                "link": ""
              },
              {
                "tool": "Publish",
                "name": "Publish the Application Services to make them available for mapping to Applications",
                "link": ""
              }
            ],
            "taskResources": [
              
              {
                "type": "Essential University",
                "title": "How to Model Application Services",
                "link": "https://enterprise-architecture.org/university/application-service-modelling/",
                "image": "images/reading2.webp" 
              },
              {
                "type": "Video",
                "title": "Using Launchpad to capture Applications Services",
                "link": "https://youtu.be/5-W7zk5w0jk",
                "image": "images/video3.webp" 
              }
            ]
          }
        ]
      },
      {
        "id": "A1.2",
        "title": "Application Reference Model",
        "view": "Application Reference Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Create the application reference model and map applications",
        "dataRequirements": [
          "Application Capabilities",
          "Application Services required for each capability",
          "Applications mapped to the Application Services they provide"
        ],
        "stakeholders": [
          "Application Owners",
          "IT Service Management",
          "Business Analysts"
        ],
        "infoSources": [
          "IT Service Management Spreadsheets",
          "Application documentation",
          "Business Capability model, if available"
        ],
        "viewsEnabled": [
          "Application Reference Model",
          "Application Service Summary",
          "Application Rationalisation",
          "Application Footprint Analysis"
        ],
        "resources": [],
        "insights": [
          {
            "text": "Understanding in detail the application estate from an application capabilities perspective, this is an application focused view not a business-usage driven view of the applications. This is differentiation is important as you are considering what the application could do, not what the are doing for your organisation.  Seeing this allows you to start to understand:",
            "subBullets": [
              "Where you have opportunities to rationalise",
              "Where you have shadow IT",
              "Where you can reduce costs"
            ]
          },
          {
            "text": "You can use this application perspective to also see, via the services, where applications are under-utilised, i.e. where their functionality is partly used but they have more capabilities, e.g. Workday has Finance as well as HR capabilities, your organisation may only be using the HR elements when they could use more (and replace other applications)."
          }
        ],
        "tasks": [
          {
            "id": "A1.2.1",
            "title": "Determine what Application Capabilities you require to support your business",
            "description": "Create the Application Capabilities that represent the high-level capabilities your applications need to provide to support the business",
            "completed": false,
            "method": [
              {
                "tool": "Business Capability Model",
                "name": "If a Business Capability model exists, use the Business Capabilities to create Application Capabilities as they often closely mirror the business",
                "link": ""
              },
              {
                "tool": "BA Interviews",
                "name": "If no Business Capability model exists, utilise the BAs business knowledge to brainstorm the Application Services that the different areas of the business will require and group those into Application Capabilities",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Application Modelling Overview - Application Capabilities",
                "link": "https://enterprise-architecture.org/university/application-modelling-overview/",
                "image": "images/video5.webp" 
              }
            ]
          },
          {
            "id": "A1.2.2",
            "title": "Map the Application Services to the Application Capabilities",
            "description": "Using the Application Services created in step A1.1.3, map these to the Application Capabilities they support",
            "completed": false,
            "method": [
              {
                "tool": "Launchpad Spreadsheets - Application Capability to Application Services tab",
                "name": "Map the Application Services to the Application Capabilities",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Video",
                "title": "Associating Application Capabilities to Application Services in the Launchpad", 
                "link": "https://youtu.be/lEbEarjgbq0",
                "image": "images/video7.webp" 
              }
            ]
          },
          {
            "id": "A1.2.3",
            "title": "Identify the Application Services provided by each Application",
            "description": "For each Application, identify the Application Services they provide and map these together",
            "completed": false,
            "method": [
              {
                "tool": "Analysis",
                "name": "Identify the Application Services provided by each Application",
                "link": ""
              },
              {
                "tool": "Launchpad Spreadsheets - Application Services to Apps tab",
                "name": "Map the Application Services to all the Applications that provide each Service ",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Video",
                "title": "Using Launchpad to capture Applications Services",
                "link": "https://youtu.be/5-W7zk5w0jk",
                "image": "images/video3.webp" 
              }
            ]
          },
          {
            "id": "A1.2.4",
            "title": "Import to Essential and publish for review",
            "description": "Import the completed launchpad spreadsheet to Essential, publish and review with stakeholders",
            "completed": false,
            "method": [
              {
                "tool": "Import Utility",
                "name": "Import the completed launchpad spreadsheet to Essential",
                "link": ""
              },
              {
                "tool": "Publish",
                "name": "Publish the changes in repository",
                "link": "https://youtu.be/iTnRYgjvQ-U",
                "image": "images/video8.webp"

              },
              {
                "tool": "Review",
                "name": "Review with the business and IT users",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
             {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
            ]
          }
        ]
      },
      {
        "id": "B1.1",
        "title": "Business Capability Model",
        "view": "Business Capability Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Create the business capability model with the BA, validate with Executive",
        "dataRequirements": ["Business Capabilities"],
        "stakeholders": ["Business Analyst", "Business Executive"],
        "infoSources": [
          "Essential pre-defined Business Capability Models",
          "Any existing business capability documentation",
          "High level process documentation",
          "Business website(s)"
        ],
        "viewsEnabled": [
          {"name":"Business Capability Model", "image": "images/screenshots/bus-cap-dashboard.png"},
          {"name":"Business Capability Summary", "image": "images/screenshots/business-capability-summary.png"}
        ],
        "resources": [],
        "insights": [
          { "text": "Defining the business capability model gives the business and IT a common language with which to discuss the business/IT engagement. The business capability model is a key anchor for your enterprise architecture and engagement with the business." }
        ],
        "tasks": [
          {
            "id": "B1.1.2",
            "title": "Define and Capture the Business Capabilities",
            "description": "Work with the Business to define and capture the Business Capabilities that represent the high-level capabilities of the business.  Alternatively, source an existing model from EAS or the internet to use as a starting point.",
            "completed": false,
            "method": [
              
            ],
            "taskResources": [
            {
                "type": "Essential Website",
                "title": "Download Pre-defined Models",
                "link": "https://enterprise-architecture.org/resources/free-ea-models/",
                "image": "images/reading7.webp",
              }, 
              {
                "type": "Essential University",
                "title": "Business Capability Modelling",
                "link": "https://enterprise-architecture.org/university/business-capability-modelling/",
                "image": "images/reading2.webp",
              },  
            {
                "type": "Video",
                "title": "Essential Launchpad - Business Domain and Business Capabilities sheets", 
                "link": "https://youtu.be/b86KgvkV_nA",
                "image": "images/video4.webp" 
              },
              {
                "type": "Read",
                "title": "Using the Business Capability Model Editor",
                "link": "https://enterprise-architecture.org/university/business-capability-model-editor/",
                "image": "images/reading6.webp"
              },
              {
                "type": "Video",
                "title": "Using the Business Capability Model Editor",
                "link": "https://youtu.be/e753P7NWdrY",
                "image": "images/video6.webp",
                "editorId": "<xsl:value-of select="$bcmEditor/name"/>"  
              }
            ]
          },
          {
            "id": "B1.1.3",
            "title": "Validate the Capability Model with a number of key Business Executives",
            "description": "Publish the Business Capability Model and review with a number of key stakeholders from across the Business to validate and agree the model",
            "completed": false,
            "method": [
              {
                "tool": "Publish",
                "name": "Publish to view the Business Capability Model",
                "link": "https://youtu.be/iTnRYgjvQ-U",
                
              },
              {
                "tool": "Review",
                "name": "Review with a number of key Business Executives from across the Business to validate and agree the model",
                "link": ""
              }
            ],
            "taskResources": [ 
          {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
            ]
          }
        ]
      },
      {
        "id": "B1.2",
        "title": "Business Process Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Identify the high-level processes and map applications that use them",
        "view": "Business Process Model",
        "dataRequirements": [
          "Business Processes",
          "Business Process to Required App Service",
          "Physical Process to App and Service"
        ],
        "stakeholders": [
          "Business Executive",
          "Business Analyst",
          "Application Owner",
          "IT Service Management"
        ],
        "infoSources": [
          "High level process documentation",
          "IT Service Management Spreadsheets for any information on business processes and applications they use for support"
        ],
        "viewsEnabled": [
          "Business Process Catalogue",
          "Business Process Family Summary",
          "Business Process Summary"
        ],
        "resources": [],
        "insights": [
          {
            "text": "Mapping the business processes to both the business capabilities they support and the applications they use allows us to see where we have duplication and inefficiencies in our processes and in our applications. This allows us to understand how IT can better support the business to:",
            "subBullets": [
              "Reduce duplication",
              "Increase efficiency and agility",
              "Reduce costs"
            ]
          }
        ],
        "tasks": [
          {
            "id": "B1.2.1",
            "title": "Define the Business Processes or use Essential functionality to do this for you",
            "description": "Define the high-level Business Processes that represent how the business operates to deliver value to its customers.  Alternatively, use Essential Set up Manager or Essential AI functionality to create a set of high-level processes for you.",
            "completed": false,
            "method": [
              {
                "tool": "Analysis",
                "name": "The processes need to be defined at a high level only, just name and description. Detailed process flows can be linked if they are documented elsewhere, but they are not required for now.  Note: at the enterprise architecture level, we are less concerned about detailed process flows. We may from time to time use them for deeper insight, but they are not needed for every process.",
                "link": ""
              },
              {
                "tool": "Interviews",
                "name": "Interview BAs to obtain the high level view of processes in their domain",
                "link": ""
              },
              {
                "tool": "Existing Documentation",
                "name": "Utilise existing documentation to create a set of high level processes",
                "link": ""
              },
              {
                "tool": "Essential Set Up Manager",
                "name": "Essential Set up Manager can create placeholder processes if this is not a priority for now",
                "link": ""
              },
              {
                "tool": "Essential AI",
                "name": "Essential Business Capability Editor can use AI to create a set of processes for you",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Essential Set up Manager - Cloud/Docker",
                "link": "https://enterprise-architecture.org/university/using-essential-set-up-manager/",
                "image": "images/video8.webp",
                "editorId": "report?XML=reportXML.xml&amp;XSL=<xsl:value-of select="$setupEditor/own_slot_value[slot_reference='report_xsl_filename']/value"/>"
              },
              {
                "type": "Editor",
                "title": "Using the Business Capability Model Editor - Cloud/Docker",
                "link": "https://enterprise-architecture.org/university/business-capability-model-editor/",
                "image": "images/video6.webp",
                "editorId": "<xsl:value-of select="$bcmEditor/name"/>"  
              },
              {
                "type": "Essential University",
                "title": "Business Process Modelling",
                "link": "https://enterprise-architecture.org/university/business-process-modelling/",
               "image": "images/video3.webp"
              }
            ]
          },
          {
            "id": "B1.2.2",
            "title": "Map the Application Service required for each Business Process",
            "description": "For each Business Process, identify the Application Services required to support the process and map these together",
            "completed": false,
            "method": [
              {
                "tool": "Interviews/Analysis",
                "name": "Use your own knowledge or discuss with the relevant BA's to identify the Application Services required by the Business Processes",
                "link": ""
              },
              {
                "tool": "Mapping",
                "name": "Map the Processes to the Services using the Essential Launchpad or the Essential Business Process Editor",
                "link": ""
              }
            ],
            "taskResources": [
              
              {
                "type": "Video",
                "title": "Essential Launchpad - Application Services to Business Process",
                "link": "https://youtu.be/FDgDYZNzAuc",
                "image": "images/video2.webp"
              }
            ]
          },
          {
            "id": "B1.2.3",
            "title": "Map the Processes to the performing Organisation and the Application and Services used",
            "description": "For each Business Process, identify the Organisations that perform the process, and the Applications and Application Services (or just applications if you don't know what functionality is used) they use when performing the process, and map these together",
            "completed": false,
            "method": [
              {
                "tool": "Interviews/Analysis",
                "name": "Use the relevant BA's to identify the Organisations that perform the processes. Note that this does not need to be at the lowest level, but a a level that is useful for analysis only.",
                "link": ""
              },
              {
                "tool": "Interviews/Analysis",
                "name": "Use the relevant BA's to identify the Application and Application Services that are used when the process is performed.  This provides a much greater level of analysis than just mapping to the Application",
                "link": ""
              },
              {
                "tool": "Analysis",
                "name": "You do not have to do this for the entire organisation and can focus on areas of need initially",
                "link": ""
              },
              {
                "tool": "Analysis",
                "name": "You can map at the higher level of Application only initially to identify areas of need and then map the services at a later date, as required",
                "link": ""
              },
              {
                "tool": "Mapping",
                "name": "Use the Launchpad spreadsheet or the Business Process Editor to complete the mapping",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "BPMN - Flow Editor",
                "link": "https://enterprise-architecture.org/university/bpmn-flow-editor-beta/",
                "editorId": "report?XML=reportXML.xml&amp;XSL=<xsl:value-of select="$bpmnEditor/own_slot_value[slot_reference='report_xsl_filename']/value"/>",
                "image": "images/reading3.webp"
              },
              {
                "type": "Video",
                "title": "BPMN - Flow Editor",
                "link": "https://youtu.be/e-Lpf5RCcSo",
                "editorId": "report?XML=reportXML.xml&amp;XSL=<xsl:value-of select="$bpmnEditor/own_slot_value[slot_reference='report_xsl_filename']/value"/>",
                "image": "images/video4.webp"
              },
              {
                "type": "Video",
                "title": "Essential Launchpad - Physical Process to App and Service",
                "link": "https://youtu.be/CKsI0n5HlOA",
                "image": "images/video5.webp",
                
              }
            ]
          },
          {
            "id": "B1.2.4",
            "title": "Import to Essential and publish for review",
            "description": "Import the completed launchpad spreadsheet to Essential, publish and review with stakeholders",
            "completed": false,
            "method": [
              {
                "tool": "Import the data",
                "name": "Use the Import utility to import the data",
                "link": ""
              },
              {
                "tool": "Publish",
                "name": "Publish to populate the views",
                "link": ""
              },
              {
                "tool": "Review for accuracy",
                "name": "Review the output with the business areas to assess accuracy ",
                "link": ""
              },
              {
                "tool": "Review for rationalisation opportunities",
                "name": "Discuss opportunities with the Business",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
            ]
          }
        ]
      },
      {
        "id": "S1.2",
        "title": "Roadmaps",
        "view": "Roadmaps",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Create roadmaps, which will be sets of strategic plans, to show the architecture changes that are tobe made to implement the strategy",
        "dataRequirements": ["(optional) Programmes","Projects","Strategic plans, i.e. architecture plans"],
        "stakeholders": ["Enterprise Architects", "CIO"],
        "infoSources": ["EA or CIO business/IT knowledge","Business","PMO","Projects"],
        "viewsEnabled": [
          {"name":"Roadmap Dashboard", "image":"images/screenshots/plans_dashboard.jpeg"},
          {"name":"Project Summary", "image":"images/screenshots/project-summary.png"},
          {"name":"Strategic Plan Summary", "image":"images/screenshots/strat-plan-summary.png"},
          {"name":"Application Summary", "image":"images/screenshots/application-provider-summary.png"}
        ],
        "resources": [],
        "insights": [
          { "text": "Understanding the project portfolio and the impact on the artefacts in the enterprise architecture. Roadmaps are used to assess the impact of projects on the organisation, of interdependencies between workstreams, of potential delays on other initiatives and on the organisation's strategic plans." }
        ],
        "tasks": [
          {
            "id": "S1.2.1",
            "title":"Gather the strategic plans and projects that implement them",
            "description": "Gather the strategic plans and project list.  Integrate with the PMO tool if one exists. If not, load the data either via a spreadsheet or directly in Essential",
            "completed": false,
            "method": [
              {
                "tool": "Essential Launchpad Plus: Strategic Plans",
                "name": "Load via spreadsheet",
                "link": ""
              },
              {
                "tool": "Project Impacts Editor",
                "name": "Use the project editor to edit your project data",
                "link": ""
              },
              {
                "tool": "PMO Tool",
                "name": "Integrate Projects from the PMO tool if one exists.",
                "link": ""
              }
            ],
            "taskResources": [
              
                {
                "type": "Editor",
                "title": "Project Impacts Editor",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>",
                "image": "images/video2.webp",
                "link": ""
               },
               {
                "type": "Video",
                "title": "Launchpad Plus: Strategic Plans",
                "editorId": "",
                "image": "images/video5.webp",
                "link": ""
               }
            ]
          },
          {
            "id": "S1.2.2",
            "title": "Associate the projects with the programmes they support",
            "description": "For each project, identify the programme it supports (if any) and map these together",
            "completed": false,
            "method": [
              {
                "tool": "Essential Launchpad Plus: Strategic Plans",
                "name": "Load via spreadsheet",
                "link": ""
              },
              {
                "tool": "Editor",
                "name": "Project Impacts Editor",
                "link": "",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>"
              }
            ],
            "taskResources": [
              {
                "type": "Editor",
                "title": "Project Impacts Editor",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>",
                "image": "images/video.webp",
                "link": ""
              },
               {
                "type": "Essential",
                "title": "Launchpad Plus: Strategic Plans",
                "editorId": "<xsl:value-of select="$eaAssist/name"/>",
                "image": "images/video4.webp",
                "link": ""
               }
            ]
          },
          {
            "id": "S1.2.3",
            "title": "Associate the projects with strategic plans they are implementing",
            "description": "For each project, identify the strategic plan it is implementing and map these together",
            "completed": false,
            "method": [
              {
                "tool": "Essential Launchpad Plus: Strategic Plans",
                "name": "Load via spreadsheet",
                "link": ""
              },
              {
                "tool": "Project Impacts Editor",
                "name": "",
                "link": "",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>"
              },
              {
                "tool": "Roadmaps Editor",
                "name": "",
                "link": "",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>"
              },
              {
                "tool": "Strategic Plan Editor",
                "name": "",
                "link": "",
                "editorId": "<xsl:value-of select="$strategicPlanEditor/name"/>"
              }

            ],
            "taskResources": [
              {
                "type": "Editor",
                "title": "Project Impacts Editor",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>",
                "image": "images/video2.webp",
                "link": ""
              },
              {
                "type": "Editor",
                "title": "Strategic Plan Editor",
                "editorId": "<xsl:value-of select="$strategicPlanEditor/name"/>",
                "image": "images/video2.webp",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/"
               },
               {
                "type": "Editor",
                "title": "Roadmaps Editor",
                "editorId": "<xsl:value-of select="$roadmapEditor[1]/name"/>",
                "image": "images/video2.webp",
                "link": "https://enterprise-architecture.org/university/roadmap-planner-tab/"
              },
               {
                "type": "Essential",
                "title": "Launchpad Plus: Strategic Plans",
                "editorId": "<xsl:value-of select="$eaAssist/name"/>",
                "image": "images/video2.webp",
                "link": ""
               }
            ]
          },
          {
            "id": "S1.2.4",
            "title": "Review/upload and publish the data",
            "description": "Publish and review with stakeholders",

            "completed": false,
            "method": [
              {
                "tool": "Essential Launchpad Plus: Strategic Plans",
                "name": "Load via spreadsheet",
                "link": ""
              }
            ],
            "taskResources": [
              
               {
                "type": "Essential",
                "title": "Launchpad Plus: Strategic Plans",
                "editorId": "<xsl:value-of select="$eaAssist/name"/>",
                "image": "images/video2.webp",
                "link": ""
               },
              {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
             }
            ]
          }
        ]
      },
      {
        "id": "S1.5",
        "title": "Costs",
        "view": "Cost Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Get costs for applications that are prime for review",
        "dataRequirements": ["Application Costs"],
        "stakeholders": ["CIO", "Business", "Finance"],
        "infoSources": ["Finance"],
        "viewsEnabled": [
          {"name":"Application Summary", "image":"images/screenshots/application-provider-summary.png"},
          {"name":"Application Cost Analysis (Cloud/Docker)", "image":"ext/apml/screenshots/it-cost-dashboard.png"},
          {"name":"Application Cost Summary", "image":"images/screenshots/application-cost-summary.png"} 
        ],
        "resources": [],
        "insights": [
          { "text": "Understand the cost breakdown of an architecture element. Look across common elements at costs and determine where cost efficiencies exist. Roll-up costs if required" }
        ],
        "tasks": [
          {
            "id": "S1.5.1",
            "title": "Identify the costs you wish to capture",
            "completed": false,
            "method": [
              {
                "tool": "Analysis",
                "name": "Define the Cost Types you want to capture across your application estate, for example, server costs, people costs, support costs etc.  Note that this will not be your financial records, but a resource to allow you to compare costs across different solutions",
                "link": ""
              }
            ],
            "taskResources": []
          },
          {
            "id": "S1.5.2",
            "title": "Add the costs to the relevant elements",
            "description": "Capture the costs for each element using one of the methods below",
            "completed": false,
            "method": [
              {
                "tool": "Essential Cost Capture Spreadsheet",
                "name": "Capture the cost types and the costs of the applications",
                "link": ""
              },
              {
                "tool": "Essential Application Editor",
                "name": "Add the cost in the Application Editor. Note if this method is used the costs types will need to be added in the Essential Data Manager.",
                "link": "",
                "editorId": "<xsl:value-of select="$appEditor/name"/>"
              },
              {
                "tool": "Import Utility",
                "name": "Import the data",
                "link": ""
              },
              {
                "tool": "Publish",
                "name": "Publish to see the results in the views",
                "link": ""
              }
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Managing Costs",
                "link":"https://enterprise-architecture.org/university/managing-costs/",
                "image": "images/reading3.webp"
              }, 
              {
                "type": "Video",
                "title": "Adding Costs using the Application Editor", 
                "link": "https://youtu.be/PCJS6qQZ0nQ",
                "editorId": "<xsl:value-of select="$appEditor/name"/>",
                "image": "images/video2.webp"
              },
              {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
            ]
          },
          {
            "id": "S1.5.3",
            "title": "View and analyse costs",
            "description": "Use the views to analyse the costs of your applications and identify rationalisation opportunities",
            "completed": false,
            "method": [
              {
                "tool": "Application Summary",
                "name": "Shows the costs per application",
                "link": "https://enterprise-architecture.org/university/application-summary/"
              },
              {
                "tool": "Application Cost Analysis",
                "name": "Shows the breakdown of costs by type and per application",
                "link": ""
              },
              {
                "tool": "Application Rationalisation Analysis",
                "name": "Identifies opportunities for rationalisation with details of the cost saved as well as the complexity of removal",
                "link": "https://enterprise-architecture.org/university/application-rationalisation-analysis/"
              },
              {
                "tool": "Application Cost Dashboard (APM pack only)",
                "name": "Shows the breakdown of costs across various dimensions, including against the business capability model",
                "link": ""
              }
            ],
            "taskResources": []
          }
        ]
      },
      {
        "id": "A1.4",
        "title": "Application Dependencies",
        "view": "Application Dependency",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Identify inter-dependencies for applications that are prime for review",
        "dataRequirements": [
          "List of Applications",
          "Detail of Application dependencies, i.e. which applications pass and receive data",
          "An understanding of the Information Exchanged between the applications (optional)"
        ],
        "stakeholders": [
          "Application Owners",
          "IT Service Management",
          "Infrastructure Team",
          "Solution Architects"
        ],
        "infoSources": [
          "CMDB",
          "IT Service Management Spreadsheets",
          "Solution Architects Spreadsheets"
        ],
        "viewsEnabled": [
          {"name": "Application Catalogue", "image":"images/screenshots/application-catalogue.png"},
          {"name": "Application Information Dependency", "image":"images/screenshots/app-info-dependency-json.png"},
          {"name": "Application Connections", "image":"images/screenshots/app-connections.png"}
        ],
        "resources": [],
        "insights": [
          {
            "text": "Understanding the dependencies between applications is crucial for managing change:",
            "subBullets": [
              "Understand impact of change",
              "Understand where two or more applications use the same data"
            ]
          }
        ],
        "tasks": [
          {
            "id": "A1.4.1",
            "title": "Consolidate Information Exchanged",
            "description": "Capture the information exchanged between applications to identify data flowing between applications",
            "completed": false,
            "method": [
            ],
            "taskResources": [ 
              {
                "type": "Editor",
                "title": "Application Editor Using",
                "editorId": "<xsl:value-of select="$appEditor/name"/>",
                "image": "images/video2.webp",
                "link": "https://youtu.be/iEAUJEnwtLI"
              },
              {
                "type": "Read",
                "title": "Application Editor",
                "editorId": "<xsl:value-of select="$appEditor/name"/>",
                "image": "images/reading2.webp",
                "link": "https://enterprise-architecture.org/university/application-editor/"
              },
              {
                "type": "Video",
                "title": "Launchpad Application Dependencies", 
                "image": "images/video4.webp",
                "link": "https://youtu.be/0geopMlw9L8"
              }]
          },
          {
            "id": "A1.4.2",
            "title": "Import to Essential and Publish for Review",
            "description": "Publish and review with stakeholders",
            "completed": false,
            "method": [
            ],
            "taskResources": [
              {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
            ]
          }
        ]
      },
      {
        "id": "T1.1",
        "title": "Technology Reference Model",
        "view": "Technology Reference Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture the technology capabilities the organisation requires and the technology components that support them",
        "dataRequirements": [
          "Technology Domains",
          "Technology Capabilities",
          "Technology Components mapped to the capabilities they support"
        ],
        "stakeholders": [
          "Solution Architects/Technical Architects",
          "IT Service Management"
        ],
        "infoSources": [
          "Solution Architects/Technical Architects",
          "IT Service Management Spreadsheets"
        ],
        "viewsEnabled": [
          {"name": "Technology Reference Model", "image":"images/screenshots/technology-reference-new.png"}
        ],
        "resources": [], 
      "insights": [
        {
          "text": "A Technology Reference Model (TRM) anchored to business capabilities becomes a core pillar of your EA. It gives a common language for how capabilities are enabled by platforms, products and services.",
          "subBullets": [
            "Mapping capabilities to technology components shows exactly how IT enables the business today and where capability outcomes are constrained by weak, missing or obsolete technologies.",
            "You can expose duplication at the technology layer (multiple integration tools, databases, analytics stacks) and quantify rationalisation opportunities beyond just the application layer.",
            "End-of-life, patch and vulnerability status can be assessed per capability, making technology risk visible in business terms and prioritising remediation where it matters.",
            "Vendor concentration risk becomes measurable: which critical capabilities depend on a single vendor, region, or proprietary technology?",
            "Standards and guardrails become actionable: define preferred technologies by capability pattern (e.g., event streaming for real-time operations) and measure conformance.",
            "Integration patterns are clarified (APIs, event streams, ETL, iPaaS), exposing brittle point-to-point links and improving resilience, decoupling and reuse.",
            "Cost optimisation is easier: tie technology TCO (licences, hosting, ops) to the capabilities they support to identify high-cost/low-value areas for savings.",
            "Resilience improves: link technology components to capabilities and to business processes (via applications) to model single points of failure and test recovery scenarios.",
            "Security by design: map required controls (IAM, encryption, secrets, network boundaries) to technology building blocks to prove compliance per capability.",
            "M&amp;A and divestments: the TRM provides a fast way to assess technology overlap and integration complexity by capability domain.",
            "Procurement leverage: consolidate buying across shared technology components that serve multiple capabilities to reduce vendor count and cost.",
            "For low-maturity EA teams, a lightweight TRM (start with 15–25 building blocks) is an excellent entry point. Even a basic map of ‘capability ↔ key tech’ helps projects plan better, informs risk and compliance, and gives the CIO a clear view of the estate’s foundations.",
            "Over time, the TRM becomes the anchor for other initiatives — technology rationalisation, cloud migration, security uplift, data strategy, resilience and cost optimisation — all traced back to business capability outcomes."
          ]
        }
        ],
        "tasks": [
          {
            "id": "T1.1.1",
            "title": "Identify the Technology Components required to support the application estate",
            "description": "If no existing model exists, utilise the knowledge of the Architects and Service Managers to brainstorm the Technology Components that will be required to support the application estate",
            "completed": false,
            "method": [],
            "taskResources": [{ "type": "Reading",
              "title": "Modelling Technology Components",
              "link": "https://enterprise-architecture.org/university/defining-a-technology-component/",
              "image": "images/reading5.webp" 
             }]
          },
          {
            "id": "T1.1.2",
            "title": "Map Technology Capabilities and Tehcnology Components",
            "title": "Map the technology components into Technology Capabilities (and group into Domains)",
            "completed": false,
            "method": [
            ],
            "taskResources": [
               { "type": "Reading",
              "title": "The Technology Layer",
              "link": "https://enterprise-architecture.org/university/technology-modelling-overview/",
                "image": "images/whiteboard1.webp" 
             },
              { "type": "Reading",
              "title": "Modelling Technology Capabilities",
              "link": "https://enterprise-architecture.org/university/defining-technology-capabilities/",
                "image": "images/reading4.webp" 
             },
             {
                "type": "Video",
                "title": "Creating Technology Domains in Launchpad",
                "link": "https://youtu.be/gleyIgAZN3I",
                "image": "images/video.webp"
              },
             {
                "type": "Video",
                "title": "Creating Technology Capabilities in Launchpad",
                "link": "https://youtu.be/wZhDGfve9LM",
                "image": "images/video.webp"
              },
             {
                "type": "Video",
                "title": "Creating Technology Components in Launchpad and mapping to capabilities",
                "link": "https://youtu.be/gplVUoYxPw4",
                "image": "images/video3.webp"
              }, 
              {
                "type": "Editor",
                "title": "The Technology Reference Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/S1aZXYaW6hc",
                "editorId": "<xsl:value-of select="$trmEditor/name"/>"
              }
            ]
          }
        ]
      },
    {
      "id": "T1.3",
      "title": "Application Technology Deployment",
      "view": "Technology Deployment",
        <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
      "description": "Map the deployments of applications to the technology nodes (servers), with locations",
      "dataRequirements": [
        "Applications",
        "Application Deployments",
        "Technology Nodes",
        "Sites"
      ],
      "stakeholders": [
        "Solution/Technical Architects",
        "IT Service Management",
        "Support"
      ],
      "infoSources": [
        "Support",
        "IT Service Management Spreadsheets",
        "Application Teams"
      ],
      "viewsEnabled": [
        "Application Summary (Deployments Tab)",
        "Application by Host Country",
        "Node Summary (limited data)"
      ],
      "resources": [],
      "insights": [
        {
          "text": "Understanding where applications are deployed, and if required adding information to the nodes such as IP address, technology type, etc. It enables questions such as:",
          "subBullets": [
            "What is the impact of node X failing or our cloud provider being unavailable? Which applications would fail?",
            "Which applications are on technology nodes using unsupported technology? Are any critical?",
            "What is the impact as we implement our Cloud First strategy?"
          ]
        }
      ],
      "tasks": [
        {
          "id": "T1.3.1",
          "title": "Identify and capture the Applications",
          "descriptions": "Capture the Applications - ideally this should have been done as part of an earlier play (see A1.1)",
          "completed": false,
          "method": [
          ],
          "taskResources": [
            { "type": "Reading",
              "title": "Modelling Application Providers",
              "link": "https://enterprise-architecture.org/university/application-modelling/",
                "image": "images/reading1.webp" 
             },
              {
                "type": "Video",
                "title": "Using Launchpad to capture Applications, Organisations and mapping together",
                "link": "https://youtu.be/CKsI0n5HlOA",
                "image": "images/video.webp"
              },
              {
                "type": "Video",
                "title": "Using the Application Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/iEAUJEnwtLI",
                "editorId": "<xsl:value-of select="$appEditor/name"/>"
              }
          ]
        },
        {
          "id": "T1.3.2",
          "title": "Capture the Server List, Map to Applications",
          "description": "Engage with the Service Management or Infrastructure teams to get hold of an up-to-date server list. Try to capture the geographic location of the servers as part of this work.  Map the Applications to the Technology Nodes (servers) by Deployment, e.g Production, Test, DR",
          "completed": false,
          "method": [
          ],
          "taskResources": [
          {
              "type": "Read",
              "title": "Application Deployments",
              "link":"https://enterprise-architecture.org/university/application-deployments/",
              "image": "images/reading2.webp"
            },
          {
            "type": "Video",
                "title": "Launchpad - Mapping Servers to Applications",
                "image": "images/video3.webp",
                "link": "https://youtu.be/E6_KNE_mWw0",
          },
              {
                "type": "Video",
                "title": "Application Editor - Mapping Servers",
                "image": "images/video6.webp",
                "link": "https://youtu.be/iEAUJEnwtLI",
                "editorId": "<xsl:value-of select="$appEditor/name"/>"
              }
              ]
        },
        {
          "id": "T1.3.3",
          "title": "Import/Publish the data",
          "description": "Publish and review with stakeholders",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
          ]
        }
      ]
    },
  {
        "id": "A1.3",
        "title": "Application Technology Architecture",
        "view": "Application Technology Architecture",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture the technology architecture of the applications in the IT Estate",
        "dataRequirements": [
          "Applications",
          "Technology Components",
          "Technology Products",
          "Lifecycle Status"
        ],
        "stakeholders": [
          "Solution Architects",
          "IT Service Management",
          "Application Owners",
          "Technical Architects"
        ],
        "infoSources": [
          "CMDB",
          "Spreadsheets"
        ],
        "viewsEnabled": [
          {"name": "Application Technology Strategy Alignment", "image":"images/screenshots/"},
          {"name": "Application Catalogue", "image":"images/screenshots/"},
          {"name": "Technology Component Catalogue", "image":"images/screenshots/"},
          {"name": "Technology Product Catalogue", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
        {
          "text": "Understanding the technology products you have, and which products should be used to provide the technology components required, alongside what technologies are actually used by your applications allows you to understand:",
          "subBullets": [
            "Where you have technology risk",
            "Where the risk to the business is greatest",
            "Where you can rationalise technologies to save money"
          ]
        }
        ],
        "tasks": [
          {
            "id": "A1.3.1",
            "title": "Collate a Technology Product List",
            "description": "If a Technology Product List exists (it may be in a CMDB), review with Stakeholders to: Clean up and de-duplicate, Confirm Lifecycle Statuses, Confirm Technology Product Roles.  If no list exists then, working with the stakeholders, collate one",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Defining Technology Products",
              "link": "https://enterprise-architecture.org/university/defining-technology-providers/",
                "image": "images/whiteboard1.webp" 
             },
             { "type": "Video",
              "title": "Launchpad Technology Products",
              "link": "https://youtu.be/Cs_DGArDgvE",
               "image": "images/video4.webp" 
             }
             ]
          },

          {
            "id": "A1.3.2",
            "title": "Map Technology Products to Technology Components",
            "description": "Map the Technology Products to the Technology Components, add lifecycles if required",
            "completed": false,
            "method": [
            ],
            "taskResources": [ 
             {
                "type": "Editor",
                "title": "The Technology Product Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/EPIvXc0XMGA",
                "editorId": "<xsl:value-of select="$tpEditor/name"/>"
              },
             {
                "type": "Video",
                "title": "Creating Technology Components in Launchpad and mapping to capabilities",
                "link": "https://youtu.be/gplVUoYxPw4",
                "image": "images/video3.webp"
              }, 
              {
                "type": "Editor",
                "title": "The Technology Reference Editor",
                "image": "images/video.webp",
                "link": "https://youtu.be/S1aZXYaW6hc",
                "editorId": "<xsl:value-of select="$trmEditor/name"/>" },
              {
                "type": "Editor",
                "title": "The Technology Lifecycle Editor",
                "image": "images/video5.webp",
                "link": "https://enterprise-architecture.org/university/technology-vendor-lifecycle-editor/",
                "editorId": "<xsl:value-of select="$vendorLifeEditor/name"/>"
              }		 

              ]
            },
              {
            "id": "A1.3.3",
            "title": "Map the Applications to the Technologies they use",
            "description": "Map the Applications to the Technology Components they use",
            "completed": false,
            "method": [
            ],
            "taskResources": [
              {
                "type": "Video",
                "title": "Using the Application Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/iEAUJEnwtLI",
                "editorId": "<xsl:value-of select="$appEditor/name"/>"
              },
              {
                "type": "Video",
                "title": "Launchpad - Application to Technology",
                "image": "images/video5.webp",
                "link": "https://youtu.be/158pYB6DrK0"
              }
            ]
          }
        ]
      },
      {
        "id": "T1.2",
        "title": "Products Catalogue",
        "view": "Products Catalogue",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Understanding in detail the technology components that are required, and which technology products can provide them",
        "dataRequirements": [
          "Technology Components",
          "Technology Suppliers",
          "Technology Products mapped to the components they provide",
          "Technology Lifecycles"
        ],
        "stakeholders": [
          "Solution Architects/Technical Architects",
          "IT Service Management"
        ],
        "infoSources": [
          "Solution Architects/Technical Architects",
          "IT Service Management Spreadsheets"
        ],
        "viewsEnabled": [
           {"name": "Technology Product Catalogue", "image":"images/screenshots/technology-product-catalogue-as-table.png"},
          {"name":"Technology Product Summary", "image":"images/screenshots/technology-product-summary.png"},
          {"name": "Technology Component Summary", "image":"images/screenshots/technology-component-summary.png"}
        ],
        "resources": [], 
      "insights": [
          {
            "text": "Understanding in detail the technology components that are required, and which technology products can provide them allows understanding of: Where you have duplication, Where you have risks, How you can reduce costs, How you can increase agility"
          }],
        "tasks": [
          {
            "id": "T1.2.1",
            "title": "Collate a Technology Product List",
            "description": "Utilise the Architects and Service Managers knowledge and spreadsheets to collate all the technology products currently in use across the IT estate",
            "completed": false,
            "method": [],
            "taskResources": [
            { "type": "Reading",
              "title": "Technology Products",
              "link": "https://enterprise-architecture.org/university/defining-technology-providers/",
                "image": "images/whiteboard2.webp" 
             },

              { "type": "Video",
              "title": "Launchpad Technology Products",
              "link": "https://youtu.be/Cs_DGArDgvE",
                "image": "images/video5.webp" 
             },
              {
                "type": "Editor",
                "title": "The Technology Product Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/EPIvXc0XMGA",
                "editorId": "<xsl:value-of select="$tpEditor/name"/>"
              }
             ]
          },
          {
            "id": "T1.2.2",
            "title": "Map Technology Products to Technology Components",
            "description": "If a Technology Reference Model exists, map the Technology Products to the components",
            "completed": false,
            "method": [],
            "taskResources": [
              { "type": "Video",
              "title": "Technology Reference Editor",
              "link": "https://youtu.be/S1aZXYaW6hc",
              "image": "images/video.webp" 
              }
              ]
          },
          {
            "id": "T1.2.3",
            "title": "Import/Publish the data",
            "description": "Load any Launchpad data and publish or, if using the editors, just publish",
            "completed": false,
            "method": [],
            "taskResources": [{
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }]
          }
        ]
      },
      {
        "id": "D1.1",
        "title": "Data Catalogue",
        "view": "Data Catalogue",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Map the high-level data used in the organisation",
        "dataRequirements": [
          "Data Subjects",
          "Data Objects",
          "Data Object Attributes",
          "Data Governance Personnel, i.e. Data Owners"
        ],
        "stakeholders": [
          "Data Analyst",
          "Business Analyst",
          "DBAs"
        ],
        "infoSources": [
          "Existing Data Models",
          "Business Process Documentation",
          "Database structures"
        ],
        "viewsEnabled": [

          {"name": "Data Catalogue", "image":"images/screenshots/"},
          {"name": "Information Reference Model", "image":"images/screenshots/"},
          {"name": "Data Object Summary (partial)", "image":"images/screenshots/"},
          {"name": "Data Subject Summary (partial)", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
        {
            "text": "A Data Dictionary, or Data Catalogue, provides a consistent set of definitions for an organisation’s data.  It can be used as an anchor to enable the following uses:", "subBullets": [
              "Which applications use which data",
              "Where data issues exist",
              "Which applications should be the source of information for analytics"
              ]
        }
        ],
        "tasks": [
          {
            "id": "D1.1.1",
            "title": "Identify the data used in your organisation",
            "description": "Identify the data used in your organisation by reviewing data models and working with the Data Analysts",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Data Modelling",
              "link": "https://enterprise-architecture.org/university/information-and-data-modelling/",
                "image": "images/reading6.webp" 
             },
              {
                "type": "Video",
                "title": "Enterprise Knowledge - Data in Use",
                "image": "images/video4.webp",
                "link": "https://youtu.be/hR53b8EEqek"
              }
             ]
          },
          {
            "id": "D1.1.2",
            "title": "Capture Data Subjects and Data Objects",
            "description": "Define the Data Subjects, the related Data Objects and the information about the Data Objects",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Video",
                "title": "Launchpad - Data Subject",
                "image": "images/video2.webp",
                "link": "https://youtu.be/GadUYN7YTbw"
              },
             {
                "type": "Video",
                "title": "Launchpad - Data Object",
                "link": "https://youtu.be/KV2IumZHjbs",
                "image": "images/video3.webp"
              }, 
              {
                "type": "Video",
                "title": "Launchpad - Data Object Inheritance",
                "image": "images/video.webp",
                "link": "https://youtu.be/MrgWWXbWLbI" 
              },
              {
                "type": "Video",
                "title": "Launchpad - Data Object Attribute",
                "image": "images/video5.webp",
                "link": "https://youtu.be/0D_GXBrPvR8" 
              }		 

              ]
            },
            {
          "id": "D1.1.3",
          "title": "Import/Publish the data",
          "description": "Publish and review with stakeholders",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
          ]
        }
              
        ]
      },
      {
        "id": "D1.2",
        "title": "Data Model",
        "view": "Data Model",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Map the data structures that underpinning the data model. not (this is the same process as D1.1)",
        "dataRequirements": [
          "Data Subjects",
          "Data Objects" 
        ],
        "stakeholders": [
          "Data Analyst",
          "Business Analyst",
          "DBAs"
        ],
        "infoSources": [
          "Existing Data Models",
          "Business Process Documentation",
          "Database structures"
        ],
        "viewsEnabled": [
          {"name": "Data Subject Model", "image":"images/screenshots/"},
          {"name": "Data Object Model", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
       {
            "text": "Data Models allow understanding of what data and data relationships are required by an organisation to support its capabilities"
       }
        ],
        "tasks": [
          {
            "id": "D1.2.1",
            "title": "Identify the data used in your organisation",
            "description": "Identify the data used in your organisation by reviewing data models and working with the Data Analysts",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Data Modelling",
              "link": "https://enterprise-architecture.org/university/information-and-data-modelling/",
                "image": "images/reading6.webp" 
             },
              {
                "type": "Video",
                "title": "Enterprise Knowledge - Data in Use",
                "image": "images/video4.webp",
                "link": "https://youtu.be/hR53b8EEqek"
              }
             ]
          },
          {
            "id": "D1.2.2",
            "title": "Capture data Subjects and Data Objects",
            "description": "Define the Data Subjects, the related Data Objects and the information about the Data Objects",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Video",
                "title": "Launchpad - Data Subject",
                "image": "images/video2.webp",
                "link": "https://youtu.be/GadUYN7YTbw"
              },
             {
                "type": "Video",
                "title": "Launchpad - Data Object",
                "link": "https://youtu.be/KV2IumZHjbs",
                "image": "images/video3.webp"
              }, 
              {
                "type": "Video",
                "title": "Launchpad - Data Object Inheritance",
                "image": "images/video.webp",
                "link": "https://youtu.be/MrgWWXbWLbI" 
              },
              {
                "type": "Video",
                "title": "Launchpad - Data Object Attribute",
                "image": "images/video5.webp",
                "link": "https://youtu.be/0D_GXBrPvR8" 
              }		 

              ]
            },
            {
          "id": "D1.2.3",
          "title": "Import/Publish the data",
          "description": "Publish and review with stakeholders",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Essential University",
                "title": "Data Import",
                "link": "https://enterprise-architecture.org/university/cloud-data-import/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "How to Import",
                "link": "https://youtu.be/jQlsWyMJLQI",
                "image": "images/video6.webp"
              },
              {
               "type": "Video",
               "title": "Publish and review the results",
               "link": "https://youtu.be/iTnRYgjvQ-U",
               "image": "images/video8.webp"
            }
          ]
        }
              
        ]
      },
      {
        "id": "D1.3",
        "title": "Data Flows",
        "view": "Data Flows",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture data flows between applications",
        "dataRequirements": [
          "Applications",
          "Data Objects and Attributes",
          "Data Representations",
          "Information Concepts and Views",
          "Information Representations" 
        ],
        "stakeholders": [
          "Data Analyst",
          "Application Owners",
          "Data Architects",
          "Integration Architects",
          "IT Service Management"
          
        ],
        "infoSources": [
          "Existing Data Models",
          "Integration Documentation",
          "Application Documentation"
        ],
        "viewsEnabled": [
          {"name": "Data Object Provider Model", "image":"images/screenshots/"},
          {"name": "Data Object Summary", "image":"images/screenshots/"},
          {"name": "Application Connections", "image":"images/screenshots/"},
          {"name": "Application Dependency", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
         {
            "text": "Understanding where data is stored and used by applications enables: Effective and fast project impact assessment as existing information flows are understood; Improved MI as the best source of data is understood"
         }
        ],
        "tasks": [
          {
            "id": "D1.3.1",
            "title": "Define the data used by applications",
            "description": "If a Data Catalogue has been defined, use that to define the data used by applications in the estate",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Data Modelling",
              "link": "https://enterprise-architecture.org/university/information-and-data-modelling/",
                "image": "images/reading6.webp" 
             }
             ]
          },
          {
            "id": "D1.3.2",
            "title": "Understand data usage and ensure data consistency",
            "description": "Verify that key terms are used consistently across all applications, and ensure that identical labels are not being applied to different data elements",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Video",
                "title": "Understanding Data Usage",
                "image": "images/video2.webp",
                "link": "https://youtu.be/hR53b8EEqek"
              }  	 

              ]
            }              
        ]
      },
      {
        "id": "S1.1",
        "title": "Principles",
        "view": "Principles",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture the principles that will guide architecture decisions across the organisation.",
        "dataRequirements": [
          "Principles can be captured across all layers, capture those that are important to you",
          "Capture a rationale and the impacts of the principles on the various layers" 
        ],
        "stakeholders": [
          "Enterprise Architect",
          "CIO",
          "Architects and Analysts",
          "Projects/Change",
          "PMO"
        ],
        "infoSources": [
          "Business Strategy",
          "IT Strategy",
          "EA or CIO business/IT knowledge",
          "Any existing principles documentation"
        ],
        "viewsEnabled": [
          {"name": "Principles Catalogue", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
          {"text": "Architecture Principles are a key part of any enterprise architecture and are used to direct the way the organisation behaves when designing capabilities, processes and/or selecting architecture artefacts (applications, technology, data, etc.) to guide alignment to strategy."},
          {"text": "The Principles act as a mechanism for governance, allowing you to understand where projects and change initiatives are deviating from the defined norms, and to help plan how to move them back on track if required"},
          {"text":"Note: Principles are not firm rules, so they can be broken, as tactical needs can sometimes outweigh strategic ones. It should be a conscious decision to deviate from the principles for compelling reasons, and ideally there should be a plan to move back to adherence"}
        ],
        "tasks": [
          {
            "id": "S1.1.1",
            "title":"Define your principles",
            "description": "Utilise any existing principles that are in use across the organisation.  Utilise the CIO and Enterprise Architects knowledge of the business to either create or test the principles against the business strategy and objectives to ensure they are fit for purpose",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Principles",
              "link": "https://enterprise-architecture.org/university/business-principles/",
              "image": "images/reading6.webp" 
             },
             { "type": "Video",
              "title": "What are and why we have EA principles",
              "link": "https://youtu.be/WUACUdB3kPo",
              "image": "images/whiteboard2.webp" 
             }
             ]
          },
          {
            "id": "S1.1.2",
            "title": "Test your principles",
            "description": "Agree which areas are key to test against the principles; this could be business processes, applications, data or technology depending on your focus, Complete the testing/scoring of the elements against the principles, Communicate the principles to project and change teams and ensure they consider them as part of their process",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Video",
                "title": "Testing Principles",
                "image": "images/video2.webp",
                "link": "https://youtu.be/ukA94FSAaZo"
              }  	 

              ]
            },
            {
          "id": "S1.1.3",
          "title": "Create your principles in Essential",
          "description": "Load the principles into Essential, ensuring you capture the rationale and impacts",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Reading",
                "title": "Principles",
                "link": "https://enterprise-architecture.org/university/business-principles/",
                "image": "images/reading6.webp"
              },
               {
                "type": "Video",
                "title": "Loading Principles into Essential",
                "link": "https://youtu.be/VanAJ0eBx5E",
                "image": "images/video.webp"
              }
          ]
        }
              
        ]
      },
      {
        "id": "S1.3",
        "title": "Plans and Projects",
        "view": "strategicPlans",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Capture the principles that will guide architecture decisions across the organisation.",
        "dataRequirements": [
          "Strategic Plans and Objectives",
          "Any elements impacted by the strategic plans",
          "Information on any Projects and/or Change Initiatives " 
        ],
        "stakeholders": [ 
          "CIO",
          "Business Stakeholders", 
          "PMO"
        ],
        "infoSources": [
          "Business Strategy",
          "IT Strategy",
          "Programmes",
          "Projects"
        ],
        "viewsEnabled": [
          {"name": "Roadmap Dashboard", "image":"images/screenshots/"},
          {"name": "Roadmap Enabled Views", "image":"images/screenshots/"},
          {"name": "Strategic Plan Summary", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
        {
            "text": "Show the strategic plans required to deliver the strategy and see what elements are being changed as part of those plans.  This enables current and future states to be seen, and the impact of delays to be understood.  The Projects Overlay shows the projects implementing the strategic plans and, again, the impacts of project delays can be seen."
        }
        ],
        "tasks": [
          {
            "id": "S1.3.1",
            "title": "Define the strategic plans required to deliver the strategy",
            "description": "Turn the strategy into a set of strategic plans, considering what the key architecture changes will be",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Strategic Plan",
              "link": "https://enterprise-architecture.org/university/strategic-plans/",
              "image": "images/reading2.webp" 
             },
             {
              "type": "Editor",
                "title": "Strategic Plan Editor",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/",
                "image": "images/video6.webp",
                "editorId": "<xsl:value-of select="$strategicPlanEditor/name"/>" 
              },
             {
              "type": "Editor",
                "title": "Roadmap Editor",
                "link": "https://enterprise-architecture.org/university/roadmap-planner-tab/",
                "image": "images/whiteboard2.webp",
                "editorId": "<xsl:value-of select="$roadmapEditor[1]/name"/>" 
              }
             ]
          },
          {
            "id": "S1.3.2",
            "title": "Map the impacted architecture elements to these plans",
            "description": "Map the impacted architecture elements to these plans and define what the type of change will be, e.g. enable, decommission, etc. Capture any dependencies between plans and map the change activities that will deliver the plans",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Read",
                "title": "Mapping plans in the editor",
                "image": "images/reading3.webp",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/"
              },
               {
              "type": "Editor",
                "title": "Strategic Plan Editor",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/",
                "image": "images/video6.webp",
                "editorId": "<xsl:value-of select="$strategicPlanEditor/name"/>" 
              } 

              ]
            },
            {
          "id": "S1.3.3",
          "title": "Publish the changes",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Reading",
                "title": "Publishing",
                "link": "https://enterprise-architecture.org/university/publish-a-repository/",
                "image": "images/reading6.webp"
              } 
          ]
        }
              
        ]
      },
      {
        "id": "S1.4",
        "title": "Standards",
        "view": "Standards",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Identify standards to apply to technologies and applications",
        "dataRequirements": [
          "Identify standards",
          "Capture technology products and the roles they play",
          "The same can be done for applications and services but these views aren’t available yet",
          "Create Reference Architectures (Not strictly necessary, depends on maturity)" 
        ],
        "stakeholders": [ 
          "CIO",
          "Architects and Analysts",
          "Projects"
        ],
        "infoSources": [
          "Business Strategy",
          "IT Strategy",
          "EA knowledge",
          "Technology Product Suppliers"
        ],
        "viewsEnabled": [
          {"name": "Strategic Technology Product Selector", "image":"images/screenshots/"},
          {"name": "Application Service Summary", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
       { "text":   "The standards act as a way of ensuring strategic alignment in the enterprise architecture. They are there to: Ensure that projects have a reference to enable them to make use of the correct standards in design and selection"},
       {"text": "Minimise ongoing costs and speed selection so projects can deliver more quickly."}
        ],
        "tasks": [
          {
            "id": "S1.4.1",
            "title": "Define standards for technology products",
            "description": "Define standards for each of the technology products. Products are assumed in Essential to be mapped to capabilities already, but if not, do this with Launchpad",
            "completed": false,
            "method": [],
            "taskResources": [
             { "type": "Reading",
              "title": "Standards",
              "link": "https://enterprise-architecture.org/university/architecture-standards/",
              "image": "images/reading6.webp" 
             },
             { "type": "Video",
              "title": "Launchpad Standards",
              "link": " ",
              "image": "images/video4.webp" 
             },
             {
                "type": "Editor",
                "title": "The Technology Product Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/EPIvXc0XMGA",
                "editorId": "<xsl:value-of select="$tpEditor/name"/>"
              }
             ]
          },
          {
            "id": "S1.4.2",
            "title": "Define standards for applications",
            "description": "Define standards for applications, in particular this should be at the application service level",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
             {
                "type": "Read",
                "title": "Defining application standards",
                "image": "images/reading3.webp",
                "link": "https://enterprise-architecture.org/university/architecture-standards/"
              }  	 

              ]
            },
            {
          "id": "S1.4.3",
          "title": "Communicate the standards, guide teams",
          "description": "Ensure you have your governance process in place see S1.6, and communicate to project teams about the Product Selector tool and brief teams in how to use it",
          "completed": false,
          "method": [
          ],
          "taskResources": [
             {
                "type": "Read",
                "title": "Using Standards to guide teams",
                "link": "https://enterprise-architecture.org/university/architecture-standards/",
                "image": "images/reading6.webp"
              } 
          ]
        }
              
        ]
      },
      {
        "id": "S1.6",
        "title": "Governance",
        "view": "Governance",
          <xsl:if test="$eipMode = 'true'">"eip": true,</xsl:if>
        "description": "Create a governance structure to manage the architecture.  This play is primarily about setting up the processes and structures to ensure that the architecture is maintained and adhered to.",
        "dataRequirements": [
        "Identify standards",
        "Capture technology products and the roles they play",
        "The same can be done for applications and services but these views aren’t available yet",
        "Create Reference Architectures (Not strictly necessary, depends on maturity)", 
        "Principles can be captured across all layers, capture those that are important to you",
        "Capture a rationale and the impacts of the principles on the various layers" 

        ],
        "stakeholders": [ 
          "CIO",
          "Enterprise Architects",
          "Architects and Analysts",
          "Projects",
          "PMO"
        ],
        "infoSources": [
          "Business Strategy",
          "IT Strategy",
          "EA or CIO business/IT knowledge",
          "Any existing principles documentation",
          "EA knowledge",
          "Technology Product Suppliers"
        ],
        "viewsEnabled": [
          {"name": "Strategic Technology Product Selector", "image":"images/screenshots/"},
            {"name": "Proposal Manager", "image":"images/screenshots/"}
          ],
      "resources": [], 
      "insights": [
         { "text": "Governance brings together architecture principles and standards to ensure that projects and change initiatives align with the business and IT strategy"},
         { "text": "Governance ensures that spend is focused in the right places, that technologies are not being chosen that increase risk, require too much support or block other initiatives. It also ensures that existing artefacts are reused and that maximum benefits gained from the existing estate."}
        ],
        "tasks": [
          {
            "id": "S1.6.1",
            "title": "Collate your Architecture Principles and Standards",
            "description": "Collate your Architecture Principles and Standards, identify your off-strategy elements",
            "completed": false,
            "method": [],
            "taskResources": [
              { "type": "Reading",
              "title": "Standards",
              "link": "https://enterprise-architecture.org/university/architecture-standards/",
              "image": "images/reading6.webp" 
              },
              { "type": "Reading",
              "title": "Principles",
              "link": "https://enterprise-architecture.org/university/business-principles/",
              "image": "images/reading2.webp" 
              },
              { "type": "Video",
              "title": "Launchpad Standards",
              "link": "https://youtu.be/YzRc12hw5jA",
              "image": "images/video4.webp" 
              },
              {
                "type": "Editor",
                "title": "The Technology Product Editor",
                "image": "images/video2.webp",
                "link": "https://youtu.be/EPIvXc0XMGA",
                "editorId": "<xsl:value-of select="$tpEditor/name"/>"
              }
              ]
          },
          {
            "id": "S1.6.2",
            "title": "Define your in-scope projects",
            "description": "Work with the PMO to understand your in-scope projects.  Define your criteria for understanding which projects really matter and so need close monitoring, e.g. significant business impact, high risk or cost, etc.",
            "completed": false,
            "method": [ 
            ],
            "taskResources": [ 
              {
                "type": "Read",
                "title": "Mapping plans in the editor",
                "image": "images/reading3.webp",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/"
              },
               {
              "type": "Editor",
                "title": "Strategic Plan Editor",
                "link": "https://enterprise-architecture.org/university/strategic-plan-editor/",
                "image": "images/video6.webp",
                "editorId": "<xsl:value-of select="$strategicPlanEditor/name"/>" 
              },
              {
                "type": "Editor",
                "title": "Project Impacts Editor",
                "editorId": "<xsl:value-of select="$projectImpactsEditor/name"/>",
                "image": "images/video2.webp",
                "link": ""
               },
               {
                "type": "Video",
                "title": "Launchpad Plus: Strategic Plans",
                "editorId": "",
                "image": "images/video5.webp",
                "link": ""
               } 	 

              ]
            },
            {
              "id": "S1.6.3",
              "title": "Implement a governance process",
              "description": "Implement a governance process (ranging from light to muscular depending on your maturity) that includes a governance meeting schedule where appropriate",
              "completed": false,
              "method": [
              ],
              "taskResources": [
                {
                    "type": "Read",
                    "title": "Effective Governance",
                    "link": "https://enterprise-architecture.org/about/thought-leadership/effective-enterprise-architecture-depends-on-powerful-governance/",
                    "image": "images/reading6.webp"
                  } 
              ]
            },
            {
              "id": "S1.6.4",
              "title": "Tools to govern your architecture",
              "description": "Make use of the tools to help govern your architecture decisions",
              "completed": false,
              "method": [
              ],
              "taskResources": [
                {
                    "type": "Read",
                    "title": "Self Governance",
                    "link": "https://enterprise-architecture.org/about/thought-leadership/self-governance-for-solution-architects/",
                    "image": "images/reading6.webp"
                  },
                  {
                  "type": "Editor",
                    "title": "Proposal Editor",
                    "link": "https://enterprise-architecture.org/university/proposal-editor-cloud-docker/",
                    "image": "images/whiteboard2.webp",
                    "editorId": "<xsl:value-of select="$proposalEditor[1]/name"/>" 
                  },
                   {
                  "type": "Editor",
                    "title": "Business Model Manager",
                    "link": "https://enterprise-architecture.org/university/bus-model-port-mngr-editor/",
                    "image": "images/video.webp",
                    "editorId": "<xsl:value-of select="$busModelManager[1]/name"/>" 
                  } 
              ]
            },
            {
              "id": "S1.6.3",
              "title": "Implement a governance process",
              "description": "Implement a governance process (ranging from light to muscular depending on your maturity) that includes a governance meeting schedule where appropriate",
              "completed": false,
              "method": [
              ],
              "taskResources": [
                {
                    "type": "Reading",
                    "title": "Effective Governance",
                    "link": "https://enterprise-architecture.org/about/thought-leadership/effective-enterprise-architecture-depends-on-powerful-governance/",
                    "image": "images/reading6.webp"
                  } 
              ]
            },
            {
              "id": "S1.6.5",
              "title": "Communicate the governance process",
              "description": "Communicate the governance process to all stakeholders and ensure they understand their roles and responsibilities, and initiate",
              "completed": false,
              "method": [
              ],
              "taskResources": [
                {
                    "type": "Video",
                    "title": "Communnicating Governance",
                    "link": "",
                    "image": "images/video6.webp"
                  }
              ]
            }
              
        ]
      }
    ]
  } 
  </script>

</body>
</html>
    </xsl:template>

    <xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
         
    </xsl:template>

</xsl:stylesheet>
