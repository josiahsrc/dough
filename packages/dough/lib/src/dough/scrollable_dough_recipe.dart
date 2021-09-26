import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'dough_recipe.dart';

part 'scrollable_dough_recipe.freezed.dart';

/// Preferences applied to scrollable dough widgets.
@freezed
class ScrollableDoughRecipeData with _$ScrollableDoughRecipeData {
  /// Creates [ScrollableDoughRecipeData] preferences.
  const factory ScrollableDoughRecipeData() = _ScrollableDoughRecipeData;
}

/// Inherited settings for scrollable dough widgets. Use this to override
/// the default [ScrollableDoughRecipeData] settings.
class ScrollableDoughRecipe extends StatelessWidget {
  /// Creates an instance of a [ScrollableDoughRecipe].
  const ScrollableDoughRecipe({
    Key? key,
    this.data,
    required this.child,
  }) : super(key: key);

  static const _kFallback = ScrollableDoughRecipeData();

  /// The [ScrollableDoughRecipeData] applied to all child scrollable dough
  /// widgets.
  final ScrollableDoughRecipeData? data;

  /// The child to apply these settings to.
  final Widget child;

  /// Gets the inherited [ScrollableDoughRecipeData]. If no recipe is found a
  /// default one will be returned instead.
  static ScrollableDoughRecipeData of(
    BuildContext context, {
    bool listen = true,
  }) =>
      DoughRecipe.of(
        context,
        listen: listen,
      ).scrollableDoughRecipe;

  @override
  Widget build(BuildContext context) {
    return DoughRecipe(
      data: DoughRecipe.of(context).copyWith(
        scrollableDoughRecipe: data ?? _kFallback,
      ),
      child: child,
    );
  }
}
