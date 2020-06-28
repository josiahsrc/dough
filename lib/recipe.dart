part of dough;

@immutable
class DoughRecipe extends StatelessWidget {
  static final DoughRecipeData _kFallbackRecipe = DoughRecipeData.fallback();

  final Widget child;
  final DoughRecipeData data;

  const DoughRecipe({
    @required this.child,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _InheritedRecipe(
      recipe: this,
      child: child,
    );
  }

  static DoughRecipeData of(BuildContext context) {
    final ih = context.dependOnInheritedWidgetOfExactType<_InheritedRecipe>();
    return ih?.recipe?.data ?? _kFallbackRecipe;
  }
}

class _InheritedRecipe extends InheritedTheme {
  final DoughRecipe recipe;

  const _InheritedRecipe({
    Key key,
    @required this.recipe,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  Widget wrap(BuildContext context, Widget child) {
    final ancestor = context.findAncestorWidgetOfExactType<_InheritedRecipe>();
    return identical(this, ancestor)
        ? child
        : DoughRecipe(data: recipe.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedRecipe old) {
    return this.recipe.data != old.recipe.data;
  }
}
