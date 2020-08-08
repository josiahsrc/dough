import 'package:flutter/material.dart';

// class ExampleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
  final Function onTap;
  const Squash({Key key, @required this.child, @required this.onTap})
      : super(key: key);
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
    easeInAnimation = Tween(begin: 1.0, end: 1.5)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails d) => controller.fling(),
      onTapCancel: () => controller.reverse(),
      onTapUp: (TapUpDetails d) => controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: easeInAnimation,
        child: widget.child,
      ),
    );
  }
}
