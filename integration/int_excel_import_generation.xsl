<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:fn="http://www.functx.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xpath-default-namespace="http://protege.stanford.edu/xml" xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" xmlns:eas="http://www.enterprise-architecture.org/essential">

	<xsl:include href="../common/functx-1.0-doc-2007-01.xsl"/>
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes" encoding="iso-8859-1"/>



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
	<!-- 28.10.2010 JP	Created -->

	<!-- param1 = the id of the specification that defines the spreadsheet to be generated -->
	<xsl:param name="param1"/>


	<!-- populateSS = a boolean indicating whether to populate appropriate worksheets with instances from the repository -->
	<xsl:param name="populateSS"/>


	<!-- extReposId = the Id of an external repository for which pre-ppulated IDs should be used -->
	<xsl:param name="extReposId"/>

	<!-- viewScopeIds = the optional taxonomy term used to scope the content pre-poluated into the spreadsheet -->
	<xsl:param name="viewScopeIds"/>

	<xsl:variable name="sheetHeadingStyleId" select="'s62'"/>
	<xsl:variable name="columnHeadingStyleId" select="'s63'"/>
	<xsl:variable name="sheetCellStyleId" select="'s64'"/>
	<xsl:variable name="indexSubheadingStyleId" select="'s76'"/>
	<xsl:variable name="indexColumnHeadingStyleId" select="'s80'"/>
	<xsl:variable name="indexWorksheetTitleStyleId" select="'s83'"/>


	<xsl:variable name="spreadsheet" select="/node()/simple_instance[name = $param1]"/>
	<!-- <xsl:variable name="extRepos" select="/node()/simple_instance[name = $extReposId]"/>-->
	<xsl:variable name="extReposInstRefs" select="/node()/simple_instance[own_slot_value[slot_reference = 'external_repository_reference']/value = $extReposId]"/>

	<xsl:variable name="ssFilename" select="$spreadsheet/own_slot_value[slot_reference = 'ss_filename']/value"/>
	<xsl:variable name="ssStartRow" select="number($spreadsheet/own_slot_value[slot_reference = 'ss_default_start_row']/value)"/>
	<xsl:variable name="ssDefaultRowCount" select="1000"/>

	<xsl:variable name="worksheetUsages" select="/node()/simple_instance[name = $spreadsheet/own_slot_value[slot_reference = 'ss_worksheets']/value]"/>
	<xsl:variable name="worksheets" select="/node()/simple_instance[name = $worksheetUsages/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>

	<xsl:variable name="columnUsages" select="/node()/simple_instance[name = $worksheetUsages/own_slot_value[slot_reference = 'wsu_column_usages']/value]"/>
	<xsl:variable name="usedColumns" select="/node()/simple_instance[name = $columnUsages/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>

	<xsl:variable name="allColumns" select="/node()/simple_instance[name = $worksheets/own_slot_value[slot_reference = 'ws_columns']/value]"/>
	<xsl:variable name="allNamedRanges" select="/node()/simple_instance[own_slot_value[slot_reference = 'nrs_column']/value = $allColumns/name]"/>

	<xsl:variable name="allReferenceData" select="/node()/simple_instance[name = $worksheets/own_slot_value[slot_reference = 'rws_references']/value]"/>
	<xsl:variable name="allNamedRefRanges" select="/node()/simple_instance[own_slot_value[slot_reference = 'nrs_reference_data']/value = $allReferenceData/name]"/>

	<xsl:variable name="concatWorksheet" select="/node()/simple_instance[name = $spreadsheet/own_slot_value[slot_reference = 'ss_concat_reference_worksheet']/value]"/>
	<xsl:variable name="allConcatReferenceData" select="/node()/simple_instance[name = $concatWorksheet/own_slot_value[slot_reference = 'rws_references']/value]"/>
	<xsl:variable name="allNamedConcatRanges" select="/node()/simple_instance[name = $allConcatReferenceData/own_slot_value[slot_reference = 'cds_named_range']/value]"/>
	<xsl:variable name="allExportSpecs" select="/node()/simple_instance[type = 'Column_Export_Specification']"/>

	<xsl:variable name="populationTypes" select="$worksheets/own_slot_value[slot_reference = 'ws_anchor_class']/value union $allExportSpecs/own_slot_value[slot_reference = 'ces_class']/value"/>
	<xsl:variable name="instancesForExport" select="/node()/simple_instance[type = $populationTypes]"/>

	<xsl:variable name="allTaxonomyTerms" select="/node()/simple_instance[type = 'Taxonomy_Term']"/>

	<xsl:variable name="emptyRowCount" select="200"/>
	<xsl:variable name="maxValidationCount" select="1000"/>
	<xsl:variable name="maxRefInstanceNo" select="500"/>
	<xsl:variable name="maxConcatNo" select="300"/>
	<xsl:variable name="shortColWidth" select="75"/>
	<xsl:variable name="mediumColWidth" select="200"/>
	<xsl:variable name="longColWidth" select="350"/>

	<xsl:variable name="maxWorksheetNameLength" select="30"/>


	<xsl:template match="knowledge_base">
		<Workbook>
			<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
				<Author>Essential Development Team</Author>
				<LastAuthor>Essential Development Team</LastAuthor>
				<Created>2011-10-13T14:06:02Z</Created>
				<LastSaved>2011-10-31T19:37:15Z</LastSaved>
				<Company>EAS Ltd</Company>
				<Version>1.0</Version>
			</DocumentProperties>
			<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
				<AllowPNG/>
			</OfficeDocumentSettings>
			<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
				<WindowHeight>15000</WindowHeight>
				<WindowWidth>25000</WindowWidth>
				<WindowTopX>560</WindowTopX>
				<WindowTopY>560</WindowTopY>
				<ProtectStructure>False</ProtectStructure>
				<ProtectWindows>False</ProtectWindows>
			</ExcelWorkbook>
			<!-- Render the standard styles used throughout the spreadsheet -->
			<xsl:call-template name="RenderStyles"/>

			<!-- Render the named ranges contained within the spreadsheet -->
			<Names>
				<xsl:apply-templates mode="RenderNamedRange" select="$allNamedRanges"/>
				<xsl:apply-templates mode="RenderReferenceNamedRange" select="$allNamedRefRanges"/>
				<xsl:apply-templates mode="RenderConcatReferenceNamedRange" select="$allNamedConcatRanges"/>
			</Names>

			<!--<NamedRange ss:Name="Application_Providers" ss:RefersTo="='Application Providers'!R7C2:R43C2"/>-->

			<!-- Render the modelling worksheets -->
			<!-- <xsl:apply-templates mode="RenderModellingWorksheet" select="$worksheetUsages[$worksheets[name=current()/own_slot_value[slot_reference='wsu_worksheet_specification']/value]/type='Worksheet_Specification']">
                <xsl:sort select="own_slot_value[slot_reference='wsu_index']/value"/>
                </xsl:apply-templates>-->

			<xsl:call-template name="RenderIndexWorksheet"/>

			<xsl:apply-templates mode="RenderModellingWorksheet" select="$worksheetUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
			</xsl:apply-templates>


			<!-- Render the reference worksheets -->
			<xsl:apply-templates mode="RenderReferenceWorksheet" select="$worksheetUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
			</xsl:apply-templates>


			<!-- Render the reference worksheet that contains concatenated data -->
			<xsl:if test="count($concatWorksheet) > 0">
				<xsl:call-template name="RenderConcatReferenceWorksheet"/>
			</xsl:if>

			<!--<Worksheet ss:Name="Application Providers">
                <Table ss:ExpandedColumnCount="6" ss:ExpandedRowCount="10" x:FullColumns="1"
                    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
                    <Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="140"/>
                    <Column ss:AutoFitWidth="0" ss:Width="112"/>
                    <Column ss:AutoFitWidth="0" ss:Width="300"/>
                    <Column ss:AutoFitWidth="0" ss:Width="200"/>
                    <Column ss:AutoFitWidth="0" ss:Width="130"/>
                    <Row ss:AutoFitHeight="0"/>
                    <Row ss:AutoFitHeight="0" ss:Height="25">
                        <Cell ss:Index="2" ss:MergeAcross="3" ss:StyleID="s62"><Data ss:Type="String">This is the Title</Data></Cell>
                    </Row>
                    <Row ss:AutoFitHeight="0">
                        <Cell ss:Index="2" ss:MergeAcross="3"><Data ss:Type="String">This is the description that goes on for a while</Data></Cell>
                    </Row>
                    <Row ss:Index="6" ss:AutoFitHeight="0">
                        <Cell ss:Index="2" ss:StyleID="s63"><Data ss:Type="String">Element Name</Data></Cell>
                        <Cell ss:StyleID="s63"><Data ss:Type="String">Synonym</Data></Cell>
                        <Cell ss:StyleID="s63"><Data ss:Type="String"><xsl:value-of select="eas:i18n('Description')"/></Data></Cell>
                        <Cell ss:StyleID="s63"><Data ss:Type="String">Validated Column</Data></Cell>
                        <Cell ss:StyleID="s63"><Data ss:Type="String">Content Source</Data></Cell>
                    </Row>
                    <Row ss:AutoFitHeight="0" ss:Height="6"/>
                    <Row ss:AutoFitHeight="0">
                        <Cell ss:Index="2" ss:StyleID="s73"><Data ss:Type="String">An App Provider</Data><NamedCell
                            ss:Name="Application_Providers"/></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">a Synonym</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">a Description</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">A Validated String</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">a content source</Data></Cell>
                    </Row>
                    <Row ss:AutoFitHeight="0">
                        <Cell ss:Index="2" ss:StyleID="s73"><Data ss:Type="String">Another App Provider</Data><NamedCell
                            ss:Name="Application_Providers"/></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">another Synonym</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">Here is my other one that is also useful that is going to be used for really long sentences</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">another validated string</Data></Cell>
                        <Cell ss:StyleID="s73"><Data ss:Type="String">another content source</Data></Cell>
                    </Row>
                    <Row ss:AutoFitHeight="0">
                        <Cell ss:Index="2" ss:StyleID="s73"><NamedCell ss:Name="Application_Providers"/></Cell>
                        <Cell ss:StyleID="s73"/>
                        <Cell ss:StyleID="s73"/>
                        <Cell ss:StyleID="s73"/>
                        <Cell ss:StyleID="s73"/>
                    </Row>
                </Table>
                <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
                    <Unsynced/>
                    <Print>
                        <ValidPrinterInfo/>
                        <PaperSizeIndex>9</PaperSizeIndex>
                        <HorizontalResolution>-4</HorizontalResolution>
                        <VerticalResolution>-4</VerticalResolution>
                    </Print>
                    <PageLayoutZoom>0</PageLayoutZoom>
                    <Selected/>
                    <FreezePanes/>
                    <FrozenNoSplit/>
                    <SplitHorizontal>6</SplitHorizontal>
                    <TopRowBottomPane>6</TopRowBottomPane>
                    <SplitVertical>4</SplitVertical>
                    <LeftColumnRightPane>4</LeftColumnRightPane>
                    <ActivePane>0</ActivePane>
                    <Panes>
                        <Pane>
                            <Number>3</Number>
                        </Pane>
                        <Pane>
                            <Number>1</Number>
                        </Pane>
                        <Pane>
                            <Number>2</Number>
                        </Pane>
                        <Pane>
                            <Number>0</Number>
                            <ActiveRow>12</ActiveRow>
                            <ActiveCol>2</ActiveCol>
                        </Pane>
                    </Panes>
                    <ProtectObjects>False</ProtectObjects>
                    <ProtectScenarios>False</ProtectScenarios>
                </WorksheetOptions>
            </Worksheet>-->


			<!--
            <Worksheet ss:Name="SHARED DATA">
                <Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="4" x:FullColumns="1"
                    x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
                    <Column ss:Index="3" ss:AutoFitWidth="0" ss:Width="267"/>
                    <Row ss:AutoFitHeight="0"/>
                    <Row ss:Index="4" ss:AutoFitHeight="0">
                        <Cell ss:Index="3"
                            ss:Formula="=CONCATENATE('Application Providers'!R[5]C[-1], &quot;::&quot;, 'Application Providers'!R[5]C[1])"><Data
                                ss:Type="String">Another App Provider::Here is my other one that is also useful that is going to be used for really long sentences</Data></Cell>
                    </Row>
                </Table>
                <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
                    <Unsynced/>
                    <Print>
                        <ValidPrinterInfo/>
                        <PaperSizeIndex>9</PaperSizeIndex>
                        <HorizontalResolution>-4</HorizontalResolution>
                        <VerticalResolution>-4</VerticalResolution>
                    </Print>
                    <PageLayoutZoom>0</PageLayoutZoom>
                    <Panes>
                        <Pane>
                            <Number>3</Number>
                            <ActiveRow>5</ActiveRow>
                            <ActiveCol>2</ActiveCol>
                        </Pane>
                    </Panes>
                    <ProtectObjects>False</ProtectObjects>
                    <ProtectScenarios>False</ProtectScenarios>
                </WorksheetOptions>
            </Worksheet>-->
		</Workbook>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a Named Range -->
	<xsl:template match="node()" mode="RenderNamedRange">
		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="rangeColumn" select="$allColumns[name = current()/own_slot_value[slot_reference = 'nrs_column']/value]"/>
		<xsl:variable name="rangeColumnUsage" select="$columnUsages[own_slot_value[slot_reference = 'cwu_column_specification']/value = $rangeColumn/name]"/>
		<xsl:variable name="worksheetUsage" select="$worksheetUsages[name = $rangeColumnUsage/own_slot_value[slot_reference = 'cwu_parent_worksheet_usage']/value]"/>
		<xsl:variable name="rangeWorksheet" select="$worksheets[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<!--<xsl:variable name="rangeWorksheet" select="$worksheets[name=current()/own_slot_value[slot_reference='nrs_worksheet']/value]"/>
        <xsl:variable name="worksheetUsage" select="$worksheetUsages[own_slot_value[slot_reference='wsu_worksheet_specification']/value = $rangeWorksheet/name]"/>-->
		<xsl:variable name="worksheetUsageLabel" select="eas:get_worksheet_name($worksheetUsage/own_slot_value[slot_reference = 'wsu_display_label']/value)"/>
		<!--<xsl:variable name="worksheetName">
            <xsl:choose>
                <xsl:when test="string-length($worksheetUsageLabel) > 0">
                    <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$rangeWorksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>-->
		<!--<xsl:variable name="worksheetName" select="$rangeWorksheet/own_slot_value[slot_reference='name']/value"/>-->

		<xsl:variable name="worksheetStartColumn" select="number($rangeWorksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>


		<xsl:variable name="columnIndex" select="number($rangeColumnUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>
		<xsl:variable name="rangeColumnNo" select="$worksheetStartColumn + $columnIndex - 1"/>
		<xsl:variable name="rangeStartRowNo" select="$ssStartRow + 1"/>
		<xsl:variable name="rangeSpec">
			<xsl:text>='</xsl:text>
			<xsl:value-of select="$worksheetUsageLabel"/>
			<xsl:text>'!R</xsl:text>
			<xsl:value-of select="$rangeStartRowNo"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$rangeColumnNo"/>
			<xsl:text>:R1000C</xsl:text>
			<xsl:value-of select="$rangeColumnNo"/>
		</xsl:variable>

		<NamedRange>
			<xsl:attribute name="ss:Name" select="$rangeName"/>
			<xsl:attribute name="ss:RefersTo" select="$rangeSpec"/>
		</NamedRange>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Reference Named Range -->
	<xsl:template match="node()" mode="RenderReferenceNamedRange">
		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="rangeWorksheet" select="$worksheets[name = current()/own_slot_value[slot_reference = 'nrs_worksheet']/value]"/>
		<xsl:variable name="worksheetUsage" select="$worksheetUsages[own_slot_value[slot_reference = 'wsu_worksheet_specification']/value = $rangeWorksheet/name]"/>
		<xsl:variable name="worksheetUsageLabel" select="eas:get_worksheet_name($worksheetUsage/own_slot_value[slot_reference = 'wsu_display_label']/value)"/>
		<!--<xsl:variable name="worksheetName">
            <xsl:choose>
                <xsl:when test="string-length($worksheetUsageLabel) > 0">
                    <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                </xsl:when>
                <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$rangeWorksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
            </xsl:choose>    
        </xsl:variable>-->
		<!--<xsl:variable name="worksheetName" select="$rangeWorksheet/own_slot_value[slot_reference='name']/value"/>-->
		<xsl:variable name="rangeRef" select="$allReferenceData[name = current()/own_slot_value[slot_reference = 'nrs_reference_data']/value]"/>
		<xsl:variable name="worksheetStartColumn" select="number($rangeWorksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<xsl:variable name="rangeStartColumnNo" select="$worksheetStartColumn + 1"/>
		<xsl:variable name="worksheetStartRow" select="number($rangeWorksheet/own_slot_value[slot_reference = 'rws_start_row']/value)"/>
		<xsl:variable name="rangeRefIndex" select="number($rangeRef/own_slot_value[slot_reference = 'rds_index']/value)"/>
		<xsl:variable name="rangeRowNo" select="$worksheetStartRow + $rangeRefIndex - 1"/>

		<xsl:variable name="refTaxonomy" select="/node()/simple_instance[name = $rangeRef/own_slot_value[slot_reference = 'tds_data_taxonomy']/value]"/>
		<xsl:variable name="refFixedValues" select="$rangeRef/own_slot_value[slot_reference = 'rds_fixed_values']/value"/>
		<xsl:variable name="refValueCount">
			<xsl:choose>
				<xsl:when test="count($refTaxonomy) > 0">
					<xsl:value-of select="count(/node()/simple_instance[name = $refTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value])"/>
				</xsl:when>
				<xsl:when test="count($refFixedValues) > 0">
					<xsl:value-of select="count($refFixedValues)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="count(/node()/simple_instance[type = $rangeRef/own_slot_value[slot_reference = 'rds_class']/value])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="rangeEndColumn" select="$rangeStartColumnNo + $refValueCount - 1"/>
		<xsl:variable name="rangeSpec">
			<xsl:text>='</xsl:text>
			<xsl:value-of select="$worksheetUsageLabel"/>
			<xsl:text>'!R</xsl:text>
			<xsl:value-of select="$rangeRowNo"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$rangeStartColumnNo"/>
			<xsl:text>:R</xsl:text>
			<xsl:value-of select="$rangeRowNo"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$rangeEndColumn"/>
		</xsl:variable>
		<!--<NamedRange ss:Name="Application_Providers" ss:RefersTo="='Application Providers'!R7C2:R43C2"/>-->
		<NamedRange>
			<xsl:attribute name="ss:Name" select="$rangeName"/>
			<xsl:attribute name="ss:RefersTo" select="$rangeSpec"/>
		</NamedRange>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Reference Named Range -->
	<xsl:template match="node()" mode="RenderConcatReferenceNamedRange">
		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = 'crnrs_display_label']/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="worksheetName" select="eas:get_worksheet_name($concatWorksheet/own_slot_value[slot_reference = 'ws_title']/value)"/>
		<!-- <xsl:variable name="worksheetName"><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetFullName"/></xsl:call-template></xsl:variable>-->
		<xsl:variable name="rangeRef" select="$allConcatReferenceData[name = current()/own_slot_value[slot_reference = 'crnrs_reference_data']/value]"/>
		<xsl:variable name="worksheetStartColumn" select="number($concatWorksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<xsl:variable name="rangeStartColumnNo" select="$worksheetStartColumn + 1"/>
		<xsl:variable name="worksheetStartRow" select="number($concatWorksheet/own_slot_value[slot_reference = 'rws_start_row']/value)"/>
		<xsl:variable name="rangeRefIndex" select="number($rangeRef/own_slot_value[slot_reference = 'rds_index']/value)"/>
		<xsl:variable name="rangeRowNo" select="$worksheetStartRow + $rangeRefIndex - 1"/>

		<xsl:variable name="refConcatColumnUsages" select="/node()/simple_instance[name = $rangeRef/own_slot_value[slot_reference = 'ccs_concatenated_columns']/value]"/>
		<xsl:variable name="refValueCount" select="$maxConcatNo"/>
		<xsl:variable name="rangeEndColumn" select="$rangeStartColumnNo + $refValueCount - 1"/>
		<xsl:variable name="rangeSpec">
			<xsl:text>='</xsl:text>
			<xsl:value-of select="$worksheetName"/>
			<xsl:text>'!R</xsl:text>
			<xsl:value-of select="$rangeRowNo"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$rangeStartColumnNo"/>
			<xsl:text>:R</xsl:text>
			<xsl:value-of select="$rangeRowNo"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$rangeEndColumn"/>
		</xsl:variable>
		<NamedRange>
			<xsl:attribute name="ss:Name" select="$rangeName"/>
			<xsl:attribute name="ss:RefersTo" select="$rangeSpec"/>
		</NamedRange>
	</xsl:template>




	<!-- 11.08.2011 JP -->
	<!-- Render a Worksheet used for modelling purposes -->
	<xsl:template match="node()" mode="RenderModellingWorksheet">
		<xsl:variable name="currentWSUsage" select="current()"/>
		<xsl:variable name="worksheet" select="$worksheets[name = current()/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<xsl:if test="$worksheet/type = 'Modelling_Worksheet_Specification'">
			<!--<xsl:variable name="worksheetUsageLabel" select="current()/own_slot_value[slot_reference='wsu_display_label']/value"/>
            <xsl:variable name="wsName">
                <xsl:choose>
                    <xsl:when test="string-length($worksheetUsageLabel) > 0">
                        <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
                </xsl:choose>    
            </xsl:variable>-->

			<xsl:variable name="columnUsages" select="$columnUsages[name = current()/own_slot_value[slot_reference = 'wsu_column_usages']/value]"/>
			<xsl:variable name="wsColumns" select="$allColumns[name = $columnUsages/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
			<xsl:variable name="wsName" select="eas:get_worksheet_name(current()/own_slot_value[slot_reference = 'wsu_display_label']/value)"/>
			<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
			<!--<xsl:variable name="wsColumns" select="$allColumns[name = $columnUsages/own_slot_value[slot_reference='cwu_column_specification']/value]"/>-->
			<xsl:variable name="wsTotalColumns">
				<xsl:call-template name="GetUsageTotalColumns">
					<xsl:with-param name="totalColumns" select="0"/>
					<xsl:with-param name="columnUsages" select="$columnUsages"/>
					<xsl:with-param name="columnNo" select="1"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="wsExpandedColCount" select="$wsStartColumn + $wsTotalColumns + 5"/>
			<xsl:variable name="customWsIdTemplate" select="$currentWSUsage/own_slot_value[slot_reference = 'wsu_id_template']/value"/>

			<xsl:variable name="wsIdTemplate">
				<xsl:choose>
					<xsl:when test="string-length($customWsIdTemplate) > 0">
						<xsl:value-of select="$customWsIdTemplate"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$worksheet/own_slot_value[slot_reference = 'ws_id_template']/value"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<Worksheet>
				<!-- Set the name of the worksheet -->
				<xsl:attribute name="ss:Name" select="$wsName"/>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
					<xsl:attribute name="ss:ExpandedRowCount" select="$ssDefaultRowCount"/>
					<xsl:attribute name="ss:ExpandedColumnCount" select="$wsExpandedColCount"/>

					<!-- Set the width of the columns that comprise the worksheet -->
					<xsl:for-each select="$columnUsages">
						<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
						<xsl:variable name="currentColUsage" select="current()"/>
						<xsl:variable name="currentColumn" select="$allColumns[name = $currentColUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
						<xsl:variable name="relColWidth" select="$currentColumn/own_slot_value[slot_reference = 'cs_column_width']/value"/>
						<xsl:variable name="colWidth">
							<xsl:choose>
								<xsl:when test="$relColWidth = 'short'">
									<xsl:value-of select="$shortColWidth"/>
								</xsl:when>
								<xsl:when test="$relColWidth = 'medium'">
									<xsl:value-of select="$mediumColWidth"/>
								</xsl:when>
								<xsl:when test="$relColWidth = 'long'">
									<xsl:value-of select="$longColWidth"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$mediumColWidth"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="numberOfColumnSpecs">
							<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
							<xsl:choose>
								<xsl:when test="string-length($usageRepeats) = 0">
									<xsl:value-of select="number($currentColumn/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="number($usageRepeats)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<!--<xsl:variable name="numberOfColumnSpecs" select="number($currentColUsage/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
						<xsl:variable name="columnPosition" select="number($currentColUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>
						<xsl:variable name="colIsHidden" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_hide']/value"/>
						<!--<xsl:variable name="columnPosition" select="position()"/>-->
						<xsl:call-template name="RenderModellingColumnSettings">
							<xsl:with-param name="columnsRemaining" select="$numberOfColumnSpecs"/>
							<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
							<xsl:with-param name="colWidth" select="$colWidth"/>
							<xsl:with-param name="columnPosition" select="$columnPosition"/>
							<xsl:with-param name="isHidden" select="$colIsHidden"/>
						</xsl:call-template>
						<!--<Column ss:AutoFitWidth="0">
                            <xsl:attribute name="ss:Width" select="$colWidth"/>
                            <xsl:if test="position() = 1">
                                <xsl:attribute name="ss:Index" select="$wsStartColumn"/>
                            </xsl:if>
                        </Column>-->
					</xsl:for-each>

					<!-- Create the worksheet title and description -->
					<xsl:call-template name="RenderWorksheetUsageTitle">
						<xsl:with-param name="worksheetUsage" select="$currentWSUsage"/>
					</xsl:call-template>

					<!-- Create the worksheet column headings -->
					<Row ss:AutoFitHeight="0">
						<xsl:attribute name="ss:Index" select="$ssStartRow"/>

						<xsl:for-each select="$columnUsages">
							<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
							<xsl:variable name="currentColUsage" select="current()"/>
							<xsl:variable name="currentCol" select="$allColumns[name = $currentColUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
							<xsl:variable name="colUsageLabel" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_column_label']/value"/>
							<xsl:variable name="columnName">
								<xsl:choose>
									<xsl:when test="string-length($colUsageLabel) = 0">
										<xsl:value-of select="$currentCol/own_slot_value[slot_reference = 'cs_heading_label']/value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$colUsageLabel"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="colUsageDesc" select="$currentColUsage/own_slot_value[slot_reference = 'description']/value"/>
							<xsl:variable name="columnDesc">
								<xsl:choose>
									<xsl:when test="string-length($colUsageLabel) = 0">
										<xsl:value-of select="$currentCol/own_slot_value[slot_reference = 'description']/value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$colUsageDesc"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- <xsl:variable name="columnName" select="current()/own_slot_value[slot_reference='cs_heading_label']/value"/>
                            <xsl:variable name="columnDesc" select="current()/own_slot_value[slot_reference='description']/value"/>-->

							<xsl:variable name="totalColsForSpec">
								<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
								<xsl:choose>
									<xsl:when test="string-length($usageRepeats) = 0">
										<xsl:value-of select="number($currentCol/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="number($usageRepeats)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>


							<!--<xsl:variable name="totalColsForSpec" select="number($currentColUsage/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
							<xsl:variable name="colUsageIndex" select="number($currentColUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>
							<xsl:choose>
								<xsl:when test="$totalColsForSpec > 1">
									<xsl:call-template name="RenderModellingColumnHeading">
										<xsl:with-param name="columnsRemaining" select="$totalColsForSpec"/>
										<xsl:with-param name="columnNo" select="1"/>
										<xsl:with-param name="columnPosition" select="$colUsageIndex"/>
										<xsl:with-param name="columnName" select="$columnName"/>
										<xsl:with-param name="columnDesc" select="$columnDesc"/>
										<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<Cell>
										<xsl:attribute name="ss:StyleID" select="$columnHeadingStyleId"/>
										<xsl:if test="position() = 1">
											<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
										</xsl:if>
										<Data ss:Type="String">
											<xsl:value-of select="$columnName"/>
										</Data>
										<xsl:if test="string-length($columnDesc) > 0">
											<xsl:call-template name="RenderHeaderDescription">
												<xsl:with-param name="description" select="$columnDesc"/>
											</xsl:call-template>
										</xsl:if>
									</Cell>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:for-each>
					</Row>
					<Row ss:AutoFitHeight="0" ss:Height="6"/>
					<!-- Either create a set of populated rows or render a pre-defined number of empty rows -->
					<xsl:choose>
						<!-- If populate parameter is 'true' create a pre-populated worksheet with the remainder being empty -->
						<xsl:when test="($populateSS = 'true') and ($currentWSUsage/own_slot_value[slot_reference = 'wsu_populate']/value = 'true') and ($worksheet/own_slot_value[slot_reference = 'ws_can_populate']/value = 'true')">
							<xsl:variable name="wsClassName" select="$worksheet/own_slot_value[slot_reference = 'ws_anchor_class']/value"/>
							<xsl:variable name="wsFilters" select="$allTaxonomyTerms[name = $currentWSUsage/own_slot_value[slot_reference = 'wsu_taxonomy_term_filter']/value]"/>
							<!-- If an external repository has been specified, only bring in instances associated with the external repository -->

							<xsl:variable name="ws_slot_filter" select="$worksheet/own_slot_value[slot_reference = 'ws_conditional_slot']/value"/>
							<xsl:variable name="ws_slot_class_filter" select="$worksheet/own_slot_value[slot_reference = 'ws_conditional_slot_class']/value"/>

							<xsl:choose>
								<xsl:when test="string-length($extReposId) > 0">

									<!-- Apply any taxonomy filtes to the instances if they have been defined -->
									<xsl:choose>
										<xsl:when test="count($wsFilters) > 0">
											<xsl:variable name="wsFilteredInstances" select="$instancesForExport[(type = $wsClassName) and (own_slot_value[slot_reference = 'external_repository_instance_reference']/value = $extReposInstRefs/name) and (own_slot_value[slot_reference = 'element_classified_by']/value = $wsFilters/name)]"/>

											<xsl:choose>
												<xsl:when test="(count($ws_slot_filter) > 0) and (count($ws_slot_class_filter) > 0)">
													<xsl:variable name="wsInstanceSlotValues" select="$instancesForExport[name = $wsFilteredInstances/own_slot_value[slot_reference = $ws_slot_filter]/value]"/>
													<xsl:variable name="wsInstanceSlotofClassValues" select="$instancesForExport[type = $ws_slot_class_filter]"/>

													<xsl:variable name="wsInstances" select="$wsFilteredInstances[own_slot_value[slot_reference = $ws_slot_filter]/value = $wsInstanceSlotofClassValues/name]"/>

													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>

												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsFilteredInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsFilteredInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>




										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="wsFilteredInstances" select="$instancesForExport[(type = $wsClassName) and (own_slot_value[slot_reference = 'external_repository_instance_reference']/value = $extReposInstRefs/name)]"/>

											<xsl:choose>
												<xsl:when test="(count($ws_slot_filter) > 0) and (count($ws_slot_class_filter) > 0)">
													<xsl:variable name="wsInstanceSlotValues" select="$instancesForExport[name = $wsFilteredInstances/own_slot_value[slot_reference = $ws_slot_filter]/value]"/>
													<xsl:variable name="wsInstanceSlotofClassValues" select="$instancesForExport[type = $ws_slot_class_filter]"/>

													<xsl:variable name="wsInstances" select="$wsFilteredInstances[own_slot_value[slot_reference = $ws_slot_filter]/value = $wsInstanceSlotofClassValues/name]"/>

													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>

												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsFilteredInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsFilteredInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>

								</xsl:when>
								<xsl:otherwise>
									<!-- Apply any taxonomy filtes to the instances if they have been defined -->
									<xsl:choose>
										<xsl:when test="count($wsFilters) > 0">
											<xsl:variable name="wsFilteredInstances" select="$instancesForExport[(type = $wsClassName) and (own_slot_value[slot_reference = 'element_classified_by']/value = $wsFilters/name)]"/>

											<xsl:choose>
												<xsl:when test="(count($ws_slot_filter) > 0) and (count($ws_slot_class_filter) > 0)">
													<xsl:variable name="wsInstanceSlotValues" select="$instancesForExport[name = $wsFilteredInstances/own_slot_value[slot_reference = $ws_slot_filter]/value]"/>
													<xsl:variable name="wsInstanceSlotofClassValues" select="$instancesForExport[type = $ws_slot_class_filter]"/>

													<xsl:variable name="wsInstances" select="$wsFilteredInstances[own_slot_value[slot_reference = $ws_slot_filter]/value = $wsInstanceSlotofClassValues/name]"/>

													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>

												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsFilteredInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsFilteredInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>

										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="wsFilteredInstances" select="$instancesForExport[type = $wsClassName]"/>

											<xsl:choose>
												<xsl:when test="(count($ws_slot_filter) > 0) and (count($ws_slot_class_filter) > 0)">
													<!-- <xsl:variable name="wsInstances" select="$wsFilteredInstances[(count($instancesForExport[(name = current()/own_slot_value[slot_reference=$ws_slot_filter]/value) and (type=$ws_slot_class_filter)]) > 0)]"/>-->
													<xsl:variable name="wsInstanceSlotValues" select="$instancesForExport[name = $wsFilteredInstances/own_slot_value[slot_reference = $ws_slot_filter]/value]"/>
													<xsl:variable name="wsInstanceSlotofClassValues" select="$instancesForExport[type = $ws_slot_class_filter]"/>

													<xsl:variable name="wsInstances" select="$wsFilteredInstances[own_slot_value[slot_reference = $ws_slot_filter]/value = $wsInstanceSlotofClassValues/name]"/>



													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>

												</xsl:when>
												<xsl:otherwise>
													<xsl:apply-templates mode="RenderPopulatedRow" select="$wsFilteredInstances">
														<xsl:sort select="own_slot_value[slot_reference = 'name']/value"/>
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="wsStartRow" select="$ssStartRow"/>
													</xsl:apply-templates>

													<!-- Fill out any remaining rows as empty -->
													<xsl:call-template name="RenderEmptyRow">
														<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
														<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
														<xsl:with-param name="rowsRemaining" select="$emptyRowCount - count($wsFilteredInstances)"/>
														<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>

										</xsl:otherwise>
									</xsl:choose>


								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="RenderEmptyRow">
								<xsl:with-param name="wsColumnUsages" select="$columnUsages"/>
								<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
								<xsl:with-param name="rowsRemaining" select="$emptyRowCount"/>
								<xsl:with-param name="wsTemplateString" select="$wsIdTemplate"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</Table>
				<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
					<Unsynced/>
					<xsl:if test="current()/own_slot_value[slot_reference = 'wsu_hide_worksheet']/value = 'true'">
						<Visible>SheetHidden</Visible>
					</xsl:if>
					<Print>
						<ValidPrinterInfo/>
						<PaperSizeIndex>9</PaperSizeIndex>
						<HorizontalResolution>-4</HorizontalResolution>
						<VerticalResolution>-4</VerticalResolution>
					</Print>
					<PageLayoutZoom>0</PageLayoutZoom>
					<Selected/>
					<FreezePanes/>
					<FrozenNoSplit/>
					<SplitHorizontal>6</SplitHorizontal>
					<TopRowBottomPane>6</TopRowBottomPane>
					<SplitVertical>4</SplitVertical>
					<LeftColumnRightPane>4</LeftColumnRightPane>
					<ActivePane>0</ActivePane>
					<Panes>
						<Pane>
							<Number>3</Number>
						</Pane>
						<Pane>
							<Number>1</Number>
						</Pane>
						<Pane>
							<Number>2</Number>
						</Pane>
						<Pane>
							<Number>0</Number>
							<ActiveRow>1</ActiveRow>
							<ActiveCol>1</ActiveCol>
						</Pane>
					</Panes>
					<ProtectObjects>False</ProtectObjects>
					<ProtectScenarios>False</ProtectScenarios>
				</WorksheetOptions>
				<xsl:variable name="wsValidations" select="$allNamedRanges[name = $wsColumns/own_slot_value[slot_reference = 'cs_validation']/value]"/>
				<xsl:apply-templates mode="RenderMultiColumnValidation" select="$wsValidations">
					<xsl:with-param name="inScopeColumnUsages" select="$columnUsages"/>
					<xsl:with-param name="validationStartRow" select="$ssStartRow + 2"/>
					<!-- <xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>-->
					<xsl:with-param name="worksheetUsage" select="$currentWSUsage"/>
					<xsl:with-param name="nameSlot" select="'name'"/>
				</xsl:apply-templates>
				<xsl:variable name="wsRefValidations" select="$allNamedRefRanges[name = $wsColumns/own_slot_value[slot_reference = 'cs_validation']/value]"/>
				<xsl:apply-templates mode="RenderMultiColumnValidation" select="$wsRefValidations">
					<xsl:with-param name="inScopeColumnUsages" select="$columnUsages"/>
					<xsl:with-param name="validationStartRow" select="$ssStartRow + 2"/>
					<!--<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>-->
					<xsl:with-param name="worksheetUsage" select="$currentWSUsage"/>
					<xsl:with-param name="nameSlot" select="'name'"/>
				</xsl:apply-templates>
				<xsl:apply-templates mode="RenderMultiConcatColumnValidation" select="$allNamedConcatRanges[own_slot_value[slot_reference = 'crnrs_validated_columns']/value = $columnUsages/name]">
					<xsl:with-param name="inScopeColumnUsages" select="$columnUsages"/>
					<xsl:with-param name="validationStartRow" select="$ssStartRow + 2"/>
					<xsl:with-param name="worksheetUsage" select="$currentWSUsage"/>
					<xsl:with-param name="nameSlot" select="'crnrs_display_label'"/>
				</xsl:apply-templates>
				<!-- <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
                    <Range>R8C5:R10C5</Range>
                    <Type>List</Type>
                    <Value>Application_Providers</Value>
                </DataValidation>-->
			</Worksheet>
		</xsl:if>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Worksheet used for holding reference values -->
	<xsl:template match="node()" mode="RenderReferenceWorksheet">
		<xsl:variable name="currentWSUsage" select="current()"/>
		<xsl:variable name="worksheet" select="$worksheets[name = $currentWSUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<xsl:if test="$worksheet/type = 'Reference_Worksheet_Specification'">
			<!--<xsl:variable name="worksheetUsageLabel" select="current()/own_slot_value[slot_reference='wsu_display_label']/value"/>
            <xsl:variable name="wsName">
                <xsl:choose>
                    <xsl:when test="string-length($worksheetUsageLabel) > 0">
                        <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
                </xsl:choose>    
                </xsl:variable>-->
			<xsl:variable name="wsLabel" select="$currentWSUsage/own_slot_value[slot_reference = 'wsu_display_label']/value"/>
			<xsl:variable name="wsName" select="eas:get_worksheet_name($wsLabel)"/>
			<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
			<xsl:variable name="wsStartRow" select="number($worksheet/own_slot_value[slot_reference = 'rws_start_row']/value)"/>
			<xsl:variable name="wsRefSpecs" select="/node()/simple_instance[name = $worksheet/own_slot_value[slot_reference = 'rws_references']/value]"/>
			<xsl:variable name="wsExpandedColCount" select="$wsStartColumn + $maxRefInstanceNo - 1"/>

			<Worksheet>
				<!-- Set the name of the wprksheet -->
				<xsl:attribute name="ss:Name" select="$wsName"/>
				<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
					<xsl:attribute name="ss:ExpandedRowCount" select="$ssDefaultRowCount"/>
					<xsl:attribute name="ss:ExpandedColumnCount" select="$wsExpandedColCount"/>

					<!-- Set the width of the columns that comprise the worksheet -->
					<Column ss:AutoFitWidth="1">
						<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
						<xsl:attribute name="ss:Width" select="$mediumColWidth"/>
					</Column>
					<xsl:call-template name="RenderReferenceColumn">
						<xsl:with-param name="columnsRemaining" select="wsExpandedColCount - 1"/>
					</xsl:call-template>


					<!-- Create the worksheet title and description -->
					<xsl:call-template name="RenderWorksheetUsageTitle">
						<xsl:with-param name="worksheetUsage" select="$currentWSUsage"/>
					</xsl:call-template>

					<Row ss:AutoFitHeight="0"/>
					<Row ss:AutoFitHeight="0"/>

					<!-- Render the reference data rows -->
					<xsl:apply-templates mode="RenderReferenceRow" select="$wsRefSpecs">
						<xsl:sort select="number(own_slot_value[slot_reference = 'rds_index']/value)"/>
						<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
						<xsl:with-param name="wsStartRow" select="$wsStartRow"/>
					</xsl:apply-templates>
				</Table>
				<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
					<Unsynced/>
					<Print>
						<ValidPrinterInfo/>
						<PaperSizeIndex>9</PaperSizeIndex>
						<HorizontalResolution>-4</HorizontalResolution>
						<VerticalResolution>-4</VerticalResolution>
					</Print>
					<PageLayoutZoom>0</PageLayoutZoom>
					<Panes>
						<Pane>
							<Number>3</Number>
							<ActiveRow>1</ActiveRow>
							<ActiveCol>1</ActiveCol>
							<RangeSelection>R5C6:R8C6</RangeSelection>
						</Pane>
					</Panes>
					<ProtectObjects>False</ProtectObjects>
					<ProtectScenarios>False</ProtectScenarios>
				</WorksheetOptions>
			</Worksheet>
		</xsl:if>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a Concat Worksheet used for holding reference values -->
	<xsl:template name="RenderConcatReferenceWorksheet">
		<xsl:variable name="worksheetUsageLabel" select="current()/own_slot_value[slot_reference = 'wsu_display_label']/value"/>
		<!--<xsl:variable name="wsName"><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="current()/own_slot_value[slot_reference='ws_title']/value"/></xsl:call-template></xsl:variable>
        -->
		<xsl:variable name="wsName" select="eas:get_worksheet_name($concatWorksheet/own_slot_value[slot_reference = 'ws_title']/value)"/>
		<xsl:variable name="wsStartColumn" select="number($concatWorksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<xsl:variable name="wsStartRow" select="number($concatWorksheet/own_slot_value[slot_reference = 'rws_start_row']/value)"/>
		<xsl:variable name="wsRefSpecs" select="/node()/simple_instance[name = $concatWorksheet/own_slot_value[slot_reference = 'rws_references']/value]"/>
		<xsl:variable name="wsExpandedColCount" select="$maxConcatNo + 1"/>

		<Worksheet>
			<!-- Set the name of the wprksheet -->
			<xsl:attribute name="ss:Name" select="$wsName"/>
			<Table x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
				<xsl:attribute name="ss:ExpandedRowCount" select="$ssDefaultRowCount"/>
				<xsl:attribute name="ss:ExpandedColumnCount" select="$wsExpandedColCount"/>

				<!-- Set the width of the columns that comprise the worksheet -->
				<Column ss:AutoFitWidth="1">
					<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
					<xsl:attribute name="ss:Width" select="$mediumColWidth"/>
				</Column>
				<xsl:call-template name="RenderReferenceColumn">
					<xsl:with-param name="columnsRemaining" select="wsExpandedColCount - 1"/>
				</xsl:call-template>


				<!-- Create the worksheet title and description -->
				<xsl:call-template name="RenderWorksheetTitle">
					<xsl:with-param name="worksheet" select="$concatWorksheet"/>
				</xsl:call-template>

				<Row ss:AutoFitHeight="0"/>
				<Row ss:AutoFitHeight="0"/>

				<!-- Render the reference data rows -->
				<xsl:apply-templates mode="RenderConcatReferenceRow" select="$wsRefSpecs">
					<xsl:sort select="number(own_slot_value[slot_reference = 'rds_index']/value)"/>
					<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
					<xsl:with-param name="wsStartRow" select="$wsStartRow"/>
				</xsl:apply-templates>
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Unsynced/>
				<Print>
					<ValidPrinterInfo/>
					<PaperSizeIndex>9</PaperSizeIndex>
					<HorizontalResolution>-4</HorizontalResolution>
					<VerticalResolution>-4</VerticalResolution>
				</Print>
				<PageLayoutZoom>0</PageLayoutZoom>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>1</ActiveRow>
						<ActiveCol>1</ActiveCol>
						<RangeSelection>R5C6:R8C6</RangeSelection>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a column for a reference data worksheet-->
	<xsl:template name="RenderReferenceColumn">
		<xsl:param name="columnsRemaining"/>
		<Column ss:AutoFitWidth="1">
			<xsl:attribute name="ss:Width" select="$mediumColWidth"/>
		</Column>
		<xsl:if test="$columnsRemaining > 0">
			<xsl:call-template name="RenderReferenceColumn">
				<xsl:with-param name="columnsRemaining" select="$columnsRemaining - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a reference worksheet row -->
	<xsl:template match="node()" mode="RenderReferenceRow">
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="wsStartRow"/>
		<xsl:variable name="refName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="refDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="refSlotName" select="own_slot_value[slot_reference = 'rds_slot']/value"/>
		<xsl:variable name="referenceInstances" select="/node()/simple_instance[type = current()/own_slot_value[slot_reference = 'rds_class']/value]"/>
		<xsl:variable name="refInstanceFilters" select="$allTaxonomyTerms[name = current()/own_slot_value[slot_reference = 'rds_content_filters']/value]"/>
		<xsl:variable name="refFixedValues" select="own_slot_value[slot_reference = 'rds_fixed_values']/value"/>
		<xsl:variable name="refTaxonomy" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'tds_data_taxonomy']/value]"/>

		<Row ss:AutoFitHeight="0">
			<xsl:if test="position() = 1">
				<xsl:attribute name="ss:Index" select="$wsStartRow"/>
			</xsl:if>
			<Cell>
				<xsl:attribute name="ss:StyleID" select="$columnHeadingStyleId"/>
				<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				<Data ss:Type="String">
					<xsl:value-of select="$refName"/>
				</Data>
				<xsl:if test="string-length($refDesc) > 0">
					<xsl:call-template name="RenderHeaderDescription">
						<xsl:with-param name="description" select="$refDesc"/>
					</xsl:call-template>
				</xsl:if>
			</Cell>
			<xsl:choose>
				<xsl:when test="count($refTaxonomy) > 0">
					<xsl:variable name="taxonomyTerms" select="$allTaxonomyTerms[name = $refTaxonomy/own_slot_value[slot_reference = 'taxonomy_terms']/value]"/>
					<xsl:for-each select="$taxonomyTerms">
						<Cell>
							<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
							<Data ss:Type="String">
								<xsl:value-of select="own_slot_value[slot_reference = 'name']/value"/>
							</Data>
						</Cell>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="count($refFixedValues) > 0">
					<xsl:for-each select="$refFixedValues">
						<Cell>
							<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
							<Data ss:Type="String">
								<xsl:value-of select="current()"/>
							</Data>
						</Cell>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="count($refInstanceFilters) > 0">
							<xsl:for-each select="$referenceInstances[own_slot_value[slot_reference = 'element_classified_by']/value = $refInstanceFilters/name]">
								<xsl:sort select="own_slot_value[slot_reference = $refSlotName]/value"/>
								<xsl:variable name="instanceLabel" select="own_slot_value[slot_reference = $refSlotName]/value"/>
								<Cell>
									<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
									<Data ss:Type="String">
										<xsl:value-of select="$instanceLabel"/>
									</Data>
								</Cell>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="$referenceInstances">
								<xsl:sort select="own_slot_value[slot_reference = $refSlotName]/value"/>
								<xsl:variable name="instanceLabel" select="own_slot_value[slot_reference = $refSlotName]/value"/>
								<Cell>
									<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
									<Data ss:Type="String">
										<xsl:value-of select="$instanceLabel"/>
									</Data>
								</Cell>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</Row>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a concatenated reference worksheet row -->
	<xsl:template match="node()" mode="RenderConcatReferenceRow">
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="wsStartRow"/>
		<xsl:variable name="refName" select="own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="refDesc" select="own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="refConcatColumns" select="/node()/simple_instance[name = current()/own_slot_value[slot_reference = 'ccs_concatenated_columns']/value]"/>

		<Row ss:AutoFitHeight="0">
			<xsl:if test="position() = 1">
				<xsl:attribute name="ss:Index" select="$wsStartRow"/>
			</xsl:if>
			<Cell>
				<xsl:attribute name="ss:StyleID" select="$columnHeadingStyleId"/>
				<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				<Data ss:Type="String">
					<xsl:value-of select="$refName"/>
				</Data>
				<xsl:if test="string-length($refDesc) > 0">
					<xsl:call-template name="RenderHeaderDescription">
						<xsl:with-param name="description" select="$refDesc"/>
					</xsl:call-template>
				</xsl:if>
			</Cell>
			<xsl:variable name="refConcatColumnUsages" select="$columnUsages[name = $refConcatColumns/own_slot_value[slot_reference = 'csu_column_specification']/value]"/>
			<xsl:variable name="sourceWorksheetUsage" select="$worksheetUsages[name = $refConcatColumnUsages/own_slot_value[slot_reference = 'cwu_parent_worksheet_usage']/value][1]"/>
			<!--<xsl:variable name="sourceWorksheet" select="$worksheets[name=$sourceWorksheetUsage/own_slot_value[slot_reference='wsu_worksheet_specification']/value]"/>-->
			<xsl:call-template name="RenderConcatDataCell">
				<xsl:with-param name="concatSourceWorksheetUsage" select="$sourceWorksheetUsage"/>
				<xsl:with-param name="refConcatColumns" select="$refConcatColumns"/>
				<xsl:with-param name="startRow" select="$wsStartRow"/>
				<xsl:with-param name="rowOffset" select="0"/>
				<xsl:with-param name="startColumn" select="$wsStartColumn + 1"/>
				<xsl:with-param name="columnOffset" select="0"/>
				<xsl:with-param name="cellsRemaining" select="$maxConcatNo - 1"/>
			</xsl:call-template>
		</Row>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an empty worksheet row -->
	<xsl:template name="RenderConcatDataCell">
		<xsl:param name="concatSourceWorksheetUsage"/>
		<xsl:param name="refConcatColumns"/>
		<xsl:param name="startRow"/>
		<xsl:param name="rowOffset"/>
		<xsl:param name="startColumn"/>
		<xsl:param name="columnOffset"/>
		<xsl:param name="cellsRemaining"/>
		<xsl:if test="$cellsRemaining > 0">
			<xsl:variable name="currentPosition" select="position()"/>
			<xsl:variable name="concatSourceWorksheet" select="$worksheets[name = $concatSourceWorksheetUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
			<xsl:variable name="wsStartColumn" select="number($concatSourceWorksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
			<xsl:variable name="refConcatColumnUsages" select="$columnUsages[name = $refConcatColumns/own_slot_value[slot_reference = 'csu_column_specification']/value]"/>
			<xsl:variable name="columnsForWorksheetUsage" select="$columnUsages[name = $concatSourceWorksheetUsage/own_slot_value[slot_reference = 'wsu_column_usages']/value]"/>

			<xsl:variable name="wsColumnUsagesSorted" as="node()*">
				<xsl:for-each select="$columnsForWorksheetUsage">
					<xsl:sort select="own_slot_value[slot_reference = 'eiu_index']/value"/>
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:variable>

			<!--<xsl:variable name="worksheetUsage" select="$worksheetUsages[own_slot_value[slot_reference='wsu_worksheet_specification']/value = $concatSourceWorksheet/name]"/>
            <xsl:variable name="worksheetUsageLabel" select="$worksheetUsage/own_slot_value[slot_reference='wsu_display_label']/value"/>
            <xsl:variable name="wsName">
                <xsl:choose>
                    <xsl:when test="string-length($worksheetUsageLabel) > 0">
                        <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$concatSourceWorksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
                </xsl:choose>    
            </xsl:variable>  -->
			<xsl:variable name="wsName" select="eas:get_worksheet_name($concatSourceWorksheetUsage/own_slot_value[slot_reference = 'wsu_display_label']/value)"/>

			<!-- <xsl:variable name="wsColumns" select="$allColumns[name = $concatSourceWorksheet/own_slot_value[slot_reference='ws_columns']/value]"/>-->
			<xsl:variable name="concatFormula">
				<xsl:text>=CONCATENATE(</xsl:text>
				<xsl:for-each select="$refConcatColumns">
					<xsl:sort select="own_slot_value[slot_reference = 'eiu_index']/value"/>
					<xsl:variable name="refConcatColumnUsage" select="$columnUsages[name = current()/own_slot_value[slot_reference = 'csu_column_specification']/value]"/>
					<xsl:variable name="rowNo" select="$ssStartRow + 2 - $startRow + $rowOffset - $currentPosition + 1"/>
					<xsl:variable name="columnIndex" select="number($refConcatColumnUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>
					<!-- <xsl:variable name="concatColumnNo" select="$columnIndex + $wsStartColumn"/>-->
					<xsl:variable name="concatColumnNo">
						<xsl:call-template name="GetColumnsSoFar">
							<xsl:with-param name="relevantColumnUsages" select="$wsColumnUsagesSorted"/>
							<xsl:with-param name="columnIndex" select="1"/>
							<xsl:with-param name="targetColumnNo" select="$columnIndex"/>
							<xsl:with-param name="totalColumns" select="1"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="columnNo" select="$concatColumnNo - $columnOffset - $startColumn + 1"/>
					<!--<xsl:variable name="columnNo" select="$concatColumnNo"/>-->
					<xsl:if test="position() != 1">
						<xsl:text disable-output-escaping="yes">, &quot;::&quot;, </xsl:text>
					</xsl:if>
					<xsl:text>'</xsl:text>
					<xsl:value-of select="$wsName"/>
					<xsl:text>'!R[</xsl:text>
					<xsl:value-of select="$rowNo"/>
					<xsl:text>]C[</xsl:text>
					<xsl:value-of select="$columnNo"/>
					<xsl:text>]</xsl:text>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>
			<!--<Cell ss:Formula="=CONCATENATE('Applications'!R[5]C[-1], &quot;::&quot;, 'Applications'!R[5]C[0])"/>-->
			<!-- <Cell ss:Formula="=CONCATENATE('Business Processes'R[3]C[1], &#34;::&#34;, 'Business Processes'R[3]C[-1])"/>-->

			<Cell>
				<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
				<xsl:attribute name="ss:Formula" select="$concatFormula"/>
			</Cell>
			<xsl:call-template name="RenderConcatDataCell">
				<xsl:with-param name="concatSourceWorksheetUsage" select="$concatSourceWorksheetUsage"/>
				<xsl:with-param name="refConcatColumns" select="$refConcatColumns"/>
				<xsl:with-param name="startRow" select="$startRow"/>
				<xsl:with-param name="rowOffset" select="$rowOffset + 1"/>
				<xsl:with-param name="startColumn" select="$startColumn"/>
				<xsl:with-param name="columnOffset" select="$columnOffset + 1"/>
				<xsl:with-param name="cellsRemaining" select="$cellsRemaining - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a pre-populated worksheet row -->
	<xsl:template mode="RenderPopulatedRow" match="node()">
		<xsl:param name="wsColumnUsages"/>
		<xsl:param name="wsStartColumn"/>

		<xsl:variable name="currentInstance" select="current()"/>
		<Row ss:AutoFitHeight="0">
			<xsl:for-each select="$wsColumnUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<xsl:variable name="currentColUsage" select="current()"/>
				<xsl:variable name="currentCol" select="$allColumns[name = current()/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>

				<!-- <xsl:variable name="relevantNameRange" select="$allNamedRanges[own_slot_value[slot_reference='nrs_column']/value = $currentCol/name]"/>-->
				<xsl:variable name="columnIsId" select="$currentCol/own_slot_value[slot_reference = 'cs_is_id']/value"/>
				<xsl:variable name="columnPosition" select="number($currentColUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>

				<xsl:choose>
					<xsl:when test="$columnIsId = 'true'">
						<!-- If an external repository has been specified, set the Id to the apprpriate external reference -->
						<xsl:choose>
							<xsl:when test="string-length($extReposId) > 0">
								<xsl:variable name="extRef" select="$extReposInstRefs[name = $currentInstance/own_slot_value[slot_reference = 'external_repository_instance_reference']/value]/own_slot_value[slot_reference = 'external_instance_reference']/value"/>
								<xsl:call-template name="RenderPopulatedColumnCell">
									<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
									<xsl:with-param name="columnPosition" select="$columnPosition"/>
									<xsl:with-param name="cellValue" select="$extRef"/>
									<xsl:with-param name="maxCols" select="1"/>
									<xsl:with-param name="valuePosition" select="1"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="RenderPopulatedColumnCell">
									<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
									<xsl:with-param name="columnPosition" select="$columnPosition"/>
									<xsl:with-param name="cellValue" select="$currentInstance/name"/>
									<xsl:with-param name="maxCols" select="1"/>
									<xsl:with-param name="valuePosition" select="1"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="totalCols">
							<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
							<xsl:choose>
								<xsl:when test="string-length($usageRepeats) = 0">
									<xsl:value-of select="number($currentCol/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="number($usageRepeats)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="columnExportSpec" select="$allExportSpecs[name = $currentCol/own_slot_value[slot_reference = 'cs_column_export_spec']/value]"/>
						<xsl:variable name="colCellValues" select="eas:get_values_for_export_spec($columnExportSpec, $currentInstance)"/>

						<xsl:for-each select="$colCellValues">
							<xsl:call-template name="RenderPopulatedColumnCell">
								<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
								<xsl:with-param name="columnPosition" select="$columnPosition"/>
								<xsl:with-param name="cellValue" select="current()"/>
								<xsl:with-param name="maxCols" select="$totalCols"/>
								<xsl:with-param name="valuePosition" select="position()"/>
							</xsl:call-template>
						</xsl:for-each>

						<xsl:call-template name="RenderEmptyColumnCell">
							<xsl:with-param name="columnsRemaining" select="$totalCols - count($colCellValues)"/>
							<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
							<xsl:with-param name="columnPosition" select="$columnPosition"/>
							<xsl:with-param name="columnIsId" select="$columnIsId"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</Row>

	</xsl:template>



	<xsl:template name="RenderPopulatedColumnCell">
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="columnPosition"/>
		<xsl:param name="cellValue"/>
		<xsl:param name="maxCols"/>
		<xsl:param name="valuePosition"/>

		<xsl:variable name="quotedPound">
			<xsl:text disable-output-escaping="yes">'£</xsl:text>
		</xsl:variable>
		<xsl:variable name="translatedCellValue" select="replace($cellValue, '&#163;', $quotedPound)"/>
		<xsl:if test="$valuePosition &lt;= $maxCols">
			<Cell>
				<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
				<xsl:if test="$columnPosition = 1">
					<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				</xsl:if>
				<Data ss:Type="String">
					<xsl:value-of select="$translatedCellValue"/>
				</Data>
			</Cell>
		</xsl:if>

	</xsl:template>




	<!-- 11.08.2011 JP -->
	<!-- Render a Column Validation entry -->
	<xsl:template match="node()" mode="RenderColumnValidation">
		<xsl:param name="inScopeColumns"/>
		<xsl:param name="validationStartRow"/>
		<xsl:param name="wsStartColumn"/>

		<xsl:variable name="validatedColumns" select="$inScopeColumns[own_slot_value[slot_reference = 'cs_validation']/value = current()/name]"/>

		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = 'name']/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="validationRange">
			<xsl:for-each select="$validatedColumns">
				<xsl:variable name="columnNo" select="number(current()/own_slot_value[slot_reference = 'cs_column_index']/value) + $wsStartColumn - 1"/>
				<xsl:text>R</xsl:text>
				<xsl:value-of select="$validationStartRow"/>
				<xsl:text>C</xsl:text>
				<xsl:value-of select="$columnNo"/>
				<xsl:text>:R</xsl:text>
				<xsl:value-of select="$maxValidationCount"/>
				<xsl:text>C</xsl:text>
				<xsl:value-of select="$columnNo"/>
				<xsl:if test="position() != count($validatedColumns)">,</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
			<Range>
				<xsl:value-of select="$validationRange"/>
			</Range>
			<Type>List</Type>
			<UseBlank/>
			<Value>
				<xsl:value-of select="$rangeName"/>
			</Value>
		</DataValidation>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render a Column Validation entry -->
	<xsl:template match="node()" mode="RenderMultiColumnValidation">
		<xsl:param name="inScopeColumnUsages"/>
		<xsl:param name="validationStartRow"/>
		<xsl:param name="worksheetUsage"/>
		<xsl:param name="nameSlot"/>

		<xsl:variable name="inScopeColumns" select="$allColumns[name = $inScopeColumnUsages/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
		<xsl:variable name="worksheet" select="$worksheets[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<xsl:variable name="wsColumnUsages" select="$columnUsages[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_column_usages']/value]"/>
		<xsl:variable name="wsColumnUsagesSorted" as="node()*">
			<xsl:for-each select="$wsColumnUsages">
				<xsl:sort select="own_slot_value[slot_reference = 'eiu_index']/value"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="validatedColumns" select="$inScopeColumns[own_slot_value[slot_reference = 'cs_validation']/value = current()/name]"/>
		<xsl:variable name="validatedColumnUsages" select="$inScopeColumnUsages[own_slot_value[slot_reference = 'cwu_column_specification']/value = $validatedColumns/name]"/>

		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = $nameSlot]/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="validationRange">
			<xsl:for-each select="$validatedColumnUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<xsl:variable name="currentColUsage" select="current()"/>
				<xsl:variable name="columnIndex" select="number(current()/own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<!--<xsl:variable name="columnRepeats" select="number(current()/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
				<!-- Changed to use column repeats from Column Spec as a default -->
				<xsl:variable name="columnRepeats">
					<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
					<xsl:choose>
						<xsl:when test="string-length($usageRepeats) = 0">
							<xsl:variable name="thisColumn" select="$validatedColumns[name = $currentColUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
							<xsl:value-of select="number($thisColumn/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($usageRepeats)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="columnsSoFar">
					<xsl:call-template name="GetColumnsSoFar">
						<xsl:with-param name="relevantColumnUsages" select="$wsColumnUsagesSorted"/>
						<xsl:with-param name="columnIndex" select="1"/>
						<xsl:with-param name="targetColumnNo" select="$columnIndex"/>
						<xsl:with-param name="totalColumns" select="0"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="columnNo" select="$columnsSoFar + $wsStartColumn"/>



				<!--<xsl:variable name="columnRepeats" select="number(current()/own_slot_value[slot_reference='cs_column_total']/value)"/>
                <xsl:variable name="columnsSoFar">
                    <xsl:call-template name="GetColumnsSoFar">
                        <xsl:with-param name="columns" select="$wsColumns"/>
                        <xsl:with-param name="columnIndex" select="1"/>
                        <xsl:with-param name="targetColumnNo" select="$columnIndex"/>
                        <xsl:with-param name="totalColumns" select="1"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="columnNo" select="$columnsSoFar + $wsStartColumn + 1"/>-->

				<!--<xsl:text>R</xsl:text><xsl:value-of select="$validationStartRow"/><xsl:text>C</xsl:text><xsl:value-of select="$columnNo"/><xsl:text>:R</xsl:text><xsl:value-of select="$maxValidationCount"/><xsl:text>C</xsl:text><xsl:value-of select="$columnNo"/>
                -->
				<xsl:call-template name="RenderRepeatValidation">
					<xsl:with-param name="repeatsRemaining" select="$columnRepeats"/>
					<!-- MAY NEED TO DO THIS -1 -->
					<xsl:with-param name="validationStartRow" select="$validationStartRow"/>
					<xsl:with-param name="columnNo" select="$columnNo"/>
				</xsl:call-template>
				<xsl:if test="position() != count($validatedColumns)">,</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
			<Range>
				<xsl:value-of select="$validationRange"/>
			</Range>
			<Type>List</Type>
			<UseBlank/>
			<Value>
				<xsl:value-of select="$rangeName"/>
			</Value>
		</DataValidation>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a Column Validation entry -->
	<xsl:template match="node()" mode="RenderMultiConcatColumnValidation">
		<xsl:param name="inScopeColumnUsages"/>
		<xsl:param name="validationStartRow"/>
		<xsl:param name="worksheetUsage"/>
		<xsl:param name="nameSlot"/>

		<xsl:variable name="inScopeColumns" select="$allColumns[name = $inScopeColumnUsages/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
		<xsl:variable name="worksheet" select="$worksheets[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<xsl:variable name="wsColumnUsages" select="$columnUsages[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_column_usages']/value]"/>
		<xsl:variable name="wsColumnUsagesSorted" as="node()*">
			<xsl:for-each select="$wsColumnUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>

		<!--<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference='ws_start_column']/value)"/>
        <xsl:variable name="wsColumns" select="$allColumns[name=$worksheet/own_slot_value[slot_reference='ws_columns']/value]"/>
        <xsl:variable name="wsColumnsSorted" as="node()*">
            <xsl:for-each select="$wsColumns">
                <xsl:sort select="own_slot_value[slot_reference='cs_column_index']/value"/>
                <xsl:copy-of select="." />
            </xsl:for-each>
        </xsl:variable>-->

		<xsl:variable name="validatedColumnUsages" select="$inScopeColumnUsages[name = current()/own_slot_value[slot_reference = 'crnrs_validated_columns']/value]"/>

		<xsl:variable name="origRangeName" select="current()/own_slot_value[slot_reference = $nameSlot]/value"/>
		<xsl:variable name="rangeName" select="translate($origRangeName, ' ', '_')"/>
		<xsl:variable name="validationRange">
			<xsl:for-each select="$validatedColumnUsages">
				<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<xsl:variable name="currentColUsage" select="current()"/>
				<xsl:variable name="columnIndex" select="number(current()/own_slot_value[slot_reference = 'eiu_index']/value)"/>
				<xsl:variable name="columnsSoFar">
					<xsl:call-template name="GetColumnsSoFar">
						<xsl:with-param name="relevantColumnUsages" select="$wsColumnUsagesSorted"/>
						<xsl:with-param name="columnIndex" select="1"/>
						<xsl:with-param name="targetColumnNo" select="$columnIndex"/>
						<xsl:with-param name="totalColumns" select="0"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="columnNo" select="$columnsSoFar + $wsStartColumn"/>

				<xsl:variable name="columnRepeats">
					<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
					<xsl:choose>
						<xsl:when test="string-length($usageRepeats) = 0">
							<xsl:variable name="thisColumn" select="$inScopeColumns[name = $currentColUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
							<xsl:value-of select="number($thisColumn/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($usageRepeats)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!--<xsl:variable name="columnRepeats" select="number(current()/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
				<!--<xsl:text>R</xsl:text><xsl:value-of select="$validationStartRow"/><xsl:text>C</xsl:text><xsl:value-of select="$columnNo"/><xsl:text>:R</xsl:text><xsl:value-of select="$maxValidationCount"/><xsl:text>C</xsl:text><xsl:value-of select="$columnNo"/>
                -->
				<xsl:call-template name="RenderRepeatValidation">
					<xsl:with-param name="repeatsRemaining" select="$columnRepeats"/>
					<xsl:with-param name="validationStartRow" select="$validationStartRow"/>
					<xsl:with-param name="columnNo" select="$columnNo"/>
				</xsl:call-template>
				<xsl:if test="position() != count($validatedColumnUsages)">,</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<DataValidation xmlns="urn:schemas-microsoft-com:office:excel">
			<Range>
				<xsl:value-of select="$validationRange"/>
			</Range>
			<Type>List</Type>
			<UseBlank/>
			<Value>
				<xsl:value-of select="$rangeName"/>
			</Value>
		</DataValidation>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Associate two Data Object within or across Packages-->
	<xsl:template name="RenderStyles">
		<Styles>
			<Style ss:ID="Default" ss:Name="Normal">
				<Alignment ss:Vertical="Top" ss:WrapText="1"/>
				<Borders/>
				<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
				<Interior/>
				<NumberFormat/>
				<Protection/>
			</Style>
			<Style ss:Name="ColumnHeading">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$columnHeadingStyleId"/>
				</xsl:attribute>
				<Alignment ss:Vertical="Top" ss:WrapText="1"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Calibri" ss:Size="14" ss:Color="#000000" ss:Bold="1"/>
				<Interior ss:Color="#A2BD90" ss:Pattern="Solid"/>
			</Style>
			<Style ss:Name="SheetCell">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$sheetCellStyleId"/>
				</xsl:attribute>
				<Alignment ss:Vertical="Top" ss:WrapText="1"/>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
			</Style>
			<Style ss:Name="SheetHeading">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$sheetHeadingStyleId"/>
				</xsl:attribute>
				<Font ss:FontName="Calibri" ss:Size="22" ss:Color="#000000" ss:Bold="1"/>
			</Style>
			<!--<Style ss:ID="s73" ss:Parent="s64">
                <Alignment ss:Vertical="Top" ss:WrapText="1"/>
                <Borders>
                    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
                    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
                </Borders>
                <Interior/>
            </Style>-->
			<Style ss:Name="IndexSubheading">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$indexSubheadingStyleId"/>
				</xsl:attribute>
				<Font ss:FontName="Calibri" ss:Size="12" ss:Color="#000000" ss:Bold="1"/>
			</Style>
			<Style ss:Name="indexColumnHeadingStyleId">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$indexColumnHeadingStyleId"/>
				</xsl:attribute>
				<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#FFFFFF" ss:Bold="1"/>
				<Interior ss:Color="#000000" ss:Pattern="Solid"/>
			</Style>
			<Style ss:Name="indexWorksheetTitle">
				<xsl:attribute name="ss:ID">
					<xsl:value-of select="$indexWorksheetTitleStyleId"/>
				</xsl:attribute>
				<Borders>
					<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>
					<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>
				</Borders>
				<Font ss:FontName="Calibri" ss:Size="12" ss:Color="#000000" ss:Bold="1"/>
				<Interior ss:Color="#FFCC99" ss:Pattern="Solid"/>
			</Style>
		</Styles>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- PRINT THE TITLE AND DESCRIPTION OF A WORKSHEET USAGE -->
	<xsl:template name="RenderWorksheetTitle">
		<xsl:param name="worksheet"/>
		<xsl:variable name="wsTitle" select="$worksheet/own_slot_value[slot_reference = 'ws_title']/value"/>
		<xsl:variable name="wsDesc" select="$worksheet/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<Row ss:AutoFitHeight="0"/>
		<Row ss:AutoFitHeight="0" ss:Height="25">
			<Cell ss:MergeAcross="3">
				<xsl:attribute name="ss:Index">
					<xsl:value-of select="$wsStartColumn"/>
				</xsl:attribute>
				<xsl:attribute name="ss:StyleID">
					<xsl:value-of select="$sheetHeadingStyleId"/>
				</xsl:attribute>
				<Data ss:Type="String">
					<xsl:value-of select="$wsTitle"/>
				</Data>
			</Cell>
		</Row>
		<Row ss:AutoFitHeight="0">
			<Cell ss:MergeAcross="3">
				<xsl:attribute name="ss:Index">
					<xsl:value-of select="$wsStartColumn"/>
				</xsl:attribute>
				<Data ss:Type="String">
					<xsl:value-of select="$wsDesc"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- PRINT THE TITLE AND DESCRIPTION OF A WORKSHEET USAGE -->
	<xsl:template name="RenderWorksheetUsageTitle">
		<xsl:param name="worksheetUsage"/>
		<xsl:variable name="worksheet" select="$worksheets[name = $worksheetUsage/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>
		<xsl:variable name="wsTitle" select="$worksheetUsage/own_slot_value[slot_reference = 'wsu_display_label']/value"/>
		<xsl:variable name="wsUsageDesc" select="$worksheetUsage/own_slot_value[slot_reference = 'description']/value"/>
		<xsl:variable name="wsDesc">
			<xsl:choose>
				<xsl:when test="string-length($wsUsageDesc) = 0">
					<xsl:value-of select="$worksheet/own_slot_value[slot_reference = 'description']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$wsUsageDesc"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="wsStartColumn" select="number($worksheet/own_slot_value[slot_reference = 'ws_start_column']/value)"/>
		<Row ss:AutoFitHeight="0"/>
		<Row ss:AutoFitHeight="0" ss:Height="25">
			<Cell ss:MergeAcross="3">
				<xsl:attribute name="ss:Index">
					<xsl:value-of select="$wsStartColumn"/>
				</xsl:attribute>
				<xsl:attribute name="ss:StyleID">
					<xsl:value-of select="$sheetHeadingStyleId"/>
				</xsl:attribute>
				<Data ss:Type="String">
					<xsl:value-of select="$wsTitle"/>
				</Data>
			</Cell>
		</Row>
		<Row ss:AutoFitHeight="0">
			<Cell ss:MergeAcross="3">
				<xsl:attribute name="ss:Index">
					<xsl:value-of select="$wsStartColumn"/>
				</xsl:attribute>
				<Data ss:Type="String">
					<xsl:value-of select="$wsDesc"/>
				</Data>
			</Cell>
		</Row>
	</xsl:template>





	<!-- 11.08.2011 JP -->
	<!-- Render an empty worksheet row -->
	<xsl:template name="RenderEmptyRowOLD">
		<xsl:param name="wsColumns"/>
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="rowsRemaining"/>
		<xsl:param name="wsTemplateString"/>
		<xsl:if test="$rowsRemaining > 0">
			<Row ss:AutoFitHeight="0">
				<xsl:for-each select="$wsColumns">
					<xsl:sort select="number(own_slot_value[slot_reference = 'cs_column_index']/value)"/>
					<xsl:variable name="relevantNameRange" select="$allNamedRanges[own_slot_value[slot_reference = 'nrs_column']/value = current()/name]"/>
					<xsl:variable name="columnIsId" select="current()/own_slot_value[slot_reference = 'cs_is_id']/value"/>
					<xsl:variable name="totalCols" select="number(current()/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
					<xsl:variable name="columnPosition" select="position()"/>
					<xsl:variable name="defaultValue" select="own_slot_value[slot_reference = 'cs_default_value']/value"/>
					<xsl:call-template name="RenderEmptyColumnCell">
						<xsl:with-param name="columnsRemaining" select="$totalCols"/>
						<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
						<xsl:with-param name="columnPosition" select="$columnPosition"/>
						<xsl:with-param name="columnIsId" select="$columnIsId"/>
						<xsl:with-param name="idNo" select="$emptyRowCount - $rowsRemaining + 1"/>
						<xsl:with-param name="wsTemplateString" select="$wsTemplateString"/>
						<xsl:with-param name="csDefaultValue" select="$defaultValue"/>
					</xsl:call-template>
					<!--<Cell>
                        <xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
                        <xsl:if test="position() = 1">
                            <xsl:attribute name="ss:Index" select="$wsStartColumn"/>
                        </xsl:if>
                        <xsl:if test="$columnIsId = 'true'">
                            <xsl:variable name="idNo" select="$emptyRowCount - $rowsRemaining + 1"></xsl:variable>
                            <Data ss:Type="String"><xsl:value-of select="concat($wsTemplateString, $idNo)"/></Data>
                        </xsl:if>
                    </Cell>       -->
				</xsl:for-each>
			</Row>
			<xsl:call-template name="RenderEmptyRowOLD">
				<xsl:with-param name="wsColumns" select="$wsColumns"/>
				<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
				<xsl:with-param name="rowsRemaining" select="$rowsRemaining - 1"/>
				<xsl:with-param name="wsTemplateString" select="$wsTemplateString"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Render an empty worksheet row -->
	<xsl:template name="RenderEmptyRow">
		<xsl:param name="wsColumnUsages"/>
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="rowsRemaining"/>
		<xsl:param name="wsTemplateString"/>
		<xsl:if test="$rowsRemaining > 0">
			<Row ss:AutoFitHeight="0">
				<xsl:for-each select="$wsColumnUsages">
					<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
					<xsl:variable name="currentColUsage" select="current()"/>
					<xsl:variable name="currentCol" select="$allColumns[name = current()/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>

					<!-- <xsl:variable name="relevantNameRange" select="$allNamedRanges[own_slot_value[slot_reference='nrs_column']/value = $currentCol/name]"/>-->
					<xsl:variable name="columnIsId" select="$currentCol/own_slot_value[slot_reference = 'cs_is_id']/value"/>

					<xsl:variable name="totalCols">
						<xsl:variable name="usageRepeats" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
						<xsl:choose>
							<xsl:when test="string-length($usageRepeats) = 0">
								<xsl:value-of select="number($currentCol/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="number($usageRepeats)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<!-- <xsl:variable name="totalCols" select="number($currentColUsage/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
					<xsl:variable name="columnPosition" select="number($currentColUsage/own_slot_value[slot_reference = 'eiu_index']/value)"/>

					<xsl:variable name="usageDefaultValue" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_default_value']/value"/>
					<xsl:variable name="defaultValue">
						<xsl:choose>
							<xsl:when test="string-length($usageDefaultValue) = 0">
								<xsl:value-of select="$currentCol/own_slot_value[slot_reference = 'cs_default_value']/value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$usageDefaultValue"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>


					<xsl:variable name="usageFormula" select="$currentColUsage/own_slot_value[slot_reference = 'cwu_column_formula']/value"/>
					<xsl:variable name="columnFormula">
						<xsl:choose>
							<xsl:when test="string-length($usageDefaultValue) = 0">
								<xsl:value-of select="$currentCol/own_slot_value[slot_reference = 'cs_column_formula']/value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$usageFormula"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:call-template name="RenderEmptyColumnCell">
						<xsl:with-param name="columnsRemaining" select="$totalCols"/>
						<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
						<xsl:with-param name="columnPosition" select="$columnPosition"/>
						<xsl:with-param name="columnIsId" select="$columnIsId"/>
						<xsl:with-param name="idNo" select="$emptyRowCount - $rowsRemaining + 1"/>
						<xsl:with-param name="wsTemplateString" select="$wsTemplateString"/>
						<xsl:with-param name="csDefaultValue" select="$defaultValue"/>
						<xsl:with-param name="csFormula" select="$columnFormula"/>
					</xsl:call-template>
					<!--<Cell>
                        <xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
                        <xsl:if test="position() = 1">
                        <xsl:attribute name="ss:Index" select="$wsStartColumn"/>
                        </xsl:if>
                        <xsl:if test="$columnIsId = 'true'">
                        <xsl:variable name="idNo" select="$emptyRowCount - $rowsRemaining + 1"></xsl:variable>
                        <Data ss:Type="String"><xsl:value-of select="concat($wsTemplateString, $idNo)"/></Data>
                        </xsl:if>
                        </Cell>       -->
				</xsl:for-each>
			</Row>
			<xsl:call-template name="RenderEmptyRow">
				<xsl:with-param name="wsColumnUsages" select="$wsColumnUsages"/>
				<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
				<xsl:with-param name="rowsRemaining" select="$rowsRemaining - 1"/>
				<xsl:with-param name="wsTemplateString" select="$wsTemplateString"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- 11.08.2011 JP -->
	<!-- Associate a description of a column or reference data heading as a comment -->
	<xsl:template name="RenderHeaderDescription">
		<xsl:param name="description"/>
		<Comment ss:Author="AutoGen">
			<Data>
				<Font html:Size="9" html:Color="#000000" xmlns="http://www.w3.org/TR/REC-html40">
					<xsl:value-of select="$description"/>
				</Font>
			</Data>
		</Comment>
	</xsl:template>


	<xsl:template name="RenderIndexWorksheet">
		<Worksheet ss:Name="Table of Contents">
			<Table ss:ExpandedColumnCount="3" ss:ExpandedRowCount="{count($worksheets) + 15}" x:FullColumns="1" x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="15">
				<Column ss:Index="2" ss:AutoFitWidth="0" ss:Width="394"/>
				<Column ss:AutoFitWidth="0" ss:Width="390"/>
				<Row ss:Index="2" ss:Height="30">
					<Cell ss:Index="2" ss:StyleID="{$sheetHeadingStyleId}" ss:MergeAcross="1">
						<Data ss:Type="String">
							<xsl:value-of select="$spreadsheet/own_slot_value[slot_reference = 'name']/value"/>
						</Data>
					</Cell>
				</Row>
				<Row ss:AutoFitHeight="0">
					<Cell ss:Index="2" ss:MergeAcross="1">
						<Data ss:Type="String">
							<xsl:value-of select="$spreadsheet/own_slot_value[slot_reference = 'description']/value"/>
						</Data>
					</Cell>
				</Row>
				<Row ss:Index="5">
					<Cell ss:Index="2" ss:StyleID="{$indexSubheadingStyleId}">
						<Data ss:Type="String">Project:</Data>
					</Cell>
				</Row>
				<Row>
					<Cell ss:Index="2" ss:StyleID="{$indexSubheadingStyleId}">
						<Data ss:Type="String">Content Owner:</Data>
					</Cell>
				</Row>
				<Row>
					<Cell ss:Index="2" ss:StyleID="{$indexSubheadingStyleId}">
						<Data ss:Type="String">Template Type:</Data>
					</Cell>
				</Row>
				<Row>
					<Cell ss:Index="2" ss:StyleID="{$indexSubheadingStyleId}">
						<Data ss:Type="String">Template Version:</Data>
					</Cell>
				</Row>
				<Row ss:Index="10">
					<Cell ss:Index="2" ss:StyleID="{$indexColumnHeadingStyleId}">
						<Data ss:Type="String">Worksheet</Data>
					</Cell>
					<Cell ss:StyleID="{$indexColumnHeadingStyleId}">
						<Data ss:Type="String">Description</Data>
					</Cell>
				</Row>
				<Row ss:AutoFitHeight="0" ss:Height="5"/>
				<xsl:for-each select="$worksheetUsages">
					<xsl:sort select="number(own_slot_value[slot_reference = 'eiu_index']/value)"/>
					<xsl:variable name="currentWSUsage" select="current()"/>
					<xsl:variable name="worksheet" select="$worksheets[name = current()/own_slot_value[slot_reference = 'wsu_worksheet_specification']/value]"/>

					<!-- <xsl:variable name="worksheetUsageLabel" select="current()/own_slot_value[slot_reference='wsu_display_label']/value"/>
                    <xsl:variable name="worksheetName">
                        <xsl:choose>
                            <xsl:when test="string-length($worksheetUsageLabel) > 0">
                                <xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheetUsageLabel"/></xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$worksheet/own_slot_value[slot_reference='name']/value"/></xsl:call-template></xsl:otherwise>
                        </xsl:choose>    
                    </xsl:variable>   -->
					<xsl:variable name="worksheetName" select="$currentWSUsage/own_slot_value[slot_reference = 'wsu_display_label']/value"/>
					<xsl:variable name="wsUsageDesc" select="$currentWSUsage/own_slot_value[slot_reference = 'description']/value"/>
					<xsl:variable name="wsDesc">
						<xsl:choose>
							<xsl:when test="string-length($wsUsageDesc) = 0">
								<xsl:value-of select="$worksheet/own_slot_value[slot_reference = 'description']/value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$wsUsageDesc"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<Row ss:AutoFitHeight="0">
						<xsl:if test="$currentWSUsage/own_slot_value[slot_reference = 'wsu_hide_worksheet']/value = 'true'">
							<xsl:attribute name="ss:Hidden" select="1"/>
						</xsl:if>
						<Cell ss:Index="2" ss:StyleID="{$indexWorksheetTitleStyleId}">
							<xsl:attribute name="ss:HRef">
								<xsl:text>#'</xsl:text>
								<xsl:value-of select="eas:get_worksheet_name($worksheetName)"/>
								<xsl:text>'!A1</xsl:text>
							</xsl:attribute>
							<Data ss:Type="String">
								<xsl:value-of select="$worksheetName"/>
							</Data>
						</Cell>
						<Cell ss:StyleID="{$sheetCellStyleId}">
							<Data ss:Type="String">
								<xsl:value-of select="$wsDesc"/>
							</Data>
						</Cell>
					</Row>
				</xsl:for-each>
				<xsl:if test="count($concatWorksheet) > 0">
					<!--<xsl:variable name="worksheetName"><xsl:call-template name="GetWorksheetName"><xsl:with-param name="givenName" select="$concatWorksheet/own_slot_value[slot_reference='ws_title']/value"/></xsl:call-template></xsl:variable>
                    -->
					<xsl:variable name="worksheetName" select="eas:get_worksheet_name($concatWorksheet/own_slot_value[slot_reference = 'ws_title']/value)"/>
					<Row ss:AutoFitHeight="0">/ <Cell ss:Index="2" ss:StyleID="{$indexWorksheetTitleStyleId}">
							<xsl:attribute name="ss:HRef"><xsl:text>#'</xsl:text><xsl:value-of select="$worksheetName"/><xsl:text>'!A1</xsl:text></xsl:attribute>
							<Data ss:Type="String"><xsl:value-of select="$worksheetName"/></Data>
						</Cell>
						<Cell ss:StyleID="{$sheetCellStyleId}">
							<Data ss:Type="String"><xsl:value-of select="$concatWorksheet/own_slot_value[slot_reference = 'description']/value"/></Data>
						</Cell>
					</Row>
				</xsl:if>
			</Table>
			<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
				<Print>
					<ValidPrinterInfo/>
					<PaperSizeIndex>9</PaperSizeIndex>
					<HorizontalResolution>-4</HorizontalResolution>
					<VerticalResolution>-4</VerticalResolution>
				</Print>
				<PageLayoutZoom>0</PageLayoutZoom>
				<Selected/>
				<Panes>
					<Pane>
						<Number>3</Number>
						<ActiveRow>1</ActiveRow>
						<ActiveCol>1</ActiveCol>
					</Pane>
				</Panes>
				<ProtectObjects>False</ProtectObjects>
				<ProtectScenarios>False</ProtectScenarios>
			</WorksheetOptions>
		</Worksheet>
	</xsl:template>

	<xsl:template name="RenderModellingColumnSettings">
		<xsl:param name="columnsRemaining"/>
		<xsl:param name="colWidth"/>
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="columnPosition"/>
		<xsl:param name="isHidden"/>
		<xsl:if test="$columnsRemaining > 0">
			<Column ss:AutoFitWidth="0">
				<xsl:attribute name="ss:Width" select="$colWidth"/>
				<xsl:if test="$columnPosition = 1">
					<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				</xsl:if>
				<xsl:if test="$isHidden = 'true'">
					<xsl:attribute name="ss:Hidden" select="1"/>
				</xsl:if>
			</Column>
			<xsl:call-template name="RenderModellingColumnSettings">
				<xsl:with-param name="columnsRemaining" select="$columnsRemaining - 1"/>
				<xsl:with-param name="colWidth" select="$colWidth"/>
				<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
				<xsl:with-param name="columnPosition" select="$columnPosition"/>
				<xsl:with-param name="isHidden" select="$isHidden"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="RenderModellingColumnHeading">
		<xsl:param name="columnsRemaining"/>
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="columnPosition"/>
		<xsl:param name="columnNo"/>
		<xsl:param name="columnName"/>
		<xsl:param name="columnDesc"/>
		<xsl:if test="$columnsRemaining > 0">
			<Cell>
				<xsl:attribute name="ss:StyleID" select="$columnHeadingStyleId"/>
				<xsl:if test="$columnPosition = 1">
					<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				</xsl:if>
				<Data ss:Type="String">
					<xsl:value-of select="$columnName"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="string($columnNo)"/>
				</Data>
				<xsl:if test="string-length($columnDesc) > 0">
					<xsl:call-template name="RenderHeaderDescription">
						<xsl:with-param name="description" select="$columnDesc"/>
					</xsl:call-template>
				</xsl:if>
			</Cell>
			<xsl:call-template name="RenderModellingColumnHeading">
				<xsl:with-param name="columnsRemaining" select="$columnsRemaining - 1"/>
				<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
				<xsl:with-param name="columnPosition" select="$columnPosition"/>
				<xsl:with-param name="columnNo" select="$columnNo + 1"/>
				<xsl:with-param name="columnName" select="$columnName"/>
				<xsl:with-param name="columnDesc" select="$columnDesc"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	<xsl:template name="RenderEmptyColumnCell">
		<xsl:param name="columnsRemaining"/>
		<xsl:param name="columnIsId"/>
		<xsl:param name="wsStartColumn"/>
		<xsl:param name="columnPosition"/>
		<xsl:param name="idNo"/>
		<xsl:param name="wsTemplateString"/>
		<xsl:param name="csDefaultValue"/>
		<xsl:param name="csFormula"/>

		<xsl:if test="$columnsRemaining > 0">
			<Cell>
				<xsl:attribute name="ss:StyleID" select="$sheetCellStyleId"/>
				<xsl:if test="$columnPosition = 1">
					<xsl:attribute name="ss:Index" select="$wsStartColumn"/>
				</xsl:if>
				<xsl:if test="string-length($csFormula) > 0">
					<xsl:attribute name="ss:Formula" select="$csFormula"/>
				</xsl:if>
				<xsl:if test="$columnIsId = 'true'">
					<Data ss:Type="String">
						<xsl:value-of select="concat($wsTemplateString, $idNo)"/>
					</Data>
				</xsl:if>
				<xsl:if test="string-length($csDefaultValue) > 0">
					<Data ss:Type="String">
						<xsl:value-of select="$csDefaultValue"/>
					</Data>
				</xsl:if>
			</Cell>
			<xsl:call-template name="RenderEmptyColumnCell">
				<xsl:with-param name="columnsRemaining" select="$columnsRemaining - 1"/>
				<xsl:with-param name="columnIsId" select="$columnIsId"/>
				<xsl:with-param name="wsStartColumn" select="$wsStartColumn"/>
				<xsl:with-param name="columnPosition" select="$columnPosition"/>
				<xsl:with-param name="idNo" select="$idNo"/>
				<xsl:with-param name="wsTemplateString" select="$wsTemplateString"/>
				<xsl:with-param name="csDefaultValue" select="$csDefaultValue"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<xsl:template name="GetColumnsSoFarOLD">
		<xsl:param name="columns"/>
		<xsl:param name="columnIndex"/>
		<xsl:param name="targetColumnNo"/>
		<xsl:param name="totalColumns"/>

		<xsl:choose>
			<xsl:when test="$columnIndex &lt; $targetColumnNo">
				<xsl:variable name="currentColumn" select="$columns[$columnIndex]"/>
				<xsl:variable name="noOfColumns" select="number($currentColumn/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
				<xsl:call-template name="GetColumnsSoFarOLD">
					<xsl:with-param name="columns" select="$columns"/>
					<xsl:with-param name="columnIndex" select="$columnIndex + 1"/>
					<xsl:with-param name="targetColumnNo" select="$targetColumnNo"/>
					<xsl:with-param name="totalColumns" select="$totalColumns + $noOfColumns"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$totalColumns"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	<xsl:template name="GetColumnsSoFar">
		<xsl:param name="relevantColumnUsages"/>
		<xsl:param name="columnIndex"/>
		<xsl:param name="targetColumnNo"/>
		<xsl:param name="totalColumns"/>

		<xsl:choose>
			<xsl:when test="$columnIndex &lt; $targetColumnNo">
				<xsl:variable name="currentColumnUsage" select="$relevantColumnUsages[$columnIndex]"/>

				<xsl:variable name="noOfColumns">
					<xsl:variable name="usageRepeats" select="$currentColumnUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
					<xsl:choose>
						<xsl:when test="string-length($usageRepeats) = 0">
							<xsl:variable name="currentCol" select="$allColumns[name = $currentColumnUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
							<xsl:value-of select="number($currentCol/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($usageRepeats)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!--<xsl:variable name="noOfColumns" select="number($currentColumnUsage/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
				<xsl:call-template name="GetColumnsSoFar">
					<xsl:with-param name="relevantColumnUsages" select="$relevantColumnUsages"/>
					<xsl:with-param name="columnIndex" select="$columnIndex + 1"/>
					<xsl:with-param name="targetColumnNo" select="$targetColumnNo"/>
					<xsl:with-param name="totalColumns" select="$totalColumns + $noOfColumns"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$totalColumns"/>
			</xsl:otherwise>
		</xsl:choose>
		<!--<xsl:value-of select="$targetColumnNo - 1"/>-->

	</xsl:template>


	<xsl:template name="RenderRepeatValidation">
		<xsl:param name="repeatsRemaining"/>
		<xsl:param name="validationStartRow"/>
		<xsl:param name="columnNo"/>

		<xsl:if test="$repeatsRemaining > 0">
			<xsl:text>R</xsl:text>
			<xsl:value-of select="$validationStartRow"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$columnNo"/>
			<xsl:text>:R</xsl:text>
			<xsl:value-of select="$maxValidationCount"/>
			<xsl:text>C</xsl:text>
			<xsl:value-of select="$columnNo"/>
			<xsl:if test="($repeatsRemaining - 1) > 0">
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:call-template name="RenderRepeatValidation">
				<xsl:with-param name="repeatsRemaining" select="$repeatsRemaining - 1"/>
				<xsl:with-param name="validationStartRow" select="$validationStartRow"/>
				<xsl:with-param name="columnNo" select="$columnNo + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!--<xsl:template name="GetTotalColumns">
        <xsl:param name="columns"/>
        <xsl:param name="columnNo"/>
        <xsl:param name="totalColumns"/>
        
        <xsl:choose>
            <xsl:when test="$columnNo &lt;= count($columns)">
                <xsl:variable name="currentColumn" select="$columns[$columnNo]"/>
                <xsl:variable name="noOfColumns" select="number($currentColumn/own_slot_value[slot_reference='cs_column_total']/value)"/>
                <xsl:call-template name="GetTotalColumns">
                    <xsl:with-param name="columns" select="$columns"/>
                    <xsl:with-param name="columnNo" select="$columnNo + 1"/>
                    <xsl:with-param name="totalColumns" select="$totalColumns + $noOfColumns"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$totalColumns"/></xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>-->


	<xsl:template name="GetUsageTotalColumns">
		<xsl:param name="columnUsages"/>
		<xsl:param name="columnNo"/>
		<xsl:param name="totalColumns"/>

		<xsl:choose>
			<xsl:when test="$columnNo &lt;= count($columnUsages)">
				<xsl:variable name="currentColumnUsage" select="$columnUsages[$columnNo]"/>

				<xsl:variable name="noOfColumns">
					<xsl:variable name="usageRepeats" select="$currentColumnUsage/own_slot_value[slot_reference = 'cwu_total_columns']/value"/>
					<xsl:choose>
						<xsl:when test="string-length($usageRepeats) = 0">
							<xsl:variable name="currentCol" select="$allColumns[name = $currentColumnUsage/own_slot_value[slot_reference = 'cwu_column_specification']/value]"/>
							<xsl:value-of select="number($currentCol/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="number($usageRepeats)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- <xsl:variable name="noOfColumns" select="number($currentColumn/own_slot_value[slot_reference='cwu_total_columns']/value)"/>-->
				<xsl:call-template name="GetUsageTotalColumns">
					<xsl:with-param name="columnUsages" select="$columnUsages"/>
					<xsl:with-param name="columnNo" select="$columnNo + 1"/>
					<xsl:with-param name="totalColumns" select="$totalColumns + $noOfColumns"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$totalColumns"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="GetWorksheetName">
		<xsl:param name="givenName"/>
		<xsl:value-of select="$givenName"/>
		<!--<xsl:value-of select="substring($givenName, $maxWorksheetNameLength)"/>-->
	</xsl:template>



	<!-- 11.08.2011 JP -->
	<!-- Render a Sequence containing the totals for each column in a worksheet -->
	<xsl:template name="GetRepeatTotals">
		<xsl:param name="columns"/>
		<xsl:param name="columnNo"/>
		<xsl:param name="repeatsList"/>

		<xsl:choose>
			<xsl:when test="$columnNo &lt;= count($columns)">
				<xsl:variable name="currentColumn" select="$columns[$columnNo]"/>
				<xsl:variable name="noOfColumns" select="number($currentColumn/own_slot_value[slot_reference = 'cs_column_total']/value)"/>
				<xsl:call-template name="GetRepeatTotals">
					<xsl:with-param name="columns" select="$columns"/>
					<xsl:with-param name="columnNo" select="$columnNo + 1"/>
					<xsl:with-param name="repeatsList" select="$repeatsList"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$repeatsList"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- FUNCTION TO CREATE A WORKSHEET NAME, LIMITED TO 30 CHARACTERS -->
	<xsl:function name="eas:get_worksheet_name" as="xs:string">
		<xsl:param name="originalName"/>
		<xsl:value-of select="substring($originalName, 1, $maxWorksheetNameLength)"/>
	</xsl:function>


	<!-- FUNCTION TO GET THE VALUE FOR A GIVEN EXPORT SPECIFICATION CHAIN -->
	<xsl:function name="eas:get_values_for_export_spec" as="xs:string*">
		<xsl:param name="currentExportSpec"/>
		<xsl:param name="currentInstances"/>

		<xsl:variable name="exportSpecSlot" select="$currentExportSpec/own_slot_value[slot_reference = 'ces_slot']/value"/>
		<xsl:variable name="nextExportSpec" select="$allExportSpecs[name = $currentExportSpec/own_slot_value[slot_reference = 'ces_next_export_spec']/value]"/>

		<xsl:choose>
			<xsl:when test="count($nextExportSpec) > 0">
				<xsl:choose>
					<xsl:when test="$currentExportSpec/own_slot_value[slot_reference = 'ces_is_inverse']/value = 'true'">
						<xsl:variable name="nextInstances" select="$instancesForExport[own_slot_value[slot_reference = $exportSpecSlot]/value = $currentInstances/name]"/>
						<xsl:copy-of select="eas:get_values_for_export_spec($nextExportSpec, $nextInstances)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="nextInstances" select="$instancesForExport[name = $currentInstances/own_slot_value[slot_reference = $exportSpecSlot]/value]"/>
						<xsl:copy-of select="eas:get_values_for_export_spec($nextExportSpec, $nextInstances)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$currentInstances/own_slot_value[slot_reference = $exportSpecSlot]/value"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>


</xsl:stylesheet>
