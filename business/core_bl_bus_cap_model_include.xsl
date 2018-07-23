<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<!--<xsl:import href="../../common/core_utilities.xsl"/>
-->
	<!--<xsl:variable name="allBusCaps" select="/node()/simple_instance[type = 'Business_Capability']"/>
	<xsl:variable name="allBusProcesses" select="/node()/simple_instance[type = 'Business_Process']"/>
	<xsl:variable name="allReportConstants" select="/node()/simple_instance[type = 'Report_Constant']"/>
	<xsl:variable name="rootBusCapConstant" select="$allReportConstants[own_slot_value[slot_reference = 'name']/value = 'Root Business Capability']"/>
	<xsl:variable name="rootBusCap" select="$allBusCaps[name = $rootBusCapConstant/own_slot_value[slot_reference = 'report_constant_ea_elements']/value]"/>
	<xsl:variable name="L0Caps" select="$allBusCaps[name = $rootBusCap/own_slot_value[slot_reference = 'contained_business_capabilities']/value]"/>-->

	<xsl:template name="gdpBusCapModelInclude">
		<xsl:call-template name="capModelStyles"/>
		<script id="bcm-template" type="text/x-handlebars-template">
				<h3 class="fontBold">
					{{{l0BusCapLink}}}
					<span class="text-default"> Business Capabilities</span>
				</h3>
				{{#l1BusCaps}}
					<div class="L0_Cap bg-offwhite">
						<h4 class="fontSemi">{{{busCapLink}}}</h4>
						{{#l2BusCaps}}
							<div class="L1Cap_Outer">
								<div class="L1Cap_Box bg-white">
									<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_blob</xsl:text></xsl:attribute>
									<div class="L1_CapLabel">
										{{{busCapLink}}}
										<!--<a>
											<xsl:attribute name="href"><xsl:text disable-output-escaping="yes">{{{busCapLink}}}</xsl:text></xsl:attribute>
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_link</xsl:text></xsl:attribute>
											{{busCapName}}
										</a>-->
									</div>
									<div class="chartInfoButton">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_info</xsl:text></xsl:attribute>
										<i class="fa fa-info-circle"/>
									</div>
									<div class="hiddenDiv">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_popup</xsl:text></xsl:attribute>
										<small><h4>Data Usage</h4>
										<table class="table table-striped table-condensed">
											<thead>
												<tr>
													<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Data Type')"/></th>
													<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('Permitted?')"/></th>
													<th class="cellWidth-240"><xsl:value-of select="eas:i18n('Legal Basis')"/></th>
												</tr>
											</thead>
											<tbody>
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_datarows</xsl:text></xsl:attribute>
											</tbody>
										</table></small>
									</div>
								</div>
							</div>
						{{/l2BusCaps}}	
					</div>		
				{{/l1BusCaps}}	
		</script>
		<script id="bcm-popup-template" type="text/x-handlebars-template">
			{{#dataUsed}}			
				<tr>
					<td>{{{dataObjectLink}}}</td>
					{{#if isPermitted}}
					  	<td><button class="backColourGreen btn btn-block">Yes</button></td>
					{{else}}
					  	<td><button class="backColourRed btn btn-block">No</button></td>
					{{/if}}
					{{#if isPermitted}}
					  	<td><ul>{{#legalBases}}<li><span>{{{legalBasisLink}}} - </span> {{legalBasisDesc}}</li>{{/legalBases}}</ul></td>
					{{else}}
					  	<td><em>n/a</em></td>
					{{/if}}
				</tr>
			{{/dataUsed}}
		</script>

		<div class="capModelOuter bg-aqua-20 top-20" id="bcm"/>

	</xsl:template>


	<xsl:template name="gdpComplianceBusCapModelInclude">
		<xsl:call-template name="capModelStyles"/>
		<script id="bcm-template" type="text/x-handlebars-template">
						<h3 class="fontBold">
							{{{l0BusCapLink}}}
							<span class="text-default"> Business Capabilities</span>
						</h3>
						{{#l1BusCaps}}
							<div class="L0_Cap bg-offwhite">
								<h4 class="fontSemi">{{{busCapLink}}}</h4>
								{{#l2BusCaps}}
									<div class="L1Cap_Outer">
										<div class="L1Cap_Box bg-white">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_blob</xsl:text></xsl:attribute>
											<div class="L1_CapLabel">{{{busCapLink}}}</div>
											{{#if nonCompliantTotal}}
												<div class="capWarning">
													<i class="fa fa-warning textColourRed"/>
												</div>
												<div class="hiddenDiv">
													<h4 class="text-primary">Warning</h4>
													<ul class="fa-ul">
														<!--<li><i class="fa fa-li fa-warning textColourRed"/>USAGE TEXT</li>
														<li><i class="fa fa-li fa-warning textColourOrange"/>SECURITY TEXT</li>-->
													</ul>
												</div>
											{{/if}}
										</div>
										<div class="L1Cap_BottomHeatmapOuter">
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usage</xsl:text></xsl:attribute>Usage</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute>
													<small><h4>Data Usage</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Data Type')"/></th>
																<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('Permitted?')"/></th>
																<th class="cellWidth-240"><xsl:value-of select="eas:i18n('Legal Basis')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_datarows</xsl:text></xsl:attribute>
														</tbody>
													</table></small>		
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_security</xsl:text></xsl:attribute>Security</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_securitypopup</xsl:text></xsl:attribute>
													<small>
														<h4>Supporting Applications</h4>
														<table class="table table-striped table-condensed">
															<thead>
																<tr>
																	<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application')"/></th>
																	<th class="cellWidth-200"><xsl:value-of select="eas:i18n('Description')"/></th>
																	<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('Compliance Level')"/></th>
																</tr>
															</thead>
															<tbody>
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_appsecrows</xsl:text></xsl:attribute>
															</tbody>
														</table>
													</small>
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
										</div>
									</div>
								{{/l2BusCaps}}
							</div>
						{{/l1BusCaps}}
					
				</script>
		<script id="bcm-popup-template" type="text/x-handlebars-template">
					{{#dataUsed}}			
						<tr>
							<td>{{{dataObjectLink}}}</td>
							{{#if isPermitted}}
							  	<td><button class="backColourGreen btn btn-block">Yes</button></td>
							{{else}}
							  	<td><button class="backColourRed btn btn-block">No</button></td>
							{{/if}}
							{{#if isPermitted}}
							  	<td><ul>{{#legalBases}}<li><span>{{{legalBasisLink}}} - </span> {{legalBasisDesc}}</li>{{/legalBases}}</ul></td>
							{{else}}
							  	<td><em>n/a</em></td>
							{{/if}}
						</tr>
					{{/dataUsed}}
				</script>
		<script id="bcm-appsecpopup-template" type="text/x-handlebars-template">
					{{#supportingApps}}			
						<tr>
							<td>{{{appLink}}}</td>
							<td>{{appDesc}}</td>
							{{#if highCompliance}}
							  	<td><button class="backColourGreen btn btn-block btn-sm">High</button></td>
							{{else if medCompliance}}
							  	<td><button class="backColourOrange btn btn-block btn-sm">Medium</button></td>
							{{else if noCompliance}}
							  	<td><button class="bg-lightgrey btn btn-block btn-sm">Not Assessed</button></td>
							{{else}}
							  	<td><button class="backColourRed btn btn-block btn-sm">Low</button></td>
							{{/if}}
						</tr>
					{{/supportingApps}}
				</script>

		<div class="capModelOuter bg-aqua-20 top-20" id="bcm"/>
	</xsl:template>


	<xsl:template name="gdpSecComplianceBusCapModelInclude">
		<xsl:call-template name="capModelStyles"/>
		<script id="bcm-template" type="text/x-handlebars-template">
						<h3 class="fontBold">
							{{{l0BusCapLink}}}
							<span class="text-default"> Business Capabilities</span>
						</h3>
						{{#l1BusCaps}}
							<div class="L0_Cap bg-offwhite">
								<h4 class="fontSemi">{{{busCapLink}}}</h4>
								{{#l2BusCaps}}
									<div class="L1Cap_Outer">
										<div class="L1Cap_Box bg-white">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_blob</xsl:text></xsl:attribute>
											<div class="L1_CapLabel">{{{busCapLink}}}</div>
										</div>
										<div class="L1Cap_BottomHeatmapOuter">
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usage</xsl:text></xsl:attribute>CIA Loss</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute>
													<small><h4>Data Usage</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Data Type')"/></th>
																<th class="cellWidth-200"><xsl:value-of select="eas:i18n('Description')"/></th>
																<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('CIA Loss Impact')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_datarows</xsl:text></xsl:attribute>
														</tbody>
													</table></small>		
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_security</xsl:text></xsl:attribute>Security</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_securitypopup</xsl:text></xsl:attribute>
													<small><h4>Supporting Applications</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application')"/></th>
																<th class="cellWidth-200"><xsl:value-of select="eas:i18n('Description')"/></th>
																<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('Compliance Level')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_appsecrows</xsl:text></xsl:attribute>
														</tbody>
													</table></small>
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
										</div>
									</div>
								{{/l2BusCaps}}
							</div>
						{{/l1BusCaps}}
					
				</script>
		<script id="bcm-popup-template" type="text/x-handlebars-template">
					{{#dataUsed}}			
						<tr>
							<td>{{{dataObjectLink}}}</td>
							<td>{{description}}</td>
							{{#if lowImpact}}
							  	<td><button class="backColourGreen btn btn-block">Low</button></td>
							{{/if}}
							{{#if medImpact}}
							  	<td><button class="backColourOrange btn btn-block">Medium</button></td>
							{{/if}}
							{{#if highImpact}}
							  	<td><button class="backColourRed btn btn-block">High</button></td>
							{{/if}}
						</tr>
					{{/dataUsed}}
				</script>
		<script id="bcm-appsecpopup-template" type="text/x-handlebars-template">
					{{#supportingApps}}			
						<tr>
							<td>{{{appLink}}}</td>
							<td>{{appDesc}}</td>
							{{#if highCompliance}}
							  	<td><button class="backColourGreen btn btn-block">High</button></td>
							{{else if medCompliance}}
							  	<td><button class="backColourOrange btn btn-block">Medium</button></td>
							{{else if noCompliance}}
							  	<td><button class="bg-lightgrey btn btn-block btn-block">Not Assessed</button></td>
							{{else}}
							  	<td><button class="backColourRed btn btn-block">Low</button></td>
							{{/if}}
						</tr>
					{{/supportingApps}}
				</script>

		<div class="capModelOuter bg-aqua-20 top-20" id="bcm"/>
	</xsl:template>



	<xsl:template name="gdpScopingBusCapModelInclude">
		<xsl:param name="showUnused" select="true()"/>
		<xsl:call-template name="capModelStyles"/>
		<script id="bcm-template" type="text/x-handlebars-template">
						<h3 class="fontBold">
							{{{l0BusCapLink}}}
							<span class="text-default"> Business Capabilities</span>
						</h3>
						{{#l1BusCaps}}
							<div class="L0_Cap bg-offwhite">
								<h4 class="fontSemi">{{{busCapLink}}}</h4>
								{{#l2BusCaps}}
									<div class="L1Cap_Outer">
										<div class="L1Cap_Box bg-white">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_blob</xsl:text></xsl:attribute>
											<div class="L1_CapLabel">{{{busCapLink}}}</div>
										</div>
										<div class="L1Cap_BottomHeatmapOuter">
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usage</xsl:text></xsl:attribute>Usage</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute>
													<small><h4>Data Used</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-100"><xsl:value-of select="eas:i18n('Data Type')"/></th>
																<th class="cellWidth-100 alignCentre"><xsl:value-of select="eas:i18n('Permitted?')"/></th>
																<th class="cellWidth-100"><xsl:value-of select="eas:i18n('Legal Basis')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_datarows</xsl:text></xsl:attribute>
														</tbody>
													</table></small>
													<xsl:if test="$showUnused">
														<small><h4>Unused Data</h4>
														<table class="table table-striped table-condensed">
															<thead>
																<tr>
																	<th class="cellWidth-120"><xsl:value-of select="eas:i18n('Data Type')"/></th>
																	<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Legal Basis')"/></th>
																</tr>
															</thead>
															<tbody>
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_unuseddatarows</xsl:text></xsl:attribute>
															</tbody>
														</table></small>
													</xsl:if>
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
											<div class="L1Cap_BottomHeatmapElement_2 bg-lightgrey"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_security</xsl:text></xsl:attribute>Security</div>
											{{#if inScope}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_securitypopup</xsl:text></xsl:attribute>
													<small><h4>Supporting Applications</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application')"/></th>
																<th class="cellWidth-200"><xsl:value-of select="eas:i18n('Description')"/></th>
																<th class="cellWidth-180 alignCentre"><xsl:value-of select="eas:i18n('Compliance Level')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_appsecrows</xsl:text></xsl:attribute>
														</tbody>
													</table></small>
												</div>
											{{else}}
												<div class="hiddenDiv"><xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_usagepopup</xsl:text></xsl:attribute><em>Out of Scope</em></div>
											{{/if}}
										</div>
									</div>
								{{/l2BusCaps}}
							</div>
						{{/l1BusCaps}}
					
				</script>
		<script id="bcm-popup-template" type="text/x-handlebars-template">
							{{#dataUsed}}			
								<tr>
									<td>{{{dataObjectLink}}}</td>
									{{#if isPermitted}}
									  	<td><button class="backColourGreen btn btn-block">Yes</button></td>
									{{else}}
									  	<td><button class="backColourRed btn btn-block">No</button></td>
									{{/if}}
									{{#if isPermitted}}
									  	<td><ul>{{#legalBases}}<li><span>{{{legalBasisLink}}} - </span> {{legalBasisDesc}}</li>{{/legalBases}}</ul></td>
									{{else}}
									  	<td><em>n/a</em></td>
									{{/if}}
								</tr>
							{{/dataUsed}}
				</script>
		<script id="bcm-unused-data-popup-template" type="text/x-handlebars-template">
							{{#unusedData}}			
								<tr>
									<td>{{{dataObjectLink}}}</td>
									<td><ul>{{#legalBases}}<li><span>{{{legalBasisLink}}} - </span> {{legalBasisDesc}}</li>{{/legalBases}}</ul></td>
								</tr>
							{{/unusedData}}
						</script>
		<script id="bcm-appsecpopup-template" type="text/x-handlebars-template">
					{{#supportingApps}}			
						<tr>
							<td>{{{appLink}}}</td>
							<td>{{appDesc}}</td>
							{{#if highCompliance}}
							  	<td><button class="backColourGreen btn btn-block">High</button></td>
							{{else if medCompliance}}
							  	<td><button class="backColourOrange btn btn-block">Medium</button></td>
							{{else if noCompliance}}
							  	<td><button class="bg-lightgrey btn btn-block btn-block">Not Assessed</button></td>
							{{else}}
							  	<td><button class="backColourRed btn btn-block">Low</button></td>
							{{/if}}
						</tr>
					{{/supportingApps}}
				</script>

		<div class="capModelOuter bg-aqua-20 top-20" id="bcm"/>
	</xsl:template>

	<xsl:template name="capModelStyles">
		<style>
			.popover {
				max-width: 800px;
			}
			.capModelOuter{
				border: 1px solid #aaa;
				border-radius: 8px;
				padding: 15px;
				float: left;
			}
			
			.L0_Cap{
				padding-left: 15px;
				border: 1px solid #666;
				border-radius: 4px;
				float: left;
				margin-bottom: 20px;
				position: relative;
				width: 100%;
			}
			
			.L1Cap_Outer{
				width: 140px;
				float: left;
				margin: 0 15px 15px 0;
			}
			
			.L1Cap_Box{
				width: 100%;
				height: 60px;
				padding: 5px;
				text-align: center;
				border: 1px solid #999;
				position: relative;
				display: table;
			}
			
			.L1_CapLabel{
				display: table-cell;
				vertical-align: middle;
				line-height: 1.1em;
			}
			
			.capModelOuter{
				border: 1px solid #aaa;
				border-radius: 8px;
				padding: 15px;
				float: left;
			}
			
			.L0_Cap{
				padding-left: 15px;
				border: 1px solid #666;
				border-radius: 4px;
				float: left;
				margin-bottom: 20px;
				position: relative;
				width: 100%;
			}
			
			.L1Cap_Outer{
				width: 140px;
				float: left;
				margin: 0 15px 15px 0;
			}
			
			.L1Cap_Box{
				width: 100%;
				height: 50px;
				padding: 5px;
				text-align: center;
				border: 1px solid #999;
				position: relative;
				display: table;
			}
			
			.L1_CapLabel{
				display: table-cell;
				vertical-align: middle;
				line-height: 1.1em;
			}
			
			.L1Cap_BottomHeatmapOuter{
				width: 100%;
				height: 20px;
				border: 1px solid #999;
				border-top: none;
			}
			
			.L1Cap_BottomHeatmapElement{
				width: calc(100%/12);
				height: 100%;
				border-right: 1px solid #fff;
				float: left;
			}
			
			.L1Cap_BottomHeatmapElement_2{
				width: calc(100%/2);
				height: 100%;
				float: left;
				text-align: center;
			}
			
			.L1Cap_BottomHeatmapElement_2_divider {
				border-left: 1px solid #666;
			}
			
			.L1Cap_BottomHeatmapElement_2:hover{
				cursor: pointer;
			}
			
			.capWarning{
				position: absolute;
				right: -4px;
				top: -8px;
			}</style>

	</xsl:template>



</xsl:stylesheet>
