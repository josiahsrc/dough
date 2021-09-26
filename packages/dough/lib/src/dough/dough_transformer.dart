// ignore_for_file: prefer_int_literals

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

import 'dough.dart';
import 'dough_controller.dart';
import 'dough_recipe.dart';

part 'dough_transformer.freezed.dart';

/// A context passed to a [DoughTransformer]. This will contain a context
/// to inform the [DoughTransformer] on how to transform a widget.
@freezed
class DoughTransformerContext with _$DoughTransformerContext {
  /// Creates an instance of a [DoughTransformerContext].
  const factory DoughTransformerContext({
    /// The unscaled animation time clamped between 0 and 1.
    required double rawT,

    /// The scaled animation time, based on [rawT], which has been transformed
    /// by the [DoughRecipeData.entryCurve] or [DoughRecipeData.exitCurve].
    required double t,

    /// The contexual recipe applied to the associated [Dough] widget.
    required DoughRecipeData recipe,

    /// The origin of the dough squish. This value is equivalent to
    /// [DoughController.origin], but is a vector instead of an offset.
    required vmath.Vector2 origin,

    /// The target of the dough squish. This value is equivalent to
    /// [DoughController.target], but is a vector instead of an offset.
    required vmath.Vector2 target,

    /// The delta of the dough squish. This value is equivalent to
    /// [DoughController.delta], but is a vector instead of an offset.
    required vmath.Vector2 delta,

    /// The full-circle delta angle of the [delta] value, relative to the
    /// [Dough] widgets up direction. This value ranges between 0 radians
    /// and 2PI radians.
    required double deltaAngle,

    /// The controller for the associated [Dough] widget.
    required DoughController controller,

    /// The axis on which to constrain any stretching.
    required Axis? axis,
  }) = _DoughTransformerContext;

  // ignore: unused_element
  const DoughTransformerContext._();
}

/// A utility for common dough transformations.
class DoughTransformations {
  const DoughTransformations._();

  /// A utility method which creates a [Matrix4] that scales widgets by a
  /// factor of the `DoughRecipe.expansion` property (see [DoughRecipe]).
  static Matrix4 expansion(DoughTransformerContext context) {
    final scaleMag = ui.lerpDouble(
      1,
      context.recipe.expansion,
      context.t,
    );
    return Matrix4.identity()..scale(scaleMag);
  }

  /// A utility method which creates a [Matrix4] that perspectively rotates
  /// wigets around their yaw and pitch axes based on
  /// [_DoughTransformerContext.delta] and `DoughRecipe.viscosity`
  /// (see [DoughRecipe]).
  static Matrix4 perspectiveWarp(DoughTransformerContext context) {
    if (!context.recipe.usePerspectiveWarp) {
      return Matrix4.identity();
    }

    final perspDelta = -context.delta * context.t / context.recipe.viscosity;
    return Matrix4.identity()
      ..setEntry(3, 2, context.recipe.perspectiveWarpDepth)
      ..rotateY(-perspDelta.x)
      ..rotateX(perspDelta.y)
      ..scale(perspDelta.length / context.recipe.viscosity + 1);
  }

  /// Calculates the skew size for the provided context. This skew size
  /// is used for calculating the "squishy" transformations for Dough.
  static double viscositySkewSize(DoughTransformerContext context) {
    return context.t * context.delta.length / context.recipe.viscosity;
  }

  /// A utility method which creates a [Matrix4] that skews widgets in the
  /// direction of the [_DoughTransformerContext.delta] based on the
  /// `DoughRecipe.viscosity` (see [DoughRecipe]). If an
  /// [_DoughTransformerContext.axis] is specified, the resulting matrix
  /// will be constrained to the provided axis.
  static Matrix4 viscositySkew(DoughTransformerContext context) {
    final skewSize = DoughTransformations.viscositySkewSize(context);

    if (context.axis == Axis.vertical) {
      return Matrix4.identity()..scale(1, skewSize, 1);
    } else if (context.axis == Axis.horizontal) {
      return Matrix4.identity()..scale(skewSize, 1, 1);
    }

    final rotateAway = Matrix4.rotationZ(-context.deltaAngle);
    final rotateTowards = Matrix4.rotationZ(context.deltaAngle);
    final skew = Matrix4.columns(
      vmath.Vector4(1, skewSize, 0, 0),
      vmath.Vector4(skewSize, 1, 0, 0),
      vmath.Vector4(0, 0, 1, 0),
      vmath.Vector4(0, 0, 0, 1),
    );

    return rotateAway.multiplied(skew).multiplied(rotateTowards);
  }

  /// A utility method which creates the default dough squishing [Matrix4].
  /// The resulting [Matrix4] doesn't apply translations, only other warping
  /// deformations based on the [_DoughTransformerContext.recipe].
  ///
  /// You can basically think of this as the core squish behavior.
  static Matrix4 squishDeformation(DoughTransformerContext context) {
    final axis = context.axis;
    if (axis == null) {
      return perspectiveWarp(context)
          .multiplied(viscositySkew(context))
          .multiplied(expansion(context));
    }

    Matrix4 axisSkew;
    final skewSize = 1 + DoughTransformations.viscositySkewSize(context);
    if (axis == Axis.horizontal) {
      axisSkew = Matrix4.identity().scaled(skewSize, 1.0, 1.0);
    } else if (axis == Axis.vertical) {
      axisSkew = Matrix4.identity().scaled(1.0, skewSize, 1.0);
    } else {
      throw UnimplementedError();
    }

    return perspectiveWarp(context)
        .multiplied(axisSkew)
        .multiplied(expansion(context));
  }
}

/// The strategy for how to transform the [Dough.child] widget. Override
/// this class to create your own dough-like squish effects. You can apply
/// your custom [DoughTransformer] strategy using the [Dough.transformer]
/// property.
///
/// See [BasicDoughTransformer] for an example on how to do this.
abstract class DoughTransformer {
  /// Creates a DoughTransformer.
  DoughTransformer() : super();

  /// A callback raised after a transform has been invoked.
  @mustCallSuper
  void onPreTransform(DoughTransformerContext context) {}

  /// Creates the [Matrix4] which will be used to transform the [Dough.child]
  /// widget.
  Matrix4 transform(DoughTransformerContext context);

  /// A callback raised after a transform has been invoked.
  @mustCallSuper
  void onPostTransform(DoughTransformerContext context) {}
}

/// Transforms [Dough.child] widgets such that they stretch from their origin
/// towards the target with resistance pulling the widget back towards its
/// origin.
class BasicDoughTransformer extends DoughTransformer {
  /// Creates a [BasicDoughTransformer].
  BasicDoughTransformer() : super();

  @override
  Matrix4 transform(DoughTransformerContext context) {
    final translate = Matrix4.translationValues(
      context.delta.x * context.t / context.recipe.adhesion,
      context.delta.y * context.t / context.recipe.adhesion,
      0,
    );

    return translate
        .multiplied(DoughTransformations.squishDeformation(context));
  }
}

/// Transforms [Dough.child] widgets such that they stretch towards their
/// target with adhesion applied. Additionally this transformer allows you
/// to apply offset to the child widget while being dragged to give the
/// illusion that the draggable widget is "resisting" being dragged until
/// [DoughController.stop] is called.
class DraggableOverlayDoughTransformer extends DoughTransformer {
  /// Creates a DraggableOverlayDoughTransformer.
  DraggableOverlayDoughTransformer({
    required this.applyDelta,
    required this.snapToTargetOnStop,
  }) : super();

  /// Whether the controller's delta should be applied to the widget.
  /// This will offset the widget being dragged by
  /// [_DoughTransformerContext.delta].
  final bool applyDelta;

  /// If [applyDelta] is true, this determines whether the widget should
  /// snap towards the target when [DoughController.stop] is called.
  final bool snapToTargetOnStop;

  @override
  Matrix4 transform(DoughTransformerContext context) {
    final adhesiveDelta = context.delta * context.t / context.recipe.adhesion;

    Matrix4 translate;
    if (applyDelta) {
      if (snapToTargetOnStop) {
        final effDelta =
            -context.delta * (context.controller.isActive ? 1 : context.t);
        translate = Matrix4.translationValues(
          effDelta.x + adhesiveDelta.x,
          effDelta.y + adhesiveDelta.y,
          0,
        );
      } else {
        translate = Matrix4.translationValues(
          -context.delta.x + adhesiveDelta.x,
          -context.delta.y + adhesiveDelta.y,
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

    return translate
        .multiplied(DoughTransformations.squishDeformation(context));
  }
}
