part of dough;

class DraggableDoughPrefs {
  final double breakDistance;
  final bool useHapticsOnBreak;

  const DraggableDoughPrefs.raw({
    @required this.breakDistance,
    @required this.useHapticsOnBreak,
  });

  factory DraggableDoughPrefs({
    double breakDistance,
    bool useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? 100,
      useHapticsOnBreak: useHapticsOnBreak ?? true,
    );
  }

  DraggableDoughPrefs copyWith({
    double breakDistance,
    bool useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? this.breakDistance,
      useHapticsOnBreak: useHapticsOnBreak ?? this.useHapticsOnBreak,
    );
  }

  factory DraggableDoughPrefs.fallback() => DraggableDoughPrefs();

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

class DraggableDough<T> extends StatefulWidget {
  final T data;
  final Axis axis;
  final Widget child;
  final Widget childWhenDragging;
  final Widget feedback;
  final Offset feedbackOffset;
  final DragAnchor dragAnchor;
  final bool ignoringFeedbackSemantics;
  final Axis affinity;
  final int maxSimultaneousDrags;
  final VoidCallback onDragStarted;
  final DraggableCanceledCallback onDraggableCanceled;
  final VoidCallback onDragCompleted;
  final DragEndCallback onDragEnd;

  const DraggableDough({
    Key key,
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

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

class _DraggableDoughState<T> extends State<DraggableDough<T>> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final contextualRecipe = DoughRecipe.of(context);
    final effectiveRecipe = contextualRecipe;

    // The feedback widget won't share the same
    // context once the [Draggable] widget instantiates
    // it as an overlay. The DoughRecipe has to be copied
    // directly so it will exist in the overlay's context
    // as well.
    final doughFeedback = DoughRecipe(
      data: effectiveRecipe,
      child: Dough(
        controller: _controller,
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
        // wait until the draggable widget instantiates the feedback
        // widget before starting the squish
        WidgetsBinding.instance.addPostFrameCallback((details) {
          _controller.start(
            origin: event.position,
            target: event.position,
          );
        });
      },
      onPointerMove: (event) {
        if (_controller.isActive) {
          final breakDist = contextualRecipe.draggablePrefs.breakDistance;
          if (_controller.delta.distanceSquared > breakDist * breakDist) {
            _controller.stop();
          } else {
            _controller.update(
              origin: event.position,
            );
          }
        }
      },
      onPointerUp: (event) {
        if (_controller.isActive) {
          _controller.stop();
          if (contextualRecipe.draggablePrefs.useHapticsOnBreak) {
            HapticFeedback.lightImpact();
          }
        }
      },
      onPointerCancel: (event) {
        if (_controller.isActive) {
          _controller.stop();
          if (contextualRecipe.draggablePrefs.useHapticsOnBreak) {
            HapticFeedback.lightImpact();
          }
        }
      },
    );
  }
}
