import 'main.dart';

import 'dough_widget_demos/pressable_demo.dart';
import 'dough_widget_demos/draggable_demo.dart';

class Routes {
  static final kHome = '/';
  static final kPressableDough = '/pressable-dough';
  static final kDraggableDough = '/draggable-dough';

  static dynamic define() => {
        kHome: (context) => HomePage(),
        kPressableDough: (context) => PressableDoughDemo(),
        kDraggableDough: (context) => DraggableDoughDemo(),
      };
}
