import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to create a custom [Dough] widget.
///
/// In this example, the widget tells the dough to stretched based on
/// if a toggle is switched on or not. See [_CustomDoughDemoState] for
/// how it does this.
class CustomDoughDemo extends StatefulWidget {
  @override
  _CustomDoughDemoState createState() => _CustomDoughDemoState();
}

/// The state of your custom dough widget.
class _CustomDoughDemoState extends State<CustomDoughDemo> {
  /// The controller that determines when the dough should stretch.
  final doughController = DoughController();

  /// A flag to indicate whether the dough should stretch or not.
  bool isStretched = false;

  @override
  Widget build(BuildContext context) {
    // Our widget that we're gonna squish.
    final myCustomDough = DoughRecipe(
      /// Make how long it takes to start stretching a bit longer.
      data: DoughRecipe.of(context).copyWith(
        entryDuration: Duration(milliseconds: 250),
      ),
      child: Dough(
        child: Container(
          height: 100,
          width: 100,
          // An image of a cookie.
          child: Image.network(
              'https://i.pinimg.com/originals/21/51/b8/2151b8dbdd5aba485f09dd5b74d679c9.png'),
        ),
        controller: doughController,
        // transformer: You can create your own transformer to change how the dough morphs,
        // but you'll have to read the source code to understand how to do this. This is a
        // bit more complicated and requires a general knowledge of linear algebra.
      ),
    );

    // A toggle for our dough stretching. Realistically, you'll probably want
    // to use a GestureDetector or Listener to determine where to start and end presses
    // based on user input. But for the sake of the demo this will be used instead.
    final doughToggle = Switch(
      value: isStretched,
      onChanged: (value) {
        // Toggle our stretch variable.
        setState(() {
          isStretched = !isStretched;

          // Start or stop a stretch based on our isStretched value.
          if (isStretched) {
            doughController.start(
              origin: Offset(0, 0),
              target: Offset(500, 500),
            );
          } else {
            doughController.stop();
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Dough'),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Toggle this to manipulate the dough!'),
            doughToggle,
            myCustomDough,
          ],
        ),
      ),
    );
  }
}
