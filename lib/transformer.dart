part of dough;

abstract class DoughTransformer {
  double _rawT;
  double _t;
  DoughRecipeData _recipe;
  vmath.Vector2 _origin;
  vmath.Vector2 _target;
  vmath.Vector2 _delta;
  double _deltaAngle;

  double get rawT => _rawT;
  double get t => _t;
  DoughRecipeData get recipe => _recipe;
  vmath.Vector2 get origin => _origin;
  vmath.Vector2 get target => _target;
  vmath.Vector2 get delta => _delta;
  double get deltaAngle => _deltaAngle;

  vmath.Matrix4 createDoughMatrix();

  @protected
  vmath.Matrix4 expansionMatrix() {
    // TODO use a homography here to scale non-uniformly?
    final scaleMag = ui.lerpDouble(1, recipe.expansion, t);
    return Matrix4.identity()..scale(scaleMag, scaleMag, scaleMag);
  }

  @protected
  vmath.Matrix4 rotateTowardDeltaMatrix() {
    return Matrix4.rotationZ(deltaAngle);
  }

  @protected
  vmath.Matrix4 rotateAwayFromDeltaMatrix() {
    return Matrix4.rotationZ(-deltaAngle);
  }

  @protected
  vmath.Matrix4 skewWithViscosityMatrix() {
    final skewSize = delta.length / recipe.viscosity;
    return Matrix4.columns(
      vmath.Vector4(1, t * skewSize, 0, 0),
      vmath.Vector4(t * skewSize, 1, 0, 0),
      vmath.Vector4(0, 0, 1, 0),
      vmath.Vector4(0, 0, 0, 1),
    );
  }

  @protected
  vmath.Matrix4 bendWithDeltaMatrix() {
    return rotateAwayFromDeltaMatrix() *
        skewWithViscosityMatrix() *
        rotateTowardDeltaMatrix();
  }
}

class BasicDoughTransformer extends DoughTransformer {
  @override
  Matrix4 createDoughMatrix() {
    final translate = Matrix4.translationValues(
      delta.x * t / recipe.adhesion,
      delta.y * t / recipe.adhesion,
      0,
    );

    return translate * bendWithDeltaMatrix() * expansionMatrix();
  }
}

// class DraggableOverlayDoughTransformer extends DoughTransformer {}
