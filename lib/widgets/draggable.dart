part of dough;

/// Preferences applied to [DraggableDough] widgets.
class DraggableDoughPrefs {
  /// The logical pixel distance at which the [DraggableDough] should
  /// elastically break its hold on the origin and enter a freely movable
  /// state.
  final double breakDistance;

  /// Whether [DraggableDough] widgets should trigger haptic feedback when
  /// the dough breaks its hold on the origin.
  final bool useHapticsOnBreak;

  /// Creates raw [DraggableDough] preferences, all values must be specified.
  const DraggableDoughPrefs.raw({
    @required this.breakDistance,
    @required this.useHapticsOnBreak,
  });

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

  /// The fallback [DraggableDough] preferences.
  factory DraggableDoughPrefs.fallback() => DraggableDoughPrefs();

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
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;

    return other is DraggableDoughPrefs &&
        other.breakDistance == breakDistance &&
        other.useHapticsOnBreak == useHapticsOnBreak;
  }

  @override
  int get hashCode {
    final values = <Object>[
      breakDistance,
      useHapticsOnBreak,
    ];

    return hashList(values);
  }
}

/// A widget which mimics the behavior of Flutter's [Draggable] widget, only this
/// one is squishy! For details on what each field does for this widget, view
/// [Flutter's docs](https://api.flutter.dev/flutter/widgets/Draggable-class.html)
/// for the [Draggable] widget.
class DraggableDough<T> extends StatefulWidget {
  /// Preferences for the behavior of this [DraggableDough] widget. This can be specified
  /// here or in the context of a [DoughRecipe] widget. This will override the contextual
  /// [DoughRecipeData.draggablePrefs] if provided.
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
    this.maxSimultaneousDrags = 1,
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

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

/// The state of a [DraggableDough] widget which controls how the [Dough] morphs
/// as the feedback is dragged around.
class _DraggableDoughState<T> extends State<DraggableDough<T>> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final recipe = DoughRecipe.of(context);
    final prefs = widget.prefs ?? recipe.draggablePrefs;

    // The feedback widget won't share the same context once the
    // [Draggable] widget instantiates it as an overlay. The [DoughRecipe]
    // has to be copied directly so it will exist in the overlay's context
    // as well.
    final doughFeedback = DoughRecipe(
      data: recipe,
      child: Dough(
        child: widget.feedback,
        controller: _controller,
        transformer: DraggableOverlayDoughTransformer(
          snapToTargetOnStop: true,
          applyDelta: true,
        ),
      ),
    );

    // TODO
    // Fix bug for maxSimultaneousDrags, each draggable shouldn't share the
    // same dough controller. They should each have their own controllers.
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
        _controller.start(
          origin: event.position,
          target: event.position,
        );
      },
      onPointerMove: (event) {
        if (_controller.isActive) {
          final sqrBreakThresh = prefs.breakDistance * prefs.breakDistance;
          if (_controller.delta.distanceSquared > sqrBreakThresh) {
            _controller.stop();

            widget.onDoughBreak?.call();
            if (prefs.useHapticsOnBreak) {
              HapticFeedback.selectionClick();
            }
          } else {
            _controller.update(
              target: event.position,
            );
          }
        }
      },
      onPointerUp: (event) {
        if (_controller.isActive) {
          _controller.stop();
        }
      },
      onPointerCancel: (event) {
        if (_controller.isActive) {
          _controller.stop();
        }
      },
    );
  }
}
