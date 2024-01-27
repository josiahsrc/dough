![Flutter Dough](../../assets/images/dough-logo@repo.png)

[![Awesome: Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://github.com/Solido/awesome-flutter)

This package provides some widgets you can use to create a smooshy UI. 
- [Flutter package](https://pub.dev/packages/dough)
- [Source code](https://github.com/josiahsrc/dough)

## How to use

This package provides squishy widgets you can use right out of the box. Optionally, you can create custom Dough widgets for a custom squish effect. For a more complete overview on how to use the Dough library, check out the [example project](./example/README.md) provided on GitHub.

### Pressable Dough

Wrap any widget in `PressableDough` to make it squish based on a user's input gestures.

```dart
PressableDough(
  child: FloatingActionButton( ... ),
);
```

You can find a full example of how to use this widget [here](example/lib/dough_widget_demos/pressable_dough_demo.dart).

![PressableDough Demo](../../assets/gifs/pressable-dough.gif)

### Draggable Dough

Similar to Flutter's built-in Draggable widget, `DraggableDough` allows you to drag and drop widgets around... Only this time it's squishy!

```dart
DraggableDough<String>(
  data: 'My data',
  child: Container( ... ),
  feedback: Container( ... ),
);
```

You can find a full example of how to use this widget [here](example/lib/dough_widget_demos/draggable_dough_demo.dart).

![DraggableDough Demo](../../assets/gifs/draggable-dough.gif)

### Gyro Dough

The `GyroDough` widget has been moved to the [Dough Sensors](https://pub.dev/packages/dough_sensors) package.

![GyroDough Demo](../../assets/gifs/gyro-dough.gif)

### Make your own Dough

If the above widgets aren't exactly what you're looking for, you can easily create your own squishy widget using the provided `Dough` widget! See the [example project](example/lib/dough_widget_demos/custom_dough_demo.dart) for more details on how to do this.

![CustomDough Demo](../../assets/gifs/custom-dough.gif)

---

## Customize how the Dough feels

If you don't like the default dough settings, you can easily change how the dough feels. Just wrap any widget that uses `Dough` in a `DoughRecipe` and you're good to go.

```dart
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

You can find a full example of how to use this widget [here](example/lib/dough_widget_demos/dough_recipe_demo.dart).

![DoughRecipe Demo](../../assets/gifs/dough-recipe.gif)

---

## Migration from v1.x.x to v2.x.x

If you're using `DraggablePrefs`, rename your `DraggablePrefs` to `DraggableDoughRecipeData`. 

```dart
// v1.x.x
DoughRecipe(
  data: DoughRecipeData(
    draggablePrefs: DraggablePrefs( ... ),
  ),
  child: DraggableDough( prefs: DraggablePrefs( ... ), ... ),
);

// v2.x.x
DoughRecipe(
  data: DoughRecipeData(
    draggableRecipe: DraggableDoughRecipeData( ... ),
  ),
  child: DraggableDough( recipe: DraggableDoughRecipeData( ... ), ... ),
)
```

If you are using `GyroDough`, install the [Dough Sensors](https://pub.dev/packages/dough_sensors) package and replace `GyroDoughPrefs` with `GyroDoughRecipeData`.

```dart
// v1.x.x
DoughRecipe(
  data: DoughRecipeData(
    gyroPrefs: GyroDoughPrefs( ... ),
  ),
  child: GyroDough( ... ),
);

// v2.x.x
GyroDoughRecipe(
  data: GyroDoughRecipeData( ... ),
  child: GyroDough( recipe: GyroDoughRecipeData( ... ), ... ),
)
```

## Future improvements

**Dough expansion** – Ideally, pressing on a dough widget would push pixels away from your finger, as if you were pressing on dough (possibly using a mesh-grid?). If you have any ideas for how to achieve this, please consider contributing!

**More dough widgets** – Support for more out-of-the-box dough widgets will be added in the future. Some dough widget ideas include...
- [ ] ReorderableListDough – Same as the reorderable list widget, but it's smooshy.
- [ ] SliverListDough – Same as the sliver list widget, but it's  smooshy.

## Contributing

Contributions to this package are always welcome! Please read the [contributing guidlines](../../CONTRIBUTING.md).
- If you have an idea/suggestion/bug-report, feel free to [create a ticket](https://github.com/josiahsrc/dough/issues).
- If you created a custom `Dough` widget or some other awesome feature that you want to share with the community, you can fork the [repository](https://github.com/josiahsrc/dough) and submit a pull request!

---

keywords: dough, rubber, elastic, rubber-band, rubberband, stretchy, squishy, smooshy, linear-algebra, matrix, transformation, flexible, draggable, drag, pressable, custom, ui, ux, interactive, animation, engage