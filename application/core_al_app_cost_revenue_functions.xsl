<?xml version="1.0" encoding="UTF-8"?>
<!-- All Copyright © 2016 Enterprise Architecture Solutions Limited. Not for redistribution.-->   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:eas="http://www.enterprise-architecture.org/essential" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns:easlang="http://www.enterprise-architecture.org/essential/language">

    <!-- 03.12.2014 JP - A set of common functions nad templates for assessment of applications -->
    <xsl:import href="../common/core_utilities.xsl"/>
    
    <xsl:variable name="allTechFunctionTypes" select="/node()/simple_instance[(type='Technology_Function_Type')]"/>
    <xsl:variable name="allTechComponents" select="/node()/simple_instance[(type='Technology_Component')]"/>
    <xsl:variable name="allTechFunctions" select="/node()/simple_instance[(type='Technology_Function')]"/>
    <xsl:variable name="allTechProducts" select="/node()/simple_instance[(type='Technology_Product')]"/>
    <xsl:variable name="allTechProductSuppliers" select="/node()/simple_instance[name = $allTechProducts/own_slot_value[slot_reference='supplier_technology_product']/value]"/>
    
    <xsl:variable name="allAppProviderRoles" select="/node()/simple_instance[(type='Application_Provider_Role')]"/>
    
    <xsl:variable name="allTechFunctionImpls" select="/node()/simple_instance[(type='Technology_Function_Implementation')]"/>

    <xsl:variable name="allTechSvcQualVals" select="/node()/simple_instance[(type='Technology_Service_Quality_Value')]"/>
    <xsl:variable name="allAppSvcQualVals" select="/node()/simple_instance[(type='Application_Service_Quality_Value')]"/>
    <xsl:variable name="allBusSvcQualVals" select="/node()/simple_instance[(type='Business_Service_Quality_Value')]"/>
    <xsl:variable name="allSvcQualVals" select="$allTechSvcQualVals union $allAppSvcQualVals union $allBusSvcQualVals"/>
    
    <xsl:variable name="allTechSvcQuals" select="/node()/simple_instance[name = $allTechSvcQualVals/own_slot_value[slot_reference='usage_of_service_quality']/value][own_slot_value[slot_reference='sq_for_classes']/value=('Application_Provider','Composite_Application_Provider')]"/>
    <xsl:variable name="allAppSvcQuals" select="/node()/simple_instance[name = $allAppSvcQualVals/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
    <xsl:variable name="allBusSvcQuals" select="/node()/simple_instance[name = $allBusSvcQualVals/own_slot_value[slot_reference='usage_of_service_quality']/value][own_slot_value[slot_reference='sq_for_classes']/value=('Application_Provider_Role', 'Application_Provider', 'Composite_Application_Provider')]"/>
    <xsl:variable name="allSvcQuals" select="$allAppSvcQuals union $allTechSvcQuals union $allBusSvcQuals"/>

    <!--<xsl:variable name="allTechSvcQuals" select="/node()/simple_instance[(type='Technology_Service_Quality')]"/>
    <xsl:variable name="allAppSvcQuals" select="/node()/simple_instance[(type='Application_Service_Quality')]"/>
    <xsl:variable name="allBusSvcQuals" select="/node()/simple_instance[(type='Business_Service_Quality')]"/>-->
    
    

    
    <xsl:variable name="allTechAssessments" select="/node()/simple_instance[(type='Technology_Performance_Measure')]"/>
    <xsl:variable name="allAppAssessments" select="/node()/simple_instance[(type='Application_Performance_Measure')]"/>
    <xsl:variable name="allBusAssessments" select="/node()/simple_instance[(type='Business_Performance_Measure')]"/>
    
    
    <!-- The maximum score for any criteria -->
    <xsl:variable name="maxScore" select="5"/>
    <xsl:variable name="barsPerChart" select="20"/>
    
    <xsl:variable name="floatFormat" select="'0'"/>
    <xsl:variable name="singleDigitFloatFormat" select="'0.0'"/>
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR AN APPLICATION'S IMPLEMENTATION OF A SERVICE -->
    <!--<xsl:function as="xs:integer" name="eas:get_app_score_for_service">
        <xsl:param name="appService"/>
        <xsl:param name="app"/>
        
        <xsl:variable name="appProRole" select="$allAppProviderRoles[(own_slot_value[slot_reference='role_for_application_provider']/value = $app/name) and (own_slot_value[slot_reference='implementing_application_service']/value = $appService/name)]"/>
        <xsl:value-of select="eas:get_apr_total_bus_score($appProRole)"/>
        
    </xsl:function>-->
    
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR A TECHNOLOGY PRODUCT -->
    <xsl:function as="xs:integer" name="eas:get_app_overall_bus_score">
        <xsl:param name="appSvcList"/>
        <xsl:param name="app"/>
        <xsl:param name="totalScore"/>
        
        
        <xsl:choose>
            <xsl:when test="count($appSvcList) > 0">
                <xsl:variable name="nextAppSvc" select="$appSvcList[1]"/>
                <xsl:variable name="nextAppProRole" select="$allAppProviderRoles[(own_slot_value[slot_reference='role_for_application_provider']/value = $app/name) and (own_slot_value[slot_reference='implementing_application_service']/value = $nextAppSvc/name)]"/>
                <xsl:choose>
                    <xsl:when test="count($nextAppProRole) > 0">
                        <xsl:variable name="nextAppProRoleScore" select="eas:get_apr_total_bus_score($nextAppProRole)"/>
                        <xsl:value-of select="eas:get_app_overall_bus_score(remove($appSvcList, 1), $app, $totalScore + $nextAppProRoleScore)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_app_overall_bus_score(remove($appSvcList, 1), $app, $totalScore)"/>           
                    </xsl:otherwise>
                </xsl:choose>           
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <xsl:function as="xs:integer" name="eas:get_overall_max_bus_score_for_app">
        <xsl:param name="app"/>
        <xsl:param name="appSvcList"/>
        <xsl:param name="totalMaxScore"/>
        
        <xsl:choose>
            <xsl:when test="count($appSvcList) > 0">
                <xsl:variable name="nextAppSvc" select="$appSvcList[1]"/>
                <xsl:variable name="nextAppProRole" select="$allAppProviderRoles[(own_slot_value[slot_reference='role_for_application_provider']/value = $app/name) and (own_slot_value[slot_reference='implementing_application_service']/value = $nextAppSvc/name)]"/>
                <xsl:variable name="nextAppProRoleMaxScore" select="eas:get_apr_max_bus_score($nextAppProRole)"/>
                <xsl:value-of select="eas:get_overall_max_bus_score_for_app(remove($appSvcList, 1), $app, $totalMaxScore + $nextAppProRoleMaxScore)"/>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    

    
    
    <xsl:function as="xs:integer" name="eas:get_overall_max_bus_score_for_physproc2apr">
        <xsl:param name="physproc2aprs"/>
        <xsl:param name="totalMaxScore"/>
        
        
        <xsl:variable name="nextPhysproc2Apr" select="$physproc2aprs[1]"/>
        <xsl:value-of select="eas:get_physproc2apr_max_bus_score($nextPhysproc2Apr)"/>
        
        <!--<xsl:choose>
            <xsl:when test="count($physproc2aprs) > 0">
                <xsl:variable name="nextPhysproc2Apr" select="$physproc2aprs[1]"/>
                <xsl:variable name="nextPhysproc2AprMaxScore" select="eas:get_physproc2apr_max_bus_score($nextPhysproc2Apr)"/>
                <xsl:value-of select="eas:get_overall_max_bus_score_for_physproc2apr(remove($physproc2aprs, 1), $totalMaxScore + $nextPhysproc2AprMaxScore)"/>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE PERCENTAGE WEIGHTED SCORE FOR AN APPLICATION'S IMPLEMENTATION OF A SERVICE -->
    <xsl:function as="xs:float" name="eas:get_appprorole_bus_percentscore">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="aprScore" select="eas:get_apr_total_bus_score($appProRole)"/>
        <xsl:variable name="aprMaxScore" select="eas:get_apr_max_bus_score($appProRole)"/>
        <xsl:choose>
            <xsl:when test="($aprScore = 0) or ($aprMaxScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$aprScore div $aprMaxScore * 100"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE PERCENTAGE WEIGHTED SCORE FOR AN APPLICATION'S IMPLEMENTATION OF A SERVICE -->
    <xsl:function as="xs:float" name="eas:get_app_percentscore_for_service">
        <xsl:param name="appService"/>
        <xsl:param name="app"/>
        
        <xsl:variable name="appProRole" select="$allAppProviderRoles[(own_slot_value[slot_reference='role_for_application_provider']/value = $app/name) and (own_slot_value[slot_reference='implementing_application_service']/value = $appService/name)]"/>
        <xsl:variable name="aprScore" select="eas:get_apr_total_bus_score($appProRole)"/>
        <xsl:variable name="aprMaxScore" select="eas:get_apr_max_bus_score($appProRole)"/>
        <xsl:choose>
            <xsl:when test="($aprScore = 0) or ($aprMaxScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$aprScore div $aprMaxScore * 100"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR AN APPLICATION'S IMPLEMENTATION OF A SERVICE -->
    <xsl:function as="xs:integer" name="eas:get_apr_total_bus_score">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="aprBusAssessments" select="$allBusAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="aprBusAssessmentSQValues" select="$allBusSvcQualVals[name = $aprBusAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        
        <xsl:value-of select="eas:get_total_weighted_score($aprBusAssessmentSQValues, 0)"/>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM WEIGHTED SCORE FOR AN APPLICATION'S IMPLEMENTATION OF A SERVICE -->
    <xsl:function as="xs:integer" name="eas:get_apr_max_bus_score">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="aprBusAssessments" select="$allBusAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="aprBusAssessmentSQValues" select="$allBusSvcQualVals[name = $aprBusAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>        
        
        <xsl:value-of select="eas:get_total_max_score($aprBusAssessmentSQValues, $maxScore, 0)"/>

    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM WEIGHTED SCORE FOR AN APPLICATION'S SUPPORT OF A PHYSICAL PROCESS -->
    <xsl:function as="xs:integer" name="eas:get_physproc2apr_max_bus_score">
        <xsl:param name="physbusproc2aprs"/>
        
        <xsl:variable name="aprBusAssessments" select="$allBusAssessments[name = $physbusproc2aprs/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="aprBusAssessmentSQValues" select="$allBusSvcQualVals[name = $aprBusAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>        
        
        <xsl:value-of select="eas:get_bussvcqualvals_total_max_score($aprBusAssessmentSQValues, $maxScore, 0)"/>
        
    </xsl:function>
    
    
    <!-- GET THE OVERALL TECHNICAL RISK SCORE FOR AN APPLICATION PROVIDER -->
    <xsl:function as="xs:float" name="eas:get_app_overall_tech_percent_score">
        <xsl:param name="app"/>
        <xsl:param name="appMaxScore"/>
        
        <xsl:variable name="appScore" select="eas:get_apr_total_tech_score($app)"/>
        <xsl:choose>
            <xsl:when test="($appScore > 0) and ($appMaxScore > 0)"><xsl:value-of select="$appScore div $appMaxScore * 100"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="number('0.00')"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED TECHNICAL RISK SCORE FOR AN APPLICATION -->
    <xsl:function as="xs:integer" name="eas:get_apr_total_tech_score">
        <xsl:param name="app"/>
        
        <xsl:variable name="appTechAssessments" select="$allTechAssessments[name = $app/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appTechAssessmentSQValues" select="$allTechSvcQualVals[name = $appTechAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        
        <xsl:value-of select="eas:get_total_weighted_score($appTechAssessmentSQValues, 0)"/>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM WEIGHTED TECHNICAL RISK SCORE FOR AN APPLICATION -->
    <xsl:function as="xs:integer" name="eas:get_apr_max_tech_score">
        <xsl:param name="app"/>
        
        <xsl:variable name="appTechAssessments" select="$allTechAssessments[name = $app/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appTechAssessmentSQValues" select="$allTechSvcQualVals[name = $appTechAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>        
        
        <xsl:value-of select="eas:get_total_max_score($appTechAssessmentSQValues, $maxScore, 0)"/>
        
    </xsl:function>
    
    
    
    
    
   
    
    
    
    
    
    <xsl:template mode="RenderBubbleChartAppScores" match="node()">
        <xsl:param name="appSvcList"/>
        <xsl:param name="appMaxScore"/>
        
        <xsl:variable name="appPercent" select="eas:get_techprod_func_percent_score(current(), $appSvcList, $appMaxScore)"/>
        <xsl:variable name="appName" select="current()/own_slot_value[slot_reference='name']/value"/>
        
        [<xsl:value-of select="format-number($appPercent, $floatFormat)"/>, <xsl:value-of select="format-number($appPercent, $floatFormat)"/>, 40, "<xsl:value-of select="$appName"/>"]<xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    
    
    
    
    
    
    
    <xsl:template mode="RenderBubbleChartTechProdScores" match="node()">
        <xsl:param name="techFuncTypeList"/>
        <xsl:param name="techProdMaxScore"/>
        
        <xsl:variable name="techProdFuncPercent" select="eas:get_techprod_func_percent_score(current(), $techFuncTypeList, $techProdMaxScore)"/>
        <xsl:variable name="techProdName" select="current()/own_slot_value[slot_reference='name']/value"/>

        [<xsl:value-of select="format-number($techProdFuncPercent, $floatFormat)"/>, <xsl:value-of select="format-number($techProdFuncPercent, $floatFormat)"/>, 40, "<xsl:value-of select="$techProdName"/>"]<xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    <!-- GET THE LIST OF PRODUCT SCORES FOR A BAR CHART -->
    <xsl:template mode="RenderBarChartOverallTechProdScores" match="node()">
        <xsl:param name="techFuncTypeList"/>
        <xsl:param name="techProdMaxScore"/>
        
        <xsl:variable name="techProdFuncPercent" select="eas:get_techprod_func_percent_score(current(), $techFuncTypeList, $techProdMaxScore)"/>
        
        <xsl:value-of select="format-number($techProdFuncPercent, $floatFormat)"/><xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    <!-- GET THE LIST OF PRODUCT NAMES FOR A BAR CHART -->
    <xsl:template mode="RenderBarChartTechProdNames" match="node()">
        
        <xsl:variable name="techProdSupplierName" select="$allTechProductSuppliers[name = current()/own_slot_value[slot_reference='supplier_technology_product']/value]/own_slot_value[slot_reference='name']/value"/>
        <xsl:text>'</xsl:text><xsl:value-of select="$techProdSupplierName"/><xsl:text>'</xsl:text><xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    <!-- GET THE LIST OF FUNCTION TYPE NAMES AND WEIGHTINGS FOR A PIE CHART -->
    <xsl:template mode="RenderPieChartTechFuncTypeWeightings" match="node()">
        <xsl:text>['</xsl:text><xsl:value-of select="own_slot_value[slot_reference='name']/value"/><xsl:text>',</xsl:text><xsl:value-of select="own_slot_value[slot_reference='tcap_weighting']/value"/><xsl:text>]</xsl:text><xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    <!-- GET THE LIST OF PRODUCT SCORES FOR A BAR CHART -->
    <xsl:template mode="RenderBarChartNonFuncTechProdScores" match="node()">
        <xsl:param name="nonFuncMaxScore"/>
        
        <xsl:variable name="techProdNonFuncPercent" select="eas:get_techprod_nonfunc_percentscore(current(), $nonFuncMaxScore)"/>
        
        <xsl:value-of select="format-number($techProdNonFuncPercent, $floatFormat)"/><xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    <!-- GET THE LIST OF SERVICE QUALITY NAMES AND WEIGHTINGS FOR A PIE CHART -->
    <xsl:template mode="RenderPieChartSvcQualWeightings" match="node()">
        <xsl:text>['</xsl:text><xsl:value-of select="own_slot_value[slot_reference='name']/value"/><xsl:text>',</xsl:text><xsl:value-of select="own_slot_value[slot_reference='sq_weighting']/value"/><xsl:text>]</xsl:text><xsl:if test="not(position() = last())">,</xsl:if>
    </xsl:template>
    
    
    
    <!-- GET THE OVERALL SCORE FOR AN APPLICATION -->
    <xsl:function as="xs:float" name="eas:get_app_percent_score">
        <xsl:param name="app"/>
        <xsl:param name="appSvcList"/>
        <xsl:param name="appMaxScore"/>
        
        <xsl:variable name="appScore" select="eas:get_tech_product_func_score($appSvcList, $app, 0)"/>
        <xsl:choose>
            <xsl:when test="($appScore > 0) and ($appMaxScore > 0)"><xsl:value-of select="$appScore div $appMaxScore * 100"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="number('0.00')"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
   
    
    
    
    
    <!-- GET THE OVERALL SCORE FOR A TECHNOLOGY PRODUCT -->
    <xsl:function as="xs:float" name="eas:get_techprod_func_percent_score">
        <xsl:param name="techProd"/>
        <xsl:param name="techFuncTypeList"/>
        <xsl:param name="techProdMaxScore"/>
        
        <xsl:variable name="techProdScore" select="eas:get_tech_product_func_score($techFuncTypeList, $techProd, 0)"/>
        <xsl:choose>
            <xsl:when test="($techProdScore > 0) and ($techProdMaxScore > 0)"><xsl:value-of select="$techProdScore div $techProdMaxScore * 100"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="number('0.00')"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR A TECHNOLOGY PRODUCT -->
    <xsl:function as="xs:integer" name="eas:get_tech_product_func_score">
        <xsl:param name="techFuncTypeList"/>
        <xsl:param name="product"/>
        <xsl:param name="totalScore"/>
        
        
        <xsl:choose>
            <xsl:when test="count($techFuncTypeList) > 0">
                <xsl:variable name="nextTechFuncType" select="$techFuncTypeList[1]"/>
                <xsl:variable name="techFuncs" select="$allTechFunctions[own_slot_value[slot_reference='realisation_of_function_type']/value = $nextTechFuncType/name]"/>
                <xsl:variable name="nextTechFuncTypeWeighting" select="number($nextTechFuncType/own_slot_value[slot_reference='tcap_weighting']/value)"/>
                <xsl:variable name="nextTechFuncTypeScore" select="eas:get_tech_product_score_for_techFuncTypeFuncs($techFuncs, $product, 0) * $nextTechFuncTypeWeighting"/>
                <xsl:value-of select="eas:get_tech_product_func_score(remove($techFuncTypeList, 1), $product, $totalScore + $nextTechFuncTypeScore)"/>           
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <xsl:function as="xs:integer" name="eas:get_max_score_for_techprod">
        <xsl:param name="techFuncTypeList"/>
        <xsl:param name="product"/>
        <xsl:param name="totalMaxScore"/>
        
        <xsl:choose>
            <xsl:when test="count($techFuncTypeList) > 0">
                <xsl:variable name="nextTechFuncType" select="$techFuncTypeList[1]"/>
                <xsl:variable name="techFuncs" select="$allTechFunctions[own_slot_value[slot_reference='realisation_of_function_type']/value = $nextTechFuncType/name]"/>
                <xsl:variable name="nextTechFuncTypeWeighting" select="number($nextTechFuncType/own_slot_value[slot_reference='tcap_weighting']/value)"/>
                <xsl:variable name="techFuncTypeMaxScore" select="eas:get_max_score_for_techFuncTypeFuncs($techFuncs, $product, 0) * $nextTechFuncTypeWeighting"/>
                <xsl:value-of select="eas:get_max_score_for_techprod(remove($techFuncTypeList, 1), $product, $totalMaxScore + $techFuncTypeMaxScore)"/>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR A TECHNOLOGY PRODUCT'S IMPLEMENTATION OF A FUNCTION -->
    <xsl:function as="xs:integer" name="eas:get_tech_product_score_for_techFuncTypeFuncs">
        <xsl:param name="techFuncList"/>
        <xsl:param name="product"/>
        <xsl:param name="totalScore"/>
        
        <xsl:choose>
            <xsl:when test="count($techFuncList) > 0">
                <xsl:variable name="nextTechFunc" select="$techFuncList[1]"/>
                <xsl:variable name="nextTechFuncWeighting" select="number($nextTechFunc/own_slot_value[slot_reference='tf_weighting']/value)"/>
                <xsl:variable name="nextTechFuncScore" select="eas:get_tech_product_score_for_func($nextTechFunc, $product) * $nextTechFuncWeighting"/>
                <xsl:value-of select="eas:get_tech_product_score_for_techFuncTypeFuncs(remove($techFuncList, 1), $product, $totalScore + $nextTechFuncScore)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>

    
    <xsl:function as="xs:integer" name="eas:get_max_score_for_techFuncTypeFuncs">
        <xsl:param name="techFuncList"/>
        <xsl:param name="product"/>
        <xsl:param name="totalMaxScore"/>
        
        <xsl:choose>
            <xsl:when test="count($techFuncList) > 0">
                <xsl:variable name="nextTechFunc" select="$techFuncList[1]"/>
                <xsl:variable name="examplTechFuncImpl" select="$allTechFunctionImpls[own_slot_value[slot_reference='tfi_implements_technology_function']/value = $nextTechFunc/name]"/>
                
                <xsl:choose>
                    <xsl:when test="count($examplTechFuncImpl) > 0">
                        <xsl:variable name="nextTechFuncWeighting" select="number($nextTechFunc/own_slot_value[slot_reference='tf_weighting']/value)"/>
                        <xsl:variable name="nextMaxTechFuncScore" select="eas:get_funcImpl_max_score($examplTechFuncImpl[1]) * $nextTechFuncWeighting"/>
                        <xsl:value-of select="eas:get_max_score_for_techFuncTypeFuncs(remove($techFuncList, 1), $product, $totalMaxScore + $nextMaxTechFuncScore)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_max_score_for_techFuncTypeFuncs(remove($techFuncList, 1), $product, $totalMaxScore)"/>
                    </xsl:otherwise>
                </xsl:choose>   
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <xsl:function as="xs:integer" name="eas:get_max_score_for_app">
        <xsl:param name="appSvcList"/>
        <xsl:param name="app"/>
        <xsl:param name="totalMaxScore"/>
        
        <xsl:choose>
            <xsl:when test="count($appSvcList) > 0">
                <xsl:variable name="nextAppSvc" select="$appSvcList[1]"/>
                <xsl:variable name="exampleAppProRole" select="$allAppProviderRoles[own_slot_value[slot_reference='implementing_application_service']/value = $nextAppSvc/name]"/>
                <xsl:variable name="nextAppSvcWeighting" select="number($nextAppSvc/own_slot_value[slot_reference='as_weighting']/value)"/>
                <!--<xsl:variable name="appSvcMaxScore" select="eas:get_funcImpl_max_score($exampleAppProRole[1]) * $nextAppSvcWeighting"/>-->
                
                <xsl:variable name="appSvcMaxScore" select="$maxScore"/>
                <xsl:value-of select="eas:get_max_score_for_app(remove($appSvcList, 1), $app, $totalMaxScore + $appSvcMaxScore)"/>  
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
   <!-- <xsl:function as="xs:integer" name="eas:get_max_score_for_techFuncTypeFuncs">
        <xsl:param name="techFuncList"/>
        <xsl:param name="product"/>
        <xsl:param name="totalMaxScore"/>
        
        <xsl:choose>
            <xsl:when test="count($techFuncList) > 0">
                <xsl:variable name="nextTechFunc" select="$techFuncList[1]"/>
                <xsl:variable name="examplTechFuncImpl" select="$allTechFunctionImpls[own_slot_value[slot_reference='tfi_implements_technology_function']/value = $nextTechFunc/name]"/>
                
                <xsl:choose>
                    <xsl:when test="count($examplTechFuncImpl) > 0">
                        <xsl:variable name="nextTechFuncWeighting" select="number($nextTechFunc/own_slot_value[slot_reference='tf_weighting']/value)"/>
                        <xsl:variable name="nextMaxTechFuncScore" select="eas:get_funcImpl_max_score($examplTechFuncImpl[1]) * $nextTechFuncWeighting"/>
                        <xsl:value-of select="eas:get_max_score_for_techFuncTypeFuncs(remove($techFuncList, 1), $product, $totalMaxScore + $nextMaxTechFuncScore)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="eas:get_max_score_for_techFuncTypeFuncs(remove($techFuncList, 1), $product, $totalMaxScore)"/>
                    </xsl:otherwise>
                </xsl:choose>   
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$totalMaxScore"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>-->
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR A TECHNOLOGY PRODUCT'S IMPLEMENTATION OF A FUNCTION -->
    <xsl:function as="xs:integer" name="eas:get_tech_product_score_for_func">
        <xsl:param name="techFunc"/>
        <xsl:param name="product"/>
        
        <xsl:variable name="prodTechFuncImpl" select="$allTechFunctionImpls[(name = $product/own_slot_value[slot_reference='technology_provider_implemented_functions']/value) and (own_slot_value[slot_reference='tfi_implements_technology_function']/value = $techFunc/name)]"/>
        <xsl:value-of select="eas:get_funcImpl_total_score($prodTechFuncImpl)"/>
        
    </xsl:function>
    
    
    
    <!-- FUNCTION TO CALCULATE THE PERCENTAGE WEIGHTED SCORE FOR A TECHNOLOGY PRODUCT'S IMPLEMENTATION OF A FUNCTION -->
    <xsl:function as="xs:float" name="eas:get_tech_product_percentscore_for_func">
        <xsl:param name="techFunc"/>
        <xsl:param name="product"/>
        
        <xsl:variable name="prodTechFuncImpl" select="$allTechFunctionImpls[(name = $product/own_slot_value[slot_reference='technology_provider_implemented_functions']/value) and (own_slot_value[slot_reference='tfi_implements_technology_function']/value = $techFunc/name)]"/>
        <xsl:variable name="funcImplScore" select="eas:get_funcImpl_total_score($prodTechFuncImpl)"/>
        <xsl:variable name="funcImplMaxScore" select="eas:get_funcImpl_max_score($prodTechFuncImpl)"/>
        <xsl:choose>
            <xsl:when test="($funcImplScore = 0) or ($funcImplMaxScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$funcImplScore div $funcImplMaxScore * 100"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR A TECHNOLOGY FUNCTION IMPLEMENTATION -->
    <xsl:function as="xs:integer" name="eas:get_funcImpl_total_score">
        <xsl:param name="funcImpl"/>
        
        <xsl:variable name="funcImplAppAssessments" select="$allAppAssessments[name = $funcImpl/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="funcImplAppAssessmentSQValues" select="$allAppSvcQualVals[name = $funcImplAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <!--<xsl:variable name="funcImplAppAssessmentSQValueScores" select="$funcImplAppAssessmentSQValues/own_slot_value[slot_reference='service_quality_value_score']/value"/>
        
        <xsl:variable name="funcImplAppAssessmentSQWeightings" select="$allAppSvcQuals[name = $funcImplAppAssessmentSQValues/own_slot_value[slot_reference='usage_of_service_quality']/value]/own_slot_value[slot_reference='sq_weighting']/value"/>-->
        
        <!--<xsl:choose>
            <xsl:when test="count($funcImplAppAssessmentSQValueScores) != count($funcImplAppAssessmentSQWeightings)">0</xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="eas:get_total_weighted_score($funcImplAppAssessmentSQValueScores, $funcImplAppAssessmentSQWeightings, 0)"/>
            </xsl:otherwise>
        </xsl:choose>-->
        <!--<xsl:value-of select="eas:get_total_weighted_score($funcImplAppAssessmentSQValueScores, $funcImplAppAssessmentSQWeightings, 0)"/>-->
        <xsl:value-of select="eas:get_total_weighted_score($funcImplAppAssessmentSQValues, 0)"/>
        
        
        <!--<xsl:variable name="funcImplAppAssessments" select="$allAppAssessments[name = $funcImpl/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="funcImplAppAssessmentSQValues" select="$allAppSvcQualVals[name = $funcImplAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="funcImplAppAssessmentSQValueScores" select="eas:get_assessmentSQV_score_list($funcImplAppAssessmentSQValues, ())"/>
        <xsl:variable name="funcImplAppAssessmentSQuals" select="$allAppSvcQuals[name = $funcImplAppAssessmentSQValues/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        
        <xsl:variable name="funcImplAppAssessmentSQWeightings" select="eas:get_svcqual_weighting_list($funcImplAppAssessmentSQuals, ())"/>
        
        <xsl:value-of select="eas:get_total_weighted_score($funcImplAppAssessmentSQValueScores, $funcImplAppAssessmentSQWeightings, 0)"/>-->
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM WEIGHTED SCORE FOR A TECHNOLOGY FUNCTION IMPLEMENTATION -->
    <xsl:function as="xs:integer" name="eas:get_funcImpl_max_score">
        <xsl:param name="funcImpl"/>
        
        <xsl:variable name="funcImplAppAssessments" select="$allAppAssessments[name = $funcImpl/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="funcImplAppAssessmentSQValues" select="$allAppSvcQualVals[name = $funcImplAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <!--<xsl:variable name="funcImplAppAssessmentSQs" select="$allAppSvcQuals[name = $funcImplAppAssessmentSQValues/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        
        <xsl:variable name="funcImplAppAssessmentSQWeightings" select="$allAppSvcQuals[name = $funcImplAppAssessmentSQValues/own_slot_value[slot_reference='usage_of_service_quality']/value]/own_slot_value[slot_reference='sq_weighting']/value"/>-->
        <!--<xsl:variable name="funcImplAppAssessmentSQWeightings" select="eas:get_svcqual_weighting_list($funcImplAppAssessmentSQs, ())"/>-->
        
        
        <xsl:value-of select="eas:get_total_max_score($funcImplAppAssessmentSQValues, $maxScore, 0)"/>
        <!--<xsl:value-of select="count($funcImplAppAssessmentSQs)"/>  -->
        
    </xsl:function>
    
    
    <!-- FUNCTION TO GENERATE A LIST OF SCORES DFROM A SET OF SERVICE QUALITY VALUES -->
    <xsl:function as="xs:integer*" name="eas:get_assessmentSQV_score_list">
        <xsl:param name="svcQualVals"/>
        <xsl:param name="assessScoreList"/>
        
        <xsl:choose>
            <xsl:when test="count($svcQualVals) > 0">
                <xsl:variable name="nextSvcQualVal" select="$svcQualVals[1]"/>
                <xsl:variable name="nextScore" select="number($nextSvcQualVal/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="nextScoreList" select="insert-before($assessScoreList, count($assessScoreList) + 1, $nextScore)"/>
                <xsl:sequence select="eas:get_assessmentSQV_score_list(remove($svcQualVals, 1), $nextScoreList)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$assessScoreList"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO GENERATE A LIST OF WEIGHTINGS DFROM A SET OF SERVICE QUALITIES -->
    <xsl:function as="xs:integer*" name="eas:get_svcqual_weighting_list">
        <xsl:param name="svcQuals"/>
        <xsl:param name="weightingList"/>
        
        <xsl:choose>
            <xsl:when test="count($svcQuals) > 0">
                <xsl:variable name="nextSvcQual" select="$svcQuals[1]"/>
                <xsl:variable name="nextWeighting" select="number($nextSvcQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:variable name="nextWeightingList" select="insert-before($weightingList, count($weightingList) + 1, $nextWeighting)"/>
                <xsl:sequence select="eas:get_svcqual_weighting_list(remove($svcQuals, 1), $nextWeightingList)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$weightingList"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL OF A GIVEN SET OF VALUES AND CORRESPONDING WEIGHTINGS -->
    <xsl:function as="xs:integer" name="eas:get_total_weighted_score">
        <xsl:param name="values"/>
        <!--<xsl:param name="weightings"/>-->
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="(count($values) > 0)">
                <xsl:variable name="nextVal" select="$values[1]"/>
                <xsl:variable name="nextValScore" select="number($nextVal/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="serviceQual" select="$allSvcQuals[name = $nextVal/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:variable name="totalToAdd" select="$nextValScore * $nextWeighting"/>
                <xsl:value-of select="eas:get_total_weighted_score(remove($values, 1), $total + $totalToAdd)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM TOTAL, GIVEN SET OF WEIGHTINGS -->
    <xsl:function as="xs:integer" name="eas:get_total_max_score">
        <xsl:param name="values"/>
        <xsl:param name="maxValue"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($values) > 0">
                <xsl:variable name="nextVal" select="$values[1]"/>
                <xsl:variable name="serviceQual" select="$allSvcQuals[name = $nextVal/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:variable name="svcQualMaxValue" select="($allAppSvcQualVals  union $allTechSvcQualVals union $allBusSvcQualVals)[name = $serviceQual/own_slot_value[slot_reference='sq_maximum_value']/value]"/>
                <xsl:variable name="svcQualMaxScore" select="number($svcQualMaxValue/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="totalToAdd" select="$svcQualMaxScore * $nextWeighting"/>
                <xsl:value-of select="eas:get_total_max_score(remove($values, 1), $maxValue, $total + $totalToAdd)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$total > 0"><xsl:value-of select="$total"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM TOTAL, GIVEN SET OF WEIGHTINGS -->
    <xsl:function as="xs:integer" name="eas:get_bussvcqualvals_total_max_score">
        <xsl:param name="values"/>
        <xsl:param name="maxValue"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($values) > 0">
                <xsl:variable name="nextVal" select="$values[1]"/>
                <xsl:variable name="serviceQual" select="$allSvcQuals[name = $nextVal/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:variable name="svcQualMaxValue" select="$allBusSvcQualVals[name = $serviceQual/own_slot_value[slot_reference='sq_maximum_value']/value]"/>
                <xsl:variable name="svcQualMaxScore" select="number($svcQualMaxValue/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="totalToAdd" select="$svcQualMaxScore * $nextWeighting"/>
                <xsl:value-of select="eas:get_bussvcqualvals_total_max_score(remove($values, 1), $maxValue, $total + $totalToAdd)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$total > 0"><xsl:value-of select="$total"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE MAXIMUM TOTAL, GIVEN SET OF WEIGHTINGS -->
    <xsl:function as="xs:integer" name="eas:get_total_max_scorefor_svcquals">
        <xsl:param name="serviceQuals"/>
        <xsl:param name="maxValue"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="count($serviceQuals) > 0">
                <xsl:variable name="serviceQual" select="$serviceQuals[1]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:variable name="totalToAdd" select="number($maxValue) * $nextWeighting"/>
                <xsl:value-of select="eas:get_total_max_scorefor_svcquals(remove($serviceQuals, 1), $maxValue, $total + $totalToAdd)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$total > 0"><xsl:value-of select="$total"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="0"/></xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    <!-- FUNCTION TO CALCULATE THE NON-FUNCTIONAL PERCENTAGE SCORE FOR A TECH PRODUCT -->
    <xsl:function as="xs:float" name="eas:get_techprod_nonfunc_percentscore">
        <xsl:param name="product"/>
        <xsl:param name="maxNonFuncScore"/>
        
        <xsl:variable name="techProdNonFuncScore" select="eas:get_techprod_nonfunc_score($product)"/>
        
        <xsl:choose>
            <xsl:when test="($techProdNonFuncScore = 0) or ($maxNonFuncScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$techProdNonFuncScore div $maxNonFuncScore * 100"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL NON-FUNCTIONALSCORE FOR A TECH PRODUCT -->
    <xsl:function as="xs:integer" name="eas:get_techprod_nonfunc_score">
        <xsl:param name="product"/>
        
        <xsl:variable name="techProdAssessments" select="$allTechAssessments[name = $product/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="techProdSQVals" select="$allTechSvcQualVals[name = $techProdAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"></xsl:variable>
        
        <xsl:value-of select="eas:get_total_weighted_score($techProdSQVals, 0)"/>
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE BUSINESS PERCENTAGE SCORE FOR A TECH PRODUCT -->
    <xsl:function as="xs:float" name="eas:get_techprod_bus_percentscore">
        <xsl:param name="product"/>
        <xsl:param name="maxBusScore"/>
        
        <xsl:variable name="techProdBusScore" select="eas:get_techprod_bus_score($product)"/>
        
        <xsl:choose>
            <xsl:when test="($techProdBusScore = 0) or ($maxBusScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$techProdBusScore div $maxBusScore * 100"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL BUSINESS SCORE FOR A TECH PRODUCT -->
    <xsl:function as="xs:integer" name="eas:get_techprod_bus_score">
        <xsl:param name="product"/>
        
        <xsl:variable name="techProdBusAssessments" select="$allBusAssessments[name = $product/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="techProdSQVals" select="$allBusSvcQualVals[name = $techProdBusAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"></xsl:variable>
        
        <xsl:value-of select="eas:get_total_weighted_score($techProdSQVals, 0)"/>
    </xsl:function>
    
    
    <!--<!-\- FUNCTION TO CALCULATE A LIST OF  TOTAL WEIGHTED SCORE FOR A SET OF TECHNOLOGY FUNCTION IMPLEMENTATIONS -\->
    <xsl:function as="xs:integer*" name="eas:get_tech_func_weighting_list">
        <xsl:param name="techFuncs"/>
        <xsl:param name="weightingList"/>
        
        <xsl:choose>
            <xsl:when test="count($weightingList) > 0">
                <xsl:variable name="nextWeighting" select="number($techFuncs[1]/own_slot_value[slot_reference='tf_weighting']/value)"/>
                <xsl:variable name="nextWeightingList" select="insert-before($weightingList, count($weightingList) + 1, $nextWeighting)"/>
                <xsl:sequence select="eas:get_tech_func_weighting_list(remove($techFuncs, 1), $nextWeightingList)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$weightingList"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-\- FUNCTION TO CALCULATE A LIST OF  TOTAL WEIGHTED SCORE FOR A SET OF TECHNOLOGY FUNCTION IMPLEMENTATIONS -\->
    <xsl:function as="xs:integer*" name="eas:get_funcImpl_total_score_list">
        <xsl:param name="funcImpls"/>
        <xsl:param name="totalScoreList"/>
        
        <xsl:choose>
            <xsl:when test="count($funcImpls) > 0">
                <xsl:variable name="nextFuncImpl" select="$funcImpls[1]"/>
                <xsl:variable name="nextFuncImplScore" select="eas:get_funcImpl_total_score($nextFuncImpl)"/>
                <xsl:variable name="nextTotalScoreList" select="insert-before($totalScoreList, count($totalScoreList) + 1, $nextFuncImplScore)"/>
                <xsl:sequence select="eas:get_funcImpl_total_score_list(remove($funcImpls, 1), $nextTotalScoreList)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$totalScoreList"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-\- FUNCTION TO CALCULATE A LIST OF  TOTAL WEIGHTED SCORE FOR A SET OF TECHNOLOGY FUNCTION IMPLEMENTATIONS -\->
    <xsl:function as="xs:integer*" name="eas:get_funcImpl_max_score_list">
        <xsl:param name="funcImpls"/>
        <xsl:param name="maxScoreList"/>
        
        <xsl:choose>
            <xsl:when test="count($funcImpls) > 0">
                <xsl:variable name="nextFuncImpl" select="$funcImpls[1]"/>
                <xsl:variable name="nextFuncImplMaxScore" select="eas:get_funcImpl_max_score($nextFuncImpl)"/>
                <xsl:variable name="nextMaxScoreList" select="insert-before($maxScoreList, count($maxScoreList) + 1, $nextFuncImplMaxScore)"/>
                <xsl:sequence select="eas:get_funcImpl_max_score_list(remove($funcImpls, 1), $nextMaxScoreList)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$maxScoreList"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>-->
    
    
    
    <!-- FUNCTION TO CALCULATE THE AVERAGE WEIGHTED SCORE FOR AN APPLICATION's IMPLEMENTATION OF AN APPLICATION SERVICE -->
    <xsl:function as="xs:float" name="eas:get_average_score_for_appprorole">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="appProRoleAppAssessments" select="$allAppAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appProRoleAppAssessmentSQValues" select="$allAppSvcQualVals[name = $appProRoleAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        
        
        <xsl:variable name="appProRoleWeightedScore" select="eas:get_total_weighted_assess_score($appProRoleAppAssessments, 0)"/>
        <xsl:variable name="appProRoleAssessmentWeightingTotal" select="count($appProRoleAppAssessments)"/>
        
        <!--<xsl:variable name="appProRoleAssessmentWeightingTotal" select="eas:get_total_weightings($appProRoleAppAssessmentSQValues, 0)"/>-->
        
        <xsl:choose>
            <xsl:when test="($appProRoleWeightedScore = 0) or ($appProRoleAssessmentWeightingTotal = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$appProRoleWeightedScore div $appProRoleAssessmentWeightingTotal"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION TO CALCULATE THE AVERAGE WEIGHTED SCORE FOR AN APPLICATION's IMPLEMENTATION OF AN APPLICATION SERVICE -->
    <xsl:function as="xs:float" name="eas:get_average_SVQ_score_for_appprorole">
        <xsl:param name="appProRole"/>
        <xsl:param name="appSvcQual"/>
        
        <xsl:variable name="appProRoleAppAssessments" select="$allAppAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appProRoleAppAssessmentSQValues" select="$allAppSvcQualVals[(name = $appProRoleAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value) and (own_slot_value[slot_reference='usage_of_service_quality']/value = $appSvcQual/name)]"/>
        
        
        <xsl:variable name="appProRoleWeightedScore" select="eas:get_total_weighted_assess_score($appProRoleAppAssessments[own_slot_value[slot_reference='pm_performance_value']/value = $appProRoleAppAssessmentSQValues/name], 0)"/>
        <xsl:variable name="appProRoleAssessmentWeightingTotal" select="count($appProRoleAppAssessments[own_slot_value[slot_reference='pm_performance_value']/value = $appProRoleAppAssessmentSQValues/name])"/>
        
        <xsl:choose>
            <xsl:when test="($appProRoleWeightedScore = 0) or ($appProRoleAssessmentWeightingTotal = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$appProRoleWeightedScore div $appProRoleAssessmentWeightingTotal"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    

    <!-- FUNCTION TO CALCULATE THE PERCENTAGE WEIGHTED SCORE FOR AN APPLICATION's IMPLEMENTATION OF AN APPLICATION SERVICE -->
    <xsl:function as="xs:float" name="eas:get_app_percentscore_for_appsvc">
        <xsl:param name="appSvc"/>
        <xsl:param name="app"/>
        
        <xsl:variable name="appProRole" select="$allAppProviderRoles[(own_slot_value[slot_reference='implementing_application_service']/value = $appSvc) and (own_slot_value[slot_reference='role_for_application_provider']/value = $app)]"/>
        <xsl:variable name="appProRoleScore" select="eas:get_appprorole_total_score($appProRole)"/>
        <xsl:variable name="appProRoleMaxScore" select="eas:get_max_score_for_app($appSvc, $app, 0)"/>
        <xsl:choose>
            <xsl:when test="($appProRoleScore = 0) or ($appProRoleMaxScore = 0)">0</xsl:when>
            <xsl:otherwise><xsl:value-of select="$appProRoleScore div $appProRoleMaxScore * 100"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    
    
    <!-- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR AN APPLICATION PROVIDER ROLE -->
    <xsl:function as="xs:integer" name="eas:get_appprorole_total_score">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="appProRoleAppAssessments" select="$allAppAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appProRoleAppAssessmentSQValues" select="$allAppSvcQualVals[name = $appProRoleAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        
        <xsl:value-of select="eas:get_total_weighted_score($appProRoleAppAssessmentSQValues, 0)"/>

    </xsl:function>
    
    
   <!-- <!-\- FUNCTION TO CALCULATE THE TOTAL WEIGHTED SCORE FOR AN APPLICATION PROVIDER ROLE -\->
    <xsl:function as="xs:integer" name="eas:get_appprorole_total_weightings">
        <xsl:param name="appProRole"/>
        
        <xsl:variable name="appProRoleAppAssessments" select="$allAppAssessments[name = $appProRole/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appProRoleAppAssessmentSQValues" select="$allAppSvcQualVals[name = $appProRoleAppAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        
        <xsl:value-of select="eas:get_total_weightings($appProRoleAppAssessmentSQValues, 0)"/>
        
    </xsl:function>-->
    
    
    <!-- FUNCTION TO CALCULATE THE SUM OF THE WEIGHTINGS FOR A SET OF SERVICE QUALITY VALUES -->
    <xsl:function as="xs:integer" name="eas:get_total_weighted_assess_score">
        <xsl:param name="assessments"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="(count($assessments) > 0)">
                <xsl:variable name="nextAssessment" select="$assessments[1]"/>
                <xsl:variable name="nextVal" select="$allAppSvcQualVals[name = $nextAssessment/own_slot_value[slot_reference='pm_performance_value']/value]"/>
                <xsl:variable name="nextValScore" select="number($nextVal/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="serviceQual" select="$allSvcQuals[name = $nextVal/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:value-of select="eas:get_total_weighted_assess_score(remove($assessments, 1), $total + ($nextWeighting * $nextValScore))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>


    <!-- FUNCTION TO CALCULATE THE SUM OF THE WEIGHTINGS FOR A SET OF SERVICE QUALITY VALUES -->
    <xsl:function as="xs:integer" name="eas:get_total_weightings">
        <xsl:param name="values"/>
        <xsl:param name="total"/>
        
        <xsl:choose>
            <xsl:when test="(count($values) > 0)">
                <xsl:variable name="nextVal" select="$values[1]"/>
                <xsl:variable name="nextValScore" select="number($nextVal/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="serviceQual" select="$allSvcQuals[name = $nextVal/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>             
                <xsl:variable name="nextWeighting" select="number($serviceQual/own_slot_value[slot_reference='sq_weighting']/value)"/>
                <xsl:value-of select="eas:get_total_weightings(remove($values, 1), $total + $nextWeighting)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$total"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS A RAG STYLE FOR A GIVEN SCORE -->
    <xsl:function as="xs:string" name="eas:get_score_rag_style">
        <xsl:param name="score"/>
        
        <xsl:choose>
            <xsl:when test="number($score) lt 0">ragTextGrey</xsl:when>
            <xsl:when test="number($score) >= ($maxScore * 0.75)">ragTextGreen</xsl:when>
            <xsl:when test="number($score) >= ($maxScore * 0.5)">ragTextYellow textColour6</xsl:when>
            <xsl:when test="number($score) >= ($maxScore * 0.25)">ragTextOrange</xsl:when>
            <xsl:otherwise>ragTextRed</xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS A TABLE CELL RAG STYLE FOR A GIVEN SCORE -->
    <xsl:function as="xs:string" name="eas:get_percent_score_tablerag_style">
        <xsl:param name="score"/>
        
        <xsl:choose>
            <xsl:when test="number($score) lt 0">backColourGrey</xsl:when>
            <xsl:when test="number($score) >= 60">backColourGreen</xsl:when>
            <xsl:when test="number($score) >= 40">backColourYellow</xsl:when>
            <xsl:when test="number($score) >= 25">backColourOrange</xsl:when>
            <xsl:otherwise>backColourRed</xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- GET THE OVERALL TECH ASSESSMENT SCORE FOR AN APPLICATION -->
    <xsl:function as="xs:float" name="eas:get_app_overall_tech_percent_score">
        <xsl:param name="app"/>
        
        <xsl:variable name="techAssessments" select="$allTechAssessments[name = $app/own_slot_value[slot_reference='performance_measures']/value]"/>
        <xsl:variable name="appScore" select="eas:get_score_for_tech_assessments($techAssessments, 0)"/>
        <xsl:variable name="appMaxScore" select="eas:get_max_score_for_tech_assessments($techAssessments, 0)"/>
        <xsl:choose>
            <xsl:when test="($appScore > 0) and ($appMaxScore > 0)"><xsl:value-of select="$appScore div $appMaxScore * 100"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="number('0.00')"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    <!-- GET THE OVERALL SCORE FOR AN APPLICATION'S SUPPORT FOR A PHYSICAL BUSINESS PROCESS -->
    <xsl:function as="xs:float" name="eas:get_overall_bus_percent_score">
        <xsl:param name="assessedElements"/>
        
        <xsl:variable name="busAssessments" select="$allBusAssessments[own_slot_value[slot_reference='pm_measured_element']/value = $assessedElements/name]"/>
        <xsl:variable name="appScore" select="eas:get_score_for_bus_assessments($busAssessments, 0)"/>
        <xsl:variable name="appMaxScore" select="eas:get_max_score_for_bus_assessments($busAssessments, 0)"/>
        <xsl:choose>
            <xsl:when test="($appScore > 0) and ($appMaxScore > 0)"><xsl:value-of select="$appScore div $appMaxScore * 100"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="number('0.00')"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>
    
    
    
    <!-- FUNCTION THAT RETURNS THE MAXIMUM SCORE POSSIBLE FOR THE GIVEN SET OF BUSINESS ASSESSMENTS -->
    <xsl:function as="xs:integer" name="eas:get_max_score_for_bus_assessments">
        <xsl:param name="busAssessments"/>
        <xsl:param name="totalScore"/>
        
        <!--<xsl:choose>
            <xsl:when test="count($busAssessments) > 0">
                <xsl:variable name="nextBusAssess" select="$busAssessments[1]"/>
                <xsl:variable name="nextBusAssessList" select="remove($busAssessments,1)"/>
                <xsl:variable name="nextBusAssessSQVs" select="$allBusSvcQualVals[name = $nextBusAssess/own_slot_value[slot_reference='pm_performance_value']/value]"/>
                <xsl:variable name="nextBusAssessSQs" select="$allBusSvcQuals[name = $nextBusAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
                <xsl:variable name="nextBusAssessMaxScore" select="eas:get_max_score_for_service_quals($nextBusAssessSQs, $nextBusAssessSQVs, 0)"/>
                <xsl:value-of select="eas:get_max_score_for_bus_assessments($nextBusAssessList, $totalScore + $nextBusAssessMaxScore)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$totalScore"/></xsl:otherwise>
        </xsl:choose>-->

        <xsl:variable name="busAssessSQVs" select="$allBusSvcQualVals[name = $busAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="busAssessSQs" select="$allBusSvcQuals[name = $busAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        <xsl:value-of select="eas:get_max_score_for_service_quals($busAssessSQs, $busAssessSQVs, 0)"/>

        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS THE MAXIMUM SCORE POSSIBLE FOR THE GIVEN SET OF TECHNOLOGY ASSESSMENTS -->
    <xsl:function as="xs:integer" name="eas:get_max_score_for_tech_assessments">
        <xsl:param name="techAssessments"/>
        <xsl:param name="totalScore"/>
        
        <xsl:variable name="techAssessSQVs" select="$allTechSvcQualVals[name = $techAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="techAssessSQs" select="$allTechSvcQuals[name = $techAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        <xsl:value-of select="eas:get_max_score_for_service_quals($techAssessSQs, $techAssessSQVs, 0)"/>
        
        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS THE MAXIMUM SCORE POSSIBLE FOR THE GIVEN SET OF SERVICE QUALITY VALUES -->
    <xsl:function as="xs:integer" name="eas:get_max_score_for_service_quals">
        <xsl:param name="serviceQualityList"/>
        <xsl:param name="insScopeServiceQualityValues"/>
        <xsl:param name="totalScore"/>
        
        <xsl:choose>
            <xsl:when test="count($serviceQualityList) > 0">
                <xsl:variable name="nextSQ" select="$serviceQualityList[1]"/>
                <xsl:variable name="nextSQList" select="remove($serviceQualityList,1)"/>
                <xsl:variable name="nextSQVs" select="$insScopeServiceQualityValues[own_slot_value[slot_reference='usage_of_service_quality']/value = $nextSQ/name]"/>
                <xsl:variable name="nextSQWeightingStr" select="$nextSQ/own_slot_value[slot_reference='sq_weighting']/value"/>
                <xsl:variable name="nextSQMaxValue" select="$allSvcQualVals[name = $nextSQ/own_slot_value[slot_reference='sq_maximum_value']/value]/own_slot_value[slot_reference='service_quality_value_score']/value"/>
                <xsl:variable name="thisMaxScore">
                    <xsl:choose>
                        <xsl:when test="string-length($nextSQMaxValue) > 0">
                            <xsl:value-of select="number($nextSQMaxValue)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$maxScore"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="nextSQWeighting">
                    <xsl:choose>
                        <xsl:when test="string-length($nextSQWeightingStr) > 0"><xsl:value-of select="number($nextSQWeightingStr)"/></xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="nextSQVCount" select="count($nextSQVs)"/>
                <xsl:variable name="nextSQMaxScore" select="$nextSQVCount * $thisMaxScore * number($nextSQWeighting)"/>
                <xsl:value-of select="eas:get_max_score_for_service_quals($nextSQList, $insScopeServiceQualityValues, $totalScore + $nextSQMaxScore)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$totalScore"/></xsl:otherwise>
        </xsl:choose>
        
        
        
    </xsl:function>
    
    <!-- FUNCTION THAT RETURNS THE TOTAL SCORE FOR THE GIVEN SET OF BUSINESS ASSESSMENTS -->
    <xsl:function as="xs:integer" name="eas:get_score_for_bus_assessments">
        <xsl:param name="busAssessments"/>
        <xsl:param name="totalScore"/>
        
        <!--<xsl:choose>
            <xsl:when test="count($busAssessments) > 0">
                <xsl:variable name="nextBusAssess" select="$busAssessments[1]"/>
                <xsl:variable name="nextBusAssessList" select="remove($busAssessments,1)"/>
                <xsl:variable name="nextBusAssessSQVs" select="$allBusSvcQualVals[name = $nextBusAssess/own_slot_value[slot_reference='pm_performance_value']/value]"/>
                <xsl:variable name="nextBusAssessSQs" select="$allBusSvcQuals[name = $nextBusAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
                <xsl:variable name="nextBusAssessMaxScore" select="eas:get_max_score_for_service_quals($nextBusAssessSQs, $nextBusAssessSQVs, 0)"/>
                <xsl:value-of select="eas:get_max_score_for_bus_assessments($nextBusAssessList, $totalScore + $nextBusAssessMaxScore)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$totalScore"/></xsl:otherwise>
        </xsl:choose>-->
        
        <xsl:variable name="busAssessSQVs" select="$allBusSvcQualVals[name = $busAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="busAssessSQs" select="$allBusSvcQuals[name = $busAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        <xsl:value-of select="eas:get_score_for_service_quals($busAssessSQs, $busAssessSQVs, 0)"/>
        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS THE TOTAL SCORE FOR THE GIVEN SET OF TECHNOLOGY ASSESSMENTS -->
    <xsl:function as="xs:integer" name="eas:get_score_for_tech_assessments">
        <xsl:param name="techAssessments"/>
        <xsl:param name="totalScore"/>
        
        <xsl:variable name="techAssessSQVs" select="$allTechSvcQualVals[name = $techAssessments/own_slot_value[slot_reference='pm_performance_value']/value]"/>
        <xsl:variable name="techAssessSQs" select="$allTechSvcQuals[name = $techAssessSQVs/own_slot_value[slot_reference='usage_of_service_quality']/value]"/>
        <xsl:value-of select="eas:get_score_for_service_quals($techAssessSQs, $techAssessSQVs, 0)"/>
        
    </xsl:function>
    
    
    <!-- FUNCTION THAT RETURNS THE TOTAL SCORE FOR THE GIVEN SET OF SERVICE QUALITY VALUES -->
    <xsl:function as="xs:integer" name="eas:get_score_for_service_quals">
        <xsl:param name="serviceQualityList"/>
        <xsl:param name="insScopeServiceQualityValues"/>
        <xsl:param name="totalScore"/>
        
        <xsl:choose>
            <xsl:when test="count($serviceQualityList) > 0">
                <xsl:variable name="nextSQ" select="$serviceQualityList[1]"/>
                <xsl:variable name="nextSQList" select="remove($serviceQualityList,1)"/>
                <xsl:variable name="nextSQVs" select="$insScopeServiceQualityValues[own_slot_value[slot_reference='usage_of_service_quality']/value = $nextSQ/name]"/>
                <xsl:variable name="nextSQWeightingStr" select="$nextSQ/own_slot_value[slot_reference='sq_weighting']/value"/>
                <xsl:variable name="nextSQWeighting">
                    <xsl:choose>
                        <xsl:when test="string-length($nextSQWeightingStr) > 0"><xsl:value-of select="number($nextSQWeightingStr)"/></xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="nextSQVTotal" select="sum($nextSQVs/own_slot_value[slot_reference='service_quality_value_score']/value)"/>
                <xsl:variable name="nextSQScore" select="$nextSQVTotal * number($nextSQWeighting)"/>
                <xsl:value-of select="eas:get_score_for_service_quals($nextSQList, $insScopeServiceQualityValues, $totalScore + $nextSQScore)"/>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$totalScore"/></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- FUNCTION THAT RETURNS THE TOTAL COST OF THE GIVEN COST COMPONENTS -->
    <xsl:function as="xs:float" name="eas:get_cost_components_total">
        <xsl:param name="costComponents"/>
        <xsl:param name="total"/>
        
        <xsl:variable name="costCompsWithVals" select="$costComponents[own_slot_value[slot_reference='cc_cost_amount']/value > 0]"/>      
        <xsl:value-of select="number(sum($costCompsWithVals/own_slot_value[slot_reference='cc_cost_amount']/value))"/>
        
    </xsl:function>
    
</xsl:stylesheet>
