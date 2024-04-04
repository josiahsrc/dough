import { Component, Host, Prop, State, Watch, h } from '@stencil/core';
import { Matrix4, Vec2, deg2rad } from "../../utils/math";

@Component({
  tag: 'dough-all-purpose-flour',
  styleUrl: 'dough-all-purpose-flour.scss',
  shadow: true,
})
export class DoughAllPurposeFlour {
  @State() matrix: Matrix4 = Matrix4.identity();
  @State() smoothDeltaX: number = 0;
  @State() smoothDeltaY: number = 0;
  private smoothDeltaXInterval: any;
  private smoothDeltaYInterval: any;
  /**
   * Set active to true when you want to manipulate the dough. Set to false when you want it to smooth back to its original position.
   * @type {boolean}
   */
  @Prop() active: boolean = false;
  @Watch('active') activeChanged() {
    clearInterval(this.smoothDeltaYInterval);
    clearInterval(this.smoothDeltaXInterval);
    if (!this.active) {
      this.smoothDeltaXChange();
      this.smoothDeltaYChange();
    }
  }
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

  /**
   * The origin X coordinate of the dough. This is the point that the dough will try to return to.
   * @type {number}
   */
  @Prop() originX: number = 0;
  @Watch('originX') originXChanged() {
    clearInterval(this.smoothDeltaXInterval);
    if (!this.active)
      this.smoothDeltaXChange();
    else
      this.updatePosition();
  }
  /**
   * The origin Y coordinate of the dough. This is the point that the dough will try to return to.
   * @type {number}
   */
  @Prop() originY: number = 0;
  @Watch('originY') originYChanged() {
    clearInterval(this.smoothDeltaYInterval);
    if (!this.active)
      this.smoothDeltaYChange();
    else
      this.updatePosition();
  }
  /**
   * The target X coordinate of the dough. This is the point that the dough will try to move to.
   * @type {number}
   */
  @Prop() targetX: number = 0;
  @Watch('targetX') targetXChanged() {
    clearInterval(this.smoothDeltaXInterval);
    if (!this.active)
      this.smoothDeltaXChange();
    else
      this.updatePosition();
  }
  /**
   * The target Y coordinate of the dough. This is the point that the dough will try to move to.
   * @type {number}
   */
  @Prop() targetY: number = 0;
  @Watch('targetY') targetYChanged() {
    clearInterval(this.smoothDeltaYInterval);
    if (!this.active)
      this.smoothDeltaYChange();
    else
      this.updatePosition();
  }


  smoothDeltaXChange() {
    this.smoothDeltaX = this.targetX - this.originX;
    // exponential decay of delta as a function of viscosity
    this.smoothDeltaXInterval = setInterval(() => {
      this.smoothDeltaX = this.smoothDeltaX * (1 - 1 / this.viscosity);
      console.log(this.smoothDeltaX);
      if (Math.abs(this.smoothDeltaX) < 0.01) {
        this.smoothDeltaX = 0;
        clearInterval(this.smoothDeltaXInterval);
      }
      this.updatePosition();
    }, 1000 / 60);
  }



  smoothDeltaYChange() {
    this.smoothDeltaY = this.targetY - this.originY;
    this.smoothDeltaYInterval = setInterval(() => {
      this.smoothDeltaY = this.smoothDeltaY * (1 - 1 / this.viscosity);
      if (Math.abs(this.smoothDeltaY) < 0.01) {
        this.smoothDeltaY = 0;
        clearInterval(this.smoothDeltaYInterval);
      }
      this.updatePosition();
    }, 1000 / 60);
  }




  connectedCallback() {
    this.updatePosition();
  }

  scaleNumber(input: number, inputRange: [number, number], outputRange: [number, number]): number {
    const [inputMin, inputMax] = inputRange;
    const [outputMin, outputMax] = outputRange;

    if (input < inputMin || input > inputMax) {
      throw new Error("Input is out of the input range!");
    }

    return ((input - inputMin) / (inputMax - inputMin)) * (outputMax - outputMin) + outputMin;
  }

  private updatePosition() {
    const STRECH_CAP = 100;

    const deltaX = this.active ? this.targetX - this.originX : this.smoothDeltaX
    const deltaY = this.active ? this.targetY - this.originY : this.smoothDeltaY
    const delta = new Vec2(deltaX, deltaY);

    const skewSize = this.scaleNumber((Math.min(STRECH_CAP, delta.length / this.viscosity)), [0, (STRECH_CAP)], [0, deg2rad(40)]);
    const deltaAngle = Vec2.fullCircleAngle(delta, new Vec2(1, 1));

    const skew = Matrix4.skew(skewSize, skewSize);
    const rotateToward = Matrix4.rotateZ(deltaAngle);
    const rotateAway = Matrix4.rotateZ(-deltaAngle);
    const squish = rotateToward.multiply(skew).multiply(rotateAway);
    const translate = Matrix4.translate(delta.x / this.adhesion, delta.y / this.adhesion, 0);
    this.matrix = translate.multiply(squish);
  }

  render() {
    return (
      <Host style={{ transform: this.matrix.toCssMatrix() }}>
        <slot></slot>
      </Host>
    );
  }
}
