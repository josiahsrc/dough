export declare const attachProps: (node: HTMLElement, newProps: any, oldProps?: any) => void;
export declare const getClassName: (classList: DOMTokenList, newProps: any, oldProps: any) => string;
export declare const transformReactEventName: (eventNameSuffix: string) => string;
export declare const isCoveredByReact: (eventNameSuffix: string) => boolean;
export declare const syncEvent: (node: Element & {
    __events?: {
        [key: string]: (e: Event) => any;
    };
}, eventName: string, newEventHandler?: (e: Event) => any) => void;
