library dough;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'dart:math' as math;

part 'recipe.dart';

class Dough extends StatelessWidget {
  final Widget child;

  const Dough({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
