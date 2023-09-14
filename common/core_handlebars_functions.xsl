<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
 
<xsl:param name="targetReportId"/>
<xsl:param name="targetMenuShortName"/> 
<xsl:variable name="reportMenu" select="/node()/simple_instance[type = 'Report_Menu']"/>
<xsl:variable name="targetReport" select="/node()/simple_instance[name = $targetReportId]"/>
<xsl:variable name="repYN"><xsl:choose><xsl:when test="$targetReportId"><xsl:value-of select="$targetReportId"/></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></xsl:variable>

	<xsl:template name="RenderHandlebarsUtilityFunctions">
			var reportURL='<xsl:value-of select="$targetReport/own_slot_value[slot_reference='report_xsl_filename']/value"/>';
			let meta=[<xsl:apply-templates select="$reportMenu" mode="classMetaData"></xsl:apply-templates>];
		 
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

			   
			function essGetMenuNamebyClass(instance) { 

				let menuName = null;
				if(instance.meta?.anchorClass) {
		
					const objectWithBusinessProcess = meta.find(obj => obj.classes.includes(instance.meta.anchorClass));
					menuName = objectWithBusinessProcess.menuId;		
				} else if(instance.className) {
				
					const objectWithBusinessProcess = meta.find(obj => obj.classes.includes(instance.className));
					menuName = objectWithBusinessProcess.menuId;
				}
					
				return menuName;
			}

		    Handlebars.registerHelper('essRenderInstanceLinkOnly', function (instance, type) {

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

		       if(instance != null) {
                let linkMenuName = essGetMenuNamebyClass(instance); 
				let instanceLink = instance.name;   
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

 Handlebars.registerHelper('essRenderInstanceLinkSelect', function (instance) {

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
				{"classes":[<xsl:for-each select="$thisClasses">"<xsl:value-of select="current()"/>"<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if></xsl:for-each>], "menuId":"<xsl:value-of select="current()/own_slot_value[slot_reference='report_menu_short_name']/value"/>"}<xsl:if test="not(position() = last())"><xsl:text>,</xsl:text></xsl:if>
	</xsl:template>

</xsl:stylesheet>
