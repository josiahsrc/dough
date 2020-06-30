part of dough;

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

class _DraggableDoughState<T> extends State<DraggableDough<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _animCtrl;
  DoughController _doughCtrl;
  double _effectiveT;

  @override
  void initState() {
    super.initState();

    _doughCtrl = DoughController();

    _effectiveT = 0.0;
    _animCtrl = AnimationController(vsync: this)
      ..addListener(_onAnimCtrlUpdated)
      ..addStatusListener(_onAnimCtrlStatusUpdated);

    Tween<double>(begin: 0.0, end: 1.0).animate(_animCtrl);
  }

  @override
  void dispose() {
    _animCtrl
      ..removeListener(_onAnimCtrlUpdated)
      ..removeStatusListener(_onAnimCtrlStatusUpdated)
      ..dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DraggableDough<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final draggable = _Draggable<T>(
      child: widget.child,
      feedback: widget.feedback,
      data: widget.data,
      axis: widget.axis,
      childWhenDragging: widget.childWhenDragging,
      feedbackOffset: Offset(0.5, 0.5), // widget.feedbackOffset,
      dragAnchor: DragAnchor.child,// widget.dragAnchor,
      affinity: widget.affinity,
      maxSimultaneousDrags: widget.maxSimultaneousDrags,
      onDragStarted: widget.onDragStarted,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragEnd: widget.onDragEnd,
      onDragCompleted: widget.onDragCompleted,
      ignoringFeedbackSemantics: widget.ignoringFeedbackSemantics,
      hapticFeedbackOnStart: widget.hapticFeedbackOnStart,
      onThresholdGestureStart: (details) {
        _doughCtrl.start(
          origin: details.globalPosition,
          target: details.globalPosition,
        );
      },
      onThresholdGestureUpdate: (details) {
        _doughCtrl.update(
          target: details.globalPosition,
        );
      },
      onThresholdGestureEnd: (details) {
        _doughCtrl.stop();
      },
    );

    return Dough(
      controller: _doughCtrl,
      child: draggable,
    );
  }

  void _onAnimCtrlUpdated() {
    setState(() {
      // TODO curve in prefs
      _effectiveT = Curves.elasticIn.transform(_animCtrl.value);
    });
  }

  void _onAnimCtrlStatusUpdated(AnimationStatus status) {
    setState(() {
      if (status == AnimationStatus.completed) {
        // TODO curve in prefs
        _effectiveT = Curves.elasticIn.transform(1.0);
      }
    });
  }
}

class _Draggable<T> extends Draggable<T> {
  final bool hapticFeedbackOnStart;
  final _MultiThresholdGestureCallback onThresholdGestureStart;
  final _MultiThresholdGestureCallback onThresholdGestureUpdate;
  final _MultiThresholdGestureCallback onThresholdGestureEnd;

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
    @required this.onThresholdGestureStart,
    @required this.onThresholdGestureUpdate,
    @required this.onThresholdGestureEnd,
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
  _MultiThresholdGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    // TODO use affinity for better query!
    // switch (affinity) {
    //   case Axis.horizontal:
    //     return HorizontalMultiDragGestureRecognizer()..onStart = onStart;
    //   case Axis.vertical:
    //     return VerticalMultiDragGestureRecognizer()..onStart = onStart;
    // }
    // return ImmediateMultiDragGestureRecognizer()..onStart = onStart;

    return _MultiThresholdGestureRecognizer(
      axis: axis,
      threshold: 90,
      onThresholdGestureStart: onThresholdGestureStart,
      onThresholdGestureUpdate: onThresholdGestureUpdate,
      onThresholdGestureEnd: onThresholdGestureEnd,
    )..onStart = (Offset position) {
        final Drag result = onStart(position);

        if (result != null && hapticFeedbackOnStart) {
          HapticFeedback.selectionClick();
        }

        return result;
      };
  }
}
