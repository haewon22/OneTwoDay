import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            foregroundImage: CachedNetworkImageProvider(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
            child: LoadingAnimationWidget.beat(
              color: Colors.grey,
              size: 30,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: Row(
                children: [
                  Text(
                    user?.displayName ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900
                    )
                  ),
                  Text(
                    " 님",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    "   >",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
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
                                    foregroundImage: CachedNetworkImageProvider(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
                                    radius: mediaSize.width / 5,
                                    child: LoadingAnimationWidget.beat(
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                                ),
                                Text(
                                  user?.displayName ?? 'Unknown',
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
                                          onTap: () {
                                            Navigator.of(context).pushNamed('/accountsettings');
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
                                                "계정 설정",
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
                                            Navigator.of(context).pushNamed('/changeprofile').then((_) {
                                              myState(() {
                                                setState(() {
                                                  user = FirebaseAuth.instance.currentUser;
                                                });
                                              });
                                            });
                                          },
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 30,
                                                  color: MainColors.blue
                                                ),
                                              ),
                                              Text(
                                                "프로필 편집",
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
                                                        "정말로 로그아웃 하시나요?",
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
                                                        "언제든 원투데이에 다시 돌아와주세요",
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
                                                          onTap: () {
                                                            FirebaseAuth.instance.signOut();
                                                            Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                                                          },
                                                          child: Container(
                                                            width: 100,
                                                            height: 40,
                                                            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: MainColors.blue,
                                                              borderRadius: BorderRadius.circular(55)
                                                            ),
                                                            child: Text(
                                                              "확인",
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
                                                "로그아웃",
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
            ),
            Text(
              "원투데이에 오신 걸 환영해요",
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ],
    );
  }
}