<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 
<xsl:template name="excelImportTemplates">
    <script id="busdomain-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",	
                    "className": "Business_Domain",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.contained_business_domains}}
                    ,"contained_business_domains": 
                    {{#isArray this.contained_business_domains}}
                        [
                            {{#each this.contained_business_domains}}
                            {
                                "className": "Business_Domain",
                                "name": "{{{this.name}}}",
                                "UPDATE_OBJECT": true
                            }{{#unless @last}},{{/unless}}
                            {{/each}}
                        ]
                    {{else}}
                        [
                            {
                                "className": "Business_Domain",
                                "name": "{{{this.contained_business_domains}}}",
                                "UPDATE_OBJECT": true
                            }
                        ]
                    {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>	
    <script id="site-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Site",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.site_geographic_location}}
                    ,"site_geographic_location": 
                            {
                                "className": "Geographic_Region",
                                "name": "{{{this.site_geographic_location}}}"
                            }
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>	
    <script id="buscap-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Business_Capability",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.supports_business_capabilities}}
                    ,"supports_business_capabilities":
                    {{#isArray this.supports_business_capabilities}}
                    [
                        {{#each this.supports_business_capabilities}}
                        {
                            "className": "Business_Capability",
                            "name": "{{{this.name}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                        [
                            {
                                "className": "Business_Capability",
                                "name": "{{{this.supports_business_capabilities}}}"
                            }
                        ]
                    {{/isArray}}
                    {{/if}}
                    {{#if this.root_capability}}
                        ,"is_root": true,
                        "element_classified_by": [
                                { 
                                    "name": "{{{this.name}}}",
                                    "className": "Taxonomy_Term"
                                }
                            ]
                    {{/if}}
                    {{#if this.business_capability_index}}
                    ,"business_capability_index":{{{this.business_capability_index}}}
                    {{/if}}
                    {{#if this.business_capability_level}}
                    ,"business_capability_level":"{{{this.business_capability_level}}}"
                    {{/if}}
                    {{#if this.belongs_to_business_domains}} 
                    ,"belongs_to_business_domains":
                    {{#isArray this.belongs_to_business_domains}}
                        [
                            {{#each this.belongs_to_business_domains}}
                            {
                                "className": "Business_Domain",
                                "name": "{{{this.name}}}"
                            }{{#unless @last}},{{/unless}}
                            {{/each}}
                        ]
                    {{else}}
                        [
                            {
                                "className": "Business_Domain",
                                "name": "{{{this.belongs_to_business_domains}}}"
                            }
                        ]
                    {{/isArray}} 
         
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>		
    <script id="busproc-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Business_Process",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.realises_business_capability}}
                    ,"realises_business_capability":
                    {{#isArray this.realises_business_capability}}
                    [
                        {{#each this.realises_business_capability}}
                        {
                            "className": "Business_Capability",
                            "name": "{{{this}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Business_Capability",
                                    "name": "{{{this.realises_business_capability}}}",
                                    "this2":"{{this}}"
                                }
                            ]
                        {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
    </script>	
    <script id="busprocfamily-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}{{this.ref}}",
                    "className": "Business_Process_Family",
                    "name": "{{{this.business_process_family}}}{{{this.family_name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.bpf_contains_busproctypes}}
                    ,"bpf_contains_busproctypes":
                    {{#isArray this.bpf_contains_busproctypes}}
                    [
                        {{#each this.bpf_contains_busproctypes}}
                        {
                            "className": "Business_Process",
                            "name": "{{{this.name}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Business_Process",
                                    "name": "{{{this.bpf_contains_busproctypes}}}"
                                }
                            ]
                        {{/isArray}}
                    {{/if}}
                    }{{#unless @last}},{{/unless}}
                {{/each}}]
    </script>	
    <script id="organisations-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Group_Actor",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.external_to_enterprise}}
                    ,"external_to_enterprise":{{this.external_to_enterprise}}
                    {{/if}}
                    {{#if this.is_member_of_actor}}
                    ,"is_member_of_actor": 
                    {{#isArray this.is_member_of_actor}}
                    [
                        {{#each this.is_member_of_actor}}
                        {
                            "className": "Group_Actor",
                            "name": "{{{this.name}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Group_Actor",
                                    "name": "{{{this.is_member_of_actor}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>
    <script id="organisations2site-template" class="handlebars-template" type="text/x-handlebars-template">
            [
                {{#each this}}
                {
                    "className": "Group_Actor",
                    "name": "{{{this.name}}}",
                    "actor_based_at_site":
                    {{#isArray this.site}}
                    [
                        {{#each this.site}}
                        {
                            "className": "Site",
                            "name": "{{{this.site}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Site",
                                    "name": "{{{this.site}}}"
                                }
                            ]
                    {{/isArray}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>	
	
    <script id="appcapability-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Application_Capability",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.mapped_to_business_domain}}
                    ,"mapped_to_business_domain": 
                    {{#isArray this.is_member_of_actor}}
                    [
                        {{#each this.is_member_of_actor}}
                        {
                            "className": "Business_Domain",
                            "name": "{{{this.mapped_to_business_domain}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Business_Domain",
                                    "name": "{{{this.mapped_to_business_domain}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                    {{#if this.contained_in_application_capability}}
                    ,"contained_in_application_capability": 
                    {{#isArray this.contained_in_application_capability}}
                    [
                        {{#each this.contained_in_application_capability}}
                        {
                            "className": "Application_Capability",
                            "name": "{{{this.contained_in_application_capability}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Application_Capability",
                                    "name": "{{{this.contained_in_application_capability}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                    {{#if this.app_cap_supports_bus_cap}}
                    ,"app_cap_supports_bus_cap": 
                    {{#isArray this.app_cap_supports_bus_cap}}
                    [
                        {{#each this.app_cap_supports_bus_cap}}
                        {
                            "className": "Business_Capability",
                            "name": "{{{this.app_cap_supports_bus_cap}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Business_Capability",
                                    "name": "{{{this.app_cap_supports_bus_cap}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                    {{#if this.element_classified_by}} 
                    ,"element_classified_by": 
                    {{#isArray this.element_classified_by}}
                    [
                        {{#each this.element_classified_by}}
                        {
                            "className": "Taxonomy_Term",
                            "name": "{{{this}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Taxonomy_Term",
                                    "name": "{{{this.element_classified_by}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>	
    <script id="appservices-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Application_Service",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
    </script>
    <script id="appservicetocapability-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                { 
                    "className": "Application_Capability",
                    "name": "{{{this.name}}}"
                    {{#if this.realised_by_application_services}}
                    ,"realised_by_application_services": 
                    {{#isArray this.realised_by_application_services}}
                    [
                        {{#each this.realised_by_application_services}}
                        {
                            "className": "Application_Service",
                            "name": "{{{this.name}}}"
                        }{{#unless @last}},{{/unless}}
                        {{/each}}
                    ]
                    {{else}}
                            [
                                {
                                    "className": "Application_Service",
                                    "name": "{{{this.realised_by_application_services}}}"
                                }
                            ]
                    {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>
    <script id="application-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Composite_Application_Provider",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.ap_codebase_status}}
                    ,"ap_codebase_status": 
                            {
                                "className": "Codebase_Status",
                                "name": "{{{this.ap_codebase_status}}}"
                            }
                    {{/if}}
                    {{#if this.ap_delivery_model}}
                    ,"ap_delivery_model": 
                            {
                                "className": "Application_Delivery_Model",
                                "name": "{{{this.ap_delivery_model}}}"
                            }
                    {{/if}}
                    {{#if this.lifecycle_status_application_provider}}
                    ,"lifecycle_status_application_provider": 
                            {
                                "className": "Lifecycle_Status",
                                "name": "{{{this.lifecycle_status_application_provider}}}"
                            }
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>
    <script id="appservicetoapps-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "className": "Composite_Application_Provider",
                    "name": "{{{this.name}}}",
                    "provides_application_services": [
                    {
                        "name": "{{{this.name}}} as {{{this.application_service}}}",
                        "className": "Application_Provider_Role",
                        "implementing_application_service": {
                            "name": "{{{this.application_service}}}",
                            "className": "Application_Service"
                        }
                    }]
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>
    <script id="apptouserorgs-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "className": "Composite_Application_Provider",
                    "name": "{{{this.name}}}",
                    "stakeholders": [
                    { 
                        "className": "ACTOR_TO_ROLE_RELATION",
                        "name": "{{{this.organisation}}} as Application Organisation User",
                        "act_to_role_from_actor": { 
                            "name": "{{{this.organisation}}}",
                            "className": "Group_Actor"
                        },
                        "act_to_role_to_role":{
                            "name": "Application Organisation User",
                            "className": "Group_Business_Role"
                        }
                    }]
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
    </script>
    <script id="businessprocesstoappserv-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "name": "{{this.application_service}}::supports::{{this.business_process}}",
                    "relation_name": "{{this.application_service}}::supports::{{this.business_process}}",
                    "className": "APP_SVC_TO_BUS_RELATION",
                    "appsvc_to_bus_from_appsvc": { 
                        "name": "{{{this.application_service}}}",
                        "className": "Application_Service"
                    },
                    "appsvc_to_bus_to_busproc": { 
                        "name": "{{this.business_process}}",
                        "className": "Business_Process"
                    }
                    {{#if this.criticality_of_application_service}}
                    ,"app_to_process_business_criticality":{ 
                        "name": "{{{this.criticality_of_application_service}}}",
                        "className": "Business_Criticality"
                    }
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
            
    </script>
    <script id="physicalprocesstoappandserv-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "className": "Physical_Process",
                    "name": "{{{this.performing_organisation}}} performing {{{this.business_process}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    ,"implements_business_process": { 
                        "name": "{{{this.business_process}}}",
                        "className": "Business_Process"
                    },
                    "process_performed_by_actor_role": { 
                        "name": "{{{this.performing_organisation}}}",
                        "className": "Group_Actor"
                    },
                    "phys_bp_supported_by_app_pro": [
                        { 
                            "name": "{{application_and_service_used}}::supports::{{{this.performing_organisation}}} performing {{{this.business_process}}}",
                            "className": "APP_PRO_TO_PHYS_BUS_RELATION",
                            "apppro_to_physbus_from_appprorole": { 
                                "name": "{{application_and_service_used}}",
                                "className": "Application_Provider_Role"
                            }
                        }
                    ]
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
    </script>
<script id="physicalprocesstoapp-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "className": "Physical_Process",
                    "name": "{{{this.performing_organisation}}} performing {{{this.business_process}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    ,"implements_business_process": { 
                        "name": "{{{this.business_process}}}",
                        "className": "Business_Process"
                    },
                    "process_performed_by_actor_role": { 
                        "name": "{{{this.performing_organisation}}}",
                        "className": "Group_Actor"
                    },
                    "phys_bp_supported_by_app_pro": [
                        { 
                            "name": "{{application}}::supports::{{{this.performing_organisation}}} performing {{{this.business_process}}}",
                            "className": "APP_PRO_TO_PHYS_BUS_RELATION",
                            "apppro_to_physbus_from_apppro": { 
                                "name": "{{application}}",
                                "className": "Composite_Application_Provider"
                            }
                        }
                    ]
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
</script>
<script id="informationexchanged-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
            "id":"{{this.id}}",
            "className": "Information_Representation",
            "name": "{{{this.name}}}"
            {{#if this.description}}
            ,"description": "{{#escaper this.description}}{{/escaper}}"
            {{/if}}
        }{{#unless @last}},{{/unless}}
        {{/each}}
    ]

</script>
<script id="appdependencies-template" class="handlebars-template" type="text/x-handlebars-template">
    [
    {{#each this}}
    {
    "name": "{{{this.name}}}",
    "className": "Composite_Application_Provider",
    "ap_static_architecture": {
        "className": "Static_Application_Provider_Architecture",
        "name": "Static Architecture of::{{{this.name}}}",
        "static_app_provider_architecture_elements": [
            {
                "className": "Static_Application_Provider_Usage",
                "name": "{{{this.name}}}::in::Static Architecture of::{{{this.name}}}",
                "static_usage_of_app_provider": {
                    "name": "{{{this.name}}}",
                    "className": "Composite_Application_Provider"
                }
            },
            {
                "className": "Static_Application_Provider_Usage",
                "name": "{{{this.source_application}}}::in::Static Architecture of::{{{this.name}}}",
                "static_usage_of_app_provider": {
                    "name": "{{{this.source_application}}}",
                    "className": "Composite_Application_Provider"
                }
            }
        ],
        "uses_provider": [
            {
                "className": ":APU-TO-APU-STATIC-RELATION",
                "name": "Static Architecture of::{{{this.name}}}: Relation from {{{this.name}}}::in::Static Architecture of::{{{this.name}}} to {{{this.source_application}}}::in::Static Architecture of::{{{this.name}}}",
                ":FROM": {
                    "className": "Static_Application_Provider_Usage",
                    "name": "{{{this.name}}}::in::Static Architecture of::{{{this.name}}}"
                },
                ":TO": {
                    "className": "Static_Application_Provider_Usage",
                    "name": "{{{this.source_application}}}::in::Static Architecture of::{{{this.name}}}"
                },
                "apu_to_apu_relation_inforeps": [
                    {
                        "className": "APP_PRO_TO_INFOREP_EXCHANGE_RELATION",
                        "name": "Static Architecture of::{{{this.name}}}: Relation from {{{this.name}}}::in::Static Architecture of::{{{this.name}}} to {{{this.source_application}}}::in::Static Architecture of::{{{this.name}}} exchanging {{{this.information_exchanged}}} managed by {{{this.source_application}}}",
                        "atire_app_pro_to_inforep": {
                            "className": "APP_PRO_TO_INFOREP_RELATION",
                            "name": "{{{this.information_exchanged}}} managed by {{{this.source_application}}}",
                            "app_pro_to_inforep_from_app": {
                                "name": "{{{this.source_application}}}",
                                "className": "Composite_Application_Provider"
                            },
                            "app_pro_to_inforep_to_inforep": {
                                "className": "Information_Representation",
                                "name": "{{{this.information_exchanged}}}"
                            }
                        },
                        "atire_acquisition_method": {
                            "className": "Data_Acquisition_Method",
                            "name": "{{{this.acquisition_method}}}"
                        },
                        "atire_service_quals": [
                            {
                                "className": "Information_Service_Quality_Value",
                                "name": "Timeliness - {{{this.frequency}}}"
                            }
                        ]
                    }
                ]
            }
        ]
    }
    }{{#unless @last}},{{/unless}}{{/each}}]
</script>
<script id="servers-template" class="handlebars-template" type="text/x-handlebars-template">
        [
                {{#each this}}
                {
                    "id":"{{this.id}}",
                    "className": "Technology_Node",
                    "name": "{{{this.name}}}"
                    {{#if this.description}}
                    ,"description": "{{#escaper this.description}}{{/escaper}}"
                    {{/if}}
                    {{#if this.technology_deployment_located_at}} 
                    ,"technology_deployment_located_at": { 
                    "name": "{{this.hosted_in}}",
                    "className": "Site"
                    }
                    {{/if}}
                    {{#if this.ip_address}}
                    ,"technology_node_attributes":
                    {{#isArray this.ip_address}}
                        [
                            {{#each this.ip_address}}
                            {
                                "className": "Attribute_Value",
                                "name": "IP Address = {{{this.name}}}",
                                "attribute_value_of": { 
                                    "name": "IP Address",
                                    "className": "Attribute"
                                },
                                "attribute_value": "{{{this.name}}}"
                            }{{#unless @last}},{{/unless}}
                            {{/each}}
                        ]
                    {{else}}
                        [
                            {
                                "className": "Attribute_Value",
                                "name": "IP Address = {{{this.ip_address}}}",
                                "attribute_value_of": { 
                                    "name": "IP Address",
                                    "className": "Attribute"
                                },
                                "attribute_value": "{{{this.ip_address}}}"
                            }
                        ]
                    {{/isArray}}
                    {{/if}}
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]

    </script>
<script id="apptoserver-template" class="handlebars-template" type="text/x-handlebars-template">
    [{{#each this}}
    { 
    "name": "{{this.server}}",
    "className": "Technology_Node",
    "contained_technology_instances": [
    { 
        "name": "{{this.environment}} - {{this.environment}}::on::{{this.server}}::",
        "className": "Application_Software_Instance",
        "instance_of_application_deployment": { 
            "name": "{{this.application}} - {{this.environment}}",
            "className": "Application_Deployment",
            "application_deployment_label": "{{this.application}} Deployment  - {{this.environment}}",
            "application_provider_deployed": { 
                "name": "{{this.application}}",
                "className": "Composite_Application_Provider"
            },
            "application_deployment_role": { 
                "name": "{{this.environment}}",
                "className": "Deployment_Role",
                "enumeration_value": "{{this.environment}}"
            }
        }
    }
    ]
    }{{#unless @last}},{{/unless}}
    {{/each}}]
</script>
<script id="technologydomains-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
            "id":"{{this.id}}",
            "className": "Technology_Domain",
            "name": "{{{this.name}}}"
            {{#if this.description}}
            ,"description": "{{#escaper this.description}}{{/escaper}}"
            {{/if}}
            {{#if this.position}}
            ,"element_classified_by":[ 
                    {
                        "className": "Taxonomy_Term",
                        "name": "{{{this.position}}}"
                    }
                    ]
            {{/if}}
        }{{#unless @last}},{{/unless}}
        {{/each}}
    ]

</script>
<script id="technologycaps-template" class="handlebars-template" type="text/x-handlebars-template">
    [
    {{#each this}}
    {
    "id":"{{this.id}}",
    "className": "Technology_Capability",
    "name": "{{{this.name}}}"
    {{#if this.description}}
    ,"description": "{{#escaper this.description}}{{/escaper}}"
    {{/if}}
    {{#if this.parent_technology_domain}}
    ,"belongs_to_technology_domain": 
            {
                "className": "Technology_Domain",
                "name": "{{{this.parent_technology_domain}}}"
            }
    {{/if}}
    }{{#unless @last}},{{/unless}}
    {{/each}}
    ]
</script>
<script id="technologycomps-template" class="handlebars-template" type="text/x-handlebars-template">
 [
    {{#each this}}
    {
        "id":"{{this.id}}",
        "className": "Technology_Component",
        "name": "{{{this.name}}}"
        {{#if this.description}}
        ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
        {{#if this.realisation_of_technology_capability}} 
        ,"realisation_of_technology_capability":
        {{#isArray this.realisation_of_technology_capability}}
                        [
                            {{#each this.realisation_of_technology_capability}}
                            {
                                "className": "Technology_Capability",
                                "name": "{{{this}}}"
                            }{{#unless @last}},{{/unless}}
                            {{/each}}
                        ]
                    {{else}}
                        [
                            {
                                "className": "Technology_Capability",
                                "name": "{{{this.realisation_of_technology_capability}}}"
                            }
                        ]
        {{/isArray}}
        {{/if}}
    }{{#unless @last}},{{/unless}}
    {{/each}}
 ]

</script>
<script id="technologysuppliers-template" class="handlebars-template" type="text/x-handlebars-template">
 [
    {{#each this}}
    {
        "id":"{{this.id}}",
        "className": "Supplier",
        "name": "{{{this.name}}}"
        {{#if this.description}}
        ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
    }{{#unless @last}},{{/unless}}
    {{/each}}
 ]
</script>
<script id="technologyfamilies-template" class="handlebars-template" type="text/x-handlebars-template">
  [
    {{#each this}}
    {
        "id":"{{this.id}}",
        "className": "Technology_Product_Family",
        "name": "{{{this.name}}}{{{this.family_name}}}"
        {{#if this.description}}
        ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
    }{{#unless @last}},{{/unless}}
    {{/each}}
 ]
</script>
<script id="techprodstouserorgs-template" class="handlebars-template" type="text/x-handlebars-template">
 [
    {{#each this}}
    { 
        "className": "Technology_Product",
        "name": "{{{this.name}}}"
        {{#if this.description}}
        ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
        ,"stakeholders": [
                    { 
                        "className": "ACTOR_TO_ROLE_RELATION",
                        "name": "{{{this.organisation}}} as Technology Organisation User",
                        "act_to_role_from_actor": { 
                            "name": "{{{this.organisation}}}",
                            "className": "Group_Actor"
                        },
                        "act_to_role_to_role":{
                            "name": "Technology Organisation User",
                            "className": "Group_Business_Role"
                        }
                    }]
    }{{#unless @last}},{{/unless}}
    {{/each}}
 ]
</script>
<script id="apptotechproducts-template" class="handlebars-template" type="text/x-handlebars-template">
    [
    {{#each this}}
    { 
        "className": "Composite_Application_Provider",
        "name": "{{{this.name}}},
        "deployments_of_application_provider:[
        {{#each this.deployments_of_application_provider}}
                    { 
                    "name": "Production - Production",
                    "className": "Application_Deployment",
                    "application_deployment_label": "Production",
                    "application_deployment_technical_arch": { 
                        "name": "APP1 TPB",
                        "className": "Technology_Product_Build",
                        "technology_provider_architecture": {
                            "id": "store_315_Class10152",
                            "name": "APP1 TPB::Product_Architecture",
                            "className": "Technology_Build_Architecture",
                            "describes_technology_provider": {
                                "id": "store_315_Class10151",
                                "name": "APP1 TPB",
                                "className": "Technology_Product_Build"
                            },
                            "contained_architecture_components": [
                                {
                                    "id": "store_315_Class10153",
                                    "name": "tp1::as::Tcomp1::in::APP1 TPB::Product_Architecture",
                                    "className": "Technology_Provider_Usage"
                                }
                            ]
                        }
                    },
                    "application_deployment_role": {
                        "name": "Production",
                        "className": "Deployment_Role",
                        "enumeration_value": "Production"
                    }
                }
            {{/each}}]
    }
    {{/each}}
]
</script>
 <script id="techproducts-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
        "id": "{{{this.id}}}",
        "name": "{{this.name}}",
        "className": "Technology_Product",
        "product_label": "{{this.supplier}}::{{this.name}}"
        {{#if this.supplier}}
        ,"supplier_technology_product": { 
            "name": "{{this.supplier}}",
            "className": "Supplier"
        }
        {{/if}}
        {{#if this.implements_technology_components}}
        ,"implements_technology_components": [
            {{#isArray this.implements_technology_components}}
                        
                                {{#each this.implements_technology_components}}
                                { 
                                    "name": "{{../this.name}}::as::{{this.name}}",
                                    "className": "Technology_Product_Role",
                                    "implementing_technology_component": {
                                        "name": "{{this.name}}",
                                        "className": "Technology_Component"
                                    },
                                    "role_for_technology_provider": {
                                        "name": "{{../this.name}}",
                                        "className": "Technology_Product"
                                    },
                                    "strategic_lifecycle_status": {
                                        "name": "{{this.adoption}}",
                                        "className": "Lifecycle_Status",
                                        "enumeration_value": "{{this.adoption}}"
                                    }
                                    {{#if this.tpr_has_standard_specs}}
                                    ,"tpr_has_standard_specs": [
                                        { 
                                            "name": "{{this.tpr_has_standard_specs.compliance}}:{{this.name}} Standard - {{../name}}",
                                            "className": "Technology_Provider_Standard_Specification",
                                            "sm_standard_strength": { 
                                                "name": "{{this.tpr_has_standard_specs.compliance}}",
                                                "className": "Standard_Strength",
                                                "enumeration_value": "{{this.tpr_has_standard_specs.compliance}}"
                                            }
                                        } ]
                                    {{/if}}
                                
                                }{{#unless @last}},{{/unless}}
                                {{/each}}
                        {{else}}
                        
            {{/isArray}}
    ]
        {{/if}}
        {{#if this.description}}
            ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
    }
        {{#unless @last}},{{/unless}}
        {{/each}}
    ]

</script>
<script id="datasubjects-template" class="handlebars-template" type="text/x-handlebars-template">
[
    {{#each this}}
    {
        "id":"{{this.id}}",
        "className": "Data_Subject",
        "name": "{{{this.name}}}"
        {{#if this.description}}
        ,"description": "{{#escaper this.description}}{{/escaper}}"
        {{/if}}
        {{#if this.data_category}}
        ,"data_category": 
                {
                    "className": "Data_Category",
                    "name": "{{{this.data_category}}}",
                    "enumeration_value":"{{{this.data_category}}}"
                }
        {{/if}}

        {{#if this.synonyms}}
        ,"synonyms": [
        {{#isArray this.synonyms}}
            {{#each this.synonyms}}
            
                { 
                    "name": "{{this}}",
                    "className": "Synonym"
                }
            {{#unless @last}},{{/unless}}
            {{/each}}
        
        {{else}}
        
            {
                "className": "Synonym",
                "name": "{{{this.synonyms}}}"
            }
        
        {{/isArray}}
       
        ]
        {{/if}}
        ,"stakeholders": [
            {{#if this.individual_owner}}
                    { 
                        "className": "ACTOR_TO_ROLE_RELATION",
                        "name": "{{{this.individual_owner}}} as Data Subject Individual Owner",
                        "act_to_role_from_actor": { 
                            "name": "{{{this.individual_owner}}}",
                            "className": "Individual_Actor"
                        },
                        "act_to_role_to_role":{
                            "name": "Data Subject Individual Owner",
                            "className": "Individual_Business_Role"
                        }
                    },
            {{/if}}
            {{#if this.organisation_owner}}
                    { 
                        "className": "ACTOR_TO_ROLE_RELATION",
                        "name": "{{{this.organisation_owner}}} as Data Subject Organisational Owner",
                        "act_to_role_from_actor": { 
                            "name": "{{{this.organisation_owner}}}",
                            "className": "Group_Actor"
                        },
                        "act_to_role_to_role":{
                            "name": "Data Subject Organisational Owner",
                            "className": "Group_Business_Role"
                        }
                    }
            {{/if}}]
    }
    {{#unless @last}},{{/unless}}
    {{/each}}
]

</script>
<script id="datobjects-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
            "id":"{{this.id}}",
            "className": "Data_Object",
            "name": "{{{this.name}}}"
            {{#if this.description}}
            ,"description": "{{#escaper this.description}}{{/escaper}}"
            {{/if}}
            {{#if this.data_category}}
            ,"data_category": 
                    {
                        "className": "Data_Category",
                        "name": "{{{this.data_category}}}",
                        "enumeration_value":"{{{this.data_category}}}"
                    }
            {{/if}}
            {{#if this.parent_data_subject}}
            ,"defined_by_data_subject":
            {{#isArray this.defined_by_data_subject}}
                            [
                                {{#each this.parent_data_subject}}
                                {
                                    "className": "Data_Subject",
                                    "name": "{{{this}}}"
                                }{{#unless @last}},{{/unless}}
                                {{/each}}
                            ]
                        {{else}}
                            [
                                {
                                    "className": "Data_Subject",
                                    "name": "{{{this.parent_data_subject}}}"
                                }
                            ]
                        {{/isArray}}
            {{/if}}
            {{#if this.is_abstract}}
            ,"data_object_is_abstract":{{this.is_abstract}}
            {{/if}}
            
        {{#if this.synonyms}}
        ,"synonyms": [
        {{#isArray this.synonyms}}
            {{#each this.synonyms}}
            
                { 
                    "name": "{{this}}",
                    "className": "Synonym"
                }
            {{#unless @last}},{{/unless}}
            {{/each}}
        
        {{else}}
        
            {
                "className": "Synonym",
                "name": "{{{this.synonyms}}}"
            }
        
        {{/isArray}}
       
        ]
        {{/if}}
            ,"stakeholders": [
                {{#if this.data_standard_owner}}
                        { 
                            "className": "ACTOR_TO_ROLE_RELATION",
                            "name": "{{{this.data_standard_owner}}} as Data ???? Owner",
                            "act_to_role_from_actor": { 
                                "name": "{{{this.data_standard_owner}}}",
                                "className": "???_Actor"
                            },
                            "act_to_role_to_role":{
                                "name": "Data ??? Owner",
                                "className": "???_Business_Role"
                            }
                        }
                {{/if}}
                {{#if this.organisation_data_owner}}
                        ,{ 
                            "className": "ACTOR_TO_ROLE_RELATION",
                            "name": "{{{this.organisation_data_owner}}} as ?????",
                            "act_to_role_from_actor": { 
                                "name": "{{{this.organisation_data_owner}}}",
                                "className": "Group_Actor"
                            },
                            "act_to_role_to_role":{
                                "name": "Data ???  Owner",
                                "className": "Group_Business_Role"
                            }
                        }
                {{/if}}
                {{#if this.data_steward}}
                        ,{ 
                            "className": "ACTOR_TO_ROLE_RELATION",
                            "name": "{{{this.data_steward}}} as ?????",
                            "act_to_role_from_actor": { 
                                "name": "{{{this.data_steward}}}",
                                "className": "Individual_Actor"
                            },
                            "act_to_role_to_role":{
                                "name": "Data Steward",
                                "className": "Individual_Business_Role"
                            }
                        }
                {{/if}}
                ]
        }
        {{#unless @last}},{{/unless}}
        {{/each}}
    ]
</script>
<script id="dataobjinheritance-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
            "className": "Data_Object",
            "name": "{{{this.name}}}",
            "data_object_specialisations": 
            {{#isArray this.child_data_object}}
            [
                {{#each this.child_data_object}}
                {
                    "className": "Data_Object",
                    "name": "{{{this}}}"
                }{{#unless @last}},{{/unless}}
                {{/each}}
            ]
            {{else}}
            [
                {
                    "className": "Data_Object",
                    "name": "{{{this.child_data_object}}}"
                }
            ]
        {{/isArray}}
        }{{#unless @last}},{{/unless}}
        {{/each}}
    ]
</script>
<script id="dataobjattributes-template" class="handlebars-template" type="text/x-handlebars-template">
    [
        {{#each this}}
        {
            "id":"{{this.id}}",
            "className": "Data_Object_Attribute",
            "name": "{{{this.data_object_name}}} - {{{this.name}}}",
            "data_attribute_label": "{{{this.name}}}",
            "belongs_to_data_object": {
                    "name": "{{this.data_object_name}}",
                    "className": "Data_Object"
                },
            {{#if this.synonyms}}
                ,"synonyms": [
                {{#isArray this.synonyms}}
                    {{#each this.synonyms}}
                    
                        { 
                            "name": "{{this}}",
                            "className": "Synonym"
                        }
                    {{#unless @last}},{{/unless}}
                    {{/each}}
                
                {{else}}
                
                    {
                        "className": "Data_Subject",
                        "name": "{{{this.synonyms}}}"
                    }
                
                {{/isArray}}
               
                ]
            {{/if}}
             
            "type_for_data_attribute": {
            {{#if this.data_type}}
                "name": "{{this.data_type}}",
                "className": "Data_Object"
            {{else}}
                "name": "{{this.primitive}}",
                "className": "Primitive_Data_Object"
            {{/if}}
            }{{#if this.data_attribute_cardinality}},
            "data_attribute_cardinality": {
                "name": "{{ this.data_attribute_cardinality}}",
                "className": "Data_Attribute_Cardinality", 
            }
            {{/if}}
            {{#if this.description}}
            ,"description": "{{#escaper this.description}}{{/escaper}}"
            {{/if}}
        }{{#unless @last}},{{/unless}}
        {{/each}}
    ]

</script>
</xsl:template>
</xsl:stylesheet>