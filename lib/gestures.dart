part of dough;

class _MultiThresholdGestureDetails {
  final Offset initialPosition;
  final Offset delta;

  Offset get globalPosition => delta + initialPosition;

  const _MultiThresholdGestureDetails({
    this.initialPosition,
    this.delta,
  });
}

typedef _MultiThresholdGestureCallback = void Function(
  _MultiThresholdGestureDetails details,
);

class _MultiThresholdGestureRecognizer
    extends MultiDragGestureRecognizer<_MultiThresholdPointerState> {
  final Axis axis;
  final double threshold;
  final _MultiThresholdGestureCallback onThresholdGestureStart;
  final _MultiThresholdGestureCallback onThresholdGestureUpdate;
  final _MultiThresholdGestureCallback onThresholdGestureEnd;

  _MultiThresholdGestureRecognizer({
    Object debugOwner,
    PointerDeviceKind kind,
    @required this.axis,
    @required this.threshold,
    @required this.onThresholdGestureStart,
    @required this.onThresholdGestureUpdate,
    @required this.onThresholdGestureEnd,
  }) : super(debugOwner: debugOwner, kind: kind);

  @override
  _MultiThresholdPointerState createNewPointerState(PointerDownEvent event) {
    return _MultiThresholdPointerState(
      initialPosition: event.position,
      threshold: this.threshold,
      axis: this.axis,
      onThresholdGestureStart: onThresholdGestureStart,
      onThresholdGestureUpdate: onThresholdGestureUpdate,
      onThresholdGestureEnd: onThresholdGestureEnd,
    );
  }

  @override
  String get debugDescription => 'multi threshold dough drag';
}

class _MultiThresholdPointerState extends MultiDragPointerState {
  final double threshold;
  final Axis axis;
  final _MultiThresholdGestureCallback onThresholdGestureStart;
  final _MultiThresholdGestureCallback onThresholdGestureUpdate;
  final _MultiThresholdGestureCallback onThresholdGestureEnd;

  GestureMultiDragStartCallback _starter;
  bool _hasStarted;
  bool _hasFinished;

  _MultiThresholdPointerState({
    @required Offset initialPosition,
    @required this.threshold,
    @required this.axis,
    @required this.onThresholdGestureStart,
    @required this.onThresholdGestureUpdate,
    @required this.onThresholdGestureEnd,
  }) : super(initialPosition);

  @override
  void checkForResolutionAfterMove() {
    assert(pendingDelta != null);

    final gestureDetails = _MultiThresholdGestureDetails(
      initialPosition: initialPosition,
      delta: pendingDelta,
    );

    if (!_hasStarted) {
      _hasStarted = true;
      onThresholdGestureStart(gestureDetails);
    }

    onThresholdGestureUpdate(gestureDetails);

    double sqrDeltaMagnitude;
    if (axis == Axis.horizontal) {
      sqrDeltaMagnitude = pendingDelta.dx * pendingDelta.dx;
    } else if (axis == Axis.vertical) {
      sqrDeltaMagnitude = pendingDelta.dy * pendingDelta.dy;
    } else {
      sqrDeltaMagnitude = (pendingDelta.dy * pendingDelta.dy) +
          (pendingDelta.dx * pendingDelta.dx);
    }

    if (sqrDeltaMagnitude > threshold * threshold && !_hasFinished) {
      _hasFinished = true;
      onThresholdGestureEnd(gestureDetails);
      resolve(GestureDisposition.accepted);
      _starter(initialPosition);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    assert(_hasStarted == null);
    assert(_hasFinished == null);
    assert(_starter == null);

    _hasStarted = false;
    _hasFinished = false;
    _starter = starter;
  }
}
