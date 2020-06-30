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
    // widgets will default to using these settings.
    return DoughRecipe(
      data: DoughRecipeData(
        adhesion: 14,
      ),
      child: app,
    );
  }
}

/// This page just provides links to the different dough widget
/// examples.
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    final links = [
      ListTile(
        title: Text('Pressable Dough'),
        onTap: () => nav.pushNamed(Routes.kPressableDough),
      ),
      ListTile(
        title: Text('Draggable Dough'),
        onTap: () => nav.pushNamed(Routes.kDraggableDough),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: ListView(children: links),
    );
  }
}
