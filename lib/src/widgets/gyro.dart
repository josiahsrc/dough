part of dough;

class GyroDough extends StatefulWidget {
  const GyroDough({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _GyroDoughState createState() => _GyroDoughState();
}

class _GyroDoughState extends State<GyroDough> {
  final _controller = DoughController();

  StreamSubscription<dynamic> _gyroSub;
  StreamSubscription<dynamic> _userAccelSub;

  @override
  void initState() {
    _controller.start(
      origin: Offset.zero,
      target: Offset.zero,
    );

    _gyroSub = gyroscopeEvents.listen(_onGyroEvent);
    _userAccelSub = userAccelerometerEvents.listen(_onUserAccelEvent);

    super.initState();
  }

  @override
  void dispose() {
    _gyroSub.cancel();
    _userAccelSub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dough(
      controller: _controller,
      child: widget.child,
    );
  }

  void _onGyroEvent(GyroscopeEvent event) {
    _controller.update(
      target: Offset(-event.y, -event.x) * 40,
    );
  }

  void _onUserAccelEvent(UserAccelerometerEvent event) {
    // _controller.update(
    //   target: Offset(-event.y, -event.x) * 40,
    // );
  }
}
