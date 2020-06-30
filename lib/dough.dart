library dough;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'dart:math' as math;
import 'dart:ui' as ui;

part 'status.dart';
part 'recipe.dart';
part 'controller.dart';
part 'utils.dart';

part 'widgets/pressable.dart';
part 'widgets/draggable.dart';

/// Squishes the provided [child] widget based on the provided
/// [controller] widget in a dough-like fashion.
class Dough extends StatefulWidget {
  /// The child to squish.
  final Widget child;

  /// The squish controller. You'll have to manage this yourself.
  final DoughController controller;

  const Dough({
    Key key,
    @required this.child,
    @required this.controller,
  }) : super(key: key);

  @override
  _DoughState createState() => _DoughState();
}

class _DoughState extends State<Dough> with SingleTickerProviderStateMixin {
  AnimationController _animCtrl;
  double _effectiveT;
  Curve _effectiveCurve;

  @override
  void initState() {
    super.initState();

    _effectiveT = 0.0;
    _effectiveCurve = null;

    _animCtrl = AnimationController(vsync: this)
      ..addListener(_onAnimCtrlUpdated)
      ..addStatusListener(_onAnimCtrlStatusUpdated);

    widget.controller
      ..addStatusListener(_onDoughCtrlStatusUpdated)
      ..addListener(_onDoughCtrlUpdated);

    Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl);
  }

  @override
  void dispose() {
    _animCtrl
      ..removeListener(_onAnimCtrlUpdated)
      ..removeStatusListener(_onAnimCtrlStatusUpdated)
      ..dispose();

    widget.controller
      ..removeStatusListener(_onDoughCtrlStatusUpdated)
      ..removeListener(_onDoughCtrlUpdated)
      ..dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Dough oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller
      ..removeListener(_onDoughCtrlUpdated)
      ..removeStatusListener(_onDoughCtrlStatusUpdated);

    widget.controller
      ..addListener(_onDoughCtrlUpdated)
      ..addStatusListener(_onDoughCtrlStatusUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.of(context);

    final delta = _VectorUtils.offsetToVector(widget.controller.delta);
    final deltaAngle = _VectorUtils.computeFullCirculeAngle(
      toDirection: delta,
      fromDirection: vmath.Vector2(1, 1),
    );

    final bendSize = delta.length / recipe.viscosity;
    final t = _effectiveT;

    // TODO use a homography here to scale non-uniformly?
    final scaleMagnitude = ui.lerpDouble(1, recipe.expansion, t);
    final scale = Matrix4.identity()
      ..scale(scaleMagnitude, scaleMagnitude, scaleMagnitude);

    final rotateTo = Matrix4.rotationZ(deltaAngle);

    final bend = Matrix4.columns(
      vmath.Vector4(1, t * bendSize, 0, 0),
      vmath.Vector4(t * bendSize, 1, 0, 0),
      vmath.Vector4(0, 0, 1, 0),
      vmath.Vector4(0, 0, 0, 1),
    )..transpose();

    final rotateBack = Matrix4.rotationZ(-deltaAngle);

    final translate = Matrix4.translationValues(
      delta.x * t / recipe.adhesion,
      delta.y * t / recipe.adhesion,
      0,
    );

    return Transform(
      alignment: Alignment.center,
      transform: translate * rotateBack * bend * rotateTo * scale,
      child: widget.child,
    );
  }

  void _onAnimCtrlUpdated() {
    setState(() {
      _effectiveT = _effectiveCurve.transform(_animCtrl.value);
    });
  }

  void _onAnimCtrlStatusUpdated(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.completed) {
        _effectiveT = _effectiveCurve.transform(1.0);
      }
    });
  }

  void _onDoughCtrlUpdated() {
    setState(() {});
  }

  void _onDoughCtrlStatusUpdated(DoughStatus status) {
    final recipe = DoughRecipe.of(context);

    setState(() {
      if (status == DoughStatus.started) {
        _effectiveCurve = recipe.entryCurve;
        _animCtrl.duration = recipe.entryDuration;

        _animCtrl
          ..stop()
          ..forward(from: _effectiveT);
      } else if (status == DoughStatus.stopped) {
        _effectiveCurve = recipe.exitCurve;
        _animCtrl.duration = recipe.exitDuration;

        _animCtrl
          ..stop()
          ..reverse(from: _effectiveT);
      } else {
        throw UnimplementedError(
          'Status ${status.toString()} not implemented!',
        );
      }
    });
  }
}
