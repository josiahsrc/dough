import 'package:freezed_annotation/freezed_annotation.dart';

import 'dough.dart';
import 'gyro.dart';

part 'gyro_recipe.freezed.dart';

/// Preferences applied to [GyroDough] widgets.
///
/// Please note that this widget will be moved over to a separate package
/// to remove a platform depedency.
@freezed
class GyroDoughPrefs with _$GyroDoughPrefs {
  /// Creates [GyroDough] preferences.
  const factory GyroDoughPrefs({
    /// The number of samples to use in the final gyro output. In technical
    /// terms, this value controls the intensity of 'low-pass filter' applied
    /// to a device's accelerometer.
    ///
    /// Higher values result in smoother gyro effects (slow-ish [Dough]), while
    /// lower values result in quick (and possibly more jagged) [Dough] effects.
    ///
    /// A typical value would be something like `10`. The minimum accepted
    /// sample count is `1`.
    @Default(10) int sampleCount,

    /// The value by which accelerometer values are multiplied. A higher
    /// value will result in [Dough] that is more sensitive to motion.
    ///
    /// A typical value would be something like `100`.
    @Default(100) double gyroMultiplier,
  }) = _GyroDoughPrefs;
}
