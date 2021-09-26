// ignore_for_file: prefer_const_constructors, prefer_int_literals, curly_braces_in_flow_control_structures, unused_import

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import 'dough.dart';
import 'dough_controller.dart';
import 'dough_recipe.dart';
import 'dough_transformer.dart';

/// Similar to [ListView], except that it squishes when the user scrolls.
class ListViewDough extends StatefulWidget {
  /// Creates an instance of a [ListViewDough].
  const ListViewDough({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.physics,
  }) : super(key: key);

  /// The direction of the scroll. Also determines the axis along which the
  /// [Dough] will stretch.
  final Axis scrollDirection;

  /// The scroll physics overrides to apply to the [ListViewDough].
  final ScrollPhysics? physics;

  @override
  State<ListViewDough> createState() => _ListViewDoughState();
}

class _ListViewDoughState extends State<ListViewDough> {
  final _scrollController = ScrollController();
  final _doughController = DoughController();
  bool _pressed = false;
  double _squishOffset = 0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _doughController.addListener(_onDoughChanged);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _doughController.removeListener(_onDoughChanged);
    super.dispose();
  }

  void _onScroll() {
    final topOffset = _scrollController.offset;
    final botOffset =
        _scrollController.offset - _scrollController.position.maxScrollExtent;

    var squishOffset = 0.0;
    if (botOffset > 0) {
      squishOffset = botOffset;
    } else if (topOffset < 0) {
      squishOffset = topOffset;
    }

    _syncState(squishOffset: squishOffset);
  }

  void _onDoughChanged() {}

  void _syncState({
    bool? pressed,
    double? squishOffset,
  }) {
    final recipe = DoughRecipe.of(context, listen: false);
    if (pressed == _pressed && squishOffset == _squishOffset) {
      return;
    }

    if (pressed == true && !_pressed) {
      _doughController.start(
        origin: Offset.zero,
        target: Offset(0, _squishOffset),
      );
    } else if (pressed == false && _pressed) {
      _doughController.stop();
      final offset = squishOffset ?? _squishOffset;
      // if (offset != 0) {
      //   _scrollController.animateTo(
      //     offset > 0 ? _scrollController.position.maxScrollExtent : 0,
      //     duration: recipe.exitDuration, // Duration(milliseconds: 500), // TODO
      //     curve: Curves.elasticOut, // TODO
      //   );
      // }
    } else if (squishOffset != null && _doughController.isActive) {
      _doughController.update(
        origin: Offset.zero,
        target: Offset(0, squishOffset),
      );
    }

    setState(() {
      _pressed = pressed ?? _pressed;
      _squishOffset = squishOffset ?? _squishOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      itemBuilder: (context, index) => Container(
        height: 40,
        color: index % 2 == 0 ? Colors.white12 : Colors.white,
        child: Center(child: Text('Element $index')),
      ),
      itemCount: 20,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      controller: _scrollController,
    );

    final notifs = NotificationListener<ScrollNotification>(
      onNotification: (notif) {
        // if (notif is OverscrollNotification) {
        //   print('Overfl: ${notif.dragDetails?.delta}');
        // }
        // if (notif is ScrollUpdateNotification) {
        //   print('Update: ${notif.dragDetails?.delta}');
        // } 
        print('Scroll ${notif.runtimeType} at ${DateTime.now()}');

        // print(DateTime.now());
        // print(notif.runtimeType);
        // if (notif is ScrollUpdateNotification) {
        //   print(notif.dragDetails?.delta);
        // } else if (notif is OverscrollNotification) {
        //   print(notif.overscroll);
        // }
        return false;
      },
      child: listView,
    );

    final listener = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _syncState(pressed: true),
      onPointerUp: (_) => _syncState(pressed: false),
      onPointerCancel: (_) => _syncState(pressed: false),
      child: notifs,
    );

    return listener;

    // return Dough(
    //   controller: _doughController,
    //   axis: widget.scrollDirection,
    //   alignment: Alignment.bottomCenter,
    //   child: listener,
    // );
  }
}

// SOLUTION
// - Listen to drag inputs on the scroll view.
// - From drag release, calculate velocity and apply squishy momentum 
// when borders are reached.
// - Clamp physics to not exceed bounds
// - Compute elastic potential using the spring solution

// THIS IS WHY CLAMPING THE PHSYICS BETWEEEN START AND END DOESNT WORK
// - The clamped physics will prevent the scroll from passing the edges of the
// screen. This means that scroll notifcations aren't passed to the widget
// when the scroll has completed.
// - ***Can't rely on scroll notifcations***

// THIS IS WHY SIMUALTION DOESN'T WORK:
// - The simulation controls the X position
// - The physics controlls the boundary conditions. Meaning that the simulation
// has no say over what the X position is until the simulation has started
// (after the user releases).
// - This means that if we want the list dough to clamp the scroll view
// in between the bounds, then no values will be applied to the simulation,
// so the simulation becomes meaningless.

class _Sim extends SpringSimulation {
  _Sim({
    required SpringDescription spring,
    required this.start,
    required this.end,
    required double velocity,
    Tolerance tolerance = Tolerance.defaultTolerance,
  })  : _xSim = start,
        super(
          spring,
          start,
          end,
          velocity,
          tolerance: tolerance,
        );

  final double start;
  final double end;

  double _xSim;
  double get position => _xSim;

  @override
  double x(double time) {
    _xSim = super.x(time);
    return end;
  }

  @override
  bool isDone(double time) {
    return _xSim == end;
  }
}

class _Phys extends ScrollPhysics {
  const _Phys({ScrollPhysics? parent}) : super(parent: parent);

  @override
  _Phys applyTo(ScrollPhysics? ancestor) {
    return _Phys(parent: buildParent(ancestor));
  }

  // @override
  // double applyBoundaryConditions(ScrollMetrics position, double value) {
  //   if (value < position.pixels &&
  //       position.pixels <= position.minScrollExtent) {
  //     return value - position.pixels;
  //   }

  //   if (position.maxScrollExtent <= position.pixels &&
  //       position.pixels < value) {
  //     return value - position.pixels;
  //   }

  //   if (value < position.minScrollExtent &&
  //       position.minScrollExtent < position.pixels) {
  //     return value - position.minScrollExtent;
  //   }

  //   if (position.pixels < position.maxScrollExtent &&
  //       position.maxScrollExtent < value) {
  //     return value - position.maxScrollExtent;
  //   }

  //   return 0;
  // }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if (position.outOfRange) {
      double? end;
      if (position.pixels > position.maxScrollExtent)
        end = position.maxScrollExtent;
      if (position.pixels < position.minScrollExtent)
        end = position.minScrollExtent;

      return _Sim(
        spring: spring,
        start: position.pixels,
        end: end!,
        velocity: math.min(0.0, velocity),
        tolerance: tolerance,
      );
    }

    if (parent != null) {
      return parent!.createBallisticSimulation(
        position,
        velocity,
      );
    }

    return super.createBallisticSimulation(
      position,
      velocity,
    );
  }
}
