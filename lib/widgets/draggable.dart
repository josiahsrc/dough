part of dough;

class DraggableDoughPrefs {}

class DraggableDough<T> extends Draggable<T> {
  final bool hapticFeedbackOnStart;

  const DraggableDough({
    Key key,
    @required Widget child,
    @required Widget feedback,
    T data,
    Axis axis,
    Widget childWhenDragging,
    Offset feedbackOffset = Offset.zero,
    DragAnchor dragAnchor = DragAnchor.child,
    int maxSimultaneousDrags,
    VoidCallback onDragStarted,
    DraggableCanceledCallback onDraggableCanceled,
    DragEndCallback onDragEnd,
    VoidCallback onDragCompleted,
    this.hapticFeedbackOnStart = true,
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
    maxSimultaneousDrags: maxSimultaneousDrags,
    onDragStarted: onDragStarted,
    onDraggableCanceled: onDraggableCanceled,
    onDragEnd: onDragEnd,
    onDragCompleted: onDragCompleted,
    ignoringFeedbackSemantics: ignoringFeedbackSemantics,
  );

  @override
  DelayedMultiDragGestureRecognizer createRecognizer(GestureMultiDragStartCallback onStart) {
    return DelayedMultiDragGestureRecognizer()
      ..onStart = (Offset position) {
        final Drag result = onStart(position);
        if (result != null && hapticFeedbackOnStart)
          HapticFeedback.selectionClick();
        return result;
      };
  }
}