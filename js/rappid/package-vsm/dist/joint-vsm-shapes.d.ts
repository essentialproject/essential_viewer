/*! JointJS+ v3.7.2 - HTML5 Diagramming Framework - TRIAL VERSION

Copyright (c) 2023 client IO

 2023-10-10 


This Source Code Form is subject to the terms of the JointJS+ Trial License
, v. 2.0. If a copy of the JointJS+ License was not distributed with this
file, You can obtain one at https://www.jointjs.com/license
 or from the JointJS+ archive as was distributed by client IO. See the LICENSE file.*/


import { dia, attributes, g } from 'jointjs';

declare class VSMCustomerSupplier extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

interface VSMWorkcellAttributes extends dia.Element.Attributes {
    thickness: number;
}
declare class VSMWorkcell extends dia.Element<VSMWorkcellAttributes> {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        thickness: number;
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetThickness(opt?: dia.Cell.Options): void;
}

declare class VSMTriangleInventory extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                d: string;
            };
            icon: {
                stroke: string;
                fill: string;
                strokeWidth: number;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMRoundedInventory extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                x: number;
                y: number;
                d: string;
            };
            icon: {
                stroke: string;
                fill: string;
                strokeWidth: number;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMKaizenBurst extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                refD: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: string;
                    height: string;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMOperator extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                rx: string;
                ry: string;
                cx: string;
                cy: string;
            };
            cap: {
                fill: string;
                stroke: string;
                strokeWidth: number;
                strokeLinecap: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMMaterialPull extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                stroke: string;
                fill: string;
                rx: string;
                ry: string;
                cx: string;
                cy: string;
            };
            arrow: {
                fill: string;
                stroke: string;
                strokeWidth: number;
                d: string;
                targetMarker: {
                    type: string;
                    stroke: string;
                    'stroke-width': number;
                    d: string;
                };
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMFIFOLane extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                fill: string;
                width: string;
                height: string;
            };
            outline: {
                strokeWidth: number;
                stroke: string;
                d: string;
            };
            rectIcon: {
                x: string;
                y: string;
                width: string;
                height: string;
            };
            ellipseIcon: {
                cx: string;
                cy: string;
                rx: string;
                ry: string;
            };
            triangleIcon: {
                d: string;
            };
            icons: {
                stroke: string;
                fill: string;
                strokeWidth: number;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMKanbanPost extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMSequencePullBall extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            inner: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                rx: string;
                ry: string;
                cx: string;
                cy: string;
            };
            outer: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                rx: string;
                ry: string;
                cx: string;
                cy: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMLoadLevelling extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                fill: string;
                width: string;
                height: string;
            };
            outline: {
                strokeWidth: number;
                stroke: string;
                d: string;
            };
            circle1Icon: {
                cx: string;
                cy: string;
                r: string;
            };
            circle2Icon: {
                cx: string;
                cy: string;
                r: string;
            };
            cross1Icon: {
                transform: string;
                d: string;
            };
            cross2Icon: {
                transform: string;
                d: string;
            };
            icons: {
                stroke: string;
                fill: string;
                strokeWidth: number;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMSignalKanban extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                x: number;
                y: number;
                d: string;
            };
            icon: {
                stroke: string;
                strokeWidth: number;
                fill: string;
                x: string;
                y: string;
                textAnchor: string;
                textVerticalAnchor: string;
                text: string;
                fontSize: number;
                fontWeight: string;
                fontFamily: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMProductionKanban extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                x: number;
                y: number;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMProductionBatchKanban extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            bodies: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                x: number;
                y: number;
                d: string;
            };
            bodyMiddle: {
                transform: string;
            };
            bodyBottom: {
                transform: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMMaterialKanban extends VSMProductionKanban {
    defaults(): any;
}
declare class VSMMaterialBatchKanban extends VSMProductionBatchKanban {
    defaults(): any;
}

declare class VSMSupermarketParts extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                width: string;
                height: string;
                strokeWidth: number;
                stroke: string;
                fill: dia.SVGPatternJSON;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMProductionControl extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                width: string;
                height: string;
                strokeWidth: number;
                stroke: string;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

interface VSMSupermarketAttributes extends dia.Element.Attributes {
    count: number;
}
declare class VSMSupermarket extends dia.Element<VSMSupermarketAttributes> {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        count: number;
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetCount(opt?: dia.Cell.Options): void;
}

interface VSMSafetyStockAttributes extends dia.Element.Attributes {
    count: number;
}
declare class VSMSafetyStock extends dia.Element<VSMSafetyStockAttributes> {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        count: number;
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetCount(opt?: dia.Cell.Options): void;
}

declare class VSMGoSee extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
                refD: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMTimelineWaiting extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            line: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    maxLineCount: number;
                    ellipsis: boolean;
                };
                x: string;
                y: number;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMTimelineProcessing extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            line: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    maxLineCount: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMTimelineTotal extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        length: number;
        attrs: {
            body: {
                fill: string;
                stroke: string;
                strokeWidth: number;
                width: string;
                height: string;
            };
            line: {
                strokeWidth: number;
                stroke: string;
                strokeLinecap: string;
                fill: string;
                d: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    height: any;
                };
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
            labelTotalWaiting: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: string;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
            labelTotalProcessing: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    height: string;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetLength(opt?: dia.Cell.Options): void;
}

interface VSMResourcePlanningAttributes extends dia.Element.Attributes {
    tilt: number;
}
declare class VSMResourcePlanning extends dia.Element<VSMResourcePlanningAttributes> {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        tilt: number;
        attrs: {
            body: {
                fill: string;
                stroke: string;
                strokeWidth: number;
            };
            top: {
                cx: string;
                rx: string;
                fill: string;
                stroke: string;
                strokeWidth: number;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetTilt(opt?: dia.Cell.Options): this;
    protected getLateralAreaPathData(tilt: number): string;
}

declare class VSMDedicatedProcess extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                width: string;
                height: string;
                stroke: string;
                strokeWidth: number;
                fill: string;
            };
            header: {
                width: string;
                height: number;
                stroke: string;
                strokeWidth: number;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    maxLineCount: number;
                    ellipsis: boolean;
                };
                x: string;
                y: number;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMSharedProcess extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                width: string;
                height: string;
                stroke: string;
                strokeWidth: number;
                fill: dia.SVGPatternJSON;
            };
            header: {
                width: string;
                height: number;
                stroke: string;
                strokeWidth: number;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    width: number;
                    maxLineCount: number;
                    ellipsis: boolean;
                };
                x: string;
                y: number;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}
interface VSMSubprocessAttributes extends dia.Element.Attributes {
    thickness: number;
}
declare class VSMSubprocess extends dia.Element<VSMSubprocessAttributes> {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        thickness: number;
        attrs: {
            body: {
                width: string;
                height: string;
                stroke: string;
                strokeWidth: number;
                fill: string;
            };
            stripes: {
                stroke: string;
                strokeWidth: number;
                fill: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                textWrap: {
                    height: number;
                    ellipsis: boolean;
                };
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    protected resetThickness(opt?: dia.Cell.Options): void;
}

interface VSMDataBoxAttributes extends dia.Element.Attributes {
    count?: number;
}
declare class VSMDataBox extends dia.Element<VSMDataBoxAttributes> {
    defaults(): {
        type: string;
        count: number;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                width: string;
                height: string;
            };
            boxes: {
                width: string;
                fill: string;
                stroke: string;
                strokeWidth: number;
            };
            labels: {
                text: string;
                x: string;
                textWrap: {
                    width: number;
                    ellipsis: boolean;
                };
                textVerticalAnchor: string;
                textAnchor: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
    initialize(): void;
    toJSON(): dia.Cell.JSON<any, VSMDataBoxAttributes>;
    protected getCleanedAttrs(): dia.Cell.Selectors;
    protected buildMarkup(opt?: dia.Cell.Options): void;
    setLabelAttr(index: number, attrs: attributes.SVGTextAttributes, opt?: dia.Cell.Options): void;
    setBoxAttr(index: number, attrs: attributes.SVGRectAttributes, opt?: dia.Cell.Options): void;
}

declare class VSMTruck extends dia.Element {
    defaults(): {
        type: string;
        size: {
            width: number;
            height: number;
        };
        attrs: {
            body: {
                strokeWidth: number;
                stroke: string;
                fill: string;
                refD: string;
            };
            background: {
                fill: string;
                refD: string;
            };
            label: {
                text: string;
                textVerticalAnchor: string;
                textAnchor: string;
                x: string;
                y: string;
                fontSize: number;
                fontFamily: string;
                fill: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMShipment extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinejoin: string;
                strokeLinecap: string;
                targetMarker: {
                    type: string;
                    d: string;
                };
            };
        };
    };
    preinitialize(): void;
}

declare class VSMMaterialFlow extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinejoin: string;
                strokeLinecap: string;
                targetMarker: {
                    type: string;
                    stroke: string;
                    'stroke-width': number;
                    d: string;
                };
            };
            outline: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinecap: string;
                strokeLinejoin: string;
            };
            material: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinecap: string;
                strokeLinejoin: string;
                strokeDasharray: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMInformationFlow extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinejoin: string;
                strokeLinecap: string;
                targetMarker: {
                    type: string;
                    stroke: string;
                    'stroke-width': number;
                    d: string;
                };
            };
            outline: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinecap: string;
                strokeLinejoin: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMElectronicInformationFlow extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinejoin: string;
                targetMarker: {
                    type: string;
                    d: string;
                };
            };
            wrapper: {
                connection: boolean;
                strokeWidth: number;
                strokeLinejoin: string;
            };
        };
    };
    preinitialize(): void;
}
declare class VSMElectronicInformationFlowView extends dia.LinkView {
    findPath(route: dia.Point[], sourcePoint: dia.Point, targetPoint: dia.Point): g.Path;
}

declare class VSMManualInfo extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeLinejoin: string;
                targetMarker: {
                    type: string;
                    d: string;
                };
            };
            wrapper: {
                connection: boolean;
                strokeWidth: number;
                strokeLinejoin: string;
            };
        };
    };
    preinitialize(): void;
}

declare class VSMPullArrow extends dia.Link {
    defaults(): {
        type: string;
        attrs: {
            line: {
                connection: boolean;
                stroke: string;
                strokeWidth: number;
                strokeDasharray: string;
                strokeLinejoin: string;
                targetMarker: {
                    type: string;
                    d: string;
                };
            };
            wrapper: {
                connection: boolean;
                strokeWidth: number;
                strokeLinejoin: string;
            };
        };
    };
    preinitialize(): void;
}

export { VSMCustomerSupplier, VSMDataBox, VSMDedicatedProcess, VSMElectronicInformationFlow, VSMElectronicInformationFlowView, VSMFIFOLane, VSMGoSee, VSMInformationFlow, VSMKaizenBurst, VSMKanbanPost, VSMLoadLevelling, VSMManualInfo, VSMMaterialBatchKanban, VSMMaterialFlow, VSMMaterialKanban, VSMMaterialPull, VSMOperator, VSMProductionBatchKanban, VSMProductionControl, VSMProductionKanban, VSMPullArrow, VSMResourcePlanning, VSMRoundedInventory, VSMSafetyStock, VSMSequencePullBall, VSMSharedProcess, VSMShipment, VSMSignalKanban, VSMSubprocess, VSMSupermarket, VSMSupermarketParts, VSMTimelineProcessing, VSMTimelineTotal, VSMTimelineWaiting, VSMTriangleInventory, VSMTruck, VSMWorkcell };
