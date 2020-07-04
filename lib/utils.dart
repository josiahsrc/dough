part of dough;

class _VectorUtils {
  /// Computes the angle between [toDirection] and [fromDirection],
  /// with the result ranging between 0 and 2PI radians.
  static double computeFullCircleAngle({
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

  /// Converts an [Offset] to a [Vector2].
  static vmath.Vector2 offsetToVector(Offset offset) {
    return vmath.Vector2(offset.dx, offset.dy);
  }

  // static Offset vectorToOffset(vmath.Vector2 vector) {
  //   return Offset(vector.x, vector.y);
  // }
  //
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
