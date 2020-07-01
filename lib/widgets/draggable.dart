part of dough;

// TODO add prefs
// TODO add haptic feedback on break

class DraggableDoughPrefs {}

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
    // The feedback widget won't share the same
    // context once the [Draggable] widget instantiates
    // it as an overlay. The DoughRecipe has to be copied
    // directly so it will exist in the overlay's context
    // as well.
    final doughFeedback = DoughRecipe(
      data: DoughRecipe.of(context),
      child: Dough(
        controller: _controller,
        child: widget.feedback,
      ),
    );

    final draggable = _Draggable<T>(
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
      hapticFeedbackOnStart: widget.hapticFeedbackOnStart,
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

class _Draggable<T> extends Draggable<T> {
  final bool hapticFeedbackOnStart;

  const _Draggable({
    Key key,
    @required Widget child,
    @required Widget feedback,
    @required T data,
    @required Axis axis,
    @required Widget childWhenDragging,
    @required Offset feedbackOffset,
    @required DragAnchor dragAnchor,
    @required Axis affinity,
    @required int maxSimultaneousDrags,
    @required VoidCallback onDragStarted,
    @required DraggableCanceledCallback onDraggableCanceled,
    @required DragEndCallback onDragEnd,
    @required VoidCallback onDragCompleted,
    @required bool ignoringFeedbackSemantics,
    @required this.hapticFeedbackOnStart,
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
}

// @override
// _MultiThresholdGestureRecognizer createRecognizer(
//   GestureMultiDragStartCallback onStart,
// ) {
//   // TODO use affinity for better query!
//   // switch (affinity) {
//   //   case Axis.horizontal:
//   //     return HorizontalMultiDragGestureRecognizer()..onStart = onStart;
//   //   case Axis.vertical:
//   //     return VerticalMultiDragGestureRecognizer()..onStart = onStart;
//   // }
//   // return ImmediateMultiDragGestureRecognizer()..onStart = onStart;

//   return _MultiThresholdGestureRecognizer(
//     axis: axis,
//     threshold: 90,
//     onThresholdGestureStart: onThresholdGestureStart,
//     onThresholdGestureUpdate: onThresholdGestureUpdate,
//     onThresholdGestureEnd: onThresholdGestureEnd,
//   )..onStart = (Offset position) {
//       final Drag result = onStart(position);

//       if (result != null && hapticFeedbackOnStart) {
//         HapticFeedback.selectionClick();
//       }

//       return result;
//     };
// }
