import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: ""),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 50),
                child: Text(
                  "계정 설정",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                foregroundImage: NetworkImage(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
                radius: mediaSize.width / 4,
                child: LoadingAnimationWidget.beat(
                  color: Colors.grey,
                  size: 50,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Text(
                  user?.displayName ?? "Unknown",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(30, 30, 30, 20),
                padding: EdgeInsets.only(left: 17),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/changeemail').then((_) {
                      setState(() {
                        user = FirebaseAuth.instance.currentUser;
                      });
                    });
                  },
                  child: ListTile(
                    minLeadingWidth: 70,
                    leading: Text(
                      "이메일 변경",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      user?.email ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87
                      ),
                      textAlign: TextAlign.end,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                padding: EdgeInsets.only(left: 14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/changepw');
                  },
                  child: ListTile(
                    leading: Text(
                      "비밀번호 변경",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
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
                                  width: mediaSize.width/4,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(0, 10, 5, 10),
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
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                  Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                                },
                                child: Container(
                                  width: mediaSize.width/4,
                                  height: 40,
                                  margin: EdgeInsets.fromLTRB(5, 10, 0, 10),
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
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  padding: EdgeInsets.only(left: 14),
                  child: ListTile(
                    leading: Text(
                      "계정 탈퇴",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red
                      )
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
