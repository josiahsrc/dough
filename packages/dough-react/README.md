![Dough React](https://github.com/josiahsrc/dough/blob/master/assets/images/dough-react-logo@repo.png?raw=true)

This package provides some widgets you can use to create a smooshy UI.

- [Source code](https://github.com/josiahsrc/dough)

<!-- a yellow warning that this package is in alpha -->

![Alpha](https://img.shields.io/badge/alpha-yellow.svg)

## How to use

This package provides squishy UI components that you can use right out of the box. Or, optionally, you can create your own.

To use This component you must call defineCustomElements() from `@dough-react` in your app's entry file.

```tsx
import { defineCustomElements } from 'dough-react';

defineCustomElements();
```

### Pressable Dough

Wrap any component in `DoughPressable` to make it squish based on a user's input gestures.

```tsx
<DoughPressable>
  <img src="..." />
</DoughPressable>
```

![DoughPressable Demo](./assets/gifs/pressable-dough.gif)

### Draggable Dough

`DoughDraggable` allows you to drag and drop components around... Only this time it's squishy!

```tsx
<DoughDraggable>
  <img src="..." />
</DoughDraggable>
```

![DraggableDough Demo](./assets/gifs/draggable-dough.gif)

### Make your own Dough

If the above widgets aren't exactly what you're looking for, you can easily create your own squishy component using the provided `DoughAllPurposeFlour` component! Check out the `DoughPressable` implementation for how to do that.

![DoughAllPurposeFlour Demo](./assets/gifs/custom-dough.gif)

---

## Customize how the Dough feels

If you don't like the default dough settings, you can easily change how the dough feels. Just update the provided `viscosity` and `adhesion` parameters.

```tsx
<DoughDraggable viscosity="10" adhesion="4">
  <img src="..." />
</DoughDraggable>
```

---

## Contributing

Contributions to this package are always welcome! Please read the [contributing guidlines](../../CONTRIBUTING.md).

- If you have an idea/suggestion/bug-report, feel free to [create a ticket](https://github.com/josiahsrc/dough/issues).
- If you created a custom `Dough` widget or some other awesome feature that you want to share with the community, you can fork the [repository](https://github.com/josiahsrc/dough) and submit a pull request!

---

keywords: dough, rubber, elastic, rubber-band, rubberband, stretchy, squishy, smooshy, linear-algebra, matrix, transformation, flexible, draggable, drag, pressable, custom, ui, ux, interactive, animation, engage, stencil, react, angular, vue, flutter, web, mobile, responsive
