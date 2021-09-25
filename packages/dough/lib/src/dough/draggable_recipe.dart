import 'package:freezed_annotation/freezed_annotation.dart';

import 'draggable.dart';

part 'draggable_recipe.freezed.dart';

/// Preferences applied to [DraggableDough] widgets.
@freezed
class DraggableDoughPrefs with _$DraggableDoughPrefs {
  /// Creates [DraggableDough] preferences.
  const factory DraggableDoughPrefs({
    /// The logical pixel distance at which the [DraggableDough] should
    /// elastically break its hold on the origin and enter a freely movable
    /// state.
    @Default(80) double breakDistance,

    /// Whether [DraggableDough] widgets should trigger haptic feedback when
    /// the dough breaks its hold on the origin.
    @Default(true) bool useHapticsOnBreak,
  }) = _DraggableDoughPrefs;
}
