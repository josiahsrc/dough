import { Component, Host, Prop, State, h } from '@stencil/core';

@Component({
  tag: 'dough-pressable',
  styleUrl: 'dough-pressable.scss',
  shadow: true,
})
export class DoughPressable {
  private startX: number = 0;
  private startY: number = 0;

  /**
   * The adhesion of the dough. The higher the number, the more the dough will stick to its original position.
   * @type {number}
   */
  @Prop() adhesion: number = 8;
  /**
   * The viscosity of the dough. The higher the number, the more the dough will resist movement.
   * @type {number}
   */
  @Prop() viscosity: number = 10;

  @State() active: boolean = false;
  @State() deltaX: number = 0;
  @State() deltaY: number = 0;

  onStart(e: MouseEvent | TouchEvent) {
    this.active = true;

    if (e instanceof MouseEvent) {
      this.startX = e.clientX;
      this.startY = e.clientY;
    } else {
      this.startX = e.touches[0].clientX;
      this.startY = e.touches[0].clientY;
    }

    // Add event listeners to the document
    document.addEventListener('mousemove', this.onMove.bind(this));
    document.addEventListener('mouseup', this.onEnd.bind(this));
    document.addEventListener('touchmove', this.onMove.bind(this));
    document.addEventListener('touchend', this.onEnd.bind(this));
  }

  onMove(e: MouseEvent | TouchEvent) {
    if (!this.active) return;

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
  }

  onEnd(_: MouseEvent | TouchEvent) {
    this.active = false;
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
    return (
      <Host onMouseDown={this.onStart.bind(this)} onTouchStart={this.onStart.bind(this)}>
        <dough-all-purpose-flour active={this.active} originX={0} originY={0} targetX={this.deltaX} targetY={this.deltaY} adhesion={this.adhesion} viscosity={this.viscosity}>
          <slot></slot>
        </dough-all-purpose-flour>
      </Host>
    );
  }
}
