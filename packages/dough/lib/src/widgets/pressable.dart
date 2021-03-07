part of dough;

/// Details for a [PressableDoughReleaseCallback].
@immutable
class PressableDoughReleaseDetails {
  /// Creates a [PressableDoughReleaseDetails].
  const PressableDoughReleaseDetails({
    required this.delta,
    required this.position,
  });

  /// How far the dough was dragged before it was released.
  final Offset delta;

  /// The global position of where the user released their hold on dough.
  final Offset position;
}

/// Raised when a user releases their hold on a [PressableDough] widget.
typedef PressableDoughReleaseCallback = void Function(
  PressableDoughReleaseDetails details,
);

/// A smooshable dough widget that morphs into different shapes based
/// on how the user presses on it.
class PressableDough extends StatefulWidget {
  /// Creates a [PressableDough] widget.
  const PressableDough({
    Key? key,
    required this.child,
    this.onStart,
    this.onReleased,
  }) : super(key: key);

  /// The child to smoosh.
  final Widget child;

  /// A callback raised when a user starts a hold on the widget and has
  /// begun to squish it around.
  final VoidCallback? onStart;

  /// A callback raised when the user releases their hold on the widget
  /// (e.g. the user stopped smooshing the widget).
  final PressableDoughReleaseCallback? onReleased;

  @override
  _PressableDoughState createState() => _PressableDoughState();
}

/// The state of a [PressableDough] widget which updates a [Dough] widget
/// based on user input.
class _PressableDoughState extends State<PressableDough> {
  final _controller = DoughController();

  @override
  Widget build(BuildContext context) {
    final pressableInterface = GestureDetector(
      onPanStart: (details) {
        _controller.start(
          origin: details.globalPosition,
          target: details.globalPosition,
        );
        widget.onStart?.call();
      },
      onPanUpdate: (details) {
        _controller.update(
          target: details.globalPosition,
        );
      },
      onPanEnd: (details) {
        if (_controller.isActive) {
          _controller.stop();
        }

        widget.onReleased?.call(
          PressableDoughReleaseDetails(
            delta: _controller.delta,
            position: _controller.target,
          ),
        );
      },
      onPanCancel: () {
        if (_controller.isActive) {
          _controller.stop();
        }
      },
      child: widget.child,
      behavior: HitTestBehavior.translucent,
    );

    return Dough(
      child: pressableInterface,
      controller: _controller,
      transformer: BasicDoughTransformer(),
    );
  }
}
