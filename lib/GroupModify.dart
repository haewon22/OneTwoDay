import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'Tools/Color/Colors.dart';
import 'Tools/Dialog/DialogForm.dart';
import 'Tools/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupModify extends StatefulWidget {
  final String groupKey;
  GroupModify({required this.groupKey});

  @override
  State<GroupModify> createState() => _GroupModifyState();
}

class _GroupModifyState extends State<GroupModify> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool switchValue = false;
  String textValue = '';
  String _imageURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Ftransparent.png?alt=media&token=8f6724fb-0983-480d-bf95-ec3a1bf7a503";
  TextEditingController textController = TextEditingController(text: "");
  Map<String, dynamic> origin = {'name': "", 'isPrivate': false};

  @override
  void initState() {
    updateGroup();
  }

  void updateGroup() async {
    await db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          textValue = data['name'];
          textController = TextEditingController(text: data['name']);
          _imageURL = data['groupURL'];
          switchValue = data['isPrivate'];
          origin['name'] = data['name'];
          origin['isPrivate'] = data['isPrivate'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
  
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
                margin: EdgeInsets.fromLTRB(0, 15, 0, 50),
                child: Text(
                  "그룹 설정",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(_imageURL),
                      radius: mediaSize.width / 4,
                      child: LoadingAnimationWidget.beat(
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_imageURL == "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5") {
                          openAlbum(mediaSize.width, widget.groupKey);
                        } else {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 140,
                                padding: EdgeInsets.only(bottom: 45),
                                decoration: BoxDecoration(
                                  color: MainColors.background,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(50)
                                  )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Loading.loadingPage(context, mediaSize.width);
                                        final storageRef = FirebaseStorage.instance.ref();
                                        final groupRef = storageRef.child("groupImage").child(widget.groupKey);
                                        await groupRef.delete();
                                        setState(() {
                                          _imageURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5";
                                        });
                                        await db.collection("group").doc(widget.groupKey).set({'groupURL': "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5"}, SetOptions(merge: true));
                                        int count = 0;
                                        Navigator.of(context).popUntil((_) => count++ >= 2);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: MainColors.blue,
                                            ),
                                          ),
                                          Text(
                                            "사진 삭제",
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
                                        openAlbum(mediaSize.width, widget.groupKey);
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.image,
                                              size: 30,
                                              color: MainColors.blue
                                            ),
                                          ),
                                          Text(
                                            "사진 수정",
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
                              );
                            }
                          );
                        }
                      },
                      child: Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: mediaSize.width / 15,
                          child: Icon(
                            Icons.camera_alt,
                            size: mediaSize.width / 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: TextFormField(
                      controller: textController,
                      maxLength: 10,
                      autovalidateMode: AutovalidateMode.always,
                      cursorColor: Color(0xff585551),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (String val) {
                        setState(() {
                          textValue = textController.text;
                        });
                      },
                      decoration: InputDecoration(
                        suffix: Text(
                          "${textValue.length}/10 ",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        labelText: 'Group name',
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(right: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Text("Private"),
                        ),
                        CupertinoSwitch(
                          activeColor: MainColors.blue,
                          value: switchValue,
                          onChanged: (bool value) {
                            setState(() {
                              switchValue = !switchValue;
                            });
                          }
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (!(origin['name'] == textValue && origin['isPrivate'] == switchValue)) {
                    Loading.loadingPage(context, mediaSize.width);
                    final data = {
                      "name": textValue,
                      "isPrivate": switchValue
                    };
                    await db.collection("group").doc(widget.groupKey).set(data, SetOptions(merge: true));
                    setState(() {
                      origin['name'] = textValue;
                      origin['isPrivate'] = switchValue;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !(origin['name'] == textValue && origin['isPrivate'] == switchValue) ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55)
                  ),
                  child: Text(
                    "수정",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                    )
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
                              "그룹을 삭제할까요?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          ],
                        ),
                        content: Text(
                          "그룹 삭제 후 되돌릴 수 없어요",
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
                                  Loading.loadingPage(context, mediaSize.width);
                                  await db.collection('group').doc(widget.groupKey).collection('member').get().then(
                                    (querySnapshot) async {
                                      for (var docSnapshot in querySnapshot.docs) {
                                        await db.collection("user").doc(docSnapshot.id).collection("group").doc(widget.groupKey).delete();
                                      }
                                    },
                                    onError: (e) => print("Error completing: $e"),
                                  );
                                  final board = db.collection('group').doc(widget.groupKey).collection("board");
                                  await board.get().then(
                                    (querySnapshot) async {
                                      for (var docSnapshot in querySnapshot.docs) {
                                        await board.doc(docSnapshot.id).collection("chat").get().then(
                                          (querySnapshot2) async {
                                            for (var docSnapshot2 in querySnapshot2.docs) {
                                              await board.doc(docSnapshot.id).collection("chat").doc(docSnapshot2.id).delete();
                                            }
                                          },
                                          onError: (e) => print("Error completing: $e"),
                                        );
                                        await board.doc(docSnapshot.id).delete();
                                      }
                                    },
                                    onError: (e) => print("Error completing: $e"),
                                  );
                                  await db.collection("group").doc(widget.groupKey).collection("chat").get().then(
                                    (querySnapshot) async {
                                      for (var docSnapshot in querySnapshot.docs) {
                                        await db.collection("group").doc(widget.groupKey).collection("chat").doc(docSnapshot.id).delete();
                                      }
                                    },
                                    onError: (e) => print("Error completing: $e"),
                                  );
                                  await db.collection("group").doc(widget.groupKey).collection("member").get().then(
                                    (querySnapshot) async {
                                      for (var docSnapshot in querySnapshot.docs) {
                                        await db.collection("group").doc(widget.groupKey).collection("member").doc(docSnapshot.id).delete();
                                      }
                                    },
                                    onError: (e) => print("Error completing: $e"),
                                  );
                                  await db.collection("group").doc(widget.groupKey).delete();
                                  if (_imageURL != "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5") {
                                    final storageRef = FirebaseStorage.instance.ref();
                                    final groupRef = storageRef.child("groupImage").child(widget.groupKey);
                                    await groupRef.delete();
                                  }
                                  Navigator.of(context).popUntil(ModalRoute.withName('/homepage'));
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
                child: Text(
                  "그룹 삭제",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  void openAlbum(double width, String key) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Loading.loadingPage(context, width);
      final File file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref();
      final groupRef = storageRef.child("groupImage").child(key);

      await groupRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String groupURL = await groupRef.getDownloadURL();
            setState(() {
              _imageURL = groupURL;
            });
            await db.collection("group").doc(widget.groupKey).set({'groupURL': groupURL}, SetOptions(merge: true));
            Navigator.of(context).pop();
            break;
          case TaskState.canceled:
            Navigator.of(context).pop();
            break;
          case TaskState.error:
            Navigator.of(context).pop();
            DialogForm.dialogForm(
              context, width,
              "사진 업로드를 실패했어요",
              "사진을 다시 업로드 해주세요"
            );
            break;
        }
      });
    }
  }
}
