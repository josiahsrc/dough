import 'package:dough_tester/routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);

    final links = [
      ListTile(
        title: Text('Pressable Dough'),
        onTap: () => nav.pushNamed(Routes.kPressableDough),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: ListView(children: links),
    );
  }
}
