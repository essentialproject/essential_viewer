<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:ooo="http://openoffice.org/2004/office"
    xmlns:ooow="http://openoffice.org/2004/writer"
    xmlns:oooc="http://openoffice.org/2004/calc"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:rpt="http://openoffice.org/2005/report"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:grddl="http://www.w3.org/2003/g/data-view#"
    xmlns:officeooo="http://openoffice.org/2009/office"
    xmlns:tableooo="http://openoffice.org/2009/table"
    xmlns:drawooo="http://openoffice.org/2010/draw"
    xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0"
    xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
    xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0"
    xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0"
	xmlns:css3t="http://www.w3.org/TR/css3-text/" office:version="1.2">	
	<office:scripts/>
    
<xsl:template name="wordHandlebars">
<script id="word-template" type="text/x-handlebars-template">
<office:body>
  <office:text text:use-soft-page-breaks="true"> 
      
        <text:h text:style-name="headingPara" text:outline-level="1">{{name}}</text:h>
     
    {{#each this.sections}}    
    {{#if this.content}}
            {{#if header}}  
            <text:h text:style-name="subHeadingPara" text:outline-level="2">{{header}}</text:h>
            {{/if}}
            {{#if header}}  
                {{#if this.intro}}
                <text:p text:style-name="Standard">{{this.intro}}</text:p>
                {{/if}}
            {{/if}}
            <text:p text:style-name="Standard"/>
        {{#ifEquals this.type "paragraph"}} 
            {{#each this.content}}   
            <text:p text:style-name="Standard">{{this}}</text:p>
            <text:p text:style-name="Standard"/>
            {{/each}}   
        {{/ifEquals}}    
       
        {{#ifEquals this.type "bullets"}} 
            <text:list text:style-name="WWNum1">
                {{#each this.content}}   
                <text:list-item>
                    <text:p text:style-name="Standard">{{this}}</text:p>
                </text:list-item>
                {{/each}}
            </text:list>
            <text:p text:style-name="Standard"/>
        {{/ifEquals}} 
        {{#ifEquals this.type "table"}} 
        <table:table table:name="Table1" table:style-name="tableStyle"> 
            <table:table-columns>
            {{#each this.headings}}
            <table:table-column table:style-name="tableColumn"/>
            {{/each}}
        </table:table-columns>
            <table:table-row table:style-name="tableColumn">
                {{#each this.headings}}
                <table:table-cell table:style-name="TableColumnCell" office:value-type="string">
                    <text:p text:style-name="Standard">{{this}}</text:p>
                </table:table-cell>
                {{/each}}
            </table:table-row>
            {{#each this.content}}
            <table:table-row table:style-name="tableCell">
                    {{#each this}}
                    <table:table-cell table:style-name="tableCell" office:value-type="string">
                        <text:p text:style-name="Standard">{{this}}</text:p>
                    </table:table-cell>
                    {{/each}}
            </table:table-row>
            {{/each}}
        </table:table>
        {{/ifEquals}} 
        {{#ifEquals this.type "image"}}
        <text:p text:style-name="Standard">{{content}}</text:p>
    {{/ifEquals}}  
    {{/if}}  
    {{/each}}
</office:text>  
</office:body>
			
</script>


</xsl:template>

<xsl:template name="wordKeyVariablesJS">
    <!-- wrappers for either side of the ODT file -->
    let contentHead='&lt;?xml version="1.0" encoding="UTF-8"?>&lt;office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0" xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0" xmlns:math="http://www.w3.org/1998/Math/MathML" xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0" xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0" xmlns:ooo="http://openoffice.org/2004/office" xmlns:ooow="http://openoffice.org/2004/writer" xmlns:oooc="http://openoffice.org/2004/calc" xmlns:dom="http://www.w3.org/2001/xml-events" xmlns:xforms="http://www.w3.org/2002/xforms" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:rpt="http://openoffice.org/2005/report" xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:grddl="http://www.w3.org/2003/g/data-view#" xmlns:officeooo="http://openoffice.org/2009/office" xmlns:tableooo="http://openoffice.org/2009/table" xmlns:drawooo="http://openoffice.org/2010/draw" xmlns:calcext="urn:org:documentfoundation:names:experimental:calc:xmlns:calcext:1.0" xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0" xmlns:field="urn:openoffice:names:experimental:ooo-ms-interop:xmlns:field:1.0" xmlns:formx="urn:openoffice:names:experimental:ooxml-odf-interop:xmlns:form:1.0" xmlns:css3t="http://www.w3.org/TR/css3-text/" office:version="1.2">&lt;office:scripts/>&lt;office:font-face-decls>&lt;style:font-face style:name="Arial" svg:font-family="Arial" style:font-family-generic="roman" style:font-pitch="variable"/>&lt;style:font-face style:name="Calibri Light" svg:font-family="Calibri Light" style:font-family-generic="swiss" style:font-pitch="variable" svg:panose-1="2 15 3 2 2 2 4 3 2 4"/>&lt;style:font-face style:name="Calibri" svg:font-family="Calibri" style:font-family-generic="swiss" style:font-pitch="variable" svg:panose-1="2 15 5 2 2 2 4 3 2 4"/>&lt;/office:font-face-decls>&lt;office:automatic-styles>&lt;style:style style:name="headingPara" style:parent-style-name="Heading1" style:master-page-name="MP0" style:family="paragraph">&lt;style:paragraph-properties fo:break-before="auto"/>&lt;/style:style>&lt;style:style style:name="subHeadingPara" style:parent-style-name="Heading2" style:master-page-name="MP0" style:family="paragraph">&lt;style:paragraph-properties fo:break-before="auto"/>&lt;/style:style>&lt;style:style style:name="underlineText" style:family="text">&lt;style:text-properties style:text-underline-style="solid" style:text-underline-width="auto" style:text-underline-color="font-color"/>&lt;/style:style>&lt;style:style style:name="boldText" style:family="text">&lt;style:text-properties fo:font-weight="bold" style:font-weight-asian="bold"/>&lt;/style:style>&lt;style:style style:name="plainText" style:parent-style-name="Normal" style:family="text">&lt;style:text-properties style:text-underline-style="none"/>&lt;/style:style>&lt;style:style style:name="tableStyle" style:family="table">&lt;style:table-properties style:width="6.2701in" fo:margin-left="0in" fo:margin-top="0in" fo:margin-bottom="0in" fo:break-before="auto" fo:break-after="auto" table:align="left" />&lt;/style:style>&lt;style:style style:name="tableCell" style:family="paragraph" style:parent-style-name="Standard">&lt;style:paragraph-properties fo:margin-left="0in" fo:margin-right="0in" fo:margin-top="0in" fo:margin-bottom="0in" fo:line-height="100%" fo:text-align="start" style:justify-single-word="false" fo:keep-together="auto" fo:orphans="0" fo:widows="0" fo:text-indent="0in" style:auto-text-indent="false" fo:padding="0in" fo:border="none" fo:keep-with-next="auto" />&lt;/style:style>&lt;style:style style:name="tableColumn" style:family="table-column">&lt;style:table-column-properties style:column-width="2.0903in"/>&lt;/style:style>&lt;style:style style:name="TableColumnCell" style:family="table-cell">&lt;style:table-cell-properties fo:border="none" fo:background-color="#D9D9D9" style:writing-mode="lr-tb" fo:padding-top="0in" fo:padding-left="0.0069in" fo:padding-bottom="0in" fo:padding-right="0.0069in"/>&lt;/style:style>&lt;style:style style:name="Table1" style:family="table">&lt;style:table-properties style:width="6.2701in" fo:margin-left="0in" fo:margin-top="0in" fo:margin-bottom="0in" fo:break-before="auto" fo:break-after="auto" table:align="left"/>&lt;/style:style>&lt;style:style style:name="tableRow" style:family="table-row">&lt;style:table-row-properties fo:keep-together="auto" />&lt;/style:style>&lt;style:style style:name="bullet" style:family="paragraph" style:parent-style-name="Standard" style:list-style-name="bulletedListStyleUL">&lt;style:paragraph-properties fo:margin-left="0.5in" fo:margin-right="0in" fo:text-indent="-0.25in" style:auto-text-indent="false" />&lt;/style:style>&lt;style:style style:name="newPara" style:family="paragraph" style:parent-style-name="Heading_20_1" style:master-page-name="Standard">&lt;style:paragraph-properties style:page-number="1" />&lt;/style:style>&lt;/office:automatic-styles>';

    let contentFoot='&lt;/office:document-content>';
    
    function generateWordZip(c,m,meta,mime,s,sty, fileName){
        zip.file("content.xml", c)
        zip.folder("META-INF").file("manifest.xml", m)
        zip.file("meta.xml", meta)
        zip.file("mimetype", mime)
        zip.file("settings.xml", s)
        zip.file("styles.xml", sty)
        var zipConfig = {
                    type: 'blob',
                    mimeType: 'application/vnd.oasis.opendocument.document'
                };


        zip.generateAsync(zipConfig)
            .then(function (blob) {
        saveAs(blob, fileName+".odt");
        });
        console.log('zip',zip) 
    }
</xsl:template>
<xsl:template name="wordHandlebarsJS">
		var wordFragment = $('#word-template').html();
		wordTemplate = Handlebars.compile(wordFragment);
		
		Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
			return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
		});
		Handlebars.registerHelper('getRows', function(arg1) {
			 
			return (16384 - arg1.heading.length)
		});
		
		Handlebars.registerHelper('getRowsHead', function(arg1) {
	 
			return (16384 - ((arg1.heading.length)+1))
		});

		Handlebars.registerHelper('getData', function(arg1, arg2, arg3) {
 
						return row
        });

       
</xsl:template>
</xsl:stylesheet>