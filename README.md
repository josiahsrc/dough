![Flutter Dough](./assets/images/dough-logo@repo.png)

This package provides some widgets you can use to create a smooshy UI. 
- [Flutter package hosted on pub.dev](https://pub.dev/packages/dough)
- [Source code](https://github.com/HatFeather/flutter_dough)

## How to use

This package provides squishy widgets you can use right out of the box. Optionally,
you can create custom Dough widgets for a custom squish effect. For a more complete
overview on how to use the Dough library, check out the [example project](./example) 
provided on GitHub.

### Pressable Dough

Wrap any widget in `PressableDough` to make it squish based on a user's input
gestures.

```
PressableDough(
    child: FloatingActionButton( ... ),
);
```

You can find a full example of how to use this widget
[here](./example/lib/dough_widget_demos/pressable_dough_demo.dart).

![PressableDough Demo](assets/gifs/pressable-dough.gif)

### Draggable Dough

Similar to Flutter's built-in Draggable widget, `DraggableDough` allows
you to drag and drop widgets around... Only this time it's squishy!

```
DraggableDough<String>(
    data: 'My data',
    child: Container( ... ),
    feedback: Container( ... ),
);
```

You can find a full example of how to use this widget
[here](./example/lib/dough_widget_demos/draggable_dough_demo.dart).

![PressableDough Demo](assets/gifs/draggable-dough.gif)

### Custom Dough

If the above widgets aren't exactly what you're looking for, you can easily 
create your own squishy widget using the provided `Dough` widget! See the
[example project](./example/lib/dough_widget_demos/custom_dough_demo.dart) 
for more details on how to do this.

![CustomDough Demo](assets/gifs/custom-dough.gif)

## Customize how the dough feels

If you don't like the default dough settings, you can easily change how 
the dough feels. Just wrap any widget that uses `Dough` in a `DoughRecipe` 
and you're good to go.

```
DoughRecipe(
    data: DoughRecipeData(
        adhesion: 8,
        viscosity: 3000,
        ...
    ),
    child: PressableDough( ... ),
);
```

---

## Future improvements

**Scaling** – The expansion property for the dough currently
only scales widgets uniformly. Ideally, when you press
on the dough widget, the pixels closest to your finger
would scale more than the pixels farther away (as you'd
expect from pressing something squishy). A possible solution
to this would be to use some sort of homography. If you
have any ideas for how to achieve this, please consider
contributing!

**More dough widgets** – Support for more out-of-the-box dough widgets 
will be added in the future. Some dough widget ideas include...

- ReorderableListDough – Same as the reorderable list widget, 
but it's smooshy.
- SliverListDough – Same as the sliver list widget, but it's 
smooshy.

## Contributing

Contributions to this package are always welcome!

- If you have an idea/suggestion/bug-report, feel free to 
[create a ticket](https://github.com/HatFeather/flutter_dough/issues).
- If you created a custom `Dough` widget or some other awesome feature
that you want to share with the community, feel free to fork the 
[repository](https://github.com/HatFeather/flutter_dough) and submit 
a pull request!
