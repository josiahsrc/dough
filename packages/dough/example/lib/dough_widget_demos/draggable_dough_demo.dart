import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [DraggableDough] widget.
class DraggableDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is the widget that appears before being dragged around.
    final myDraggableChild = Container(
      color: Colors.blue,
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
      color: Colors.green,
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Squishy feedback',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );

    // Create the draggable dough widget using our child and feedback widgets.
    // Also apply a custom dough recipe to make this widget feel awesome :)
    final myDraggableDough = DoughRecipe(
      data: DoughRecipeData(
        adhesion: 4,
        viscosity: 500,
        draggableDoughRecipe: DraggableDoughRecipeData(
          breakDistance: 80,
          useHapticsOnBreak: true,
        ),
      ),
      child: DraggableDough<String>(
        data: 'My data!',
        child: myDraggableChild,
        feedback: myFeedbackWidget,
        longPress: false,
        onDoughBreak: () {
          // This callback is raised when the dough snaps from its hold at its origin.
          print('Demo dough snapped and is freely being dragged!');
        },
      ),
    );

    // DraggableDough works just like the Flutter Draggable widget, except
    // it's squishy! So you can just use the already built drag widgets that
    // Flutter provides, no problem.
    final myDragTarget = DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          width: 100,
          color: candidateData.length > 0 ? Colors.lightGreen : Colors.grey,
          child: Center(
            child: Text(
              'Drag target',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        );
      },
      onWillAccept: (value) => value == 'My data!',
      onAccept: (value) {
        print('the value "$value" was accepted!');
      },
    );

    // Now just use the DraggableDough widget however you'd normally use
    // Flutter's native Draggable widget.
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Dough'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 50,
            top: 50,
            child: myDraggableDough,
          ),
          Positioned(
            right: 50,
            bottom: 50,
            child: myDragTarget,
          ),
        ],
      ),
    );
  }
}
