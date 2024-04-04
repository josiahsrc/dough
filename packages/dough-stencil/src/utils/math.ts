export function deg2rad(deg: number): number {
  return deg * (Math.PI / 180);
}

export function rad2deg(rad: number): number {
  return rad * (180 / Math.PI);
}

export class Vec2 {
  private _x: number;
  private _y: number;

  constructor(x: number, y: number) {
    this._x = x;
    this._y = y;
  }

  get x(): number {
    return this._x;
  }

  get y(): number {
    return this._y;
  }

  static zero(): Vec2 {
    return new Vec2(0, 0);
  }

  get length(): number {
    return Math.sqrt(this.x ** 2 + this.y ** 2);
  }

  static signedAngle(a: Vec2, b: Vec2): number {
    return Math.atan2(b.y, b.x) - Math.atan2(a.y, a.x);
  }

  static fullCircleAngle(target: Vec2, source?: Vec2): number {
    const a = source ?? new Vec2(1, 0);
    const b = target;
    const rawAngle = Vec2.signedAngle(a, b);
    if (rawAngle < 0.0) {
      return 2 * Math.PI + rawAngle;
    } else {
      return rawAngle;
    }
  }
}

export class Matrix4 {
  private elements: number[];

  constructor(values: number[][]) {
    this.elements = new Array<number>(16);
    for (let row = 0; row < 4; ++row) {
      for (let col = 0; col < 4; ++col) {
        this.set(row, col, values[row][col]);
      }
    }
  }

  static zero(): Matrix4 {
    return new Matrix4([
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ]);
  }

  static identity(): Matrix4 {
    return new Matrix4([
      [1, 0, 0, 0],
      [0, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1],
    ]);
  }

  static skew(alphaRadians: number, betaRadians: number): Matrix4 {
    const a = Math.tan(alphaRadians);
    const b = Math.tan(betaRadians);
    return new Matrix4([
      [1, a, 0, 0],
      [b, 1, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 1, 1],
    ]);
  }

  static scale(x: number, y: number, z: number): Matrix4 {
    return new Matrix4([
      [x, 0, 0, 0],
      [0, y, 0, 0],
      [0, 0, z, 0],
      [0, 0, 1, 1],
    ]);
  }

  static translate(x: number, y: number, z: number): Matrix4 {
    return new Matrix4([
      [1, 0, 0, x],
      [0, 1, 0, y],
      [0, 0, 1, z],
      [0, 0, 1, 1],
    ]);
  }

  static translateVec2(vec: Vec2): Matrix4 {
    return Matrix4.translate(vec.x, vec.y, 0);
  }

  static rotateZ(radians: number): Matrix4 {
    const cos = Math.cos(radians);
    const sin = Math.sin(radians);
    return new Matrix4([
      [cos, -sin, 0, 0],
      [sin, cos, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 1, 1],
    ]);
  }

  get(row: number, col: number): number {
    if (row < 0 || row > 3 || col < 0 || col > 3) {
      throw new Error('Matrix4 indices are out of range');
    }
    return this.elements[col * 4 + row];
  }

  private set(row: number, col: number, value: number): void {
    if (row < 0 || row > 3 || col < 0 || col > 3) {
      throw new Error('Matrix4 indices are out of range');
    }
    this.elements[col * 4 + row] = value;
  }

  multiply(other: Matrix4): Matrix4 {
    const result = Matrix4.zero();

    for (let row = 0; row < 4; ++row) {
      for (let col = 0; col < 4; ++col) {
        let sum = 0;
        for (let k = 0; k < 4; ++k) {
          sum += this.get(row, k) * other.get(k, col);
        }
        result.set(row, col, sum);
      }
    }

    return result;
  }

  toCssMatrix(): string {
    return `matrix3d(${this.elements.join(',')})`;
  }
}
