part of dough;

abstract class DoughTransformer {
  double _rawT;
  double _t;
  DoughRecipeData _recipe;
  vmath.Vector2 _origin;
  vmath.Vector2 _target;
  vmath.Vector2 _delta;
  double _deltaAngle;
  DoughController _controller;

  double get rawT => _rawT;
  double get t => _t;
  DoughRecipeData get recipe => _recipe;
  vmath.Vector2 get origin => _origin;
  vmath.Vector2 get target => _target;
  vmath.Vector2 get delta => _delta;
  double get deltaAngle => _deltaAngle;
  DoughController get controller => _controller;

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

class DraggableOverlayDoughTransformer extends DoughTransformer {
  final bool applyDelta;
  final bool snapToTargetOnStop;

  DraggableOverlayDoughTransformer({
    @required this.applyDelta,
    @required this.snapToTargetOnStop,
  });

  @override
  Matrix4 createDoughMatrix() {
    final adhesiveDx = delta.x * t / recipe.adhesion;
    final adhesiveDy = delta.y * t / recipe.adhesion;

    Matrix4 translate;
    if (applyDelta) {
      if (snapToTargetOnStop) {
        final dx = -delta.x * (controller.isActive ? 1 : t);
        final dy = -delta.y * (controller.isActive ? 1 : t);
        translate = Matrix4.translationValues(
          dx + adhesiveDx,
          dy + adhesiveDy,
          0,
        );
      } else {
        translate = Matrix4.translationValues(
          -delta.x + adhesiveDx,
          -delta.y + adhesiveDy,
          0,
        );
      }
    } else {
      translate = Matrix4.translationValues(adhesiveDx, adhesiveDy, 0);
    }

    return translate * bendWithDeltaMatrix() * expansionMatrix();
  }
}
