import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.appBar, required this.title});

  final AppBar appBar;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: Colors.black54),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
