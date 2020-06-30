part of dough;

class DraggableDoughPrefs {}

class DraggableDough<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return _Draggable<T>(
      child: child,
      feedback: feedback,
      data: data,
      axis: axis,
      childWhenDragging: childWhenDragging,
      feedbackOffset: feedbackOffset,
      dragAnchor: dragAnchor,
      affinity: affinity,
      maxSimultaneousDrags: maxSimultaneousDrags,
      onDragStarted: onDragStarted,
      onDraggableCanceled: onDraggableCanceled,
      onDragEnd: onDragEnd,
      onDragCompleted: onDragCompleted,
      ignoringFeedbackSemantics: ignoringFeedbackSemantics,
      hapticFeedbackOnStart: hapticFeedbackOnStart,
    );
  }
}

class _Draggable<T> extends Draggable<T> {
  final bool hapticFeedbackOnStart;

  const _Draggable({
    Key key,
    @required Widget child,
    @required Widget feedback,
    T data,
    Axis axis,
    Widget childWhenDragging,
    Offset feedbackOffset = Offset.zero,
    DragAnchor dragAnchor = DragAnchor.child,
    Axis affinity,
    int maxSimultaneousDrags,
    VoidCallback onDragStarted,
    DraggableCanceledCallback onDraggableCanceled,
    DragEndCallback onDragEnd,
    VoidCallback onDragCompleted,
    this.hapticFeedbackOnStart,
    bool ignoringFeedbackSemantics = true,
  }) : super(
          key: key,
          child: child,
          feedback: feedback,
          data: data,
          axis: axis,
          childWhenDragging: childWhenDragging,
          feedbackOffset: feedbackOffset,
          dragAnchor: dragAnchor,
          affinity: affinity,
          maxSimultaneousDrags: maxSimultaneousDrags,
          onDragStarted: onDragStarted,
          onDraggableCanceled: onDraggableCanceled,
          onDragEnd: onDragEnd,
          onDragCompleted: onDragCompleted,
          ignoringFeedbackSemantics: ignoringFeedbackSemantics,
        );

  @override
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    // TODO use affinity for better query
    // switch (affinity) {
    //   case Axis.horizontal:
    //     return HorizontalMultiDragGestureRecognizer()..onStart = onStart;
    //   case Axis.vertical:
    //     return VerticalMultiDragGestureRecognizer()..onStart = onStart;
    // }
    // return ImmediateMultiDragGestureRecognizer()..onStart = onStart;

    return _MultiThresholdGestureRecognizer(
      axis: axis,
      threshold: 40,
    )..onStart = (Offset position) {
        final Drag result = onStart(position);

        if (result != null && hapticFeedbackOnStart) {
          HapticFeedback.selectionClick();
        }

        return result;
      };
  }
}
