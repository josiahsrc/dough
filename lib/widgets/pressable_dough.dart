part of dough;

/// Some details about a dough release after being pressed.
@immutable
class PressableDoughReleaseDetails {

  /// How far the dough was dragged before it was released.
  final Offset delta;

  const PressableDoughReleaseDetails({
    this.delta,
  });
}

typedef PressableDoughReleaseCallback = void Function(
  PressableDoughReleaseDetails details,
);

/// A smooshable dough widget that reacts to a user's presses.
class PressableDough extends StatefulWidget {

  /// The child to smoosh.
  final Widget child;

  /// A callback raised when the user releases their hold on the widget.
  final PressableDoughReleaseCallback onReleased;

  const PressableDough({
    Key key,
    @required this.child,
    this.onReleased,
  }) : super(key: key);

  @override
  _PressableDoughState createState() => _PressableDoughState();
}

class _PressableDoughState extends State<PressableDough> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final pressableInterface = GestureDetector(
      onPanStart: (details) {
        _controller.start(
          origin: details.globalPosition,
          target: details.globalPosition,
        );
      },
      onPanUpdate: (details) {
        _controller.update(
          target: details.globalPosition,
        );
      },
      onPanEnd: (details) {
        _controller.stop();
        widget.onReleased?.call(
          PressableDoughReleaseDetails(
            delta: _controller.delta,
          ),
        );
      },
      child: widget.child,
      behavior: HitTestBehavior.translucent,
    );

    return Dough(
      child: pressableInterface,
      controller: _controller,
    );
  }
}
