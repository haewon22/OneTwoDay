import 'dart:io';
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

class ChangeProfile extends StatefulWidget {
  const ChangeProfile({super.key});

  @override
  State<ChangeProfile> createState() => ChangeProfileState();
}

class ChangeProfileState extends State<ChangeProfile> {
  var user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String textValue = '';
  late TextEditingController textController;

  @override
  void initState() {
    setState(() {
      textValue = user?.displayName ?? 'Unknown';
      textController = TextEditingController(text: textValue);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "",
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 50),
              child: Text(
                "프로필 편집",
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
                                      Navigator.of(context).popUntil(ModalRoute.withName('/changeprofile'));
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: TextFormField(
                    controller: textController,
                    maxLength: 5,
                    autovalidateMode: AutovalidateMode.always,
                    cursorColor: Color(0xff585551),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                    ],
                    onChanged: (String val) {
                      setState(() {
                        textValue = textController.text;
                      });
                    },
                    decoration: InputDecoration(
                      suffix: Text(
                        "${textValue.length}/5 ",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      labelText: 'Name',
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
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                if (textValue.isNotEmpty && textValue != user?.displayName) {
                  Loading.loadingPage(context, mediaSize.width);
                  await user?.updateDisplayName(textValue);
                  user = FirebaseAuth.instance.currentUser;
                  final data = {
                    'name': user?.displayName,
                    'profileURL': user?.photoURL
                  };
                  db.collection("user").doc(user!.uid).set(data, SetOptions(merge: true));
                  setState(() {
                    user = FirebaseAuth.instance.currentUser;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: mediaSize.width,
                height: 55,
                margin: EdgeInsets.fromLTRB(30, 30, 30, 50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: textValue.isNotEmpty && textValue != user?.displayName ? MainColors.blue : Colors.grey,
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
            )
          ],
        ),
      )
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
            Navigator.of(context).popUntil(ModalRoute.withName('/changeprofile'));
            break;
          case TaskState.canceled:
            Navigator.of(context).popUntil(ModalRoute.withName('/changeprofile'));
            break;
          case TaskState.error:
            Navigator.of(context).popUntil(ModalRoute.withName('/changeprofile'));
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
