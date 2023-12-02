import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'ProfileDrawer.dart';

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
                        foregroundImage: NetworkImage(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
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
                        ProfileDrawer(),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                        child: Image.asset(
                          'assets/images/calendar_icon.png',
                          height: 45,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 12, 0),
                        child: Text(
                          DateTime.now().day.toString(),
                          style: TextStyle(
                            color: MainColors.blue,
                            fontFamily: "NPSfont",
                            fontSize: 20
                          )
                        )
                      )
                    ],
                  )
                )
              ],
            ),
          )
        ),
        Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(30, 20, 15, 0),
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
            ),
          ),
          Icon(Icons.close)
        ],
      );
    }
    return Icon(Icons.search);
  }
}
