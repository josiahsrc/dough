import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [DraggableDough] widget.
class DraggableDoughDemo extends StatelessWidget {
  final doughUrl =
      'https://i.pinimg.com/originals/21/51/b8/2151b8dbdd5aba485f09dd5b74d679c9.png';

  @override
  Widget build(BuildContext context) {
    // This is the widget that appears before being dragged around.
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
          style: Theme.of(context).accentTextTheme.bodyText2,
        ),
      ),
    );

    // This is the widget that gets dragged around.
    final myFeedbackWidget = Image.network(doughUrl, width: 100, height: 100);

    // Create the draggable dough widget using our child and feedback widgets.
    // Also apply a custom dough recipe to make this widget feel awesome :)
    final myDraggableDough = DoughRecipe(
      data: DoughRecipeData(
        adhesion: 2,
        viscosity: 250,
        draggablePrefs: DraggableDoughPrefs(
          breakDistance: 120,
          useHapticsOnBreak: true,
        ),
      ),
      child: DraggableDough<String>(
        data: 'My data!',
        child: myDraggableChild,
        feedback: myFeedbackWidget,
        childWhenDragging: Container(),
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
              style: Theme.of(context).accentTextTheme.bodyText2,
            ),
          ),
        );
      },
      onWillAccept: (value) => value == 'My data!',
      onAccept: (value) {
        print('the value "$value" was accepted!');
      },
    );

    // Now just use the draggable dough widget however you'd normally use
    // Flutter's Draggable widget.
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
