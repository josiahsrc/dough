part of dough;

/// Inherited settings for [Dough] widgets. Use this to override
/// the default [Dough] settings.
@immutable
class DoughRecipe extends InheritedWidget {
  static final DoughRecipeData _kFallbackRecipe = DoughRecipeData.fallback();

  /// The settings to use.
  final DoughRecipeData data;

  /// Creates a [DoughRecipe] widget.
  const DoughRecipe({
    Key key,
    @required Widget child,
    this.data,
  }) : super(key: key, child: child);

  /// Gets the inherited [DoughRecipeData]. If no recipe is found,
  /// a default one will be returned instead.
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
class DoughRecipeData extends Equatable {
  /// How 'thick' a [Dough] widget is. Higher values make for harder/less
  /// elastic [Dough]. A typical value would be something like 7000. Lower
  /// values like 100 will result in unexpected behaviors.
  final double viscosity;

  /// How sticky a [Dough] widget is. Higher values result in [Dough] that
  /// doesn't move around a lot when its dragged. Lower values result in
  /// really "slippery" [Dough]. A typical value would be something like 12.
  final double adhesion;

  /// The factor by which a [Dough] widget expands when activated.
  final double expansion;

  /// Whether perspective warping should be used. When enabled, [Dough] widgets
  /// will perform a 3D rotation slightly towards [DoughController.delta]. This
  /// will give the illusion that the dough has mass and make it feel more jiggly.
  final bool usePerspectiveWarp;

  /// The depth of the perspective warp. A typical value would be something like 0.015.
  final double perspectiveWarpDepth;

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

  /// Creates a raw recipe, all values must be specified.
  const DoughRecipeData.raw({
    @required this.viscosity,
    @required this.adhesion,
    @required this.expansion,
    @required this.usePerspectiveWarp,
    @required this.perspectiveWarpDepth,
    @required this.entryDuration,
    @required this.entryCurve,
    @required this.exitDuration,
    @required this.exitCurve,
    @required this.draggablePrefs,
  });

  /// Creates a recipe.
  factory DoughRecipeData({
    double viscosity,
    double adhesion,
    double expansion,
    bool usePerspectiveWarp,
    double perspectiveWarpDepth,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
    DraggableDoughPrefs draggablePrefs,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? 7000,
      adhesion: adhesion ?? 12,
      expansion: expansion ?? 1,
      usePerspectiveWarp: usePerspectiveWarp ?? false,
      perspectiveWarpDepth: perspectiveWarpDepth ?? 0.015,
      entryDuration: entryDuration ?? const Duration(milliseconds: 20),
      entryCurve: entryCurve ?? Curves.easeInOut,
      exitDuration: exitDuration ?? const Duration(milliseconds: 500),
      exitCurve: exitCurve ?? Curves.elasticIn,
      draggablePrefs: draggablePrefs ?? DraggableDoughPrefs.fallback(),
    );
  }

  /// Creates the fallback recipe.
  factory DoughRecipeData.fallback() => DoughRecipeData();

  // TODO :-)
  // /// A constructor designed to be used by the finest chefs.
  // factory DoughRecipeData.leChef({
  //   double poundsOfFlour = 10,
  //   double cupsOfWater = 5,
  //   double teaspoonsOfHoney = 2,
  // }) {
  //   return DoughRecipeData(
  //     viscosity: 100 * poundsOfFlour - cupsOfWater * 50,
  //   );
  // }

  /// Copies the current recipe with some new values.
  DoughRecipeData copyWith({
    double viscosity,
    double adhesion,
    double expansion,
    bool usePerspectiveWarp,
    double perspectiveWarpDepth,
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
      usePerspectiveWarp: usePerspectiveWarp ?? this.usePerspectiveWarp,
      perspectiveWarpDepth: perspectiveWarpDepth ?? this.perspectiveWarpDepth,
      entryDuration: entryDuration ?? this.entryDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitDuration: exitDuration ?? this.exitDuration,
      exitCurve: exitCurve ?? this.exitCurve,
      draggablePrefs: draggablePrefs ?? this.draggablePrefs,
    );
  }

  @override
  List<Object> get props => [
        viscosity,
        adhesion,
        expansion,
        usePerspectiveWarp,
        perspectiveWarpDepth,
        entryDuration,
        entryCurve,
        exitDuration,
        exitCurve,
        draggablePrefs,
      ];

  @override
  bool get stringify => true;
}
