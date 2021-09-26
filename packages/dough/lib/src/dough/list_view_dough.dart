import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dough.dart';
import 'dough_controller.dart';

/// Similar to [ListView], except it squishes when the user drags on it.
class ListViewDough extends StatefulWidget {
  /// Creates an instance of a [ListViewDough].
  const ListViewDough({
    Key? key,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  /// The direction of the scroll. Also determines the axis along which the
  /// [Dough] will stretch.
  final Axis scrollDirection;

  @override
  State<ListViewDough> createState() => _ListViewDoughState();
}

class _ListViewDoughState extends State<ListViewDough> {
  final scrollController = ScrollController();
  final doughController = DoughController();
  bool pressed = false;
  double squishOffset = 0;

  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.addListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    final topOffset = scrollController.offset;
    final botOffset =
        scrollController.offset - scrollController.position.maxScrollExtent;

    var squishOffset = 0.0;
    if (botOffset > 0) {
      squishOffset = botOffset;
    } else if (topOffset < 0) {
      squishOffset = topOffset;
    }

    syncState(squishOffset: squishOffset);
  }

  void syncState({
    bool? pressed,
    double? squishOffset,
  }) {
    if (pressed == this.pressed && squishOffset == this.squishOffset) {
      return;
    }

    if (pressed == true && !this.pressed) {
      doughController.start(
        origin: Offset.zero,
        target: Offset(0, this.squishOffset),
      );
    } else if (pressed == false && this.pressed) {
      doughController.stop();
    } else if (squishOffset != null && doughController.isActive) {
      doughController.update(
        origin: Offset.zero,
        target: Offset(0, squishOffset),
      );
    }

    setState(() {
      this.pressed = pressed ?? this.pressed;
      this.squishOffset = squishOffset ?? this.squishOffset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      itemBuilder: (context, index) => Container(
        height: 40,
        color: index % 2 == 0 ? Colors.red : Colors.blue,
      ),
      itemCount: 20,
      controller: scrollController,
    );

    final listener = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => syncState(pressed: true),
      onPointerUp: (_) => syncState(pressed: false),
      onPointerCancel: (_) => syncState(pressed: false),
      child: listView,
    );

    return Dough(
      controller: doughController,
      axis: widget.scrollDirection,
      child: listener,
    );
  }
}
