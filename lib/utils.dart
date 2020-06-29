part of dough;

class _VectorUtils {
  static double computeFullCirculeAngle({
    @required vmath.Vector2 toDirection,
    vmath.Vector2 fromDirection,
  }) {
    final a = fromDirection ?? vmath.Vector2(1, 0);
    final b = toDirection;

    final rawAngle = -a.angleToSigned(b);
    if (rawAngle < 0.0) {
      return 2 * math.pi + rawAngle;
    } else {
      return rawAngle;
    }
  }

  // static Offset vectorToOffset(vmath.Vector2 vector) {
  //   return Offset(vector.x, vector.y);
  // }

  static vmath.Vector2 offsetToVector(Offset offset) {
    return vmath.Vector2(offset.dx, offset.dy);
  }

  // static vmath.Vector2 lerp(
  //   vmath.Vector2 a,
  //   vmath.Vector2 b,
  //   double t,
  // ) {
  //   return vmath.Vector2(
  //     ui.lerpDouble(a.x, b.x, t),
  //     ui.lerpDouble(a.y, b.y, t),
  //   );
  // }
}
