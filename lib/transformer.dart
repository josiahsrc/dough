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

  /// Creates the [Matrix4] which will be used to transform the [Dough.child] widget.
  Matrix4 createDoughMatrix();

  /// A utility method which creates a [Matrix4] that scales widgets by a factor of
  /// [DoughRecipe.expansion].
  @protected
  Matrix4 createExpansionMatrix() {
    // TODO:
    // Try to recreate photoshop's liquify effect to push pixels closest to the press
    // point (target) away (1/x). This could give illusion that the screen is squishy
    // dough.
    final scaleMag = ui.lerpDouble(1, recipe.expansion, t);
    return Matrix4.identity()..scale(scaleMag);
  }

  /// A utility method which creates a [Matrix4] that perspectively rotates wigets around
  /// their yaw and pitch axes based on [delta] and [DoughRecipe.viscosity].
  @protected
  Matrix4 createPerspectiveWarpMatrix() {
    if (!recipe.usePerspectiveWarp) {
      return Matrix4.identity();
    }

    final perspDelta = -delta * t / recipe.viscosity;
    return Matrix4.identity()
      ..setEntry(3, 2, recipe.perspectiveWarpDepth)
      ..rotateY(-perspDelta.x)
      ..rotateX(perspDelta.y)
      ..scale(perspDelta.length / recipe.viscosity + 1);
  }

  /// A utility method which creates a [Matrix4] that skews widgets in the direction
  /// of the [delta] based on the [DoughRecipe.viscosity].
  @protected
  Matrix4 createViscositySkewMatrix() {
    final rotateAway = Matrix4.rotationZ(-deltaAngle);
    final rotateTowards = Matrix4.rotationZ(deltaAngle);

    final skewSize = t * delta.length / recipe.viscosity;
    final skew = Matrix4.columns(
      vmath.Vector4(1, skewSize, 0, 0),
      vmath.Vector4(skewSize, 1, 0, 0),
      vmath.Vector4(0, 0, 1, 0),
      vmath.Vector4(0, 0, 0, 1),
    );

    return rotateAway * skew * rotateTowards;
  }

  /// A utility method which creates the default dough squishing [Matrix4]. The resulting
  /// [Matrix4] doesn't apply translations, only other warping deformations based on the
  /// [recipe].
  ///
  /// You can basically think of this as the core squish behavior.
  @protected
  Matrix4 createSquishDeformationMatrix() {
    return createPerspectiveWarpMatrix() *
        createViscositySkewMatrix() *
        createExpansionMatrix();
  }

  @Deprecated('Use createExpansionMatrix() instead')
  @protected
  Matrix4 expansionMatrix() => createExpansionMatrix();

  @Deprecated('Use Matrix4.rotationZ(deltaAngle) instead')
  @protected
  Matrix4 rotateTowardDeltaMatrix() => Matrix4.rotationZ(deltaAngle);

  @Deprecated('Use Matrix4.rotationZ(-deltaAngle) instead')
  @protected
  Matrix4 rotateAwayFromDeltaMatrix() => Matrix4.rotationZ(-deltaAngle);

  @Deprecated('Use createViscositySkewMatrix() instead')
  @protected
  Matrix4 bendWithDeltaMatrix() => createViscositySkewMatrix();
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

    return translate * createSquishDeformationMatrix();
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
    final adhesiveDelta = delta * t / recipe.adhesion;

    Matrix4 translate;
    if (applyDelta) {
      if (snapToTargetOnStop) {
        final effDelta = -delta * (controller.isActive ? 1 : t);
        translate = Matrix4.translationValues(
          effDelta.x + adhesiveDelta.x,
          effDelta.y + adhesiveDelta.y,
          0,
        );
      } else {
        translate = Matrix4.translationValues(
          -delta.x + adhesiveDelta.x,
          -delta.y + adhesiveDelta.y,
          0,
        );
      }
    } else {
      translate = Matrix4.translationValues(
        adhesiveDelta.x,
        adhesiveDelta.y,
        0,
      );
    }

    return translate * createSquishDeformationMatrix();
  }
}
