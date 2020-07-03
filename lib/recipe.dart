part of dough;

/// Inherited settings for [Dough] widgets. Use this to override
/// the default [Dough] settings.
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
  /// How 'thick' a [Dough] widget is. Higher values make for harder/less
  /// elastic [Dough]. A typical value would be something like 10000. Lower 
  /// values like 100 will result in unexpected behaviors.
  final double viscosity;

  /// How sticky a [Dough] widget is. Higher values result in [Dough] that
  /// doesn't move around a lot when its dragged. Lower values result in 
  /// really "slippery" [Dough]. A typical value would be something like 14.
  final double adhesion;

  /// The factor by which a [Dough] widget expands when pressed.
  final double expansion;

  /// How long a [Dough] widget takes to transition into a squished state.
  final Duration entryDuration;

  /// The curve by which a [Dough] widget enters a squished state.
  final Curve entryCurve;

  /// How long a [Dough] widget takes to transition out of a squished state.
  final Duration exitDuration;

  /// The curve by which a [Dough] widget exits a squished state.
  final Curve exitCurve;

  /// Default settings applied to [DraggableDough] widgets.
  final DraggableDoughPrefs draggablePrefs;

  const DoughRecipeData.raw({
    @required this.viscosity,
    @required this.adhesion,
    @required this.expansion,
    @required this.entryDuration,
    @required this.entryCurve,
    @required this.exitDuration,
    @required this.exitCurve,
    @required this.draggablePrefs,
  });

  factory DoughRecipeData({
    double viscosity,
    double adhesion,
    double expansion,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
    DraggableDoughPrefs draggablePrefs,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? 5000,
      adhesion: adhesion ?? 14,
      expansion: expansion ?? 1,
      entryDuration: entryDuration ?? const Duration(milliseconds: 20),
      entryCurve: entryCurve ?? Curves.easeInOut,
      exitDuration: exitDuration ?? const Duration(milliseconds: 500),
      exitCurve: exitCurve ?? Curves.elasticIn,
      draggablePrefs: draggablePrefs ?? DraggableDoughPrefs.fallback(),
    );
  }

  factory DoughRecipeData.fallback() => DoughRecipeData();

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
    DraggableDoughPrefs draggablePrefs,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? this.viscosity,
      adhesion: adhesion ?? this.adhesion,
      expansion: expansion ?? this.expansion,
      entryDuration: entryDuration ?? this.entryDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitDuration: exitDuration ?? this.exitDuration,
      exitCurve: exitCurve ?? this.exitCurve,
      draggablePrefs: draggablePrefs ?? this.draggablePrefs,
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
        other.exitCurve == exitCurve &&
        other.draggablePrefs == draggablePrefs;
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
      draggablePrefs,
    ];

    return hashList(values);
  }
}
