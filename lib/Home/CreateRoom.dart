import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Tools/Appbar/MyAppBar.dart';
import '../Tools/Color/Colors.dart';
import '../Tools/Dialog/DialogForm.dart';
import '../Tools/Loading/Loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool switchValue = false;
  String textValue = '';
  String _imageURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5";
  String groupKey = '';
  TextEditingController textController = TextEditingController();

  @override
  initState() {
    while (true) {
      bool stop = true;
      const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      Random _rnd = Random();
      String randomStr = String.fromCharCodes(Iterable.generate(5,
        (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
      ));
      db.collection("group").get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            if (randomStr == docSnapshot.id) stop = false;
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
      if (stop) {
        setState(() {
          groupKey = randomStr;
        });
        break;
      }
    }
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
                  "그룹 생성하기",
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
                          openAlbum(mediaSize.width, groupKey);
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
                                        final groupRef = storageRef.child("groupImage").child(groupKey);
                                        await groupRef.delete();
                                        setState(() {
                                          _imageURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/groupImage%2Fdefault_group.png?alt=media&token=038b6402-ba76-4591-8375-c805d9df01c5";
                                        });
                                        Navigator.of(context).popUntil(ModalRoute.withName('/createroom'));
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
                                        openAlbum(mediaSize.width, groupKey);
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
                onTap: () {
                  if (textValue.isNotEmpty) {
                    Loading.loadingPage(context, mediaSize.width);
                    final data = {
                      "groupURL": _imageURL,
                      "name": textValue,
                      "isPrivate": switchValue
                    };
                    final memberData = {
                      "isAdmin": true,
                    };
                    final userData = {
                      "open": DateTime.now().toString(),
                    };
                    db.collection("group").doc(groupKey).set(data, SetOptions(merge: true));
                    db.collection("group").doc(groupKey).collection('member').doc(user!.uid).set(memberData, SetOptions(merge: true));
                    db.collection("user").doc(user!.uid).collection('group').doc(groupKey).set(userData, SetOptions(merge: true));
                    Navigator.of(context).popUntil(ModalRoute.withName('/homepage'));
                  }
                },
                child: Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 50),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: textValue.isNotEmpty ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55)
                  ),
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
            Navigator.of(context).popUntil(ModalRoute.withName('/createroom'));
            break;
          case TaskState.canceled:
            Navigator.of(context).popUntil(ModalRoute.withName('/createroom'));
            break;
          case TaskState.error:
            Navigator.of(context).popUntil(ModalRoute.withName('/createroom'));
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
