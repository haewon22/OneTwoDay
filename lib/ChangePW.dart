import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Tools/Dialog/DialogForm.dart';
import 'Tools/Loading/Loading.dart';

class ChangePW extends StatefulWidget {
  const ChangePW({super.key});

  @override
  State<ChangePW> createState() => _ChangePWState();
}

class _ChangePWState extends State<ChangePW> {
  Map<String, String> _input = {'pw' : "", 'newpw' : "", 'newrepw' : ""};
  Map<String, bool> _isFirstInput = {'newpw' : true, 'newrepw' : true};
  Map<String, bool> _isValidated = {'newpw' : false, 'newrepw' : false};
  Map<String, bool> _passwordVisible = {'pw': false, 'newpw': false, 'newrepw': false};
  List<TextEditingController> textController = [TextEditingController(), TextEditingController(), TextEditingController()];
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: "", groupS: false),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  margin: EdgeInsets.only(top: 15),
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
                  height: 60,
                  child: Text(
                    "비밀번호를 입력하고\n새로운 비밀번호을 입력해주세요",
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
                    obscureText: !_passwordVisible['pw']!,
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
                            _passwordVisible['pw'] = !_passwordVisible['pw']!;
                          });
                        },
                        child: Icon(
                          _passwordVisible['pw']! ? Icons.visibility : Icons.visibility_off,
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
                    obscureText: !_passwordVisible['newpw']!,
                    cursorColor: Color(0xff585551),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: 'New Password',
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
                            _passwordVisible['newpw'] = !_passwordVisible['newpw']!;
                          });
                        },
                        child: Icon(
                          _passwordVisible['newpw']! ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey
                        ),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        if (!textController[1].text.isEmpty) _isFirstInput['newpw'] = false;
                        _input['newpw'] = textController[1].text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _pwValidator(_input['newpw']!),
                    style: TextStyle(
                      color: MainColors.blue,
                      fontSize: 11.9
                    ),
                  )
                ),
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 5, 30, 0), 
                  child: TextFormField(
                    controller: textController[2],
                    autovalidateMode: AutovalidateMode.always,
                    obscureText: !_passwordVisible['newrepw']!,
                    cursorColor: Color(0xff585551),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: 'Re-New Password',
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
                            _passwordVisible['newrepw'] = !_passwordVisible['newrepw']!;
                          });
                        },
                        child: Icon(
                          _passwordVisible['newrepw']! ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey
                        ),
                      ),
                    ),
                    onChanged: (String value) { 
                      setState(() {
                        if (!textController[2].text.isEmpty) _isFirstInput['newrepw'] = false;
                        _input['newrepw'] = textController[2].text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _repwValidator(_input['newrepw']!),
                    style: TextStyle(
                      color: MainColors.blue,
                      fontSize: 11.9
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () async {
                    if (_isValidated['newpw']! && _isValidated['newrepw']! && _input['pw']!.isNotEmpty) {
                      Loading.loadingPage(context, mediaSize.width);
                      final user = await FirebaseAuth.instance.currentUser;
                      final cred = EmailAuthProvider.credential(
                        email: user?.email ?? 'Unknown', password: _input['pw']!
                      );
                      await user!.reauthenticateWithCredential(cred).then((value) async {
                        await user!.updatePassword(_input['newpw']!);
                        Navigator.of(context).pop();
                        DialogForm.dialogForm(
                          context, mediaSize.width,
                          "비밀번호 변경을 완료했어요",
                          "앞으로 변경된 비밀번호로 사용해주세요"
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
                      color: _isValidated['newpw']! && _isValidated['newrepw']! && _input['pw']!.isNotEmpty ? MainColors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(55)
                    ),
                    child: Text(
                      "비밀번호 변경하기",
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
        ),
      )
    );
  }

  String _pwValidator(String value) {
    if (_isFirstInput['newpw']!) return "";
    if (value.isEmpty) {
      _isValidated['newpw'] = false;
      return "비밀번호를 입력하세요";
    }
    if (value.length < 8) {
      _isValidated['newpw'] = false;
      return "비밀번호를 8자 이상 입력하세요";
    }
    setState(() {
      _isValidated['newpw'] = true;
    });
    return "";
  }

  String _repwValidator(String value) {
    if (_isFirstInput['newrepw']!) return "";
    if (value.isEmpty) {
      _isValidated['newrepw'] = false;
      return "비밀번호를 다시 입력하세요";
    }
    if (value != _input['newpw']) {
      _isValidated['newrepw'] = false;
      return "위 비밀번호와 달라요";
    }
    setState(() {
      _isValidated['newrepw'] = true;
    });
    return "";
  }
}
