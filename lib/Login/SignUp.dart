import '../Tools/Color/Colors.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget{
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 70,
              margin: EdgeInsets.only(top: 45),
              child: Text(
                "회원가입",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w900
                )
              ),
            ),
            Container(
              height: 60,
              child: Text(
                "원투데이에 오신 것을 환영합니다\n이메일로 가입하여 원투데이를 시작하세요",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  height: 1.7
                )
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/signupform');
              },
              child: Container(
                width: mediaSize.width,
                height: 55,
                margin: EdgeInsets.all(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MainColors.blue,
                  borderRadius: BorderRadius.circular(55)
                ),
                child: Text(
                  "이메일로 회원가입",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  )
                ),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "이미 계정이 있나요?  ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12
                  )
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('/signin');
                  },
                  child: Text(
                    "로그인",
                    style: TextStyle(
                      color: MainColors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600
                    )
                  )
                )
              ],
            )
          ]
        )
      )
    );
  }
}