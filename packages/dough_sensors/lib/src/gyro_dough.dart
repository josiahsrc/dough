import 'dart:async';

import 'package:dough/dough.dart';
import 'package:dough/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

/// A widget that stretches its child in a dough-like fashion based
/// on physical device accelerometer inputs (e.g. the [Dough] jiggles
/// when you move your phone around).
///
/// **This widget ONLY works on devices that have accelerometers.**
///
/// Please note that this widget will be moved over to a separate package
/// to remove a platform depedency.
class GyroDough extends StatefulWidget {
  /// Creates a [GyroDough] widget.
  const GyroDough({
    Key? key,
    required this.child,
    this.recipe,
  }) : super(key: key);

  /// The child to stretch based on physical device motion.
  final Widget child;

  /// Preferences for the behavior of this [GyroDough] widget. This can
  /// be specified here or in the context of a [GyroDoughRecipe] widget.
  /// This will override the contextual [GyroDoughRecipeData] if provided.
  final GyroDoughRecipeData? recipe;

  @override
  GyroDoughState createState() => GyroDoughState();
}

/// The state of a gyro dough widget which is used to track and interpret
/// accelerometer values.
class GyroDoughState extends State<GyroDough> {
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
    final prefs = widget.recipe ?? GyroDoughRecipe.watch(context);

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
    final prefs = GyroDoughRecipe.read(context);
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

/// Preferences applied to [GyroDough] widgets.
///
/// Please note that this widget will be moved over to a separate package
/// to remove a platform depedency.
class GyroDoughRecipeData extends Equatable {
  /// Creates [GyroDough] preferences.
  factory GyroDoughRecipeData({
    int? sampleCount,
    double? gyroMultiplier,
  }) {
    return GyroDoughRecipeData.raw(
      sampleCount: sampleCount ?? 10,
      gyroMultiplier: gyroMultiplier ?? 100,
    );
  }

  /// Creates raw [GyroDough] preferences, all values must be specified.
  const GyroDoughRecipeData.raw({
    required this.sampleCount,
    required this.gyroMultiplier,
  });

  /// Creates fallback [GyroDough] preferences.
  factory GyroDoughRecipeData.fallback() => GyroDoughRecipeData();

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
  GyroDoughRecipeData copyWith({
    int? sampleCount,
    double? gyroMultiplier,
  }) {
    return GyroDoughRecipeData.raw(
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

final _kFallback = GyroDoughRecipeData.fallback();

/// Inherited settings for [GyroDough] widgets. Use this to override
/// the default [GyroDough] settings.
class GyroDoughRecipe extends AbstractRecipe<GyroDoughRecipeData> {
  /// Creates a [GyroDoughRecipe] widget.
  const GyroDoughRecipe({
    super.key,
    required super.child,
    super.data,
  });

  /// Gets the inherited [GyroDoughRecipeData]. If no recipe is found,
  /// a default one will be returned instead.
  static GyroDoughRecipeData of(
    BuildContext context, [
    bool listen = true,
  ]) {
    final root = maybeRecipeOf<GyroDoughRecipeData>(
      context: context,
      listen: listen,
    );
    final gyro = maybeRecipeOf<GyroDoughRecipeData>(
      context: context,
      listen: listen,
    );
    return gyro ?? root ?? _kFallback;
  }

  /// Gets the inherited [GyroDoughRecipeData] without listening
  /// to it. If no recipe is found, a default one will be returned instead.
  static GyroDoughRecipeData read(BuildContext context) {
    return of(context, false);
  }

  /// Gets the inherited [GyroDoughRecipeData] and listens to it. If no
  /// recipe is found, a default one will be returned instead.
  static GyroDoughRecipeData watch(BuildContext context) {
    return of(context);
  }

  @override
  GyroDoughRecipeData get fallback => _kFallback;
}
