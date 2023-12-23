import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Dashboard/Notice/AddNewNotice.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import '../../Dashboard/Notice/Mywriting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../../Tools/Color/Colors.dart';
import '../../Tools/Dialog/DialogForm.dart';
import 'package:lottie/lottie.dart';

class Myboard extends StatefulWidget {
  final String groupKey;
  Myboard({required this.groupKey});

  @override
  MyboardState createState() => MyboardState();
}

class MyboardState extends State<Myboard> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String groupName = "";
  String message = "";
  double startX = 0;
  bool dragtoLeft = false;
  bool isAdmin = false;
  bool isLoaded= false;

  removeData(index) {
    notice.removeAt(index);
  }

  List<Map<String, dynamic>> notice = [];

  @override
  void initState() {
    db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          groupName = data['name'] + " 게시판";
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = data['isAdmin'];
          message = isAdmin ? "아직 게시글이 없어요\n새로운 게시글을 추가해봐요" : "아직 게시글이 없어요";
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    updateBoard();
    db.collection("user").doc(user!.uid).collection("group").doc(widget.groupKey).snapshots().listen(
      (event) {
        if (event.data() == null) Future.delayed(Duration.zero, () {
          if (mounted) DialogForm.dialogQuit(context);
        });
      }
    );
  }

  void updateBoard() async {
    final List<Map<String, dynamic>> updateNotice = [];
    await db.collection("group").doc(widget.groupKey).collection("board").orderBy("date", descending: true).get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          String noticeId = docSnapshot.id;
          String title = docSnapshot.data()['title'];
          String name = "";
          String date = DateFormat('yyyy.MM.dd').format(DateTime.parse(docSnapshot.data()['date']));
          int chat = 0;
          await db.collection("user").doc(docSnapshot.data()['uid']).get().then(
            (DocumentSnapshot doc) {
              if (doc.data() == null) {
                setState(() {
                  name = "탈퇴 계정";
                });
              } else {
                final data = doc.data() as Map<String, dynamic>;
                setState(() {
                  name = data['name'];
                });
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
          await db.collection("group").doc(widget.groupKey).collection("board").doc(docSnapshot.id).collection("chat").get().then(
            (querySnapshot) async {
              for (var docSnapshot in querySnapshot.docs) {
                setState(() {
                  chat++;
                });
              }
            },
            onError: (e) => print("Error completing: $e"),
          );
          updateNotice.add({
            'id': noticeId,
            'title': title,
            'name': name,
            'date': date,
            'chat': chat.toString()
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      notice = updateNotice;
      isLoaded = true;
    });
  }
  
  Widget listview_builder() {
    return ListView.builder(
      itemCount: notice.length,
      itemBuilder: (BuildContext context, int index) {
        String title = notice[index]['title'];
        String writer = notice[index]['name'];
        String date = notice[index]['date'];
        String chat = notice[index]['chat'];
        return Container(
          margin: index == 0 ? EdgeInsets.only(top: 10) : index == notice.length - 1 ? EdgeInsets.only(bottom: 72) : EdgeInsets.all(0),
          child: Slidable(
            enabled: isAdmin,
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: MainColors.background,
                          title: Column(
                            children: [
                              Text(
                                "게시글을 삭제할까요?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                          content: Text(
                            "게시글은 삭제 후 되돌릴 수 없어요",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                            ),
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
                                    margin: EdgeInsets.only(right: 5),
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
                                    final noticeOne = db.collection("group").doc(widget.groupKey).collection("board").doc(notice[index]['id']);
                                    await noticeOne.collection("chat").get().then(
                                      (querySnapshot) async {
                                        for (var docSnapshot in querySnapshot.docs) {
                                          await noticeOne.collection("chat").doc(docSnapshot.id).delete();
                                        }
                                      },
                                      onError: (e) => print("Error completing: $e"),
                                    );
                                    await noticeOne.delete();
                                    updateBoard();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    margin: EdgeInsets.only(left: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(55)
                                    ),
                                    child: Text(
                                      "삭제",
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
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                ),
              ]
            ),
            child: ListTile(
              iconColor: MainColors.blue,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Mywriting(groupKey: widget.groupKey, noticeKey: notice[index]['id']))).then((_) {
                  updateBoard();
                });
              },
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 15),
                    width: 5,
                    height: 45,
                    decoration: BoxDecoration(
                      color: MainColors.blue
                    )
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 230,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w800
                          )
                        ),
                      ),
                      Text(writer),
                    ],
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date + ' 게시',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    '댓글 ' + chat,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        title: groupName,
        groupS: false,
        appBar: AppBar()
      ),
      body: isLoaded ? notice.length != 0 ? listview_builder() : Container(
        padding: EdgeInsets.only(bottom: 72),
        alignment: Alignment.center,
        width: mediaSize.width,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12
          ),
        ),
      ) : Container(
        padding: EdgeInsets.only(bottom: 72),
        alignment: Alignment.center,
        width: mediaSize.width,
        child: Lottie.asset(
          'assets/lotties/loading.json',
          frameRate: FrameRate.max,
          width: 50,
          height: 50
        ),
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewNotice(groupKey: widget.groupKey))).then((_) {
            updateBoard();
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: MainColors.blue,
        shape: CircleBorder()
      ) : Container()
    );
  }
}
