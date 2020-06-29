part of dough;

/// Inherited settings for dough widgets. Use this to override
/// the default dough settings.
@immutable
class DoughRecipe extends InheritedWidget {
  static final DoughRecipeData _kFallbackRecipe = DoughRecipeData.fallback();

  /// The settings to use.
  final DoughRecipeData data;

  const DoughRecipe({
    Key key,
    @required Widget child,
    this.data,
  }) : super(key: key, child: child);

  /// Gets the inherited [DoughRecipeData]. If no recipe is found,
  /// a default one will be used instead.
  static DoughRecipeData of(BuildContext context) {
    final ih = context.dependOnInheritedWidgetOfExactType<DoughRecipe>();
    return ih?.data ?? _kFallbackRecipe;
  }

  @override
  bool updateShouldNotify(covariant DoughRecipe old) {
    return this.data != old.data;
  }
}

/// Settings which will be applied to the [DoughWidget] on build.
@immutable
class DoughRecipeData {
  /// How thick the dough is. Higher values make for harder/less
  /// elastic dough. A typical value would be something like 10000.
  final double viscosity;

  /// How stick the dough is. Higher values result in dough that
  /// doesn't move around a lot when its dragged. Lower values
  /// result in really "slippery" dough. A typical value would be
  /// something like 14.
  final double adhesion;

  /// The factor by which the dough expands when pressed.
  final double expansion;

  /// How long the dough takes to transition into a squished state.
  final Duration entryDuration;

  /// The curve by which the dough enters a squished state.
  final Curve entryCurve;

  /// How long the dough takes to transition out of a squished state.
  final Duration exitDuration;

  /// The curve by which the dough exits a squished state.
  final Curve exitCurve;

  const DoughRecipeData.raw({
    @required this.viscosity,
    @required this.adhesion,
    @required this.expansion,
    @required this.entryDuration,
    @required this.entryCurve,
    @required this.exitDuration,
    @required this.exitCurve,
  });

  factory DoughRecipeData({
    double viscosity,
    double adhesion,
    double expansion,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? 10000,
      adhesion: adhesion ?? 14,
      expansion: expansion ?? 1,
      entryDuration: entryDuration ?? const Duration(milliseconds: 200),
      entryCurve: entryCurve ?? Curves.easeInOut,
      exitDuration: exitDuration ?? const Duration(milliseconds: 500),
      exitCurve: exitCurve ?? Curves.elasticIn,
    );
  }

  // TODO :-)
  // factory DoughRecipeData.leChef({
  //   double poundsOfFlour = 10,
  //   double cupsOfWater = 5,
  //   double teaspoonsOfHoney,
  // }) {
  //   throw UnimplementedError();
  // }

  /// Copies the current recipe with some new values.
  DoughRecipeData copyWith({
    double viscosity,
    double adhesion,
    double expansion,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? this.viscosity,
      adhesion: adhesion ?? this.adhesion,
      expansion: expansion ?? this.expansion,
      entryDuration: entryDuration ?? this.entryDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitDuration: exitDuration ?? this.exitDuration,
      exitCurve: exitCurve ?? this.exitCurve,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;

    return other is DoughRecipeData &&
        other.viscosity == viscosity &&
        other.adhesion == adhesion &&
        other.expansion == expansion &&
        other.entryDuration == entryDuration &&
        other.entryCurve == entryCurve &&
        other.exitDuration == exitDuration &&
        other.exitCurve == exitCurve;
  }

  @override
  int get hashCode {
    final values = <Object>[
      viscosity,
      adhesion,
      expansion,
      entryDuration,
      entryCurve,
      exitDuration,
      exitCurve,
    ];

    return hashList(values);
  }

  factory DoughRecipeData.fallback() => DoughRecipeData();
}
