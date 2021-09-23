import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

class DoughRecipeDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myDraggableChild = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Draggable',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );

    // This is the widget that gets dragged around.
    final myFeedbackWidget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Feedback',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );

    // The default draggable dough widget.
    final myDefaultDraggableDough = DraggableDough<String>(
      data: 'My data!',
      child: myDraggableChild,
      feedback: myFeedbackWidget,
      childWhenDragging: Container(),
    );

    // To override the default draggable dough feel, just wrap it in a
    // DoughRecipe widget and you're good to go! For this widget we're
    // enabling `usePerspectiveWarp` to create a sense of mass for the
    // dough and make it feel more jiggly.
    final myDraggableDoughWithNewSettings = DoughRecipe(
      data: DoughRecipeData(
        adhesion: 4,
        viscosity: 300,
        usePerspectiveWarp: true,
        perspectiveWarpDepth: 0.02,
        exitDuration: Duration(milliseconds: 600),
        draggablePrefs: DraggableDoughPrefs(
          breakDistance: 100,
          useHapticsOnBreak: true,
        ),
      ),
      child: myDefaultDraggableDough,
    );

    // Display the draggable in the center of the page.
    return Scaffold(
      appBar: AppBar(
        title: Text('Dough Recipe'),
      ),
      body: Center(
        child: myDraggableDoughWithNewSettings,
      ),
    );
  }
}
