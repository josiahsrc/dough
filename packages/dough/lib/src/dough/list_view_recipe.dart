import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'dough_recipe.dart';
import 'list_view.dart';

part 'list_view_recipe.freezed.dart';

/// Preferences applied to [ListViewDough] widgets.
@freezed
class ListViewDoughRecipeData with _$ListViewDoughRecipeData {
  /// Creates [ListViewDoughRecipeData] preferences.
  const factory ListViewDoughRecipeData() = _ListViewDoughRecipeData;
}

/// Inherited settings for [ListViewDough] widgets. Use this to override
/// the default [ListViewDough] settings.
class ListViewDoughRecipe extends StatelessWidget {
  /// Creates an instance of a [ListViewDoughRecipe].
  const ListViewDoughRecipe({
    Key? key,
    this.data,
    required this.child,
  }) : super(key: key);

  static const _kFallback = ListViewDoughRecipeData();

  /// The [ListViewDoughRecipeData] applied to all child [ListViewDough]
  /// widgets.
  final ListViewDoughRecipeData? data;

  /// The child to apply these settings to.
  final Widget child;

  /// Gets the inherited [ListViewDoughRecipeData]. If no recipe is found a 
  /// default one will be returned instead.
  static ListViewDoughRecipeData of(
    BuildContext context, {
    bool listen = true,
  }) =>
      DoughRecipe.of(
        context,
        listen: listen,
      ).listViewDoughRecipe;

  @override
  Widget build(BuildContext context) {
    return DoughRecipe(
      data: DoughRecipe.of(context).copyWith(
        listViewDoughRecipe: data ?? _kFallback,
      ),
      child: child,
    );
  }
}
