<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">

<xsl:template name="RenderPanelFunctions">
 
<script id="appSlidePanel-template" type="text/x-handlebars-template"> 
    <div class="row">
            <div class="col-sm-8">
                <h4 class="text-normal strong inline-block right-30" >{{#essRenderInstanceLinkMenuOnlyLight this 'Composite_Application_Provider'}}{{/essRenderInstanceLinkMenuOnlyLight}}</h4>
                                </div>
            <div class="col-sm-4">
                <div class="text-right"> 
                    <i class="fa fa-times closePanelButton left-30"></i>
                </div>
                <div class="clearfix"/>
            </div>
        </div>
        
        <div class="row">
            <div class="col-sm-12">
                <ul class="nav nav-tabs ess-small-tabs">
                    <li class="active"><a data-toggle="tab" href="#summary">Summary</a></li>
                    {{#if capabilitiesSupporting}}
                    <li><a data-toggle="tab" href="#capabilities"><xsl:value-of select="eas:i18n('Capabilities')"/><span class="badge dark">{{capabilitiesSupporting}}</span></a></li>
                    {{/if}}
                    {{#if processesSupporting}}
                    <li><a data-toggle="tab" href="#processes"><xsl:value-of select="eas:i18n('Processes')"/><span class="badge dark">{{processesSupporting}}</span></a></li>
                    {{/if}} 
                    <li><a data-toggle="tab" href="#integrations"><xsl:value-of select="eas:i18n('Integrations')"/><span class="badge dark">{{totalIntegrations}}</span></a></li>  
                    {{#if allServices}}
                    <li><a data-toggle="tab" href="#services"><xsl:value-of select="eas:i18n('Services')"/></a></li>
                    {{/if}}
                    <li></li>
                </ul>
                
        
                <div class="tab-content">
                    <div id="summary" class="tab-pane fade in active">
                        <div>
                            <strong><xsl:value-of select="eas:i18n('Description')"/></strong>
                            <br/>
                            {{description}}    
                        </div>
                        <div class="ess-tags-wrapper top-10">
                            <div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#2EB8BF;color:#ffffff</xsl:attribute>
                                <i class="fa fa-code right-5"/>{{codebase}}</div>
                            <div class="ess-tag ess-tag-default">
                                    <xsl:attribute name="style">background-color:#24A1B7;color:#ffffff</xsl:attribute>
                                <i class="fa fa-desktop right-5"/>{{delivery}}</div>
                            <div class="ess-tag ess-tag-default">
                                    <xsl:attribute name="style">background-color:#A884E9;color:#ffffff</xsl:attribute>
                                    <i class="fa fa-users right-5"/>{{processList.length}} <xsl:value-of select="eas:i18n('Processes Supported')"/></div>
                            <div class="ess-tag ess-tag-default">
                                    <xsl:attribute name="style">background-color:#6849D0;color:#ffffff</xsl:attribute>
                                    <i class="fa fa-exchange right-5"/>{{totalIntegrations}} <xsl:value-of select="eas:i18n('Integrations')"/> ({{inI}} in / {{outI}} out)</div>
                        </div>
                    </div>
                    <div id="capabilities" class="tab-pane fade">
                        <p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Capabilities')"/>:</p>
                        <div>
                        {{#if capList}} 
                        {{#each capList}}
                            <div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#f5ffa1;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Capability'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                        {{/each}}
                        {{else}}
                            <p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
                        {{/if}}
                        </div>
                    </div> 
                    <div id="processes" class="tab-pane fade">
                        <p class="strong"><xsl:value-of select="eas:i18n('This application supports the following Business Processes, supporting')"/> {{processList.length}} <xsl:value-of select="eas:i18n('processes')"/>:</p>
                        <div>
                        {{#if processes}}
                        {{#each processList}}
                            <div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#dccdf6;color:#000000</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Business_Process'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                        {{/each}} 
                        {{else}}
                            <p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
                        {{/if}}
                        </div>
                    </div>
                    <div id="services" class="tab-pane fade">
                        <p class="strong"><xsl:value-of select="eas:i18n('This application provide the following services, i.e. could be used')"/>:</p>
                        <div>
                        {{#if allServices}}
                        {{#each allServices}}
                            <div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#c1d0db;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                        {{/each}} 
                        {{else}}
                            <p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
                        {{/if}}
                    </div>
                        <p class="strong"><xsl:value-of select="eas:i18n('The following services are actually used in business processes')"/>:</p>
                        <div>
                        {{#if services}}
                        {{#each services}}
                            <div class="ess-tag ess-tag-default"><xsl:attribute name="style">background-color:#73B9EE;color:#ffffff</xsl:attribute>{{#essRenderInstanceLinkMenuOnly this 'Application_Service'}}{{/essRenderInstanceLinkMenuOnly}}</div>
                        {{/each}} 
                        {{else}}
                            <p class="text-muted"><xsl:value-of select="eas:i18n('None Mapped')"/></p>
                        {{/if}}
                        </div>
                    </div>
                    <div id="integrations" class="tab-pane fade">
                    <p class="strong"><xsl:value-of select="eas:i18n('This application has the following integrations')"/>:</p>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="impact bottom-10"><xsl:value-of select="eas:i18n('Inbound')"/></div>
                                {{#each inIList}}
                                <div class="ess-tag bg-lightblue-100">{{name}}</div>
                                {{/each}}
                        </div>
                        <div class="col-md-6">
                            <div class="impact bottom-10"><xsl:value-of select="eas:i18n('Outbound')"/></div>
                                {{#each outIList}}
                                <div class="ess-tag bg-pink-100">{{name}}</div>
                                {{/each}}
                        </div>
                    </div>
                </div>
                    
                </div>
            </div>
        </div>
    </script>
<script>
// these are the classes that your view has that you want pop-up menus for, look under EA Support > Essential Viewer > Menu Mangement > Report Menu, find the menu for you class and add the class and under menuId the menu short Name value 
               var meta=[
				{"classes":["Group_Actor"], "menuId":"grpActorGenMenu"},
				{"classes":["Technology_Product","Technology_Provider"], "menuId":"techProdGenMenu"},
                {"classes":["Application_Provider","Composite_Application_Provider"], "menuId":"appProviderGenMenu"},
                {"classes":["Application_Service","Composite_Application_Service"], "menuId":"appServiceGenMenu"}];

                //******  Hide slide up
                $('.slideUpPanel').hide();

                    $(document).ready(function() {
                        //***** slide up panel handlebars template 
                        var appslidePanelFragment = $("#appSlidePanel-template").html();
                        appslidePanelTemplate = Handlebars.compile(appslidePanelFragment);

                        //*** link pop-up menus for slide up
                        Handlebars.registerHelper('essRenderInstanceLinkMenuOnly', function (instance, type) {
		 
                                let thisMeta = meta.filter((d) => {
                                    return d.classes.includes(type)
                                });
                                
                                instance['meta'] = thisMeta[0]
                            
                                let linkMenuName = essGetMenuName(instance);
                                let instanceLink = instance.name;
                                if (linkMenuName != null) {
                                    let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
                                    let linkClass = 'context-menu-' + linkMenuName;
                                    let linkId = instance.id + 'Link';
                                    instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(237, 237, 237)">' + instance.name + '</a>';

                                    return instanceLink;
                                }
                            });

                        Handlebars.registerHelper('essRenderInstanceLinkMenuOnlyLight', function (instance, type) {
		 
                            let thisMeta = meta.filter((d) => {
                                return d.classes.includes(type)
                            });
                              
                            instance['meta'] = thisMeta[0]
                         
                            let linkMenuName = essGetMenuName(instance);
                            let instanceLink = instance.name;
                            if (linkMenuName != null) {
                                let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
                                let linkClass = 'context-menu-' + linkMenuName;
                                let linkId = instance.id + 'Link';
                                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + ' dark" id="' + linkId + '" style="color:rgb(237, 237, 237)">' + instance.name + '</a>';
            
                                return instanceLink;
                            }
                        });
            
                        const essLinkLanguage = '<xsl:value-of select="$i18n"/>';
                        function essGetMenuName(instance) {
                            let menuName = null;
                            if ((instance != null) &amp;&amp;
                                (instance.meta != null) &amp;&amp;
                                (instance.meta.classes != null)) {
                                menuName = instance.meta.menuId;
                            } else if (instance.classes != null) {
                                menuName = instance.meta.classes;
                            }
                            return menuName;
                        }
                    })


                </script>
	</xsl:template>
	 
</xsl:stylesheet>