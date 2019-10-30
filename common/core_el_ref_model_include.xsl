<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:import href="../common/core_utilities.xsl"/>

	<xsl:template name="refModelLegendInclude">
		<script id="rag-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-brightred-120"/>
			<div class="keyLabel">High</div>
			<div class="keySampleWide bg-orange-120"/>
			<div class="keyLabel">Medium</div>
			<div class="keySampleWide bg-brightgreen-120"/>
			<div class="keyLabel">Low</div>
			<div class="keySampleWide bg-darkgrey"/>
			<div class="keyLabel">Undefined</div>
		</script>
		
		<script id="no-overlay-legend-template" type="text/x-handlebars-template">
			<div class="keyTitle">Legend:</div>
			<div class="keySampleWide bg-darkblue-80"/>
			<div class="keyLabel">{{inScope}}</div>
<!--			<div class="keySampleWide bg-lightgrey"/>
			<div class="keyLabel">No Supporting IT</div>-->
		</script>
		
	</xsl:template>

	
	<xsl:template name="busCapModelInclude">
		<script id="bcm-template" type="text/x-handlebars-template">
			<h3>{{{l0BusCapLink}}} Capabilities</h3>
			{{#each l1BusCaps}}					
				<div class="row">
					<div class="col-xs-12">
						<div class="refModel-l0-outer">
							<div class="refModel-l0-title fontBlack large">
								{{{busCapLink}}}
							</div>
							{{#l2BusCaps}}
								<!--<a href="#" class="text-default">-->
									<div class="busRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{busCapLink}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_popup</xsl:text></xsl:attribute>												
												<small>
													<p>{{busCapDescription}}</p>
													<h4>Supporting Applications</h4>
													<table class="table table-striped table-condensed">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																<th class="cellWidth-140"><xsl:value-of select="eas:i18n('Application Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{busCapId}}_app_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>
												</small>
											</div>
										</div>
									</div>
								<!--</a>-->
							{{/l2BusCaps}}
							<div class="clearfix"/>
						</div>
						{{#unless @last}}
							<div class="clearfix bottom-10"/>
						{{/unless}}
					</div>
				</div>
			{{/each}}				
		</script>
		<script id="bcm-buscap-popup-template" type="text/x-handlebars-template">
			{{#busCapApps}}			
				<tr>
					<td>{{{link}}}</td>
					<td>{{{description}}}</td>
					<td>{{count}}</td>
				</tr>
			{{/busCapApps}}
		</script>
	</xsl:template>
	
	
	<xsl:template name="appRefModelInclude">
		<script id="arm-template" type="text/x-handlebars-template">
			<div class="col-xs-4 col-md-3 col-lg-2" id="refLeftCol">
							{{#each left}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
													<div class="appRefModel-blob">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="cellWidth-140"><xsl:value-of select="eas:i18n('Application Count')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>											
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-6 col-lg-8 matchHeight1" id="refCenterCol">
							{{#each middle}}							
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
													<div class="appRefModel-blob">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="cellWidth-140"><xsl:value-of select="eas:i18n('Application Count')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>										
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
										{{#unless @last}}
											<div class="clearfix bottom-10"/>
										{{/unless}}
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-3 col-lg-2" id="refRightCol">
							{{#each right}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
												<a href="#" class="text-default">
													<div class="appRefModel-blob">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="cellWidth-140"><xsl:value-of select="eas:i18n('Application Count')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>
												</a>
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
		</script>
		<script id="arm-appcap-popup-template" type="text/x-handlebars-template">
			{{#appCapApps}}			
				<tr>
					<td>{{{link}}}</td>
					<td>{{{description}}}</td>
					<td>{{count}}</td>
				</tr>
			{{/appCapApps}}
		</script>
	</xsl:template>
	
	
	<xsl:template name="appRefModelComparisonInclude">
		<script id="arm-template" type="text/x-handlebars-template">
			<div class="col-xs-4 col-md-3 col-lg-2" id="refLeftCol">
							{{#each left}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
													<div class="appRefModel-blob noAppColour">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title text-midgrey">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="alignCentre small cellWidth-180 leftAppHeading"><xsl:value-of select="eas:i18n('Application 1')"/></th>
																				<th class="alignCentre small cellWidth-180 rightAppHeading"><xsl:value-of select="eas:i18n('Application 2')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>											
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-6 col-lg-8 matchHeight1" id="refCenterCol">
							{{#each middle}}							
								<div class="row">
									<div class="col-xs-12">
										<div class="refModel-l0-outer">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
													<div class="appRefModel-blob noAppColour">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="alignCentre small cellWidth-180 leftAppHeading"><xsl:value-of select="eas:i18n('Application 1')"/></th>
																				<th class="alignCentre small cellWidth-180 rightAppHeading"><xsl:value-of select="eas:i18n('Application 2')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>										
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
										{{#unless @last}}
											<div class="clearfix bottom-10"/>
										{{/unless}}
									</div>
								</div>
							{{/each}}
						</div>
						<div class="col-xs-4 col-md-3 col-lg-2" id="refRightCol">
							{{#each right}}
								<div class="row bottom-15">
									<div class="col-xs-12">
										<div class="refModel-l0-outer matchHeight1">
											<div class="refModel-l0-title fontBlack large">
												{{{link}}}
											</div>
											{{#childAppCaps}}
												<div class="appRefModel-blob noAppColour">
														<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
														<div class="refModel-blob-title">
															{{{link}}}
														</div>
														<div class="refModel-blob-info">
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
															<i class="fa fa-info-circle text-white"/>
															<div class="hiddenDiv">
																<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
																<small>
																	<p>{{description}}</p>
																	<h4>Applications</h4>
																	<table class="table table-striped table-condensed">
																		<thead>
																			<tr>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Application Service')"/></th>
																				<th class="small cellWidth-180"><xsl:value-of select="eas:i18n('Description')"/></th>
																				<th class="alignCentre small cellWidth-180 leftAppHeading"><xsl:value-of select="eas:i18n('Application 1')"/></th>
																				<th class="alignCentre small cellWidth-180 rightAppHeading"><xsl:value-of select="eas:i18n('Application 2')"/></th>
																			</tr>
																		</thead>
																		<tbody>
																			<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_app_rows</xsl:text></xsl:attribute>
																		</tbody>
																	</table>
																</small>
															</div>
														</div>
													</div>
											{{/childAppCaps}}
											<div class="clearfix"/>
										</div>
									</div>
								</div>
							{{/each}}
						</div>
		</script>
		<script id="arm-appcap-comparison-popup-template" type="text/x-handlebars-template">
			{{#appCapApps}}			
				<tr>
					<td>{{{link}}}</td>
					<td>{{{description}}}</td>
					<td class="alignCentre alignMiddle">{{#if leftAppImpl}}<div class="btn leftAppColour"/>{{/if}}</td>
					<td class="alignCentre alignMiddle">{{#if rightAppImpl}}<div class="btn rightAppColour"/>{{/if}}</td>
				</tr>
			{{/appCapApps}}
		</script>
	</xsl:template>
	
	
	
	<!-- RENDERS TRM WITH POPUP DETAIL INCLUDING TECHNOLOGY CAPABILITY DESCRIPTION AND PRODUC COUNTS FOR EACH TECH COMPONENT -->
	<xsl:template name="techRefModelInclude">
		<!--Top-->
		<script id="trm-template" type="text/x-handlebars-template">
			<div class="col-xs-12">
				{{#each top}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>					
											</div>
										</div>
									</div>								
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--Ends-->
			<!--Left-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each left}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Center-->
			<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
				{{#each middle}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
							{{#unless @last}}
								<div class="clearfix bottom-10"/>
							{{/unless}}
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Right-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each right}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Bottom-->
			<div class="col-xs-12">
				<div class="clearfix bottom-10"/>
				{{#each bottom}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_blob</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
													<p>{{description}}</p>
													<h4>Technology Products</h4>
													<table class="table table-striped table-condensed xsmall">
														<thead>
															<tr>
																<th class="cellWidth-180"><xsl:value-of select="eas:i18n('Technology Type')"/></th>
																<th class="alignCentre cellWidth-140"><xsl:value-of select="eas:i18n('Product Count')"/></th>
															</tr>
														</thead>
														<tbody>
															<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_techprod_rows</xsl:text></xsl:attribute>
														</tbody>
													</table>
												
											</div>
										</div>
									</div>							
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--Ends-->
		</script>
		
		<!-- Handlebars template for the contents of the popup table for a technology capability -->
		<script id="trm-techcap-popup-template" type="text/x-handlebars-template">
			{{#techCapProds}}			
				<tr>
					<td>{{{link}}}</td>
					<td class="alignCentre">{{count}}</td>
				</tr>
			{{/techCapProds}}
		</script>
	</xsl:template>
	
	
	<!-- RENDERS TRM WITH POPUP DETAIL INCLUDING ONLY TECHNOLOGY CAPABILITY DESCRIPTION -->
	<xsl:template name="techRefModelBasicInclude">
		<!--Top-->
		<script id="trm-template" type="text/x-handlebars-template">
			<div class="col-xs-12">
				{{#each top}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob bg-midgrey">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-refArch">
											{{#if isRelevant}}
												<i class="fa fa-sitemap text-white"/>
											{{/if}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
												<p>{{description}}</p>					
											</div>
										</div>
									</div>								
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
					<div class="clearfix bottom-10"/>
				{{/each}}
			</div>
			<!--Ends-->
			<!--Left-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each left}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob bg-midgrey">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-refArch">
											{{#if isRelevant}}
												<i class="fa fa-sitemap text-white"/>
											{{/if}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
												<p>{{description}}</p>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Center-->
			<div class="col-xs-4 col-md-6 col-lg-8 matchHeightTRM">
				{{#each middle}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob bg-midgrey">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-refArch">
											{{#if isRelevant}}
												<i class="fa fa-sitemap text-white"/>
											{{/if}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
												<p>{{description}}</p>											
											</div>
										</div>
									</div>
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
							{{#unless @last}}
								<div class="clearfix bottom-10"/>
							{{/unless}}
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Right-->
			<div class="col-xs-4 col-md-3 col-lg-2">
				{{#each right}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeightTRM">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob bg-midgrey">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-refArch">
											{{#if isRelevant}}
												<i class="fa fa-sitemap text-white"/>
											{{/if}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
												<p>{{description}}</p>											
											</div>
										</div>
									</div>				
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--ends-->
			<!--Bottom-->
			<div class="col-xs-12">
				<div class="clearfix bottom-10"/>
				{{#each bottom}}
					<div class="row">
						<div class="col-xs-12">
							<div class="refModel-l0-outer matchHeight2">
								<div class="refModel-l0-title fontBlack large">
									{{{link}}}
								</div>
								{{#childTechCaps}}
									<div class="techRefModel-blob bg-midgrey">
										<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}</xsl:text></xsl:attribute>
										<div class="refModel-blob-title">
											{{{link}}}
										</div>
										<div class="refModel-blob-refArch">
											{{#if isRelevant}}
												<i class="fa fa-sitemap text-white"/>
											{{/if}}
										</div>
										<div class="refModel-blob-info">
											<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_info</xsl:text></xsl:attribute>
											<i class="fa fa-info-circle text-white"/>
											<div class="hiddenDiv">
												<xsl:attribute name="id"><xsl:text disable-output-escaping="yes">{{id}}_popup</xsl:text></xsl:attribute>
												<p>{{description}}</p>
											</div>
										</div>
									</div>							
								{{/childTechCaps}}
								<div class="clearfix"/>
							</div>
						</div>
					</div>
				{{/each}}
			</div>
			<!--Ends-->
		</script>
	</xsl:template>
	


	<xsl:template name="gdpBusCapModelInclude">
		<xsl:call-template name="refModelStyles"/>
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
		<xsl:call-template name="refModelStyles"/>
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
		<xsl:call-template name="refModelStyles"/>
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
							{{#if noImpact}}
							  	<td><button class="bg-lightgrey btn btn-block">Not Assessed</button></td>
							{{/if}}
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
		<xsl:call-template name="refModelStyles"/>
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

	<xsl:template name="refModelStyles">
		<!--Reference Model Styles-->
		<style>
					.refModel-l0-outer{
						<!--background-color: pink;-->
						border: 1px solid #aaa;
						padding: 10px 10px 0px 10px;
						border-radius: 4px;
						background-color: #eee;
					}
					
					.refModel-l0-title{
						margin-bottom: 5px;
						line-height: 1.1em;
					}
					
					.refModel-l1-outer{
						border: 1px solid #aaa;
						border-radius: 4px;
						margin-bottom: 10px;
					}
					
					.refModel-l1-inner{
						background-color: #fff;
						padding: 10px;
					}
					
					.refModel-l1-title{
						line-height: 1.1em;
						padding: 5px 10px;
					}
					
					.refModel-blob, .busRefModel-blob, .appRefModel-blob, .techRefModel-blob {
						display: flex;
						align-items: center;
						justify-content: center;
						width: 120px;
						max-width: 120px;
						height: 50px;
						padding: 3px;
						max-height: 50px;
						overflow: hidden;
						border: 1px solid #aaa;
						border-radius: 4px;
						float: left;
						margin-right: 10px;
						margin-bottom: 10px;
						text-align: center;
						font-size: 12px;
						position: relative;

					}
					
					.appRefModel-blob a {
						color: white;
					}
					
					.busRefModel-blob a {
						color: white;
					}
					
					.techRefModel-blob a {
						color: white;
					}
					
					.refModel-l1-title a {
						color: white !important;
					}
					
					.bg-lightgrey a {
						color: #333 !important;
					}
					
					.refModel-blob:hover {border: 2px solid #666;}
					
					.refModel-blob-title{
						line-height: 1em;
					
					}
					.refModel-blob-info {
						position: absolute;
						bottom: 0px;
						right: 2px;
					}
					.refModel-blob-refArch {
						position: absolute;
						bottom: 0px;
						left: 2px;
					}
					
				</style>
		<!--Ends-->
	</xsl:template>



</xsl:stylesheet>
