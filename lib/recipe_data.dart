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
    return DoughRecipeData.raw(
      viscosity: viscosity ?? 10000,
      adhesion: adhesion ?? 14,
      entryDuration: entryDuration ?? const Duration(milliseconds: 50),
      entryCurve: entryCurve ?? Curves.easeInOut,
      exitDuration: exitDuration ?? const Duration(milliseconds: 500),
      exitCurve: exitCurve ?? Curves.elasticIn,
    );
  }

  DoughRecipeData copyWith({
    double viscosity,
    double adhesion,
    Duration entryDuration,
    Curve entryCurve,
    Duration exitDuration,
    Curve exitCurve,
  }) {
    return DoughRecipeData.raw(
      viscosity: viscosity ?? this.viscosity,
      adhesion: adhesion ?? this.adhesion,
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
      entryDuration,
      entryCurve,
      exitDuration,
      exitCurve,
    ];

    return hashList(values);
  }

  factory DoughRecipeData.fallback() => DoughRecipeData();
}
