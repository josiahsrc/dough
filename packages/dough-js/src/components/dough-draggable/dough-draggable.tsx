import { Component, Element, Host, Event, EventEmitter, Prop, State, h } from '@stencil/core';
import { Vec2 } from "../../utils/math";

const BREAK_DISTANCE: number = 50;

@Component({
  tag: 'dough-draggable',
  styleUrl: 'dough-draggable.scss',
  shadow: true,
})
export class DoughDraggable {
  @Element() el: HTMLElement;
  private startX: number = 0;
  private startY: number = 0;

  @Event() doughDragStart: EventEmitter<{ x: number, y: number }>;
  @Event() doughDragMove: EventEmitter<{ x: number, y: number }>;
  @Event() doughDragEnd: EventEmitter<{ x: number, y: number }>;

  /**
   * The adhesion of the dough. The higher the number, the more the dough will stick to its original position.
   * @type {number}
   */
  @Prop() adhesion: number = 4
  /**
   * The viscosity of the dough. The higher the number, the more the dough will resist movement.
   * @type {number}
   */
  @Prop() viscosity: number = 4

  @State() active: boolean = false;
  @State() deltaX: number = 0;
  @State() deltaY: number = 0;
  @State() detached: boolean = false;


  private onStart(e: MouseEvent | TouchEvent) {
    this.active = true;

    if (e instanceof MouseEvent) {
      this.startX = e.clientX;
      this.startY = e.clientY;
    } else {
      this.startX = e.touches[0].clientX;
      this.startY = e.touches[0].clientY;
    }

    document.addEventListener('mousemove', this.onMove.bind(this));
    document.addEventListener('mouseup', this.onEnd.bind(this));
    document.addEventListener('touchmove', this.onMove.bind(this));
    document.addEventListener('touchend', this.onEnd.bind(this));
  }

  private onMove(e: MouseEvent | TouchEvent) {
    if (!this.active)
      return;

    let x = 0;
    let y = 0;
    if (e instanceof MouseEvent) {
      x = e.clientX;
      y = e.clientY;
    } else {
      x = e.touches[0].clientX;
      y = e.touches[0].clientY;
    }

    this.deltaX = x - this.startX;
    this.deltaY = y - this.startY;

    const vect = new Vec2(this.deltaX, this.deltaY);
    const magnitude = vect.length;
    if (!this.detached && BREAK_DISTANCE * this.adhesion < magnitude) {
      this.el.classList.add('detached');
      this.detached = true;
      this.doughDragStart.emit({ x, y });
    }

    if (this.detached) {
      this.doughDragMove.emit({ x, y });
    }
  }

  private onEnd(e: MouseEvent | TouchEvent) {
    if (!this.active)
      return;

    if (e instanceof MouseEvent) {
      this.doughDragEnd.emit({ x: e.clientX, y: e.clientY });
    } else {
      this.doughDragEnd.emit({ x: e.changedTouches[0].clientX, y: e.changedTouches[0].clientY });
    }

    this.active = false;
    this.detached = false;
    this.el.classList.remove('detached');
    this.deltaX = 0;
    this.deltaY = 0;
    this.startX = 0;
    this.startY = 0;

    // Remove event listeners from the document
    document.removeEventListener('mousemove', this.onMove.bind(this));
    document.removeEventListener('mouseup', this.onEnd.bind(this));
    document.removeEventListener('touchmove', this.onMove.bind(this));
    document.removeEventListener('touchend', this.onEnd.bind(this));
  }

  render() {
    const translateX = this.detached ? this.deltaX : 0;
    const translateY = this.detached ? this.deltaY : 0;

    return (
      <Host onTouchStart={this.onStart.bind(this)} onMouseDown={this.onStart.bind(this)} style={{
        transform: `translate(${translateX}px, ${translateY}px)`
      }}>
        <dough-all-purpose-flour
          originX={0}
          originY={0}
          targetX={this.detached ? 0 : this.deltaX}
          targetY={this.detached ? 0 : this.deltaY}
          adhesion={this.adhesion}
          viscosity={this.viscosity}
        >
          <slot></slot>
        </dough-all-purpose-flour>
      </Host>
    );
  }
}
