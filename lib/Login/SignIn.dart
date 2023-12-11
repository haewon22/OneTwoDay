import '../Tools/Color/Colors.dart';
import '../Tools/Dialog/DialogForm.dart';
import '../Tools/Loading/Loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget{
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool _passwordVisible = false;
  Map<String, String> _input = {'email' : "", 'pw' : ""};
  List<TextEditingController> textController = [TextEditingController(), TextEditingController()];

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  margin: EdgeInsets.only(top: 45),
                  child: Text(
                    "로그인",
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
                    "돌아오신 것을 환영합니다\n당신을 그리워했어요",
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
                    controller: textController[0],
                    autovalidateMode: AutovalidateMode.always,
                    cursorColor: Color(0xff585551),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(55),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                    onChanged: (String value) { 
                      setState(() {
                        _input['email'] = textController[0].text;
                      });
                    },
                  ),
                ),
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0), 
                  child: TextFormField(
                    controller: textController[1],
                    autovalidateMode: AutovalidateMode.always,
                    cursorColor: Color(0xff585551),
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(55),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(55),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        child: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey
                        ),
                      ),
                    ),
                    onChanged: (String value) { 
                      setState(() {
                        _input['pw'] = textController[1].text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/forgotpw');
                    },
                    child: Text(
                      "비밀번호를 잊으셨나요",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                      ),
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () async {
                    if (_input['email']!.isNotEmpty && _input['pw']!.isNotEmpty) {
                      try {
                        Loading.loadingPage(context, mediaSize.width);
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _input['email']!,
                          password: _input['pw']!
                        );
                        Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => false);
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
                        } else if (e.code == 'wrong-password') {
                          Navigator.of(context).pop();
                          DialogForm.dialogForm(
                            context, mediaSize.width,
                            "비밀번호가 올바르지 않아요",
                            "비밀번호를 다시 입력해주세요"
                          );
                        } else if (e.code == 'too-many-requests') {
                          Navigator.of(context).pop();
                          DialogForm.dialogForm(
                            context, mediaSize.width,
                            "요청이 너무 많아요",
                            "잠시 후에 다시 시도해주세요"
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
                      color: (_input['email']!.isNotEmpty && _input['pw']!.isNotEmpty) ? MainColors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(55)
                    ),
                    child: Text(
                      "로그인",
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
                      "계정이 없으신가요?  ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/signup');
                      },
                      child: Text(
                        "회원가입",
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
          ),
        )
      ),
    );
  }
}