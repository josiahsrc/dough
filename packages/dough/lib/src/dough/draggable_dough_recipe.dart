import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'dough_recipe.dart';
import 'draggable_dough.dart';

part 'draggable_dough_recipe.freezed.dart';

/// Preferences applied to [DraggableDough] widgets.
@freezed
class DraggableDoughRecipeData with _$DraggableDoughRecipeData {
  /// Creates [DraggableDough] preferences.
  const factory DraggableDoughRecipeData({
    /// The logical pixel distance at which the [DraggableDough] should
    /// elastically break its hold on the origin and enter a freely movable
    /// state.
    @Default(80) double breakDistance,

    /// Whether [DraggableDough] widgets should trigger haptic feedback when
    /// the dough breaks its hold on the origin.
    @Default(true) bool useHapticsOnBreak,
  }) = _DraggableDoughRecipeData;
}

/// Inherited settings for [DraggableDough] widgets. Use this to override
/// the default [DraggableDough] settings.
class DraggableDoughRecipe extends StatelessWidget {
  /// Creates an instance of a [DraggableDoughRecipe].
  const DraggableDoughRecipe({
    Key? key,
    this.data,
    required this.child,
  }) : super(key: key);

  static const _kFallback = DraggableDoughRecipeData();

  /// The [DraggableDoughRecipeData] applied to all child [DraggableDough]
  /// widgets.
  final DraggableDoughRecipeData? data;

  /// The child to apply these settings to.
  final Widget child;

  /// Gets the inherited [DraggableDoughRecipeData]. If no recipe is found a 
  /// default one will be returned instead.
  static DraggableDoughRecipeData of(
    BuildContext context, {
    bool listen = true,
  }) =>
      DoughRecipe.of(
        context,
        listen: listen,
      ).draggableDoughRecipe;

  @override
  Widget build(BuildContext context) {
    return DoughRecipe(
      data: DoughRecipe.of(context).copyWith(
        draggableDoughRecipe: data ?? _kFallback,
      ),
      child: child,
    );
  }
}
