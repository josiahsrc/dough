library dough;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

part 'status.dart';
part 'recipe.dart';
part 'recipe_data.dart';
part 'controller.dart';
part 'utils.dart';

class Dough extends StatefulWidget {
  final Widget child;
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
  double _lerpTime;
  Curve _lerpCurve;

  @override
  void initState() {
    super.initState();

    _lerpTime = 0.0;
    _lerpCurve = null;

    _animCtrl = AnimationController(vsync: this);
    _animCtrl.addListener(_onAnimCtrlUpdated);
    _animCtrl.addStatusListener(_onAnimCtrlStatusUpdated);

    widget.controller.addStatusListener(_onDoughCtrlStatusUpdated);
    widget.controller.addListener(_onDoughCtrlUpdated);

    Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl);
  }

  @override
  void dispose() {
    super.dispose();

    _animCtrl.removeListener(_onAnimCtrlUpdated);
    _animCtrl.removeStatusListener(_onAnimCtrlStatusUpdated);
    _animCtrl.dispose();

    widget.controller.removeStatusListener(_onDoughCtrlStatusUpdated);
    widget.controller.removeListener(_onDoughCtrlUpdated);
  }

  @override
  void didUpdateWidget(covariant Dough oldWidget) {
    super.didUpdateWidget(oldWidget);

    oldWidget.controller.removeListener(_onDoughCtrlUpdated);
    oldWidget.controller.removeStatusListener(_onDoughCtrlStatusUpdated);

    widget.controller.addListener(_onDoughCtrlUpdated);
    widget.controller.addStatusListener(_onDoughCtrlStatusUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.of(context);

    throw UnimplementedError();
  }

  void _onAnimCtrlUpdated() {
    setState(() {
      _lerpTime = _lerpCurve.transform(_animCtrl.value);
    });
  }

  void _onAnimCtrlStatusUpdated(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.completed) {
        _lerpTime = _lerpCurve.transform(1.0);
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
        _lerpCurve = recipe.entryCurve;
        _animCtrl.duration = recipe.entryDuration;

        _animCtrl.stop();
        _animCtrl.forward(from: _lerpTime);
      } else if (status == DoughStatus.started) {
        _lerpCurve = recipe.exitCurve;
        _animCtrl.duration = recipe.exitDuration;

        _animCtrl.stop();
        _animCtrl.reverse(from: _lerpTime);
      } else {
        throw UnimplementedError();
      }
    });
  }
}
