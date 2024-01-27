import 'package:dough/utils.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

import 'dough_controller.dart';
import 'dough_recipe.dart';
import 'dough_transformer.dart';

/// Squishes the provided [child] widget based on the provided
/// [controller] widget in a dough-like fashion.
class Dough extends StatefulWidget {
  /// Creates a [Dough] widget.
  const Dough({
    Key? key,
    required this.child,
    required this.controller,
    this.transformer,
    this.axis,
  }) : super(key: key);

  /// The child to squish.
  final Widget child;

  /// Manages when the [child] will smoosh around.
  final DoughController controller;

  /// The strategy for how to transform the [child]. This controls **how**
  /// the [child] gets smooshed. You can create your own transformers by
  /// inheriting from [DoughTransformer] or use one of the provided
  /// transformers. If no transformer is specified, a default transformer
  /// of type [BasicDoughTransformer] will be used.
  final DoughTransformer? transformer;

  /// The axis on which to constrain any stretching. If no axis is specified,
  /// the [Dough] will not be constrained to any access.
  ///
  /// **Note that this feature is still under development.**
  final Axis? axis;

  @override
  DoughState createState() => DoughState();
}

/// The state of a [Dough] widget which manages an animation controller
/// to gracefully transform a widget over time.
class DoughState extends State<Dough> with SingleTickerProviderStateMixin {
  /// A fallback [DoughTransformer] which will be used if none is specified.
  /// This is not static because it's values are modified based on the state
  /// of this widget.
  final _fallbackTransformer = BasicDoughTransformer();

  /// The controller to drive the squish animation.
  late AnimationController _animCtrl;

  /// The current normalized time into the squish animation.
  double _effectiveT = 0;

  /// The curve along which the squish will animate.
  Curve _effectiveCurve = Curves.linear;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(vsync: this)
      ..addListener(_onAnimCtrlUpdated)
      ..addStatusListener(_onAnimCtrlStatusUpdated);

    widget.controller
      ..addStatusListener(_onDoughCtrlStatusUpdated)
      ..addListener(_onDoughCtrlUpdated);

    Tween<double>(begin: 0, end: 1).animate(_animCtrl);

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

    final lastController = oldWidget.controller;
    final nextController = widget.controller;

    lastController
      ..removeListener(_onDoughCtrlUpdated)
      ..removeStatusListener(_onDoughCtrlStatusUpdated);

    nextController
      ..addListener(_onDoughCtrlUpdated)
      ..addStatusListener(_onDoughCtrlStatusUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.watch(context);
    final controller = widget.controller;
    final axis = widget.axis;
    final delta = VectorUtils.offsetToVector(controller.delta);
    final effTrfm = widget.transformer ?? _fallbackTransformer;
    final deltaAngle = VectorUtils.computeFullCircleAngle(
      toDirection: delta,
      fromDirection: vmath.Vector2(1, 1),
    );

    final tContext = DoughTransformerContext(
      rawT: _animCtrl.value,
      t: _effectiveT,
      recipe: recipe,
      origin: VectorUtils.offsetToVector(controller.origin),
      target: VectorUtils.offsetToVector(controller.target),
      delta: delta,
      deltaAngle: deltaAngle,
      controller: controller,
      axis: axis,
    );

    // Run the transform life-cycle.
    effTrfm.onPreTransform(tContext);
    final transform = effTrfm.transform(tContext);
    effTrfm.onPostTransform(tContext);

    return Transform(
      alignment: Alignment.center,
      transform: transform,
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
        _effectiveT = _effectiveCurve.transform(1);
      }
    });
  }

  void _onDoughCtrlUpdated() {
    setState(() {});
  }

  void _onDoughCtrlStatusUpdated(DoughStatus status) {
    final recipe = DoughRecipe.read(context);

    setState(() {
      if (status == DoughStatus.started) {
        _effectiveCurve = recipe.entryCurve;
        _animCtrl
          ..duration = recipe.entryDuration
          ..stop()
          ..forward(from: _effectiveT);
      } else if (status == DoughStatus.stopped) {
        _effectiveCurve = recipe.exitCurve;
        _animCtrl
          ..duration = recipe.exitDuration
          ..stop()
          ..reverse(from: _effectiveT);
      } else {
        throw UnimplementedError('Status $status not implemented.');
      }
    });
  }
}
