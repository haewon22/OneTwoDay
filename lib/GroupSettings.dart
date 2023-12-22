import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:onetwoday/GroupModify.dart';
import 'package:onetwoday/MemberSettings.dart';

import 'Tools/Color/Colors.dart';
import 'Tools/Dialog/DialogForm.dart';
import 'Tools/Loading/Loading.dart';

class GroupSettings extends StatefulWidget {
  final String groupKey;
  final Function() function;

  GroupSettings({required this.groupKey, required this.function});

  @override
  State<GroupSettings> createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  var user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String groupName = "";
  String groupURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Ftransparent.png?alt=media&token=8f6724fb-0983-480d-bf95-ec3a1bf7a503";
  bool isAdmin = false;

  @override
  void initState() {
    updateGroup();
    updateAdmin();
  }

  void updateGroup() async {
    await db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          groupName = data['name'];
          groupURL = data['groupURL'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void updateAdmin() async {
    await db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = data['isAdmin'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(right: 15),
        child: Icon(Icons.menu)
      ),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter myState) {
                return Container(
                  height: 450,
                  decoration: BoxDecoration(
                    color: MainColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50)
                    )
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 80, bottom: 10),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(groupURL),
                            radius: mediaSize.width / 5,
                            child: LoadingAnimationWidget.beat(
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                        Text(
                          groupName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900
                          )
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 45),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (isAdmin) await Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => GroupModify(groupKey: widget.groupKey)
                                    )).then((_) async {
                                      await db.collection('group').doc(widget.groupKey).get().then(
                                        (DocumentSnapshot doc) {
                                          if (doc.data() != null) {
                                            final data = doc.data() as Map<String, dynamic>;
                                            myState(() {
                                              setState(() {
                                                groupName = data['name'];
                                                groupURL = data['groupURL'];
                                              });
                                            });
                                            widget.function();
                                          }
                                        },
                                        onError: (e) => print("Error getting document: $e"),
                                      );
                                    });
                                    else DialogForm.dialogForm(
                                      context, mediaSize.width,
                                      "권한자만 접근할 수 있어요",
                                      "권한자에게 권한 부여를 요청해보세요"
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.settings,
                                          size: 30,
                                          color: MainColors.blue,
                                        ),
                                      ),
                                      Text(
                                        "그룹 설정",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:MainColors.blue
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (isAdmin) await Navigator.push(context, MaterialPageRoute(builder: (context) => MemberSettings(groupKey: widget.groupKey))).then((_) async {
                                      await db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
                                        (DocumentSnapshot doc) {
                                          final data = doc.data() as Map<String, dynamic>;
                                          myState(() {
                                            setState(() {
                                              isAdmin = data['isAdmin'];
                                            });
                                          });
                                          widget.function();
                                        },
                                        onError: (e) => print("Error getting document: $e"),
                                      );
                                    });
                                    else DialogForm.dialogForm(
                                      context, mediaSize.width,
                                      "권한자만 접근할 수 있어요",
                                      "권한자에게 권한 부여를 요청해보세요"
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: MainColors.blue
                                        ),
                                      ),
                                      Text(
                                        "멤버 설정",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: MainColors.blue
                                        ),
                                      )
                                    ],
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
                                                "정말로 그룹을 나가시나요?",
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
                                                "활동했던 기록은 지워지지 않아요",
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
                                                    int count = 0;
                                                    await db.collection("group").doc(widget.groupKey).collection("member").where("isAdmin", isEqualTo: true).get().then(
                                                      (querySnapshot) {
                                                        for (var docSnapshot in querySnapshot.docs) {
                                                          count++;
                                                        }
                                                      },
                                                      onError: (e) => print("Error completing: $e"),
                                                    );
                                                    if (isAdmin && count < 2) {
                                                      Navigator.of(context).pop();
                                                      DialogForm.dialogForm(
                                                        context, mediaSize.width,
                                                        "그룹을 나갈 수 없어요",
                                                        "권한자가 2명 이상일 때\n그룹을 나갈 수 있어요\n혹시 그룹 삭제를 원하신다면\n그룹 설정으로 가주세요"
                                                      );
                                                    } else {
                                                      await db.collection("group").doc(widget.groupKey).collection("member").doc(user!.uid).delete();
                                                      await db.collection("user").doc(user!.uid).collection("group").doc(widget.groupKey).delete();
                                                      Navigator.of(context).popUntil(ModalRoute.withName('/homepage'));
                                                    }
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
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.logout,
                                          size: 30,
                                          color: MainColors.blue
                                        ),
                                      ),
                                      Text(
                                        "그룹 탈퇴",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: MainColors.blue
                                        ),
                                      )
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }
        );
      },
    );
  }
}
