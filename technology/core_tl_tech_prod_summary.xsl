<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_strategic_plans.xsl"/>
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:include href="../common/datatables_includes.xsl"/>
	
	<!--<xsl:include href="../common/core_arch_image.xsl"/>-->

	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>


	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="targetReport" select="'REPORT_NAME_SLOT_VALUE'"/>
	<xsl:variable name="targetMenu" select="eas:get_menu_by_shortname('MENU_SHORT_NAME_SLOT_VALUE')"/>
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Individual_Actor', 'Group_Actor', 'Business_Process', 'Site', 'Technology_Function', 'Technology_Capability', 'Technology_Product', 'Supplier', 'Technology_Strategic_Plan', 'Technology_Component', 'Composite_Application_Provider', 'Application_Provider', 'Application_Deployment', 'Application_Software_Instance', 'Infrastructure_Software_Instance', 'Information_Store_Instance', 'Technology_Node')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="currentNode" select="/node()/simple_instance[name = $param1]"/>
	<xsl:variable name="serverName" select="$currentNode/own_slot_value[slot_reference = 'name']/value"/>
	<xsl:variable name="aRoleList" select="/node()/simple_instance[own_slot_value[slot_reference = 'role_for_technology_provider']/value = $param1]"/>

	<xsl:variable name="allTechProdRoles" select="/node()/simple_instance[supertype = 'Technology_Provider_Role']"/>
	<xsl:variable name="allTechProdRoleUsages" select="/node()/simple_instance[type = 'Technology_Provider_Usage']"/>
	<xsl:variable name="allTechProducts" select="/node()/simple_instance[supertype = 'Technology_Provider']"/>
	<xsl:variable name="allTechComps" select="/node()/simple_instance[type = 'Technology_Component' or supertype = 'Technology_Component']"/>
	<xsl:variable name="allTechBuilds" select="/node()/simple_instance[type = 'Technology_Build_Architecture']"/>
	<xsl:variable name="allTechProductFamilies" select="/node()/simple_instance[type = 'Technology_Product_Family']"/>
	<xsl:variable name="allSites" select="/node()/simple_instance[type = 'Site']"/>

	<xsl:variable name="allLifecycleStatii" select="/node()/simple_instance[name = $allTechProdRoles/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
	<xsl:variable name="allTechProdStandards" select="/node()/simple_instance[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allTechProdRoles/name]"/>
	<xsl:variable name="allStandardStrengths" select="/node()/simple_instance[name = $allTechProdStandards/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
	<xsl:variable name="allStandardStyles" select="/node()/simple_instance[name = $allStandardStrengths/own_slot_value[slot_reference = 'element_styling_classes']/value]"/>
	
    <xsl:variable name="productLifecycles" select="/node()/simple_instance[type='Lifecycle_Model'][own_slot_value[slot_reference='lifecycle_model_subject']/value=$currentNode/name]"/>

	<xsl:variable name="lifecycleStatusUsages" select="/node()/simple_instance[type=('Vendor_Lifecycle_Status_Usage','Lifecycle_Status_Usage')][own_slot_value[slot_reference='used_in_lifecycle_model']/value=$productLifecycles/name]"/>
    <xsl:variable name="lifecycles" select="/node()/simple_instance[type=('Vendor_Lifecycle_Status','Lifecycle_Status')]"/>
	<xsl:variable name="offStrategyStyle">backColourRed</xsl:variable>

	<xsl:variable name="inScopeCosts" select="/node()/simple_instance[type='Cost'][own_slot_value[slot_reference = 'cost_for_elements']/value = $currentNode/name]"/>
	<xsl:variable name="inScopeCostComponents" select="/node()/simple_instance[supertype='Cost_Component'][name = $inScopeCosts/own_slot_value[slot_reference = 'cost_components']/value]"/>
	<xsl:variable name="inScopeCostInstances" select="$inScopeCosts union $inScopeCostComponents"></xsl:variable>
	<xsl:variable name="currencyType" select="/node()/simple_instance[(type = 'Report_Constant')][own_slot_value[slot_reference = 'name']/value='Default Currency']"/>
	<xsl:variable name="currency" select="/node()/simple_instance[(type = 'Currency')][name=$currencyType/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]/own_slot_value[slot_reference='currency_symbol']/value"/>
	<xsl:variable name="allStakeholders" select="/node()/simple_instance[name = $currentNode/own_slot_value[slot_reference = 'stakeholders']/value]"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
	<xsl:variable name="allRoles" select="/node()/simple_instance[name = $allStakeholders/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>

	<!--
		* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	<!-- 19.04.2008 JP  Migrated to new servlet reporting engine	 -->
	<!-- 06.11.2008 JWC	Migrated to XSL v2 -->
	<!-- 29.06.2010	JWC	Fixed details links to support " ' " characters in names -->
	<!-- 01.05.2011 NJW Updated to support Essential Viewer version 3-->
	<!-- 05.01.2016 NJW Updated to support Essential Viewer version 5-->
	<!-- 08.03.2013 JWC	Resolved some issues rendering impacted Applcations -->
	<!-- 14.05.2013	JWC Sorted out the rendering of Strategic Plans - to include usage of the product -->
	<!-- 12.02.2019	JP	- Updated to use cpmmon Strategic Plans template-->


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<title>
					<xsl:value-of select="eas:i18n('Technology Product Summary')"/>
				</title>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:call-template name="dataTablesLibrary"/>
                <style>
                .btn-vstatus {background-color:#ffffff;
                    border:1pt solid #d3d3d3;
                    font-size:1.1em;
                    pointer:none;}
                </style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->

				<!-- PAGE BODY STARTS HERE -->
				<xsl:apply-templates select="$currentNode" mode="Page_Body"/>

				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
			</body>
		</html>
	</xsl:template>


	<!--Start the Page Body Template-->
	<xsl:template match="node()" mode="Page_Body">

		<!-- Get the name of the application provider -->
		<xsl:variable name="productName">
			<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
		</xsl:variable>
		<xsl:variable name="tech_prod_role_list" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'implements_technology_components']/value]"/>
		<!-- Get all the usages of the Technology Product Roles for this product -->
		<xsl:variable name="tech_prod_usage_list" select="/node()/simple_instance[own_slot_value[slot_reference = 'provider_as_role']/value = $tech_prod_role_list/name]"/>
		<!-- Get all the technology product builds where these usages are used -->
		<xsl:variable name="techProdBuildList" select="/node()/simple_instance[name = $tech_prod_usage_list/own_slot_value[slot_reference = 'used_in_technology_provider_architecture']/value]"/>


		<div class="container-fluid">
			<div class="row">
				<div>
					<div class="col-xs-12">
						<div class="page-header">
							<h1>
								<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>:&#160;</span>
								<span class="text-darkgrey"><xsl:value-of select="eas:i18n('Technology Product Summary for')"/>&#160; </span>
								<span class="text-primary">
									<xsl:value-of select="$serverName"/>
								</span>
							</h1>
						</div>
					</div>
				</div>

				<!--Setup Description Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-list-ul icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Description')"/>
					</h2>
					<div class="content-section">
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</div>

					<hr/>
				</div>


				<!--Setup Product Family Section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-sitemap icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Member of Product Family')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="productFamilyInstances" select="$allTechProductFamilies[name = $currentNode/own_slot_value[slot_reference = 'member_of_technology_product_families']/value]"/>
						<xsl:choose>
							<xsl:when test="count($productFamilyInstances) &gt; 0">
								<xsl:for-each select="$productFamilyInstances">
									<xsl:value-of select="current()/own_slot_value[slot_reference = 'name']/value"/><xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise> - </xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>




				<!--Setup the Supplier section-->

				<div class="col-xs-12 col-md-6">
					<div class="sectionIcon">
						<i class="fa fa-truck icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supplier')"/>
					</h2>
					<div class="content-section">
						<xsl:if test="count(own_slot_value[slot_reference = 'supplier_technology_product']/value) = 0">
							<span>-</span>
						</xsl:if>
						<xsl:apply-templates select="own_slot_value[slot_reference = 'supplier_technology_product']/value" mode="RenderInstanceName"/>
					</div>
					<hr/>
				</div>


				<!--Setup Misc Section-->

				<div class="col-xs-6">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Lifecycle Status')"/>
					</h2>
					<div class="content-section">
                         
                             <button type="button" class="btn btn-primary" >Internal:</button><xsl:text> </xsl:text> <button type="button" class="btn btn-vstatus"><span id="internal"></span></button><p></p>
                            <button type="button" class="btn btn-primary" >External:</button><xsl:text> </xsl:text> <button type="button" class="btn btn-vstatus"><span id="vendor"></span></button><br/>
                       
					</div>
					<hr/>
				</div>
<script>
    <xsl:variable name="internal" select="$lifecycles[name=current()/own_slot_value[slot_reference='technology_provider_lifecycle_status']/value]"/>
    <xsl:variable name="internalStatusLabel">
    	<xsl:choose>
    		<xsl:when test="count($internal) = 0">Not Set</xsl:when>
    		<xsl:when test="string-length($internal/own_slot_value[slot_reference='enumeration_value']/value) > 0"><xsl:value-of select="$internal/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when>
    		<xsl:otherwise><xsl:value-of select="$internal/own_slot_value[slot_reference='name']/value"/></xsl:otherwise>
    	</xsl:choose>
    </xsl:variable>
	<xsl:variable name="external" select="$lifecycles[name=current()/own_slot_value[slot_reference='vendor_product_lifecycle_status']/value]"/>
	<xsl:variable name="externalStatusLabel">
		<xsl:choose>
			<xsl:when test="count($external) = 0">Not Set</xsl:when>
			<xsl:when test="string-length($external/own_slot_value[slot_reference='enumeration_value']/value) > 0"><xsl:value-of select="$external/own_slot_value[slot_reference='enumeration_value']/value"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$external/own_slot_value[slot_reference='name']/value"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    today= new Date().getTime();
statusJSON=[<xsl:apply-templates select="$lifecycleStatusUsages" mode="lifecyclesJSON"/>]; 
	thisvendor=['<xsl:value-of select="$externalStatusLabel"/>'];    
	thisinternal=['<xsl:value-of select="$internalStatusLabel"/>'];  

     var list=statusJSON.filter(function(d){
        return new Date(d.date).getTime() &lt; today; 
    })
    
    list.sort(custom_sort);
    vendors=list;
    vendor=list.filter(function(d){
        return d.type==="Vendor_Lifecycle_Status";
    })
    
  internal=list.filter(function(d){
        return d.type==="Lifecycle_Status";
    })
  
    if(internal[0]){$('#internal').text(internal[0].name)}else{$('#internal').text(thisinternal[0])}
    if(vendor[0]){$('#vendor').text(vendor[0].name)}else{$('#vendor').text(thisvendor[0])}
    
    function custom_sort(a, b) {
    return new Date(b.date).getTime() - new Date(a.date).getTime();
}
    
    
</script>
         <xsl:variable name="isAuthzForCostClasses" select="eas:isUserAuthZClasses(('Cost', 'Cost_Component'))"/>
		 <xsl:variable name="isAuthzForCostInstances" select="eas:isUserAuthZInstances($inScopeCostInstances)"/>

                <div class="col-xs-6">
					<div class="sectionIcon">
						<i class="fa fa-info-circle icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Maintenance Cost')"/>
					</h2>
					<xsl:variable name="defaultCurrencyConstant" select="eas:get_instance_by_name(/node()/simple_instance, 'Report_Constant', 'Default Currency')"/>
					<xsl:variable name="defaultCurrency" select="eas:get_instance_slot_values(/node()/simple_instance, $defaultCurrencyConstant, 'report_constant_ea_elements')"/>
					<xsl:variable name="defaultCurrencySymbol" select="eas:get_string_slot_values($defaultCurrency, 'currency_symbol')"/>
					<xsl:variable name="maintenanceCost" select="if (count(current()/own_slot_value[slot_reference = 'maintenance_cost']/value) > 0) then concat($defaultCurrencySymbol,format-number(current()/own_slot_value[slot_reference = 'maintenance_cost']/value, '##,###,###')) else ''"/>
				
					<div class="content-section">
							<xsl:choose>
								<xsl:when test="not($isAuthzForCostClasses) or not($isAuthzForCostInstances)"><span><xsl:value-of select="$theRedactedString"/></span></xsl:when>
								<xsl:otherwise>
									<xsl:variable name="costTypeTotal" select="eas:get_cost_components_total($inScopeCostComponents, 0)"/>
									<xsl:choose>
										<xsl:when test="$costTypeTotal=0">
												<xsl:choose>
													<xsl:when test="not(count($maintenanceCost) > 0)">
														<p> - </p>
													</xsl:when>
													<xsl:otherwise>
														<p> <xsl:value-of select="eas:getSafeJSString($maintenanceCost)"/>
														</p>
													</xsl:otherwise>
												</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$currency"/>  <xsl:value-of select="format-number($costTypeTotal, '###,###,###')"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>  


						
					</div>
					<hr/>
				</div>

				<!--Setup the Strategic Plans section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-calendar icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Strategic Plans')"/>
					</h2>
					<div class="content-section">
						<h3>
							<xsl:value-of select="eas:i18n('Plans for Product')"/>
						</h3>
						<xsl:apply-templates select="$currentNode" mode="StrategicPlansForElement"/>

						<div class="verticalSpacer_20px"/>
						<h3>
							<xsl:value-of select="eas:i18n('Plans for use of Product')"/>
						</h3>
						<xsl:apply-templates select="$aRoleList" mode="StrategicPlansForElement"/>

					</div>
					<hr/>
				</div>



				<!--Setup Technology Functions Offered Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-blocks icon-section icon-color"/>
					</div>
					<h2 class="text-primary">Technology Functions Offered</h2>
					<div class="content-section">
						<xsl:apply-templates select="$currentNode" mode="TechnologyFunctions"/>
					</div>

					<hr/>
				</div>


				<!--Setup Used to Implement Technology Components Section-->
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-radialdots icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Used to Implement Technology Components')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="not(count($tech_prod_role_list) > 0)">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Technology Components implemented')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>

								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-40pc">
												<xsl:value-of select="eas:i18n('Technology Component')"/>
											</th>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Status')"/>
											</th>
											<th class="cellWidth-30pc alignCentre">
												<xsl:value-of select="eas:i18n('Standards Compliance')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$tech_prod_role_list" mode="TechnologyProductRole"/>
									</tbody>
								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>


					<hr/>
				</div>

	<!--Setup Stakeholders Section-->
	<div class="col-xs-12">
		<div class="sectionIcon">
			<i class="fa fa-users icon-section icon-color"/>
		</div>
		<div>
			<h2 class="text-primary">
				<xsl:value-of select="eas:i18n('Roles and People')"/>
			</h2>
			 
		</div>
		<div class="content-section">
			<xsl:choose>
				<xsl:when test="count($allStakeholders) &gt; 0">
					<script>
					$(document).ready(function(){
						// Setup - add a text input to each footer cell
						$('#dt_stakeholders tfoot th').each( function () {
							var title = $(this).text();
							$(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
						} );
						
						var table = $('#dt_stakeholders').DataTable({
						scrollY: "350px",
						scrollCollapse: true,
						paging: false,
						info: false,
						sort: true,
						responsive: true,
						columns: [
							{ "width": "30%" },
							{ "width": "30%" },
							{ "width": "40%" }
						  ],
						dom: 'Bfrtip',
						buttons: [
							'copyHtml5', 
							'excelHtml5',
							'csvHtml5',
							'pdfHtml5',
							'print'
						]
						});
						
						
						// Apply the search
						table.columns().every( function () {
							var that = this;
					 
							$( 'input', this.footer() ).on( 'keyup change', function () {
								if ( that.search() !== this.value ) {
									that
										.search( this.value )
										.draw();
								}
							} );
						} );
						
						table.columns.adjust();
						
						$(window).resize( function () {
							table.columns.adjust();
						});
					});
				</script>
					<table class="table table-striped table-bordered" id="dt_stakeholders">
						<thead>
							<tr>
								<th class="cellWidth-30pc">
									<xsl:value-of select="eas:i18n('Role')"/>
								</th>
								<th class="cellWidth-30pc">
									<xsl:value-of select="eas:i18n('Person or Organisation')"/>
								</th>
								<th class="cellWidth-40pc">
									<xsl:value-of select="eas:i18n('Email')"/>
								</th>
							</tr>
						</thead>
						<tbody>
							<xsl:for-each select="$allStakeholders">
								<xsl:variable name="actor" select="$allActors[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]"/>
								<xsl:variable name="role" select="$allRoles[name = current()/own_slot_value[slot_reference = 'act_to_role_to_role']/value]"/>
								<xsl:variable name="email" select="$actor/own_slot_value[slot_reference = 'email']/value"/>
								<tr>
									<td>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$role"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:call-template name="RenderInstanceLink">
											<xsl:with-param name="theSubjectInstance" select="$actor"/>
											<xsl:with-param name="theXML" select="$reposXML"/>
											<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
										</xsl:call-template>
									</td>
									<td>
										<xsl:value-of select="$email"/>
									</td>
								</tr>
							</xsl:for-each>

						</tbody>
						<tfoot>
							<tr>
								<th>
									<xsl:value-of select="eas:i18n('Role')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Person or Organisation')"/>
								</th>
								<th>
									<xsl:value-of select="eas:i18n('Email')"/>
								</th>
							</tr>
						</tfoot>
					</table>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<span>-</span>
					</p>
				</xsl:otherwise>
			</xsl:choose>

		</div>
		<hr/>
	</div>
				<!--Setup Supports Applications Section-->

				<xsl:variable name="techProvsInScope" select="$techProdBuildList/own_slot_value[slot_reference = 'describes_technology_provider']/value"/>
				<xsl:variable name="app_deployment_list" select="/node()/simple_instance[(own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $techProvsInScope) or (own_slot_value[slot_reference = 'application_deployment_technical_arch']/value = $param1)]"/>
				

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-tablet icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supports Applications')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="not(count($app_deployment_list))">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Supported Applications Defined for this Product')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>

								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-20pc">
												<xsl:value-of select="eas:i18n('Application Supported')"/>
											</th>
											<th class="cellWidth-35pc">
												<xsl:value-of select="eas:i18n('Application Deployment Instances Supported')"/>
											</th>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Application Deployment Description')"/>
											</th>
											<th class="cellWidth-15pc">
												<xsl:value-of select="eas:i18n('Runtime Status')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$app_deployment_list" mode="ApplicationDeployment"/>
									</tbody>

								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>

					<hr/>
				</div>
				

				<xsl:variable name="supportedAppProviders" select="/node()/simple_instance[name = $app_deployment_list/own_slot_value[slot_reference = 'application_provider_deployed']/value]"/>
				<xsl:variable name="supportedAppProRoles" select="/node()/simple_instance[own_slot_value[slot_reference='role_for_application_provider']/value = $supportedAppProviders/name]"/>
				<xsl:variable name="supportedAPRToPhysProcRels" select="/node()/simple_instance[own_slot_value[slot_reference=('apppro_to_physbus_from_apppro', 'apppro_to_physbus_from_appprorole')]/value = ($supportedAppProviders, $supportedAppProRoles)/name]"/>
				<xsl:variable name="supportedPhysProcs" select="/node()/simple_instance[name = $supportedAPRToPhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value]"/>
				<xsl:variable name="supportedBusProcs" select="/node()/simple_instance[name = $supportedPhysProcs/own_slot_value[slot_reference='implements_business_process']/value]"/>
				<xsl:variable name="supportedActorsAndRoles" select="/node()/simple_instance[name = $supportedPhysProcs/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
				<xsl:variable name="supportedDirecActors" select="$supportedActorsAndRoles[type = 'Group_Actor']"/>
				<xsl:variable name="supportedActor2Roles" select="$supportedActorsAndRoles[type = 'ACTOR_TO_ROLE_RELATION']"/>
				<xsl:variable name="supportedIndirectActors" select="/node()/simple_instance[name = $supportedActor2Roles/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
				<xsl:variable name="allSupportedActors" select="$supportedDirecActors union $supportedIndirectActors"/>
				
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-users icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supports Business Processes')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="not(count($supportedPhysProcs))">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No supported Business Processes defined for this Technology Product')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>
								
								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Business Process Supported')"/>
											</th>
											<th class="cellWidth-30pc">
												<xsl:value-of select="eas:i18n('Performed By Organisation')"/>
											</th>
											<th class="cellWidth-15pc">
												<xsl:value-of select="eas:i18n('At Locations')"/>
											</th>
											<th class="cellWidth-25pc">
												<xsl:value-of select="eas:i18n('Using Applications')"/>
											</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="$supportedPhysProcs" mode="PhysicalProcesess">
											<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
											<xsl:with-param name="supportedAppProviders" select="$supportedAppProviders"/>
											<xsl:with-param name="supportedAppProRoles" select="$supportedAppProRoles"/>
											<xsl:with-param name="supportedAPRToPhysProcRels" select="$supportedAPRToPhysProcRels"/>
											<xsl:with-param name="supportedBusProcs" select="$supportedBusProcs"/>
											<xsl:with-param name="supportedActorsAndRoles" select="$supportedActorsAndRoles"/>
											<xsl:with-param name="allSupportedActors" select="$allSupportedActors"/>
										</xsl:apply-templates>
									</tbody>
									
								</table>
								
							</xsl:otherwise>
						</xsl:choose>
					</div>
					
					<hr/>
				</div>


				<!--Setup Information Stores Section-->
				<xsl:variable name="thisProduct" select="name"/>
				<xsl:variable name="techInstances" select="/node()/simple_instance[own_slot_value[slot_reference = 'technology_instance_of']/value = $thisProduct]"/>
				<xsl:variable name="infoStoreInstances" select="/node()/simple_instance[type = 'Information_Store_Instance' and own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value = $techInstances/name]"/>


				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-database icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supports Information Stores')"/>
					</h2>
					<div class="content-section">
						<xsl:apply-templates select="$currentNode" mode="FindInformationStores"/>
					</div>

					<hr/>
				</div>


				<!--Setup Deployed Instances Section-->

				<xsl:variable name="thisProduct" select="current()/name"/>
				<xsl:variable name="techProdInstances" select="/node()/simple_instance[own_slot_value[slot_reference = 'technology_instance_of']/value = $thisProduct]"/>


				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-server icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Deployed Instances')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($techProdInstances) = 0">
								<p>
									<em>
										<xsl:value-of select="eas:i18n('No Deployed Instances for this Product')"/>
									</em>
								</p>
							</xsl:when>
							<xsl:otherwise>

								<table class="table table-bordered table-striped">
									<thead>
										<th class="cellWidth-20pc">
											<xsl:value-of select="eas:i18n('Technology Instance Name')"/>
										</th>
										<th class="cellWidth-30pc">
											<xsl:value-of select="eas:i18n('Technology Instance Description')"/>
										</th>
										<th class="cellWidth-15pc">
											<xsl:value-of select="eas:i18n('Runtime Status')"/>
										</th>
										<th class="cellWidth-20pc">
											<xsl:value-of select="eas:i18n('Technology Product')"/>
										</th>
										<th class="cellWidth-15pc">
											<xsl:value-of select="eas:i18n('Used As')"/>
										</th>
									</thead>
									<tbody>
										<xsl:apply-templates select="$techProdInstances" mode="Technology_Instance"/>
									</tbody>
								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>


				<!--Setup Tech Architectures Section-->

				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa essicon-boxesdiagonal icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Used In Technology Architectures')"/>
					</h2>
					<div class="content-section">
						<xsl:choose>
							<xsl:when test="count($techProdBuildList) = 0">
								<em>-</em>
							</xsl:when>
							<xsl:otherwise>
								<script>
								$(document).ready(function(){
									// Setup - add a text input to each footer cell
								    $('#dt_techarchs tfoot th').each( function () {
								        var title = $(this).text();
								        $(this).html( '&lt;input type="text" placeholder="Search '+title+'" /&gt;' );
								    } );
									
									var table = $('#dt_techarchs').DataTable({
									scrollY: "350px",
									scrollCollapse: true,
									paging: false,
									info: false,
									sort: true,
									responsive: true,
									columns: [
									    { "width": "20%" },
									    { "width": "20%" },
									    { "width": "30%" },
									    { "width": "30%" }
									  ],
									dom: 'Bfrtip',
								    buttons: [
							            'copyHtml5', 
							            'excelHtml5',
							            'csvHtml5',
							            'pdfHtml5',
							            'print'
							        ]
									});
									
									
									// Apply the search
								    table.columns().every( function () {
								        var that = this;
								 
								        $( 'input', this.footer() ).on( 'keyup change', function () {
								            if ( that.search() !== this.value ) {
								                that
								                    .search( this.value )
								                    .draw();
								            }
								        } );
								    } );
								    
								    table.columns.adjust();
								    
								    $(window).resize( function () {
								        table.columns.adjust();
								    });
								});
							</script>
								<table class="table table-striped table-bordered" id="dt_techarchs">
									<thead>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Architecture')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Technology Component')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Component Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Technology Products')"/>
											</th>
										</tr>
									</thead>
									<tfoot>
										<tr>
											<th>
												<xsl:value-of select="eas:i18n('Architecture')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Technology Component')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Component Description')"/>
											</th>
											<th>
												<xsl:value-of select="eas:i18n('Technology Products')"/>
											</th>
										</tr>
									</tfoot>
									<tbody>
										<xsl:for-each-group select="$techProdBuildList" group-by="name">
											<xsl:variable name="aUsageList" select="$allTechProdRoleUsages[name = current()/own_slot_value[slot_reference = 'contained_architecture_components']/value]"/>

											<xsl:for-each select="$aUsageList">
												<xsl:variable name="aRole" select="$allTechProdRoles[name = current()/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
												<xsl:variable name="aComp" select="$allTechComps[name = $aRole/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>
												<xsl:variable name="aProd" select="$allTechProducts[name = $aRole/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
												<tr>
													<td>
														<xsl:value-of select="translate(current-group()[1]/own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
													</td>
													<td>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="$aComp"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template>
													</td>
													<td>
														<xsl:value-of select="$aComp/own_slot_value[slot_reference = 'description']/value"/>
													</td>
													<td>
														<xsl:call-template name="RenderInstanceLink">
															<xsl:with-param name="theSubjectInstance" select="$aProd"/>
															<xsl:with-param name="theXML" select="$reposXML"/>
															<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
														</xsl:call-template>
													</td>
												</tr>
											</xsl:for-each>
										</xsl:for-each-group>
									</tbody>
								</table>

							</xsl:otherwise>
						</xsl:choose>
					</div>
					<hr/>
				</div>



				<!--Setup the Supporting Documentation section-->
				<div class="col-xs-12">
					<div class="sectionIcon">
						<i class="fa fa-file-text-o icon-section icon-color"/>
					</div>
					<h2 class="text-primary">
						<xsl:value-of select="eas:i18n('Supporting Documentation')"/>
					</h2>
					<div class="content-section">
						<xsl:variable name="currentInstance" select="/node()/simple_instance[name=$param1]"/><xsl:variable name="anExternalDocRefList" select="/node()/simple_instance[name = $currentInstance/own_slot_value[slot_reference = 'external_reference_links']/value]"/><xsl:call-template name="RenderExternalDocRefList"><xsl:with-param name="extDocRefs" select="$anExternalDocRefList"/></xsl:call-template>
					</div>
					<hr/>
				</div>


				<!--Setup Closing Divs-->
			</div>
		</div>

		<div class="clear"/>
	</xsl:template>



	<!-- 19.11.2008	JWC Render the list of offered Technology Functions. Takes the node of a Technology
		Product/Provider -->
	<xsl:template match="node()" mode="TechnologyFunctions">
		<xsl:variable name="functionList" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_product_functions_offered']/value]"/>
		<xsl:choose>
			<xsl:when test="count($functionList) > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<tr>
							<th>
								<xsl:value-of select="eas:i18n('Technology Function')"/>
							</th>
							<th>
								<xsl:value-of select="eas:i18n('Description')"/>
							</th>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="$functionList" mode="RenderTechnologyFunctions"/>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No Technology Functions defined for this product')"/>. </em>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- 19.11.2008	JWC
	Render the Technology Functions give a set of Technology Function nodes -->
	<xsl:template match="node()" mode="RenderTechnologyFunctions">
		<tr>
			<td>
				<!--<xsl:value-of select="own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE DETAILS FOR Technology Product Roles -->
	<xsl:template match="node()" mode="TechnologyProductRole">
		<xsl:variable name="techCompInstID" select="own_slot_value[slot_reference = 'implementing_technology_component']/value"/>
		<xsl:variable name="relevantTechComps" select="$allTechComps[name = $techCompInstID]"/>
		<tr>
			<td>
				<!--<xsl:apply-templates select="$techCompInstID" mode="RenderInstanceName" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$relevantTechComps"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<xsl:variable name="lifecycle_status" select="$allLifecycleStatii[name = current()/own_slot_value[slot_reference = 'strategic_lifecycle_status']/value]"/>
			
			<xsl:variable name="allRelevantTPRs" select="$allTechProdRoles[own_slot_value[slot_reference = 'implementing_technology_component']/value = $relevantTechComps/name]"/>
			<xsl:variable name="allRelevantTechProdStandards" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = $allRelevantTPRs/name]"/>
			
			<xsl:variable name="thisTechProdStandard" select="$allTechProdStandards[own_slot_value[slot_reference = 'tps_standard_tech_provider_role']/value = current()/name]"/>
			<xsl:variable name="thisStandardStrength" select="$allStandardStrengths[name = $thisTechProdStandard/own_slot_value[slot_reference = 'sm_standard_strength']/value]"/>
			<xsl:variable name="thisStandardStyleClass" select="$allStandardStyles[name = $thisStandardStrength/own_slot_value[slot_reference = 'element_styling_classes']/value]/own_slot_value[slot_reference = 'element_style_class']/value"/>
			
			<!-- 25.08.18 JP Updated to include Standards Compliance -->
			<td>
				<xsl:if test="not(count($lifecycle_status))">
					<em>
						<xsl:value-of select="eas:i18n('not defined')"/>
					</em>
				</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$lifecycle_status"/></xsl:call-template>
			</td>
			<xsl:choose>
				<xsl:when test="count($allRelevantTechProdStandards) = 0">
					<td class="alignCentre">
						<em><xsl:value-of select="eas:i18n('no standards defined')"/></em>
					</td>
				</xsl:when>
				<xsl:when test="count($thisTechProdStandard) >0">
					<td class="alignCentre {$thisStandardStyleClass}">
						<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$thisStandardStrength"/></xsl:call-template>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td class="alignCentre {$offStrategyStyle}">
						<xsl:value-of select="eas:i18n('Off Strategy')"/>
					</td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>

	</xsl:template>
	
	
	
	
	
	<!-- Render information about each Application Deployment that is supported by a Product 
		Takes instances of Application Deployment-->
	<xsl:template match="node()" mode="ApplicationDeployment">
		<tr>
			<xsl:variable name="appProviderID" select="own_slot_value[slot_reference = 'application_provider_deployed']/value"/>
			<xsl:variable name="application_provider_instance" select="/node()/simple_instance[name = $appProviderID]"/>
			<xsl:variable name="application_provider_name" select="$application_provider_instance/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="swComps" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'deployment_of_software_components']/value]"/>
			<xsl:variable name="swArchs" select="/node()/simple_instance[name = $swComps/own_slot_value[slot_reference = 'contained_in_logical_software_arch']/value]"/>
			<xsl:variable name="appProvider" select="/node()/simple_instance[name = $swArchs/own_slot_value[slot_reference = 'software_architecture_of_app_provider']/value]"/>
			<xsl:variable name="appProviderName" select="$appProvider/own_slot_value[slot_reference = 'name']/value"/>
			<xsl:variable name="app_instance_id" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'application_deployment_technology_instance']/value]"/>
			<xsl:variable name="app_runtme_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'application_deployment_role']/value]"/>
			<xsl:choose>
				<xsl:when test="count($application_provider_name) > 0">
					<td>
						<!--<a>
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$application_provider_instance/name" />
								<xsl:text>&amp;LABEL=Application Module Definition - </xsl:text>
								<xsl:value-of select="$application_provider_name" />
							</xsl:attribute>
							<xsl:value-of select="$application_provider_name" />
						</a>-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$application_provider_instance"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
						</xsl:call-template>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<!-- Find Application Provider via software components -->
					<td>
						<xsl:choose>
							<xsl:when test="count($appProviderName) > 0">
								<!--<a>
									<xsl:attribute name="href">
										<xsl:text>report?XML=reportXML.xml&amp;XSL=application/core_app_def.xsl&amp;PMA=</xsl:text>
										<xsl:value-of select="$application_provider_instance/name" />
										<xsl:text>&amp;LABEL=Application Module Definition - </xsl:text>
										<xsl:value-of select="$appProviderName" />
									</xsl:attribute>
									<xsl:value-of select="$appProviderName" />
								</a>-->
								<xsl:call-template name="RenderInstanceLink">
									<xsl:with-param name="theSubjectInstance" select="$application_provider_instance"/>
									<xsl:with-param name="theXML" select="$reposXML"/>
									<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="eas:i18n('No information')"/>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<ul>
					<xsl:apply-templates select="$app_instance_id" mode="ApplicationSoftwareInstances"/>
				</ul>
			</td>
			<td>
				<xsl:if test="count(own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($app_runtme_status))">-</xsl:if>
				<xsl:value-of select="$app_runtme_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</td>
		</tr>
	</xsl:template>


	<!-- Render information about the Physical Processes that are supported by this Technology product -->
	<xsl:template match="node()" mode="PhysicalProcesess">
		<xsl:param name="supportedAppProviders"/>
		<xsl:param name="supportedAppProRoles"/>
		<xsl:param name="supportedAPRToPhysProcRels"/>
		<xsl:param name="supportedBusProcs"/>
		<xsl:param name="supportedActorsAndRoles"/>
		<xsl:param name="allSupportedActors"/>
		
		<xsl:variable name="thisPhysProc" select="current()"/>
		
		<!-- Get the logical process being supported -->
		<xsl:variable name="thisBusProcess" select="$supportedBusProcs[name = $thisPhysProc/own_slot_value[slot_reference='implements_business_process']/value]"/>
		
		<!-- Get the organisation performing the process -->
		<xsl:variable name="thisActorsAndRoles" select="$supportedActorsAndRoles[name = $thisPhysProc/own_slot_value[slot_reference='process_performed_by_actor_role']/value]"/>
		<xsl:variable name="thisDirecActor" select="$thisActorsAndRoles[type = 'Group_Actor']"/>
		<xsl:variable name="thisActor2Role" select="$thisActorsAndRoles[type = 'ACTOR_TO_ROLE_RELATION']"/>
		<xsl:variable name="thisIndirectActor" select="$allSupportedActors[name = $thisActor2Role/own_slot_value[slot_reference='act_to_role_from_actor']/value]"/>
		<xsl:variable name="thisActor" select="$thisDirecActor union $thisIndirectActor"/>
		
		<xsl:variable name="thisSites" select="$allSites[name = ($thisPhysProc, $thisActor)/own_slot_value[slot_reference=('process_performed_at_sites', 'actor_based_at_site')]/value]"/>
		
		
		<!-- Get the supporting applications for the physical processes -->
		<xsl:variable name="thisAPRToPhysProcRels" select="$supportedAPRToPhysProcRels[own_slot_value[slot_reference='apppro_to_physbus_to_busproc']/value = $thisPhysProc/name]"/>
		<xsl:variable name="thisDirectApps" select="$supportedAppProviders[name = $thisAPRToPhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_from_apppro']/value]"/>
		<xsl:variable name="thisAPRs" select="$supportedAppProRoles[name = $thisAPRToPhysProcRels/own_slot_value[slot_reference='apppro_to_physbus_from_appprorole']/value]"/>
		<xsl:variable name="thisIndirectApps" select="$supportedAppProviders[name = $thisAPRs/own_slot_value[slot_reference='role_for_application_provider']/value]"/>
		<xsl:variable name="allThisApps" select="$thisDirectApps union $thisIndirectApps"/>



		<tr>
			<!-- Business Process -->
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisBusProcess"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
			<!-- Performing Org -->
			<td>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$thisActor"/>
				</xsl:call-template>
			</td>
			<!-- Performed at Sites -->
			<td>
				<ul>
					<xsl:for-each select="$thisSites">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</li>	
					</xsl:for-each>
				</ul>
			</td>
			<!-- Supporting Apps -->
			<td>
				<ul>
					<xsl:for-each select="$allThisApps">
						<li>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
							</xsl:call-template>
						</li>	
					</xsl:for-each>
				</ul>
			</td>
		</tr>
		
	</xsl:template>


	<!-- Render information about an Application Software Instance -->
	<xsl:template match="node()" mode="ApplicationSoftwareInstances">
		<xsl:variable name="app_instance_name" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="instance_name" select="translate($app_instance_name, '::', ' ')"/>
		<li>
			<!--<a>
				<xsl:attribute name="href">
					<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
					<xsl:value-of select="name" />
					<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
					<xsl:value-of select="$instance_name" />
				</xsl:attribute>
				<xsl:value-of select="$instance_name" />
			</a>-->
			<xsl:call-template name="RenderInstanceLink">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="theXML" select="$reposXML"/>
				<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
			</xsl:call-template>
		</li>

	</xsl:template>

	<!-- Find the set of Information Stores that are dependent on this Technology Product 
		and send them to be rendered. Expects the node for the current product -->
	<xsl:template match="node()" mode="FindInformationStores">
		<xsl:variable name="thisProduct" select="name"/>
		<xsl:variable name="techInstances" select="/node()/simple_instance[own_slot_value[slot_reference = 'technology_instance_of']/value = $thisProduct]"/>
		<!-- Find all Information Store Instances dependent on these product instances -->
		<xsl:variable name="infoStoreInstances" select="/node()/simple_instance[type = 'Information_Store_Instance' and own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value = $techInstances/name]"/>
		<xsl:choose>
			<xsl:when test="count($infoStoreInstances) > 0">
				<table class="table table-bordered table-striped">
					<thead>
						<th class="cellWidth-15pc">
							<xsl:value-of select="eas:i18n('DB Schema Name')"/>
						</th>
						<th class="cellWidth-25pc">
							<xsl:value-of select="eas:i18n('DB Schema Description')"/>
						</th>
						<th class="cellWidth-15pc">
							<xsl:value-of select="eas:i18n('Deployment Status')"/>
						</th>
						<th class="cellWidth-15pc">
							<xsl:value-of select="eas:i18n('Supporting DB Installation')"/>
						</th>
						<th class="cellWidth-15pc">
							<xsl:value-of select="eas:i18n('DB Installation Technology')"/>
						</th>
						<th class="cellWidth-15pc">
							<xsl:value-of select="eas:i18n('IT Contact')"/>
						</th>
					</thead>
					<tbody>
						<xsl:apply-templates select="$infoStoreInstances" mode="Info_Store_Instance"/>
					</tbody>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<em><xsl:value-of select="eas:i18n('No Information Store dependencies defined for this product')"/>.</em>
			</xsl:otherwise>

		</xsl:choose>

	</xsl:template>

	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED INFORMATION STORE INSTANCES -->
	<xsl:template match="node()" mode="Info_Store_Instance">
		<!-- 18.04.2008 JWC - Link to information representation report -->
		<xsl:variable name="anInformationStoreID" select="own_slot_value[slot_reference = 'instance_of_information_store']/value"/>
		<xsl:variable name="anInformationStore" select="/node()/simple_instance[name = $anInformationStoreID]"/>
		<xsl:variable name="anInformationRep" select="$anInformationStore/own_slot_value[slot_reference = 'deployment_of_information_representation']/value"/>
		<xsl:variable name="anInformationRepInst" select="/node()/simple_instance[name = $anInformationRep]"/>
		<xsl:variable name="info_deployment_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
		<xsl:variable name="info_db_instance" select="/node()/simple_instance[(name = current()/own_slot_value[slot_reference = 'contained_technology_instance_dependencies']/value) and (type = 'Infrastructure_Software_Instance')]"/>
		<xsl:variable name="info_db_tech_product" select="/node()/simple_instance[name = $info_db_instance/own_slot_value[slot_reference = 'technology_instance_of']/value]"/>
		<xsl:variable name="info_rep" select="/node()/simple_instance[own_slot_value[slot_reference = 'implemented_with_information_stores']/value = current()/own_slot_value[slot_reference = 'instance_of_information_store']/value]"/>
		<xsl:variable name="info_it_contact" select="/node()/simple_instance[name = $info_rep/own_slot_value[slot_reference = 'representation_it_contact']/value]"/>

		<tr>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=information/infoRep.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="$anInformationRep" />
						<xsl:text>&amp;LABEL=Information Representation - </xsl:text>
						<xsl:value-of select="$anInformationRepInst/own_slot_value[slot_reference='name']/value" />
					</xsl:attribute>
					<xsl:value-of select="own_slot_value[slot_reference='technology_instance_given_name']/value" />
				</a>-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="count(own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($info_deployment_status))">-</xsl:if>
				<xsl:value-of select="$info_deployment_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="not(count($info_db_instance))">-</xsl:when>
					<xsl:otherwise>
						<!--<a>
							<xsl:variable name="db_given_name" select="$info_db_instance/own_slot_value[slot_reference='technology_instance_given_name']/value" />
							<xsl:attribute name="href">
								<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
								<xsl:value-of select="$info_db_instance/name" />
								<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
								<xsl:value-of select="$db_given_name" />
							</xsl:attribute>
							<xsl:value-of select="$db_given_name" />
						</a>-->
						<xsl:call-template name="RenderInstanceLink">
							<xsl:with-param name="theSubjectInstance" select="$info_db_instance"/>
							<xsl:with-param name="theXML" select="$reposXML"/>
							<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
							<xsl:with-param name="displaySlot" select="'technology_instance_given_name'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:if test="not(count($info_db_tech_product))">-</xsl:if>
				<!--<xsl:value-of select="translate($info_db_tech_product/own_slot_value[slot_reference='product_label']/value, '::', '  ')" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$info_db_tech_product"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="translate($info_db_tech_product/own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($info_it_contact))">-</xsl:if>
				<!--<xsl:value-of select="$info_it_contact/own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$info_it_contact"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<!-- TEMPLATE TO CREATE THE DETAILS FOR DEPLOYED TECHNOLOGY INSTANCES -->
	<xsl:template match="node()" mode="Technology_Instance">
		<xsl:variable name="instance_given_name" select="own_slot_value[slot_reference = 'technology_instance_given_name']/value"/>
		<xsl:variable name="instance_basic_name" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="tech_runtme_status" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'technology_instance_deployment_status']/value]"/>
		<xsl:variable name="tech_instance_usage" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]"/>
		<xsl:variable name="instance_prod_role" select="/node()/simple_instance[name = $tech_instance_usage[name = current()/own_slot_value[slot_reference = 'instance_of_logical_tech_provider']/value]/own_slot_value[slot_reference = 'provider_as_role']/value]"/>
		<xsl:variable name="tech_product" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
		<xsl:variable name="tech_component" select="/node()/simple_instance[name = $instance_prod_role/own_slot_value[slot_reference = 'implementing_technology_component']/value]"/>

		<tr>
			<td>
				<!--<a>
					<xsl:attribute name="href">
						<xsl:text>report?XML=reportXML.xml&amp;XSL=technology/core_tech_instance_def.xsl&amp;PMA=</xsl:text>
						<xsl:value-of select="name" />
						<xsl:text>&amp;LABEL=Technology Instance - </xsl:text>
						<xsl:choose>
							<xsl:when test="not(string($instance_given_name))">
								<xsl:value-of select="$instance_basic_name" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$instance_given_name" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="not(string($instance_given_name))">
							<xsl:value-of select="$instance_basic_name" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$instance_given_name" />
						</xsl:otherwise>
					</xsl:choose>
				</a>-->

				<xsl:variable name="techInstanceName">
					<xsl:choose>
						<xsl:when test="not(string($instance_given_name))">
							<xsl:value-of select="$instance_basic_name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$instance_given_name"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="$techInstanceName"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="count(own_slot_value[slot_reference = 'description']/value) = 0">-</xsl:if>
				<xsl:call-template name="RenderMultiLangInstanceDescription">
					<xsl:with-param name="theSubjectInstance" select="current()"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($tech_runtme_status))">-</xsl:if>
				<xsl:value-of select="$tech_runtme_status/own_slot_value[slot_reference = 'enumeration_value']/value"/>
			</td>
			<td>
				<xsl:if test="not(count($tech_product))">-</xsl:if>
				<!--<xsl:value-of select="translate($tech_product/own_slot_value[slot_reference='product_label']/value, '::', '  ')" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$tech_product"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
					<xsl:with-param name="displayString" select="translate($tech_product/own_slot_value[slot_reference = 'product_label']/value, '::', '  ')"/>
				</xsl:call-template>
			</td>
			<td>
				<xsl:if test="not(count($tech_component))">-</xsl:if>
				<!--<xsl:value-of select="$tech_component/own_slot_value[slot_reference='name']/value" />-->
				<xsl:call-template name="RenderInstanceLink">
					<xsl:with-param name="theSubjectInstance" select="$tech_component"/>
					<xsl:with-param name="theXML" select="$reposXML"/>
					<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
				</xsl:call-template>
			</td>
		</tr>

	</xsl:template>
<xsl:template match="node()" mode="lifecyclesJSON">
    <xsl:variable name="thisLife" select="$lifecycles[name=current()/own_slot_value[slot_reference='lcm_lifecycle_status']/value]"/>
    {"id":"<xsl:value-of select="current()/name"/>","name":"<xsl:value-of select="$thisLife/own_slot_value[slot_reference='enumeration_value']/value"/>","date":"<xsl:value-of select="current()/own_slot_value[slot_reference='lcm_status_start_date_iso_8601']/value"/>","type":"<xsl:value-of select="$lifecycles[name=current()/own_slot_value[slot_reference='lcm_lifecycle_status']/value]/type"/>"},
    </xsl:template>

	<!--<!-\- TEMPLATE TO CREATE THE DETAILS FOR A SUPPORTING STRATEGIC PLAN  -\->
	<!-\- Given a reference (instance ID) to an element, find all its plans and render each -\->
	<xsl:template match="node()" mode="StrategicPlansForElement">
		<xsl:variable name="anElement">
			<xsl:value-of select="node()"/>
		</xsl:variable>
		<xsl:variable name="anActivePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Active_Plan')]"/>
		<xsl:variable name="aFuturePlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Future_Plan')]"/>
		<xsl:variable name="anOldPlan" select="/node()/simple_instance[type = 'Planning_Status' and (own_slot_value[slot_reference = 'name']/value = 'Old_Plan')]"/>
		<xsl:variable name="aStrategicPlanSet" select="/node()/simple_instance[own_slot_value[slot_reference = 'strategic_plan_for_element']/value = $anElement]"/>
		<!-\- Test to see if any plans are defined yet -\->
		<xsl:choose>
			<xsl:when test="count($aStrategicPlanSet) > 0">
				<!-\- Show active plans first -\->
				<!-\-<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference='strategic_plan_status']/value=$anActivePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anActivePlan/name" />
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the future -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference='strategic_plan_status']/value=$aFuturePlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$aFuturePlan/name" />
					</xsl:with-param>
				</xsl:apply-templates>
				<!-\- Then the old -\->
				<xsl:apply-templates select="$aStrategicPlanSet[own_slot_value[slot_reference='strategic_plan_status']/value=$anOldPlan/name]" mode="StrategicPlanDetailsTable">
					<xsl:with-param name="theStatus">
						<xsl:value-of select="$anOldPlan/name" />
					</xsl:with-param>
				</xsl:apply-templates>-\->

				<!-\- Then all other plans -\->
				<xsl:apply-templates select="$aStrategicPlanSet" mode="StrategicPlanDetailsTable">
					<xsl:sort select="own_slot_value[slot_reference = 'strategic_plan_status']/value"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<em>
					<xsl:value-of select="eas:i18n('No strategic plans defined for this element')"/>
				</em>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-\- Render the details of a particular strategic plan in a small table -\->
	<!-\- No details of plan inter-dependencies is presented here. However, a link 
        to the plan definition page is provided where those details will be shown -\->
	<xsl:template match="node()" mode="StrategicPlanDetailsTable">
		<xsl:param name="theStatus"/>
		<xsl:variable name="aStatusID" select="current()/own_slot_value[slot_reference = 'strategic_plan_status']/value"/>

		<!-\-	<xsl:if test="$aStatusID = $theStatus">-\->
		<table>

			<thead>
				<tr>
					<th>
						<xsl:value-of select="eas:i18n('Plan')"/>
					</th>
					<th>
						<xsl:value-of select="eas:i18n('Description')"/>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<strong>
							<xsl:call-template name="RenderInstanceLink">
								<xsl:with-param name="theSubjectInstance" select="current()"/>
								<xsl:with-param name="theXML" select="$reposXML"/>
								<xsl:with-param name="viewScopeTerms" select="$viewScopeTerms"/>
								<xsl:with-param name="displayString" select="translate(own_slot_value[slot_reference = 'name']/value, '::', ' ')"/>
							</xsl:call-template>
						</strong>
					</td>
					<td>
						<xsl:call-template name="RenderMultiLangInstanceDescription">
							<xsl:with-param name="theSubjectInstance" select="current()"/>
						</xsl:call-template>
					</td>
				</tr>
			</tbody>
		</table>
		<!-\-		</xsl:if>-\->
	</xsl:template>-->
	<xsl:function as="xs:float" name="eas:get_cost_components_total">
			<xsl:param name="costComponents"/>
			<xsl:param name="total"/>
			
			<xsl:choose>
				<xsl:when test="count($costComponents) > 0">
					<xsl:variable name="nextCost" select="$costComponents[1]"/>
					<xsl:variable name="newCostComponents" select="remove($costComponents, 1)"/>
					<xsl:variable name="costAmount" select="$nextCost/own_slot_value[slot_reference='cc_cost_amount']/value"/>
					<xsl:choose>
						<xsl:when test="$costAmount > 0">
							<xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total + number($costAmount))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="eas:get_cost_components_total($newCostComponents, $total)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$total"/></xsl:otherwise>
			</xsl:choose>
		</xsl:function>


</xsl:stylesheet>
