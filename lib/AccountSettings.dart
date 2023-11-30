import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  String email = 'haewon20430@cau.ac.kr';
  String name = '정해원';
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: ""),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "계정 설정",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Color(0xff6d8aa1),
                      size: 150,
                    ),
                    Positioned(
                      right: 15,
                      bottom: 15,
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
              SizedBox(
                child: Text(
                  name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(30, 30, 30, 10),
                padding: EdgeInsets.only(left: 17),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/changeemail');
                  },
                  child: ListTile(
                    minLeadingWidth: 70,
                    leading: Text("Email"),
                    title: Text(
                      email,
                      style: TextStyle(fontSize: 14),
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
                margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                padding: EdgeInsets.only(left: 14),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/changepw');
                  },
                  child: ListTile(
                    leading: Text("비밀번호"),
                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                padding: EdgeInsets.only(left: 14),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Color(0xfff2f2f2),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                title: Text(
                                  '정말 탈퇴하시겠습니까?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                contentPadding: EdgeInsets.only(top: 30),
                                content: Builder(
                                  builder: (context) {
                                    var height =
                                        MediaQuery.of(context).size.height;
                                    var width =
                                        MediaQuery.of(context).size.width;

                                    return Container(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "탈퇴 시 계정의 모든 정보는 삭제되며\n다시 복구 할 수 없습니다.",
                                        textAlign: TextAlign.center,
                                      ),
                                      height: height - 600,
                                      width: width - 400,
                                    );
                                  },
                                ),
                                actionsAlignment: MainAxisAlignment.center,
                                actions: [
                                  Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        height: 50,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "탈퇴",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xff6d8aa1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        height: 50,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "취소",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ));
                    },
                    child: Text(
                      "계정탈퇴",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
