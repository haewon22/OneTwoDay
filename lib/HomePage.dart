import 'package:flutter/material.dart';
import 'package:onetwoday/HomeBody.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/ProfileDrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "OneTwoDay",
      ),
      drawer: ProfileDrawer(),
      body: HomeBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: Icon(
          Icons.calendar_today,
          color: Color(0xff6d8aa1),
          size: 35,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        hoverColor: Color(0xfff2f2f2),
        hoverElevation: 0,
        highlightElevation: 0,
      ),
    );
  }
}
