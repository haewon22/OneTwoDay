import 'package:flutter/material.dart';

class HomeGridView extends StatefulWidget {
  const HomeGridView({super.key});

  @override
  State<HomeGridView> createState() => _HomeGridViewState();
}

class _HomeGridViewState extends State<HomeGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(crossAxisCount: 4, children: [
      Container(
          color: Colors.red,
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8.0)),
      Container(
          color: Colors.yellow,
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8.0)),
      Container(
          color: Colors.green,
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8.0)),
      Container(
          color: Colors.blue,
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8.0))
    ]);
  }
}
