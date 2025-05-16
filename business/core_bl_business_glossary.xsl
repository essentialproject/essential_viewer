<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
<xsl:import href="../common/core_js_functions.xsl"></xsl:import> 
<xsl:include href="../common/core_doctype.xsl"></xsl:include>
<xsl:include href="../common/core_common_head_content.xsl"></xsl:include>
<xsl:include href="../common/core_header.xsl"></xsl:include>
<xsl:include href="../common/core_footer.xsl"></xsl:include>
<xsl:include href="../common/core_external_doc_ref.xsl"></xsl:include>

<xsl:output method="html" omit-xml-declaration="yes" indent="yes"></xsl:output>

<xsl:param name="param1"></xsl:param>

<!-- START GENERIC PARAMETERS --> 

<xsl:param name="viewScopeTermIds"/>
<xsl:param name="targetReportId"/>
<xsl:param name="targetMenuShortName"/> 

 
<!-- START GENERIC CATALOGUE SETUP VARIABES -->
<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
<xsl:key name="term" match="/node()/simple_instance[type='Business_Term']" use="type"/>
<xsl:key name="termName" match="/node()/simple_instance[type='Business_Term']" use="name"/>
<xsl:key name="synonyms" match="/node()/simple_instance[type='Synonym']" use="name"/>
<xsl:key name="allExternalReferenceLinks" match="/node()/simple_instance[type='External_Reference_Link']" use="name"/>


<!-- END GENERIC PARAMETERS -->

<!-- START GENERIC LINK VARIABLES -->
<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
    <xsl:variable name="linkClasses" select="('Business_Process', 'Application_Provider', 'Composite_Application_Provider','Business_Capability')"/>
  
	<!--
		* Copyright © 2008-2024 Enterprise Architecture Solutions Limited.
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
   <!-- Set the path to the DataSet API NAME as configured in the repo and pointing to your api file, you can have multiple data sets-->	
	
   
    <xsl:template match="knowledge_base">
		 
        
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"></xsl:call-template>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"></xsl:with-param>
						<xsl:with-param name="targetMenu" select="()"></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
                <title><xsl:value-of select="eas:i18n('Business Glossary')"/></title>
              	<!--script to support smooth scroll back to top of page-->
			 
				<script src="js/d3/d3.v5.9.7.min.js"></script>
				<!-- ADD JAVASCRIPT FOR CONTEXT POP-UP MENUS, WHERE REQUIRED -->
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<style>
                   
                    .notepad {
                        display: flex;
                        flex: 1;
                        gap: 20px;
                        width: 100%;
                        height: 79vh; /* Set height to fill the viewport */
                    }
                    
                    .letters {
                        display: flex;
                        flex-direction: column;
                        gap: 5px;
                        padding-right: 10px;
                        font-weight:bold;
                        font-size:14pt;
                        border-right: 1px solid #ccc;
                        min-width: 50px;
                        overflow-y: auto;
                        height: 82vh; /* Set height to fill the viewport */
                    }

                    .letter:hover {
                        color: blue;
                    }

                    .letter.selected {
                        background-color: #3ce0d7; /* Highlight color */
                        color: white; /* Change text color when selected */
                        border-radius: 5px;
                        padding: 5px; /* Optional padding for better appearance */
                    }
                    
                    .glossary-container {
                        flex: 1;
                        border: 1px solid #ddd;
                        
                        padding: 20px;
                        border-radius: 5px;
                        position: relative;
                        overflow-y: auto; /* Enable scrolling within the glossary */
                        height: 82vh; /* Set height to fill the viewport */
                        transition: transform 0.6s;
                        backface-visibility: hidden;
                    }
                    
                    .glossary-container.turning {
                        transform: rotateX(90deg);
                    }
                    .glossary-item {
                        padding: 10px;
                        margin-bottom: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        position: relative;
                        width: 100%;
                        border-left:3px solid #3ce0d7; 
                    }

                    .synonym{
                        font-size:10px;
                    }
                    .empty-message {
                        text-align: center;
                        margin-top: 20px;
                        font-style: italic;
                    }
                    .gHeader{
                        font-size:20px;
                    }
                </style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"></xsl:call-template>
			 
				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"></xsl:value-of>: </span>
									<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Business Glossary')"/></span>
								</h1>
							</div>
                        </div>
					 
						<div class="col-xs-12"> 
                            <div class="notepad">
                                <div class="letters" id="letters">
                                    <!-- Alphabet letters will be dynamically generated here -->
                                </div>
                            
                                <div class="glossary-container" id="glossary-container">
                                    <div class="empty-message">Loading...</div>
                                </div>
                            </div>   
						</div>
                   </div>
                 
                
                </div>
               
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"></xsl:call-template>
<!-- Handlebars Template -->
<script id="glossary-template" type="text/x-handlebars-template">
    {{#each this}}
        <div class="glossary-item"><xsl:attribute name="id">term-{{this.id}}</xsl:attribute><xsl:attribute name="data-id">{{this.id}}</xsl:attribute>
            <span class="gHeader">{{name}}</span><br/>
            <span style="font-size:0.9em">
                <b>Description</b>:  {{#if description.length}} {{description}}  {{else}}
                    None
                {{/if}}<br/>
                {{#if business_term_example.length}} <b>Example</b>: {{business_term_example}}<br/>{{/if}}
                {{#if this.synonyms.length}}
                <b>Synonyms</b>: 
                {{#each this.synonyms}}<i>{{this.name}}</i>{{#unless @last}}, {{/unless}} {{/each}}
                 <br/>
                {{/if}}
                <b>Related Terms</b>: 
                {{#if this.related_terms.length}}
                    {{#each this.related_terms}}
                        <a class="related-term-link"><xsl:attribute name="href">#term-{{this.id}}</xsl:attribute><xsl:attribute name="data-term-name">{{this.name}}</xsl:attribute><xsl:attribute name="data-term-id">{{this.id}}</xsl:attribute><i>{{this.name}}</i></a>{{#unless @last}}, {{/unless}}
                    {{/each}}
                {{else}}
                    None
                {{/if}}<br/>
                {{#if external_reference_links.length}} <b>External links</b>: {{#each this.external_reference_links}} {{#if this.url.length}}<a><xsl:attribute name="href">{{this.url}}</xsl:attribute><xsl:attribute name="title">{{this.description}}</xsl:attribute>{{this.name}}</a>{{#unless @last}}, {{/unless}} {{/if}} {{/each}}<br/>{{/if}}
            </span>
        </div>
    {{/each}}
</script>

		
            </body>
			
			<script>	
            <!-- required for Data set API, specify one with-param per data set -->		
			
// Sample glossary data in JSON format
var glossaryData=[<xsl:apply-templates select="key('term', 'Business_Term')" mode="term"/>]
console.log('glossaryData',glossaryData)
  
// Function to render letters in the sidebar
// Function to render letters in the sidebar
function renderLetters() {
    const lettersContainer = document.getElementById('letters');
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    alphabet.forEach(letter => {
        const letterElement = document.createElement('div');
        letterElement.textContent = letter;
        letterElement.classList.add('letter');
        letterElement.addEventListener('click', () => handleLetterClick(letter, letterElement));
        lettersContainer.appendChild(letterElement);
    });
}

// Function to handle letter clicks and apply page-turn effect
function handleLetterClick(letter, clickedElement) {
    const glossaryContainer = document.getElementById('glossary-container');

    // Check if the clicked element is valid before attempting to modify it
    if (clickedElement) {
        // Highlight the clicked letter and remove highlight from others
        document.querySelectorAll('.letter').forEach(el => el.classList.remove('selected'));
        clickedElement.classList.add('selected');
    }

    // Apply the page-turn effect
    glossaryContainer.classList.add('turning');

    // Set a delay to allow the turn effect to play before updating content
    setTimeout(() => {
        const filteredData = glossaryData.filter(item => item.name.toUpperCase().startsWith(letter));
        renderGlossary(filteredData);
        glossaryContainer.classList.remove('turning');
    }, 600); // Duration matches the CSS transition time
}

// Function to render the glossary using Handlebars
function renderGlossary(data) {
    const source = document.getElementById('glossary-template').innerHTML;
    const template = Handlebars.compile(source);
    const glossaryContainer = document.getElementById('glossary-container');
    glossaryContainer.innerHTML = data.length ? template(data) : '<div class="empty-message">No terms found.</div>';

    // Event listener to handle related term clicks
    document.querySelectorAll('.related-term-link').forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const termId = this.getAttribute('data-term-id');
            const termName = this.getAttribute('data-term-name');
            openLetterAndScrollToTerm(termId, termName);
        });
    });
}

// Function to programmatically open the relevant letter


// Function to programmatically open the relevant letter and scroll to the specific term
function openLetterAndScrollToTerm(termId, termName) {
    // Find the first letter of the term name
    const firstLetter = termName.charAt(0).toUpperCase();

    // Trigger the letter click programmatically to open the relevant section
    handleLetterClick(firstLetter);

    // Wait for the glossary to render before scrolling
    setTimeout(() => {
        const targetElement = document.getElementById(`term-${termId}`);
        if (targetElement) {
            // Scroll to the term with the element positioned at the top of the container
            targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }, 700); // Adjust timing to ensure it runs after the initial scroll
}


 

// Initial render of letters and default display of 'A' terms
renderLetters();
handleLetterClick('A'); // Default open on letter A



			</script>
		</html>
	</xsl:template>
 <xsl:template match="node()" mode="term">
 
    <xsl:variable name="relatedExternalLinks" select="key('allExternalReferenceLinks', current()/own_slot_value[slot_reference = ('external_reference_links')]/value)"/>
    <xsl:variable name="syns" select="key('synonyms', current()/own_slot_value[slot_reference = ('synonyms')]/value)"/>
    <xsl:variable name="related" select="key('termName', current()/own_slot_value[slot_reference = ('business_term_related_terms')]/value)"/>
    {
        "id":"<xsl:value-of select="current()/name"/>", 
	   <xsl:variable name="combinedMap" as="map(*)" select="map{
	   'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')), 
	   'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')')),
       'business_term_example': string(translate(translate(current()/own_slot_value[slot_reference = ('business_term_examples')]/value,'}',')'),'{',')'))
	 }" />
	 <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	 <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>,

     "synonyms": [<xsl:for-each select="$syns"> {
        "id":"<xsl:value-of select="current()/name"/>", 
        <xsl:variable name="combinedMap" as="map(*)" select="map{
        'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
        }" />
	    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
	    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
        
    "related_terms": [<xsl:for-each select="$related"> {
    "id":"<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')'))
    }" />
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],

    "external_reference_links": [<xsl:for-each select="$relatedExternalLinks"> {
    "id":"<xsl:value-of select="current()/name"/>", 
    <xsl:variable name="combinedMap" as="map(*)" select="map{
    'name': string(translate(translate(current()/own_slot_value[slot_reference = ('name')]/value,'}',')'),'{',')')),
    'url': string(translate(translate(current()/own_slot_value[slot_reference = ('external_reference_url')]/value,'}',')'),'{',')')),
    'description': string(translate(translate(current()/own_slot_value[slot_reference = ('description')]/value,'}',')'),'{',')'))
    }" />
    <xsl:variable name="resultCombined" select="serialize($combinedMap, map{'method':'json', 'indent':true()})" />
    <xsl:value-of select="substring-before(substring-after($resultCombined,'{'),'}')"/>}<xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>],
         
         
}<xsl:if test="position()!=last()">,</xsl:if>
</xsl:template>
	</xsl:stylesheet>
