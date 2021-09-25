import 'package:dough/dough.dart';
import 'package:dough/utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';

import 'gyro.dart';

part 'gyro_recipe.freezed.dart';

/// Preferences applied to [GyroDough] widgets.
@freezed
class GyroDoughRecipeData with _$GyroDoughRecipeData {
  /// Creates [GyroDough] preferences.
  const factory GyroDoughRecipeData({
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
  }) = _GyroDoughRecipeData;
}

/// Inherited settings for [GyroDough] widgets. Use this to override
/// the default [GyroDough] settings.
class GyroDoughRecipe extends StatelessWidget {
  /// Creates an instance of a [GyroDoughRecipe].
  const GyroDoughRecipe({
    Key? key,
    required this.data,
    required this.child,
  }) : super(key: key);

  static const _kFallback = GyroDoughRecipeData();

  /// The [GyroDoughRecipeData] applied to all child [GyroDough] widgets.
  final GyroDoughRecipeData? data;

  /// The child to apply these settings to.
  final Widget child;

  /// Gets the inherited receipe. If no recipe is found a default one will
  /// be returned instead.
  static GyroDoughRecipeData of(
    BuildContext context, {
    bool listen = true,
  }) =>
      ProviderUtils.of<GyroDoughRecipeData>(
        context: context,
        listen: listen,
        fallback: _kFallback,
      );

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: data ?? _kFallback,
      child: child,
    );
  }
}
