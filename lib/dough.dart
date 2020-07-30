library dough;

import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

part 'transformer.dart';
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

  /// Manages when the [child] will smoosh around.
  final DoughController controller;

  /// The strategy for how to transform the [child]. This controls **how** the
  /// [child] gets smooshed. You can create your own transformers by inheriting
  /// from [DoughTransformer] or use one of the provided transformers. If no
  /// transformer is specified, a default transformer of type [BasicDoughTransformer]
  /// will be used.
  final DoughTransformer transformer;

  /// Creates a [Dough] widget.
  const Dough({
    Key key,
    @required this.child,
    @required this.controller,
    this.transformer,
  })  : assert(controller != null),
        assert(child != null),
        super(key: key);

  @override
  _DoughState createState() => _DoughState();
}

/// The state of a [Dough] widget which manages an animation controller
/// to gracefully transform a widget over time.
class _DoughState extends State<Dough> with SingleTickerProviderStateMixin {
  final _fallbackTransformer = BasicDoughTransformer();

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

    // If the controller was active on start, inform this widget that it
    // should start squishing (as soon as the context is usable).
    if (widget.controller.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.controller.isActive) {
          _onDoughCtrlStatusUpdated(widget.controller.status);
        }
      });
    }
  }

  @override
  void dispose() {
    _animCtrl
      ..removeListener(_onAnimCtrlUpdated)
      ..removeStatusListener(_onAnimCtrlStatusUpdated)
      ..dispose();

    widget.controller
      ..removeStatusListener(_onDoughCtrlStatusUpdated)
      ..removeListener(_onDoughCtrlUpdated);

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
    final controller = widget.controller;
    final delta = _VectorUtils.offsetToVector(controller.delta);
    final deltaAngle = _VectorUtils.computeFullCircleAngle(
      toDirection: delta,
      fromDirection: vmath.Vector2(1, 1),
    );

    // Provide the transformer with details on how to squish the child widget.
    final effTrfm = widget.transformer ?? _fallbackTransformer;
    effTrfm._rawT = _animCtrl.value;
    effTrfm._t = _effectiveT;
    effTrfm._recipe = recipe;
    effTrfm._origin = _VectorUtils.offsetToVector(controller.origin);
    effTrfm._target = _VectorUtils.offsetToVector(controller.target);
    effTrfm._delta = delta;
    effTrfm._deltaAngle = deltaAngle;
    effTrfm._controller = controller;

    return Transform(
      alignment: Alignment.center,
      transform: effTrfm.createDoughMatrix(),
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
