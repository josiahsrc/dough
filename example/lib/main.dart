import 'package:flutter/material.dart';
import 'package:dough/dough.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );

    // Optionally apply your own default dough recipe to your
    // whole app if you don't like the built in recipe
    return DoughRecipe(
      data: DoughRecipeData(
        adhesion: 14,
      ),
      child: app,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Just a regular old floating action button
    final fab = FloatingActionButton(
      onPressed: () {},
      child: Icon(Icons.fingerprint),
    );

    // Now the floating action button is smooshy!
    final doughFab = PressableDough(
      child: fab,
    );

    // Just a regular old container
    final centerContainer = Container(
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Drag me around :)',
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    // Now let's say we want to make the center container
    // a bit squishier, but we want a different kind of 
    // squish. To do that we just wrap the dough widget
    // in another recipe! Easy peasy.
    final doughCenterContainer = DoughRecipe(
      data: DoughRecipeData(
        viscosity: 3000,
        expansion: 1.2,
      ),
      child: PressableDough(
        child: centerContainer,
        onRelease: (details) {
          // This callback is raised when the user release their
          // hold on the pressable dough.
          print('I was release with ${details.delta} delta!');
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: doughCenterContainer,
      ),
      floatingActionButton: doughFab,
    );
  }
}
