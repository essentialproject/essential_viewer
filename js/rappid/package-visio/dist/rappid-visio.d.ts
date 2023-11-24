/*! JointJS+ v3.7.2 - HTML5 Diagramming Framework - TRIAL VERSION

Copyright (c) 2023 client IO

 2023-10-10 


This Source Code Form is subject to the terms of the JointJS+ Trial License
, v. 2.0. If a copy of the JointJS+ License was not distributed with this
file, You can obtain one at https://www.jointjs.com/license
 or from the JointJS+ archive as was distributed by client IO. See the LICENSE file.*/


import { dia, g } from "jointjs";

// ----- CLASSES ------------------------------------------------------------------------
export class VisioArchive {

    document: VisioDocument;
    source: ArrayBuffer;

    static fromArrayBuffer(buffer: ArrayBuffer): Promise<VisioArchive>;

    static fromBase64(base64: string): Promise<VisioArchive>;

    static fromURL(url: string): Promise<VisioArchive>;

    toVSDX<T extends keyof VisioArchive.ToVSDXOutputByType = 'blob'>(options?: {
        type: T,
        compression?: 'STORE' | 'DEFLATE',
        compressionOptions?: null | {
            level: number;
        },
        comment?: string,
        mimeType?: string,
        encodeFileName?(filename: string): string,
        streamFiles?: boolean,
        platform?: 'DOS' | 'UNIX',
    }): Promise<VisioArchive.ToVSDXOutputByType[T]>;
}

export class VisioConnect extends VisioObject {

    fromCell: string;
    fromPart: string;
    fromSheet: string;
    toCell: string;
    toPart: string;
    toSheet: string;

    getShape(): VisioShape;

    getSource(): VisioShape | null;

    getTarget(): VisioShape | null;

    toLinkAttributes(sourceElement: dia.Element, targetElement: dia.Element): dia.Link.Attributes | null;
}

export class VisioDocument extends VisioRelObject {

    getMasters(): VisioMaster[];

    getMastersIdMap(): { [id: number]: VisioMaster };

    getMastersNameMap(): { [name: string]: VisioMaster };

    getPage(id: number): VisioPage;

    getPages(): VisioPage[];

}

export class VisioPage extends VisioRelObject {

    background: boolean;
    backPage: number;
    height: number;
    width: number;
    name: string;
    nameU: string;
    id: number;

    fromPaper(paper: dia.Paper, options?: VisioPage.FromPaperAttributes): Promise<void>;

    getContent(): Promise<VisioPageContent>;

}

export class VisioPageContent {

    getConnect(shapeId: number): VisioConnect | null;

    getConnects(): VisioConnect[];

    getElementShapes(): VisioShape[];

    getForeignShape(archivePath: string): VisioShape | null;

    getForeignShapes(): VisioShape[];

    getLinkShapes(): VisioShape[];

    getRootShape(id: number): VisioShape | null;

    getRootShapes(): VisioShape[];

    getShape(id: number): VisioShape | null;

    getShapes(): VisioShape[];

    toGraphCells(options?: VisioPageContent.ToGraphCellsAttributes): dia.Cell[];

    getFonts(): string[];

    getUnsupportedFonts(): string[];

}

export class VisioRow extends VisioSheetObject {

    index?: number;
    name?: string;
    type?: types.VisioRowType | string;

}

export class VisioShape extends VisioSheetObject {

    id: number;
    masterId: number;
    name: string | null;
    type: types.VisioShapeType | string;

    static fromMaster(master: VisioMaster, page: VisioPage): VisioShape;

    addSection<K extends keyof VisioSection.SectionClassByType>(type: K): VisioSection.SectionClassByType[K];

    getAncestorShapes(): VisioShape[];

    getComputedGeometry(): VisioGeometrySection[];

    getComputedSection<K extends keyof VisioSection.SectionClassByType>(name: K): VisioSection.SectionClassByType[K] | null;

    getConnect(): VisioConnect | null;

    getGeometry(): VisioGeometrySection[];

    hasImage(): boolean;

    getImage(): Promise<VisioImageObject | null>;

    getOwnSectionNames(): string[];

    getPageAngle(): number;

    getPageBBox(): g.Rect;

    getPagePosition(): g.Point;

    getPageZIndex(): number;

    getRootShape(): VisioShape;

    getSection<K extends keyof VisioSection.SectionClassByType>(type: K): VisioSection.SectionClassByType[K] | null;

    getSectionNames(): string[];

    getSubShapes(): VisioShape[];

    getText(): string;

    getMaster(): VisioMaster | null;

    isOneDimensional(): boolean;

    removeSection<K extends keyof VisioSection.SectionClassByType>(type: K, index?: number): void;

    setText(text: string): void;

    toElementAttributes(): dia.Element.Attributes;

}

export class VisioMaster extends VisioRelObject {

    id: number;
    name: string;

    getIconBase64(): string | null;

}

export class VisioCell {

    name: string;
    value: string | undefined;
    formula: string | undefined;
    units: string | undefined;

    eval(): any;

}

export class VisioSection extends VisioObject {

    type: types.VisioSectionType | string;

    static from<T extends VisioSection.VisioSectionType>(attributes: VisioSectionAttributes): VisioSection.SectionClassByType[T];

    getRows(): VisioRow[];

}

export class VisioGeometrySection extends VisioIndexedSection {

    addRow(type?: types.VisioRowType | string): VisioRow;

    toPath(width: number, height: number): g.Path;

    // Proxy VisioSheetObject API

    getOwnCellNames(): string[];

    getCell(name: types.VisioCellName | string): VisioCell | null;

    setCell(name: types.VisioCellName | string, attributes: Partial<VisioCellAttributes>): void;

    removeCell(name: types.VisioCellName | string): void;

}

export class VisioIndexedSection extends VisioSection {

    getRow(index: number): VisioRow;

    addRow(): VisioRow;

    removeRow(index: number): VisioRow[];

}

export class VisioNamedSection extends VisioSection {

    getRow(name: string): VisioRow;

    addRow(name): VisioRow;

    removeRow(name): VisioRow[];

}

export class VisioDataSection extends VisioNamedSection {

    getProperty(name: string, attribute?: string): any;

    getPropertyNames(): string[];

}

export class VisioSheetObject {

    getOwnCellNames(): string[];

    getCell(name: types.VisioCellName | string): VisioCell | null;

    setCell(name: types.VisioCellName | string, attributes: Partial<VisioCellAttributes>): void;

    removeCell(name: types.VisioCellName | string): void;

}

export class VisioElement extends dia.Element {

}

export class VisioLink extends dia.Link {

}

// ----- NAMESPACES ---------------------------------------------------------------------

namespace util {

    export function fromPixels(value: number, units?: types.VisioUnitType | string): number;

    export function toPixels(value: number, units?: types.VisioUnitType | string): number;

    export function isFontAvailable(fonts: string): boolean;

    export function isFontAvailable(fonts: string[]): boolean[];

}

namespace types {

    export enum VisioCellName {
        A = 'A',
        Action = 'Action',
        Active = 'Active',
        AddMarkup = 'AddMarkup',
        Address = 'Address',
        AlignBottom = 'AlignBottom',
        AlignCenter = 'AlignCenter',
        AlignLeft = 'AlignLeft',
        Alignment = 'Alignment',
        AlignMiddle = 'AlignMiddle',
        AlignRight = 'AlignRight',
        AlignTop = 'AlignTop',
        Angle = 'Angle',
        AsianFont = 'AsianFont',
        AutoGen = 'AutoGen',
        AvenueSizeX = 'AvenueSizeX',
        AvenueSizeY = 'AvenueSizeY',
        AvoidPageBreaks = 'AvoidPageBreaks',
        B = 'B',
        BeginArrow = 'BeginArrow',
        BeginArrowSize = 'BeginArrowSize',
        BeginGroup = 'BeginGroup',
        BeginX = 'BeginX',
        BeginY = 'BeginY',
        BegTrigger = 'BegTrigger',
        BevelBottomHeight = 'BevelBottomHeight',
        BevelBottomType = 'BevelBottomType',
        BevelBottomWidth = 'BevelBottomWidth',
        BevelContourColor = 'BevelContourColor',
        BevelContourSize = 'BevelContourSize',
        BevelDepthColor = 'BevelDepthColor',
        BevelDepthSize = 'BevelDepthSize',
        BevelLightingAngle = 'BevelLightingAngle',
        BevelLightingType = 'BevelLightingType',
        BevelMaterialType = 'BevelMaterialType',
        BevelTopHeight = 'BevelTopHeight',
        BevelTopType = 'BevelTopType',
        BevelTopWidth = 'BevelTopWidth',
        BlockSizeX = 'BlockSizeX',
        BlockSizeY = 'BlockSizeY',
        Blur = 'Blur',
        BottomMargin = 'BottomMargin',
        Brightness = 'Brightness',
        Bullet = 'Bullet',
        BulletFont = 'BulletFont',
        BulletFontSize = 'BulletFontSize',
        BulletStr = 'BulletStr',
        ButtonFace = 'ButtonFace',
        C = 'C',
        Calendar = 'Calendar',
        CanGlue = 'CanGlue',
        Case = 'Case',
        CenterX = 'CenterX',
        CenterY = 'CenterY',
        Checked = 'Checked',
        ClippingPath = 'ClippingPath',
        Color = 'Color',
        ColorSchemeIndex = 'ColorSchemeIndex',
        ColorTrans = 'ColorTrans',
        Comment = 'Comment',
        ComplexScriptFont = 'ComplexScriptFont',
        ComplexScriptSize = 'ComplexScriptSize',
        CompoundType = 'CompoundType',
        ConFixedCode = 'ConFixedCode',
        ConLineJumpCode = 'ConLineJumpCode',
        ConLineJumpDirX = 'ConLineJumpDirX',
        ConLineJumpDirY = 'ConLineJumpDirY',
        ConLineJumpStyle = 'ConLineJumpStyle',
        ConLineRouteExt = 'ConLineRouteExt',
        ConnectorSchemeIndex = 'ConnectorSchemeIndex',
        Contrast = 'Contrast',
        Copyright = 'Copyright',
        CtrlAsInput = 'CtrlAsInput',
        CurrentIndex = 'CurrentIndex',
        D = 'D',
        DataLinked = 'DataLinked',
        DblUnderline = 'DblUnderline',
        Default = 'Default',
        DefaultTabStop = 'DefaultTabStop',
        Denoise = 'Denoise',
        Description = 'Description',
        DirX = 'DirX',
        DirY = 'DirY',
        Disabled = 'Disabled',
        DisplayLevel = 'DisplayLevel',
        DisplayMode = 'DisplayMode',
        DistanceFromGround = 'DistanceFromGround',
        DocLangID = 'DocLangID',
        DocLockDuplicatePage = 'DocLockDuplicatePage',
        DocLockReplace = 'DocLockReplace',
        DontMoveChildren = 'DontMoveChildren',
        DoubleStrikethrough = 'DoubleStrikethrough',
        DrawingResizeType = 'DrawingResizeType',
        DrawingScale = 'DrawingScale',
        DrawingScaleType = 'DrawingScaleType',
        DrawingSizeType = 'DrawingSizeType',
        DropOnPageScale = 'DropOnPageScale',
        DynamicsOff = 'DynamicsOff',
        DynFeedback = 'DynFeedback',
        E = 'E',
        EffectSchemeIndex = 'EffectSchemeIndex',
        EmbellishmentIndex = 'EmbellishmentIndex',
        EnableFillProps = 'EnableFillProps',
        EnableGrid = 'EnableGrid',
        EnableLineProps = 'EnableLineProps',
        EnableTextProps = 'EnableTextProps',
        EndArrow = 'EndArrow',
        EndArrowSize = 'EndArrowSize',
        EndTrigger = 'EndTrigger',
        EndX = 'EndX',
        EndY = 'EndY',
        EventDblClick = 'EventDblClick',
        EventDrop = 'EventDrop',
        EventMultiDrop = 'EventMultiDrop',
        EventXFMod = 'EventXFMod',
        ExtraInfo = 'ExtraInfo',
        FillBkgnd = 'FillBkgnd',
        FillBkgndTrans = 'FillBkgndTrans',
        FillForegnd = 'FillForegnd',
        FillForegndTrans = 'FillForegndTrans',
        FillGradientAngle = 'FillGradientAngle',
        FillGradientDir = 'FillGradientDir',
        FillGradientEnabled = 'FillGradientEnabled',
        FillPattern = 'FillPattern',
        Flags = 'Flags',
        FlipX = 'FlipX',
        FlipY = 'FlipY',
        FlyoutChild = 'FlyoutChild',
        Font = 'Font',
        FontScale = 'FontScale',
        FontSchemeIndex = 'FontSchemeIndex',
        Format = 'Format',
        Frame = 'Frame',
        Gamma = 'Gamma',
        GlowColor = 'GlowColor',
        GlowColorTrans = 'GlowColorTrans',
        GlowSize = 'GlowSize',
        Glue = 'Glue',
        GlueType = 'GlueType',
        GradientStopColor = 'GradientStopColor',
        GradientStopColorTrans = 'GradientStopColorTrans',
        GradientStopPosition = 'GradientStopPosition',
        Height = 'Height',
        HelpTopic = 'HelpTopic',
        HideForApply = 'HideForApply',
        HideText = 'HideText',
        HorzAlign = 'HorzAlign',
        ImgHeight = 'ImgHeight',
        ImgOffsetX = 'ImgOffsetX',
        ImgOffsetY = 'ImgOffsetY',
        ImgWidth = 'ImgWidth',
        IndFirst = 'IndFirst',
        IndLeft = 'IndLeft',
        IndRight = 'IndRight',
        InhibitSnap = 'InhibitSnap',
        Initials = 'Initials',
        Invisible = 'Invisible',
        IsDropSource = 'IsDropSource',
        IsDropTarget = 'IsDropTarget',
        IsSnapTarget = 'IsSnapTarget',
        IsTextEditTarget = 'IsTextEditTarget',
        KeepTextFlat = 'KeepTextFlat',
        Label = 'Label',
        LangID = 'LangID',
        LayerMember = 'LayerMember',
        LeftMargin = 'LeftMargin',
        Letterspace = 'Letterspace',
        LineAdjustFrom = 'LineAdjustFrom',
        LineAdjustTo = 'LineAdjustTo',
        LineCap = 'LineCap',
        LineColor = 'LineColor',
        LineColorTrans = 'LineColorTrans',
        LineGradientAngle = 'LineGradientAngle',
        LineGradientDir = 'LineGradientDir',
        LineGradientEnabled = 'LineGradientEnabled',
        LineJumpCode = 'LineJumpCode',
        LineJumpFactorX = 'LineJumpFactorX',
        LineJumpFactorY = 'LineJumpFactorY',
        LineJumpStyle = 'LineJumpStyle',
        LinePattern = 'LinePattern',
        LineRouteExt = 'LineRouteExt',
        LineToLineX = 'LineToLineX',
        LineToLineY = 'LineToLineY',
        LineToNodeX = 'LineToNodeX',
        LineToNodeY = 'LineToNodeY',
        LineWeight = 'LineWeight',
        LocalizeMerge = 'LocalizeMerge',
        Lock = 'Lock',
        LockAspect = 'LockAspect',
        LockBegin = 'LockBegin',
        LockCalcWH = 'LockCalcWH',
        LockCrop = 'LockCrop',
        LockCustProp = 'LockCustProp',
        LockDelete = 'LockDelete',
        LockEnd = 'LockEnd',
        LockFormat = 'LockFormat',
        LockFromGroupFormat = 'LockFromGroupFormat',
        LockGroup = 'LockGroup',
        LockHeight = 'LockHeight',
        LockMoveX = 'LockMoveX',
        LockMoveY = 'LockMoveY',
        LockPreview = 'LockPreview',
        LockReplace = 'LockReplace',
        LockRotate = 'LockRotate',
        LockSelect = 'LockSelect',
        LockTextEdit = 'LockTextEdit',
        LockThemeColors = 'LockThemeColors',
        LockThemeConnectors = 'LockThemeConnectors',
        LockThemeEffects = 'LockThemeEffects',
        LockThemeFonts = 'LockThemeFonts',
        LockThemeIndex = 'LockThemeIndex',
        LockVariation = 'LockVariation',
        LockVtxEdit = 'LockVtxEdit',
        LockWidth = 'LockWidth',
        LocPinX = 'LocPinX',
        LocPinY = 'LocPinY',
        Menu = 'Menu',
        Name = 'Name',
        NameUniv = 'NameUniv',
        NewWindow = 'NewWindow',
        NoAlignBox = 'NoAlignBox',
        NoCoauth = 'NoCoauth',
        NoCtlHandles = 'NoCtlHandles',
        NoFill = 'NoFill',
        NoLine = 'NoLine',
        NoLiveDynamics = 'NoLiveDynamics',
        NonPrinting = 'NonPrinting',
        NoObjHandles = 'NoObjHandles',
        NoProofing = 'NoProofing',
        NoQuickDrag = 'NoQuickDrag',
        NoShow = 'NoShow',
        NoSnap = 'NoSnap',
        ObjectKind = 'ObjectKind',
        ObjType = 'ObjType',
        OnPage = 'OnPage',
        OutputFormat = 'OutputFormat',
        Overline = 'Overline',
        PageBottomMargin = 'PageBottomMargin',
        PageHeight = 'PageHeight',
        PageLeftMargin = 'PageLeftMargin',
        PageLineJumpDirX = 'PageLineJumpDirX',
        PageLineJumpDirY = 'PageLineJumpDirY',
        PageLockDuplicate = 'PageLockDuplicate',
        PageLockReplace = 'PageLockReplace',
        PageRightMargin = 'PageRightMargin',
        PageScale = 'PageScale',
        PageShapeSplit = 'PageShapeSplit',
        PagesX = 'PagesX',
        PagesY = 'PagesY',
        PageTopMargin = 'PageTopMargin',
        PageWidth = 'PageWidth',
        PaperKind = 'PaperKind',
        PaperSource = 'PaperSource',
        Perspective = 'Perspective',
        PinX = 'PinX',
        PinY = 'PinY',
        PlaceDepth = 'PlaceDepth',
        PlaceFlip = 'PlaceFlip',
        PlaceStyle = 'PlaceStyle',
        PlowCode = 'PlowCode',
        Pos = 'Pos',
        Position = 'Position',
        PreviewQuality = 'PreviewQuality',
        PreviewScope = 'PreviewScope',
        Print = 'Print',
        PrintGrid = 'PrintGrid',
        PrintPageOrientation = 'PrintPageOrientation',
        Prompt = 'Prompt',
        QuickStyleEffectsMatrix = 'QuickStyleEffectsMatrix',
        QuickStyleFillColor = 'QuickStyleFillColor',
        QuickStyleFillMatrix = 'QuickStyleFillMatrix',
        QuickStyleFontColor = 'QuickStyleFontColor',
        QuickStyleFontMatrix = 'QuickStyleFontMatrix',
        QuickStyleLineColor = 'QuickStyleLineColor',
        QuickStyleLineMatrix = 'QuickStyleLineMatrix',
        QuickStyleShadowColor = 'QuickStyleShadowColor',
        QuickStyleType = 'QuickStyleType',
        QuickStyleVariation = 'QuickStyleVariation',
        ReadOnly = 'ReadOnly',
        ReflectionBlur = 'ReflectionBlur',
        ReflectionDist = 'ReflectionDist',
        ReflectionSize = 'ReflectionSize',
        ReflectionTrans = 'ReflectionTrans',
        Relationships = 'Relationships',
        ReplaceCopyCells = 'ReplaceCopyCells',
        ReplaceLockFormat = 'ReplaceLockFormat',
        ReplaceLockShapeData = 'ReplaceLockShapeData',
        ReplaceLockText = 'ReplaceLockText',
        ResizeMode = 'ResizeMode',
        ResizePage = 'ResizePage',
        ReviewerID = 'ReviewerID',
        RightMargin = 'RightMargin',
        RotateGradientWithShape = 'RotateGradientWithShape',
        RotationType = 'RotationType',
        RotationXAngle = 'RotationXAngle',
        RotationYAngle = 'RotationYAngle',
        RotationZAngle = 'RotationZAngle',
        Rounding = 'Rounding',
        RouteStyle = 'RouteStyle',
        ScaleX = 'ScaleX',
        ScaleY = 'ScaleY',
        SelectMode = 'SelectMode',
        ShapeFixedCode = 'ShapeFixedCode',
        ShapeKeywords = 'ShapeKeywords',
        ShapePermeablePlace = 'ShapePermeablePlace',
        ShapePermeableX = 'ShapePermeableX',
        ShapePermeableY = 'ShapePermeableY',
        ShapePlaceFlip = 'ShapePlaceFlip',
        ShapePlaceStyle = 'ShapePlaceStyle',
        ShapePlowCode = 'ShapePlowCode',
        ShapeRouteStyle = 'ShapeRouteStyle',
        ShapeShdwBlur = 'ShapeShdwBlur',
        ShapeShdwObliqueAngle = 'ShapeShdwObliqueAngle',
        ShapeShdwOffsetX = 'ShapeShdwOffsetX',
        ShapeShdwOffsetY = 'ShapeShdwOffsetY',
        ShapeShdwScaleFactor = 'ShapeShdwScaleFactor',
        ShapeShdwShow = 'ShapeShdwShow',
        ShapeShdwType = 'ShapeShdwType',
        ShapeSplit = 'ShapeSplit',
        ShapeSplittable = 'ShapeSplittable',
        Sharpen = 'Sharpen',
        ShdwBkgnd = 'ShdwBkgnd',
        ShdwBkgndTrans = 'ShdwBkgndTrans',
        ShdwForegnd = 'ShdwForegnd',
        ShdwForegndTrans = 'ShdwForegndTrans',
        ShdwObliqueAngle = 'ShdwObliqueAngle',
        ShdwOffsetX = 'ShdwOffsetX',
        ShdwOffsetY = 'ShdwOffsetY',
        ShdwPattern = 'ShdwPattern',
        ShdwScaleFactor = 'ShdwScaleFactor',
        ShdwType = 'ShdwType',
        Size = 'Size',
        SketchAmount = 'SketchAmount',
        SketchEnabled = 'SketchEnabled',
        SketchFillChange = 'SketchFillChange',
        SketchLineChange = 'SketchLineChange',
        SketchLineWeight = 'SketchLineWeight',
        SketchSeed = 'SketchSeed',
        Snap = 'Snap',
        SoftEdgesSize = 'SoftEdgesSize',
        SortKey = 'SortKey',
        SpAfter = 'SpAfter',
        SpBefore = 'SpBefore',
        SpLine = 'SpLine',
        Status = 'Status',
        Strikethru = 'Strikethru',
        Style = 'Style',
        SubAddress = 'SubAddress',
        TagName = 'TagName',
        TextBkgnd = 'TextBkgnd',
        TextBkgndTrans = 'TextBkgndTrans',
        TextDirection = 'TextDirection',
        TextPosAfterBullet = 'TextPosAfterBullet',
        TheData = 'TheData',
        ThemeIndex = 'ThemeIndex',
        TheText = 'TheText',
        TopMargin = 'TopMargin',
        Transparency = 'Transparency',
        TxtAngle = 'TxtAngle',
        TxtHeight = 'TxtHeight',
        TxtLocPinX = 'TxtLocPinX',
        TxtLocPinY = 'TxtLocPinY',
        TxtPinX = 'TxtPinX',
        TxtPinY = 'TxtPinY',
        TxtWidth = 'TxtWidth',
        Type = 'Type',
        UICat = 'UICat',
        UICod = 'UICod',
        UIFmt = 'UIFmt',
        UIVisibility = 'UIVisibility',
        UpdateAlignBox = 'UpdateAlignBox',
        UseGroupGradient = 'UseGroupGradient',
        Value = 'Value',
        VariationColorIndex = 'VariationColorIndex',
        VariationStyleIndex = 'VariationStyleIndex',
        Verify = 'Verify',
        VerticalAlign = 'VerticalAlign',
        ViewMarkup = 'ViewMarkup',
        Visible = 'Visible',
        WalkPreference = 'WalkPreference',
        Width = 'Width',
        X = 'X',
        XCon = 'XCon',
        XDyn = 'XDyn',
        XGridDensity = 'XGridDensity',
        XGridOrigin = 'XGridOrigin',
        XGridSpacing = 'XGridSpacing',
        XJustify = 'XJustify',
        XRulerDensity = 'XRulerDensity',
        XRulerOrigin = 'XRulerOrigin',
        Y = 'Y',
        YCon = 'YCon',
        YDyn = 'YDyn',
        YGridDensity = 'YGridDensity',
        YGridOrigin = 'YGridOrigin',
        YGridSpacing = 'YGridSpacing',
        YJustify = 'YJustify',
        YRulerDensity = 'YRulerDensity',
        YRulerOrigin = 'YRulerOrigin'
    }

    export enum VisioRowType {
        ArcTo = 'ArcTo',
        Ellipse = 'Ellipse',
        EllipticalArcTo = 'EllipticalArcTo',
        InfiniteLine = 'InfiniteLine',
        LineTo = 'LineTo',
        MoveTo = 'MoveTo',
        NURBSTo = 'NURBSTo',
        PolylineTo = 'PolylineTo',
        RelCubBezTo = 'RelCubBezTo',
        RelEllipticalArcTo = 'RelEllipticalArcTo',
        RelLineTo = 'RelLineTo',
        RelMoveTo = 'RelMoveTo',
        RelQuadBezTo = 'RelQuadBezTo',
        SplineStart = 'SplineStart',
        SplineKnot = 'SplineKnot'
    }

    export enum VisioSectionType {
        Actions = 'Actions',
        ActionTag = 'ActionTag',
        Character = 'Character',
        Connection = 'Connection',
        Control = 'Control',
        Field = 'Field',
        FillGradient = 'FillGradient',
        Geometry = 'Geometry',
        Hyperlink = 'Hyperlink',
        Layer = 'Layer',
        LineGradient = 'LineGradient',
        Paragraph = 'Paragraph',
        User = 'User',
        Property = 'Property',
        Scratch = 'Scratch',
        Tabs = 'Tabs'
    }

    export enum VisioUnitType {
        AC = 'AC',       // Acres
        AD = 'AD',       // Degrees-minutes-seconds
        BOOL = 'BOOL',   // Boolean
        C = 'C',         // Ciceros
        C_D = 'C_D',     // Ciceros and didots
        CM = 'CM',       // Centimeters
        COLOR = 'COLOR', // RGB color value
        CY = 'CY',       // Currency
        D = 'D',         // Didots
        DA = 'DA',       // Radians
        DATE = 'DATE',   // Days
        DE = 'DE',       // Days
        DEG = 'DEG',     // Degrees
        DL = 'DL',       // Inches
        DP = 'DP',       // Inches
        DT = 'DT',       // Points
        ED = 'ED',       // Days
        EH = 'EH',       // Hours
        EM = 'EM',       // Minutes
        ES = 'ES',       // Seconds
        EW = 'EW',       // Weeks
        F_I = 'F_I',     // Feet and inches
        FT = 'FT',       // Feet
        HA = 'HA',       // Hectare
        IN = 'IN',       // Inches
        IN_F = 'IN_F',   // Inches
        KM = 'KM',       // Kilometers
        M = 'M',         // Meters
        MI = 'MI',       // Miles
        MI_F = 'MI_F',   // Miles
        MM = 'MM',       // Millimeters
        NM = 'NM',       // Nautical miles
        PER = 'PER',     // Percentage
        P_PT = 'P_PT',   // Picas and points
        PT = 'PT',       // Points
        P = 'P',         // Picas
        PNT = 'PNT',     // Coordinates of a two-dimensional point
        RAD = 'RAD',     // Radians
        STR = 'STR',     // String
        YD = 'YD'        // Yards
    }

    enum VisioShapeType {
        Shape = 'Shape',
        Group = 'Group',
        Foreign = 'Foreign',
        Guide = 'Guide',
        LinkLabel = 'LinkLabel'
    }
}

namespace debug {

    let level: number;

    function log(message: string): void;

}

namespace config {

    let evaluateFormulas: boolean;

}

namespace VisioArchive {

    interface ToVSDXOutputByType {
        base64: string;
        string: string;
        text: string;
        binarystring: string;
        array: number[];
        uint8array: Uint8Array;
        arraybuffer: ArrayBuffer;
        blob: Blob;
        nodebuffer: Buffer;
    }

}

namespace VisioSection {

    interface SectionClassByType {
        Actions: VisioNamedSection;
        ActionTag: VisioNamedSection;
        Character: VisioIndexedSection;
        Connection: VisioIndexedSection;
        Control: VisioNamedSection;
        Field: VisioIndexedSection;
        FillGradient: VisioIndexedSection;
        Geometry: VisioGeometrySection[];
        Hyperlink: VisioNamedSection;
        Layer: VisioIndexedSection;
        LineGradient: VisioIndexedSection;
        Paragraph: VisioIndexedSection;
        User: VisioDataSection;
        Property: VisioDataSection;
        Scratch: VisioIndexedSection;
        Tabs: VisioIndexedSection;
    }

    type VisioSectionType = keyof SectionClassByType;

}

namespace VisioPage {
    interface VisioShapeTemplates {
        fromConnection(linkView: dia.LinkView): Promise<JXON>;
        fromNodes(cellView: dia.CellView): Promise<JXON>;
    }
    interface FromPaperAttributes {
        exportElement?: (
            elementView: dia.ElementView,
            visioPage: VisioPage,
            templates: VisioShapeTemplates
        ) => Promise<VisioShape | null>;
        exportLink?: (
            linkView: dia.LinkView,
            visioPage: VisioPage,
            templates: VisioShapeTemplates
        ) => Promise<VisioShape | null>;
    }

}

namespace VisioPageContent {

    interface ToGraphCellsAttributes {
        ignoreNonPrinting?: boolean;
        ignoreSubShapeConnects?: boolean;
        importShape?: (shape: VisioShape) => dia.Element | null;
        importConnect?: (connect: VisioConnect, sourceElement: dia.Element, targetElement: dia.Element) => dia.Link | null;
        importLabels?: (shape: VisioShape, link: dia.Link) => dia.Element[] | void;
        importImage?: (shape: VisioShape, element: dia.Element, image: VisioImageObject) => any[] | void;
        onImagesLoad?: (images: any[]) => void;
    }

}

// ----- VISIO-WIDE INTERFACES ----------------------------------------------------------
// used to instantiate a Visio Cell
interface VisioCellAttributes {
    value: any;
    formula: string | null;
    units: string | null;
}

// used to instantiate a Visio Section
interface VisioSectionAttributes {
    archive: VisioArchive;
    type: types.VisioSectionType | string;
    cells?: VisioCells;
    rows?: VisioRow[];
    index?: number;
    jxon?: JXON;
}

// object returned when fetching an Image
interface VisioImageObject {
    absolutePath: string;
    file: string;
    extension: string;
    base64: string;
    selector: string;
}

// ----- NOT EXPOSED --------------------------------------------------------------------
class VisioRelObject extends VisioObject { }
class VisioCells extends VisioCellsBase { }
class VisioCellsBase extends VisioObject { }
class VisioObject { }

type JXON = { [key: string]: any };
