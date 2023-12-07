import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EnterRoom extends StatefulWidget {
  const EnterRoom({super.key});

  @override
  State<EnterRoom> createState() => _EnterRoomState();
}

class _EnterRoomState extends State<EnterRoom> {
  bool _isClicked = false;
  String textValue = '';

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "",
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 30),
              child: Text(
                "그룹 참가하기",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                cursorColor: Color(0xff585551),
                inputFormatters: [
                  FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
                      allow: true),
                ],
                onChanged: (String val) {
                  setState(() {
                    textValue = val;
                    if (val.length == 5)
                      _isClicked = true;
                    else
                      _isClicked = false;
                  });
                },
                decoration: InputDecoration(
                  suffix: Text(
                    "${textValue.length}/5 ",
                    style: TextStyle(
                        fontSize: 13,
                        color: (!_isClicked ? Colors.red : Colors.grey)),
                  ),
                  counterText: "",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  labelText: 'Key',
                  labelStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(55),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(55),
                  ),
                )
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_isClicked) print("완료 눌림");
              },
              child: Container(
                width: mediaSize.width,
                height: 55,
                margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: _isClicked ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55)),
                child: Text(
                  "완료",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  )
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
