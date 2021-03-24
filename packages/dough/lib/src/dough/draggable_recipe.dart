import 'package:equatable/equatable.dart';

import 'draggable.dart';

/// Preferences applied to [DraggableDough] widgets.
class DraggableDoughPrefs extends Equatable {
  /// Creates raw [DraggableDough] preferences, all values must be specified.
  const DraggableDoughPrefs.raw({
    required this.breakDistance,
    required this.useHapticsOnBreak,
  });

  /// Creates [DraggableDough] preferences.
  factory DraggableDoughPrefs({
    double? breakDistance,
    bool? useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? 80,
      useHapticsOnBreak: useHapticsOnBreak ?? true,
    );
  }

  /// Creates fallback [DraggableDough] preferences.
  factory DraggableDoughPrefs.fallback() => DraggableDoughPrefs();

  /// The logical pixel distance at which the [DraggableDough] should
  /// elastically break its hold on the origin and enter a freely movable
  /// state.
  final double breakDistance;

  /// Whether [DraggableDough] widgets should trigger haptic feedback when
  /// the dough breaks its hold on the origin.
  final bool useHapticsOnBreak;

  /// Copies these preferences with some new values.
  DraggableDoughPrefs copyWith({
    double? breakDistance,
    bool? useHapticsOnBreak,
  }) {
    return DraggableDoughPrefs.raw(
      breakDistance: breakDistance ?? this.breakDistance,
      useHapticsOnBreak: useHapticsOnBreak ?? this.useHapticsOnBreak,
    );
  }

  @override
  List<Object> get props => [
        breakDistance,
        useHapticsOnBreak,
      ];

  @override
  bool get stringify => true;
}
