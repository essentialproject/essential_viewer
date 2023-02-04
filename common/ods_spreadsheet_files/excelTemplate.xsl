<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xslt"
	xmlns:pro="http://protege.stanford.edu/xml"
	xmlns:eas="http://www.enterprise-architecture.org/essential"
	xmlns:functx="http://www.functx.com"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ess="http://www.enterprise-architecture.org/essential/errorview"
	xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:of="urn:oasis:names:tc:opendocument:xmlns:of:1.2" office:version="1.3">	
<xsl:template name="excelHandlebars">
		<script id="excel-template" type="text/x-handlebars-template">

			<table:calculation-settings table:case-sensitive="false" table:search-criteria-must-apply-to-whole-cell="true" table:use-wildcards="true" table:use-regular-expressions="false" table:automatic-find-labels="false"/>
			{{#ifEquals this.lookups 'true'}}
		  <table:content-validations>
			{{#each this.sheets}}
				{{#each this.lookups}} 
			<table:content-validation><xsl:attribute name="table:name">{{this.val}}</xsl:attribute><xsl:attribute name="table:condition">of:cell-content-is-in-list(['{{this.lookUpSheet}}'.${{this.lookupCol}}$8:.${{this.lookupCol}}$3000])</xsl:attribute><xsl:attribute name="table:base-cell-address">{{../this.worksheetNameNice}}.${{this.column}}$8</xsl:attribute>
					<table:help-message table:display="true"/>
					<table:error-message table:display="true"/>
				</table:content-validation>
				{{/each}}
			{{/each}}
			</table:content-validations>
			{{/ifEquals}}
			{{#each this.sheets}}
			<table:table table:style-name="ta1"><xsl:attribute name="table:name">{{this.worksheetNameNice}}</xsl:attribute>
				<table:table-column table:style-name="co1" table:default-cell-style-name="ce2"/>
				<table:table-column table:style-name="co2" table:default-cell-style-name="ce1"><xsl:attribute name="table:number-columns-repeated">{{this.heading.length}}</xsl:attribute></table:table-column> 
				<table:table-column table:style-name="co3" table:default-cell-style-name="ce1"><xsl:attribute name="table:number-columns-repeated">{{#getRowsHead this}}{{/getRowsHead}}</xsl:attribute></table:table-column> 
				<table:table-row table:style-name="ro1">
					<table:table-cell office:value-type="string" table:style-name="ce4">
						<text:p>Name</text:p>
					</table:table-cell>
					<table:table-cell office:value-type="string" table:style-name="ce1">
						<text:p>{{this.name}}</text:p>
					</table:table-cell>
					<table:table-cell table:number-columns-repeated="16382" table:style-name="ce1"/>
				</table:table-row>
				<table:table-row table:style-name="ro1">
					<table:table-cell office:value-type="string" table:style-name="ce4">
						<text:p>Description</text:p>
					</table:table-cell>
					<table:table-cell office:value-type="string" table:style-name="ce1">
						<text:p>{{this.description}}</text:p>
					</table:table-cell>
					<table:table-cell table:number-columns-repeated="16382" table:style-name="ce1"/>
				</table:table-row>
				<table:table-row table:number-rows-repeated="3" table:style-name="ro1">
					<table:table-cell table:number-columns-repeated="16384"/>
				</table:table-row>
				<table:table-row table:style-name="ro1">
					<table:table-cell office:value-type="string" table:style-name="ce1">
						<text:p></text:p>
					</table:table-cell>
				{{#each this.heading}}
					<table:table-cell office:value-type="string" table:style-name="ce3">
						<text:p>{{this.name}}</text:p>
					</table:table-cell>
					{{/each}}
					<table:table-cell><xsl:attribute name="table:number-columns-repeated">{{#getRowsHead this}}{{/getRowsHead}}</xsl:attribute></table:table-cell>
				</table:table-row>
				<table:table-row table:style-name="ro1">
					<table:table-cell table:number-columns-repeated="16384"/>
				</table:table-row>
				{{#getData this.data this.heading this.lookups}}{{/getData}}
			</table:table> 
			{{/each}} 
			
</script>
</xsl:template>
<xsl:template name="excelHandlebarsJS">
		var excelFragment = $('#excel-template').html();
		excelTemplate = Handlebars.compile(excelFragment);
		
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
 
			let row='';
						let validation=''; 
						arg1.forEach((d)=>{
				 row=row+'&lt;table:table-row  table:style-name="ro1">&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p> &lt;/text:p>&lt;/table:table-cell>';
						Object.keys(d).forEach(function(k,i){
						  
						if(typeof d[k] == 'string'){
							if(d[k].includes('&amp;')){
								d[k]=d[k].replace('&amp;','&amp;amp;') 
							}
						}
							if(arg3){
								let validationMatch=arg3.find((v)=>{return v.columnNum==i}); 
								if(validationMatch){validation=validationMatch.val}	  
							}
								if(k!=='row'){ 
									if(validation.length&gt;1){
										row=row+'&lt;table:table-cell office:value-type="string" table:content-validation-name="'+validation+'" table:style-name="ce1">&lt;text:p>'+d[k]+'&lt;/text:p>&lt;/table:table-cell>';
									}
									else{
										row=row+'&lt;table:table-cell office:value-type="string" table:style-name="ce1">&lt;text:p>'+d[k]+'&lt;/text:p>&lt;/table:table-cell>';
									} 
								} 
							validation='';
						})

						 row=row+'&lt;table:table-cell table:number-columns-repeated="'+(16384 - (arg2.length+1))+'">&lt;/table:table-cell>&lt;/table:table-row>'; 
						
					})
			 
						return row
		});
</xsl:template>
</xsl:stylesheet>