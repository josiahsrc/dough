part of dough;

class DraggableDoughPrefs {}

class DraggableDough<T> extends StatefulWidget {
  final Widget child;
  final Widget childWhenDragging;
  final Widget feedback;
  final Offset feedbackOffset;
  final T data;
  final Axis axis;
  final DragAnchor dragAnchor;
  final bool ignoringFeedbackSemantics;
  final Axis affinity;
  final int maxSimultaneousDrags;
  final VoidCallback onDragStarted;
  final DraggableCanceledCallback onDraggableCanceled;
  final VoidCallback onDragCompleted;
  final DragEndCallback onDragEnd;
  final bool hapticFeedbackOnStart;

  const DraggableDough({
    Key key,
    @required this.child,
    this.childWhenDragging,
    @required this.feedback,
    this.data,
    this.axis,
    this.feedbackOffset = Offset.zero,
    this.dragAnchor = DragAnchor.child,
    this.ignoringFeedbackSemantics = true,
    this.affinity,
    this.maxSimultaneousDrags,
    this.onDragStarted,
    this.onDraggableCanceled,
    this.onDragCompleted,
    this.onDragEnd,
    this.hapticFeedbackOnStart,
  }) : super(key: key);

  @override
  _DraggableDoughState<T> createState() => _DraggableDoughState<T>();
}

class _DraggableDoughState<T> extends State<DraggableDough<T>> {
  @override
  Widget build(BuildContext context) {
    // TODO
    // - get reference to drag child
    // - transform the drag child so its origin is where it sticks until the drag snaps
    // - once the drag snaps, boing back into shap. don't call controller.stop, instead
    //   just update the controller so the origin matches the target until they're equal

    return Draggable<T>(
      child: widget.child,
      childWhenDragging: widget.childWhenDragging,
      feedback: widget.feedback,
      data: widget.data,
      axis: widget.axis,
      feedbackOffset: widget.feedbackOffset,
      dragAnchor: widget.dragAnchor,
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      affinity: widget.affinity,
      maxSimultaneousDrags: widget.maxSimultaneousDrags,
      onDragStarted: widget.onDragStarted,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragCompleted: widget.onDragCompleted,
      onDragEnd: widget.onDragEnd,
    );
  }
}
