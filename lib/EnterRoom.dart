import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'Tools/Color/Colors.dart';
import 'Tools/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tools/Dialog/DialogForm.dart';

class EnterRoom extends StatefulWidget {
  const EnterRoom({super.key});

  @override
  State<EnterRoom> createState() => _EnterRoomState();
}

class _EnterRoomState extends State<EnterRoom> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool _isClicked = false;
  String textValue = '';
  TextEditingController textController = TextEditingController();

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
        appBar: MyAppBar(
          appBar: AppBar(),
          title: "",
          groupS: false
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
                  controller: textController,
                  autovalidateMode: AutovalidateMode.always,
                  cursorColor: Color(0xff585551),
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp('[a-zA-Z]'),
                        allow: true),
                  ],
                  onChanged: (String val) {
                    setState(() {
                      textValue = textController.text;
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
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(55),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(55),
                    ),
                  )
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Loading.loadingPage(context, mediaSize.width);
                  bool isExist = true;
                  bool isPrivate = false;
                  await db.collection("group").doc(textValue).get().then(
                    (DocumentSnapshot doc) {
                      if (doc.data() == null) {
                        isExist = false;
                        Navigator.of(context).pop();
                        DialogForm.dialogForm(
                          context, mediaSize.width,
                          "그룹이 존재하지 않아요",
                          "존재하지 않은 그룹 키예요\n그룹 키를 다시 입력해주세요"
                        );
                      } else {
                        final data = doc.data() as Map<String, dynamic>;
                        setState(() {
                          isPrivate = data['isPrivate'];
                        });
                      }
                    },
                    onError: (e) => print("Error getting document: $e"),
                  );
                  if (isExist) {
                    final memberData = {
                      "isAdmin": !isPrivate,
                    };
                    final userData = {
                      "open": DateTime.now().toString(),
                    };
                    db.collection("group").doc(textValue).collection('member').doc(user!.uid).set(memberData, SetOptions(merge: true));
                    db.collection("user").doc(user!.uid).collection('group').doc(textValue).set(userData, SetOptions(merge: true));
                    Navigator.of(context).popUntil(ModalRoute.withName('/homepage'));
                  }
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
      ),
    );
  }
}
