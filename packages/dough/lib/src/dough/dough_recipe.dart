import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';

import 'dough.dart';
import 'dough_controller.dart';
import 'draggable.dart';
import 'draggable_recipe.dart';
import 'gyro.dart';
import 'gyro_recipe.dart';

part 'dough_recipe.freezed.dart';

/// Inherited settings for [Dough] widgets. Use this to override
/// the default [Dough] settings.
@immutable
class DoughRecipe extends StatelessWidget {
  /// Creates a [DoughRecipe] widget.
  const DoughRecipe({
    Key? key,
    required this.child,
    this.data,
  }) : super(key: key);

  /// The fallback recipe.
  static const DoughRecipeData _kFallbackRecipe = DoughRecipeData();

  /// This widget's child. Any [Dough] widget below this widget will inherit
  /// the [data] provided in this recipe.
  final Widget child;

  /// The settings to be applied to all [Dough] widgets below this widget.
  final DoughRecipeData? data;

  /// Gets the inherited [DoughRecipeData]. If no recipe is found,
  /// a default one will be returned instead.
  static DoughRecipeData of(
    BuildContext context, [
    bool listen = true,
  ]) {
    try {
      return Provider.of<DoughRecipeData>(context, listen: listen);
    } on ProviderNotFoundException catch (_) {
      return _kFallbackRecipe;
    }
  }

  /// Gets the inherited [DoughRecipeData] without listening to it. If no
  /// recipe is found, a default one will be returned instead.
  static DoughRecipeData read(BuildContext context) {
    return of(context, false);
  }

  /// Gets the inherited [DoughRecipeData] and listens to it. If no recipe
  /// is found, a default one will be returned instead.
  static DoughRecipeData watch(BuildContext context) {
    return of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: data ?? _kFallbackRecipe,
      child: child,
    );
  }
}

/// Settings which will be applied to the [Dough] widget at runtime.
/// Also includes fields that are common to all supported dough-like
/// widgets.
@freezed
class DoughRecipeData with _$DoughRecipeData {
  /// Creates a DoughRecipeData.
  const factory DoughRecipeData({
    /// How 'thick' a [Dough] widget is. Higher values make for harder/less
    /// elastic [Dough]. A typical value would be something like 7000. Lower
    /// values like 100 will result in unexpected behaviors.
    @Default(7000) double viscosity,

    /// How sticky a [Dough] widget is. Higher values result in [Dough] that
    /// doesn't move around a lot when its dragged. Lower values result in
    /// really "slippery" [Dough]. A typical value would be something like 12.
    @Default(12) double adhesion,

    /// The factor by which a [Dough] widget expands when activated.
    @Default(1) double expansion,

    /// Whether perspective warping should be used. When enabled, [Dough] 
    /// widgets will perform a 3D rotation slightly towards 
    /// [DoughController.delta]. This will give the illusion that the dough 
    /// has mass and make it feel more jiggly.
    @Default(false) bool usePerspectiveWarp,

    /// The depth of the perspective warp. A typical value would be something
    /// like 0.015.
    @Default(0.015) double perspectiveWarpDepth,

    /// How long a [Dough] widget takes to transition into a squished state.
    @Default(Duration(milliseconds: 20)) Duration entryDuration,

    /// The curve by which a [Dough] widget enters a squished state.
    @Default(Curves.easeInOut) Curve entryCurve,

    /// How long a [Dough] widget takes to transition out of a squished state.
    @Default(Duration(milliseconds: 500)) Duration exitDuration,

    /// The curve by which a [Dough] widget exits a squished state.
    @Default(Curves.elasticIn) Curve exitCurve,

    /// Default settings applied to [DraggableDough] widgets.
    @Default(DraggableDoughPrefs()) DraggableDoughPrefs draggablePrefs,

    /// Default settings applied to [GyroDough] widgets.
    @Default(GyroDoughPrefs()) GyroDoughPrefs gyroPrefs,
  }) = _DoughRecipeData;
}
