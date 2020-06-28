library dough;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

part 'status.dart';
part 'recipe.dart';
part 'recipe_data.dart';
part 'controller.dart';
part 'utils.dart';

class Dough extends StatelessWidget {
  final Widget child;

  const Dough({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.of(context);

    throw UnimplementedError();
  }
}
