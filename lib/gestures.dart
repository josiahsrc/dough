part of dough;

class _MultiThresholdGestureRecognizer
    extends MultiDragGestureRecognizer<_MultiThresholdPointerState> {
  final Axis axis;
  final double threshold;

  _MultiThresholdGestureRecognizer({
    Object debugOwner,
    PointerDeviceKind kind,
    @required this.axis,
    @required this.threshold,
  }) : super(debugOwner: debugOwner, kind: kind);

  @override
  _MultiThresholdPointerState createNewPointerState(PointerDownEvent event) {
    return _MultiThresholdPointerState(
      event.position,
      this.threshold,
      this.axis,
    );
  }

  @override
  String get debugDescription => 'multi threshold dough drag';
}

class _MultiThresholdPointerState extends MultiDragPointerState {
  final double threshold;
  final Axis axis;

  GestureMultiDragStartCallback _starter;

  _MultiThresholdPointerState(
    Offset initialPosition,
    this.threshold,
    this.axis,
  ) : super(initialPosition);

  @override
  void checkForResolutionAfterMove() {
    assert(pendingDelta != null);

    double sqrDeltaMagnitude;
    if (axis == Axis.horizontal) {
      sqrDeltaMagnitude = pendingDelta.dx * pendingDelta.dx;
    } else if (axis == Axis.vertical) {
      sqrDeltaMagnitude = pendingDelta.dy * pendingDelta.dy;
    } else {
      sqrDeltaMagnitude = (pendingDelta.dy * pendingDelta.dy) +
          (pendingDelta.dx * pendingDelta.dx);
    }

    if (sqrDeltaMagnitude > threshold * threshold) {
      resolve(GestureDisposition.accepted);
      _starter(initialPosition);
    }
  }

  @override
  void accepted(GestureMultiDragStartCallback starter) {
    assert(_starter == null);
    _starter = starter;
  }
}
