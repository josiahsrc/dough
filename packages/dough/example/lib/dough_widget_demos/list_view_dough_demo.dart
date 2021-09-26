import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [ListViewDough] widget.
class ListViewDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mySquishyList = ListViewDough();

    final myExtraSquishyList = DoughRecipe(
      data: DoughRecipeData(
        expansion: 1,
        exitCurve: Curves.elasticIn,
        viscosity: 1400,
        adhesion: 40,
        exitDuration: Duration(milliseconds: 800),
        listViewDoughRecipe: ListViewDoughRecipeData(),
      ),
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
