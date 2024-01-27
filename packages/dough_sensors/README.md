![Flutter Dough](../../assets/images/dough-sensors-logo@repo.png)

[![Awesome: Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)

Smooshy widgets that use sensors. Builds on top of the [Dough](https://pub.dev/packages/dough) library.
- [Flutter package](https://pub.dev/packages/dough_sensors)
- [Source code](https://github.com/josiahsrc/dough)

## How to use

This package provides sensor-based squishy widgets you can use right out of the box. For a more complete overview on how to use the Dough Sensors library, check out the [example project](./example/README.md) provided on GitHub.

### Gyro Dough

Wrap any widget in `GyroDough` to make it squish based on how a user moves their phone around in physical space. This widget only works on devices that have accelerometer/gyroscope features.

```
GyroDough(
  child: Container( ... ),
);
```

You can find a full example of how to use this widget [here](example/lib/dough_widget_demos/gyro_dough_demo.dart).

![GyroDough Demo](../../assets/gifs/gyro-dough.gif)

---

## Customize how the Dough feels

If you don't like the default dough settings, you can easily change how the dough feels. Just wrap any widget that uses `GyroDough` in a `GyroDoughRecipe` and you're good to go.

```
GyroDoughRecipe(
  data: GyroDoughRecipeData(
    gyroMultiplier: 110, // Control the squishiness of the widget
    ...
  ),
  child: GyroDough( ... ),
);
```

You can find a full example of how to use this widget [here](example/lib/dough_widget_demos/gyro_dough_demo.dart).

---

## Contributing

Contributions to this package are always welcome! Please read the [contributing guidlines](../../CONTRIBUTING.md).
- If you have an idea/suggestion/bug-report, feel free to [create a ticket](https://github.com/josiahsrc/dough/issues).
- If you created a custom `Dough` widget or some other awesome feature that you want to share with the community, you can fork the [repository](https://github.com/josiahsrc/dough) and submit a pull request!

---

keywords: dough, rubber, elastic, rubber-band, rubberband, stretchy, squishy, smooshy, linear-algebra, matrix, transformation, flexible, draggable, drag, pressable, custom, ui, ux, interactive, animation, engage, sensors