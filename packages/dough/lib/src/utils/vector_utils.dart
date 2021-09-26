import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

/// A Vector utility class.
class VectorUtils {
  const VectorUtils._();

  /// Computes the angle between [toDirection] and [fromDirection],
  /// with the result ranging between 0 and 2π radians.
  static double computeFullCircleAngle({
    required vmath.Vector2 toDirection,
    vmath.Vector2? fromDirection,
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

  /// Converts an [Offset] to a [vmath.Vector2].
  static vmath.Vector2 offsetToVector(Offset offset) {
    return vmath.Vector2(offset.dx, offset.dy);
  }
}
