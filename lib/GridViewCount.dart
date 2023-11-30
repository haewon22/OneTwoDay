import 'package:flutter/material.dart';

class GridViewCount extends StatefulWidget {
  const GridViewCount({super.key});

  @override
  State<GridViewCount> createState() => _GridViewCountState();
}

class _GridViewCountState extends State<GridViewCount> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0)),
        Container(
            color: Colors.grey,
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8.0))
      ],
    );
  }
}
