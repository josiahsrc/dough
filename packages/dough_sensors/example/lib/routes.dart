import 'main.dart';

import 'demos/gyro_dough_demo.dart';

class Routes {
  static final kHome = '/';
  static final kGyroDoughDemo = '/gyro-dough';

  static define() => {
        kHome: (context) => HomePage(),
        kGyroDoughDemo: (context) => GyroDoughDemo(),
      };
}
