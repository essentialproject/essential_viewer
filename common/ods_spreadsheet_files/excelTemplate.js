  
				<table:calculation-settings table:case-sensitive="false" table:search-criteria-must-apply-to-whole-cell="true" table:use-wildcards="true" table:use-regular-expressions="false" table:automatic-find-labels="false"/>
				{{#ifEquals this.lookups 'true'}}
			  <table:content-validations>
				{{#each this.sheets}}
					{{#each this.lookups}}
				<table:content-validation><xsl:attribute name="table:name">{{this.val}}</xsl:attribute><xsl:attribute name="table:condition">of:cell-content-is-in-list([{{this.lookUpSheet}}.${{this.lookupCol}}$8:.${{this.lookupCol}}$3000])</xsl:attribute><xsl:attribute name="table:base-cell-address">{{../this.worksheetName}}.${{this.column}}$8</xsl:attribute>
						<table:help-message table:display="true"/>
						<table:error-message table:display="true"/>
					</table:content-validation>
					{{/each}}
				{{/each}}
				</table:content-validations>
				{{/ifEquals}}
				{{#each this.sheets}}
				<table:table table:style-name="ta1"><xsl:attribute name="table:name">{{this.worksheetName}}</xsl:attribute>
					<table:table-column table:style-name="co1" table:default-cell-style-name="ce2"/>
					<table:table-column table:style-name="co2" table:default-cell-style-name="ce1"><xsl:attribute name="table:number-columns-repeated">{{this.heading.length}}</xsl:attribute></table:table-column> 
					<table:table-column table:style-name="co3" table:default-cell-style-name="ce1"><xsl:attribute name="table:number-columns-repeated">{{#getRowsHead this}}{{/getRowsHead}}</xsl:attribute></table:table-column> 
					<table:table-row table:style-name="ro1">
						<table:table-cell office:value-type="string" table:style-name="ce1">
							<text:p>Name</text:p>
						</table:table-cell>
						<table:table-cell office:value-type="string" table:style-name="ce1">
							<text:p>{{this.name}}</text:p>
						</table:table-cell>
						<table:table-cell table:number-columns-repeated="16382" table:style-name="ce1"/>
					</table:table-row>
					<table:table-row table:style-name="ro1">
						<table:table-cell office:value-type="string" table:style-name="ce1">
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
						<table:table-cell office:value-type="string" table:style-name="ce1">
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
 
 