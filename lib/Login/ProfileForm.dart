import 'dart:io';
import '../Tools/Color/Colors.dart';
import '../Tools/Dialog/DialogForm.dart';
import '../Tools/Loading/Loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileForm extends StatefulWidget{
  @override
  ProfileFormState createState() => ProfileFormState();
}

class ProfileFormState extends State<ProfileForm> {
  String _input = "";
  bool _isFirstInput = true;
  bool _isValidated = false;
  String _imageURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9";
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
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
                  autovalidateMode: AutovalidateMode.always,
                  cursorColor: Color(0xff585551),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    labelText: '이름',
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
                  validator: (value) { 
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        if (!value!.isEmpty) _isFirstInput = false;
                        _input = value!;
                      });
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                alignment: Alignment.centerLeft,
                child: Text(
                  _nameValidator(_input!),
                  style: TextStyle(
                    color: MainColors.blue,
                    fontSize: 12
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 48, bottom: 60),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      backgroundColor: MainColors.background,
                      foregroundImage: NetworkImage(_imageURL),
                      foregroundColor: MainColors.background,
                      radius: mediaSize.width / 4,
                      child: LoadingAnimationWidget.beat(
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          Loading.loadingPage(context, mediaSize.width);
                          final File file = File(pickedFile.path);
                          final user = await FirebaseAuth.instance.currentUser;
                          final storageRef = FirebaseStorage.instance.ref();
                          final profileRef = storageRef.child("profileImage").child(user?.email ?? "unknown");

                          await profileRef.putFile(file).snapshotEvents.listen((taskSnapshot) async {
                            switch (taskSnapshot.state) {
                              case TaskState.running:
                                break;
                              case TaskState.paused:
                                break;
                              case TaskState.success:
                                String profileURL = await profileRef.getDownloadURL();
                                Navigator.of(context).pop();
                                setState(() {
                                  _imageURL = profileURL;
                                });
                                break;
                              case TaskState.canceled:
                                Navigator.of(context).pop();
                                break;
                              case TaskState.error:
                                Navigator.of(context).pop();
                                DialogForm.dialogForm(
                                  context, mediaSize.width,
                                  "사진 업로드를 실패했어요",
                                  "사진을 다시 업로드 해주세요"
                                );
                                break;
                            }
                          });
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
                  if (_isValidated) {
                    Loading.loadingPage(context, mediaSize.width);
                    final user = await FirebaseAuth.instance.currentUser;
                    await user?.updateDisplayName(_input);
                    await user?.updatePhotoURL(_imageURL);
                    Navigator.of(context).pushNamedAndRemoveUntil('/homepage', (route) => false);
                  }
                },
                child: Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isValidated ? MainColors.blue : Colors.grey,
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
    );
  }

  String _nameValidator(String value) {
    if (_isFirstInput!) return "";
    if (value.isEmpty) {
      _isValidated = false;
      return "이름을 입력하세요";
    }
    setState(() {
      _isValidated = true;
    });
    return "";
  }
}