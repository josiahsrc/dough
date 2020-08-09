import 'package:flutter/material.dart';

// class ExampleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Squash(
//             onTap: () => debugPrint("abc"),
//             child: Container(
//                 decoration:
//                     BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
//                 height: 200.0,
//                 width: 200.0),
//           ),
//         ],
//       ),
//     );
//   }
// }

class Squash extends StatefulWidget {
  final Widget child;
  final Function() onTap;
  final double scaleFrom;
  final double scaleTo;
  final Curve curve;
  final TextStyle textStyle;
  final Decoration decoration;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final AlignmentGeometry alignment;

  const Squash({
    Key key,
    @required this.child,
    @required this.onTap,
    this.scaleFrom,
    this.scaleTo,
    this.curve,
    this.textStyle,
    this.padding,
    this.decoration,
    this.margin,
    this.height,
    this.width,
    this.alignment,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SquashState();
}

class _SquashState extends State<Squash>
    with SingleTickerProviderStateMixin<Squash> {
  AnimationController controller;
  Animation<double> easeInAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 200), value: 1.0);
    easeInAnimation =
        Tween(begin: widget.scaleFrom ?? 1.0, end: widget.scaleTo ?? 1.25)
            .animate(CurvedAnimation(
                parent: controller, curve: widget.curve ?? Curves.easeOut));
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTapDown: (TapDownDetails d) => controller.fling(),
        onTapCancel: () => controller.reverse(),
        onTapUp: (TapUpDetails d) => controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: easeInAnimation,
          child: Container(
            padding: widget.padding,
            height: widget.height,
            width: widget.width,
            alignment: widget.alignment,
            decoration: widget.decoration,
            child: DefaultTextStyle(
              style: widget.textStyle ?? Theme.of(context).textTheme.button,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
