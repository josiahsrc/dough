part of dough;

class PressableDough extends StatefulWidget {
  final Widget child;

  const PressableDough({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _PressableDoughState createState() => _PressableDoughState();
}

class _PressableDoughState extends State<PressableDough> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final pressableInterface = GestureDetector(
      onPanDown: (details) {
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
      },
      child: widget.child,
    );

    return Dough(
      child: pressableInterface,
      controller: _controller,
    );
  }
}
