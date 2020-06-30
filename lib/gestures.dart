part of dough;

// class _HorizDeltaGestureRecognizer
//     extends MultiDragGestureRecognizer<_HorizDeltaPointerState> {
//   final double snapDelta;

//   _HorizDeltaGestureRecognizer({
//     Object debugOwner,
//     PointerDeviceKind kind,
//     this.snapDelta,
//   }) : super(debugOwner: debugOwner, kind: kind);

//   @override
//   _HorizDeltaPointerState createNewPointerState(PointerDownEvent event) {
//     return _HorizDeltaPointerState(
//       event.position,
//       this.snapDelta,
//     );
//   }

//   @override
//   String get debugDescription => 'horizontal delta multi drag';
// }

// class _HorizDeltaPointerState extends MultiDragPointerState {
//   final double snapDelta;

//   _HorizDeltaPointerState(
//     Offset initialPosition,
//     this.snapDelta,
//   ) : super(initialPosition);

//   @override
//   void checkForResolutionAfterMove() {
//     assert(pendingDelta != null);
//     if (pendingDelta.dx.abs() > snapDelta)
//       resolve(GestureDisposition.accepted);
//   }

//   @override
//   void accepted(GestureMultiDragStartCallback starter) {
//     starter(initialPosition);
//   }
// }
