import 'dart:io';
import '../Tools/Color/Colors.dart';
import '../Tools/Dialog/DialogForm.dart';
import '../Tools/Loading/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileForm extends StatefulWidget{
  @override
  ProfileFormState createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm> {
  var user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String _input = "";
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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 70,
                  margin: EdgeInsets.only(top: 45),
                  child: Text(
                    "프로필 등록",
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
                    "이름을 입력하고\n프로필 사진을 등록해주세요",
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
                    controller: textController,
                    autovalidateMode: AutovalidateMode.always,
                    cursorColor: Color(0xff585551),
                    maxLength: 5,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                    decoration: InputDecoration(
                      suffix: Text(
                        "${_input.length}/5 ",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: '이름',
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
                    onChanged: (String value) { 
                      setState(() {
                        _input = textController.text;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 60),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        foregroundImage: CachedNetworkImageProvider(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
                        radius: mediaSize.width / 4,
                        child: LoadingAnimationWidget.beat(
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (user?.photoURL == "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9") {
                            openAlbum(mediaSize.width);
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
                                          final profileRef = storageRef.child("profileImage").child(user?.uid ?? 'unknown');
                                          await profileRef.delete();
                                          await user?.updatePhotoURL("https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9");
                                          setState(() {
                                            user = FirebaseAuth.instance.currentUser;
                                          });
                                          Navigator.of(context).popUntil(ModalRoute.withName('/profileform'));
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
                                          openAlbum(mediaSize.width);
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
                GestureDetector(
                  onTap: () async {
                    if (_input.isNotEmpty) {
                      Loading.loadingPage(context, mediaSize.width);
                      await user?.updateDisplayName(_input);
                      user = FirebaseAuth.instance.currentUser;
                      final data = {
                        'name': user?.displayName,
                        'profileURL': user?.photoURL
                      };
                      db.collection("user").doc(user!.uid).set(data, SetOptions(merge: true));
                      Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => false);
                    }
                  },
                  child: Container(
                    width: mediaSize.width,
                    height: 55,
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _input.isNotEmpty ? MainColors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(55)
                    ),
                    child: Text(
                      "원투데이 시작하기",
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
      ),
    );
  }

  void openAlbum(double width) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Loading.loadingPage(context, width);
      final File file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref();
      final profileRef = storageRef.child("profileImage").child(user?.uid ?? 'unknown');

      await profileRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String profileURL = await profileRef.getDownloadURL();
            await user?.updatePhotoURL(profileURL);
            setState(() {
              user = FirebaseAuth.instance.currentUser;
            });
            Navigator.of(context).popUntil(ModalRoute.withName('/profileform'));
            break;
          case TaskState.canceled:
            Navigator.of(context).popUntil(ModalRoute.withName('/profileform'));
            break;
          case TaskState.error:
            Navigator.of(context).popUntil(ModalRoute.withName('/profileform'));
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