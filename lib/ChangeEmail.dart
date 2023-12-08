import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Tools/Dialog/DialogForm.dart';
import 'Tools/Loading/Loading.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  Map<String, String> _input = {'pw' : "", 'newemail' : ""};
  bool _isFirstInput = true;
  bool _isValidated = false;
  bool _passwordVisible = false;
  List<TextEditingController> textController = [TextEditingController(), TextEditingController()];
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: ""),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70,
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "이메일 변경",
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
                  "비밀번호를 입력하고\n새로운 이메일을 입력해주세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.7
                  )
                ),
              ),
              Container(
                height: 55,
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0), 
                child: TextFormField(
                  controller: textController[0],
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
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
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
                      _input['pw'] = textController[0].text;
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
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: 'New Email',
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
                  onChanged: (String value) { 
                    setState(() {
                      if (!textController[1].text.isEmpty) _isFirstInput = false;
                      _input['newemail'] = textController[1].text;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  _emailValidator(_input['newemail']!),
                  style: TextStyle(
                    color: MainColors.blue,
                    fontSize: 11.9
                  ),
                )
              ),
              GestureDetector(
                onTap: () async {
                  if (_isValidated && _input['pw']!.isNotEmpty) {
                    Loading.loadingPage(context, mediaSize.width);
                    final user = await FirebaseAuth.instance.currentUser;
                    final cred = EmailAuthProvider.credential(
                      email: user?.email ?? 'Unknown', password: _input['pw']!
                    );
                    await user!.reauthenticateWithCredential(cred).then((value) async {
                      await user!.updateEmail(_input['newemail']!);
                      Navigator.of(context).pop();
                      DialogForm.dialogForm(
                        context, mediaSize.width,
                        "이메일 변경을 완료했어요",
                        "앞으로 변경된 이메일로 사용해주세요"
                      );
                    }).catchError((e) {
                      if (e.code == 'wrong-password') {
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
                    });
                  }
                },
                child: Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isValidated! && _input['pw']!.isNotEmpty ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55)
                  ),
                  child: Text(
                    "이메일 변경하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    )
                  ),
                )
              ),
            ]
          )
        ),
      )
    );
  }

  String _emailValidator(String value) {
    if (_isFirstInput!) return "";
    if (value.isEmpty) {
      _isValidated = false;
      return "이메일을 입력하세요";
    }
    if (!value.contains("@") || !value.contains(".")) {
      _isValidated = false;
      return "이메일 형식으로 입력하세요";
    }
    setState(() {
      _isValidated = true;
    });
    return "";
  }
}
