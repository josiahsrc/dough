part of dough;

class DraggableDoughPrefs {}

/// Makes its child draggable but in a smooshy-like way.
class DraggableDough<T> extends Draggable<T> {
  /// Whether haptic feedback should be triggered on drag start.
  final bool hapticFeedbackOnStart;

  /// Creates a widget that can be dragged in a smooshy-like way.
  ///
  /// The [child] and [feedback] arguments must not be null. If
  /// [maxSimultaneousDrags] is non-null, it must be non-negative.
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
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    // switch (affinity) {
    //   case Axis.horizontal:
    //     return HorizontalMultiDragGestureRecognizer()..onStart = onStart;
    //   case Axis.vertical:
    //     return VerticalMultiDragGestureRecognizer()..onStart = onStart;
    // }
    // return ImmediateMultiDragGestureRecognizer()..onStart = onStart;
    print('here');
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

// class DraggableDough<T> extends Draggable<T> {
//   final bool hapticFeedbackOnStart;

//   const DraggableDough({
//     Key key,
//     @required Widget child,
//     @required Widget feedback,
//     T data,
//     Axis axis,
//     Widget childWhenDragging,
//     Offset feedbackOffset = Offset.zero,
//     DragAnchor dragAnchor = DragAnchor.child,
//     int maxSimultaneousDrags,
//     VoidCallback onDragStarted,
//     DraggableCanceledCallback onDraggableCanceled,
//     DragEndCallback onDragEnd,
//     VoidCallback onDragCompleted,
//     this.hapticFeedbackOnStart = true,
//     bool ignoringFeedbackSemantics = true,
//   }) : super(
//           key: key,
//           child: child,
//           feedback: feedback,
//           data: data,
//           axis: axis,
//           childWhenDragging: childWhenDragging,
//           feedbackOffset: feedbackOffset,
//           dragAnchor: dragAnchor,
//           maxSimultaneousDrags: maxSimultaneousDrags,
//           onDragStarted: onDragStarted,
//           onDraggableCanceled: onDraggableCanceled,
//           onDragEnd: onDragEnd,
//           onDragCompleted: onDragCompleted,
//           ignoringFeedbackSemantics: ignoringFeedbackSemantics,
//         );

//   @override
//   DelayedMultiDragGestureRecognizer createRecognizer(
//       GestureMultiDragStartCallback onStart) {
//     return DelayedMultiDragGestureRecognizer(
//       delay: Duration(seconds: 15),
//     )..onStart = (Offset position) {
//         final Drag result = onStart(position);
//         if (result != null && hapticFeedbackOnStart)
//           HapticFeedback.selectionClick();
//         return result;
//       };
//   }

// @override
// _MultiThresholdGestureRecognizer createRecognizer(
//   GestureMultiDragStartCallback onStart,
// ) {
//   print('creating multi drag');
//   return _MultiThresholdGestureRecognizer(
//     axis: axis,
//     threshold: 40,
//   )..onStart = (Offset position) {
//       final Drag result = onStart(position);

//       if (result != null && hapticFeedbackOnStart) {
//         HapticFeedback.selectionClick();
//       }

//       return result;
//     };
// }
// }
