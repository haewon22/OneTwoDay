import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SampleItem { create, enter }

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final user = FirebaseAuth.instance.currentUser;
  SampleItem? selectedMenu;
  var offsetValue = 50.0;
  bool isSearch = false;
  String _input = "";
  bool _isFirstInput = true;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: -5
              ),
            ]
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
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
                                user?.displayName ?? "Unknown",
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
                              builder: (BuildContext context) {
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
                                            foregroundImage: NetworkImage(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
                                            radius: mediaSize.width / 5,
                                          ),
                                        ),
                                        Text(
                                          user?.displayName ?? "Unknown",
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
                                                Column(
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
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Column(
                                                            children: [
                                                              Text(
                                                                "정말로 로그아웃 하시나요?",
                                                                style: TextStyle(
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
                                                                  fontSize: 15,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          actions: <Widget>[
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Container(
                                                                    width: mediaSize.width/4,
                                                                    height: 40,
                                                                    margin: EdgeInsets.fromLTRB(30, 10, 10, 10),
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
                                                                    margin: EdgeInsets.fromLTRB(10, 10, 30, 10),
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
                          },
                        ),
                        Text(
                          "원투데이에 오신 걸 환영해요",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/calendar');
                  },
                  child: Image.asset(
                    'assets/images/calendar_icon.png',
                    height: 50,
                  )
                )
              ],
            ),
          )
        ),
        Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 20, 5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '그룹',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ),
              GestureDetector(
                child: SearchGroup(context),
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
              ),
              PopupMenuButton(
                offset: Offset(-20, offsetValue),
                icon: Icon(Icons.add),
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                    if (selectedMenu == SampleItem.create) {
                      offsetValue = 60.0;
                      Navigator.of(context).pushNamed('/createroom');
                    } else if (selectedMenu == SampleItem.enter) {
                      offsetValue = 110.0;
                      Navigator.of(context).pushNamed('/enterroom');
                    }
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.create,
                    child: Text("그룹 생성하기"),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.enter,
                    child: Text("그룹 참가하기"),
                  )
                ],
              ),
            ],
          ),
        ),
        //TODO: GirdView
      ],
    );
  }

  Widget SearchGroup(BuildContext context) {
    if (isSearch) {
      return Row(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 5),
            constraints: BoxConstraints(
              maxHeight: 40,
              maxWidth: 220
            ),
            child: TextFormField(
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              cursorColor: Color(0xff585551),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
          Icon(Icons.close)
        ],
      );
    }
    return Icon(Icons.search);
  }
}
