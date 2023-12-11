import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Tools/Dialog/DialogForm.dart';
import 'package:flutter/services.dart';

class Granted {
  String name;
  bool isGranted;
  Granted(this.name, {this.isGranted = false});
}

class NGranted {
  String name;
  bool isGranted;
  NGranted(this.name, {this.isGranted = false});
}

class MemberSettings extends StatefulWidget {
  final String groupKey;
  MemberSettings({required this.groupKey});

  @override
  State<MemberSettings> createState() => _MemberSettingsState();
}

class _MemberSettingsState extends State<MemberSettings> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool isSearch = true;
  bool isChecked = true;
  String textValue = '';
  bool isAdmin = false;

  final List<Granted> _grant = [Granted('해원'), Granted('민성'), Granted("원석")];
  final List<NGranted> _ngrant = [
    NGranted('원해'),
    NGranted('성민'),
    NGranted("석원"),
    NGranted('원해d'),
    NGranted('성민d'),
    NGranted("석원d")
  ];

  @override
  void initState() {
    updateAdmin();
  }

  void updateAdmin() async {
    await db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = data['isAdmin'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "멤버 설정",
        groupS: false
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: SearchMember(context),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
              "권한이 부여된 멤버",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              itemCount: _grant.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            spreadRadius: -5)
                      ]),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                    leading: CircleAvatar(
                        radius: 25,
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        foregroundImage:
                            AssetImage('assets/images/profileEx.png')),
                    title: Text(
                      '${_grant[index].name}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        splashRadius: 0.1,
                        checkColor: Colors.white,
                        activeColor: MainColors.blue,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        value: isChecked,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "권한이 부여되지 않은 멤버",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              itemCount: _grant.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            spreadRadius: -5)
                      ]),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                    leading: CircleAvatar(
                        radius: 30,
                        foregroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        foregroundImage:
                            AssetImage('assets/images/profileEx.png')),
                    title: Text(
                      '${_ngrant[index].name}',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        splashRadius: 0.1,
                        checkColor: Colors.white,
                        activeColor: MainColors.blue,
                        shape: CircleBorder(),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        value: isChecked,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.groupKey));
          DialogForm.dialogForm(
            context, mediaSize.width,
            "그룹 키가 복사되었어요",
            '그룹 키: "${widget.groupKey}"\n초대할 사람에게 공유하세요'
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: MainColors.blue,
        shape: CircleBorder()
      ) : Container()
    );
  }

  Widget SearchMember(BuildContext context) {
    if (isSearch) {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxHeight: 50, maxWidth: MediaQuery.of(context).size.width - 50
        ),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          cursorColor: Color(0xff585551),
          decoration: InputDecoration(
            labelText: '멤버 검색',
            labelStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.black),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
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
          onChanged: (String val) {
            setState(() {
              textValue = val;
            });
          }
        ),
      );
    }
    return Icon(Icons.search);
  }
}
