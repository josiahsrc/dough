import 'package:dough_tester/pages/pressable_dough.dart';

import 'pages/home.dart';

class Routes {
  static final kHome = '/';
  static final kPressableDough = '/pressable-dough';

  static dynamic define() => {
        kHome: (context) => HomePage(),
        kPressableDough: (context) => PressableDoughPage(),
      };
}
