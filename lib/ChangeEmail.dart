import 'package:flutter/material.dart';

import 'MyAppBar.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  String email = 'haewon@cau.ac.kr';
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
                Icons.alternate_email,
                size: 70,
                color: Color(0xff6d8aa1),
              ),
            ),
            Text(
              "이메일 변경",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
            ),
            Text(email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                )),
            Container(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
              child: TextFormField(
                cursorColor: Color(0xff6d8aa1),
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "변경하려는 Email 주소",
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
              margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
              width: MediaQuery.of(context).size.width - 100,
              height: 50,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "인증 메일 발송",
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
