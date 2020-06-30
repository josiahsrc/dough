import 'main.dart';

import 'dough_demo_pages/pressable_dough.dart';

class Routes {
  static final kHome = '/';
  static final kPressableDough = '/pressable-dough';
  static final kDraggableDough = '/draggable-dough';

  static dynamic define() => {
        kHome: (context) => HomePage(),
        kPressableDough: (context) => PressableDoughPage(),
        kDraggableDough: (context) => PressableDoughPage(),
      };
}
