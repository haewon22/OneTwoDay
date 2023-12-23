import 'package:flutter/material.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import '../../Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../Tools/Dialog/DialogForm.dart';
import '../../Tools/Loading/Loading.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final db = FirebaseFirestore.instance;
  String _input = "";
  bool _passwordVisible = false;
  TextEditingController textController = TextEditingController();
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
                    "계정 탈퇴",
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
                    "계정을 탈퇴하시려면\n비밀번호을 입력해주세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      height: 1.7
                    )
                  ),
                ),
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 20), 
                  child: TextFormField(
                    controller: textController,
                    autovalidateMode: AutovalidateMode.always,
                    cursorColor: Color(0xff585551),
                    obscureText: !_passwordVisible!,
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
                            _passwordVisible = !_passwordVisible!;
                          });
                        },
                        child: Icon(
                          _passwordVisible! ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey
                        ),
                      ),
                    ),
                    onChanged: (String value) { 
                      setState(() {
                        _input = textController.text;
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (_input!.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: MainColors.background,
                            title: Column(
                              children: [
                                Text(
                                  "정말로 탈퇴하시나요?",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "탈퇴 시 계정의 모든 정보는 삭제되고\n다시 복구 할 수 없어요",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(55)
                                      ),
                                      child: Text(
                                        "취소",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700
                                        )
                                      ),
                                    )
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      Loading.loadingPage(context, mediaSize.width);
                                      final user = await FirebaseAuth.instance.currentUser;
                                      final cred = EmailAuthProvider.credential(
                                        email: user?.email ?? 'Unknown', password: _input!
                                      );
                                      await user!.reauthenticateWithCredential(cred).then((value) async {
                                        bool canDelete = true;
                                        await db.collection("user").doc(user.uid).collection("group").get().then(
                                          (querySnapshot) async {
                                            for (var docSnapshot in querySnapshot.docs) {
                                              int count = 0;
                                              bool isAdmin = false;
                                              await db.collection("group").doc(docSnapshot.id).collection("member").doc(user.uid).get().then(
                                                (DocumentSnapshot doc) {
                                                  final data = doc.data() as Map<String, dynamic>;
                                                  isAdmin = data['isAdmin'];
                                                },
                                                onError: (e) => print("Error getting document: $e"),
                                              );
                                              await db.collection("group").doc(docSnapshot.id).collection("member").where("isAdmin", isEqualTo: true).get().then(
                                                (querySnapshot) {
                                                  for (var docSnapshot in querySnapshot.docs) {
                                                    count++;
                                                  }
                                                },
                                                onError: (e) => print("Error completing: $e"),
                                              );
                                              if (isAdmin && count < 2) {
                                                canDelete = false;
                                                break;
                                              }
                                            }
                                          },
                                          onError: (e) => print("Error completing: $e"),
                                        );

                                        if (canDelete) {
                                          await db.collection("user").doc(user.uid).collection("group").get().then(
                                            (querySnapshot) async {
                                              for (var docSnapshot in querySnapshot.docs) {
                                                await db.collection("group").doc(docSnapshot.id).collection("member").doc(user.uid).delete();
                                                await db.collection("user").doc(user.uid).collection("group").doc(docSnapshot.id).delete();
                                              }
                                            },
                                            onError: (e) => print("Error completing: $e"),
                                          );
                                          await db.collection("user").doc(user.uid).collection("calendar").get().then(
                                            (querySnapshot) async {
                                              for (var docSnapshot in querySnapshot.docs) {
                                                await db.collection("user").doc(user.uid).collection("calendar").doc(docSnapshot.id).delete();
                                              }
                                            },
                                            onError: (e) => print("Error completing: $e"),
                                          );
                                          await db.collection("user").doc(user.uid).delete();
                                          if (user.photoURL != "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9") {
                                            final storageRef = FirebaseStorage.instance.ref();
                                            final profileRef = storageRef.child("profileImage").child(user.uid);
                                            await profileRef.delete();
                                          }
                                          await user.delete();
                                          Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                                        } else {
                                          Navigator.of(context).pop();
                                          DialogForm.dialogForm(
                                            context, mediaSize.width,
                                            "계정 삭제가 불가능해요",
                                            "혼자 권한자인 그룹이 있어\n계정 삭제가 불가능해요\n권한자를 추가하거나 그룹을 삭제하고\n다시 시도해주세요"
                                          );
                                        }
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
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 40,
                                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(55)
                                      ),
                                      child: Text(
                                        "탈퇴",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700
                                        )
                                      ),
                                    )
                                  ),
                                ],
                              )
                            ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    width: mediaSize.width,
                    height: 55,
                    margin: EdgeInsets.fromLTRB(30, 5, 30, 30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _input!.isNotEmpty ? Colors.red : Colors.grey,
                      borderRadius: BorderRadius.circular(55)
                    ),
                    child: Text(
                      "계정 탈퇴",
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
}
