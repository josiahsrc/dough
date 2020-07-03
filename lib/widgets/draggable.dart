part of dough;

// TODO add prefs
// TODO add haptic feedback on break

class DraggableDoughPrefs {
  final double breakDistance;

  const DraggableDoughPrefs.raw({
    @required this.breakDistance,
  });

  factory DraggableDoughPrefs({
    double breakDistance,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? 100,
    );
  }

  DraggableDoughPrefs copyWith({
    double breakDistance,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? this.breakDistance,
    );
  }

  factory DraggableDoughPrefs.fallback() => DraggableDoughPrefs();

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;

    return other is DraggableDoughPrefs && other.breakDistance == breakDistance;
  }

  @override
  int get hashCode {
    final values = <Object>[breakDistance];

    return hashList(values);
  }
}

class DraggableDough<T> extends StatefulWidget {
  final bool hapticFeedbackOnStart;
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
    this.hapticFeedbackOnStart = true,
  })  : assert(child != null),
        assert(feedback != null),
        assert(ignoringFeedbackSemantics != null),
        assert(maxSimultaneousDrags == null || maxSimultaneousDrags >= 0),
        assert(hapticFeedbackOnStart != null),
        super(key: key);

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

class _DraggableDoughState<T> extends State<DraggableDough<T>> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final contextualRecipe = DoughRecipe.of(context);
    final effectiveRecipe = contextualRecipe.copyWith(
      adhesion: 1 / contextualRecipe.adhesion,
      viscosity: 1 / contextualRecipe.viscosity,
    );

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
          // TODO store in prefs
          if (_controller.delta.distanceSquared > 500 * 50) {
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
