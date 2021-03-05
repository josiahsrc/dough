import 'main.dart';

import 'dough_widget_demos/custom_dough_demo.dart';
import 'dough_widget_demos/gyro_dough_demo.dart';
import 'dough_widget_demos/pressable_dough_demo.dart';
import 'dough_widget_demos/draggable_dough_demo.dart';
import 'dough_widget_demos/dough_recipe_demo.dart';

class Routes {
  static final kHome = '/';
  static final kCustomDough = '/custom-dough';
  static final kPressableDough = '/pressable-dough';
  static final kDraggableDough = '/draggable-dough';
  static final kGyroDoughDemo = '/gyro-dough';
  static final kDoughRecipeDemo = '/dough-recipe';

  static define() => {
        kHome: (context) => HomePage(),
        kCustomDough: (context) => CustomDoughDemo(),
        kPressableDough: (context) => PressableDoughDemo(),
        kDraggableDough: (context) => DraggableDoughDemo(),
        kGyroDoughDemo: (context) => GyroDoughDemo(),
        kDoughRecipeDemo: (context) => DoughRecipeDemo(),
      };
}
