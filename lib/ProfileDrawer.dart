import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  State<ProfileDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<ProfileDrawer> {
  String name = '정해원';
  String email = 'haewon20430@cau.ac.kr';
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color(0xfff2f2f2),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Profile",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        foregroundImage:
                            AssetImage('assets/images/profileEx.png'),
                        foregroundColor: Colors.white,
                        radius: 55,
                      ),
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 15,
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text(email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    )),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "이름",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      TextFormField(
                        controller: TextEditingController(text: name),
                        textAlign: TextAlign.start,
                        cursorColor: Color(0xff585551),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          suffixIcon: Icon(
                            Icons.create,
                            size: 16,
                            color: Colors.black54,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(55),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, left: 40, right: 40),
                  //width: 90,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff6d8aa1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "저장",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                          "계정 설정",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff6d8aa1)),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('/accountsettings');
                        },
                      ),
                      Text(
                        "  또는  ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        child: Text(
                          "로그아웃",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff6d8aa1)),
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
