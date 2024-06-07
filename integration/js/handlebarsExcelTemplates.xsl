<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 
<xsl:template name="excelTemplates">
    <script id="captable-name" type="text/x-handlebars-template">
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

    <script id="domtable-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.parentDomain}}
              {{#each this.parentDomain}}
                {
                  "id": "{{../this.id}}", 
                  "name": "{{{../this.name}}}", 
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "parent": "{{{this.name}}}"
                }{{#unless @last}},{{/unless}}
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}", 
                "name": "{{{this.name}}}", 
                "description": "{{#escaper this.description}}{{/escaper}}",
                "parent": ""
              }{{#unless @last}},{{/unless}}
            {{/if}}
          {{/each}}
        ]
    </script>
        

    <script id="processtable-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.parentCaps}}
              {{#each this.parentCaps}}
                {
                  "id": "{{../this.id}}", 
                  "name": "{{{../this.name}}}", 
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "parent_capability": "{{{this.name}}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}", 
                "name": "{{{this.name}}}", 
                "description": "{{#escaper this.description}}{{/escaper}}",
                "parent_capability": ""
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        

    <script id="processfamilytable-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.containedProcesses}}
              {{#each this.containedProcesses}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "process": "{{{this.name}}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "process": ""
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="sites-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}",
              "country": "{{this.countries.0.name}}"
            }{{#unless @last}},{{/unless}}
          {{/each}}
        ]
    </script>
        

    <script id="orgs-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.parents}}
              {{#each this.parents}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "parent": "{{{this.name}}}",
                  "external": "{{../this.external}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "parent": "",
                "external": "{{this.external}}"
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="orgsite-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.site}}
              {{#each this.site}}
                {
                  "organisation": "{{{../this.name}}}",
                  "site": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="appcap-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.SupportedBusCapability}}
              {{#each this.SupportedBusCapability}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper this.description}}{{/escaper}}",
                  "appCategory": "{{../this.appCapCategory}}",
                  "busdom": "",
                  "parentAppCat": "",
                  "supportedCap": "{{{this.name}}}",
                  "refLayer": "{{../ReferenceModelLayer}}"
                },
              {{/each}}
            {{/if}}
            {{#if this.businessDomain}}
              {{#each this.businessDomain}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "appCategory": "{{../this.appCapCategory}}",
                  "busdom": "{{{this.name}}}",
                  "parentAppCat": "",
                  "supportedCap": "",
                  "refLayer": "{{../ReferenceModelLayer}}"
                },
              {{/each}}
            {{/if}}
            {{#if this.ParentAppCapability}}
              {{#each this.ParentAppCapability}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper this.description}}{{/escaper}}",
                  "appCategory": "{{../this.appCapCategory}}",
                  "busdom": "",
                  "parentAppCat": "{{{this.name}}}",
                  "supportedCap": "",
                  "refLayer": "{{../ReferenceModelLayer}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
          {{#each this}}
            {{#unless this.ParentAppCapability}}
              {{#unless this.SupportedBusCapability}}
                {{#unless this.businessDomain}}
                  {
                    "id": "{{this.id}}",
                    "name": "{{{this.name}}}",
                    "description": "{{#escaper this.description}}{{/escaper}}",
                    "appCategory": "{{this.appCapCategory}}",
                    "busdom": "",
                    "parentAppCat": "",
                    "supportedCap": "",
                    "refLayer": "{{this.ReferenceModelLayer}}"
                  },
                {{/unless}}
              {{/unless}}
            {{/unless}}
          {{/each}}
        ]
    </script>
        
    <script id="app2svc-name" type="text/x-handlebars-template">
        [
            {{#each this}}
            {{#if this.services}}
                {{#each this.services}} 
                {
                    "app": "{{{../this.name}}}",
                    "service": "{{{this.name}}}"
                },
                {{/each}}
            {{/if}}
            {{/each}}
        ]
    </script>
        
    <script id="apps-name" type="text/x-handlebars-template">
        [
            {{#each this}}
            {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "codebase_name": "{{this.codebase_name}}",
                "lifecycle_name": "{{this.lifecycle_name}}",
                "delivery_name": "{{this.delivery_name}}"
            }{{#unless @last}},{{/unless}}
            {{/each}} 
        ]
    </script>
            
    <script id="appcapsvc-name" type="text/x-handlebars-template">			
        [
          {{#each this}}
            {{#if this.services}}
              {{#each this.services}}
                {
                  "capability": "{{{../this.name}}}",				
                  "service": "{{{this.name}}}"
                },				
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="appsvc-name" type="text/x-handlebars-template">		 
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}"
            }{{#unless @last}},{{/unless}}
          {{/each}}
        ]
    </script>
        
    <script id="bp2appsvc-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.services}}
              {{#each this.services}}
                {
                  "Business Process": "{{{../this.name}}}",
                  "ApplicationService": "{{{this.name}}}",
                  "Criticality": "{{../this.criticality}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="pp2appviasvc-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.appsviaservice}}
              {{#each this.appsviaservice}}
                {
                  "Process": "{{../this.processName}}",
                  "org": "{{../this.org}}",
                  "appAndService": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="pp2app-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.appsdirect}}
              {{#each this.appsdirect}}
                {
                  "Process": "{{../this.processName}}",
                  "Org": "{{../this.org}}",
                  "Application": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="app2org-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.actors}}
              {{#each this.actors}}
                {
                  "app": "{{{../this.name}}}",
                  "org": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="inforeps-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}"
            }{{#unless @last}},{{/unless}}
          {{/each}}
        ]
    </script>
        
    <script id="servers-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.ipAddresses}}
              {{#each this.ipAddresses}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "hosted": "{{../this.hostedIn}}",
                  "ip": "{{this}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "hosted": "{{this.hostedIn}}",
                "ip": "{{this.ipAddress}}"
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="app2server-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.deployment}}
              {{#each this.deployment}}
                {
                  "app": "{{{../this.name}}}",
                  "servers": "{{../this.server}}",
                  "env": "{{{this.name}}}"
                },
              {{/each}}
            {{else}}
              {
                "app": "{{{this.name}}}",
                "servers": "{{this.server}}",
                "env": ""
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="techdoms-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}",
              "position": "{{this.ReferenceModelLayer}}"
            },
          {{/each}}
        ]
    </script>
        
    <script id="techcaps-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}",
              "domain": "{{this.domain}}"
            },
          {{/each}}
        ]
    </script>
        
    <script id="techcomps-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.caps}}
              {{#each this.caps}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "parentCap": "{{this}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "parentCap": ""
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="techprods-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.usages}}
              {{#each this.usages}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{#escaper ../this.name}}{{/escaper}}",
                  "supplier": "{{../this.supplier}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "family": "{{#each ../this.family}}{{#ifEquals @index 0}}{{this.name}}{{/ifEquals}}{{/each}}",
                  "releaseStatus": "{{../this.vendor}}",
                  "delivery": "{{../this.delivery}}",
                  "usage": "{{{this.name}}}",
                  "compliance": "{{this.compliance}}",
                  "adoption": "{{this.adoption}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{#escaper this.name}}{{/escaper}}",
                "supplier": "{{this.supplier}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "family": "{{this.family}}",
                "releaseStatus": "{{this.vendor}}",
                "delivery": "{{this.delivery}}",
                "usage": "",
                "compliance": "",
                "adoption": ""
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        

    <script id="techsuppliers-name" type="text/x-handlebars-template">
        [
            {{#each this}}
            {
                "id": "{{this.id}}", 
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}"
            }{{#unless @last}},{{/unless}}
            {{/each}}
        ]	
    </script>
            
    <script id="techprodfamily-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {
              "id": "{{this.id}}",
              "name": "{{{this.name}}}",
              "description": "{{#escaper this.description}}{{/escaper}}"
            }{{#unless @last}},{{/unless}}
          {{/each}}
        ]	 
    </script>
        
    <script id="techprodorg-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.org}}
              {{#each this.org}}
                {
                  "products": "{{{../this.name}}}",
                  "orgs": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="datasubject-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.synonyms}}
              {{#each this.synonyms}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "synonym1": "{{{this.name}}}",
                  "synonym2": "",
                  "category": "{{../this.category}}",
                  "orgOwner": "{{../this.orgOwner}}",
                  "indOwner": "{{../this.indivOwner}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "synonym1": "",
                "synonym2": "",
                "category": "{{this.category}}",
                "orgOwner": "{{this.orgOwner}}",
                "indOwner": "{{this.indivOwner}}"
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        

    <script id="dataobjectattribute-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#each this.attributes}}
              {{#if this.synonyms}}
                {{#each this.synonyms}}
                  {
                    "id": "{{../this.id}}",
                    "doName": "{{../../this.name}}",
                    "attName": "{{{../this.name}}}",
                    "description": "{{#escaper ../this.description}}{{/escaper}}",
                    "synonym1": "{{{this.name}}}",
                    "synonym2": "",
                    "doTypeObj": "{{../this.typeObject}}",
                    "doTypePrim": "{{../this.typePrimitive}}",
                    "cardinality": "{{../this.cardinality}}"
                  },
                {{/each}}
              {{else}}
                {
                  "id": "{{this.id}}",
                  "doName": "{{{this.name}}}",
                  "attName": "{{{this.name}}}",
                  "description": "{{#escaper this.description}}{{/escaper}}",
                  "synonym1": "",
                  "synonym2": "",
                  "doTypeObj": "{{this.typeObject}}",
                  "doTypePrim": "{{this.typePrimitive}}",
                  "cardinality": "{{this.cardinality}}"
                },
              {{/if}}
            {{/each}}
          {{/each}}
        ]
    </script>
        
    <script id="dataobjectinherit-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.children}}
              {{#each this.children}}
                {
                  "parent": "{{{../this.name}}}",
                  "child": "{{{this.name}}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="dataobject-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.synonyms}}
              {{#each this.synonyms}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "synonym1": "{{{this.name}}}",
                  "synonym2": "",
                  "parentDataSubj": "",
                  "dataCategory": "{{../this.category}}",
                  "abstract": "{{../this.isAbstract}}"
                },
              {{/each}}
            {{/if}}
          {{/each}}
          {{#each this}}
            {{#if this.parents}}
              {{#each this.parents}}
                {
                  "id": "{{../this.id}}",
                  "name": "{{{../this.name}}}",
                  "description": "{{#escaper ../this.description}}{{/escaper}}",
                  "synonym1": "",
                  "synonym2": "",
                  "parentDataSubj": "{{{this.name}}}",
                  "dataCategory": "{{../this.category}}",
                  "abstract": "{{../this.isAbstract}}"
                },
              {{/each}}
            {{else}}
              {
                "id": "{{this.id}}",
                "name": "{{{this.name}}}",
                "description": "{{#escaper this.description}}{{/escaper}}",
                "synonym1": "",
                "synonym2": "",
                "parentDataSubj": "",
                "dataCategory": "{{this.category}}",
                "abstract": "{{this.isAbstract}}"
              },
            {{/if}}
          {{/each}}
        ]
    </script>

    <script id="appdependency-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.info}}
              {{#each this.info}}
                {
                  "source": "{{../this.source}}",
                  "target": "{{../this.target}}",
                  "info": "{{{this.name}}}",
                  "acquisition": "{{../this.acquisition}}",
                  "frequency": "{{../this.frequency.0.name}}"
                },
              {{/each}}
            {{else}}
              { 
                "source": "{{this.source}}",
                "target": "{{this.target}}",
                "info": "",
                "acquisition": "{{this.acquisition}}",
                "frequency": "{{this.frequency.0.name}}"
              },
            {{/if}}
          {{/each}}
        ]
    </script>
        
    <script id="apptotechprod-name" type="text/x-handlebars-template">
        [
          {{#each this}}
            {{#if this.supportingTech}}
              {{#each this.supportingTech}}
                {{#if @last}}
                {{else}}
                  {
                    "application": "{{../this.application}}",
                    "environment": "{{this.environmentName}}",
                    "fromTechProd": "{{this.fromTechProduct}}",
                    "fromTechComp": "{{this.fromTechComponent}}",
                    "toTechProd": "{{this.toTechProduct}}",
                    "toTechComp": "{{this.toTechComponent}}"
                  },
                {{/if}}
              {{/each}}
            {{/if}}
          {{/each}}
        ]
    </script>
        
</xsl:template>
</xsl:stylesheet>