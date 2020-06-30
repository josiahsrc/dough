part of dough;

class DraggableDoughPrefs {}

// class DraggableDoughTarget<T> extends StatelessWidget {

// }

class DraggableDough<T> extends StatelessWidget {
  final Widget child;
  final Widget childWhenDragging;
  final Widget feedback;
  final T data;
  final Axis axis;

  const DraggableDough({
    Key key,
    @required this.child,
    this.childWhenDragging,
    @required this.feedback,
    this.data,
    this.axis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      child: child,
      childWhenDragging: childWhenDragging,
      feedback: feedback,
      data: data,
      axis: axis,
    );
  }
}
