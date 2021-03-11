library dough;

import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sensors/sensors.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

part 'src/controller.dart';
part 'src/dough.dart';
part 'src/recipe.dart';
part 'src/transformer.dart';
part 'src/utilsold/vector_utils.dart';
part 'src/widgets/draggable.dart';
part 'src/widgets/gyro.dart';
part 'src/widgets/pressable.dart';
