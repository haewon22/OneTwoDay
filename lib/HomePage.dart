import 'package:flutter/material.dart';
import 'package:onetwoday/HomeBody.dart';
import 'Tools/Color/Colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 67,
        leading: Container(
          margin: EdgeInsets.only(left: 10, bottom: 12.0, top: 12),
          padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: Image.asset(
            'assets/images/splash_icon.png',
            fit: BoxFit.contain,
          ),
        ),
        titleSpacing: 4,
        title: Container(
          margin: EdgeInsets.only(bottom: 3),
          child: Text(
            "원투데이",
            style: TextStyle(
              color: MainColors.blue,
              fontFamily: 'NPSfont',
              fontSize: 27
            ),
          ),
        ),
        backgroundColor: MainColors.background,
        shadowColor: Colors.transparent,
      ),
      body: HomeBody(),
    );
  }
}
