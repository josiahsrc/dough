# dough

This package provides some widgets you can use to create a smooshy
UI.

## How to use

Simply wrap any widget in one of the provided dough widgets like so:

```
PressableDough(
    onReleased: (details) { },
    child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.fingerprint),
    );
);
```

That's it. Now your UI is smooshy! It will look something
like this:

![Alt Text](assets/gifs/pressable-dough.gif)

### Customization

If you don't like the default dough settings, you can easily
change how the dough feels. Just wrap your dough in a 
`DoughRecipe` widget and you're good to go.

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

**More dough widgets** – Currently only the `PressableDough`
widget is provided out of the box. Support for more dough
widgets will be added in the future.

