<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:functx="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ess="http://www.enterprise-architecture.org/essential/errorview" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">
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
	<xsl:variable name="allApplications" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')]"/> 
	
    <xsl:variable name="allArchUsages" select="/node()/simple_instance[type='Static_Application_Provider_Usage']"/>
    <xsl:variable name="allApplicationsApps" select="/node()/simple_instance[type=('Application_Provider','Composite_Application_Provider')][name=$allArchUsages/own_slot_value[slot_reference='static_usage_of_app_provider']/value]"/> 
     <xsl:variable name="allAPIs" select="/node()/simple_instance[type=('Application_Provider_Interface')]"/> 
    <xsl:variable name="allApplicationsAPUs" select="$allApplicationsApps union $allAPIs"/> 
  <xsl:variable name="allDataAcquisition" select="/node()/simple_instance[type='Data_Acquisition_Method']"/>
  <xsl:variable name="allInfoQual" select="/node()/simple_instance[type='Information_Service_Quality_Value']"/>
  
  <xsl:variable name="allAPPINFOREPs" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_RELATION']"/>
  <xsl:variable name="allAPPINFOREPEXCHANGEs" select="/node()/simple_instance[type='APP_PRO_TO_INFOREP_EXCHANGE_RELATION']"/>
  <xsl:key name="allAPUsTokey" match="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference=':TO']/value"/>
  <xsl:key name="allAPUsFromkey" match="/node()/simple_instance[type=':APU-TO-APU-STATIC-RELATION']" use="own_slot_value[slot_reference=':FROM']/value"/>
  <xsl:key name="allArchUsageskey" match="/node()/simple_instance[type='Static_Application_Provider_Usage']" use="own_slot_value[slot_reference='static_usage_of_app_provider']/value"/>
  <xsl:key name="allAppProtoInfokey" match="$allAPPINFOREPs" use="own_slot_value[slot_reference='apu_to_apu_relation_inforeps']/value"/>
  <xsl:key name="allInfokey" match="/node()/simple_instance[type='Information_Representation']" use="own_slot_value[slot_reference='app_pro_to_inforep_to_inforep']/value"/>
  <xsl:key name="allInfotoAPUkey" match="/node()/simple_instance[type=('APP_PRO_TO_INFOREP_RELATION','APP_PRO_TO_INFOREP_EXCHANGE_RELATION')]" use="own_slot_value[slot_reference='used_in_app_dependencies']/value"/>
  <!-- narrow down to airs tied to inforep exchanged -->
  <xsl:variable name="allAIRwithAPU" select="$allAPPINFOREPs[name=$allAPPINFOREPEXCHANGEs/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value]"/>
  <xsl:key name="allInfoRepkey" match="/node()/simple_instance[type='Information_Representation']" use="own_slot_value[slot_reference='inforep_used_by_app_pro']/value"/>
 
  

  <!-- END GENERIC LINK VARIABLES -->
 	<xsl:variable name="apiPathApps" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: BusCap to App Mart Apps']"/> 
    <xsl:variable name="apiPathInfo" select="$utilitiesAllDataSetAPIs[own_slot_value[slot_reference = 'name']/value = 'Core API: Information Mart']"/> 
    
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

	<xsl:template match="knowledge_base">
		<xsl:call-template name="docType"/>
		
        <xsl:variable name="apiPathNodes">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathApps"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="apiPathInfo">
            <xsl:call-template name="GetViewerAPIPath">
                <xsl:with-param name="apiReport" select="$apiPathInfo"/>
            </xsl:call-template>
        </xsl:variable>
        
 
		  
		<html>
			<head>
				<xsl:call-template name="commonHeadContent"/> 
				<xsl:for-each select="$linkClasses">
					<xsl:call-template name="RenderInstanceLinkJavascript">
						<xsl:with-param name="instanceClassName" select="current()"/>
						<xsl:with-param name="targetMenu" select="()"/>
					</xsl:call-template>
				</xsl:for-each>
				<title>Launchpad Exporter</title> 
				<script src="js/FileSaver.min.js"/>
				<style>
				.minText {font-size:0.8em;
						  vertical-align: top;
							}
				.stepsHead {font-size:0.9em;
						  	horizontal-align: center;
							background-color:#393939;
							color:#fff}	
				.playBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					border-radius: 4px;
					width: 100%;
					margin-bottom: 10px;
					position: relative;
				}
				.notesBlob{
					border: 1px solid #ccc;
					padding: 5px;
					background-color: #f6f6f6;
					width:60%;
					border-radius: 4px; 
				}
				.playTitle{
					font-weight: 700;
					font-size: 110%;
				}
				.playDescription{
					font-size: 90%;
				}
				.playDocs {
					position: absolute;
					top: 5px;
					right: 5px;
				}
				.playSteps{
					display: none;
            }
           
				.playSteps > ul {
					<!--columns: 2;-->
				}

            .additional {
               color: #32a8a8;
            }
            .additionalShow {
               color: #32a8a8;
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
							<div class="page-header">
								<h1>
									<span class="text-primary"><xsl:value-of select="eas:i18n('View')"/>: </span>
									<span class="text-darkgrey">Launchpad Export - Application Interface Dependency</span>
								</h1>
							</div>
						</div>
						<!--<xsl:call-template name="RenderDataSetAPIWarning"/>-->
					 
						<div class="col-md-3">
					<p>		
              <button id="genExcel" class="btn btn-default bg-primary text-white small bottom-10">Generate Application Dependency Launchpad File</button> <span class="appDepSpin"><i class="fa fa-cog fa-spin  fa-fw"></i> Loading...wait</span><br/></p>
              <p>
                <a class="noUL" href="https://enterprise-architecture.org/downloads_area/app_dependency_import.zip" download="app_dependency_import.zip">
                <button id="downloadSpec" class="btn btn-default bg-secondary text-white small bottom-10">Get Application Dependency Import Specification</button>
                </a> 
                <br/>
                    
                     <a href="https://enterprise-architecture.org/downloads_area/LaunchpadPlus-Application_Dependencies.docx" download="LaunchpadPlus-Application_Dependencies.docx"><h4><i class="fa fa-book"></i> Documentation</h4></a> 
               
                 </p>   
                        </div>
                        <div class="col-md-9">
                        <p>
                            The Application Dependencies workbook allows you to import dependencies in bulk.  You can map either applications directly or via interfaces.<br/>
                            The workbook will export any existing data.
                        </p>
                        <p>
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <td>Sheet</td>
                                    <td>Description</td>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>Applications</td>
                                    <td>A list of composite application providers in the repository</td>
                                </tr>  
                                <tr>
                                    <td>Application Modules</td>
                                    <td>A list of application providers in the repository</td>
                                </tr> 
                                <tr>
                                    <td>App Pro Interface</td>
                                    <td>A list of application provider interfaces in the repository</td>
                                </tr> 
                                <tr>
                                    <td>Interface Exchanged</td>
                                    <td>A list of information representations which are used to describe what information is flowing between applications.  Note, you can map these to information views (using the implements_information_views slot) and then to data objects via the information views, if required.  In Cloud/Docker you can also use the application editor to do this.</td>
                                </tr> 
                                <tr>
                                    <td>Application Dependencies XXYY</td>
                                    <td>A list of the dependencies between composite applications and the information passed between them.  Note, you will require a separate row for each different type of information.  You can add method and timeliness or leave them blank<br/>
                                    <b>Note:</b> Use the correct tab to map variations, e.g. Composite Application (CA) to Application Provider (AP) is the sheet ending CAAP (CA to AP), CACA, APCA or APAP.
                                    </td>
                                </tr>  
                                <tr>
                                    <td>App Interface Dependencies XXYY</td>
                                    <td>A list of the dependencies between composite applications that use an API, and the information passed between them via the API.  The information exchanged may differ on either side of the API.  Note, again you will require a separate row for each different type of information.  You can add method and timeliness or leave them blank.<br/>
                                    <b>Note:</b> Us the correct sheet to map the interface</td>
                                </tr>      
                               
                                </tbody>
                            </table>
                        </p>
                        </div>
	 
						<!--Setup Closing Tags-->
					</div>
				</div>
 
				<!-- ADD THE PAGE FOOTER -->
				<xsl:call-template name="Footer"/>
 			
<script>


appAPUList=[<xsl:apply-templates select="$allApplicationsAPUs" mode="getAppAPUs"/>];
allAIRwithAPU=[<xsl:apply-templates select="$allAIRwithAPU" mode="data"/>];
 
if(appAPUList.length&gt;0){
    let toListPairs=[]
    appAPUList.forEach((d)=>{
        d.To.forEach((e)=>{
            if(d.ApplicationName){
                toListPairs.push({"id":e.apuid,"appName":d.ApplicationName, "toAppId":d.ApplicationID, "type":d.type})
            }
        })
    });
 
    appAPUList.forEach((d)=>{ 
        d.From.forEach((e)=>{
        if(e){
            let thisTo=toListPairs.find((f)=>{
                return f.id==e.apuid;
            }) 
        if(thisTo){ 
            
            e['toApp']=thisTo.appName;
            e['toAppId']=thisTo.toAppId;
            e['type']=thisTo.type;
            }   
          }
          
        if(d.type=='Application_Provider_Interface'){
//to  
 
        d.To.forEach((e)=>{
        if(e){
            appAPUList.forEach((f)=>{
                let thisAPIApp=f.From.find((ap)=>{
                    return ap.apuid==e.apuid;
                })

                if(thisAPIApp){
                e['to']=f.ApplicationName;
                e['toData']=f.data;
                e['type']=f.type
                }
            })    
          }
        })

    let allTos=[];
        d.From.forEach((f)=>{
            d.To.forEach((t)=>{ 
                let newf=f; 
                newf['fromApp']=t.to;
                newf['fromData']=t.data;
                newf['fromtype']=t.type;
                allTos.push(newf)
                 
            })

        })
  
        let apiList=[];
        let rowList=[];
        allTos.forEach((a)=>{
          if(a.data.length&gt;0){
                    a.data.forEach((dt)=>{
                    apiList.push({
                    "apuid": a.apuid,
                    "aputype": a.aputype,
                    "data": dt.name,
                    "method":dt.method,
                    "frequency":dt.frequency,
                    "fromApp": a.fromApp,
                    "fromData": a.fromData,
                    "fromtype": a.fromtype,
                    "to": a.to,
                    "toApp": a.toApp,
                    "toAppId": a.toAppId,
                    "type": a.type
                    })
                })
            }
            else{
                apiList.push({
                    "apuid": a.apuid,
                    "aputype": a.aputype,
                    "data": [],
                    "method":'',
                    "frequency":'',
                    "fromApp": a.fromApp,
                    "fromData": a.fromData,
                    "fromtype": a.fromtype,
                    "to": a.to,
                    "toApp": a.toApp,
                    "toAppId": a.toAppId,
                    "type": a.type
                    }) 
            }
        })
      
        apiList.forEach((a)=>{
            if(a.fromData.length&gt;0){
                a.fromData.forEach((dt)=>{
                rowList.push({
                "apuid": a.apuid,
                "aputype": a.aputype,
                "data": a.data,
                "fromApp": a.fromApp,
                "fromData": dt.name,
                "fromtype": a.fromtype,
                "method":dt.method,
                "frequency":dt.frequency,
                "to": a.to,
                "toApp": a.toApp,
                "toAppId": a.toAppId,
                "type": a.type
                })
                })
            }else{
                rowList.push({
                "apuid": a.apuid,
                "aputype": a.aputype,
                "data": a.data,
                "fromApp": a.fromApp,
                "fromData": [],
                "fromtype": a.fromtype,
                "method":'',
                "frequency":'',
                "to": a.to,
                "toApp": a.toApp,
                "toAppId": a.toAppId,
                "type": a.type
                })
            }
        
     
        })
        d['allAPIData']=rowList;
    }
    }); 
        });
    
} 
	var worksheetList=[];
 	var ExcelArray=[];		
	
	statusSet={}
		 
    $('document').ready(function () {
	});
	
var getXML = function promise_getExcelXML(excelXML_URL) {
    return new Promise(
    function (resolve, reject) {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function () {
            if (this.readyState == 4 &amp;&amp; this.status == 200) {
                ////console.log(prefixString);
                resolve(this.responseText);
            }
        };
        xmlhttp.onerror = function () {
            reject(false);
        };
        xmlhttp.open("GET", excelXML_URL, true);
        xmlhttp.send();
    });
};

</script>
<script  id="appdep-tab" type="text/x-handlebars-template">
 <Worksheet ss:Name="Application Dependencies CACA">
  <Table ss:ExpandedColumnCount="10" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="21"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="163"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
   <Column ss:AutoFitWidth="0" ss:Width="104"/>
   <Column ss:AutoFitWidth="0" ss:Width="93"/>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell/>
    <Cell ss:StyleID="s72"><Data ss:Type="String" >Application Dependencies</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell ss:StyleID="s42"><Data ss:Type="String" >Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell/>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"/>
    <Cell/>
    <Cell/>
   </Row>
   {{#each this}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
       {{#each this.From}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
            {{#each this.data}} 
             {{#ifEquals ../this.type 'Composite_Application_Provider'}}
                 {{#ifEquals ../../this.type 'Composite_Application_Provider'}}
                <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell/>
                    <Cell><Data ss:Type="String">{{../this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.name}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="8"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                </Row>
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifEquals}}
        {{/each}}
        {{/ifEquals}}
   {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>7</SplitHorizontal>
   <TopRowBottomPane>7</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R169C5</Range>
   <Type>List</Type>
   <Value>Valid_Data_Aquisition_Methods</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R169C6</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R890C3,R892C3:R100002C3,R8C2:R10002C2</Range>
   <Type>List</Type>
   <Value>Applications!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R895C4,R896C5:R898C5,R894C5,R8C4:R893C4,R901C5:R903C5,R899C4:R10002C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Information Exchanged'!R8C3:R1000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Dependencies APCA">
  <Table ss:ExpandedColumnCount="10" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="21"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="163"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
   <Column ss:AutoFitWidth="0" ss:Width="104"/>
   <Column ss:AutoFitWidth="0" ss:Width="93"/>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell/>
    <Cell ss:StyleID="s72"><Data ss:Type="String" >Application Dependencies</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell ss:StyleID="s42"><Data ss:Type="String" >Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell/>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"/>
    <Cell/>
    <Cell/>
   </Row>
   {{#each this}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
       {{#each this.From}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
            {{#each this.data}} 
             {{#ifEquals ../this.type 'Application_Provider'}}
                 {{#ifEquals ../../this.type 'Composite_Application_Provider'}}
                <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell/>
                    <Cell><Data ss:Type="String">{{../this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.name}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="8"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                </Row>
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifEquals}}
        {{/each}}
        {{/ifEquals}}
   {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>7</SplitHorizontal>
   <TopRowBottomPane>7</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R169C5</Range>
   <Type>List</Type>
   <Value>Valid_Data_Aquisition_Methods</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R169C6</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R890C3,R892C3:R100002C3</Range>
   <Type>List</Type>
   <Value>Applications!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R10002C2</Range>
   <Type>List</Type>
   <Value>'Application Modules'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R895C4,R896C5:R898C5,R894C5,R8C4:R893C4,R901C5:R903C5,R899C4:R10002C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Information Exchanged'!R8C3:R1000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Dependencies CAAP">
  <Table ss:ExpandedColumnCount="10" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="21"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="163"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
   <Column ss:AutoFitWidth="0" ss:Width="104"/>
   <Column ss:AutoFitWidth="0" ss:Width="93"/>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell/>
    <Cell ss:StyleID="s72"><Data ss:Type="String" >Application Dependencies</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell ss:StyleID="s42"><Data ss:Type="String" >Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell/>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"/>
    <Cell/>
    <Cell/>
   </Row>
   {{#each this}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
       {{#each this.From}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
            {{#each this.data}} 
             {{#ifEquals ../this.type 'Composite_Application_Provider'}}
                 {{#ifEquals ../../this.type 'Application_Provider'}}
                <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell/>
                    <Cell><Data ss:Type="String">{{../this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.name}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="8"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                </Row>
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifEquals}}
        {{/each}}
        {{/ifEquals}}
   {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>7</SplitHorizontal>
   <TopRowBottomPane>7</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R169C5</Range>
   <Type>List</Type>
   <Value>Valid_Data_Aquisition_Methods</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R169C6</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C2:R10002C2</Range>
   <Type>List</Type>
   <Value>Applications!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R10002C3</Range>
   <Type>List</Type>
   <Value>'Application Modules'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R895C4,R896C5:R898C5,R894C5,R8C4:R893C4,R901C5:R903C5,R899C4:R10002C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Information Exchanged'!R8C3:R1000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Dependencies APAP">
  <Table ss:ExpandedColumnCount="10" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="21"/>
   <Column ss:AutoFitWidth="0" ss:Width="190"/>
   <Column ss:AutoFitWidth="0" ss:Width="230"/>
   <Column ss:AutoFitWidth="0" ss:Width="163"/>
   <Column ss:AutoFitWidth="0" ss:Width="196"/>
   <Column ss:AutoFitWidth="0" ss:Width="135"/>
   <Column ss:Index="8" ss:AutoFitWidth="0" ss:Width="159"/>
   <Column ss:AutoFitWidth="0" ss:Width="104"/>
   <Column ss:AutoFitWidth="0" ss:Width="93"/>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell/>
    <Cell ss:StyleID="s72"><Data ss:Type="String" >Application Dependencies</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell ss:StyleID="s42"><Data ss:Type="String" >Captures the information dependencies between applications; where information passes between applications and the method for passing the information</Data></Cell>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="20">
    <Cell/>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
    <Cell ss:Index="8" ss:StyleID="s68"><Data ss:Type="String"></Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String"> </Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8">
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell/>
    <Cell ss:Index="8"/>
    <Cell/>
    <Cell/>
   </Row>
   {{#each this}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
       {{#each this.From}}
        {{#ifEquals this.type 'Application_Provider_Interface'}}
        {{else}}
            {{#each this.data}} 
             {{#ifEquals ../this.type 'Application_Provider'}}
                 {{#ifEquals ../../this.type 'Application_Provider'}}
                <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell/>
                    <Cell><Data ss:Type="String">{{../this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.name}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="8"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                </Row>
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifEquals}}
        {{/each}}
        {{/ifEquals}}
   {{/each}}
  </Table>
  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <FreezePanes/>
   <FrozenNoSplit/>
   <SplitHorizontal>7</SplitHorizontal>
   <TopRowBottomPane>7</TopRowBottomPane>
   <ActivePane>2</ActivePane>
   <Panes>
    <Pane>
     <Number>3</Number>
    </Pane>
    <Pane>
     <Number>2</Number>
     <ActiveCol>1</ActiveCol>
    </Pane>
   </Panes>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R169C5</Range>
   <Type>List</Type>
   <Value>Valid_Data_Aquisition_Methods</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R169C6</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C3:R890C3,R892C3:R100002C3,R8C2:R10002C2</Range>
   <Type>List</Type>
   <Value>'Application Modules'!R8C3:R5000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R895C4,R896C5:R898C5,R894C5,R8C4:R893C4,R901C5:R903C5,R899C4:R10002C4</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>'Information Exchanged'!R8C3:R1000C3</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C9</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C8:R6C9, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C8:R6C10</Range>
   <Condition>
    <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C10</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C10:R6C10, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet> 
 <Worksheet ss:Name="App Interface Dependencies CACA">
        <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
         x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="21"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="126"/>
         <Column ss:AutoFitWidth="0" ss:Width="135" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="133"/>
         <Column ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="135"/>
         <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="159"/>
         <Column ss:AutoFitWidth="0" ss:Width="104"/>
         <Column ss:AutoFitWidth="0" ss:Width="93"/>
         <Row ss:AutoFitHeight="0"/>
         <Row ss:AutoFitHeight="0" ss:Height="29">
          <Cell ss:Index="2" ss:StyleID="s72"><Data ss:Type="String">Application Interface Dependencies</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
          <Cell ss:Index="2"><Data ss:Type="String">Captures the information dependencies between applications using an app interface; where information passes between applications, the method for passing the information and the interface used</Data></Cell>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17">
          <Cell ss:Index="11"><Data ss:Type="String"></Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="20">
          <Cell ss:Index="2" ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Interface App Used</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
          <Cell ss:Index="11" ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8"/>
         {{#each this}}
            {{#ifNotEquals this.type 'Application_Provider_Interface'}}
             {{else}}
                 {{#each this.allAPIData}}  
                 {{#ifEquals this.fromtype 'Composite_Application_Provider'}}
                 {{#ifEquals this.type 'Composite_Application_Provider'}}
                    <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell ss:Index="2"><Data ss:Type="String">{{this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.data}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromData}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="11"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                    </Row> 
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifNotEquals}}
   {{/each}}
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Unsynced/>
         <Print>
          <ValidPrinterInfo/>
          <PaperSizeIndex>9</PaperSizeIndex>
          <VerticalResolution>0</VerticalResolution>
         </Print>
         <Zoom>130</Zoom>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>7</ActiveRow>
           <ActiveCol>7</ActiveCol>
           <RangeSelection>R2C2:R8C8</RangeSelection>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C6:R99641C6,R8C2:R9641C2</Range>
            <Type>List</Type>
            <Value>Applications!R8C3:R5000C3</Value>
            </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C4:R9641C4</Range>
            <Type>List</Type>
            <Value>'App Pro Interface'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R9641C3,R8C5:R9000C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Information Exchanged'!R8C3:R1000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R9C7</Range>
         <Type>List</Type>
         <Value>Valid_Data_Aquisition_Methods</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R9C8</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
        </DataValidation>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C12</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C11:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C13</Range>
         <Condition>
          <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C13</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C13:R6C13, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
</Worksheet>    
<Worksheet ss:Name="App Interface Dependencies CAAP">
        <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
         x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="21"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="126"/>
         <Column ss:AutoFitWidth="0" ss:Width="135" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="133"/>
         <Column ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="135"/>
         <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="159"/>
         <Column ss:AutoFitWidth="0" ss:Width="104"/>
         <Column ss:AutoFitWidth="0" ss:Width="93"/>
         <Row ss:AutoFitHeight="0"/>
         <Row ss:AutoFitHeight="0" ss:Height="29">
          <Cell ss:Index="2" ss:StyleID="s72"><Data ss:Type="String">Application Interface Dependencies</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
          <Cell ss:Index="2"><Data ss:Type="String">Captures the information dependencies between applications using an app interface; where information passes between applications, the method for passing the information and the interface used</Data></Cell>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17">
          <Cell ss:Index="11"><Data ss:Type="String"></Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="20">
          <Cell ss:Index="2" ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Interface App Used</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
          <Cell ss:Index="11" ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8"/>
         {{#each this}}
            {{#ifNotEquals this.type 'Application_Provider_Interface'}}
             {{else}}
                 {{#each this.allAPIData}} 
                 {{#ifEquals fromtype 'Application_Provider'}}
                 {{#ifEquals type 'Composite_Application_Provider'}}
                    <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell ss:Index="2"><Data ss:Type="String">{{this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.data}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromData}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="11"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                    </Row> 
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifNotEquals}}
   {{/each}}
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Unsynced/>
         <Print>
          <ValidPrinterInfo/>
          <PaperSizeIndex>9</PaperSizeIndex>
          <VerticalResolution>0</VerticalResolution>
         </Print>
         <Zoom>130</Zoom>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>7</ActiveRow>
           <ActiveCol>7</ActiveCol>
           <RangeSelection>R2C2:R8C8</RangeSelection>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C2:R9641C2</Range>
         <Type>List</Type>
         <Value>Applications!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R99641C6</Range>
         <Type>List</Type>
         <Value>'Application Modules'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R9641C3,R8C5:R9000C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Information Exchanged'!R8C3:R1000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C4:R9641C4</Range>
            <Type>List</Type>
            <Value>'App Pro Interface'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R9C7</Range>
         <Type>List</Type>
         <Value>Valid_Data_Aquisition_Methods</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R9C8</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
        </DataValidation>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C12</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C11:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C13</Range>
         <Condition>
          <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C13</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C13:R6C13, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
</Worksheet> 
<Worksheet ss:Name="App Interface Dependencies APCA">
        <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
         x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="21"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="126"/>
         <Column ss:AutoFitWidth="0" ss:Width="135" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="133"/>
         <Column ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="135"/>
         <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="159"/>
         <Column ss:AutoFitWidth="0" ss:Width="104"/>
         <Column ss:AutoFitWidth="0" ss:Width="93"/>
         <Row ss:AutoFitHeight="0"/>
         <Row ss:AutoFitHeight="0" ss:Height="29">
          <Cell ss:Index="2" ss:StyleID="s72"><Data ss:Type="String">Application Interface Dependencies</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
          <Cell ss:Index="2"><Data ss:Type="String">Captures the information dependencies between applications using an app interface; where information passes between applications, the method for passing the information and the interface used</Data></Cell>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17">
          <Cell ss:Index="11"><Data ss:Type="String"></Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="20">
          <Cell ss:Index="2" ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Interface App Used</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
          <Cell ss:Index="11" ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8"/>
         {{#each this}}
            {{#ifNotEquals this.type 'Application_Provider_Interface'}}
             {{else}}
                 {{#each this.allAPIData}} 
                 {{#ifEquals fromtype 'Composite_Application_Provider'}}
                 {{#ifEquals type 'Application_Provider'}}
                    <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell ss:Index="2"><Data ss:Type="String">{{this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.data}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromData}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="11"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                    </Row> 
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifNotEquals}}
   {{/each}}
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Unsynced/>
         <Print>
          <ValidPrinterInfo/>
          <PaperSizeIndex>9</PaperSizeIndex>
          <VerticalResolution>0</VerticalResolution>
         </Print>
         <Zoom>130</Zoom>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>7</ActiveRow>
           <ActiveCol>7</ActiveCol>
           <RangeSelection>R2C2:R8C8</RangeSelection>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R99641C6</Range>
         <Type>List</Type>
         <Value>Applications!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
        <Range>R8C2:R10002C2</Range>
        <Type>List</Type>
        <Value>'Application Modules'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R9641C3,R8C5:R9000C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Information Exchanged'!R8C3:R1000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C4:R9641C4</Range>
            <Type>List</Type>
            <Value>'App Pro Interface'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R9C7</Range>
         <Type>List</Type>
         <Value>Valid_Data_Aquisition_Methods</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R9C8</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
        </DataValidation>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C12</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C11:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C13</Range>
         <Condition>
          <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C13</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C13:R6C13, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
</Worksheet> 
<Worksheet ss:Name="App Interface Dependencies APAP">
        <Table ss:ExpandedColumnCount="13" x:FullColumns="1"
         x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:AutoFitWidth="0" ss:Width="21"/>
         <Column ss:AutoFitWidth="0" ss:Width="190"/>
         <Column ss:AutoFitWidth="0" ss:Width="126"/>
         <Column ss:AutoFitWidth="0" ss:Width="135" ss:Span="1"/>
         <Column ss:Index="6" ss:AutoFitWidth="0" ss:Width="133"/>
         <Column ss:AutoFitWidth="0" ss:Width="123"/>
         <Column ss:AutoFitWidth="0" ss:Width="135"/>
         <Column ss:Index="11" ss:AutoFitWidth="0" ss:Width="159"/>
         <Column ss:AutoFitWidth="0" ss:Width="104"/>
         <Column ss:AutoFitWidth="0" ss:Width="93"/>
         <Row ss:AutoFitHeight="0"/>
         <Row ss:AutoFitHeight="0" ss:Height="29">
          <Cell ss:Index="2" ss:StyleID="s72"><Data ss:Type="String">Application Interface Dependencies</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
          <Cell ss:Index="2"><Data ss:Type="String">Captures the information dependencies between applications using an app interface; where information passes between applications, the method for passing the information and the interface used</Data></Cell>
         </Row>
         <Row ss:Index="5" ss:AutoFitHeight="0" ss:Height="17">
          <Cell ss:Index="11"><Data ss:Type="String"></Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="20">
          <Cell ss:Index="2" ss:StyleID="s68"><Data ss:Type="String">Source Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Interface App Used</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Information Exchanged</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Target Application</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Acquisition Method</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Frequency</Data></Cell>
          <Cell ss:Index="11" ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
          <Cell ><Data ss:Type="String"> </Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="8"/>
         {{#each this}}
            {{#ifNotEquals this.type 'Application_Provider_Interface'}}
             {{else}}
                 {{#each this.allAPIData}} 
                 {{#ifEquals fromtype 'Application_Provider'}}
                 {{#ifEquals type 'Application_Provider'}}
                    <Row ss:AutoFitHeight="0" ss:Height="17">
                    <Cell ss:Index="2"><Data ss:Type="String">{{this.toApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.data}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{../this.ApplicationName}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromData}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.fromApp}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.method}}</Data></Cell>
                    <Cell><Data ss:Type="String">{{this.frequency}}</Data></Cell>
                    <Cell ss:Index="11"></Cell>
                    <Cell></Cell>
                    <Cell></Cell>
                    </Row> 
                {{/ifEquals}}
                {{/ifEquals}}
            {{/each}}
            {{/ifNotEquals}}
   {{/each}}
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Unsynced/>
         <Print>
          <ValidPrinterInfo/>
          <PaperSizeIndex>9</PaperSizeIndex>
          <VerticalResolution>0</VerticalResolution>
         </Print>
         <Zoom>130</Zoom>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>7</ActiveRow>
           <ActiveCol>7</ActiveCol>
           <RangeSelection>R2C2:R8C8</RangeSelection>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C6:R99641C6,R8C2:R9641C2</Range>
         <Type>List</Type>
         <Value>'Application Modules'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C3:R9641C3,R8C5:R9000C5</Range>
         <Type>List</Type>
         <UseBlank/>
         <Value>'Information Exchanged'!R8C3:R1000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
            <Range>R8C4:R9641C4</Range>
            <Type>List</Type>
            <Value>'App Pro Interface'!R8C3:R5000C3</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C7:R9C7</Range>
         <Type>List</Type>
         <Value>Valid_Data_Aquisition_Methods</Value>
        </DataValidation>
        <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R8C8:R9C8</Range>
         <Type>List</Type>
         <CellRangeList/>
         <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
        </DataValidation>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C12</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C11:R6C12, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C11:R6C13</Range>
         <Condition>
          <Value1>ISERROR(SEARCH(&quot;OK&quot;,RC))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
        <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
         <Range>R6C13</Range>
         <Condition>
          <Value1>AND(COUNTIF(R6C13:R6C13, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
          <Format Style='color:#9C0006;background:#FFC7CE'/>
         </Condition>
        </ConditionalFormatting>
</Worksheet> 
</script>
<script  id="list-tab" type="text/x-handlebars-template">
  <Worksheet ss:Name="Applications">
  	<Table ss:ExpandedColumnCount="11" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="22"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="217"/>
   <Column ss:AutoFitWidth="0" ss:Width="297"/>
   <Column  ss:AutoFitWidth="0" ss:Width="123"/>
   <Column  ss:AutoFitWidth="0" ss:Width="206"/>
   <Column ss:AutoFitWidth="0" ss:Width="200"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s72" ><Data ss:Type="String">Applications (Composite Application Provider)</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:MergeAcross="9" ><Data ss:Type="String">Captures information about the Applications used within the organisation</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2"  ss:StyleID="s68"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Description</Data></Cell>
    <Cell ><Data ss:Type="String"></Data></Cell>
    <Cell  ><Data ss:Type="String"></Data></Cell>
    <Cell ><Data ss:Type="String"></Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
   {{#each this}}
	{{#ifEquals this.valueClass 'Composite_Application_Provider'}}
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell ss:Index="2" ><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell ><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Valid_Composite_Applications"/></Cell>
     <Cell><Data ss:Type="String">{{this.description}}</Data></Cell>
    <Cell />
    <Cell />
    <Cell />
   </Row>
	{{/ifEquals}}
   {{/each}}
	</Table>
    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  	</WorksheetOptions>
  	<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R11C5</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
	</DataValidation>
	<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R8C7:R250C7</Range>
	<Type>List</Type>
	<Value>Valid_Composite_Applications</Value>
	</DataValidation>
	<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R8C6:R240C6</Range>
	<Type>List</Type>
	<UseBlank/>
	<Value>INDIRECT(&quot;TechProds[Name]&quot;)</Value>
	</DataValidation>
	<ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R6C2,R6C4</Range>
	<Condition>
		<Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
		<Format Style='color:#9C0006;background:#FFC7CE'/>
	</Condition>
	</ConditionalFormatting>
	<ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R6C3</Range>
	<Condition>
		<Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
		<Format Style='color:#9C0006;background:#FFC7CE'/>
	</Condition>
	</ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="Application Modules">
  <Table ss:ExpandedColumnCount="9" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="25"/>
   <Column ss:AutoFitWidth="0" ss:Width="64"/>
   <Column ss:AutoFitWidth="0" ss:Width="184"/>
   <Column ss:AutoFitWidth="0" ss:Width="267"/>
   <Column ss:AutoFitWidth="0" ss:Width="174"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2"  ss:StyleID="s72"><Data ss:Type="String">Application Modules</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:MergeAcross="7"><Data ss:Type="String">Captures information about the Applications Modules (Application Providers) that are contained within an Application (Composite Application Provider)</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2"  ss:StyleID="s68"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s68"><Data ss:Type="String">Parent Application</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="4">
    <Cell ss:Index="5"/>
   </Row>
    {{#each this}}
	{{#ifEquals this.valueClass 'Application_Provider'}}
   <Row ss:AutoFitHeight="0" ss:Height="17">
    <Cell ss:Index="2"><Data ss:Type="String">{{this.id}}</Data></Cell>
    <Cell><Data ss:Type="String">{{this.name}}</Data><NamedCell
      ss:Name="Valid_App_Module"/></Cell>
     <Cell><Data ss:Type="String">{{this.description}}</Data></Cell>
    <Cell/>
   </Row>
   {{/ifEquals}}
   {{/each}}
	</Table>
    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  	</WorksheetOptions>
	<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R8C5:R2500C5</Range>
	<Type>List</Type>
	<Value>'Applications'!R8C3:R4000C3</Value>
	</DataValidation>
	<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R8C6:R240C6</Range>
	<Type>List</Type>
	<UseBlank/>
	<Value>INDIRECT(&quot;TechProds[Name]&quot;)</Value>
	</DataValidation>
	<ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R6C2,R6C4</Range>
	<Condition>
		<Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
		<Format Style='color:#9C0006;background:#FFC7CE'/>
	</Condition>
	</ConditionalFormatting>
	<ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
	<Range>R6C3</Range>
	<Condition>
		<Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
		<Format Style='color:#9C0006;background:#FFC7CE'/>
	</Condition>
	</ConditionalFormatting>
 </Worksheet>
 <Worksheet ss:Name="App Pro Interface">
  <Table ss:ExpandedColumnCount="11" x:FullColumns="1"
   x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
   <Column ss:AutoFitWidth="0" ss:Width="22"/>
   <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="217"/>
   <Column ss:AutoFitWidth="0" ss:Width="297"/>
   <Column ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="123"/>
   <Column ss:Hidden="1" ss:AutoFitWidth="0" ss:Width="206"/>
   <Column ss:AutoFitWidth="0" ss:Width="200"/>
   <Row ss:AutoFitHeight="0"/>
   <Row ss:AutoFitHeight="0" ss:Height="29">
    <Cell ss:Index="2" ss:MergeAcross="2" ss:StyleID="s72" ><Data ss:Type="String">Application Provider Interface</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="19">
    <Cell ss:Index="2" ss:MergeAcross="9" ><Data ss:Type="String">Captures information about the Applications that act as an intermediary between 2 or more Applications that are exchanging information or functionality</Data></Cell>
   </Row>
   <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="20">
    <Cell ss:Index="2"  ss:StyleID="s68"><Data ss:Type="String">ID</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Name</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Description</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Interface CI #</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Technology Used</Data></Cell>
    <Cell ss:StyleID="s68" ><Data ss:Type="String">Containing Application</Data></Cell>
   </Row>
   <Row ss:AutoFitHeight="0" ss:Height="8"/>
    {{#each this}}
	{{#ifEquals this.valueClass 'Application_Provider_Interface'}}
	<Row ss:AutoFitHeight="0" ss:Height="17">
		<Cell ss:Index="2" ><Data ss:Type="String">{{this.id}}</Data></Cell>
		<Cell ><Data ss:Type="String">{{this.name}}</Data></Cell>
		<Cell ><Data ss:Type="String">{{this.description}}</Data></Cell>
		<Cell />
		<Cell />
		<Cell />
	</Row>   
    {{/ifEquals}}
   {{/each}}
	</Table>
    <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
   <PageSetup>
    <Header x:Margin="0.3"/>
    <Footer x:Margin="0.3"/>
    <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
   </PageSetup>
   <Unsynced/>
   <ProtectObjects>False</ProtectObjects>
   <ProtectScenarios>False</ProtectScenarios>
  </WorksheetOptions>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C5:R11C5</Range>
   <Type>List</Type>
   <CellRangeList/>
   <Value>&quot;Ad-Hoc, annual, quarterly, monthly, weekly ,daily, hourly, Real-Time&quot;</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C7:R2500C7</Range>
   <Type>List</Type>
   <Value>'Applications'!R8C3:R4000C3</Value>
  </DataValidation>
  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R8C6:R240C6</Range>
   <Type>List</Type>
   <UseBlank/>
   <Value>INDIRECT(&quot;TechProds[Name]&quot;)</Value>
  </DataValidation>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C2,R6C4</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C2:R6C2, RC)+COUNTIF(R6C4:R6C4, RC)+COUNTIF(R6C6:R6C6, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">
   <Range>R6C3</Range>
   <Condition>
    <Value1>AND(COUNTIF(R6C3:R6C3, RC)+COUNTIF(R6C5:R6C5, RC)+COUNTIF(R6C7:R6C7, RC)&gt;1,NOT(ISBLANK(RC)))</Value1>
    <Format Style='color:#9C0006;background:#FFC7CE'/>
   </Condition>
  </ConditionalFormatting>
 </Worksheet>

</script>	
<script  id="info-tab" type="text/x-handlebars-template">
    <Worksheet ss:Name="Information Exchanged">
        <Table ss:ExpandedColumnCount="8" x:FullColumns="1"
         x:FullRows="1" ss:DefaultColumnWidth="66" ss:DefaultRowHeight="16">
         <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="69"/>
         <Column ss:AutoFitWidth="0" ss:Width="218"/>
         <Column ss:AutoFitWidth="0" ss:Width="377"/>
         <Row ss:AutoFitHeight="0"/>
         <Row ss:AutoFitHeight="0" ss:Height="29">
          <Cell ss:Index="2" ss:MergeAcross="4" ss:StyleID="s72"><Data ss:Type="String">Information Exchanged</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0">
          <Cell ss:Index="2" ss:MergeAcross="4"><Data ss:Type="String">Used to capture the Information exchanged between applications</Data></Cell>
         </Row>
         <Row ss:Index="6" ss:AutoFitHeight="0" ss:Height="20">
          <Cell ss:Index="2" ss:StyleID="s68"><Data ss:Type="String">ID</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Name</Data></Cell>
          <Cell ss:StyleID="s68"><Data ss:Type="String">Description</Data></Cell>
         </Row>
         <Row ss:AutoFitHeight="0" ss:Height="6">
          <Cell ss:Index="2"/>
          <Cell/>
          <Cell/>
         </Row>
         {{#each this}}
         <Row ss:AutoFitHeight="0" ss:Height="17">
          <Cell ss:Index="2"><Data ss:Type="String">{{this.id}}</Data></Cell>
          <Cell><Data ss:Type="String">{{this.name}}</Data></Cell>
          <Cell><Data ss:Type="String">{{this.description}}</Data></Cell>
         </Row>
         {{/each}}
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Unsynced/>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>8</ActiveRow>
           <ActiveCol>2</ActiveCol>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
       </Worksheet>
</script>	
<script  id="dependencies-tab" type="text/x-handlebars-template">
</script>
</body>
<script>
 <xsl:call-template name="RenderViewerAPIJSFunction"> 
    <xsl:with-param name="viewerAPIPath" select="$apiPathNodes"></xsl:with-param>
    <xsl:with-param name="viewerAPIPathInfo" select="$apiPathInfo"></xsl:with-param>
 </xsl:call-template>
</script>			
		</html>
	</xsl:template>
 
	<xsl:template name="GetViewerAPIPath">
        <xsl:param name="apiReport"/>
        
        <xsl:variable name="dataSetPath">
            <xsl:call-template name="RenderLinkText">
                <xsl:with-param name="theXSL" select="$apiReport/own_slot_value[slot_reference = 'report_xsl_filename']/value"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:value-of select="$dataSetPath"/>
    </xsl:template>
	
	 <xsl:template name="RenderViewerAPIJSFunction">
          <xsl:param name="viewerAPIPath"></xsl:param>
          <xsl:param name="viewerAPIPathInfo"></xsl:param> 
        var viewAPIData = '<xsl:value-of select="$viewerAPIPath"/>';
		var viewAPIDataInfo = '<xsl:value-of select="$viewerAPIPathInfo"/>';
        console.log(viewAPIData)
        console.log(viewAPIDataInfo)
		 
        //set a variable to a Promise function that calls the API Report using the given path and returns the resulting data
        
        var promise_loadViewerAPIData = function(apiDataSetURL) {
            return new Promise(function (resolve, reject) {
                if (apiDataSetURL != null) {
                    var xmlhttp = new XMLHttpRequest();
    
                    xmlhttp.onreadystatechange = function () {
                        if (this.readyState == 4 &amp;&amp; this.status == 200) {
                            var viewerData = JSON.parse(this.responseText);
                            resolve(viewerData);
                            <!--$('#ess-data-gen-alert').hide();-->
                        }
                    };
                    xmlhttp.onerror = function () {
                        reject(false);
                    };
                    xmlhttp.open("GET", apiDataSetURL, true);
                    xmlhttp.send();
                } else {
                    reject(false);
                }
            });
        };
        var applicationTechArch={};
	   var applicationDependencies={};

	    Promise.all([
                 promise_loadViewerAPIData(viewAPIData),
                 promise_loadViewerAPIData(viewAPIDataInfo)
				]).then(function (responses){  

 $('.appDepSpin').hide();
    let appList=responses[0].applications
    let infoList=responses[1].information_representation
   appList=appList.concat(responses[0].apis)
 
	var listFragment   = $("#list-tab").html();
   	listTemplate = Handlebars.compile(listFragment);
	
	var appDependencyFragment   = $("#appdep-tab").html();
   	appDependencyTemplate = Handlebars.compile(appDependencyFragment);
	
	var infoFragment   = $("#info-tab").html();
    infoTemplate = Handlebars.compile(infoFragment); 


    Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) { 
    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
    });

    Handlebars.registerHelper('ifNotEquals', function(arg1, arg2, options) { 
        return (arg1 != arg2) ? options.fn(this) : options.inverse(this);
        });
    
	Handlebars.registerHelper('greaterThan', function (v1, v2, options) {
	'use strict';
	   if (v1>v2) {
		 return options.fn(this);
	  }
	  return options.inverse(this);
	});

	
	
	$('#genExcel').click(function(){
 
	var xmlhead, xmlfoot;
	getXML('integration/launchpad_plus_head.xml').then(function(response){
		xmlhead=response;	

		}).then(function(response){ 
 
		var LaunchpadJSON=[];
		ExcelArray=[];
	var worksheetText='';
   worksheetText  
 
	   ExcelString=xmlhead+worksheetText+listTemplate(appList)+infoTemplate(infoList)+appDependencyTemplate(appAPUList)+'&lt;/Workbook>';
 
		ExcelArray.push(ExcelString)
 
 	var blob = new Blob([ExcelArray[0]], {type: "text/xml"});
 	saveAs(blob, "launchpad_appdep_export.xml");
	
   //console.log(ExcelArray[0])
	  		});
		});
				})
   
    </xsl:template>
<xsl:template match="node()" mode="getApps">
{"name": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","id": "<xsl:value-of select="current()/name"/>","type":"<xsl:value-of select="current()/type"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>
<xsl:template match="node()" mode="getAppAPUs">
     <xsl:variable name="usages" select="key('allArchUsageskey',current()/name)"/>  
   
    <xsl:variable name="FROMs" select="key('allAPUsFromkey',$usages/name)"/>  
     <xsl:variable name="TOs" select="key('allAPUsTokey',$usages/name)"/>
     {"ApplicationName": "<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>","ApplicationID": "<xsl:value-of select="current()/name"/>","type":"<xsl:value-of select="current()/type"/>","From":[ <xsl:apply-templates select="$FROMs" mode="getAPUtoAPUFrom"></xsl:apply-templates>],"To":[<xsl:apply-templates select="$TOs" mode="getAPUtoAPUTo"></xsl:apply-templates>],
     "usage":[<xsl:for-each select="$usages">"<xsl:value-of select="current()/own_slot_value[slot_reference='used_in_static_app_provider_architecture']/value"/>"<xsl:if test="not(position()=last())">,</xsl:if></xsl:for-each>],
   	}<xsl:if test="not(position()=last())">,</xsl:if>     
</xsl:template>
   
    <xsl:template match="node()" mode="getAPUtoAPUFrom"> 
        <xsl:variable name="data" select="key('allInfotoAPUkey',current()/name)"/>    
        <xsl:variable name="thisAIRwithAPU" select="$allAPPINFOREPs[name=$data/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value]"/>
        <xsl:variable name="thisInfoReps" select="key('allInfoRepkey', $thisAIRwithAPU/name)"></xsl:variable>
        {"apuid":"<xsl:value-of select="current()/name"/>","aputype":"<xsl:value-of select="current()/type"/>", "to":"<xsl:value-of select="current()/own_slot_value[slot_reference=':TO']/value"/>",
         "data":[<xsl:apply-templates select="$thisInfoReps" mode="data"><xsl:with-param name="method" select="$data/own_slot_value[slot_reference='atire_acquisition_method']/value"/><xsl:with-param name="freq" select="$data/own_slot_value[slot_reference='atire_service_quals']/value"/></xsl:apply-templates>]}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template> 
    <xsl:template match="node()" mode="getAPUtoAPUTo"> 
        {      <xsl:variable name="data" select="key('allInfotoAPUkey',current()/name)"/>    
        <xsl:variable name="thisAIRwithAPU" select="$allAPPINFOREPs[name=$data/own_slot_value[slot_reference='atire_app_pro_to_inforep']/value]"/>
        <xsl:variable name="thisInfoReps" select="key('allInfoRepkey', $thisAIRwithAPU/name)"></xsl:variable>
            "apuid":"<xsl:value-of select="current()/name"/>","aputype":"<xsl:value-of select="current()/type"/>",  "from":"<xsl:value-of select="current()/own_slot_value[slot_reference=':FROM']/value"/>",
            "data":[<xsl:apply-templates select="$thisInfoReps" mode="data"><xsl:with-param name="method" select="$data/own_slot_value[slot_reference='atire_acquisition_method']/value"/><xsl:with-param name="freq" select="$data/own_slot_value[slot_reference='atire_service_quals']/value"/></xsl:apply-templates>]}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template> 
 <xsl:template match="node()" mode="getContainedApps">
         <xsl:variable name="parent" select="$allApplications[own_slot_value[slot_reference='contained_application_providers']/value=current()/name]"/>
        {"subId":"<xsl:value-of select="current()/name"/>","subName":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "parent":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$parent"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>", "parentID":"<xsl:value-of select="$parent/name"/>"}<xsl:if test="not(position()=last())">,</xsl:if>
    </xsl:template> 
    <xsl:template match="node()" mode="data">
          <xsl:param name="method"/>
          <xsl:param name="freq"/>
          <xsl:variable name="aqmethod" select="$allDataAcquisition[name=$method]"/>
          <xsl:variable name="aqfreq" select="$allInfoQual[name=$freq]"/>
        {"id":"<xsl:value-of select="current()/name"/>",
        "method":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aqmethod"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
        "frequency":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="$aqfreq"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>",
        "name":"<xsl:call-template name="RenderMultiLangInstanceName"><xsl:with-param name="theSubjectInstance" select="current()"/><xsl:with-param name="isRenderAsJSString" select="true()"/></xsl:call-template>"}<xsl:if test="not(position()=last())">,</xsl:if>
</xsl:template>
</xsl:stylesheet>  
