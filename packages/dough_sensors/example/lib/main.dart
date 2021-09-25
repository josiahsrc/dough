import 'package:flutter/material.dart';
import 'package:dough_sensors/dough_sensors.dart';

import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: Routes.define(),
      initialRoute: Routes.kHome,
    );
  }
}

/// This page just provides links to the different dough widget examples.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    final pageList = [
      ListTile(
        title: Text('Gyro Dough'),
        onTap: () => nav.pushNamed(Routes.kGyroDoughDemo),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: ListView(children: pageList),
    );
  }
}
