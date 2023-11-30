import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';

class ChangePW extends StatefulWidget {
  const ChangePW({super.key});

  @override
  State<ChangePW> createState() => _ChangePWState();
}

class _ChangePWState extends State<ChangePW> {
  String email = 'haewon20430@cau.ac.kr';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "", appBar: AppBar()),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 80,
              child: Icon(
                Icons.lock,
                size: 70,
                color: Color(0xff6d8aa1),
              ),
            ),
            Text(
              "비밀번호 변경",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 60, 30, 5),
              child: TextFormField(
                cursorColor: Color(0xff6d8aa1),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "기존 비밀번호",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              child: TextFormField(
                cursorColor: Color(0xff6d8aa1),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "새로운 비밀번호",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 10, 20, 40),
              child: Text(
                "비밀번호가 기억나지 않으세요?",
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              width: MediaQuery.of(context).size.width - 100,
              height: 50,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "확인",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: Color(0xff6d8aa1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
