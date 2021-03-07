part of dough;

/// Preferences applied to [GyroDough] widgets.
class GyroDoughPrefs extends Equatable {
  /// Creates raw [GyroDough] preferences, all values must be specified.
  const GyroDoughPrefs.raw({
    required this.sampleCount,
    required this.gyroMultiplier,
  });

  /// Creates [GyroDough] preferences.
  factory GyroDoughPrefs({
    int? sampleCount,
    double? gyroMultiplier,
  }) {
    return GyroDoughPrefs.raw(
      sampleCount: sampleCount ?? 10,
      gyroMultiplier: gyroMultiplier ?? 100,
    );
  }

  /// Creates fallback [GyroDough] preferences.
  factory GyroDoughPrefs.fallback() => GyroDoughPrefs();

  /// The number of samples to use in the final gyro output. In technical
  /// terms, this value controls the intensity of 'low-pass filter' applied
  /// to a device's accelerometer.
  ///
  /// Higher values result in smoother gyro effects (slow-ish [Dough]), while
  /// lower values result in quick (and possibly more jagged) [Dough] effects.
  ///
  /// A typical value would be something like `10`. The minimum accepted
  /// sample count is `1`.
  final int sampleCount;

  /// The value by which accelerometer values are multiplied. Higher
  /// [gyroMultiplier] values will result in [Dough] that is more sensitive to
  /// motion.
  ///
  /// A typical value would be something like `100`.
  final double gyroMultiplier;

  /// Copies these preferences with some new values.
  GyroDoughPrefs copyWith({
    int? sampleCount,
    double? gyroMultiplier,
  }) {
    return GyroDoughPrefs.raw(
      sampleCount: sampleCount ?? this.sampleCount,
      gyroMultiplier: gyroMultiplier ?? this.gyroMultiplier,
    );
  }

  @override
  List<Object> get props => [
        sampleCount,
        gyroMultiplier,
      ];

  @override
  bool get stringify => true;
}

/// A widget that stretches its child in a dough-like fashion based
/// on physical device accelerometer inputs (e.g. the [Dough] jiggles
/// when you move your phone around).
///
/// **This widget ONLY works on devices that have accelerometers.**
class GyroDough extends StatefulWidget {
  /// Creates a [GyroDough] widget.
  const GyroDough({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The child to stretch based on physical device motion.
  final Widget child;

  @override
  _GyroDoughState createState() => _GyroDoughState();
}

/// The state of a gyro dough widget which is used to track and interpret
/// accelerometer values.
class _GyroDoughState extends State<GyroDough> {
  final _controller = DoughController();

  late List<Offset> _rollingSamples;
  late Offset _rollingSum;
  late int _rollingIndex;
  bool _hasInitialized = false;
  StreamSubscription<dynamic>? _accelSub;

  @override
  void initState() {
    _accelSub = accelerometerEvents.listen(_onAccelEvent);
    _controller.start(
      origin: Offset.zero,
      target: Offset.zero,
    );

    super.initState();
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _accelSub = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final prefs = DoughRecipe.watch(context).gyroPrefs;

    if (!_hasInitialized) {
      _rollingSum = Offset.zero;
      _rollingIndex = 0;
      _rollingSamples = List<Offset>.filled(
        prefs.sampleCount,
        Offset.zero,
      );

      _hasInitialized = true;
    } else {
      _rollingSum = Offset.zero;

      final oldSamples = _rollingSamples;
      final newSamples = List<Offset>.filled(
        prefs.sampleCount,
        Offset.zero,
      );

      // Sync the samples to the new gyro preferences.
      for (var i = 0; i < newSamples.length; ++i) {
        newSamples[i] = oldSamples[i % oldSamples.length];
        _rollingSum += newSamples[i];
      }

      _rollingSamples = newSamples;
      _rollingIndex = _rollingIndex % newSamples.length;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dough(
      controller: _controller,
      child: widget.child,
    );
  }

  void _onAccelEvent(AccelerometerEvent event) {
    final prefs = DoughRecipe.read(context).gyroPrefs;
    final sample = Offset(-event.x, event.y) * prefs.gyroMultiplier;

    _rollingIndex = (_rollingIndex + 1) % _rollingSamples.length;
    _rollingSum -= _rollingSamples[_rollingIndex];
    _rollingSamples[_rollingIndex] = sample;
    _rollingSum += sample;

    // Apply a low-pass filter to smooth out the accelerometer values.
    _controller.update(
      target: _rollingSum / _rollingSamples.length.toDouble(),
    );
  }
}
