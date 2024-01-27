import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Returns the recipe of type [T] from the context, or [fallbackData] if no
/// recipe was found.
T recipeOf<T extends Equatable>({
  required BuildContext context,
  required T fallbackData,
  required bool listen,
}) {
  try {
    return Provider.of<T>(context, listen: listen);
  } on ProviderNotFoundException {
    return fallbackData;
  }
}

/// Returns the recipe of type [T] from the context, or null if no recipe
/// was found.
T? maybeRecipeOf<T extends Equatable>({
  required BuildContext context,
  required bool listen,
}) {
  try {
    return Provider.of<T>(context, listen: listen);
  } on ProviderNotFoundException {
    return null;
  }
}

/// Inherited settings for squishy widgets. Use this to override
/// the default squishy settings. Callers may implement this interface
/// to expose their own recipes through the context.
abstract class AbstractRecipe<T extends Equatable> extends StatelessWidget {
  /// Creates a [AbstractRecipe] widget.
  const AbstractRecipe({
    super.key,
    this.data,
    required this.child,
  });

  /// This widget's child. Any squishy widget below this widget will inherit
  /// the [data] provided in this recipe.
  final Widget child;

  /// The settings to be applied to all relevant squishy widgets below this
  /// widget.
  final T? data;

  /// The fallback recipe.
  T get fallback;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: data ?? fallback,
      child: child,
    );
  }
}
