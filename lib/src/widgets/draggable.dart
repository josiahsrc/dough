part of dough;

/// Preferences applied to [DraggableDough] widgets.
class DraggableDoughPrefs extends Equatable {
  /// Creates raw [DraggableDough] preferences, all values must be specified.
  const DraggableDoughPrefs.raw({
    @required this.breakDistance,
    @required this.useHapticsOnBreak,
  })  : assert(breakDistance != null),
        assert(useHapticsOnBreak != null);

  /// Creates [DraggableDough] preferences.
  factory DraggableDoughPrefs({
    double breakDistance,
    bool useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? 80,
      useHapticsOnBreak: useHapticsOnBreak ?? true,
    );
  }

  /// Creates fallback [DraggableDough] preferences.
  factory DraggableDoughPrefs.fallback() => DraggableDoughPrefs();

  /// The logical pixel distance at which the [DraggableDough] should
  /// elastically break its hold on the origin and enter a freely movable
  /// state.
  final double breakDistance;

  /// Whether [DraggableDough] widgets should trigger haptic feedback when
  /// the dough breaks its hold on the origin.
  final bool useHapticsOnBreak;

  /// Copies these preferences with some new values.
  DraggableDoughPrefs copyWith({
    double breakDistance,
    bool useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? this.breakDistance,
      useHapticsOnBreak: useHapticsOnBreak ?? this.useHapticsOnBreak,
    );
  }

  @override
  List<Object> get props => [
        breakDistance,
        useHapticsOnBreak,
      ];

  @override
  bool get stringify => true;
}

/// A widget which mimics the behavior of Flutter's [Draggable] widget, only
/// this one is squishy! For details on what each field does for this widget,
/// view [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html)
/// for the [Draggable] widget.
class DraggableDough<T> extends StatefulWidget {
  /// Creates a [DraggableDough] widget.
  const DraggableDough({
    Key key,
    this.prefs,
    this.onDoughBreak,
    @required this.child,
    @required this.feedback,
    this.data,
    this.axis,
    this.childWhenDragging,
    this.feedbackOffset = Offset.zero,
    this.dragAnchor = DragAnchor.child,
    this.affinity,
    this.maxSimultaneousDrags,
    this.onDragStarted,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.ignoringFeedbackSemantics = true,
  })  : assert(child != null),
        assert(feedback != null),
        assert(ignoringFeedbackSemantics != null),
        assert(maxSimultaneousDrags == null || maxSimultaneousDrags >= 0),
        super(key: key);

  /// Preferences for the behavior of this [DraggableDough] widget. This can
  /// be specified here or in the context of a [DoughRecipe] widget. This will
  /// override the contextual [DoughRecipeData.draggablePrefs] if provided.
  final DraggableDoughPrefs prefs;

  /// A callback raised when the user drags the feedback widget beyond the
  /// [DraggableDoughPrefs.breakDistance] and the [Dough] snaps back into
  /// its original form.
  final VoidCallback onDoughBreak;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final T data;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Axis axis;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget child;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget childWhenDragging;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Widget feedback;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Offset feedbackOffset;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DragAnchor dragAnchor;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final bool ignoringFeedbackSemantics;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final Axis affinity;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final int maxSimultaneousDrags;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final VoidCallback onDragStarted;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DraggableCanceledCallback onDraggableCanceled;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final VoidCallback onDragCompleted;

  /// See [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html).
  final DragEndCallback onDragEnd;

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

/// The state of a [DraggableDough] widget which controls how the [Dough] morphs
/// as the feedback is dragged around.
class _DraggableDoughState<T> extends State<DraggableDough<T>> {
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

    final draggable = Draggable<T>(
      child: widget.child,
      feedback: doughFeedback,
      data: widget.data,
      axis: widget.axis,
      childWhenDragging: widget.childWhenDragging,
      feedbackOffset: widget.feedbackOffset,
      dragAnchor: widget.dragAnchor,
      affinity: widget.affinity,
      maxSimultaneousDrags: widget.maxSimultaneousDrags,
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragEnd: widget.onDragEnd,
      onDragCompleted: widget.onDragCompleted,
      onDragStarted: widget.onDragStarted,
    );

    return Listener(
      child: draggable,
      onPointerDown: (event) {
        _controllerTracker.enqueueHintControllerID(event.pointer);
        _controllerTracker.initController(event.pointer)
          ..start(
            origin: event.position,
            target: event.position,
          );
      },
      onPointerMove: (event) {
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
        final controller = _controllerTracker.getcontroller(event.pointer);
        if (controller != null) {
          _controllerTracker.tearDownController(event.pointer);
        }
      },
      onPointerCancel: (event) {
        final controller = _controllerTracker.getcontroller(event.pointer);
        if (controller != null) {
          _controllerTracker.tearDownController(event.pointer);
        }
      },
    );
  }
}

/// A helper drag feedback widget which maintains a pointer ID to control
/// the Dough.
class _DragFeedback extends StatefulWidget {
  /// Creates a [_DragFeedback] widget.
  const _DragFeedback({
    Key key,
    @required this.controllerTracker,
    @required this.child,
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
  int _controllerID;

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
      child: widget.child,
      controller: widget.controllerTracker.getcontroller(_controllerID),
      transformer: DraggableOverlayDoughTransformer(
        snapToTargetOnStop: true,
        applyDelta: true,
      ),
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
    assert(!_controllers.containsKey(id));
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
    assert(_controllers.containsKey(id));
    return _controllers[id];
  }

  /// Tears down the [DoughController] cached at the specified [id].
  DoughController tearDownController(int id) {
    assert(_controllers.containsKey(id));

    final controller = _controllers[id];
    if (controller.isActive) {
      controller.stop();
    }

    return _controllers.remove(id);
  }

  /// Cleans up the controller and hint cache.
  void reset() {
    for (final id in _controllers.keys) {
      final controller = _controllers[id];
      if (controller.isActive) {
        controller.stop();
      }
    }

    _hintControllerIDs.clear();
    _controllers.clear();
  }
}
