<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 
<xsl:param name="targetReportId"/>
<xsl:param name="targetMenuShortName"/> 
<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu']"/>
<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
<xsl:variable name="repYN"><xsl:choose><xsl:when test="$targetReportId"><xsl:value-of select="$targetReportId"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>

	<xsl:template name="RenderHandlebarsUtilityFunctions">
	 
			var reportURL='<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
			var meta=[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>];
			const meta2=meta;
		 //console.log('meta', meta)
		 //console.log('15')
			const essLinkLanguage = '<xsl:value-of select="$i18n"/>';


		    function essGetMenuName(instance) { 
				//console.log('19')
			
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

			   
			function essGetMenuNamebyClass(instance) { 
 
				let menuName = null;
				if(instance.meta?.anchorClass) {
					
					const objectWithMenu = meta2.find(obj => obj.classes.includes(instance.meta.anchorClass));
				 
					if(objectWithMenu.enabled =='true'){
						menuName = objectWithMenu.menuId;	
					}	
				} else if(instance.className) {
	
					const objectWithMenu = meta2.find(obj => obj.classes.includes(instance.className));
				 
				//	console.log('objectWithMenu',objectWithMenu)
					if(objectWithMenu){
						if(objectWithMenu.enabled  &amp;&amp; objectWithMenu.enabled =='true'){
							menuName = objectWithMenu.menuId;
						}else if(objectWithMenu.enabled  &amp;&amp; objectWithMenu.enabled =='false'){
							// do nothing
						}else{
							menuName = objectWithMenu.menuId;
						}
					}
				}
					
				return menuName;
			}

		    Handlebars.registerHelper('essRenderInstanceLinkOnly', function (instance, type) {
				//console.log('55')
		        let targetReport = "<xsl:value-of select="$repYN"/>";
				let linkMenuName = essGetMenuName(instance); 
		        if (targetReport.length &gt; 1) { 
		            let linkURL = reportURL;
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';

		            return instanceLink;
		        } else {
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
		                let linkURL = reportURL;
		                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';

		                return instanceLink;
		            }
		        }
		    });
		    Handlebars.registerHelper('hbessRenderInstanceLinkMenu', function (instance, type) {
				//console.log('84')
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
		            instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';

		            return instanceLink;
		        }
		    });

		  Handlebars.registerHelper('essRenderInstanceReportLink', function (instance) {
			//console.log('102')
		        let targetReport = "<xsl:value-of select="$repYN"/>";
				let linkMenuName = essGetMenuNamebyClass(instance); 
		        if (targetReport.length &gt; 1) { 
		            let linkURL = reportURL;
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
		            let linkId = instance.id + 'Link';
		            instanceLink = '<a href="' + linkHref + '" id="' + linkId + '">' + instance.name + '</a>';

		            return instanceLink;
		        } else {

		            let linkMenuName = essGetMenuNamebyClass(instance);
		            let instanceLink = instance.name;
		            if (linkMenuName != null) {
		                let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		                let linkClass = 'context-menu-' + linkMenuName;
		                let linkId = instance.id + 'Link';
		                let linkURL = reportURL;
		                instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '&amp;xsl=' + linkURL + '">' + instance.name + '</a>';

		                return instanceLink;
		            }
		        }
		    });

		Handlebars.registerHelper('essRenderInstanceMenuLink', function (instance) {
			// console.log('129', instance)
		       if(instance != null) {
                let linkMenuName = essGetMenuNamebyClass(instance); 
				let instanceLink = instance.name;   
			//	console.log('linkMenuName',linkMenuName)
				if(linkMenuName) {
				 
					let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					let linkClass = 'context-menu-' + linkMenuName;
					let linkId = instance.id + 'Link';
					instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
		 
					<!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
                } 
				return instanceLink;
			} else {
				return '';
			}
		    });
<!--
		Handlebars.registerHelper('essRenderInstanceMenuLinkReport', function (instance) {

				if(instance != null) {
				 let linkMenuName = essGetMenuNamebyClass(instance); 
				 let instanceLink = instance.name;   
		  
				 if(linkMenuName) {
				  
					 let linkHref = 'report?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					 let linkClass = 'context-menu-' + linkMenuName;
					 let linkId = instance.id + 'Link';
					 instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
					 console.log('linkHref',linkHref)
							 } 
				 return instanceLink;
			 } else {
				 return '';
			 }
			 });		
	-->
			Handlebars.registerHelper('essRenderInstanceMenuLinkLight', function (instance) {
				//console.log('150')
				if(instance != null) {
				 let linkMenuName = essGetMenuNamebyClass(instance); 
				 let instanceLink = instance.name;   
		  //console.log('linkMenuName',linkMenuName)
		  //console.log('instanceLink',instanceLink)
				 if(linkMenuName) {
				  
					 let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					 let linkClass = 'context-menu-' + linkMenuName;
					 let linkId = instance.id + 'Link';
					 instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '" style="color:white">' + instance.name + '</a>';
			 
					 <!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
				 } 
				 return '<span style="color:white">' + instanceLink + '</span>';
			 } else {
				 return '';
			 }
			 });		
	
		Handlebars.registerHelper('essRenderInstanceMenuLinkReport', function (instance) {
			//console.log('172', instance)
				if(instance != null) {
				 let linkMenuName = essGetMenuNamebyClass(instance); 
				 let instanceLink = instance.name;   
			
				 if(linkMenuName) {
				  
					 let linkHref = 'report?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
					 let linkClass = 'context-menu-' + linkMenuName;
					 let linkId = instance.id + 'Link';
					 instanceLink = '<a href="' + linkHref + '" class="' + linkClass + '" id="' + linkId + '">' + instance.name + '</a>';
			
					 <!--instanceLink = '<a><xsl:attribute name="href" select="linkHref"/><xsl:attribute name="class" select="linkClass"/><xsl:attribute name="id" select="linkId"/></a>'-->
				 } 
				 return instanceLink;
			 } else {
				 return '';
			 }
			 });		

 Handlebars.registerHelper('essRenderInstanceLinkSelect', function (instance) {
	//console.log('193')
		        let targetReport = "<xsl:value-of select="$repYN"/>";
				let linkMenuName = essGetMenuNamebyClass(instance); 
		        if (targetReport.length &gt; 1) { 
		            let linkURL = reportURL;
		            let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage + '&amp;XSL=' + linkURL;
		            let linkId = instance.id + 'Link';
		        	instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15" onclick="window.location.href=&quot;' + linkHref + '&quot;"  id="' + linkId +'"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'

		            return instanceLink;
		        } else {

		            let linkMenuName = essGetMenuNamebyClass(instance);
		            let instanceLink = instance.name;
		            if (linkMenuName != null) {
		                let linkHref = '?XML=reportXML.xml&amp;PMA=' + instance.id + '&amp;cl=' + essLinkLanguage;
		                let linkClass = 'context-menu-' + linkMenuName;
		                let linkId = instance.id + 'Link';
		                let linkURL = reportURL;

						instanceLink = '<button class="ebfw-confirm-instance-selection btn btn-default btn-xs right-15 ' + linkClass + '" href="' + linkHref + '"  id="' + linkId + '&amp;xsl=' + linkURL + '"><i class="text-success fa fa-check-circle right-5"></i>Select</button>'
 
		                return instanceLink;
		            }
		        }
		    });
	
	
	</xsl:template>
	
	<xsl:template match="node()" mode="classMetaData"> 
				<xsl:variable name="thisClasses" select="current()/own_slot_value[slot_reference='report_menu_class']/value"/>
				{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "enabled":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_is_default']/value"/>", "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>
	<xsl:template name="GetViewerAPIPathTemplate">
        <xsl:param name="apiReport"/>
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$dataSetPath"/>
    </xsl:template>
</xsl:stylesheet>
