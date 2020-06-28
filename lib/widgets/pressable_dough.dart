part of dough;

@immutable
class PressableDoughReleaseDetails {
  final Offset delta;

  const PressableDoughReleaseDetails({
    this.delta,
  });
}

typedef PressableDoughReleaseCallback = void Function(
  PressableDoughReleaseDetails details,
);

class PressableDough extends StatefulWidget {
  final Widget child;
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
