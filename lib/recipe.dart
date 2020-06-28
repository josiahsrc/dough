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

@immutable
class DoughRecipeData {
  final double viscosity;
  final double adhesion;
  final double expansion;
  final Duration entryDuration;
  final Curve entryCurve;
  final Duration exitDuration;
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
      expansion: expansion ?? 1.05,
      entryDuration: entryDuration ?? const Duration(milliseconds: 200),
      entryCurve: entryCurve ?? Curves.easeInOut,
      exitDuration: exitDuration ?? const Duration(milliseconds: 500),
      exitCurve: exitCurve ?? Curves.elasticIn,
    );
  }

  factory DoughRecipeData.leChef({
    double poundsOfFlour,
    double cupsOfWater,
    double teaspoonsOfHoney,
  }) {
    throw UnimplementedError();
  }

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
