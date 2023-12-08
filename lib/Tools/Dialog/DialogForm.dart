import 'package:flutter/material.dart';
import '../Color/Colors.dart';

class DialogForm {
  static void dialogForm(BuildContext context, double width, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: MainColors.background,
          title: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
          actions: <Widget>[ 
            new GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: width,
                height: 40,
                margin: EdgeInsets.fromLTRB(50, 0, 50, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MainColors.blue,
                  borderRadius: BorderRadius.circular(55)
                ),
                child: Text(
                  "닫기",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  )
                ),
              )
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
        );
      },
    );
  }
}