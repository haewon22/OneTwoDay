import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: "", groupS: false),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 50),
                  child: Text(
                    "계정 설정",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                ),
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
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Text(
                    user?.displayName ?? "Unknown",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 20),
                  padding: EdgeInsets.only(left: 17),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/changeemail').then((_) {
                        setState(() {
                          user = FirebaseAuth.instance.currentUser;
                        });
                      });
                    },
                    child: ListTile(
                      minLeadingWidth: 70,
                      leading: Text(
                        "이메일 변경",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        user?.email ?? 'Unknown',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black87
                        ),
                        textAlign: TextAlign.end,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                  padding: EdgeInsets.only(left: 14),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/changepw');
                    },
                    child: ListTile(
                      leading: Text(
                        "비밀번호 변경",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/deleteaccount');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white),
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                    padding: EdgeInsets.only(left: 14),
                    child: ListTile(
                      leading: Text(
                        "계정 탈퇴",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.red
                        )
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
