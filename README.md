![Flutter Dough](./assets/images/dough-logo@repo.png)

[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![Awesome: Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)

This package provides some widgets you can use to create a smooshy UI. 
- [Flutter package](https://pub.dev/packages/dough)
- [Source code](https://github.com/josiahsrc/flutter_dough)

## How to use

This package provides squishy widgets you can use right out of the box. Optionally, you can create custom Dough widgets for a custom squish effect. For a more complete overview on how to use the Dough library, check out the [example project](./example) provided on GitHub.

### Pressable Dough

Wrap any widget in `PressableDough` to make it squish based on a user's input gestures.

```
PressableDough(
    child: FloatingActionButton( ... ),
);
```

You can find a full example of how to use this widget [here](./example/lib/dough_widget_demos/pressable_dough_demo.dart).

![PressableDough Demo](assets/gifs/pressable-dough.gif)

### Draggable Dough

Similar to Flutter's built-in Draggable widget, `DraggableDough` allows you to drag and drop widgets around... Only this time it's squishy!

```
DraggableDough<String>(
    data: 'My data',
    child: Container( ... ),
    feedback: Container( ... ),
);
```

You can find a full example of how to use this widget [here](./example/lib/dough_widget_demos/draggable_dough_demo.dart).

![DraggableDough Demo](assets/gifs/draggable-dough.gif)

### Gyro Dough

Wrap any widget in `GyroDough` to make it squish based on how a user moves their phone around in physical space. This widget only works on devices that have accelerometer/gyroscope features.

```
GyroDough(
    child: Container( ... ),
);
```

You can find a full example of how to use this widget [here](./example/lib/dough_widget_demos/gyro_dough_demo.dart).

![GyroDough Demo](assets/gifs/gyro-dough.gif)

### Make your own Dough

If the above widgets aren't exactly what you're looking for, you can easily create your own squishy widget using the provided `Dough` widget! See the [example project](./example/lib/dough_widget_demos/custom_dough_demo.dart) for more details on how to do this.

![CustomDough Demo](assets/gifs/custom-dough.gif)

---

## Customize how the Dough feels

If you don't like the default dough settings, you can easily change how the dough feels. Just wrap any widget that uses `Dough` in a `DoughRecipe` and you're good to go.

```
DoughRecipe(
    data: DoughRecipeData(
        adhesion: 4,
        viscosity: 250, // a more jello like substance
        usePerspectiveWarp: true, // use for added jiggly-ness
        perspectiveWarpDepth: 0.02,
        exitDuration: Duration(milliseconds: 600),
        ...
    ),
    child: PressableDough( ... ),
);
```

You can find a full example of how to use this widget [here](./example/lib/dough_widget_demos/dough_recipe_demo.dart).

![DoughRecipe Demo](assets/gifs/dough-recipe.gif)

---

## Future improvements

**Dough expansion** – Ideally, pressing on a dough widget would push pixels away from your finger, as if you were pressing on dough (possibly using a mesh-grid?). If you have any ideas for how to achieve this, please consider contributing!

**More dough widgets** – Support for more out-of-the-box dough widgets will be added in the future. Some dough widget ideas include...
- [ ] ReorderableListDough – Same as the reorderable list widget, but it's smooshy.
- [ ] SliverListDough – Same as the sliver list widget, but it's  smooshy.

## Contributing

Contributions to this package are always welcome! Please read the [contributing guidlines](./CONTRIBUTING.md).
- If you have an idea/suggestion/bug-report, feel free to [create a ticket](https://github.com/josiahsrc/flutter_dough/issues).
- If you created a custom `Dough` widget or some other awesome feature that you want to share with the community, feel free to fork the [repository](https://github.com/josiahsrc/flutter_dough) and submit a pull request!

---

keywords: dough, rubber, elastic, rubber-band, rubberband, stretchy, squishy, smooshy, linear-algebra, matrix, transformation, flexible, draggable, drag, pressable, custom, ui, ux, interactive, animation, engage