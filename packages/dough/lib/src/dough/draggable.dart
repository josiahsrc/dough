// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dough.dart';
import 'dough_controller.dart';
import 'dough_recipe.dart';
import 'dough_transformer.dart';
import 'draggable_recipe.dart';

/// A widget which mimics the behavior of Flutter's [Draggable] widget, only
/// this one is squishy! For details on what each field does for this widget,
/// view [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html)
/// for the [Draggable] widget.
class DraggableDough<T extends Object> extends StatefulWidget {
  /// Creates a [DraggableDough] widget.
  const DraggableDough({
    super.key,
    this.prefs,
    this.onDoughBreak,
    required this.child,
    required this.feedback,
    this.data,
    this.axis,
    this.childWhenDragging,
    this.feedbackOffset = Offset.zero,
    this.dragAnchorStrategy = childDragAnchorStrategy,
    this.affinity,
    this.maxSimultaneousDrags,
    this.onDragStarted,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.ignoringFeedbackSemantics = true,
    this.longPress = false,
  }) : assert(maxSimultaneousDrags == null || maxSimultaneousDrags >= 0);

  /// Preferences for the behavior of this [DraggableDough] widget. This can
  /// be specified here or in the context of a [DoughRecipe] widget. This will
  /// override the contextual [DoughRecipeData.draggablePrefs] if provided.
  final DraggableDoughPrefs? prefs;

  /// A callback raised when the user drags the feedback widget beyond the
  /// [DraggableDoughPrefs.breakDistance] and the [Dough] snaps back into
  /// its original form.
  final VoidCallback? onDoughBreak;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final T? data;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Axis? axis;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget child;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget? childWhenDragging;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget feedback;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Offset feedbackOffset;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DragAnchorStrategy dragAnchorStrategy;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final bool ignoringFeedbackSemantics;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Axis? affinity;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final int? maxSimultaneousDrags;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final VoidCallback? onDragStarted;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DraggableCanceledCallback? onDraggableCanceled;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final VoidCallback? onDragCompleted;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DragEndCallback? onDragEnd;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/LongPressDraggable-class.html).
  ///
  /// **NOTE:** There is a known issue where, if enabled, the [onDoughBreak]
  /// callback will still be triggered, even if the draggable widget
  /// does not become visible. This behavior will be fixed in a future
  /// update, but it will be a breaking change.
  final bool longPress;

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

/// The state of a [DraggableDough] widget which controls how the [Dough] morphs
/// as the feedback is dragged around.
class _DraggableDoughState<T extends Object> extends State<DraggableDough<T>> {
  final _controllerTracker = _DragControllerTracker();

  @override
  void initState() {
    super.initState();
    _controllerTracker.reset();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerTracker.reset();
  }

  @override
  void didUpdateWidget(covariant DraggableDough<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controllerTracker.reset();
  }

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.watch(context);
    final prefs = widget.prefs ?? recipe.draggablePrefs;

    // The feedback widget won't share the same context once the [Draggable]
    // widget instantiates it as an overlay. The [DoughRecipe] has to be copied
    // directly so it will exist in the overlay's context as well.
    final doughFeedback = DoughRecipe(
      data: recipe,
      child: _DragFeedback(
        controllerTracker: _controllerTracker,
        child: widget.feedback,
      ),
    );

    Widget draggable;
    if (widget.longPress) {
      draggable = LongPressDraggable<T>(
        feedback: doughFeedback,
        data: widget.data,
        axis: widget.axis,
        childWhenDragging: widget.childWhenDragging,
        feedbackOffset: widget.feedbackOffset,
        dragAnchorStrategy: widget.dragAnchorStrategy,
        maxSimultaneousDrags: widget.maxSimultaneousDrags,
        ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
        onDraggableCanceled: widget.onDraggableCanceled,
        onDragEnd: widget.onDragEnd,
        onDragCompleted: widget.onDragCompleted,
        onDragStarted: widget.onDragStarted,
        child: widget.child,
      );
    } else {
      draggable = Draggable<T>(
        feedback: doughFeedback,
        data: widget.data,
        axis: widget.axis,
        childWhenDragging: widget.childWhenDragging,
        feedbackOffset: widget.feedbackOffset,
        dragAnchorStrategy: widget.dragAnchorStrategy,
        affinity: widget.affinity,
        maxSimultaneousDrags: widget.maxSimultaneousDrags,
        ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
        onDraggableCanceled: widget.onDraggableCanceled,
        onDragEnd: widget.onDragEnd,
        onDragCompleted: widget.onDragCompleted,
        onDragStarted: widget.onDragStarted,
        child: widget.child,
      );
    }

    return Listener(
      onPointerDown: (event) {
        _controllerTracker.enqueueHintControllerID(event.pointer);
        _controllerTracker.initController(event.pointer).start(
              origin: event.position,
              target: event.position,
            );
      },
      onPointerMove: (event) {
        // This should never happen. But just in case, be safe.
        if (!_controllerTracker.containsController(event.pointer)) {
          return;
        }

        final controller = _controllerTracker.getcontroller(event.pointer);
        if (controller.isActive) {
          final sqrBreakThresh = prefs.breakDistance * prefs.breakDistance;
          if (controller.delta.distanceSquared > sqrBreakThresh) {
            controller.stop();
            widget.onDoughBreak?.call();
            if (prefs.useHapticsOnBreak) {
              HapticFeedback.selectionClick();
            }
          } else {
            controller.update(
              target: event.position,
            );
          }
        }
      },
      onPointerUp: (event) {
        if (_controllerTracker.containsController(event.pointer)) {
          _controllerTracker.tearDownController(event.pointer);
        }
      },
      onPointerCancel: (event) {
        if (_controllerTracker.containsController(event.pointer)) {
          _controllerTracker.tearDownController(event.pointer);
        }
      },
      child: draggable,
    );
  }
}

/// A helper drag feedback widget which maintains a pointer ID to control
/// the Dough.
class _DragFeedback extends StatefulWidget {
  /// Creates a [_DragFeedback] widget.
  const _DragFeedback({
    Key? key,
    required this.controllerTracker,
    required this.child,
  }) : super(key: key);

  /// The widget being dragged.
  final Widget child;

  /// A reference to track pointer IDs.
  final _DragControllerTracker controllerTracker;

  @override
  _DragFeedbackState createState() => _DragFeedbackState();
}

/// The state of a [_DragFeedback] widget.
class _DragFeedbackState extends State<_DragFeedback> {
  late int _controllerID;

  @override
  void initState() {
    super.initState();

    // Save the next hint to determine which controller to bind to.
    assert(widget.controllerTracker.hasHintControllerID);
    _controllerID = widget.controllerTracker.dequeueHintControllerID();
  }

  @override
  Widget build(BuildContext context) {
    return Dough(
      controller: widget.controllerTracker.getcontroller(_controllerID),
      transformer: DraggableOverlayDoughTransformer(
        snapToTargetOnStop: true,
        applyDelta: true,
      ),
      child: widget.child,
    );
  }
}

/// A helper class to keep track of various dough controllers based on
/// the pointer IDs they're associated with when being dragged.
class _DragControllerTracker {
  final _controllers = <int, DoughController>{};
  final _hintControllerIDs = ListQueue<int>();

  /// Whether a hint controller was specified.
  bool get hasHintControllerID => !_hintControllerIDs.isEmpty;

  /// Enqueues an [id] to hint at the [DoughController] that the next
  /// [_DragFeedback] widget should use when smooshing the dough.
  void enqueueHintControllerID(int id) {
    _hintControllerIDs.addLast(id);
  }

  /// Dequeues an `id` that hints at which [DoughController] to use next,
  /// (ensures that the hint is valid).
  int dequeueHintControllerID() {
    while (!_hintControllerIDs.isEmpty) {
      final id = _hintControllerIDs.removeFirst();
      if (containsController(id)) {
        return id;
      }
    }

    return -1;
  }

  /// Initializes a [DoughController] for the specified [id].
  DoughController initController(int id) {
    assert(!containsController(id));
    final controller = DoughController();
    _controllers[id] = controller;
    return controller;
  }

  /// Returns whether a [DoughController] with the specified [id] exists.
  bool containsController(int id) {
    return _controllers.containsKey(id);
  }

  /// Gets a [DoughController] for the specified [id].
  DoughController getcontroller(int id) {
    assert(containsController(id));
    return _controllers[id]!;
  }

  /// Tears down the [DoughController] cached at the specified [id].
  DoughController tearDownController(int id) {
    assert(containsController(id));
    final controller = getcontroller(id);
    if (controller.isActive) {
      controller.stop();
    }

    return _controllers.remove(id)!;
  }

  /// Cleans up the controller and hint cache.
  void reset() {
    for (final id in _controllers.keys) {
      final controller = getcontroller(id);
      if (controller.isActive) {
        controller.stop();
      }
    }

    _hintControllerIDs.clear();
    _controllers.clear();
  }
}
