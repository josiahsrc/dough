var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __rest = (this && this.__rest) || function (s, e) {
    var t = {};
    for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p) && e.indexOf(p) < 0)
        t[p] = s[p];
    if (s != null && typeof Object.getOwnPropertySymbols === "function")
        for (var i = 0, p = Object.getOwnPropertySymbols(s); i < p.length; i++) {
            if (e.indexOf(p[i]) < 0 && Object.prototype.propertyIsEnumerable.call(s, p[i]))
                t[p[i]] = s[p[i]];
        }
    return t;
};
import React from 'react';
import ReactDOM from 'react-dom';
import { attachProps, dashToPascalCase, defineCustomElement, setRef } from './utils';
export const createOverlayComponent = (tagName, controller, customElement) => {
    defineCustomElement(tagName, customElement);
    const displayName = dashToPascalCase(tagName);
    const didDismissEventName = `on${displayName}DidDismiss`;
    const didPresentEventName = `on${displayName}DidPresent`;
    const willDismissEventName = `on${displayName}WillDismiss`;
    const willPresentEventName = `on${displayName}WillPresent`;
    let isDismissing = false;
    class Overlay extends React.Component {
        constructor(props) {
            super(props);
            if (typeof document !== 'undefined') {
                this.el = document.createElement('div');
            }
            this.handleDismiss = this.handleDismiss.bind(this);
        }
        static get displayName() {
            return displayName;
        }
        componentDidMount() {
            if (this.props.isOpen) {
                this.present();
            }
        }
        componentWillUnmount() {
            if (this.overlay) {
                this.overlay.dismiss();
            }
        }
        handleDismiss(event) {
            if (this.props.onDidDismiss) {
                this.props.onDidDismiss(event);
            }
            setRef(this.props.forwardedRef, null);
        }
        shouldComponentUpdate(nextProps) {
            if (this.overlay && nextProps.isOpen !== this.props.isOpen && nextProps.isOpen === false) {
                isDismissing = true;
            }
            return true;
        }
        componentDidUpdate(prevProps) {
            return __awaiter(this, void 0, void 0, function* () {
                if (this.overlay) {
                    attachProps(this.overlay, this.props, prevProps);
                }
                if (prevProps.isOpen !== this.props.isOpen && this.props.isOpen === true) {
                    this.present(prevProps);
                }
                if (this.overlay && prevProps.isOpen !== this.props.isOpen && this.props.isOpen === false) {
                    yield this.overlay.dismiss();
                    isDismissing = false;
                    this.forceUpdate();
                }
            });
        }
        present(prevProps) {
            return __awaiter(this, void 0, void 0, function* () {
                const _a = this.props, { children, isOpen, onDidDismiss, onDidPresent, onWillDismiss, onWillPresent } = _a, cProps = __rest(_a, ["children", "isOpen", "onDidDismiss", "onDidPresent", "onWillDismiss", "onWillPresent"]);
                const elementProps = Object.assign(Object.assign({}, cProps), { ref: this.props.forwardedRef, [didDismissEventName]: this.handleDismiss, [didPresentEventName]: (e) => this.props.onDidPresent && this.props.onDidPresent(e), [willDismissEventName]: (e) => this.props.onWillDismiss && this.props.onWillDismiss(e), [willPresentEventName]: (e) => this.props.onWillPresent && this.props.onWillPresent(e) });
                this.overlay = yield controller.create(Object.assign(Object.assign({}, elementProps), { component: this.el, componentProps: {} }));
                setRef(this.props.forwardedRef, this.overlay);
                attachProps(this.overlay, elementProps, prevProps);
                yield this.overlay.present();
            });
        }
        render() {
            return ReactDOM.createPortal(this.props.isOpen || isDismissing ? this.props.children : null, this.el);
        }
    }
    return React.forwardRef((props, ref) => {
        return React.createElement(Overlay, Object.assign({}, props, { forwardedRef: ref }));
    });
};
//# sourceMappingURL=createOverlayComponent.js.map