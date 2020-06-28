part of dough;

@immutable
class DoughRecipeData {
  final double viscosity;
  final double adhesion;
  final Duration entryDuration;
  final Curve entryCurve;
  final Duration exitDuration;
  final Curve exitCurve;

  const DoughRecipeData.raw({
    @required this.viscosity,
    @required this.adhesion,
    @required this.entryDuration,
    @required this.entryCurve,
    @required this.exitDuration,
    @required this.exitCurve,
  });

  factory DoughRecipeData({
    double viscosity,
    double adhesion,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
  }) {
    return null;
  }

  // const DoughRecipeData.raw({
  //   double viscosity,
  //   double adhesion,
  //   Duration entryDuration,
  //   Curve entryCurve,
  //   Duration exitDuration,
  //   Curve exitCurve,
  // })  : this.viscosity = viscosity ?? 10000,
  //       this.adhesion = adhesion ?? 14,
  //       this.entryDuration = entryDuration ?? const Duration(milliseconds: 50),
  //       this.entryCurve = entryCurve ?? Curves.easeInOut,
  //       this.exitDuration = exitDuration ?? const Duration(milliseconds: 500),
  //       this.exitCurve = exitCurve ?? Curves.elasticIn;

  factory DoughRecipeData.fallback() {
    return DoughRecipeData.raw(
      viscosity: 10000,
      adhesion: 14,
      entryDuration: const Duration(milliseconds: 50),
      entryCurve: Curves.easeInOut,
      exitDuration: const Duration(milliseconds: 500),
      exitCurve: Curves.elasticIn,
    );
  }
}