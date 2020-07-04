part of dough;

/// The strategy for how to transform the [Dough.child] widget. Override
/// this class to create your own dough-like squish effects. You can apply
/// your custom [DoughTransformer] strategy using the [Dough.transformer]
/// property.
///
/// See [BasicDoughTransformer] for an example on how to do this.
abstract class DoughTransformer {
  double _rawT;
  double _t;
  DoughRecipeData _recipe;
  vmath.Vector2 _origin;
  vmath.Vector2 _target;
  vmath.Vector2 _delta;
  double _deltaAngle;
  DoughController _controller;

  /// The unscaled animation time clamped between 0 and 1.
  double get rawT => _rawT;

  /// The scaled animation time, based on [rawT], which has been transformed
  /// by the [DoughRecipeData.entryCurve] or [DoughRecipeData.exitCurve].
  double get t => _t;

  /// The contexual recipe applied to the associated [Dough] widget.
  DoughRecipeData get recipe => _recipe;

  /// The origin of the dough squish. This value is equivalent to
  /// [DoughController.origin], but is a vector instead of an offset.
  vmath.Vector2 get origin => _origin;

  /// The target of the dough squish. This value is equivalent to
  /// [DoughController.target], but is a vector instead of an offset.
  vmath.Vector2 get target => _target;

  /// The delta of the dough squish. This value is equivalent to
  /// [DoughController.delta], but is a vector instead of an offset.
  vmath.Vector2 get delta => _delta;

  /// The full-circle delta angle of the [delta] value, relative to the
  /// [Dough] widgets up direction. This value ranges between 0 radians
  /// and 2PI radians.
  double get deltaAngle => _deltaAngle;

  /// The controller for the associated [Dough] widget.
  DoughController get controller => _controller;

  /// Create the matrix which will be used to transform the [Dough.child] widget.
  vmath.Matrix4 createDoughMatrix();

  /// A utility method which returns a matrix that scales widgets.
  @protected
  vmath.Matrix4 expansionMatrix() {
    // TODO use a homography here to scale non-uniformly?
    final scaleMag = ui.lerpDouble(1, recipe.expansion, t);
    return Matrix4.identity()..scale(scaleMag, scaleMag, scaleMag);
  }

  /// A utility method which returns a matrix that rotates widgets in the direction
  /// of the [deltaAngle] property.
  @protected
  vmath.Matrix4 rotateTowardDeltaMatrix() {
    return Matrix4.rotationZ(deltaAngle);
  }

  /// A utility method which returns a matrix that rotates widgets int the opposite
  /// direction of the [deltaAngle] property.
  @protected
  vmath.Matrix4 rotateAwayFromDeltaMatrix() {
    return Matrix4.rotationZ(-deltaAngle);
  }

  /// A utility method which returns a matrix that skews widgets based on the
  /// [DoughRecipe.viscosity] property.
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

  /// A utility method which creates the "dough-squish" matrix. The resulting
  /// [Matrix4] will bend widgets in a dough-like fashion, without adhesion applied.
  @protected
  vmath.Matrix4 bendWithDeltaMatrix() {
    return rotateAwayFromDeltaMatrix() *
        skewWithViscosityMatrix() *
        rotateTowardDeltaMatrix();
  }
}

/// Transforms [Dough.child] widgets such that they stretch from their origin towards
/// the target with resistance pulling the widget back towards its origin.
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

/// Transforms [Dough.child] widgets such that they stretch towards their target
/// with adhesion applied. Additionally this transformer allows you to apply offset
/// to the child widget while being dragged to give the illusion that the draggable
/// widget is "resisting" being dragged until [DoughController.stop] is called.
class DraggableOverlayDoughTransformer extends DoughTransformer {
  /// Whether the controller's delta should be applied to the widget. This will offset
  /// the widget being dragged by [delta].
  final bool applyDelta;

  /// If [applyDelta] is true, this determines whether the widget should snap towards
  /// the target when [DoughController.stop] is called.
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
