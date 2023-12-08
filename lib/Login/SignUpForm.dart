import '../Tools/Color/Colors.dart';
import '../Tools/Loading/Loading.dart';
import '../Tools/Dialog/DialogForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpForm extends StatefulWidget{
  @override
  SignUpFormState createState() => SignUpFormState();
}

class SignUpFormState extends State<SignUpForm> {
  String _password = "00000000";
  Map<String, bool> _isEmail = {'sent': false, 'verified': false};
  Map<String, bool> _textVisible = {'pw': false, 'repw': false};
  Map<String, String> _input = {'email' : "", 'pw' : "", 'repw' : ""};
  Map<String, bool> _isFirstInput = {'email' : true, 'pw' : true, 'repw' : true};
  Map<String, bool> _isValidated = {'email' : false, 'pw' : false, 'repw' : false};
  List<TextEditingController> textController = [TextEditingController(), TextEditingController(), TextEditingController()];

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
                  "회원가입",
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
                  !_isEmail['sent']! ? "이메일을 입력해주세요" : !_isEmail['verified']! ? "인증 메일을 확인해주세요" : "비밀번호를 입력해주세요",
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
                  enabled: !_isEmail['sent']!,
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
                  onChanged: (String value) { 
                    setState(() {
                      if (!textController[0].text.isEmpty) _isFirstInput['email'] = false;
                      _input['email'] = textController[0].text;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  _emailValidator(_input['email']!),
                  style: TextStyle(
                    color: MainColors.blue,
                    fontSize: 11.9
                  ),
                )
              ),
              _signUpBottomForm(mediaSize)
            ]
          )
        ),
      )
    );
  }
  
  Widget _signUpBottomForm(dynamic mediaSize) {
    if (_isEmail['sent']! && !_isEmail['verified']!) {
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.currentUser?.reload();
              final user = await FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  setState(() {
                    _isEmail['verified'] = true;
                  });
                }
                else {
                  DialogForm.dialogForm(
                    context, mediaSize.width,
                    "아직 인증되지 않았어요",
                    "입력하신 이메일에서\n인증 메일이 왔는지 확인하고\n메일 속 링크를 눌러주세요"
                  );
                }
              }
            },
            child: Container(
              width: mediaSize.width,
              height: 55,
              margin: EdgeInsets.fromLTRB(30, 8, 30, 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: MainColors.blue,
                borderRadius: BorderRadius.circular(55)
              ),
              child: Text(
                "이메일 인증 완료",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                )
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "인증 메일이 오지 않았나요?  ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                )
              ),
              GestureDetector(
                onTap: () async {
                  Loading.loadingPage(context, mediaSize.width);
                  final user = await FirebaseAuth.instance.currentUser;
                  final cred = EmailAuthProvider.credential(
                    email: _input['email']!, password: _password
                  );
                  user!.reauthenticateWithCredential(cred).then((value) {
                    user.delete().then((_) {
                      Navigator.of(context).pop();
                      setState(() {
                        _isEmail['sent'] = false;
                      });
                    });
                  });
                },
                child: Text(
                  "주소 수정하기",
                  style: TextStyle(
                    color: MainColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600
                  )
                )
              ),
            ],
          ),
        ]
      );
    } else if (_isEmail['sent']! && _isEmail['verified']!) {
      return Column(
        children: [
          Container(
            height: 55,
            margin: EdgeInsets.fromLTRB(30, 8, 30, 0), 
            child: TextFormField(
              controller: textController[1],
              autovalidateMode: AutovalidateMode.always,
              obscureText: !_textVisible['pw']!,
              cursorColor: Color(0xff585551),
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
                      _textVisible['pw'] = !_textVisible['pw']!;
                    });
                  },
                  child: Icon(
                    _textVisible['pw']! ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey
                  ),
                ),
              ),
              onChanged: (String value) {
                setState(() {
                  if (!textController[1].text.isEmpty) _isFirstInput['pw'] = false;
                  _input['pw'] = textController[1].text;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.centerLeft,
            child: Text(
              _pwValidator(_input['pw']!),
              style: TextStyle(
                color: MainColors.blue,
                fontSize: 11.9
              ),
            )
          ),
          Container(
            height: 55,
            margin: EdgeInsets.fromLTRB(30, 8, 30, 0), 
            child: TextFormField(
              controller: textController[2],
              autovalidateMode: AutovalidateMode.always,
              obscureText: !_textVisible['repw']!,
              cursorColor: Color(0xff585551),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                labelText: 'Re-Password',
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
                      _textVisible['repw'] = !_textVisible['repw']!;
                    });
                  },
                  child: Icon(
                    _textVisible['repw']! ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey
                  ),
                ),
              ),
              onChanged: (String value) { 
                setState(() {
                  if (!textController[2].text.isEmpty) _isFirstInput['repw'] = false;
                  _input['repw'] = textController[2].text;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.centerLeft,
            child: Text(
              _repwValidator(_input['repw']!),
              style: TextStyle(
                color: MainColors.blue,
                fontSize: 11.9
              ),
            )
          ),
          GestureDetector(
            onTap: () async {
              if (_isValidated['pw']! && _isValidated['repw']!) {
                Loading.loadingPage(context, mediaSize.width);
                final user = await FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(
                  email: _input['email']!, password: _password
                );
                user!.reauthenticateWithCredential(cred).then((value) {
                  user.updatePassword(_input['pw']!).then((_) {
                    setState(() {
                      _password = _input['pw']!;
                    });
                    Navigator.of(context).popAndPushNamed('/profileform');
                  });
                });
                await user?.updatePhotoURL("https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9");
              }
            },
            child: Container(
              width: mediaSize.width,
              height: 55,
              margin: EdgeInsets.fromLTRB(30, 8, 30, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (_isValidated['pw']! && _isValidated['repw']!) ? MainColors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(55)
              ),
              child: Text(
                "다음",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                )
              ),
            )
          ),
        ]
      );
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            if(_isValidated['email']!) {
              try {
                Loading.loadingPage(context, mediaSize.width);
                final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _input['email']!,
                  password: _password,
                );
                if (credential.user != null) await credential.user!.sendEmailVerification();
                Navigator.of(context).pop();
                setState(() {
                  _isEmail['sent'] = true;
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  Navigator.of(context).pop();
                  DialogForm.dialogForm(
                    context, mediaSize.width,
                    "이미 가입된 계정이예요",
                    "다른 이메일 주소로 가입해주세요"
                  );
                }
              }
            }
          },
          child: Container(
            width: mediaSize.width,
            height: 55,
            margin: EdgeInsets.fromLTRB(30, 8, 30, 30),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _isValidated['email']! ? MainColors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(55)
            ),
            child: Text(
              "인증 메일 보내기",
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
    );
  }

  String _emailValidator(String value) {
    if (_isFirstInput['email']!) return "";
    if (value.isEmpty) {
      _isValidated['email'] = false;
      return "이메일을 입력하세요";
    }
    if (!value.contains("@") || !value.contains(".")) {
      _isValidated['email'] = false;
      return "이메일 형식으로 입력하세요";
    }
    setState(() {
      _isValidated['email'] = true;
    });
    return "";
  }

  String _pwValidator(String value) {
    if (_isFirstInput['pw']!) return "";
    if (value.isEmpty) {
      _isValidated['pw'] = false;
      return "비밀번호를 입력하세요";
    }
    if (value.length < 8) {
      _isValidated['pw'] = false;
      return "비밀번호를 8자 이상 입력하세요";
    }
    setState(() {
      _isValidated['pw'] = true;
    });
    return "";
  }

  String _repwValidator(String value) {
    if (_isFirstInput['repw']!) return "";
    if (value.isEmpty) {
      _isValidated['repw'] = false;
      return "비밀번호를 다시 입력하세요";
    }
    if (value != _input['pw']) {
      _isValidated['repw'] = false;
      return "위 비밀번호와 달라요";
    }
    setState(() {
      _isValidated['repw'] = true;
    });
    return "";
  }
}