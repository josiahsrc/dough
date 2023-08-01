import { Vec2 } from './math';

describe('vec2dAngleToSigned', () => {
  it('returns the signed angle between two vectors', () => {
    expect(Vec2.signedAngle(new Vec2(1, 0), new Vec2(0, 1))).toBeCloseTo(Math.PI / 2);
    expect(Vec2.signedAngle(new Vec2(0, 1), new Vec2(1, 0))).toBeCloseTo(-Math.PI / 2);
    expect(Vec2.signedAngle(new Vec2(1, 0), new Vec2(-1, 0))).toBeCloseTo(Math.PI);
    expect(Vec2.signedAngle(new Vec2(1, 0), new Vec2(1, 0))).toBeCloseTo(0);
  });
});
