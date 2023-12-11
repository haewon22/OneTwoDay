import 'package:flutter/material.dart';

import './Tools/Color/Colors.dart';
import 'GroupSettings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({
    super.key,
    required this.appBar,
    required this.title,
    required this.groupS,
    this.groupKey,
    this.function
  });

  final AppBar appBar;
  final String title;
  final bool groupS;
  String? groupKey;
  Function()? function;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MainColors.background,
      shadowColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        splashRadius: 0.1,
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(Icons.arrow_back_ios),
      ),
      title: Container(
        child: Text(
          title,
          style: TextStyle(
              color: MainColors.blue, fontWeight: FontWeight.w900),
        ),
      ),
      iconTheme: IconThemeData(color: MainColors.blue),
      actions: [if (groupS) GroupSettings(groupKey: groupKey ?? "", function: function!)],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
