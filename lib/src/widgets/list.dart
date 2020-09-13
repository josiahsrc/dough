import 'package:dough/dough.dart';
import 'package:flutter/material.dart';

class ListViewDough extends StatefulWidget {
  @override
  _ListViewDoughState createState() => _ListViewDoughState();
}

class _ListViewDoughState extends State<ListViewDough> {
  final _doughController = DoughController();

  @override
  Widget build(BuildContext context) {
    return Dough(
      controller: _doughController,
      child: ListView(),
      axis: Axis.vertical,
    );
  }
}
