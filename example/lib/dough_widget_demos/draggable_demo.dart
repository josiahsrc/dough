import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [DraggableDough] widget.
class DraggableDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Positioned(
          left: 50,
          top: 10,
          child: DoughRecipe(
            data: DoughRecipeData(
              // adhesion: 8,
              // adhesion: 4,
              viscosity: 1000,
              // draggablePrefs: DraggableDoughPrefs(
              //   breakDistance: 150
              // ),
            ),
            child: DraggableDough<String>(
              data: 'same as whatever you\'d use for the'
                  'flutter Draggable widgets data property',
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
              feedback: Container(
                width: 50,
                height: 50,
                color: Colors.green,
              ),
              onDragStarted: () {},
              onDoughBreak: () {
                print('drag started');
              },
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Dough'),
      ),
      body: body,
    );
  }
}
