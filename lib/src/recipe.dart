part of dough;

/// Inherited settings for [Dough] widgets. Use this to override
/// the default [Dough] settings.
@immutable
class DoughRecipe extends StatelessWidget {
  /// Creates a [DoughRecipe] widget.
  const DoughRecipe({
    Key key,
    @required this.child,
    this.data,
  })  : assert(child != null),
        super(key: key);

  /// The fallback recipe.
  static final DoughRecipeData _kFallbackRecipe = DoughRecipeData.fallback();

  /// This widget's child. Any [Dough] widget below this widget will inherit
  /// the [data] provided in this recipe.
  final Widget child;

  /// The settings to be applied to all [Dough] widgets below this widget.
  final DoughRecipeData data;

  /// Gets the inherited [DoughRecipeData]. If no recipe is found,
  /// a default one will be returned instead.
  static DoughRecipeData of(
    BuildContext context, [
    bool listen = true,
  ]) {
    assert(listen != null);
    try {
      return Provider.of<DoughRecipeData>(context, listen: listen);
    } on ProviderNotFoundException catch (_) {
      return _kFallbackRecipe;
    }
  }

  /// Gets the inherited [DoughRecipeData] without listening to it. If no
  /// recipe is found, a default one will be returned instead.
  static DoughRecipeData read(BuildContext context) {
    return of(context, false);
  }

  /// Gets the inherited [DoughRecipeData] and listens to it. If no recipe
  /// is found, a default one will be returned instead.
  static DoughRecipeData watch(BuildContext context) {
    return of(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: data ?? _kFallbackRecipe,
      child: child,
    );
  }
}

/// Settings which will be applied to the [DoughWidget] on build.
@immutable
class DoughRecipeData extends Equatable {
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
    @required this.gyroPrefs,
  })  : assert(viscosity != null),
        assert(adhesion != null),
        assert(expansion != null),
        assert(usePerspectiveWarp != null),
        assert(perspectiveWarpDepth != null),
        assert(entryDuration != null),
        assert(entryCurve != null),
        assert(exitDuration != null),
        assert(exitCurve != null),
        assert(draggablePrefs != null),
        assert(gyroPrefs != null);

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
    GyroDoughPrefs gyroPrefs,
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
      gyroPrefs: gyroPrefs ?? GyroDoughPrefs.fallback(),
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
  /// will give the illusion that the dough has mass and make it feel more
  /// jiggly.
  final bool usePerspectiveWarp;

  /// The depth of the perspective warp. A typical value would be something
  /// like 0.015.
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

  /// Default settings applied to [GyroDough] widgets.
  final GyroDoughPrefs gyroPrefs;

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
    GyroDoughPrefs gyroPrefs,
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
      gyroPrefs: gyroPrefs ?? this.gyroPrefs,
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
        gyroPrefs,
      ];

  @override
  bool get stringify => true;
}
