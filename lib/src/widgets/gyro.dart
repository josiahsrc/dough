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

  List<Offset> _rollingSamples;
  Offset _rollingSum;
  int _rollingIndex;

  StreamSubscription<dynamic> _gyroSub;
  StreamSubscription<dynamic> _userAccelSub;
  StreamSubscription<dynamic> _accelSub;

  Offset get _filteredOffset {
    return _rollingSum / _rollingSamples.length.toDouble();
  }

  @override
  void initState() {
    _controller.start(
      origin: Offset.zero,
      target: Offset.zero,
    );

    _rollingSamples = List<Offset>.filled(10, Offset.zero);
    _rollingSum = Offset.zero;
    _rollingIndex = 0;

    _gyroSub = gyroscopeEvents.listen(_onGyroEvent);
    _userAccelSub = userAccelerometerEvents.listen(_onUserAccelEvent);
    _accelSub = accelerometerEvents.listen(_onAccelEvent);

    super.initState();
  }

  @override
  void dispose() {
    _gyroSub.cancel();
    _userAccelSub.cancel();
    _accelSub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Text('value: $_printMe');
    return Dough(
      controller: _controller,
      child: widget.child,
    );
  }

  void _onGyroEvent(GyroscopeEvent event) {
    // _controller.update(
    //   target: Offset(-event.y, -event.x) * 40,
    // );
  }

  void _onUserAccelEvent(UserAccelerometerEvent event) {
    // _controller.update(
    //   target: Offset(-event.y, -event.x) * 40,
    // );
  }

  void _onAccelEvent(AccelerometerEvent event) {
    setState(() {
      final sample = Offset(-event.x, event.y) * 100;

      _rollingIndex = (_rollingIndex + 1) % _rollingSamples.length;
      _rollingSum -= _rollingSamples[_rollingIndex];
      _rollingSamples[_rollingIndex] = sample;
      _rollingSum += sample;

      _controller.update(
        target: _filteredOffset,
      );
    });
  }
}
