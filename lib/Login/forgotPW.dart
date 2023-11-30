import '../Tools/Color/Colors.dart';
import '../Tools/Dialog/DialogForm.dart';
import '../Tools/Loading/Loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPW extends StatefulWidget{
  @override
  ForgotPWState createState() => ForgotPWState();
}

class ForgotPWState extends State<ForgotPW> {
  String _input = "";
  bool _isEmailSent = false;
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                margin: EdgeInsets.only(top: 45),
                child: Text(
                  "비밀번호 변경",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w900
                  )
                ),
              ),
              Container(
                height: 30,
                child: Text(
                  "이메일을 입력해주세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.7
                  )
                ),
              ),
              Container(
                height: 55,
                margin: EdgeInsets.fromLTRB(30, 30, 30, 0), 
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  enabled: !_isEmailSent!,
                  cursorColor: Color(0xff585551),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: 'Email',
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
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                  validator: (value) { 
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _input = value!;
                      });
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_input.isNotEmpty) {
                    try {
                      Loading.loadingPage(context, mediaSize.width);
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _input,
                        password: "000000"
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Navigator.of(context).pop();
                        DialogForm.dialogForm(
                          context, mediaSize.width,
                          "가입되지 않은 이메일이예요",
                          "이메일을 다시 입력해주세요"
                        );
                      } else if (e.code == 'invalid-email') {
                        Navigator.of(context).pop();
                        DialogForm.dialogForm(
                          context, mediaSize.width,
                          "이메일 형식이 올바르지 않아요",
                          "이메일 형식으로 다시 입력해주세요"
                        );
                      } else if (e.code == 'too-many-requests') {
                        Navigator.of(context).pop();
                        DialogForm.dialogForm(
                          context, mediaSize.width,
                          "요청이 너무 많아요",
                          "잠시 후에 다시 시도해주세요"
                        );
                      } else if (e.code == 'wrong-password') {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _input);
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Text(
                                    "비밀번호 변경 메일을 보냈어요",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "비밀번호 변경 메일을 확인하고\n메일 속 링크를 눌러\n비밀번호를 변경해주세요",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[ 
                                new GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).popUntil(ModalRoute.withName("/signin"));
                                  },
                                  child: Container(
                                    width: mediaSize.width,
                                    height: 40,
                                    margin: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: MainColors.blue,
                                      borderRadius: BorderRadius.circular(55)
                                    ),
                                    child: Text(
                                      "로그인하러 가기",
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
                  }
                },
                child: Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _input.isNotEmpty ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55)
                  ),
                  child: Text(
                    "비밀번호 변경 메일 보내기",
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
                    "비밀번호를 알고있나요?  ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                    )
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "뒤로가기",
                      style: TextStyle(
                        color: MainColors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                      )
                    )
                  )
                ],
              ),
            ],
          )
        )
      )
    );
  }
}