<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 
<xsl:template name="excelPlusTemplates">
    <script id="dependencytable-name" type="text/x-handlebars-template">
        [
        {{#each this}}
          {{#if this.parentBusinessCapability}}
            {{#each this.parentBusinessCapability}}
              {
                "ID": "{{../this.id}}",
                "Name": "{{{../this.name}}}",
                "Description": "{{#escaper ../this.description}}{{/escaper}}",
                "parent": "{{{this.name}}}",
                "positioninparent": "{{../this.positioninParent}}",
                "sequencenumber": "{{../this.sequenceNumber}}",
                "rootCapability": "{{../this.rootCapability}}",
                "businessDomain": "{{../this.businessDomain}}",
                "level": "{{../this.level}}"
              }{{#unless @last}},{{/unless}}
            {{/each}}
          {{else}}
            {
              "ID": "{{this.id}}",
              "Name": "{{{this.name}}}",
              "Description": "{{#escaper this.description}}{{/escaper}}",
              "parent": "{{{this.name}}}",
              "positioninparent": "{{this.positioninParent}}",
              "sequencenumber": "{{this.sequenceNumber}}",
              "rootCapability": "{{this.rootCapability}}",
              "businessDomain": "{{this.businessDomain}}",
              "level": "{{this.level}}"
            }
          {{/if}}
          {{#unless @last}},{{/unless}}
        {{/each}}
      ]
      
    </script>
  </xsl:template>
    
      
</xsl:stylesheet>