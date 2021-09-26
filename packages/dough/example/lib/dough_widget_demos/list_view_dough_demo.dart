import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [ListViewDough] widget.
class ListViewDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mySquishyList = ListViewDough();

    final myExtraSquishyList = ListViewDoughRecipe(
      data: ListViewDoughRecipeData(),
      child: mySquishyList,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('List View Dough'),
      ),
      body: myExtraSquishyList,
    );
  }
}
