import 'package:flutter/material.dart';
import 'package:dough/dough.dart';

import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: Routes.define(),
      initialRoute: Routes.kHome,
    );

    // Optionally, apply your own default dough recipe to your
    // whole app if you don't like the built in recipe. All dough
    // widgets will then default to use these settings.
    return DoughRecipe(
      data: DoughRecipeData(
        viscosity: 5000,
        adhesion: 14,
      ),
      child: app,
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
        title: Text('Dough Recipe'),
        onTap: () => nav.pushNamed(Routes.kDoughRecipeDemo),
      ),
      Divider(),
      ListTile(
        title: Text('Pressable Dough'),
        onTap: () => nav.pushNamed(Routes.kPressableDough),
      ),
      ListTile(
        title: Text('Draggable Dough'),
        onTap: () => nav.pushNamed(Routes.kDraggableDough),
      ),
      Divider(),
      ListTile(
        title: Text('Custom Dough'),
        onTap: () => nav.pushNamed(Routes.kCustomDough),
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
