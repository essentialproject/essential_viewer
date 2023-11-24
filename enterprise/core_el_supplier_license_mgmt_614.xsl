<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview">
	<xsl:include href="../common/core_doctype.xsl"/>
	<xsl:include href="../common/core_common_head_content.xsl"/>
	<xsl:include href="../common/core_header.xsl"/>
	<xsl:include href="../common/core_footer.xsl"/>
	<xsl:include href="../common/core_external_doc_ref.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="param1"/>

	<!-- START GENERIC PARAMETERS -->
	<xsl:param name="viewScopeTermIds"/>

	<!-- END GENERIC PARAMETERS -->

	<!-- START GENERIC LINK VARIABLES -->
	<xsl:variable name="viewScopeTerms" select="eas:get_scoping_terms_from_string($viewScopeTermIds)"/>
	<xsl:variable name="linkClasses" select="('Business_Capability', 'Application_Provider')"/>
	<!-- END GENERIC LINK VARIABLES -->

	<xsl:variable name="organisationITUsers" select="/node()/simple_instance[type = 'Group_Business_Role'][own_slot_value[slot_reference = 'name']/value = ('Application Organisation User','Application User') or own_slot_value[slot_reference = 'name']/value = 'Technology Organisation User']"/>
	<xsl:variable name="allActorNames" select="/node()/simple_instance[type = 'Group_Actor']"/>
	<xsl:variable name="allTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="allActors" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_from_actor']/value = $allActorNames/name]"/>
	<xsl:variable name="actorPlayingRole" select="/node()/simple_instance[type = 'ACTOR_TO_ROLE_RELATION'][own_slot_value[slot_reference = 'act_to_role_to_role']/value = $organisationITUsers/name]"/>
	<xsl:variable name="technologyProducts" select="/node()/simple_instance[type = 'Technology_Product']"/>
	<xsl:variable name="tprsForTechnologyProducts" select="/node()/simple_instance[type = 'Technology_Product_Role']"/>
	<xsl:variable name="technologyComponents" select="/node()/simple_instance[type = 'Technology_Component'][own_slot_value[slot_reference = 'realised_by_technology_products']/value = $tprsForTechnologyProducts/name]"/>
	<xsl:variable name="applications" select="/node()/simple_instance[type = ('Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="aprs" select="/node()/simple_instance[type = 'Application_Provider_Role'][own_slot_value[slot_reference = 'role_for_application_provider']/value = $applications/name]"/>
    <xsl:variable name="services" select="/node()/simple_instance[type = ('Application_Service','Composite_Application_Service')][own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $aprs/name]"/>
	<xsl:variable name="allSuppliers" select="/node()/simple_instance[type = 'Supplier']"/>
	<xsl:variable name="supplier" select="$allSuppliers[$applications/own_slot_value[slot_reference = 'ap_supplier']/value = name or $technologyProducts/own_slot_value[slot_reference = 'supplier_technology_product']/value = name]"/>
	<xsl:variable name="supplierRelStatii" select="/node()/simple_instance[name = $allSuppliers/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
<!--	<xsl:variable name="supplierContracts" select="/node()/simple_instance[type = 'OBLIGATION_COMPONENT_RELATION']"/>[own_slot_value[slot_reference = 'obligation_component_to_element']/value = $technologyProducts/name or own_slot_value[slot_reference = 'obligation_component_to_element']/value = $applications/name]-->
	
	<xsl:variable name="allContracts" select="/node()/simple_instance[type='Contract']"/>
	<xsl:variable name="allContractToElementRels" select="/node()/simple_instance[name = $allContracts/own_slot_value[slot_reference = 'contract_for']/value]"/>
	<xsl:variable name="allContractElements" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'contract_component_to_element']/value]"/>
	<xsl:variable name="allLicenses" select="/node()/simple_instance[name = $allContractToElementRels/own_slot_value[slot_reference = 'ccr_license']/value]"/>
	<xsl:variable name="allRenewalModels" select="/node()/simple_instance[type='Contract_Renewal_Model']"/>
	
	<!--<xsl:variable name="alllicenses" select="/node()/simple_instance[type = 'License']"/>
	<xsl:variable name="contracts" select="/node()/simple_instance[type = 'Compliance_Obligation'][own_slot_value[slot_reference = 'compliance_obligation_licenses']/value = $alllicenses/name]"/>
    
	<xsl:variable name="licenses" select="/node()/simple_instance[type = 'License'][name = $contracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
	<xsl:variable name="actualContracts" select="/node()/simple_instance[type = 'Contract'][own_slot_value[slot_reference = 'contract_uses_license']/value = $licenses/name]"/>-->
	<xsl:variable name="licenseType" select="/node()/simple_instance[type = 'License_Type']"/>
	
	<xsl:variable name="viewerPrimaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'primary_header_colour_viewer']/value"/>
	<xsl:variable name="viewerSecondaryHeader" select="$activeViewerStyle/own_slot_value[slot_reference = 'secondary_header_colour_viewer']/value"/>
	<xsl:variable name="vIcon" select="$activeViewerStyle/own_slot_value[slot_reference = 'viewer_icon_colour']/value"/>
	
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


	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/>
                <xsl:call-template name="RenderModalReportContent"><xsl:with-param name="essModalClassNames" select="$linkClasses"/></xsl:call-template>
				<!-- Searchable Select Box Libraries and Styles -->
				<link href="js/select2/css/select2.min.css?release=6.19" rel="stylesheet"/>
				<script src="js/select2/js/select2.min.js?release=6.19"/>
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Supplier License Management</title>
				<style>
					.supplier{
						border: 1pt solid #d3d3d3;
						border-radius: 3px;
						box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
						margin: 4px 0px;
						background-color: #fff;
						border-left: 3pt solid #333;
						padding: 3px;
					}
					
					#supplier-summary-table > tbody > tr > th{
						width: 25%;
						background-color: #eee;
					}
					
					#supplier-summary-table > tbody > tr > th,
					#supplier-summary-table > tbody > tr > td{
						font-size: 1.2em;
						padding: 5px;
					}
					
					#supplier-summary-table {
						border-collapse: separate;
						border-spacing: 0 5px; 
					}
					
					.dateHeader {
						font-weight: bold;
						text-align: center;
					}
					
					.intro{
						background-color: #aaa;
						color: #ffffff;
						padding: 5px;
					}
					
					.detail{
						background-color: #f7f7f7;
						margin: 2px;
					}
					
					.licenceInfo{
						border: 1pt solid #ccc;
						border-radius: 4px;
						padding: 3px;
						float: left;
					}
					.licenceInfo.potentials{min-width:40px}
					.licenceInfo.contract{min-width:150px}
					.licenceInfo.type{min-width:100px}
					.licenceInfo.date{min-width:100px}
					.licenceInfo.poss{text-align: center; min-width: 30px;}
					
					.product{
						border: 1pt solid #aaa;
						border-radius: 4px;
						box-shadow: 0px 1px 2px 0px hsla(0, 0%, 0%, 0.25);
						margin: 0 0 5px 0;
						padding: 5px;
						float: left;
						width: 100%;
					}
					
					#mnths{
						margin-bottom: 4px;
					}
					
					.monthView{
						margin-bottom: 4px;
					}
					
					.costcolumn{
						font-size: 14pt;
					}
					
					.dateBlock{
						height: 15px;
						border: 1pt solid #d3d3d3
					}
					
					#candidateLicenses{
						display: flex;
						flex-direction: column;
					}
					
					.supplier.active {
						border-left: 3pt solid <xsl:value-of select="$vIcon"/>;
					}
				
				</style>
			</head>
			<body>
				<!-- ADD THE PAGE HEADING -->
				<xsl:call-template name="Heading"/>

				<!--ADD THE CONTENT-->
				<div class="container-fluid">
					<div class="row">
						<div class="col-xs-12">
							<h1 class="text-primary"><xsl:value-of select="eas:i18n('Supplier License Management')"/></h1>
							<hr/>
						</div>
						<div class="col-xs-12">
							<ul class="nav nav-tabs">
								<li class="active">
									<a data-toggle="tab" href="#supplier"><xsl:value-of select="eas:i18n('Suppliers')"/></a>
								</li>
								
								<li>
									<a data-toggle="tab" href="#analysis"><xsl:value-of select="eas:i18n('Analysis')"/></a>
								</li>
                                <li>
									<a data-toggle="tab" href="#license">12 Month View</a>
								</li>
							</ul>
                <br/>
							<div class="tab-content">
								<div id="supplier" class="tab-pane fade in active">
									<h3 class="strong"><xsl:value-of select="eas:i18n('Suppliers')"/></h3>
									<div class="row">
										<div class="col-md-4" style="overflow-y:scroll;max-height:400px">
											<div><strong class="right-10"><xsl:value-of select="eas:i18n('Filter')"/>:</strong><input type="text" id="supplierFilter"/></div>
											<div id="form" class="top-15"/>
										</div>
										<div class="col-md-8">
											<div id="supplierSummary"/>
										</div>
									</div>
								</div>
								<div id="license" class="tab-pane fade">
									<h3 class="strong"><xsl:value-of select="eas:i18n('License Renewal')"/> - <xsl:value-of select="eas:i18n('12 Month Outlook')"/></h3>
									<div class="row">
										<div class="col-xs-3 bottom-10">
											<strong class="right-10"><xsl:value-of select="eas:i18n('Supplier Filter')"/>:</strong>
											<select id="pickSuppliers" style="width:200px;">
												<option name="All">All</option>
												<xsl:apply-templates select="$supplier" mode="supplierOptions">
													<xsl:sort select="own_slot_value[slot_reference = 'name']/value" order="ascending"/>
												</xsl:apply-templates>
											</select>
										</div>
										<div class="col-xs-9">
											<div class="productKey bottom-10 pull-right">
												<div class="keyTitle">Legend:</div>
												<div class="keySampleWide bg-brightgreen-100"/>
												<div class="keyLabel"><xsl:value-of select="eas:i18n('Contract Review Date')"/></div>
												<div class="keySampleWide bg-orange-100"/>
												<div class="keyLabel"><xsl:value-of select="eas:i18n('Minimum Cancellation Notice')"/></div>												
												<div class="keySampleWide bg-brightred-100"/>
												<div class="keyLabel"><xsl:value-of select="eas:i18n('Contract Renewal Date')"/></div>
											</div>
										</div>
										<div class="col-xs-3"/>
										<div class="col-xs-9">
											<div id="mnths" class="row"/>
										</div>
										<div id="datePane"/>
									</div>
								</div>
								<div id="analysis" class="tab-pane fade">
									<h3 class="strong"><xsl:value-of select="eas:i18n('Analysis')"/></h3>
									<div class="row">
										<div class="col-md-4">
											<div class="intro strong large"><xsl:value-of select="eas:i18n('Current Product')"/></div>
										</div>
										<div class="col-md-4">
											<div class="intro strong large"><xsl:value-of select="eas:i18n('Potential Replacement')"/></div>
										</div>
										<div class="col-md-4">
											<div class="intro strong large"><xsl:value-of select="eas:i18n('Savings')"/></div>
										</div>
										<div class="col-xs-12">
											<div id="analysisPane"/>
										</div>
									</div>
								</div>
							</div>

						</div>
					</div>
				</div>


				<!-- Modal -->
				<div class="modal fade" id="Modal" tabindex="-1" role="dialog" aria-hidden="true">
					<div class="modal-dialog modal-dialog-centered modal-lg" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h3 class="modal-title"><xsl:value-of select="eas:i18n('Potential Candidates')"/></h3>
							</div>
							<div class="modal-body" id="candidateLicenses">
							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-default" data-dismiss="modal"><xsl:value-of select="eas:i18n('Close')"/></button>
							</div>
						</div>
					</div>
				</div>
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
				 
			</body>

<script>
	    
	    var month=new Date().getMonth();    
	        
	        supplierJSON=[<xsl:apply-templates select="$supplier" mode="supplierList">
	                                        <xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/>
	                                    </xsl:apply-templates>];  
	        productJSON=[<xsl:apply-templates select="$technologyProducts" mode="productList">
	                                        <xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/>
	                                    </xsl:apply-templates>,<xsl:apply-templates select="$applications" mode="productList">
	                                        <xsl:sort order="ascending" select="own_slot_value[slot_reference='name']/value"/>
	                                    </xsl:apply-templates>];
	
	        
	        monthsList=['Jan','Feb','Mar','Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
	         var appCardTemplate;
	         var focusSupplier;
	         var focusProduct;
	         var today= new Date();
	    
	        $(document).ready(function() {                            
		        var supplierCardFragment = $("#supplier-card-template").html();
		        supplierTemplate = Handlebars.compile(supplierCardFragment);
		
		        var supplierSummaryCardFragment = $("#supplier-summary-template").html();
		        supplierTemplate = Handlebars.compile(supplierCardFragment);
		        supplierSummaryTemplate = Handlebars.compile(supplierSummaryCardFragment); 
		
		        var productCardFragment = $("#product-template").html();
		        productTemplate = Handlebars.compile(productCardFragment);
		
		        var analysisCardFragment = $("#analysis-template").html();
		        analysisTemplate = Handlebars.compile(analysisCardFragment);
		    
		        var datesFragment = $("#date-template").html();
		        dateTemplate = Handlebars.compile(datesFragment);
	    
	       		$('#form').append(supplierTemplate(supplierJSON)); 
	       		
	       		$('#pickSuppliers').select2({
			        //allowClear: true,
			        placeholder: "Suppliers",
			        theme: "bootstrap"
			    });
	
	
				//add event listener for filtering suppliers
			   $('#supplierFilter').on( 'keyup change', function () {
		            var textVal = $(this).val().toLowerCase();
		            $('.supplier').each(function(i, obj) {
		                 $(this).show();
		                 if(textVal != null) {
		                     var itemName = $(this).text().toLowerCase();
		                     if(!(itemName.includes(textVal))) {
		                         $(this).hide();
		                     }
		                 }
		             });
		       });

			
				$('.supplier').click(function(){
					$('#supplierSummary').empty();
					var supID=$(this)[0].id;
					var thisSupplier=supplierJSON.filter(function(d){
				        return d.id===supID;
				    });
					focusSupplier=supID;
					$('.supplier').removeClass('active');
					$(this).addClass('active');
					$('#supplierSummary').append(supplierSummaryTemplate(thisSupplier[0]))
	    
			        $('.potentials').click(function(){
			            $('#candidateLicenses').empty();
                        $('#licenseOnContract').empty();
			            focusProduct=$(this).parent().parent()[0].id;
			           
			           
			                var thisSupplier=supplierJSON.filter(function(d){
			                    return d.id===focusSupplier;
			                }); 

			             if(thisSupplier[0].techProducts.length &gt;0){
			                var techPoss=thisSupplier[0].techProducts.filter(function(e){
			                        return e.id===focusProduct;
			                    }) 
                            }else
                            {var techPoss=thisSupplier[0].appProducts.filter(function(e){
			                        return e.id===focusProduct;
			                    }) }


    if(techPoss[0]){ $('#candidateLicenses').append(productTemplate(techPoss[0].potentials));}
			            $('.pc'+focusProduct).addClass('bg-info');
	                
	
	            $('.possButton').click(function(){
		            var prodsList=techPoss[0].potentials;
		            var selectedProd=$(this).parent().parent().parent()[0].id;
		            var savings=new Array;
	            
	            	$(this).parent().parent().parent().removeClass('bg-success');
	            	$(this).parent().parent().parent().addClass('bg-success');
	           <!-- var thisSave={};
	            thisSave['current']=focusProduct;
	            thisSave['future']=$(this).parent().parent()[0].id;
	            savings.push(thisSave);
	            console.log(savings)
	            $('#analysisPane').append(analysisTemplate(savings[0]));
	--> 
	                savings['current']= prodsList.filter(function(f){
	                        return f.id===focusProduct;
	                    })
    
        
	                savings['future']= prodsList.filter(function(f){
	                        return f.id===selectedProd;
	                    })
	                
	                var currentYrMultipler;
	                var futureYrMultipler;
	                if(savings.current[0].LicenceType==='Subscription'){
	                        currentYrMultipler=1;
	                    }else
	                    { currentYrMultipler=Math.round(savings.current[0].YearsOnContract)
	                         } 
	                if(savings.future[0].LicenceType==='Subscription'){
	                        futureYrMultipler=1;
	                    }else
	                    { futureYrMultipler=Math.round(savings.future[0].YearsOnContract)
	                         } 
	                currentCostPerUnit=parseInt(savings.current[0].licenseUnitPriceContract) / currentYrMultipler;
	                futureCostPerUnit=parseInt(savings.future[0].licenseUnitPriceContract) / futureYrMultipler;
    <!--console.log('1');
      console.log(savings.current[0].licenseUnitPriceContract); 
       console.log(currentYrMultipler);
	    console.log('2');
       console.log(savings.future[0].licenseUnitPriceContract);
       console.log(futureYrMultipler);-->
    
    var tosaving=Math.round(((currentCostPerUnit-futureCostPerUnit)/currentCostPerUnit)*100);
                    if(tosaving){
    
                        if(tosaving &lt; 1){ tosaving='Negative'}
                        else if(tosaving &gt; 1){tosaving='Positive'}
                        }
                        else
                        {tosaving='Investigate'};
    
	                savings['totalPercent']=tosaving;
          
	                $('#analysisPane').append(analysisTemplate(savings));
	    
	                  $('.cls').click(function(){
	                    $(this).parent().prev().remove();
	                    $(this).parent().prev().remove();
	                    $(this).parent().remove();
	                    })
	              });
	            });
	        });
	        
	        
	        <!-- 12 Month View Logic -->
	        var mnthArray=[];
	        var stDt=today.getMonth()+1;
	        for(i=0;i&lt;12;i++){
	            if(stDt===12){stDt=0}
	           
	            stDt=stDt+1; 
	            mnthArray.push(stDt)
	    
	        }
	        html='';
	        mnthArray.forEach(function(d){
	        // console.log(monthsList[d-1]);
	            html+='&lt;div class="col-xs-1 dateHeader">'+monthsList[d-1]+'&lt;/div>'    
	        })
	    	html+='';
	       	//console.log(html);
	        $('#mnths').append(html);
	        productJSON.forEach(function(d){
	                var endDate = new Date(d.dateDebug)
	                var diff=monthDiff(today,endDate)
	                    d['diff']=diff+1;
	 			
		        if(d.dateDebug){
		           $('#datePane').append(dateTemplate(d));
		           var idForDiv='.col'+d.id+''+d.diff;
		           $(idForDiv).css('background-color','red');
           
		           var idForDiv='.col'+d.id+''+d.diff;
		           $(idForDiv).css('background-color','#DE1F20');
		           
		           
		           var contractNoticeMonths = 0;
		           if(d.contractNoticeMonths > 0) {
			           contractNoticeMonths = d.diff - d.contractNoticeMonths;
			           if(contractNoticeMonths > 0) {
				           var idForNoticeDiv='.col'+d.id+''+contractNoticeMonths;
				           $(idForNoticeDiv).css('background-color','#FFAA00');
			           }
		           }
		           
		           
		           if(d.renewalReviewMonths > 0) {
			           var renewalReviewMonths = d.diff - d.contractNoticeMonths - d.renewalReviewMonths;
			           if(renewalReviewMonths > 0) {
				           var idForReviewDiv='.col'+d.id+''+ renewalReviewMonths;
				           $(idForReviewDiv).css('background-color','#1EAD4E');
			           }
		           }
	               
	               //DEBUG
	               if(d['diff'] > 0) {
		 				
		 			}
		     
		            
		        }
		                })              
		 		$('#pickSuppliers').change(function(){
					var supplierToShow=$(this).children(":selected").attr("id");
					if(this.value==='All'){
						$('.monthView').show()
					    }else
					{
						$('.monthView').hide()
						$('.'+supplierToShow).show()
					}
				});
	    
		});
	    <!--End of Document Ready-->
	  
	    function monthDiff(d1, d2) {
	        var months;
	        months = (d2.getFullYear() - d1.getFullYear()) * 12;
	        months -= d1.getMonth() + 1;
	        months += d2.getMonth();
	        return months &lt;= 0 ? 0 : months;
	    };
	      
	</script> 
    
			<script id="date-template" type="text/x-handlebars-template">
				<div><xsl:attribute name="class">col-xs-3 pf{{supplierID}} monthView</xsl:attribute>
					<strong>{{product}}</strong>
				</div>
				<div>
					<xsl:attribute name="class">col-xs-9 pf{{supplierID}} monthView</xsl:attribute>
					<div class="row">
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}1</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}2</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}3</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}4</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}5</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}6</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}7</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}8</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}9</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}10</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}11</xsl:attribute>
							</div>
						</div>
						<div class="col-xs-1">
							<div class="dateBlock">
								<xsl:attribute name="class">dateBlock col{{id}}12</xsl:attribute>
							</div>
						</div>
					</div>
				</div>
				<div class="clearfix"/>
			</script>
			
			<script id="supplier-card-template" type="text/x-handlebars-template">
				{{#each this}}
				<div>
					<xsl:attribute name="class">supplier sup{{Supplier}}</xsl:attribute>
					<xsl:attribute name="id">{{id}}</xsl:attribute>
					{{Supplier}}</div>
				{{/each}}
			</script>
			
			<script id="supplier-summary-template" type="text/x-handlebars-template">
				<table id="supplier-summary-table">
					<tbody>
						<tr>
							<th>Supplier</th>
							<td>{{Supplier}}</td>
						</tr>
						<tr>
							<th>Description</th>
							<td>{{description}}</td>
						</tr>
						<tr>
							<th>Website</th>
							<td>{{website}}</td>
						</tr>
						<tr>
							<th>Contact</th>
							<td>{{contact}}</td>
						</tr>
					</tbody>
				</table>
				<h3 class="strong">Products</h3>
				<div class="productKey small bottom-10">
					<span class="right-10 impact">Key:</span>
					<i class="fa fa-exchange right-5 icon-color"/><span class="right-10">Potential Candidates</span>
					<i class="fa fa-money right-5 icon-color"/><span class="right-10">Total Cost</span>
					<i class="fa fa-users right-5 icon-color"/><span class="right-10"># of Licenses</span>
					<i class="fa fa-th right-5 icon-color"/><span class="right-10">Cost per License</span>
					<i class="fa fa-file-text-o right-5 icon-color"/><span class="right-10">Purchase Model</span>
					<i class="fa fa-calendar right-5 icon-color"/><span class="right-10">Renewal Date</span>
				</div>
				{{#each techProducts}}
					<div class="product">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="pull-left">
							<i class="fa fa-server text-primary right-5"/>
							<span class="strong">{{product}}</span>
						</div>
						<div class="pull-right">
                             {{#if potentialsCount}}
							<div class="licenceInfo potentials right-10" data-toggle="modal" data-target="#Modal" style="cursor:pointer">
								<i class="fa fa-exchange right-5"/>
								<span>{{potentialsCount}}</span>
							</div>
                             {{/if}}
                            {{#if licenseOnContract}}
							<div class="licenceInfo contract right-10">
								<i class="fa fa-money right-5"/><span>{{licenseCostContract}}</span>
								<i class="fa fa-users right-5 left-10"/><span>{{licenseOnContract}}</span>
								<i class="fa fa-th right-5 left-10"/><span>{{licenseUnitPriceContract}}</span>
							</div>
                            {{/if}}
                              {{#if LicenceType}}
							<div class="licenceInfo type right-10">
								<i class="fa fa-file-text-o right-5"/><span>{{LicenceType}}</span>
							</div>
                            {{/if}}
                            {{#if dateDebug}}
							<div class="licenceInfo date right-10">
								<xsl:attribute name="style">border-left:3pt solid {{rembgColor}}</xsl:attribute>
								<i class="fa fa-calendar right-5"/><span>{{dateDebug}}</span>
							</div>
                            {{/if}}	
						</div>
							
						</div>	
				{{/each}}
				
				{{#each appProducts}}
					<div class="product">
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<div class="pull-left">
							<i class="fa fa-server text-primary right-5"/>
							<span class="strong">{{product}}</span>
						</div>
						<div class="pull-right"> 
                            {{#if potentialsCount}}
							<div class="licenceInfo potentials right-10" data-toggle="modal" data-target="#Modal" style="cursor:pointer">
								<i class="fa fa-exchange right-5 "/><span>{{potentialsCount}}</span>
							</div>
                            {{/if}}
                              {{#if licenseOnContract}}
							<div class="licenceInfo contract right-10">
								<i class="fa fa-money right-5 "/><span>{{licenseCostContract}}</span>
								<i class="fa fa-users right-5 left-10"/><span>{{licenseOnContract}}</span>
								<i class="fa fa-th right-5 left-10"/><span>{{licenseUnitPriceContract}}</span>
							</div>
                            {{/if}}
                              {{#if LicenceType}}
							<div class="licenceInfo type right-10">
								<i class="fa fa-file-text-o right-5 "/><span>{{LicenceType}}</span>
							</div>
                            {{/if}}
                              {{#if dateDebug}}
							<div class="licenceInfo date">
								<xsl:attribute name="style">border-left:3pt solid {{rembgColor}}</xsl:attribute>
								<i class="fa fa-calendar right-5 "/><span>{{dateDebug}}</span>
							</div>
                            {{/if}}
						</div>
					</div>
				{{/each}}
			</script>
			
			<script id="product-template" type="text/x-handlebars-template">
				{{#each this}}
					<div>
						<xsl:attribute name="id">{{id}}</xsl:attribute>
						<xsl:attribute name="class">product pc{{id}}</xsl:attribute>
						<div class="pull-left">
							<i class="fa fa-server text-primary right-5"/>
							<span class="strong">{{product}}</span>
						</div>
						<div class="pull-right">
                            {{#if licenseOnContract}}
							<div class="licenceInfo contract right-10">
								<i class="fa fa-money right-5 "/><span>
                                {{licenseCostContract}}</span>
								<i class="fa fa-users right-5 left-10"/><span>{{licenseOnContract}}</span>
								<i class="fa fa-th right-5 left-10"/><span>{{licenseUnitPriceContract}}</span>
							</div>
                            {{/if}} 
                            {{#if LicenceType}}   
							<div class="licenceInfo type right-10">
								<i class="fa fa-file-text-o right-5 "/><span>{{LicenceType}}</span>
							</div>
                             {{/if}}
                            {{#if dateDebug}}  
							<div class="licenceInfo date right-10">
								<xsl:attribute name="style">border-left:3pt solid {{rembgColor}}</xsl:attribute>
								<i class="fa fa-calendar right-5 "/><span>{{dateDebug}}</span>
							</div>
                            {{/if}}
                            {{#unless dateDebug}}
                            <div class="licenceInfo date right-10">Not Known</div>
                            {{/unless}}
							<div class="licenceInfo poss">
								<xsl:attribute name="style">cursor:pointer</xsl:attribute>
								<i class="fa fa-plus-circle possButton"/>
							</div>	
						</div>
					</div>
				{{/each}}
			</script>
			<script id="analysis-template" type="text/x-handlebars-template">
				<div class="row top-5">
					<div class="col-md-4">
						<div class="product">
							<xsl:attribute name="id">{{current.0.id}}</xsl:attribute>
							<div class="pull-left">
								<i class="fa fa-server text-primary right-5"/>
								<span class="strong">{{current.0.product}}</span>
							</div>
							<div class="pull-right">
								<div class="licenceInfo contract right-10">
                                   {{#if current.0.licenseCostContract}}  
									<i class="fa fa-money right-5 "/><span>{{current.0.licenseCostContract}}</span>
									<i class="fa fa-users right-5 left-10"/><span>{{current.0.licenseOnContract}}</span>
									<i class="fa fa-th right-5 left-10"/><span>{{current.0.licenseUnitPriceContract}}</span>
                                    {{/if}}
								</div>
								<div class="licenceInfo type right-10">
									<i class="fa fa-file-text-o right-5 "/><span>{{current.0.LicenceType}}</span>
								</div>
								<div class="licenceInfo date right-10">
									<xsl:attribute name="style">border-left:3pt solid {{current.0.rembgColor}}</xsl:attribute>
									<i class="fa fa-calendar right-5 "/><span>{{current.0.dateDebug}}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="col-md-4">
						<div class="product">
							<xsl:attribute name="id">{{future.0.id}}</xsl:attribute>
							<div class="pull-left">
								<i class="fa fa-server text-primary right-5"/>
								<span class="strong">{{future.0.product}}</span>
							</div>
							<div class="pull-right">
                                {{#if future.0.licenseCostContract}}  
								<div class="licenceInfo contract right-10">
									<i class="fa fa-money right-5 "/><span>{{future.0.licenseCostContract}}</span>
									<i class="fa fa-users right-5 left-10"/><span>{{future.0.licenseOnContract}}</span>
									<i class="fa fa-th right-5 left-10"/><span>{{future.0.licenseUnitPriceContract}}</span>
								</div>
                                {{/if}}
                                {{#if future.0.LicenceType}}
								<div class="licenceInfo type right-10">
									<i class="fa fa-file-text-o right-5 "/><span>{{future.0.LicenceType}}</span>
								</div>
                                {{/if}}
                                 {{#if future.0.dateDebug}}
								<div class="licenceInfo date right-10">
									<xsl:attribute name="style">border-left:3pt solid {{future.0.rembgColor}}</xsl:attribute>
									<i class="fa fa-calendar right-5 "/><span>{{future.0.dateDebug}}</span>
								</div>
                                {{/if}}
							</div>
						</div>
					</div>
					<div class="col-md-4 costcolumn">
						<strong>Potential Saving: </strong><span>{{totalPercent}}</span>
						<button class="btn btn-default licenceInfo cls pull-right">
							<i class="fa fa-times right-5"/>
							<span>Discard</span>  
						</button>
                      
					</div>
				</div>
			</script>
		</html>
	</xsl:template>

	<xsl:template match="node()" mode="supplierList">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="productsForSupplier" select="$technologyProducts[own_slot_value[slot_reference = 'supplier_technology_product']/value = $this/name]"/>
		<xsl:variable name="applicationsForSupplier" select="$applications[own_slot_value[slot_reference = 'ap_supplier']/value = $this/name]"/> {"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>","Supplier":"<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>","description":"<xsl:call-template name="RenderMultiLangInstanceDescription"><xsl:with-param name="isRenderAsJSString" select="true()"/><xsl:with-param name="theSubjectInstance" select="current()"/></xsl:call-template>","contact":"<xsl:value-of select="$allActorNames[name = current()/own_slot_value[slot_reference = 'supplier_actor']/value]/own_slot_value[slot_reference = 'name']/value"/><xsl:if test="not(own_slot_value[slot_reference = 'supplier_actor']/value)">none</xsl:if>","techProducts":[<xsl:if test="not($productsForSupplier)"/><xsl:apply-templates select="$productsForSupplier" mode="productList"/>],"appProducts":[<xsl:if test="not($applicationsForSupplier)"/>
		<xsl:apply-templates select="$applicationsForSupplier" mode="productList"/>]}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="node()" mode="productList">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisContractRels" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_to_element']/value=current()/name]"/>
		
		{"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>","product": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$this"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","oid":"<xsl:value-of select="$this/name"/>","debug":"<xsl:value-of select="$thisContractRels/name"/>","stakeholders":[<xsl:apply-templates select="$allActors[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]" mode="users"/>], 
		<xsl:choose>
			<xsl:when test="$thisContractRels">
				<!--<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>-->
				<xsl:variable name="thisActualContracts" select="$allContracts[name = $thisContractRels/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
				<xsl:variable name="thisTPRs" select="$tprsForTechnologyProducts[own_slot_value[slot_reference = 'role_for_technology_provider']/value = $this/name]"/>
				<xsl:variable name="thisTComps" select="$technologyComponents[own_slot_value[slot_reference = 'realised_by_technology_products']/value = $thisTPRs/name]"/>
				<xsl:variable name="thisCompTPRs" select="$tprsForTechnologyProducts[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisTComps/name]"/>
				<xsl:variable name="allProductsforTPR" select="$allTechnologyProducts[name = $thisCompTPRs/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
				<xsl:variable name="thisaprs" select="$aprs[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
				<xsl:variable name="thisservices" select="$services[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $thisaprs/name]"/>
				<xsl:variable name="allaprs" select="$aprs[own_slot_value[slot_reference = 'implementing_application_service']/value = $thisservices/name]"/>
				<xsl:variable name="potentialapps" select="$applications[own_slot_value[slot_reference = 'provides_application_services']/value = $allaprs/name]"/>
				
				<xsl:variable name="contractRelCount" select="count($thisContractRels)"/>
				<xsl:variable name="currentContractRel" select="$thisContractRels[$contractRelCount]"/>
				<xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = $currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_model']/value]"/>
				<xsl:variable name="currentContract" select="$allContracts[name = $currentContractRel/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
				<xsl:variable name="currentContractSupplier" select="$allSuppliers[name = $currentContract/own_slot_value[slot_reference = 'contract_supplier']/value]"/>
				<xsl:variable name="supplierRelStatus" select="$supplierRelStatii[name = $currentContractSupplier/own_slot_value[slot_reference = 'supplier_relationship_status']/value]"/>
				<xsl:variable name="currentLicense" select="$allLicenses[name = $currentContractRel/own_slot_value[slot_reference = 'ccr_license']/value]"/>
				<xsl:variable name="renewalNoticeDays">
					<xsl:choose>
						<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="contractNoticeMonths">
					<xsl:choose>
						<xsl:when test="$renewalNoticeDays > 0">
							<xsl:value-of select="round($renewalNoticeDays div 30)"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="renewalReviewDays">
					<xsl:choose>
						<xsl:when test="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value">
							<xsl:value-of select="$supplierRelStatus/own_slot_value[slot_reference = 'csrs_contract_review_notice_days']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="renewalReviewMonths">
					<xsl:choose>
						<xsl:when test="$renewalReviewDays > 0">
							<xsl:value-of select="round($renewalReviewDays div 30)"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!--<xsl:variable name="period"><xsl:choose><xsl:when test="$contractNoticeMonths > 0"><xsl:value-of select="$contractNoticeMonths"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable> -->
				<!--<xsl:variable name="endYear" select="functx:add-months(xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $contractNoticeMonths)"/>-->
				<xsl:variable name="startYear" select="xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value, 1, 10))"/>
				
				<xsl:variable name="endYear">
							<xsl:choose>
								<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value">
						 			<xsl:value-of select="xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value, 1, 10))"/>
								</xsl:when>
							<xsl:otherwise>
							2000-01-01
							</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
				<xsl:variable name="noticeDays" select="$currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value"/>
				<!--<xsl:variable name="contractRelLengthMonths" select="xs:date($endYear) - xs:date($startYear) div xs:duration('P1M')"/>-->
				<xsl:variable name="contractRelLengthMonths" select="12"/>
				<xsl:variable name="remaining" select="days-from-duration(xs:duration(xs:date($endYear) - current-date()))"/>
				<xsl:variable name="Year" select="year-from-date(xs:date($endYear))"/>
				<xsl:variable name="Month" select="month-from-date(xs:date($endYear))"/>
				<xsl:variable name="currentContractedUnits">
					<xsl:choose>
						<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="currentContractTotal">
					<xsl:choose>
						<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="currentCostPerUnit">
					<xsl:choose>
						<xsl:when test="$currentContractedUnits > 0 and $currentContractTotal > 0">
							<xsl:value-of select="$currentContractTotal div $currentContractedUnits"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Day" select="day-from-date(xs:date($endYear))"/>"Contract":"<xsl:value-of select="$currentContract/own_slot_value[slot_reference = 'name']/value"/>","dbug":"test","Licence":"<xsl:value-of select="$currentLicense/own_slot_value[slot_reference = 'name']/value"/>","LicenceType":"<xsl:value-of select="$currentRenewalModel/own_slot_value[slot_reference = 'name']/value"/>","licenseOnContract":"<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>","YearsOnContract":"<xsl:choose><xsl:when test="$contractRelLengthMonths > 0"><xsl:value-of select="$contractRelLengthMonths div 12"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>","licenseCostContract":"<xsl:value-of select="format-number($currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value, '##,###,###')"/>","licenseUnitPriceContract":"<xsl:value-of select="format-number($currentCostPerUnit, '##,###,###')"/>","month":"<xsl:value-of select="$Month"/>","year":"<xsl:value-of select="$Year"/>","EndDate":"<xsl:value-of select="$Day"/>/<xsl:value-of select="$Month"/>/<xsl:value-of select="$Year"/>","remaining":<xsl:value-of select="$remaining"/>,"rembgColor": "<xsl:choose><xsl:when test="$remaining &lt; 0">red</xsl:when>
					<xsl:when test="$remaining > 0 and $remaining &lt; 180">#f4c96a</xsl:when>
					<xsl:otherwise>#98d193</xsl:otherwise></xsl:choose>", "contractNoticeMonths": <xsl:value-of select="$contractNoticeMonths"/>, "renewalReviewMonths": <xsl:value-of select="$renewalReviewMonths"/>, "potentialsCount":"<xsl:choose><xsl:when test="(count($allProductsforTPR)+count($potentialapps))&lt;2"></xsl:when><xsl:otherwise><xsl:value-of select="count($allProductsforTPR)+count($potentialapps)-1"/></xsl:otherwise></xsl:choose>","potentials":[<xsl:apply-templates select="$allProductsforTPR" mode="opportunities"/><xsl:apply-templates select="$potentialapps" mode="opportunities"/>],"debugapr":"<xsl:value-of select="$allaprs/name"/>","debugserr":"<xsl:value-of select="$thisservices/name"/>","debugapp":"<xsl:value-of select="$potentialapps/name"/>", "dateDebug":""</xsl:when><xsl:otherwise>"licence":"none"</xsl:otherwise></xsl:choose>,"supplier":"<xsl:value-of select="$supplier[name = $this/own_slot_value[slot_reference = 'supplier_technology_product']/value]/own_slot_value[slot_reference = 'name']/value"/><xsl:value-of select="$supplier[name = $this/own_slot_value[slot_reference = 'ap_supplier']/value]/own_slot_value[slot_reference = 'name']/value"/>","supplierID":"<xsl:value-of select="eas:getSafeJSString($supplier[name = $this/own_slot_value[slot_reference = 'supplier_technology_product']/value]/name)"/><xsl:value-of select="eas:getSafeJSString($supplier[name = $this/own_slot_value[slot_reference = 'ap_supplier']/value]/name)"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

	<!--<xsl:template match="node()" mode="productList">
		<xsl:variable name="this" select="current()"/>
        <xsl:variable name="thisContracts" select="$contracts[own_slot_value[slot_reference = 'obligation_applies_to']/value=current()/name]"/>
        
        {"id": "<xsl:value-of select="eas:getSafeJSString($this/name)"/>","product": "<xsl:value-of select="$this/own_slot_value[slot_reference = 'name']/value"/>","oid":"<xsl:value-of select="$this/name"/>","debug":"<xsl:value-of select="$thisContracts/name"/>","stakeholders":[<xsl:apply-templates select="$allActors[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]" mode="users"/>], 
		<xsl:choose>
			<xsl:when test="$thisContracts">
				<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>
				<xsl:variable name="thisActualContract" select="$actualContracts[own_slot_value[slot_reference = 'contract_uses_license']/value = $thisLicenses/name]"/>
				<xsl:variable name="thisTPRs" select="$tprsForTechnologyProducts[own_slot_value[slot_reference = 'role_for_technology_provider']/value = $this/name]"/>
				<xsl:variable name="thisTComps" select="$technologyComponents[own_slot_value[slot_reference = 'realised_by_technology_products']/value = $thisTPRs/name]"/>
				<xsl:variable name="thisCompTPRs" select="$tprsForTechnologyProducts[own_slot_value[slot_reference = 'implementing_technology_component']/value = $thisTComps/name]"/>
				<xsl:variable name="allProductsforTPR" select="$allTechnologyProducts[name = $thisCompTPRs/own_slot_value[slot_reference = 'role_for_technology_provider']/value]"/>
                <xsl:variable name="thisaprs" select="$aprs[own_slot_value[slot_reference = 'role_for_application_provider']/value = current()/name]"/>
                <xsl:variable name="thisservices" select="$services[own_slot_value[slot_reference = 'provided_by_application_provider_roles']/value = $thisaprs/name]"/>
                <xsl:variable name="allaprs" select="$aprs[own_slot_value[slot_reference = 'implementing_application_service']/value = $thisservices/name]"/>
                <xsl:variable name="potentialapps" select="$applications[own_slot_value[slot_reference = 'provides_application_services']/value = $allaprs/name]"/>
                
				<xsl:variable name="period"><xsl:choose><xsl:when test="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"><xsl:value-of select="$thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable> 
                <xsl:variable name="endYear" select="functx:add-months(xs:date(substring($thisLicenses/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $period)"/>
				<xsl:variable name="remaining" select="days-from-duration(xs:duration(xs:date($endYear) - current-date()))"/>
				<xsl:variable name="Year" select="year-from-date(xs:date($endYear))"/>
				<xsl:variable name="Month" select="month-from-date(xs:date($endYear))"/>
				<xsl:variable name="Day" select="day-from-date(xs:date($endYear))"/>"Contract":"<xsl:value-of select="$thisContracts/own_slot_value[slot_reference = 'name']/value"/>","Licence":"<xsl:value-of select="$thisLicenses/own_slot_value[slot_reference = 'name']/value"/>","LicenceType":"<xsl:value-of select="$licenseType[name = $thisLicenses/own_slot_value[slot_reference = 'license_type']/value]/own_slot_value[slot_reference = 'name']/value"/>","licenseOnContract":"<xsl:value-of select="$thisActualContract/own_slot_value[slot_reference = 'contract_number_of_units']/value"/>","YearsOnContract":"<xsl:value-of select="($thisLicenses/own_slot_value[slot_reference = 'license_months_to_renewal']/value) div 12"/>","licenseCostContract":"<xsl:value-of select="format-number($thisActualContract/own_slot_value[slot_reference = 'contract_deal_cost']/value, '##,###,###')"/>","licenseUnitPriceContract":"<xsl:value-of select="format-number($thisActualContract/own_slot_value[slot_reference = 'contract_unit_cost']/value, '##,###,###')"/>","month":"<xsl:value-of select="$Month"/>","year":"<xsl:value-of select="$Year"/>","EndDate":"<xsl:value-of select="$Day"/>/<xsl:value-of select="$Month"/>/<xsl:value-of select="$Year"/>","remaining":<xsl:value-of select="$remaining"/>,"rembgColor": "<xsl:choose><xsl:when test="$remaining &lt; 0">red</xsl:when>
					<xsl:when test="$remaining > 0 and $remaining &lt; 180">#f4c96a</xsl:when>
					<xsl:otherwise>#98d193</xsl:otherwise></xsl:choose>","potentialsCount":"<xsl:choose><xsl:when test="(count($allProductsforTPR)+count($potentialapps))&lt;2"></xsl:when><xsl:otherwise><xsl:value-of select="count($allProductsforTPR)+count($potentialapps)-1"/></xsl:otherwise></xsl:choose>","potentials":[<xsl:apply-templates select="$allProductsforTPR" mode="opportunities"/><xsl:apply-templates select="$potentialapps" mode="opportunities"/>],"debugapr":"<xsl:value-of select="$allaprs/name"/>","debugserr":"<xsl:value-of select="$thisservices/name"/>","debugapp":"<xsl:value-of select="$potentialapps/name"/>", "dateDebug":" "</xsl:when><xsl:otherwise>"licence":"none"</xsl:otherwise></xsl:choose>,"supplier":"<xsl:value-of select="$supplier[name = $this/own_slot_value[slot_reference = 'supplier_technology_product']/value]/own_slot_value[slot_reference = 'name']/value"/><xsl:value-of select="$supplier[name = $this/own_slot_value[slot_reference = 'ap_supplier']/value]/own_slot_value[slot_reference = 'name']/value"/>","supplierID":"<xsl:value-of select="translate($supplier[name = $this/own_slot_value[slot_reference = 'supplier_technology_product']/value]/name, '.', '')"/><xsl:value-of select="translate($supplier[name = $this/own_slot_value[slot_reference = 'ap_supplier']/value]/name, '.', '')"/>"}<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>-->
	
	
	
	<xsl:template match="node()" mode="opportunities">
		<xsl:variable name="this" select="current()"/>
		<xsl:apply-templates select="$this" mode="subproductList"/>

	</xsl:template>
	<xsl:template match="node()" mode="options">
		<xsl:variable name="this" select="own_slot_value[slot_reference = 'name']/value"/>

		<option value="{$this}">
			<xsl:value-of select="$this"/>
		</option>
	</xsl:template>

	<xsl:template match="node()" mode="users"> "<xsl:value-of select="$allActorNames[name = current()/own_slot_value[slot_reference = 'act_to_role_from_actor']/value]/own_slot_value[slot_reference = 'name']/value"/>"<xsl:if test="not(position() = last())">,</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="subproductList">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisContractRels" select="$allContractToElementRels[own_slot_value[slot_reference = 'contract_component_to_element']/value=current()/name]"/>
		 {"id":"<xsl:value-of select="eas:getSafeJSString($this/name)"/>","product": "<xsl:call-template name="RenderMultiLangInstanceName">
			<xsl:with-param name="theSubjectInstance" select="$this"/>
			<xsl:with-param name="isRenderAsJSString" select="true()"/>
		</xsl:call-template>","oid":"<xsl:value-of select="$this/name"/>","stakeholders":[<xsl:apply-templates select="$allActors[name = $this/own_slot_value[slot_reference = 'stakeholders']/value]" mode="users"/>],
		<xsl:choose>
			<xsl:when test="$thisContractRels">
				<!--<xsl:variable name="thisLicenses" select="$licenses[name = $thisContracts/own_slot_value[slot_reference = 'compliance_obligation_licenses']/value]"/>-->
				<xsl:variable name="thisActualContracts" select="$allContracts[name = $thisContractRels/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
				<xsl:variable name="contractRelCount" select="count($thisContractRels)"/>
				<xsl:variable name="currentContractRel" select="$thisContractRels[$contractRelCount]"/>
				<xsl:variable name="currentContract" select="$thisActualContracts[name = $currentContractRel/own_slot_value[slot_reference = 'contract_component_from_contract']/value]"/>
				<xsl:variable name="currentLicense" select="$allLicenses[name = $currentContractRel/own_slot_value[slot_reference = 'ccr_license']/value]"/>
                <xsl:variable name="currentRenewalModel" select="$allRenewalModels[name = $currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_model']/value]"/>
				<xsl:variable name="renewalNoticeDays">
					<xsl:choose>
						<xsl:when test="$currentContractRel">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_renewal_notice_days']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="contractNoticeMonths">
					<xsl:choose>
						<xsl:when test="$renewalNoticeDays > 0">
							<xsl:value-of select="round($renewalNoticeDays div 30)"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!--<xsl:variable name="period"><xsl:choose><xsl:when test="$contractNoticeMonths > 0"><xsl:value-of select="$contractNoticeMonths"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:variable> -->
				<!--<xsl:variable name="endYear" select="functx:add-months(xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'license_start_date']/value, 1, 10)), $contractNoticeMonths)"/>-->
				 
				<xsl:variable name="startYear" select="xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'ccr_start_date_ISO8601']/value, 1, 10))"/>
					 
			 
						<xsl:variable name="endYear">
							<xsl:choose>
								<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value">
						 			<xsl:value-of select="xs:date(substring($currentContractRel/own_slot_value[slot_reference = 'ccr_end_date_ISO8601']/value, 1, 10))"/>
								</xsl:when>
							<xsl:otherwise>
							2000-01-01
							</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
				
				<!--<xsl:variable name="contractRelLengthMonths" select="xs:date($endYear) - xs:date($startYear) div xs:duration('P1M')"/>-->
				<xsl:variable name="contractRelLengthMonths" select="12"/>
				<xsl:variable name="remaining" select="days-from-duration(xs:duration(xs:date($endYear) - current-date()))"/>
				<xsl:variable name="Year" select="year-from-date(xs:date($endYear))"/>
				<xsl:variable name="Month" select="month-from-date(xs:date($endYear))"/>
				<xsl:variable name="Day" select="day-from-date(xs:date($endYear))"/>
				 

				<xsl:variable name="currentContractedUnits">
					<xsl:choose>
						<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="currentContractTotal">
					<xsl:choose>
						<xsl:when test="$currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value">
							<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="currentCostPerUnit">
					<xsl:choose>
						<xsl:when test="$currentContractedUnits > 0 and $currentContractTotal > 0">
							<xsl:value-of select="$currentContractTotal div $currentContractedUnits"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				"Contract":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$currentContract"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>","Licence":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$currentLicense"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>","LicenceType":"<xsl:call-template name="RenderMultiLangInstanceName">
					<xsl:with-param name="theSubjectInstance" select="$currentRenewalModel"/>
					<xsl:with-param name="isRenderAsJSString" select="true()"/>
				</xsl:call-template>","licenseOnContract":"<xsl:value-of select="$currentContractRel/own_slot_value[slot_reference = 'ccr_contracted_units']/value"/>","YearsOnContract":"<xsl:choose><xsl:when test="$contractRelLengthMonths > 0"><xsl:value-of select="$contractRelLengthMonths div 12"/></xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>","licenseCostContract":"<xsl:value-of select="format-number($currentContractRel/own_slot_value[slot_reference = 'ccr_total_annual_cost']/value, '##,###,###')"/>","licenseUnitPriceContract":"<xsl:value-of select="format-number($currentCostPerUnit, '##,###,###')"/>","month":"<xsl:value-of select="$Month"/>","year":"<xsl:value-of select="$Year"/>","EndDate":"<xsl:value-of select="$Day"/>/<xsl:value-of select="$Month"/>/<xsl:value-of select="$Year"/>","remaining":<xsl:value-of select="$remaining"/>,"rembgColor": "<xsl:choose><xsl:when test="$remaining &lt; 0">red</xsl:when>
					<xsl:when test="$remaining > 0 and $remaining &lt; 180">#f4c96a</xsl:when>
					<xsl:otherwise>#98d193</xsl:otherwise></xsl:choose>", "dateDebug":" " </xsl:when><xsl:otherwise>"licence":"none"</xsl:otherwise></xsl:choose>},
	</xsl:template>
	
	
	<xsl:template match="node()" mode="supplierOptions">
		<xsl:variable name="this" select="current()"/>
		<xsl:variable name="thisid" select="eas:getSafeJSString($this/name)"/>
		<option id="pf{$thisid}">
			<xsl:call-template name="RenderMultiLangInstanceName">
				<xsl:with-param name="theSubjectInstance" select="current()"/>
				<xsl:with-param name="isRenderAsJSString" select="true()"/>
			</xsl:call-template>
		</option>
	</xsl:template>
	


</xsl:stylesheet>
