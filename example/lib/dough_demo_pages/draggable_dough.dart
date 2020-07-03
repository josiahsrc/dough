import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

class DraggableDoughPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        Positioned(
          left: 50,
          top: 10,
          child: DoughRecipe(
            data: DoughRecipeData(
              viscosity: 500,
              adhesion: 1.2,
              entryDuration: Duration(
                milliseconds: 10,
              ),
            ),
            child: DraggableDough<String>(
              data: 'same as whatever you\'d use for '
                  'the flutter Draggable data property',
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
