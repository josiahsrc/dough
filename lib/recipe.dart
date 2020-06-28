part of dough;

@immutable
class DoughRecipe extends InheritedWidget {
  static final DoughRecipeData _kFallbackRecipe = DoughRecipeData.fallback();

  final DoughRecipeData data;

  const DoughRecipe({
    Key key,
    @required Widget child,
    this.data,
  }) : super(key: key, child: child);

  static DoughRecipeData of(BuildContext context) {
    final ih = context.dependOnInheritedWidgetOfExactType<DoughRecipe>();
    return ih?.data ?? _kFallbackRecipe;
  }

  @override
  bool updateShouldNotify(covariant DoughRecipe old) {
    return this.data != old.data;
  }
}
