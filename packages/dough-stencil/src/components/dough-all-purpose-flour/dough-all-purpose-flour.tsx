import { Component, Host, Prop, State, Watch, h } from '@stencil/core';
import { Matrix4, Vec2, deg2rad } from "../../utils/math";

@Component({
  tag: 'dough-all-purpose-flour',
  styleUrl: 'dough-all-purpose-flour.scss',
  shadow: true,
})
export class DoughAllPurposeFlour {
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
    this.updatePosition();
  }
  /**
   * The origin Y coordinate of the dough. This is the point that the dough will try to return to.
   * @type {number}
   */
  @Prop() originY: number = 0;
  @Watch('originY') originYChanged() {
    this.updatePosition();
  }
  /**
   * The target X coordinate of the dough. This is the point that the dough will try to move to.
   * @type {number}
   */
  @Prop() targetX: number = 0;
  @Watch('targetX') targetXChanged() {
    this.updatePosition();
  }
  /**
   * The target Y coordinate of the dough. This is the point that the dough will try to move to.
   * @type {number}
   */
  @Prop() targetY: number = 0;
  @Watch('targetY') targetYChanged() {
    this.updatePosition();
  }

  @State() matrix: Matrix4 = Matrix4.identity();

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

    const deltaX = this.targetX - this.originX;
    const deltaY = this.targetY - this.originY;
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
