/*! JointJS+ v3.7.2 - HTML5 Diagramming Framework - TRIAL VERSION

Copyright (c) 2023 client IO

 2023-10-10 


This Source Code Form is subject to the terms of the JointJS+ Trial License
, v. 2.0. If a copy of the JointJS+ License was not distributed with this
file, You can obtain one at https://www.jointjs.com/license
 or from the JointJS+ archive as was distributed by client IO. See the LICENSE file.*/


import * as Backbone from 'backbone';

export * from 'jointjs';

export as namespace joint;

declare module 'jointjs' {

    /* JointJS Namespaces */

    export namespace dia {

        export namespace Paper {

            type PrintAction = (pages: JQuery[] | false) => void;
            type PrintUnits = 'mm' | 'cm' | 'in' | 'pt' | 'pc';

            interface PrintExportOptions {
                sheet?: dia.Size,
                sheetUnit?: PrintUnits,
                area?: g.Rect,
                ready?: (pages: JQuery[], printAction: PrintAction, opt: { sheetSizePx: dia.Size & { cssWidth: string, cssHeight: string } }) => void,
                poster?: boolean | { rows: number, columns: number } | dia.Size,
                margin?: dia.Padding,
                marginUnit?: PrintUnits,
                padding?: dia.Padding
            }

            type BeforeSerialize = (doc: SVGSVGElement, paper: dia.Paper) => void | SVGElement;

            interface SVGExportOptions {
                preserveDimensions?: boolean;
                area?: dia.BBox;
                convertImagesToDataUris?: boolean;
                useComputedStyles?: boolean;
                stylesheet?: string;
                beforeSerialize?: BeforeSerialize;
                fillFormControls?: boolean;
            }

            interface CanvasExportOptions extends SVGExportOptions {
                height?: number;
                width?: number;
                size?: string;
                backgroundColor?: string;
                padding?: dia.Padding;
                canvg?: any;
            }

            interface RasterExportOptions extends CanvasExportOptions {
                type?: 'image/png' | 'image/jpeg' | string;
                quality?: number;
            }
        }

        export interface Paper {

            /**
            * @deprecated use format.print
            */
            print(opt?: Paper.PrintExportOptions): void;

            toDataURL(callback: (dataURL: string) => void, opt?: Paper.RasterExportOptions): void;

            toJPEG(callback: (dataURL: string) => void, opt?: Paper.RasterExportOptions): void;

            toPNG(callback: (dataURL: string) => void, opt?: Paper.RasterExportOptions): void;

            toSVG(callback: (svg: string) => void, opt?: Paper.SVGExportOptions): void;

            toCanvas(callback: (canvas: HTMLCanvasElement) => void, opt?: Paper.CanvasExportOptions): void;

            openAsSVG(opt?: Paper.SVGExportOptions): void;

            openAsPNG(opt?: Paper.RasterExportOptions): void;
        }

        export namespace Graph {

            interface ShortestPathOptions {
                directed?: boolean;
                weight?: (id1: string, id2: string) => number;
            }

            interface ConstructTreeNode {
                children?: ConstructTreeNode[]
                [property: string]: any;
            }

            interface ConstructTreeConfig {
                children?: string | ((node: ConstructTreeNode) => ConstructTreeNode[]);
                makeElement: (node: ConstructTreeNode, parentElement: dia.Element | null) => dia.Element;
                makeLink: (parentElement: dia.Element, childElement: dia.Element) => dia.Link;
            }
        }

        export interface Graph {

            /**
             * @deprecated use graphUtils.constructTree
             */
            constructTree(
                parent: Graph.ConstructTreeNode,
                config: Graph.ConstructTreeConfig
            ): dia.Cell[];

            /**
             * @deprecated use graphUtils.shortestPath
             */
            shortestPath(
                source: dia.Element | string | number,
                target: dia.Element | string | number,
                opt?: Graph.ShortestPathOptions
            ): Array<string | number>;
        }

        namespace CommandManager {

            type ReduceOptionsCallback = (value: any, name: string) => boolean;

            interface Options {
                graph: dia.Graph;
                cmdBeforeAdd?: (eventName: string, ...eventArgs: any[]) => boolean;
                cmdNameRegex?: any; /* a regular expression */
                applyOptionsList?: string[] | ReduceOptionsCallback;
                revertOptionsList?: string[] | ReduceOptionsCallback;
                storeReducedOptions?: boolean;
                stackLimit?: number;
            }

            interface EventOptions {
                [key: string]: any;
            }
            interface CommandData {
                id: string | number;
                type: string;
                previous: any;
                next: any;
                attributes: any;
            }

            interface Command {
                batch: boolean;
                action: string;
                data: CommandData;
                options: any;
                graphChange: boolean;
            }

            type BatchCommand = Command[];

            type Commands = Array<Command | BatchCommand>;

            interface JSON {
                undo: BatchCommand[];
                redo: BatchCommand[];
                [key: string]: any;
            }
        }

        class CommandManager extends Backbone.Model {

            constructor(opt: CommandManager.Options);

            options: CommandManager.Options;

            undoStack: CommandManager.Commands;

            redoStack: CommandManager.Commands;

            batchLevel: number | null;

            batchCommand: CommandManager.Commands | null;

            lastCmdIndex: number | null;

            undo(opt?: CommandManager.EventOptions): void;

            redo(opt?: CommandManager.EventOptions): void;

            cancel(opt?: CommandManager.EventOptions): void;

            reset(opt?: CommandManager.EventOptions): void;

            hasUndo(): boolean;

            hasRedo(): boolean;

            squashUndo(n?: number): void;

            squashRedo(n?: number): void;

            listen(): void;

            initBatchCommand(): void;

            storeBatchCommand(opt?: CommandManager.EventOptions): void;

            toJSON(): CommandManager.JSON;

            fromJSON(json: CommandManager.JSON, opt?: CommandManager.EventOptions): void;

            protected reduceOptions(opt: CommandManager.EventOptions): Partial<CommandManager.EventOptions>;

            protected exportBatchCommands(commands?: CommandManager.Commands): CommandManager.BatchCommand[];

            static sortBatchCommand(batchCommand: CommandManager.BatchCommand): CommandManager.BatchCommand;

            static filterBatchCommand(batchCommand: CommandManager.BatchCommand): CommandManager.BatchCommand;

            static squashCommands(commands: CommandManager.Commands, n?: number): CommandManager.Commands;
        }

        namespace Validator {

            export interface Options {
                commandManager: dia.CommandManager;
                cancelInvalid?: boolean;
            }

            type Callback = (err: Error, command: any, next: any) => any;
        }

        class Validator extends Backbone.Model {

            constructor(opt: Validator.Options);

            options: Validator.Options;

            /* overrides Backbone.Model.prototype.validate() */
            validate(actions: any, ...callback: Array<Validator.Callback>): Validator;
        }
    }

    export namespace elementTools {

        namespace SwimlaneBoundary {
            export interface Options extends dia.ToolView.Options {
                laneId: string;
                padding?: dia.Sides;
                attributes?: attributes.NativeSVGAttributes;
            }
        }

        class SwimlaneBoundary extends dia.ToolView {
            constructor(opt: SwimlaneBoundary.Options);

            options: SwimlaneBoundary.Options;
        }

        namespace SwimlaneTransform {

            export interface HandleOptions extends mvc.ViewOptions<undefined> {
                axis: 'x' | 'y';
                side: dia.OrthogonalDirection;
            }

            export class Handle extends mvc.View<undefined> {
                options: HandleOptions;
            }

            export interface Handle {
                new(...args: any[]): Handle;
            }

            export interface Options extends dia.ToolView.Options {
                laneId: string;
                minSize?: number;
                handleClass?: any;
                padding?: dia.Sides;
                stopPropagation?: boolean;
                constraintsPadding?: number;
                minSizeConstraints?: (model: shapes.bpmn2.Pool, laneId: string, handleSide: dia.OrthogonalDirection) => Array<dia.Point>;
                maxSizeConstraints?: (model: shapes.bpmn2.Pool, laneId: string, handleSide: dia.OrthogonalDirection) => Array<dia.Point>;
            }
        }

        class SwimlaneTransform extends dia.ToolView {
            static TransformHandle: SwimlaneTransform.Handle;

            constructor(opt: SwimlaneTransform.Options);

            options: SwimlaneTransform.Options;

            protected onHandleChangeStart(selectedHandle: SwimlaneTransform.Handle, evt: dia.Event): void;
            protected onHandleChanging(selectedHandle: SwimlaneTransform.Handle, evt: dia.Event): void;
            protected onHandleChangeEnd(selectedHandle: SwimlaneTransform.Handle, evt: dia.Event): void;
        }


        namespace RecordScrollbar {

            export interface Options extends dia.ToolView.Options {
                margin?: number;
                width?: number;
                rightAlign?: boolean;
            }
        }
        class RecordScrollbar extends dia.ToolView {

            constructor(opt: RecordScrollbar.Options);

            options: RecordScrollbar.Options;

            protected getTrackHeight(): number;
            protected getScale(): number;
            protected getBBox(): g.Rect;
            protected enable(): void;
            protected disable(): void;
            protected onPointerDown(evt: dia.Event): void;
            protected onPointerMove(evt: dia.Event): void;
            protected onPointerUp(evt: dia.Event): void;
        }
    }

    export namespace layout {

        namespace ForceDirected {
            export interface Options {
                graph: dia.Graph | dia.Cell[];
                x?: number;
                y?: number;
                width: number;
                height: number;
                gravityCenter: dia.Point;
                charge?: number;
                linkDistance?: number;
                linkStrength?: number;
            }
        }

        class ForceDirected extends Backbone.Model {

            constructor(opt: ForceDirected.Options);

            options: ForceDirected.Options;

            start(): void;

            step(): void;
        }

        namespace GridLayout {

            type SetAttributesCallback = (element: dia.Element, attributes: dia.Element, opt: Options) => void;

            type GridMetrics = {
                rowHeights: number[];
                columnWidths: number[];
                gridX: number[];
                gridY: number[];
                bbox: g.Rect;
            };

            export interface Options {
                resizeToFit?: boolean;
                marginX?: number;
                marginY?: number;
                columns?: number;
                columnWidth?: 'compact' | 'auto' | number | string;
                rowHeight?: 'compact' | 'auto' | number | string;
                verticalAlign?: 'top' | 'middle' | 'bottom';
                horizontalAlign?: 'left' | 'middle' | 'right';
                columnGap?: number;
                rowGap?: number;
                deep?: boolean;
                parentRelative?: boolean;
                setAttributes?: SetAttributesCallback
                /**
                 * @deprecated use verticalAlign / horizontalAlign
                 */
                centre?: boolean;
                /**
                 * @deprecated use columnGap
                 */
                dx?: number;
                /**
                 * @deprecated use rowGap
                 */
                dy?: number;
            }

            export function layout(graphOrCells: dia.Graph | Array<dia.Cell>, opt?: Options): GridMetrics;
        }

        namespace StackLayout {

            type SetAttributesCallback = (element: dia.Element, attributes: dia.Element.Attributes, opt?: dia.Graph.Options) => void;

            export enum Directions {
                TopBottom = 'TB',
                BottomTop = 'BT',
                LeftRight = 'LR',
                RightLeft = 'RL'
            }

            export enum Alignments {
                Start = 'start',
                Middle = 'middle',
                End = 'end',
            }

            export interface StackLayoutOptions {
                direction: Directions;
                alignment?: Alignments;
                stackSize: number;
                stackGap?: number;
                stackElementGap?: number;
                stackCount?: number;
                topLeft?: dia.Point;
                bottomLeft?: dia.Point;
                topRight?: dia.Point;
                bottomRight?: dia.Point;
                setAttributes?: SetAttributesCallback;
                stackIndexAttributeName?: string;
                stackElementIndexAttributeName?: string;
            }

            export interface Stack {
                bbox: g.Rect,
                elements: dia.Element[],
                index: number
            }

            export interface StackLayoutResult {
                bbox: g.Rect,
                stacks: Stack[]
            }

            export function layout(model: dia.Graph | dia.Element[], options?: StackLayoutOptions): StackLayoutResult;
        }

        namespace TreeLayout {

            interface AttributeNames {
                'siblingRank'?: string;
                'direction'?: string;
                'margin'?: string;
                'offset'?: string;
                'prevSiblingGap'?: string;
                'nextSiblingGap'?: string;
                'firstChildGap'?: string;
            }

            type Direction = 'L' | 'R' | 'T' | 'B' | 'BR' | 'BL' | 'TR' | 'TL';

            type FromToDirections = [Direction, Direction];

            type DirectionRule = (rule: FromToDirections) => (direction: Direction) => Direction;

            type SiblingRank = number | undefined;
            export interface DirectionRules {
                rotate: DirectionRule;
                flip: DirectionRule;
                straighten: DirectionRule;
            }

            export interface Options {
                graph: dia.Graph;
                gap?: number;
                parentGap?: number;
                siblingGap?: number;
                firstChildGap?: number;
                direction?: Direction;
                directionRule?: DirectionRule;
                updatePosition?: null | ((element: dia.Element, position: dia.Point, opt?: { [key: string]: any }) => void);
                updateVertices?: null | ((link: dia.Link, vertices: Array<dia.Point>, opt?: { [key: string]: any }) => void);
                updateAttributes?: null | ((layoutArea: LayoutArea, root: dia.Element, rootLink: dia.Link, opt: { [key: string]: any }) => void);
                filter?: null | ((children: dia.Element[], parent: dia.Element | null, opt: { [key: string]: any }) => dia.Element[]);
                attributeNames?: AttributeNames;
                symmetrical?: boolean;
            }

            interface ReconnectElementOptions {
                siblingRank?: TreeLayout.SiblingRank,
                direction?: TreeLayout.Direction,
                [key: string]: any;
            }

            class LayoutArea {
                root: dia.Element;
                link: dia.Link | null;
                level: number;
                /**
                 * Normalized sibling rank (0,1,2,3,..)
                 */
                siblingRank: SiblingRank;
                rootOffset: number;
                rootMargin: number;
                // Gaps
                siblingGap: number;
                parentGap: number;
                nextSiblingGap: number;
                prevSiblingGap: number;
                firstChildGap: number;
                // metrics
                x: number;
                y: number;
                dx: number;
                dy: number;
                width: number;
                height: number;
                rootCX: number;
                rootCY: number;
                // references
                parentArea: LayoutArea | null;
                childAreas: LayoutArea[];
                siblings: { [direction in Direction]: LayoutSiblings };
            }

            class LayoutSiblings {
                direction: Direction;
                width: number;
                height: number;
                layoutAreas: LayoutArea[];
                parentArea: LayoutArea;
                siblingGap: number;
            }
        }

        class TreeLayout extends Backbone.Model {

            graph: dia.Graph;

            constructor(opt: TreeLayout.Options);

            options: TreeLayout.Options;

            layout(opt?: { [key: string]: any }): this;

            layoutTree(root: dia.Element, opt?: { [key: string]: any }): this;

            getLayoutBBox(): g.Rect | null;

            updateDirections(branch: dia.Element, rule: TreeLayout.FromToDirections, opt?: dia.Cell.Options): void;

            reconnectElement(child: dia.Element, parent: dia.Element, opt?: TreeLayout.ReconnectElementOptions): boolean;

            changeSiblingRank(el: dia.Element, siblingRank: TreeLayout.SiblingRank, opt?: dia.Cell.Options): void;

            changeDirection(el: dia.Element, direction: TreeLayout.Direction, opt?: dia.Cell.Options): void;

            getAttributeName(attribute: string): string;

            getAttribute(el: dia.Element, attribute: string): any;

            removeElement(el: dia.Element, opt?: { layout?: boolean, [key: string]: any }): void;

            static directionRules: TreeLayout.DirectionRules
        }
    }

    export namespace shapes {

        export namespace measurement {

            namespace Distance {

                interface LabelFormatOptions {
                    fixed?: number;
                    unit?: string;
                }

                interface LabelPositionOptions {
                    offset?: number;
                    ratio?: number;
                }

                interface DistanceLabelAttributes extends attributes.SVGTextAttributes {
                    labelText: LabelFormatOptions,
                    labelDistance: LabelPositionOptions
                }

                interface DistanceAnchorLineAttributes extends attributes.SVGPathAttributes {
                    dAnchor?: dia.LinkEnd;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    line?: attributes.SVGPathAttributes;
                    wrapper?: attributes.SVGPathAttributes;
                    anchorLines?: DistanceAnchorLineAttributes;
                    sourceAnchorLine?: DistanceAnchorLineAttributes;
                    targetAnchorLine?: DistanceAnchorLineAttributes;
                    distanceLabel?: DistanceLabelAttributes;
                }

                interface Attributes<T> extends dia.Link.GenericAttributes<T> {
                }
            }

            class Distance extends dia.Link {

                constructor(
                    attributes?: Distance.Attributes<Distance.Selectors>,
                    opt?: dia.Graph.Options
                )

                protected getDistanceText(view: dia.LinkView, opt?: Distance.LabelFormatOptions): string;
            }

            namespace Angle {

                enum AngleStarts {
                    self = 'self',
                    source = 'source',
                    target = 'target'
                }

                enum AngleDirections {
                    clockwise = 'clockwise',
                    anticlockwise = 'anticlockwise',
                    small = 'small',
                    large = 'large'
                }

                interface AngleAttributes extends attributes.SVGPathAttributes {
                    angle?: number;
                    angleD?: dia.LinkEnd;
                    angleRadius?: number;
                    anglePie?: boolean;
                    angleStart?: AngleStarts;
                    angleDirection?: AngleDirections;
                }

                interface AngleLabelAttributes extends attributes.SVGTextAttributes {
                    angleText?: dia.LinkEnd;
                    angleTextPosition?: dia.LinkEnd;
                    angleTextDecimalPoints?: number,
                    angleTextDistance?: number;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    line?: attributes.SVGPathAttributes;
                    wrapper?: attributes.SVGPathAttributes;
                    angles?: AngleAttributes;
                    sourceAngle?: AngleAttributes;
                    targetAngle?: AngleAttributes;
                    angleLabels?: AngleLabelAttributes;
                    sourceLabel?: AngleLabelAttributes;
                    targetLabel?: AngleLabelAttributes;
                }

                interface GetAngleTextOptions {
                    angle?: number;
                    decimalPoints?: number;
                }

                interface Attributes<T> extends dia.Link.GenericAttributes<T> {

                }
            }

            class Angle extends dia.Link {

                constructor(
                    attributes?: Angle.Attributes<Angle.Selectors>,
                    opt?: dia.Graph.Options
                )

                protected getAngleText(opt?: Angle.GetAngleTextOptions): string;
            }

        }

        export namespace bpmn2 {

            type borderType = 'single' | 'double' | 'thick';
            type borderStyle = 'solid' | 'dashed' | 'dotted';
            type IconSet = Record<string, string>;

            enum IconsFlows {
                row = 'row',
                column = 'column'
            }

            enum IconsOrigins {
                topLeft = 'left-top',
                bottomLeft = 'left-bottom',
                topRight = 'right-top',
                bottomRight = 'right-bottom',
                topMiddle = 'top',
                bottomMiddle = 'bottom',
                rightMiddle = 'right',
                leftMiddle = 'left',
                center = 'center'
            }

            interface MarkersAttributes extends attributes.SVGAttributes {
                iconSize?: number;
                iconColor?: string;
                iconTypes?: string[];
                iconsOrigin?: IconsOrigins;
                iconsFlow?: IconsFlows;
            }

            interface BorderAttributes extends attributes.SVGPathAttributes {
                fillRule?: string;
                borderType?: borderType;
                borderStyle?: borderStyle;
                borderRadius?: number;
            }

            interface IconAttributes extends attributes.SVGImageAttributes {
                iconColor?: string;
                iconType?: string;
            }

            namespace Activity {

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    background?: attributes.SVGRectAttributes;
                    border?: BorderAttributes;
                    icon?: IconAttributes;
                    label?: attributes.SVGTextAttributes;
                    markers?: MarkersAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Activity extends dia.Element {
                constructor(
                    attributes?: Activity.Attributes<Activity.Selectors>,
                    opt?: dia.Graph.Options
                )

                static ACTIVITY_TYPE_ICONS: IconSet;
                static ACTIVITY_MARKER_ICONS: IconSet;
            }

            namespace Pool {
                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: attributes.SVGRectAttributes;
                    laneGroups?: attributes.SVGAttributes;
                    laneHeaders?: attributes.SVGAttributes;
                    laneLabels?: attributes.SVGAttributes;
                    lanes?: attributes.SVGAttributes;
                    milestoneGroups?: attributes.SVGAttributes;
                    milestoneHeaders?: attributes.SVGAttributes;
                    milestoneLabels?: attributes.SVGAttributes;
                    milestoneLines?: attributes.SVGAttributes;
                    [key: string]: any;
                }


                interface Sublane {
                    label?: string;
                    size?: number;
                    id?: string;
                    headerSize?: number;
                    sublanes?: Sublane[];
                }

                interface Milestone {
                    label?: string;
                    size?: number;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> {
                    lanes?: Sublane[];
                    milestones?: Milestone[];
                    headerSize?: number;
                    milestonesSize?: number;
                    padding?: dia.Padding;
                }
            }

            class Pool extends dia.Element {

                constructor(
                    attributes?: Pool.Attributes<Pool.Selectors>,
                    opt?: dia.Graph.Options
                );

                protected metrics: any;

                getLaneBBox(laneGroupId: string): g.Rect | null;
                getMilestoneBBox(milestoneGroupId: string): g.Rect | null;
                getLanesFromPoint(point: dia.Point): string[];
                getMilestoneFromPoint(point: dia.Point): string | null;
                getMinimalSize(): dia.Size;
                getLanePath(laneGroupId: string): string[];
            }

            namespace HeaderedPool {

                interface Selectors extends Pool.Selectors {
                    header?: attributes.SVGRectAttributes;
                    headerLabel?: attributes.SVGTextAttributes;
                }
            }

            class HeaderedPool extends Pool {
                constructor(
                    attributes?: Pool.Attributes<HeaderedPool.Selectors>,
                    opt?: dia.Graph.Options
                )
            }

            class PoolView extends dia.ElementView { }

            let HeaderedPoolView: PoolView;

            namespace Gateway {

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: attributes.SVGPolygonAttributes;
                    icon?: IconAttributes;
                    label?: attributes.SVGTextAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Gateway extends dia.Element {
                constructor(
                    attributes?: Gateway.Attributes<Gateway.Selectors>,
                    opt?: dia.Graph.Options
                )

                static GATEWAY_ICONS: IconSet;
            }

            namespace Conversation {

                interface BorderAttributes extends attributes.SVGPathAttributes {
                    fillRule?: string;
                    borderType?: borderType;
                    borderStyle?: borderStyle;
                    borderRadius?: number;
                }

                interface IconAttributes extends attributes.SVGImageAttributes {
                    iconColor?: string;
                    iconType?: string;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: attributes.SVGPolygonAttributes;
                    label?: attributes.SVGTextAttributes;
                    markers?: MarkersAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }

            }

            class Conversation extends dia.Element {
                constructor(
                    attributes?: Conversation.Attributes<Conversation.Selectors>,
                    opt?: dia.Graph.Options
                )

                static CONVERSATION_MARKER_ICONS: IconSet;
            }

            interface ConversationLinkSelectors {
                root?: attributes.SVGAttributes;
                line?: attributes.SVGPathAttributes;
                outline?: attributes.SVGPathAttributes;
                wrapper?: attributes.SVGPathAttributes;
            }

            class ConversationLink extends dia.Link {
                constructor(
                    attributes?: dia.Link.GenericAttributes<ConversationLinkSelectors>,
                    opt?: dia.Graph.Options
                )
            }

            namespace Annotation {

                interface BorderAttributes extends attributes.SVGPathAttributes {
                    annotationD?: { size: number, side?: 'left' | 'top' | 'right' | 'bottom' };
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: attributes.SVGPolygonAttributes;
                    border?: BorderAttributes;
                    label?: attributes.SVGTextAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Annotation extends dia.Element {
                constructor(
                    attributes?: Conversation.Attributes<Annotation.Selectors>,
                    opt?: dia.Graph.Options
                )
            }

            interface AnnotationLinkSelectors {
                root?: attributes.SVGAttributes;
                line?: attributes.SVGPathAttributes;
                wrapper?: attributes.SVGPathAttributes;
            }

            class AnnotationLink extends dia.Link {
                constructor(
                    attributes?: dia.Link.GenericAttributes<AnnotationLinkSelectors>,
                    opt?: dia.Graph.Options
                )
            }

            namespace DataObject {

                interface BodyAttributes extends attributes.SVGPathAttributes {
                    objectD?: number;
                }

                interface DataTypeIconAttributes extends attributes.SVGImageAttributes {
                    iconColor?: string;
                    iconType?: string;
                }

                interface CollectionIconAttributes extends attributes.SVGImageAttributes {
                    iconColor?: string;
                    collection?: string;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: BodyAttributes;
                    label?: attributes.SVGTextAttributes;
                    dataTypeIcon?: DataTypeIconAttributes;
                    collectionIcon?: DataTypeIconAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class DataObject extends dia.Element {
                constructor(
                    attributes?: DataObject.Attributes<DataObject.Selectors>,
                    opt?: dia.Graph.Options
                )

                static DATA_OBJECT_TYPE_ICONS: IconSet;
                static DATA_OBJECT_COLLECTION_ICONS: IconSet;
            }

            namespace DataAssociation {

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    line?: attributes.SVGPathAttributes;
                    wrapper?: attributes.SVGPathAttributes;
                }
            }

            class DataAssociation extends dia.Link {
                constructor(
                    attributes?: dia.Link.GenericAttributes<DataAssociation.Selectors>,
                    opt?: dia.Graph.Options
                )
            }

            namespace DataStore {

                interface BodyAttributes extends attributes.SVGPathAttributes {
                    lateralArea: number;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: BodyAttributes;
                    top?: attributes.SVGAttributes;
                    label?: attributes.SVGTextAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class DataStore extends dia.Element {
                constructor(
                    attributes?: DataStore.Attributes<DataStore.Selectors>,
                    opt?: dia.Graph.Options
                )

                topRy(t: number, opt: any): this;
            }

            namespace Event {

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    background?: attributes.SVGEllipseAttributes;
                    border?: BorderAttributes;
                    icon?: IconAttributes;
                    label?: attributes.SVGTextAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Event extends dia.Element {
                constructor(
                    attributes?: Event.Attributes<Event.Selectors>,
                    opt?: dia.Graph.Options
                )

                static EVENT_ICONS: IconSet;
            }

            namespace Flow {

                enum Types {
                    sequence = 'sequence',
                    default = 'default',
                    conditional = 'conditional',
                    message = 'message'
                }

                interface LineAttributes extends attributes.SVGPathAttributes {
                    flowType?: Types;
                    markerFill?: string;
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    line?: LineAttributes;
                    wrapper?: attributes.SVGPathAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Flow extends dia.Link {
                constructor(
                    attributes?: Flow.Attributes<Flow.Selectors>,
                    opt?: dia.Graph.Options
                )

                static FLOW_TYPES: typeof Flow.Types;
            }

            namespace Group {

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    body?: attributes.SVGRectAttributes;
                    wrapper?: attributes.SVGRectAttributes;
                    label?: attributes.SVGTextAttributes;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> { }
            }

            class Group extends dia.Element {
                constructor(
                    attributes?: Group.Attributes<Group.Selectors>,
                    opt?: dia.Graph.Options
                )
            }
        }

        export namespace standard {

            namespace Record {

                type ItemId = string;

                type GroupId = number;

                type ItemSide = 'left' | 'middle' | 'right';

                interface Item {
                    id?: ItemId;
                    label?: string;
                    icon?: string;
                    collapsed?: boolean;
                    height?: number;
                    span?: number;
                    highlighted?: boolean;
                    group?: string | string[];
                    items?: Item[];
                }

                interface ItemIcon {
                    width?: number;
                    height?: number;
                    padding?: number;
                }

                interface ItemTextAttribute extends attributes.SVGAttributeTextWrap {
                    textWrap?: boolean;
                }

                interface ItemLabelAttributes extends attributes.SVGTextAttributes {
                    itemText?: ItemTextAttribute;
                    itemHighlight?: attributes.NativeSVGAttributes
                }

                interface ItemBodyAttributes extends attributes.SVGRectAttributes {
                    itemHighlight?: attributes.NativeSVGAttributes
                }

                interface Selectors {
                    root?: attributes.SVGAttributes;
                    wrapper?: attributes.SVGAttributes;
                    bodiesGroups?: attributes.SVGAttributes;
                    labelsGroups?: attributes.SVGAttributes;
                    buttonsGroups?: attributes.SVGAttributes;
                    forksGroups?: attributes.SVGAttributes;
                    iconsGroups?: attributes.SVGAttributes;
                    // Bodies of all items
                    itemBodies?: ItemBodyAttributes;
                    // Bodies of a specific column
                    itemBodies_0?: ItemBodyAttributes;
                    itemBodies_1?: ItemBodyAttributes;
                    itemBodies_2?: ItemBodyAttributes;
                    // Labels of all items
                    itemLabels?: ItemLabelAttributes;
                    /* Labels of a specific column */
                    itemLabels_0?: ItemLabelAttributes;
                    itemLabels_1?: ItemLabelAttributes;
                    itemLabels_2?: ItemLabelAttributes;
                    // Specific Item
                    // * itemBody_[itemId]?: ItemBodyAttributes;
                    // * itemLabel_[itemId]?: ItemLabelAttributes;
                    // Specific Column
                    // * itemBodies_[n]?: ItemBodyAttributes;
                    // * itemLabels_[n]?: ItemLabelAttributes;
                    // * group_[n]?: attributes.SVGAttributes;
                    // * bodiesGroup_[n]?: attributes.SVGGAttributes;
                    // * labelsGroup_[n]?: attributes.SVGAttributes;
                    // * buttonsGroup_[n]?: attributes.SVGAttributes;
                    // * forksGroup_[n]?: attributes.SVGAttributes;
                    // * iconsGroup_[n]?: attributes.SVGAttributes;
                    [key: string]: any;
                }

                interface Attributes<T> extends dia.Element.GenericAttributes<T> {
                    items?: Item[][];
                    itemHeight?: number;
                    itemOffset?: number;
                    itemMinLabelWidth?: number;
                    itemButtonSize?: number;
                    itemIcon?: ItemIcon;
                    itemOverflow?: boolean;
                    itemBelowViewSelector?: string;
                    itemAboveViewSelector?: string;
                    scrollTop?: number | null;
                    padding?: dia.Padding;
                }
            }

            class Record extends dia.Element {
                constructor(
                    attributes?: Record.Attributes<Record.Selectors>,
                    opt?: dia.Graph.Options
                )

                protected metrics: any;

                item(itemId: Record.ItemId): Record.Item | null;
                item(itemId: Record.ItemId, value: Record.Item, opt?: dia.Cell.Options): this;

                toggleItemCollapse(itemId: Record.ItemId, opt?: dia.Cell.Options): this;

                toggleItemHighlight(itemId: Record.ItemId, opt?: dia.Cell.Options): this;

                isItemVisible(itemId: Record.ItemId): boolean | null;

                isItemCollapsed(itemId: Record.ItemId): boolean | null;

                isItemHighlighted(itemId: Record.ItemId): boolean | null;

                getPadding(): dia.SidesJSON;

                getMinimalSize(): dia.Size;

                getItemPathArray(itemId: Record.ItemId): string[] | null;

                getItemParentId(itemId: Record.ItemId): Record.ItemId | null;

                getItemGroupIndex(itemId: Record.ItemId): number | null;

                getItemSide(itemId: Record.ItemId): Record.ItemSide | null;

                getItemBBox(itemId: Record.ItemId): g.Rect | null;

                removeItem(itemId: Record.ItemId): this;

                addNextSibling(siblingId: Record.ItemId, item: Record.Item, opt?: dia.Cell.Options): this;

                addPrevSibling(siblingId: Record.ItemId, item: Record.Item, opt?: dia.Cell.Options): this;

                addItemAtIndex(id: Record.ItemId | Record.GroupId, index: number, item: Record.Item, opt?: dia.Cell.Options): this;

                removeInvalidLinks(): dia.Link[];

                isLinkInvalid(link: dia.Link): boolean;

                getItemViewSign(itemId: Record.ItemId): number;

                isItemInView(itemId: Record.ItemId): boolean;

                isEveryItemInView(): boolean;

                getScrollTop(): number | null;

                setScrollTop(scrollTop: number | null, opt?: dia.Cell.Options): void;

                protected clampScrollTop(scrollTop: number): number;

                protected getSelector(selector: string, id: Record.ItemId | Record.GroupId): string;

                protected getGroupSelector(selector: string, ...ids: Array<Record.ItemId | Record.GroupId>): string[];

                protected getItemLabelMarkup(item: Record.Item, x: number, y: number, groupId: Record.GroupId): dia.MarkupNodeJSON;

                protected getItemBodyMarkup(item: Record.Item, x: number, y: number, groupId: Record.GroupId, overflow: number): dia.MarkupNodeJSON;

                protected getIconMarkup(item: Record.Item, x: number, y: number, groupId: Record.GroupId): dia.MarkupNodeJSON;

                protected getButtonMarkup(item: Record.Item, x: number, y: number, groupId: Record.GroupId): dia.MarkupNodeJSON;

                protected getButtonPathData(x: number, y: number, r: number, collapsed: boolean): string;

                protected getForkMarkup(itemId: Record.ItemId): dia.MarkupNodeJSON;

                protected getForkPathData(itemId: Record.ItemId): string;

                protected getItemCache(itemId: Record.ItemId): any;

                protected getItemCacheAttribute(itemId: Record.ItemId, attribute: string): any;
            }

            namespace BorderedRecord {

                interface Selectors extends Record.Selectors {
                    body?: attributes.SVGRectAttributes;
                }
            }

            class BorderedRecord extends Record {
                constructor(
                    attributes?: Record.Attributes<BorderedRecord.Selectors>,
                    opt?: dia.Graph.Options
                )
            }

            namespace HeaderedRecord {

                interface Selectors extends Record.Selectors {
                    body?: attributes.SVGRectAttributes;
                    header?: attributes.SVGRectAttributes;
                    headerLabel?: attributes.SVGTextAttributes;
                }
            }

            class HeaderedRecord extends Record {
                constructor(
                    attributes?: Record.Attributes<HeaderedRecord.Selectors>,
                    opt?: dia.Graph.Options
                )
            }

            class RecordView extends dia.ElementView {

                protected onItemButtonClick(evt: JQuery): void;
            }

            let HeaderedRecordView: RecordView;
            let BorderedRecordView: RecordView;
        }

        export namespace chart {

            namespace Plot {

                interface Series {
                    name: string;
                    label?: string;
                    data?: dia.Point[];
                    interpolate?: 'linear' | 'bezier' | 'step' | 'stepBefore' | 'stepAfter';
                    bars?: boolean | {
                        align?: 'middle' | 'left' | 'right';
                        barWidth: number;
                        'top-rx': number;
                        'top-ry': number;
                    };
                    showLegend?: boolean | ((serie: Plot.Series, stats: any) => boolean);
                    legendLabelLineHeight?: number;
                    hideFillBoundaries?: boolean;
                    showRightFillBoundary?: boolean;
                    fillPadding?: {
                        left?: number;
                        right?: number;
                        bottom?: number;
                    }
                }

                interface Marking {
                    name: string;
                    label?: string;
                    start?: dia.Point;
                    end?: dia.Point;
                    attrs?: { [key: string]: any };
                }

                interface Axis {
                    min?: number;
                    max?: number;
                    tickFormat?: string | ((tickValue: number) => string);
                    tickSuffix?: string | ((tickValue: number) => string);
                    ticks?: number;
                    tickStep?: number;
                }

                interface Attributes extends dia.Element.Attributes {
                    series?: Series[],
                    axis?: {
                        'x-axis'?: Axis,
                        'y-axis'?: Axis
                    },
                    markings?: Marking[];
                    padding?: dia.Padding;
                    attrs?: { [key: string]: any };
                }
            }

            namespace Matrix {

                interface Selectors extends shapes.SVGRectSelector, shapes.SVGTextSelector, shapes.SVGPathSelector {
                    '.background'?: attributes.SVGAttributes;
                    '.cells'?: attributes.SVGAttributes;
                    '.foreground'?: attributes.SVGAttributes;
                    '.labels'?: attributes.SVGAttributes;
                    '.rows'?: attributes.SVGAttributes;
                    '.columns'?: attributes.SVGAttributes;
                    '.cell'?: attributes.SVGRectAttributes;
                    '.label'?: attributes.SVGTextAttributes;
                    '.grid-line'?: attributes.SVGPathAttributes;
                }

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    cells: Array<Array<attributes.SVGRectAttributes>>,
                    labels?: {
                        rows?: Array<attributes.SVGTextAttributes>
                        columns?: Array<attributes.SVGTextAttributes>
                    }
                }
            }

            namespace Pie {

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    series: Serie[];
                    pieHole?: number;
                    serieDefaults?: Serie;
                    sliceDefaults?: Slice;
                }

                interface Selectors extends shapes.SVGRectSelector, shapes.SVGTextSelector, shapes.SVGPathSelector, shapes.SVGCircleSelector {

                    '.background': attributes.SVGAttributes;
                    '.data': attributes.SVGAttributes;
                    '.foreground': attributes.SVGAttributes;
                    '.legend': attributes.SVGAttributes;
                    '.legend-items': attributes.SVGAttributes;
                    '.caption': attributes.SVGTextAttributes;
                    '.subcaption': attributes.SVGTextAttributes;

                    '.slice': attributes.SVGAttributes;
                    '.slice-fill': attributes.SVGPathAttributes;
                    '.slice-border': attributes.SVGPathAttributes;
                    '.slice-inner-label': attributes.SVGTextAttributes;
                    '.legend-serie': attributes.SVGAttributes;
                    '.legend-slice': attributes.SVGAttributes;
                }

                interface Serie {
                    data?: Slice[];
                    name?: string;
                    label?: string;
                    startAngle?: number;
                    degree?: number;
                    showLegend?: boolean;
                    labelLineHeight?: number;
                }

                interface Slice {
                    value: number;
                    label?: string;
                    fill?: string;
                    innerLabel?: string;
                    innerLabelMargin?: number;
                    legendLabel?: string;
                    legendLabelLineHeight?: number;
                    legendLabelMargin?: number;
                    offset?: number;
                    onClickEffect?: { type: 'enlarge' | 'offset', offset?: number, scale?: number };
                    onHoverEffect?: { type: 'enlarge' | 'offset', offset?: number, scale?: number };
                }
            }

            namespace Knob {

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    value: number;
                    pieHole?: number;
                    min?: number;
                    max?: number;
                    fill?: string;
                    sliceDefaults: Pie.Slice;
                    serieDefaults: Pie.Serie;
                }

                interface Selectors extends Pie.Attributes { }
            }

            class Plot extends shapes.basic.Generic {

                tickMarkup: string;
                pointMarkup: string;
                barMarkup: string;
                markingMarkup: string;
                serieMarkup: string;
                legendItemMarkup: string;

                constructor(
                    attributes?: Plot.Attributes,
                    opt?: { [key: string]: any }
                );

                legendPosition(): void;

                addPoint(p: dia.Point, serieName: string, opt?: { [key: string]: any }): void;

                lastPoint(serieName: string): dia.Point;

                firstPoint(serieName: string): dia.Point;
            }

            class Matrix extends shapes.basic.Generic {

                cellMarkup: string;
                labelMarkup: string;
                gridLineMarkup: string;

                constructor(
                    attributes?: Matrix.Attributes,
                    opt?: { [key: string]: any }
                );
            }

            class Pie extends shapes.basic.Generic {

                sliceMarkup: string;
                sliceFillMarkup: string;
                sliceBorderMarkup: string;
                sliceInnerLabelMarkup: string;
                legendSerieMarkup: string;
                legendSliceMarkup: string;

                constructor(attributes?: Pie.Attributes, opt?: { [key: string]: any })

                addSlice(slice: Pie.Slice, serieIndex: number, opt?: { [key: string]: any }): void;

                editSlice(slice: Pie.Slice, sliceIndex: number, serieIndex: number, opt?: { [key: string]: any }): void;
            }

            class Knob extends shapes.chart.Pie {

                constructor(attributes?: Knob.Attributes, opt?: { [key: string]: any });
            }
        }

        export namespace measurement {

            interface LinkSelectors {
                root?: attributes.SVGAttributes;
                line?: attributes.SVGPathAttributes;
                wrapper?: attributes.SVGPathAttributes;
                anchorLines?: attributes.SVGPathAttributes;
                sourceAnchorLine?: attributes.SVGPathAttributes;
                targetAnchorLine?: attributes.SVGPathAttributes;
                distanceLabel?: attributes.SVGTextAttributes;
            }

            class Link extends dia.Link {
                constructor(
                    attributes?: dia.Link.GenericAttributes<LinkSelectors>,
                    opt?: dia.Graph.Options
                )
                protected getDistanceText(view: dia.LinkView, opt: { [key: string]: any }): string;
            }
        }

        export namespace bpmn {

            export let icons: {
                none: string,
                message: string,
                plus: string,
                cross: string,
                user: string,
                circle: string,
                service: string,
            };

            namespace Activity {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGRectSelector, shapes.SVGPathSelector, shapes.SVGImageSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.inner'?: attributes.SVGRectAttributes,
                    '.outer'?: attributes.SVGRectAttributes,
                    '.content'?: attributes.SVGTextAttributes,
                    '.sub-process'?: attributes.SVGPathAttributes,
                    '.icon'?: attributes.SVGImageAttributes
                }

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    activityType?: string;
                    content?: string;
                    icon?: string;
                    subProcess?: boolean;
                }
            }

            class Activity extends shapes.basic.TextBlock {

                icon: string;
                subProcess: boolean;

                constructor(
                    attributes?: Activity.Attributes,
                    opt?: { [key: string]: any }
                );

                protected _onIconChange(cell: dia.Cell, icon: string): void;

                protected _onSubProcessChange(cell: dia.Cell, subProcess: boolean): void;

                protected onActivityTypeChange(cell: dia.Cell, type: string): void;

                protected onSubProcessChange(cell: dia.Cell, subProcess: boolean): void;
            }

            namespace Annotation {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGRectSelector, shapes.SVGPathSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.content'?: attributes.SVGTextAttributes,
                    '.stroke'?: attributes.SVGPathAttributes
                }

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    wingLength?: number;
                    content?: string;
                }
            }

            class Annotation extends shapes.basic.TextBlock {

                constructor(
                    attributes?: Annotation.Attributes,
                    opt?: { [key: string]: any }
                );

                protected onSizeChange(cell: dia.Cell, size: number): void;

                getStrokePathData(width: number, height: number, wingLength: number): string;
            }

            namespace Gateway {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGImageSelector, shapes.SVGPolygonSelector {
                    '.body'?: attributes.SVGPolygonAttributes,
                    '.label'?: attributes.SVGTextAttributes
                }

                interface Attributes extends dia.Element.GenericAttributes<Gateway.Selectors> {
                    icon?: string;
                }
            }

            class Gateway extends dia.Element {

                icon: string;
                constructor(
                    attributes?: Gateway.Attributes,
                    opt?: { [key: string]: any }
                );

                protected _onIconChange(cell: dia.Cell, icon: string): void;
            }

            namespace Event {
                interface Selectors extends shapes.SVGCircleSelector, shapes.SVGImageSelector, shapes.SVGTextSelector {
                    '.body'?: attributes.SVGCircleAttributes,
                    '.outer'?: attributes.SVGCircleAttributes,
                    '.inner'?: attributes.SVGCircleAttributes,
                    '.label'?: attributes.SVGTextAttributes,
                }

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    eventType?: string;
                    icon?: string;
                }
            }

            class Event extends dia.Element {

                icon: string;
                constructor(
                    attributes?: Event.Attributes,
                    opt?: { [key: string]: any }
                );

                protected _onIconChange(cell: dia.Cell, icon: string): void;

                protected onEventTypeChange(cell: dia.Cell, type: string): void;
            }

            namespace Pool {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGRectSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.header'?: attributes.SVGRectAttributes,
                    '.label'?: attributes.SVGTextAttributes,
                    '.blackbox-label'?: attributes.SVGTextAttributes,
                    '.blackbox-wrap'?: attributes.SVGAttributes,
                    '.lanes'?: attributes.SVGAttributes
                }

                interface SubLane {
                    label: string;
                    name?: string;
                    ratio?: number;
                    headerWidth?: number;
                    sublanes?: SubLane[];
                }

                interface Attributes extends dia.Element.GenericAttributes<Pool.Selectors> {
                    lanes?: {
                        label?: string,
                        headerWidth?: number,
                        sublanes?: SubLane[]
                    }
                }
            }

            class Pool extends dia.Element {

                constructor(
                    attributes?: Pool.Attributes,
                    opt?: { [key: string]: any }
                );
            }

            namespace Group {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGRectSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.label-rect'?: attributes.SVGRectAttributes,
                    '.label-group'?: attributes.SVGAttributes,
                    '.label-wrap'?: attributes.SVGAttributes,
                    '.label'?: attributes.SVGTextAttributes
                }
            }

            class Group extends dia.Element {

                constructor(
                    attributes?: dia.Element.GenericAttributes<Group.Selectors>,
                    opt?: { [key: string]: any }
                );
            }

            namespace DataObject {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGPolygonSelector {
                    '.body'?: attributes.SVGPolygonAttributes,
                    '.label'?: attributes.SVGTextAttributes
                }
            }

            class DataObject extends dia.Element {

                constructor(
                    attributes?: dia.Element.GenericAttributes<DataObject.Selectors>,
                    opt?: { [key: string]: any }
                );
            }

            namespace Conversation {
                interface Selectors extends shapes.SVGTextSelector, shapes.SVGPolygonSelector, shapes.SVGPathSelector {
                    '.body'?: attributes.SVGPolygonAttributes,
                    '.label'?: attributes.SVGTextAttributes,
                    '.sub-process'?: attributes.SVGPathAttributes,
                }

                interface Attributes extends dia.Element.GenericAttributes<Conversation.Selectors> {
                    conversationType?: string;
                    subProcess?: boolean;
                }
            }

            class Conversation extends dia.Element {

                subProcess: boolean;
                constructor(
                    attributes?: Conversation.Attributes,
                    opt?: { [key: string]: any }
                );

                protected _onSubProcessChange(cell: dia.Cell, subProcess: boolean): void;

                protected onConversationTypeChange(cell: dia.Cell, type: string): void;
            }

            namespace Choreography {

                interface Selectors extends shapes.SVGTextSelector, shapes.SVGRectSelector, shapes.SVGPathSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.content'?: attributes.SVGTextAttributes,
                    '.participant-label'?: attributes.SVGTextAttributes,
                    '.participant-rect'?: attributes.SVGRectAttributes,
                    '.label'?: attributes.SVGTextAttributes,
                    '.sub-process'?: attributes.SVGPathAttributes,
                    '.participants'?: attributes.SVGAttributes

                }

                interface Attributes extends dia.Element.GenericAttributes<Selectors> {
                    participants?: string[];
                    content?: string;
                    initiatingParticipant?: number;
                    subProcess?: boolean;
                }

            }

            class Choreography extends shapes.basic.TextBlock {

                subProcess: boolean;
                constructor(
                    attributes?: Choreography.Attributes,
                    opt?: { [key: string]: any }
                );

                protected _onSubProcessChange(cell: dia.Cell, subProcess: boolean): void;
            }

            class ChoreographyView extends dia.ElementView {

            }

            namespace Message {

                interface Selectors extends shapes.SVGPolygonSelector, shapes.SVGTextSelector {
                    '.body'?: attributes.SVGRectAttributes,
                    '.label'?: attributes.SVGTextAttributes,
                }
            }

            class Message extends dia.Element {

                constructor(
                    attributes?: dia.Element.GenericAttributes<Message.Selectors>,
                    opt?: { [key: string]: any }
                );
            }


            namespace Flow {
                interface Attributes extends dia.Link.Attributes {
                    flowType?: string;
                }
            }

            class Flow extends dia.Link {

                constructor(
                    attributes?: Flow.Attributes,
                    opt?: { [key: string]: any }
                );

                protected onFlowTypeChange(cell: dia.Cell, type: string): void;
            }
        }
    }

    /* Rappid Specific Namespaces */

    export const versionRappid: string;

    export namespace graphUtils {

        interface ConstructTreeNode {
            children?: ConstructTreeNode[]
            [property: string]: any;
        }

        interface ConstructTreeConfig {
            children?: string | ((node: ConstructTreeNode | any) => ConstructTreeNode[] | any);
            makeElement: (node: ConstructTreeNode, parentElement: dia.Element | null) => dia.Element;
            makeLink: (parentElement: dia.Element, childElement: dia.Element) => dia.Link;
        }

        function constructTree(
            parent: ConstructTreeNode | any,
            config: ConstructTreeConfig
        ): dia.Cell[];


        interface ShortestPathOptions {
            directed?: boolean;
            weight?: (id1: string, id2: string) => number;
        }

        function shortestPath(
            graph: dia.Graph,
            source: dia.Element | string | number,
            target: dia.Element | string | number,
            opt?: ShortestPathOptions
        ): Array<string | number>;

        interface AdjacencyList {
            [elementID: string]: dia.Cell.ID[]
        }

        function toAdjacencyList(graph: dia.Graph): AdjacencyList;
    }

    export namespace ui {

        namespace Clipboard {

            interface BaseOptions {
                useLocalStorage?: boolean;
                deep?: boolean;
                [key: string]: any;
            }

            interface Options extends BaseOptions {
                link?: { [key: string]: any };
                origin?: dia.PositionName;
                translate?: { dx: number, dy: number };
                removeCellOptions?: dia.Cell.DisconnectableOptions;
                addCellOptions?: dia.CollectionAddOptions;
            }

            interface CutElementsOptions extends BaseOptions {
                removeCellOptions?: dia.Cell.DisconnectableOptions;
            }

            interface PasteCellsAtPointOptions extends BaseOptions {
                origin?: dia.PositionName;
                link?: { [key: string]: any };
                addCellOptions?: dia.CollectionAddOptions;
            }

            interface PasteCellsOptions extends BaseOptions {
                translate?: { dx: number, dy: number };
                link?: { [key: string]: any };
                addCellOptions?: dia.CollectionAddOptions;
            }
        }

        class Clipboard extends Backbone.Collection<Backbone.Model> {

            constructor(opt?: Clipboard.Options);

            defaults: Clipboard.Options;

            cid: string;

            /**
             * This function returns the elements and links from the original graph that were copied. This is useful for implements
             * the Cut operation where the original cells should be removed from the graph. `selection` contains
             * elements that should be copied to the clipboard. Note that with these elements, also all the associated
             * links are copied. That's why we also need the `graph` parameter, to find these links.
             */
            copyElements(selection: Backbone.Collection<dia.Cell> | Array<dia.Cell>, graph: dia.Graph, opt?: Clipboard.BaseOptions): Array<dia.Cell>;

            /**
             * Same logic as per `copyElements`, but elements are removed from the graph
             */
            cutElements(selection: Backbone.Collection<dia.Cell> | Array<dia.Cell>, graph: dia.Graph, opt?: Clipboard.CutElementsOptions): Array<dia.Cell>;

            /**
             * If `translate` object with `dx` and `dy` properties is passed, the copied elements will be
             * translated by the specified amount. This is useful for e.g. the 'cut' operation where we'd like to have
             * the pasted elements moved by an offset to see they were pasted to the paper.
             *
             * If `useLocalStorage` is `true`, the copied elements will be saved to the localStorage (if present)
             * making it possible to copy-paste elements between browser tabs or sessions.
             *
             * `link` is attributes that will be set all links before they are added to the `graph`.
             * This is useful for e.g. setting `z: -1` for links in order to always put them to the bottom of the paper.
             *
             * `addCellOptions` options for the `graph.addCells` call.
             */
            pasteCells(graph: dia.Graph, opt?: Clipboard.PasteCellsOptions): Array<dia.Cell>;

            /**
            * `origin` option shows which point of the cells bbox will be used for pasting at the point. The default value is `center`.
            *
            * If `useLocalStorage` is `true`, the copied elements will be saved to the localStorage (if present)
            * making it possible to copy-paste elements between browser tabs or sessions.
            *
            * `link` is attributes that will be set all links before they are added to the `graph`.
            * This is useful for e.g. setting `z: -1` for links in order to always put them to the bottom of the paper.
            *
            * `addCellOptions` options for the `graph.addCells` call.
            */
            pasteCellsAtPoint(graph: dia.Graph, point: dia.Point, opt?: Clipboard.PasteCellsAtPointOptions): Array<dia.Cell>;

            clear(opt?: Clipboard.BaseOptions): void;

            isEmpty(opt?: Clipboard.BaseOptions): boolean;

            protected modifyCell(cell: dia.Cell, opt: Clipboard.Options, z: number): dia.Cell;

            protected updateFromStorage(graph: dia.Graph): dia.Cell;

            protected getJSONFromStorage(): Array<dia.Cell.JSON> | null;

            protected getOriginPoint(cells: Array<dia.Cell>, graph: dia.Graph, origin: dia.PositionName): dia.Point | null;
        }

        class SelectBox extends mvc.View<undefined> {

            constructor(opt?: SelectBox.Options);

            options: SelectBox.Options;

            getSelection(): SelectBox.Selection;

            getSelectionValue(selection?: SelectBox.Selection): any;

            getSelectionIndex(): number;

            select(idx: number, opt?: { [key: string]: any }): void;

            selectByValue(value: any, opt?: { [key: string]: any }): void;

            isOpen(): boolean;

            toggle(): void;

            open(): void;

            close(): void;

            isDisabled(): boolean;

            enable(): void;

            disable(): void;

            render(): this;

            static OptionsView: any;

            protected onToggle(evt: dia.Event): void;

            protected onOutsideClick(evt: dia.Event): void;

            protected onOptionsMouseOut(evt: dia.Event): void;

            protected onOptionSelect(idx: number, opt?: { [key: string]: any }): void;

            protected onOptionHover(option?: { [key: string]: any }, idx?: string): void;

            protected position(): void;

            protected calculateElOverflow(el: HTMLElement, target: any): number;
        }

        namespace SelectBox {

            export interface Selection {
                [key: string]: any;
            }

            type OpenPolicy = 'selected' | 'auto' | 'above' | 'coverAbove' | 'below' | 'coverBelow';

            export interface Options extends mvc.ViewOptions<undefined> {
                icon?: string;
                content?: JQuery | string | HTMLElement;
                options?: Array<Selection>;
                target?: JQuery | string | HTMLElement;
                width?: number;
                openPolicy?: OpenPolicy;
                selectBoxOptionsClass?: string | (() => string);
                placeholder?: string;
                disabled?: boolean;
                selected?: number;
                keyboardNavigation?: boolean
            }
        }

        class ColorPalette extends ui.SelectBox {

            protected position(): void;

            static OptionsView: any;
        }

        namespace RadioGroup {
            export interface RadioGroupOption {
                content: string,
                value: any
            }

            export interface Options extends mvc.ViewOptions<undefined> {
                name?: string;
                options?: RadioGroupOption[];
            }
        }

        class RadioGroup extends mvc.View<undefined> {

            constructor(opt?: RadioGroup.Options);

            getCurrentValue(): any;

            select(index: number): void;

            selectByValue(value: any): void;

            getSelectionIndex(): number;

            setOptions(options: RadioGroup.RadioGroupOption[]): void;

            render(): this;

            protected renderOptions(): void;

            protected renderOption(option: RadioGroup.RadioGroupOption, index: number): void;

            protected onOptiomClick(evt: dia.Event): void;
        }

        namespace ContextToolbar {

            export interface Options extends mvc.ViewOptions<undefined> {
                padding?: number;
                autoClose?: boolean;
                vertical?: boolean;
                type?: string;
                tools?: { [key: string]: any };
                root?: HTMLElement;
                target?: string | JQuery | Element | dia.Point;
                anchor?: dia.PositionName;
                position?: dia.PositionName;
                scale?: number;
            }
        }

        class ContextToolbar extends mvc.View<undefined> {

            constructor(opt?: ContextToolbar.Options);

            options: ContextToolbar.Options;

            render(): this;

            static opened: ContextToolbar | undefined;

            static close(): void;

            // Call whenever the `options.target` changes its position.
            static update(): void;

            protected getRoot(): JQuery;

            protected position(): void;

            protected scale(): void;

            protected onToolPointerdown(evt: dia.Event): void;

            protected onDocumentPointerdown(evt: dia.Event): void;

            protected renderContent(): void;

            protected beforeMount(): void;

            protected delegateAutoCloseEvents(): void;

            protected undelegateAutoCloseEvents(): void;
        }

        namespace Dialog {

            export interface Options extends mvc.ViewOptions<undefined> {
                draggable?: boolean;
                closeButtonContent?: string | HTMLElement | JQuery;
                closeButton?: boolean;
                inlined?: boolean;
                modal?: boolean;
                width?: number;
                title?: string;
                buttons?: Array<{
                    content?: string | HTMLElement | JQuery;
                    position?: string;
                    action?: string;
                }>;
                type?: string;
                content?: string | HTMLElement | JQuery;
            }
        }

        class Dialog extends mvc.View<undefined> {

            constructor(options: Dialog.Options);

            options: Dialog.Options;

            close(): this;

            open(el?: JQuery | HTMLElement): this;

            render(): this;

            protected action(evt: dia.Event): void;

            protected onDragStart(evt: dia.Event): void;

            protected onDrag(evt: dia.Event): void;

            protected onDragEnd(): void;
        }

        namespace FlashMessage {

            export interface Options extends Dialog.Options {
                cascade?: boolean,
                closeAnimation?: {
                    delay?: number,
                    duration?: number,
                    easing?: string,
                    properties?: {
                        opacity?: number
                    }
                },
                openAnimation?: {
                    duration?: number,
                    easing?: string,
                    properties?: {
                        opacity?: number
                    }
                }
            }
        }

        class FlashMessage extends ui.Dialog {

            constructor(options?: FlashMessage.Options)

            options: FlashMessage.Options;

            protected addToCascade(): void;

            protected removeFromCascade(): void;

            protected startCloseAnimation(): void;

            protected startOpenAnimationk(): void;

            static padding: 15;

            static open(content: any, title: any, opt?: { [key: string]: any }): void;

            static close(): void;

            open(): this;

            close(): this;
        }

        namespace FreeTransform {

            type Directions = 'top' | 'bottom' | 'left' | 'right' | 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right';

            type SizeConstraint = number | ((cell: dia.Cell, FreeTransform: FreeTransform) => number);

            export interface Options extends mvc.ViewOptions<undefined> {
                cellView?: dia.CellView;
                cell?: dia.Cell;
                paper?: dia.Paper;
                rotateAngleGrid?: number;
                resizeGrid?: { width: number, height: number };
                preserveAspectRatio?: boolean;
                minWidth?: SizeConstraint;
                minHeight?: SizeConstraint;
                maxWidth?: SizeConstraint;
                maxHeight?: SizeConstraint;
                allowOrthogonalResize?: boolean;
                allowRotation?: boolean;
                clearAll?: boolean;
                clearOnBlankPointerdown?: boolean;
                usePaperScale?: boolean;
                padding?: dia.Padding;
                resizeDirections?: Directions[];
            }
        }

        class FreeTransform extends mvc.View<undefined> {

            constructor(options?: FreeTransform.Options);

            options: FreeTransform.Options;

            update(): void;

            requestUpdate(opt: { [key: string]: any }): void;

            render(): this;

            static clear(paper: dia.Paper): void;

            protected startResizing(evt: dia.Event): void;

            protected toValidResizeDirection(direction: string): any

            protected startRotating(evt: dia.Event): void;

            protected pointermove(evt: dia.Event): void;

            protected pointerup(evt: dia.Event): void;

            protected startOp(el: string | JQuery | HTMLElement): void;

            protected stopOp(): void;

            protected renderHandles(): void;
        }

        namespace Inspector {

            type Operator = (cell: dia.Cell, propertyValue: any, ...conditionValues: any[]) => boolean;

            interface Options extends mvc.ViewOptions<undefined> {
                cellView?: dia.CellView;
                cell?: Backbone.Model;
                live?: boolean;
                validateInput?: (input: any, path: string, type: string, inspector: Inspector) => boolean;
                groups?: any;
                inputs?: any;
                storeGroupsState?: boolean;
                restoreGroupsState?: boolean;
                updateCellOnClose?: boolean;
                renderLabel?: (opt: { [key: string]: any }, path: string, inspector: Inspector) => string | JQuery | HTMLElement;
                renderFieldContent?: (opt: { [key: string]: any }, path: string, value: any, inspector: Inspector) => string | JQuery | HTMLElement;
                focusField?: (opt: { [key: string]: any }, path: string, element: HTMLElement, inspector: Inspector) => void;
                getFieldValue?: (attribute: HTMLElement, type: string) => any;
                multiOpenGroups?: boolean;
                container?: string | Element | JQuery;
                stateKey?: (model: dia.Cell) => string;
                operators?: { [operatorName: string]: Operator };
            }

            interface OptionsSource {
                dependencies?: string[],
                source: (data: OptionsSourceData) => any[] | Promise<any[]>
            }

            interface OptionsSourceData {
                model: Backbone.Model,
                inspector: Inspector,
                initialized: boolean,
                path: string,
                dependencies: { [key: string]: {
                    path: string,
                    changedPath: string,
                    value: any
                }}
            }
        }

        class Inspector extends mvc.View<undefined> {

            constructor(options: Inspector.Options);

            options: Inspector.Options;

            render(): this;

            updateCell(): void;
            updateCell(attrNode: JQuery | HTMLElement, attrPath: string, opt?: { [key: string]: any }): void;

            focusField(path: string): void;

            toggleGroup(name: string): void;

            closeGroup(name: string, opt?: { [key: string]: any }): void;

            openGroup(name: string, opt?: { [key: string]: any }): void;

            closeGroups(): void;

            openGroups(): void;

            storeGroupsState(): void;

            restoreGroupsState(): void;

            refreshSource(path: string): void;

            refreshSources(): void;

            static instance: Inspector | null;

            static create(container: HTMLElement | string | JQuery, opt?: Inspector.Options): ui.Inspector;

            static close(): void;

            protected renderGroup(opt?: { [key: string]: any }): JQuery;

            protected renderOwnFieldContent(opt?: { [key: string]: any }): JQuery;

            protected replaceHTMLEntity(entity: any, code: any): void;

            protected renderObjectProperty(opt?: { [key: string]: any }): JQuery;

            protected renderListItem(opt?: { [key: string]: any }): JQuery;

            protected renderFieldContainer(opt?: { [key: string]: any }): JQuery;

            protected renderTemplate($el: JQuery, options: { [key: string]: any }, path: string, opt?: { [key: string]: any }): void;

            protected addListItem(evt: dia.Event): void;

            protected deleteListItem(evt: dia.Event): void;

            protected onChangeInput(evt: dia.Event): void;

            protected processInput($input: JQuery, opt: { [key: string]: any }): void;

            protected onCellChange(eventName: string, cell: dia.Cell, change: any, opt: { [key: string]: any }): void;

            protected pointerdown(evt: dia.Event): void;

            protected pointerup(): void;

            protected pointerfocusin(evt: dia.Event): void;

            protected pointerfocusout(evt: dia.Event): void;

            protected onGroupLabelClick(evt: dia.Event): void;

            protected renderFieldContent(options: { [key: string]: any }, path: string, value: any): HTMLElement;

            protected onContentEditableBlur(evt: dia.Event): void;
        }

        namespace PaperScroller {

            type ScrollWhileDraggingOptions = {
                interval?: number;
                padding?: dia.Padding;
                scrollingFunction?: (distance: number, evt: dia.Event) => number;
            };

            interface ZoomOptions {
                absolute?: boolean;
                grid?: number;
                max?: number;
                min?: number;
                ox?: number;
                oy?: number;
            }

            interface InertiaOptions {
                friction?: number;
            }

            export interface Options extends mvc.ViewOptions<undefined> {
                paper: dia.Paper;
                padding?: dia.Padding | ((paperScroller: PaperScroller) => dia.Padding);
                minVisiblePaperSize?: number;
                autoResizePaper?: boolean;
                baseWidth?: number;
                baseHeight?: number;
                contentOptions?: dia.Paper.FitToContentOptions | ((paperScroller: PaperScroller) => dia.Paper.FitToContentOptions);
                cursor?: string;
                scrollWhileDragging?: boolean | ScrollWhileDraggingOptions;
                inertia?: boolean | InertiaOptions;
                borderless?: boolean;
            }

            interface ScrollOptions {
                animation?: boolean | JQuery.EffectsOptions<HTMLElement>;
                [key: string]: any;
            }
        }

        class PaperScroller extends mvc.View<undefined> {

            transitionClassName: string;

            transitionEventName: string;

            constructor(opt?: PaperScroller.Options);

            options: PaperScroller.Options;

            lock(): this;

            unlock(): this;

            render(): this;

            setCursor(cursor: string): this;

            clientToLocalPoint(x: number, y: number): g.Point;

            localToBackgroundPoint(x: number, y: number): g.Point;

            center(opt?: { [key: string]: any }): this;
            center(x: number, y?: number, opt?: { [key: string]: any }): this;

            centerContent(opt?: { [key: string]: any }): this;

            centerElement(element: dia.Element, opt?: { [key: string]: any }): this;

            positionContent(positionName: string, opt?: { [key: string]: any }): this;

            positionElement(element: dia.Element, positionName: string, opt?: { [key: string]: any }): this;

            positionRect(rect: g.Rect, positionName: string, opt?: { [key: string]: any }): this;

            positionPoint(point: g.Point, x: number | string, y: number | string, opt?: { [key: string]: any }): this;

            scroll(x: number, y?: number, opt?: PaperScroller.ScrollOptions): void;

            scrollToContent(opt?: PaperScroller.ScrollOptions): void;

            scrollToElement(element: dia.Element, opt?: PaperScroller.ScrollOptions): void;

            zoom(): number;
            zoom(value: number, opt?: PaperScroller.ZoomOptions): this;

            zoomToRect(rect: dia.BBox, opt?: dia.Paper.ScaleContentOptions): this;

            zoomToFit(opt?: dia.Paper.ScaleContentOptions): this;

            transitionToPoint(x: number, y: number, opt?: { [key: string]: any }): this;

            removeTransition(): this;

            transitionToRect(rect: dia.BBox, opt?: {
                maxScale?: number;
                minScale?: number;
                scaleGrid?: number;
                visibility?: number;
                center?: dia.Point;
                [key: string]: any;
            }): this;

            startPanning(evt: dia.Event): void;

            stopPanning(evt: dia.Event): void;

            getClientSize(): dia.Size;

            getVisibleArea(): g.Rect;

            isElementVisible(element: dia.Element, opt?: { [key: string]: any }): boolean;

            isPointVisible(point: dia.Point): boolean;

            scrollWhileDragging(evt: dia.Event, x: number, y: number, opt?: PaperScroller.ScrollWhileDraggingOptions): void;

            stopScrollWhileDragging(evt: dia.Event): void;

            adjustPaper(): this;

            getPadding(): dia.PaddingJSON;

            addPadding(): this;

            computeRequiredPadding(): dia.PaddingJSON;

            storeCenter(): void;
            storeCenter(x: number, y: number): void;

            restoreCenter(): void;

            getCenter(): g.Point;

            computeCenter(): g.Point;

            protected onBackgroundEvent(evt: dia.Event): void;

            protected onScroll(evt: dia.Event): void;

            protected onResize(): void;

            protected onScale(sx: number, sy: number, ox: number, oy: number): void;

            protected beforePaperManipulation(): void;

            protected afterPaperManipulation(): void;

            protected isRTLDirection(): boolean;

            protected getLTRScrollLeft(): number;

            protected getScrollLeftFromLTR(scrollLeftLTR: number): number;
        }

        namespace Lightbox {

            export type Easing = string;

            export interface Options extends Dialog.Options {
                image: string;
                downloadable?: boolean;
                fileName?: string;
                closeAnimation?: {
                    delay?: number;
                    duration?: number;
                    easing?: Easing;
                    properties?: {
                        opacity?: number
                    }
                };
                top?: number;
                windowArea?: number;
                openAnimation?: boolean
            }
        }

        class Lightbox extends ui.Dialog {

            constructor(options?: Lightbox.Options);

            options: Lightbox.Options;

            open(): this;

            positionAndScale(): void;

            close(): this;

            startCloseAnimation(): void;

            startOpenAnimation(): void;
        }

        namespace Popup {

            export type ArrowPositionName = 'top' | 'left' | 'bottom' | 'right' |
                'top-left' | 'top-right' | 'bottom-left' | 'bottom-right' | 'none'

            export interface Options extends ContextToolbar.Options {
                target: string | JQuery | Element;
                content?: string | HTMLElement | JQuery | ((el: SVGElement) => void | string | HTMLElement | JQuery);
                arrowPosition?: ArrowPositionName;
            }
        }

        class Popup extends ContextToolbar {

            constructor(options?: Popup.Options);

            options: Popup.Options;

            beforeMount(): void;

            renderContent(): void;
        }

        namespace PathDrawer {

            export interface Options extends mvc.ViewOptions<undefined> {
                target: SVGSVGElement,
                pathAttributes?: attributes.NativeSVGAttributes,
                startPointMarkup?: string,
                snapRadius?: number
            }
        }

        class PathDrawer extends mvc.View<undefined> {

            constructor(options?: PathDrawer.Options);

            options: PathDrawer.Options;

            render(): this;

            remove(): this;

            onStartPointPointerDown(evt: dia.Event): void;

            onPointerDown(evt: dia.Event): void;

            onDoubleClick(evt: dia.Event): void;

            onContextMenu(evt: dia.Event): void;
        }

        namespace PathEditor {

            export interface Options extends mvc.ViewOptions<undefined> {
                pathElement: SVGPathElement,
                anchorPointMarkup?: string,
                controlPointMarkup?: string
            }
        }

        class PathEditor extends mvc.View<undefined> {

            constructor(options?: PathEditor.Options);

            options: PathEditor.Options;

            render(): this;

            remove(): this;

            adjustAnchorPoint(index: number, dx: number, dy: number, evt?: dia.Event, opt?: { dry?: boolean }): void;

            adjustControlPoint(index: number, controlPointIndex: number, dx: number, dy: number, evt?: dia.Event, opt?: { dry?: boolean }): void;

            adjustSegment(index: number, dx: number, dy: number, evt?: dia.Event, opt?: { dry?: boolean }): void;

            getControlPointLockedStates(): boolean[][];

            setControlPointLockedStates(lockedStates: boolean[][]): void;

            startMoving(evt: dia.Event): void;

            move(evt: dia.Event): void;

            stopMoving(evt: dia.Event): void;

            createAnchorPoint(evt: dia.Event): void;

            removeAnchorPoint(evt: dia.Event): void;

            lockControlPoint(evt: dia.Event): void;

            addClosePathSegment(evt: dia.Event): void;

            removeClosePathSegment(evt: dia.Event): void;

            convertSegmentPath(evt: dia.Event): void;

            onAnchorPointPointerDown(evt: dia.Event): void;

            onControlPointPointerDown(evt: dia.Event): void;

            onSegmentPathPointerDown(evt: dia.Event): void;

            onPointerMove(evt: dia.Event): void;

            onPointerUp(evt: dia.Event): void;

            onAnchorPointDoubleClick(evt: dia.Event): void;

            onControlPointDoubleClick(evt: dia.Event): void;

            onSegmentPathDoubleClick(evt: dia.Event): void;
        }

        namespace Navigator {

            type UseContentBBox = boolean | { useModelGeometry?: boolean };

            export interface Options extends mvc.ViewOptions<undefined> {
                paperConstructor?: typeof dia.Paper;
                paperOptions?: dia.Paper.Options;
                paperScroller?: PaperScroller;
                /**
                 * @deprecated use zoom instead
                 */
                zoomOptions?: PaperScroller.ZoomOptions;
                zoom?: boolean | PaperScroller.ZoomOptions;
                width?: number;
                height?: number;
                padding?: number;
                useContentBBox?: UseContentBBox
            }
        }

        class Navigator extends mvc.View<undefined> {

            constructor(options?: Navigator.Options);

            options: Navigator.Options;

            render(): this;

            updateCurrentView(): void;

            updatePaper(): void;

            toggleUseContentBBox(useContentBBox: Navigator.UseContentBBox): void;

            freeze(opt?: dia.Paper.FreezeOptions): void;

            unfreeze(opt?: dia.Paper.UnfreezeOptions): void;
        }

        namespace SelectButtonGroup {

            export interface Options extends mvc.ViewOptions<undefined> {
                options?: Array<{
                    content?: string | HTMLElement | JQuery,
                    value?: any,
                    attrs?: object,
                    selected?: boolean,
                    icon?: string,
                    iconSelected?: string,
                    buttonWidth?: number,
                    buttonHeight?: number,
                    iconWidth?: number,
                    iconHeight?: number,
                }>;
                disabled?: boolean;
                multi?: boolean;
                selected?: number | number[];
                singleDeselect?: boolean;
                noSelectionValue?: any;
                width?: number;
                buttonWidth?: number;
                buttonHeight?: number;
                iconWidth?: number;
                iconHeight?: number;
            }
        }

        class SelectButtonGroup extends mvc.View<undefined> {

            constructor(options?: SelectButtonGroup.Options);

            options: SelectButtonGroup.Options;

            getSelection(): any;

            getSelectionValue(selection?: any): any;

            select(index: number, opt?: { [key: string]: any }): void;

            selectByValue(value: any, opt?: { [key: string]: any }): void;

            deselect(): void;

            isDisabled(): boolean;

            enable(): void;

            disable(): void;

            render(): this;

            protected onSelect(evt: dia.Event): void;

            protected onOptionHover(evt: dia.Event): void;

            protected onMouseOut(evt: dia.Event): void;

            protected pointerdown(evt: dia.Event): void;

            protected pointerup(): void;
        }

        class Widget extends mvc.View<undefined> {

            constructor(opt: mvc.ViewOptions<undefined>, refs?: Array<any>);

            enable(): void;

            disable(): void;

            isDisabled(): boolean;

            protected getReferences(): Array<any>;

            protected getReference(name: string): any;

            static create<T extends Widget>(
                opt: { [key: string]: any } | string,
                refs?: Array<any>,
                widgets?: { [name: string]: Widget }
            ): T;
        }

        namespace widgets {
            interface WidgetMap {
                button: button,
                checkbox: checkbox,
                'input-number': inputNumber,
                'input-text': inputText,
                label: label,
                range: range,
                redo: redo,
                'select-box': selectBox,
                'select-button-group': selectButtonGroup,
                separator: separator,
                textarea: textarea,
                toggle: toggle,
                undo: undo,
                'zoom-in': zoomIn,
                'zoom-out': zoomOut,
                'zoom-slider': zoomSlider,
                'zoom-to-fit': zoomToFit,
                'color-picker': colorPicker,
            }

            class button extends Widget { }
            class checkbox extends Widget { }
            class inputNumber extends Widget { }
            class inputText extends Widget { }
            class label extends Widget { }
            class range extends Widget {
                setValue: (value: number, opt?: { silent: boolean }) => void;
            }
            class redo extends Widget { }
            class selectBox extends Widget {
                selectBox: SelectBox
            }
            class selectButtonGroup extends Widget {
                selectButtonGroup: SelectButtonGroup
            }
            class separator extends Widget { }
            class textarea extends Widget { }
            class toggle extends Widget { }
            class undo extends Widget { }
            class zoomIn extends Widget { }
            class zoomOut extends Widget { }
            class zoomSlider extends Widget { }
            class zoomToFit extends Widget { }
            class colorPicker extends Widget {
                setValue: (value: string, opt?: { silent: boolean }) => void
            }
        }

        namespace Toolbar {

            export interface Options extends mvc.ViewOptions<undefined> {
                tools?: Array<{ [key: string]: any } | string>,
                groups?: {
                    [key: string]: {
                        index?: number,
                        align?: Align
                    }
                }
                references?: any,
                autoToggle?: boolean,
                widgetNamespace?: { [name: string]: Widget }
            }

            enum Align {
                Left = 'left',
                Right = 'right'
            }
        }

        class Toolbar extends mvc.View<undefined> {

            constructor(options?: Toolbar.Options);

            options: Toolbar.Options;

            on(evt: string | object, callback?: (...args: any[]) => void, context?: any): this;

            getWidgetByName(name: string): Widget;
            getWidgetByName<T extends keyof ui.widgets.WidgetMap>(name: string): ui.widgets.WidgetMap[T];

            getWidgets(): Array<Widget>;

            render(): this;
        }

        class Tooltip extends mvc.View<undefined> {

            constructor(options?: Tooltip.Options);

            options: Tooltip.Options;

            hide(): void;

            show(options?: Tooltip.RenderOptions): void;

            toggle(options?: Tooltip.RenderOptions): void;

            isVisible(): boolean;

            render(options?: Tooltip.RenderOptions): this;

            protected getTooltipSettings(el: HTMLElement): { [key: string]: any };
        }

        namespace Tooltip {

            export enum TooltipPosition {
                Left = 'left',
                Top = 'top',
                Bottom = 'bottom',
                Right = 'right'
            }

            enum TooltipArrowPosition {
                Left = 'left',
                Top = 'top',
                Bottom = 'bottom',
                Right = 'right',
                Auto = 'auto',
                Off = 'off'
            }

            interface Animation {
                duration?: number | string;
                delay?: number | string;
                timingFunction?: string;
                [key: string]: any;
            }

            export interface RenderOptions {
                target?: string | Element,
                x?: number,
                y?: number
            }

            export interface Options extends mvc.ViewOptions<undefined> {

                position?: TooltipPosition | ((element: Element) => TooltipPosition);
                positionSelector?: string | ((element: Element) => Element);
                direction?: TooltipArrowPosition;
                minResizedWidth?: number;
                padding?: number;
                rootTarget?: any;
                target?: any;
                container?: string | Element | JQuery,
                trigger?: string;
                viewport?: {
                    selector?: null
                    padding?: number
                };
                dataAttributePrefix?: string;
                template?: string;
                content?: string | Element | JQuery | ((this: Tooltip, node: Node, tooltip: Tooltip) => string | JQuery | Element | false | null | undefined);
                animation?: boolean | Animation;
            }
        }

        namespace Keyboard {

            interface Options {
                filter?: (evt: dia.Event, keyboard: Keyboard) => boolean;
            }

            type Event = dia.Event | KeyboardEvent;
        }

        class Keyboard {

            constructor(options?: Keyboard.Options);

            options: Keyboard.Options;

            on(evt: string | object, callback?: ((evt: dia.Event) => void) | any, context?: any): this;

            off(evt: string | object, callback?: ((evt: dia.Event) => void) | any, context?: any): this;

            enable(): void;

            disable(): void;

            isActive(name: string, evt: Keyboard.Event): boolean;

            isKeyPrintable(evt: Keyboard.Event): boolean;

            isConsumerElement(evt: Keyboard.Event): boolean;

            static keyMap: { [key: string]: number };
            static modifiers: { [key: number]: string };
            static modifierMap: { [key: string]: number };
            static charCodeAlternatives: { [key: number]: string };
            static eventNamesMap: { [event: string]: string }
        }

        class Selection extends mvc.View<dia.Cell> {

            constructor(options?: Selection.Options);

            options: Selection.Options;

            cancelSelection(): void;

            addHandle(opt?: Selection.Handle): this;

            stopSelecting(evt: dia.Event): void;

            removeHandle(name: string): this;

            startSelecting(evt: dia.Event): void;

            changeHandle(name: string, opt?: Selection.Handle): this;

            translateSelectedElements(dx: number, dy: number): void;

            hide(): void;

            render(): this;

            destroySelectionBox(cell: dia.Cell): void;

            createSelectionBox(cell: dia.Cell): void;

            protected onSelectionBoxPointerDown(evt: dia.Event): void;

            protected startSelectionInteraction(evt: dia.Event, cellView: dia.CellView): void;

            protected startTranslatingSelection(evt: dia.Event): void;

            protected pointerup(evt: dia.Event): void;

            protected showSelected(): void;

            protected destroyAllSelectionBoxes(): void;

            protected onHandlePointerDown(evt: dia.Event): void;

            protected pointermove(evt: dia.Event): void;

            protected onRemoveElement(element: dia.Element): void;

            protected onResetElements(elements: dia.Element): void;

            protected onAddElement(element: dia.Element): void;

            protected getCellBBox(cell: dia.Cell): g.Rect | null;

            protected getWrapperBBox(): g.Rect | null;

            protected updateBoxContent(): void;
        }

        namespace Selection {

            export interface Options extends mvc.ViewOptions<undefined> {
                paper: dia.Paper | ui.PaperScroller;
                graph?: dia.Graph;
                boxContent?: boolean | string | HTMLElement | JQuery | ((boxElement: HTMLElement) => string | HTMLElement | JQuery);
                handles?: Array<Handle>;
                useModelGeometry?: boolean;
                strictSelection?: boolean;
                rotateAngleGrid?: number;
                allowTranslate?: boolean;
                preserveAspectRatio?: boolean;
                collection?: any;
                filter?: ((cell: dia.Cell) => boolean) | Array<string | dia.Cell>;
                translateConnectedLinks?: ConnectedLinksTranslation;
                allowCellInteraction?: boolean;
            }

            export interface Handle {
                name: string;
                position?: HandlePosition;
                events?: HandleEvents;
                attrs?: any;
                icon?: string;
                content?: string | HTMLElement | JQuery
            }

            enum HandlePosition {
                N = 'n', NW = 'nw',
                W = 'w', SW = 'sw',
                S = 's', SE = 'se',
                E = 'e', NE = 'ne'
            }

            enum ConnectedLinksTranslation {
                NONE = 'none',
                SUBGRAPH = 'subgraph',
                ALL = 'all'
            }

            type EventHandler = (evt: dia.Event, x: number, y: number) => void;

            export interface HandleEvents {
                pointerdown?: string | EventHandler;
                pointermove?: string | EventHandler;
                pointerup?: string | EventHandler;
                contextmenu?: string | EventHandler;
            }
        }

        namespace Snaplines {

            export type SnaplinesType = 'move' | 'resize';

            export interface AdditionalSnapPointsOptions {
                type: SnaplinesType
            }

            export interface Options extends mvc.ViewOptions<undefined> {
                paper: dia.Paper;
                distance?: number;
                filter?: string[] | dia.Cell[] | (() => string[] | dia.Cell[]);
                usePaperGrid?: boolean;
                canSnap?: (this: Snaplines, elementView: dia.ElementView) => boolean;
                additionalSnapPoints?: (this: Snaplines, elementView: dia.ElementView, options: AdditionalSnapPointsOptions) => Array<dia.Point>;
            }
        }

        class Snaplines extends mvc.View<undefined> {

            constructor(opt?: Snaplines.Options);

            options: Snaplines.Options;

            hide(): void;

            render(): this;

            isDisabled(): boolean;

            enable(): void;

            disable(): void;

            /**
             * @deprecated in favor of `enable()`
             */
            startListening(): void;

            protected show(opt?: {
                vertical?: number,
                horizontal?: number
            }): void;

            protected captureCursorOffset(cellView: dia.CellView, evt: dia.Event, x: number, y: number): void;

            protected snapWhileResizing(cell: dia.Cell, opt?: { [key: string]: any }): void;

            protected canElementMove(cellView: dia.CellView): boolean;

            protected canElementSnap(cellView: dia.CellView, evt?: dia.Event): boolean;

            protected snapWhileMoving(cellView: dia.CellView, evt: dia.Event, x: number, y: number): void;

            protected onBatchStop(data: { [key: string]: any }): void;
        }

        namespace Stencil {

            type MatchCellCallback = (cell: dia.Cell, keyword: string, groupId: string, stencil: Stencil) => boolean;
            type MatchCellMap = { [type: string]: Array<dia.Path> };
            type DropAnimation = boolean | { duration?: number | string, easing?: string };

            type LayoutGroupCallback = (graph: dia.Graph, group: Group) => void;

            export interface Options extends mvc.ViewOptions<undefined> {
                paper: dia.Paper | ui.PaperScroller;
                width?: number;
                height?: number;
                label?: string;
                groups?: { [key: string]: Stencil.Group };
                groupsToggleButtons?: boolean;
                dropAnimation?: DropAnimation;
                search?: MatchCellMap | MatchCellCallback | null;
                layout?: boolean | layout.GridLayout.Options | { [key: string]: any } | LayoutGroupCallback;
                snaplines?: ui.Snaplines;
                scaleClones?: boolean;
                usePaperGrid?: boolean;
                dragStartClone?: (cell: dia.Cell) => dia.Cell;
                dragEndClone?: (cell: dia.Cell) => dia.Cell;
                paperOptions?: (() => dia.Paper.Options) | dia.Paper.Options;
                paperDragOptions?: (() => dia.Paper.Options) | dia.Paper.Options;
                canDrag?: (cellView: dia.CellView, evt: dia.Event, groupName: string | null) => boolean;
                contentOptions?: dia.Paper.FitToContentOptions;
                container?: string | Element | JQuery;
            }

            export interface Group {
                label: string;
                index: number;
                closed?: boolean;
                height?: number;
                layout?: boolean | layout.GridLayout.Options | { [key: string]: any };
                paperOptions?: (() => dia.Paper.Options) | dia.Paper.Options;
                [key: string]: any;
            }
        }

        class Stencil extends mvc.View<undefined> {

            constructor(opt?: Stencil.Options);

            options: Stencil.Options;

            papers: { [groupName: string]: dia.Paper };

            paperEvents: Backbone.EventsHash;

            setPaper(paper: dia.Paper | ui.PaperScroller): void;

            startListening(): void;

            load(groups: { [groupName: string]: Array<dia.Cell | Backbone.ObjectHash> }): void;
            load(cells: Array<dia.Cell | Backbone.ObjectHash>, groupName?: string): void;

            loadGroup(cells: Array<dia.Cell | Backbone.ObjectHash>, groupName?: string): void;

            getGraph(group?: string): dia.Graph;

            getPaper(group?: string): dia.Paper;

            render(): this;

            toggleGroup(name: string): void;

            closeGroup(name: string): void;

            openGroup(name: string): void;

            isGroupOpen(name: string): boolean;

            closeGroups(): void;

            openGroups(): void;

            freeze(opt?: dia.Paper.FreezeOptions): void;

            unfreeze(opt?: dia.Paper.UnfreezeOptions): void;

            cancelDrag(options?: { dropAnimation?: Stencil.DropAnimation }): void;

            isDragCanceled(): boolean;

            startDragging(cell: dia.Cell, evt: dia.Event | Event): void;

            filter(keyword: string, matchCell?: Stencil.MatchCellMap | Stencil.MatchCellCallback): void;

            protected positionCell(cell: dia.Cell, x: number, y: number, opt?: dia.Cell.Options): void;

            protected preparePaperForDragging(cell: dia.Cell, clientX: number, clientY: number): void;

            protected removePaperAfterDragging(clone: dia.Cell): void;

            protected onCloneSnapped(clone: dia.Cell, position: any, opt?: { [key: string]: any }): void;

            protected onDragStart(cellView: dia.CellView, evt: dia.Event, x: number, y: number): void;

            protected onDrag(evt: dia.Event): void;

            protected onDragEnd(evt: dia.Event): void;

            protected onDropEnd(cellClone: dia.Cell): void;

            protected notifyDragEnd(cloneView: dia.CellView, evt: dia.Event, cloneArea: g.Rect, validDropTarget: boolean): void;

            protected onDrop(cloneView: dia.CellView, evt: dia.Event, point: g.Point, snapToGrid: boolean): void;

            protected onDropInvalid(cloneView: dia.CellView, evt: dia.Event, point: g.Point, snapToGrid: boolean): void;

            protected drop(clone: dia.Element, point: dia.Point, snapToGrid: boolean): void;

            protected insideValidArea(point: dia.Point): boolean;

            protected getDropArea(el: HTMLElement | JQuery): g.Rect;

            protected getCloneArea(cloneView: dia.CellView, evt: dia.Event, usePaperGrid: boolean): g.Rect;

            protected onSearch(evt: dia.Event): void;

            protected pointerFocusIn(): void;

            protected pointerFocusOut(): void;

            protected onGroupLabelClick(evt: dia.Event): void;

            protected dispose(): void;

            protected createGroupGraph(groupId: string, paperOptions: dia.Paper.Options): dia.Graph;

            protected getGroupPaperOptions(groupId: string): dia.Paper.Options;
        }

        namespace TreeLayoutView {

            interface ConnectionDetails {
                level: number;
                direction: layout.TreeLayout.Direction,
                siblingRank: number,
                siblings: Array<dia.Element>
            }

            export interface Options extends mvc.ViewOptions<layout.TreeLayout> {
                previewAttrs?: { [key: string]: any };
                useModelGeometry?: boolean;
                clone?: (element: dia.Element) => dia.Element;
                canInteract?: (elementView: dia.ElementView) => boolean;
                validateConnection?: ((
                    element: dia.Element,
                    candidate: dia.Element,
                    treeLayoutView: TreeLayoutView,
                    details: ConnectionDetails
                ) => boolean) | null;
                validatePosition?: ((
                    element: dia.Element,
                    x: number,
                    y: number,
                    treeLayoutView: TreeLayoutView
                ) => boolean) | null;
                reconnectElements?: ((
                    elements: dia.Element[],
                    parent: dia.Element,
                    siblingRank: number,
                    direction: layout.TreeLayout.Direction,
                    treeLayoutView: TreeLayoutView
                ) => void) | null;
                translateElements?: ((
                    elements: dia.Element[],
                    x: number,
                    y: number,
                    treeLayoutView: TreeLayoutView
                ) => void) | null;
                layoutFunction?: ((treeLayoutView: TreeLayoutView) => void) | null
                paperConstructor?: typeof dia.Paper;
                paperOptions?: dia.Paper.Options;
                [key: string]: any;
            }
        }

        class TreeLayoutView extends mvc.View<layout.TreeLayout> {

            constructor(options?: TreeLayoutView.Options);

            options: TreeLayoutView.Options;

            render(): this;

            toggleDefaultInteraction(interactive: boolean): void;

            toggleDropping(state: boolean): void;

            isActive(): boolean;

            reconnectElement(element: dia.Element, candidate: { id: string; direction: layout.TreeLayout.Direction; siblingRank: number; }): void;

            canInteract(handler: any): (cellView: dia.CellView) => boolean;

            startDragging(elements: Array<dia.Element>): void;

            dragstart(elements: Array<dia.Element>, x: number, y: number): void;

            drag(elements: Array<dia.Element>, x: number, y: number): void;

            dragend(elements: Array<dia.Element>, x: number, y: number): void;

            cancelDrag(): void;

            canDrop(): boolean;

            show(): void;

            hide(): void;

            isDisabled(): boolean;

            enable(): void;

            disable(): void;

            /**
             * @deprecated in favor of `enable()`
             */
            startListening(): void;

            protected onPointerdown(elementView: dia.ElementView, evt: dia.Event, x: number, y: number): void;

            protected onPointermove(evt: dia.Event): void;

            protected onPointerup(evt: dia.Event): void;
        }

        namespace StackLayoutView {

            export interface PreviewCallbackOptions {
                sourceStack: layout.StackLayout.Stack;
                sourceElement: dia.Element;
                targetStack: layout.StackLayout.Stack;
                insertElementIndex: number;
                invalid: boolean;
            }

            export interface ValidateCallbackOptions {
                sourceStack: layout.StackLayout.Stack;
                sourceElement: dia.Element;
                targetStack: layout.StackLayout.Stack;
                insertElementIndex: number;
            }

            export interface ModifyInsertElementIndexOptions {
                sourceStack: layout.StackLayout.Stack;
                sourceElement: dia.Element;
                targetStack: layout.StackLayout.Stack;
                insertElementIndex: number;
            }

            export type PreviewCallback = (options: PreviewCallbackOptions, view: StackLayoutView) => SVGElement;

            export type ValidateMovingCallback = (options: ValidateCallbackOptions, view: StackLayoutView) => boolean;

            export type ModifyInsertElementIndexCallback = (options: ModifyInsertElementIndexOptions, point: g.Point, view: StackLayoutView) => number;

            export type CanInteractCallback = (elementView: dia.ElementView, view: StackLayoutView) => boolean;

            export interface StackLayoutModelOptions extends layout.StackLayout.StackLayoutOptions {
                stackIndexAttributeName?: string,
                stackElementIndexAttributeName?: string
            }

            export interface StackLayoutViewOptions extends mvc.ViewOptions<StackLayoutModel, SVGElement> {
                layoutOptions?: StackLayoutModelOptions;
                paper: dia.Paper;
                preview?: PreviewCallback;
                validateMoving?: ValidateMovingCallback;
                modifyInsertElementIndex?: ModifyInsertElementIndexCallback;
                canInteract?: CanInteractCallback;
            }

            export interface StackLayoutModel extends Backbone.Model<StackLayoutModelOptions> {

                update(): void;

                getStackFromPoint(point: g.PlainPoint): layout.StackLayout.Stack;

                getInsertElementIndexFromPoint(stack: layout.StackLayout.Stack, point: g.PlainPoint): number;

                getStackFromElement(element: dia.Element): layout.StackLayout.Stack

                hasElement(element: dia.Element): boolean;

                insertElement(element: dia.Element, targetStackIndex: number, insertElementIndex: number, opt?: dia.Cell.Options): void;

                bbox: g.Rect;

                elements: dia.Element[];

                stacks: layout.StackLayout.Stack[];

                direction: layout.StackLayout.Directions;
            }
        }

        export class StackLayoutView extends mvc.View<StackLayoutView.StackLayoutModel, SVGElement> {

            constructor(options: StackLayoutView.StackLayoutViewOptions);

            options: StackLayoutView.StackLayoutViewOptions;

            startListening(): void;

            dragstart(element: dia.Element, x: number, y: number): void;

            drag(element: dia.Element, x: number, y: number): void;

            dragend(element: dia.Element, x: number, y: number): void;

            cancelDrag(): void;

            canDrop(): boolean;

            protected getPreviewPosition(targetStack: layout.StackLayout.Stack, targetElementIndex: number): g.PlainPoint;

            protected createGhost(elementView: dia.ElementView): Vectorizer;

            protected onPaperPointerdown(view: dia.ElementView, evt: dia.Event, pointerX: number, pointerY: number): void;

            protected onPaperPointermove(view: dia.ElementView, evt: dia.Event, pointerX: number, pointerY: number): void;

            protected onPaperPointerup(view: dia.ElementView, evt: dia.Event): void;
        }

        namespace Halo {

            export interface Options extends mvc.ViewOptions<undefined> {
                cellView: dia.CellView;
                loopLinkPreferredSide?: 'top' | 'bottom' | 'left' | 'right';
                loopLinkWidth?: number;
                rotateAngleGrid?: number;
                rotateEmbeds?: boolean;
                boxContent?: boolean | string | HTMLElement | JQuery | ((cellView: dia.CellView, boxElement: HTMLElement) => string | HTMLElement | JQuery);
                handles?: Array<Handle>;
                clearAll?: boolean;
                clearOnBlankPointerdown?: boolean;
                useModelGeometry?: boolean;
                clone?: (cell: dia.Cell, opt: { [key: string]: any }) => dia.Cell | Array<dia.Cell>;
                type?: string;
                pieSliceAngle?: number;
                pieStartAngleOffset?: number;
                pieIconSize?: number;
                pieToggles?: Array<{ name: string, position: HandlePosition }>;
                bbox?: dia.Point | dia.BBox | ((cellView: dia.CellView) => dia.Point | dia.BBox);
                tinyThreshold?: number;
                smallThreshold?: number;
                magnet?: (elementView: dia.ElementView, end: 'source' | 'target', evt: dia.Event) => SVGElement;
            }

            enum HandlePosition {
                N = 'n', NW = 'nw',
                W = 'w', SW = 'sw',
                S = 's', SE = 'se',
                E = 'e', NE = 'ne'
            }

            type EventHandler = (evt: dia.Event, x: number, y: number) => void;

            interface HandleEvents {
                pointerdown?: string | EventHandler;
                pointermove?: string | EventHandler;
                pointerup?: string | EventHandler;
                contextmenu?: string | EventHandler;
            }

            interface Handle {
                name: string;
                position?: HandlePosition;
                events?: HandleEvents;
                attrs?: any;
                icon?: string;
                content?: string | HTMLElement | JQuery;
            }
        }

        class Halo extends mvc.View<undefined> {

            constructor(options?: Halo.Options);

            options: Halo.Options;

            extendHandles(props: Halo.Handle): void;

            addHandles(handles: Halo.Handle[]): this;

            addHandle(handle: Halo.Handle): this;

            removeHandles(): this;

            removeHandle(name: string): this;

            changeHandle(name: string, handle: Halo.Handle): this;

            hasHandle(name: string): boolean;

            getHandle(name: string): Halo.Handle | undefined;

            toggleHandle(name: string, selected?: boolean): this;

            selectHandle(name: string): this;

            deselectHandle(name: string): this;

            deselectAllHandles(): this;

            toggleState(toggleName: string): void;

            isOpen(toggleName: string): boolean;

            isRendered(): boolean;

            render(): this;

            static clear(paper: dia.Paper): void;

            protected update(): void;

            protected onHandlePointerDown(evt: dia.Event): void;

            protected onPieTogglePointerDown(evt: dia.Event): void;

            protected pointermove(evt: dia.Event): void;

            protected pointerup(evt: dia.Event): void;

            protected toggleFork(): void;

            protected canFork(): boolean;

            protected cloneCell(cell: dia.Cell, opt: { [key: string]: any }): dia.Cell;
        }

        namespace TextEditor {

            interface Annotation extends Vectorizer.TextAnnotation {
                [key: string]: any;
            }

            interface URLAnnotation extends Annotation {
                url: string;
            }

            type URLAnnotationCallback = (url: string) => Partial<URLAnnotation>;

            interface Options extends mvc.ViewOptions<undefined> {

                text?: string, // The SVG text element on which we want to enable inline text editing.
                newlineCharacterBBoxWidth?: number, // The width of the new line character. Used for selection of a newline.
                placeholder?: boolean | string,  // The placeholder in case the text gets emptied.
                focus?: boolean, // Determines if the textarea should gain focus. In some cases, this is not intentional - e.g. if we use the ui.TextEditor for displaying remote cursor.
                debug?: boolean,
                useNativeSelection?: boolean,
                annotateUrls?: boolean,
                cellView?: dia.CellView,
                textProperty?: dia.Path,
                annotationsProperty?: dia.Path,
                urlAnnotation?: Partial<URLAnnotation> | URLAnnotationCallback,
                textareaAttributes?: {
                    autocorrect?: string,
                    autocomplete?: string,
                    autocapitalize?: string,
                    spellcheck?: string,
                    tabindex?: string
                },
                onKeydown?: (this: TextEditor, evt: KeyboardEvent, editor: TextEditor) => void;
                onOutsidePointerdown?: (this: TextEditor, evt: PointerEvent, editor: TextEditor) => void;
            }

            interface Selection {
                end: number | null;
                start: number | null;
            }

            interface EventMap {
                'open': (textElement: SVGElement, cellView: dia.CellView | null) => void;
                'close': (textElement: SVGElement, cellView: dia.CellView | null) => void;
                'text:change': (text: string, prevText: string, annotation: Array<Vectorizer.TextAnnotation>, selection: Selection, prevSelection: Selection) => void;
                'select:change': (selectionStart: number, selectionEnd: number) => void;
                'select:changed': (selectionStart: number, selectionEnd: number) => void;
                'select:out-of-range': (selectionStart: number, selectionEnd: number) => void;
                'caret:change': (caretPosition: number) => void;
            }
        }

        class TextEditor extends mvc.View<undefined> {

            constructor(options?: TextEditor.Options);

            options: TextEditor.Options;

            render(root?: HTMLElement): this;

            selectAll(): this;

            // Programmatically select portion of the text inside the text editor starting at selectionStart ending at selectionEnd. This method automatically swaps selectionStart and selectionEnd if they are in a wrong order.
            select(selectionStart: number, selectionEnd?: number): this

            // Programmatically deselect all the selected text inside the text editor.
            deselect(): this;

            // Return the start character position of the current selection.
            getSelectionStart(): number | null;

            // Return the end character position of the current selection.
            getSelectionEnd(): number | null;

            // Return an object of the form { start: Number, end: Number } containing the start and end position of the current selection. Note that the start and end positions are returned normalized. This means that the start index will always be lower than the end index even though the user started selecting the text from the end back to the start.
            getSelectionRange(): TextEditor.Selection;

            // Return the number of characters in the current selection.
            getSelectionLength(): number;

            // Return the selected text.
            getSelection(): string;

            // Start the mouse text selection
            startSelecting(): void;

            // Programmatically set the caret position. If opt.silent is true, the text editor will not trigger the 'caret:change' event.
            setCaret(charNum: number, opt?: { [key: string]: any }): this;

            // Programmatically hide the caret.
            hideCaret(): this;

            // Update the size and color of the caret
            updateCaret(): void;

            // Return the text content (including new line characters) inside the text editor.
            getTextContent(): string;

            // Return the start and end character positions for a word under charNum character position.
            getWordBoundary(charNum: number): [number, number] | undefined;

            // Return the start and end character positions for a URL under charNum character position. Return undefined if there was no URL recognized at the charNum index.
            getURLBoundary(charNum: number): [number, number] | undefined;

            // Return the number of characters in the text.
            getNumberOfChars(): number;

            // Return the character position the user clicked on. If there is no such a position found, return the last one.
            getCharNumFromEvent(evt: dia.Event | Event): number;

            // This method stores annotation attributes that will be used for the very next insert operation. This is useful, for example, when we have a toolbar and the user changes text to e.g. bold. At this point, we can just call setCurrentAnnotation({ 'font-weight': 'bold' }) and let the text editor know that once the user starts typing, the text should be bold. Note that the current annotation will be removed right after the first text operation came. This is because after that, the next inserted character will already inherit properties from the previous character which is our 'bold' text. (Rich-text specific.)
            setCurrentAnnotation(attrs: attributes.SVGAttributes): void;

            // Set annotations of the text inside the text editor. These annotations will be modified during the course of using the text editor. (Rich-text specific.)
            setAnnotations(annotations: Vectorizer.TextAnnotation | Array<Vectorizer.TextAnnotation>): void;

            // Return the annotations of the text inside the text editor. (Rich-text specific.)
            getAnnotations(): Array<Vectorizer.TextAnnotation> | undefined;

            // Get the combined (merged) attributes for a character at the position index taking into account all the annotations that apply. (Rich-text specific.)
            getCombinedAnnotationAttrsAtIndex(index: number, annotations: Vectorizer.TextAnnotation | Array<Vectorizer.TextAnnotation>): attributes.SVGAttributes;

            // Find a common annotation among all the annotations that fall into the range (an object with start and end properties - normalized). For characters that don't fall into any of the annotations, assume defaultAnnotation (default annotation does not need start and end properties). The common annotation denotes the attributes that all the characters in the range share. If any of the attributes for any character inside range differ, undefined is returned. This is useful e.g. when your toolbar needs to reflect the text attributes of a selection. (Rich-text specific.)
            getSelectionAttrs(range: TextEditor.Selection, annotations: Vectorizer.TextAnnotation): attributes.SVGAttributes;

            findAnnotationsUnderCursor(annotations: Vectorizer.TextAnnotation, selectionStart: number): Array<Vectorizer.TextAnnotation>;

            findAnnotationsInSelection(annotations: Vectorizer.TextAnnotation, selectionStart: number, selectionEnd: number): Array<Vectorizer.TextAnnotation>;

            // protected

            protected setTextElement(el: SVGElement): void;

            protected bindTextElement(el: SVGElement): void;

            protected unbindTextElement(): void;

            protected onKeydown(evt: dia.Event): void;

            protected onKeyup(evt: dia.Event): void;

            protected onCopy(evt: dia.Event): void;

            protected onCut(evt: dia.Event): void;

            protected onPaste(evt: dia.Event): void;

            protected onAfterPaste(evt: dia.Event): void;

            protected onMousedown(evt: dia.Event): void;

            protected onMousemove(evt: dia.Event): void;

            protected onMouseup(evt: dia.Event): void;

            protected onDoubleClick(evt: dia.Event): void;

            protected onTripleClick(evt: dia.Event): void;

            protected onInput(evt: dia.Event): void;

            protected onAfterKeydown(evt: dia.Event): void;

            // Class methods

            static ed: TextEditor | null;

            static edit(el?: SVGElement, opt?: TextEditor.Options): TextEditor;

            static close(): void;

            static applyAnnotations(annotations: TextEditor.Annotation[]): void;

            static getTextElement(el: SVGElement): SVGElement | undefined;

            static isLineStart(text: string, charNum: number): boolean;

            static isLineEnding(text: string, charNum: number): boolean;

            static isEmptyLine(text: string, charNum: number): boolean;

            static normalizeAnnotations(
                annotations: TextEditor.Annotation[],
                options?: any
            ): TextEditor.Annotation[];

            static getCombinedAnnotationAttrsAtIndex(
                annotations: TextEditor.Annotation[],
                index: number,
                options?: any
            ): attributes.SVGAttributes;

            static getCombinedAnnotationAttrsBetweenIndexes(
                annotations: TextEditor.Annotation[],
                start: number,
                end: number,
                options?: any
            ): attributes.SVGAttributes;

            // Proxies

            static setCaret(charNum: number, opt?: { [key: string]: any }): TextEditor;

            static deselect(): TextEditor;

            static selectAll(): TextEditor;

            static select(selectionStart: number, selectionEnd?: number): TextEditor;

            static getNumberOfChars(): number;

            static getCharNumFromEvent(evt: dia.Event | Event): number;

            static getWordBoundary(charNum: number): [number, number] | undefined;

            static getSelectionLength(): number;

            static getSelectionRange(): TextEditor.Selection;

            static getAnnotations(): TextEditor.Annotation[] | undefined;

            static setCurrentAnnotation(attrs: attributes.SVGAttributes): void;

            static getSelectionAttrs(
                annotations: Vectorizer.TextAnnotation | Array<Vectorizer.TextAnnotation>
            ): attributes.SVGAttributes | null;

            static findAnnotationsUnderCursor(): Array<Vectorizer.TextAnnotation> | null;

            static findAnnotationsInSelection(): Array<Vectorizer.TextAnnotation> | null;

            /* TODO: Backbone.EventsMixin add static methods */

            static on(eventName: string, callback: Backbone.EventHandler, context?: any): TextEditor;
            static on(eventMap: Backbone.EventMap, context?: any): TextEditor;
            static off(eventName?: string, callback?: Backbone.EventHandler, context?: any): TextEditor;
            static trigger(eventName: string, ...args: any[]): TextEditor;
            static bind(eventName: string, callback: Backbone.EventHandler, context?: any): TextEditor;
            static bind(eventMap: Backbone.EventMap, context?: any): TextEditor;
            static unbind(eventName?: string, callback?: Backbone.EventHandler, context?: any): TextEditor;

            static once(events: string, callback: Backbone.EventHandler, context?: any): TextEditor;
            static once(eventMap: Backbone.EventMap, context?: any): TextEditor;
            static listenTo(object: any, events: string, callback: Backbone.EventHandler): TextEditor;
            static listenTo(object: any, eventMap: Backbone.EventMap): TextEditor;
            static listenToOnce(object: any, events: string, callback: Backbone.EventHandler): TextEditor;
            static listenToOnce(object: any, eventMap: Backbone.EventMap): TextEditor;
            static stopListening(object?: any, events?: string, callback?: Backbone.EventHandler): TextEditor;
        }
    }

    export namespace alg {

        interface PriorityQueueOptions {
            comparator?: (a: number, b: number) => number;
            data: Array<any>
        }

        class PriorityQueue {

            constructor(opt?: PriorityQueueOptions);

            options: PriorityQueueOptions;

            isEmpty(): boolean;

            insert(priority: number, value: any, id?: number | string): void;

            peek(): any;

            peekPriority(): number;

            updatePriority(id: number | string, priority: number): void;

            remove(): any;

            bubbleUp(pos: number): void;

            bubbleDown(pos: number): void;
        }

        const Dijkstra: (adjacencyList: any, source: string | number, weight: (aNode: any, bNode: any) => number) => any;
    }

    export namespace format {

        namespace gexf {

            export interface ElementOptions {
                id: string | number;
                label: string;
                width?: number;
                height?: number;
                x?: number;
                y?: number;
                z?: number;
                color?: string;
                shape?: string;
            }

            export interface LinkOptions {
                source: string;
                target: string;
            }
        }

        export namespace gexf {
            export function toCellsArray(
                xmlString: string,
                makeElement: (opt: gexf.ElementOptions, xmlNode: Node) => dia.Element,
                makeLink: (opt: gexf.LinkOptions, xmlEdge: Node) => dia.Link
            ): Array<dia.Cell>;
        }

        export function toPNG(paper: dia.Paper, callback: (dataURL: string, error?: Error) => void, opt?: dia.Paper.RasterExportOptions): void;

        export function toDataURL(paper: dia.Paper, callback: (dataURL: string, error?: Error) => void, opt?: dia.Paper.RasterExportOptions): void;

        export function toJPEG(paper: dia.Paper, callback: (dataURL: string, error?: Error) => void, opt?: dia.Paper.RasterExportOptions): void;

        export function toSVG(paper: dia.Paper, callback: (svg: string, error?: Error) => void, opt?: dia.Paper.SVGExportOptions): void;

        export function toCanvas(paper: dia.Paper, callback: (canvas: HTMLCanvasElement, error?: Error) => void, opt?: dia.Paper.CanvasExportOptions): void;

        export function openAsSVG(paper: dia.Paper, opt?: dia.Paper.SVGExportOptions): void;

        export function openAsPNG(paper: dia.Paper, opt?: dia.Paper.RasterExportOptions): void;

        export function print(paper: dia.Paper, opt?: dia.Paper.PrintExportOptions): void;
    }

    export namespace storage {
        const Local: {
            prefix: string;
            insert: (collection: string, doc: any, callback: (err: Error, doc: any) => void) => void;
            find: (collection: string, query: any, callback: (err: Error, docs: Array<any>) => void) => void;
            remove: (collection: string, query: any, callback: (err: Error) => void) => void;
        };
    }

}
