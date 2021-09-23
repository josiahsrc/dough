import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

/// This page demonstrates how to use the [GyroDough] widget.
class GyroDoughDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myWidgetToSquish = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      width: 100,
      height: 100,
      child: Center(
        child: Text(
          'Shake the phone',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );

    // Create a squishy widget which reacts to physical
    // phone movement!
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
        title: Text('Gyro Dough'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NOTE',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.left,
            ),
            Text(
              'This widget only works on devices that '
              'have accelerometer/gyroscope features...',
              textAlign: TextAlign.left,
            ),
            Spacer(),
            Center(child: mySquishyGyroWidget),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
