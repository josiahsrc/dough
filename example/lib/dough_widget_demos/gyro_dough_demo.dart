import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

class GyroDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build');
    final myWidgetToSquish = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Try shaking the phone',
          textAlign: TextAlign.center,
          style: Theme.of(context).accentTextTheme.bodyText2,
        ),
      ),
    );

    final mySquishyGyroWidget = DoughRecipe(
      data: DoughRecipeData(
        adhesion: 21,
      ),
      child: GyroDough(
        child: myWidgetToSquish,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Dough Recipe'),
      ),
      body: Center(
        child: mySquishyGyroWidget,
      ),
    );
  }
}
