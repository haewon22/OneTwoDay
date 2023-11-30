import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loading {
  static void loadingPage(BuildContext context, double width) {
    showDialog(
      barrierColor: Colors.white30,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(width / 2 - 32),
          child: Lottie.asset(
            'assets/lotties/loading.json',
            frameRate: FrameRate.max,
          ),
        );
      }
    );
  }
}