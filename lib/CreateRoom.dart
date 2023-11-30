import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: MyAppBar(
          appBar: AppBar(),
          title: "",
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 45),
                  child: Text(
                    "그룹 생성하기",
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
                        color: Colors.black26,
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
                Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: TextFormField(
                      cursorColor: Color(0xff585551),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        labelText: '그룹 이름',
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
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Private"),
                    Switch(
                        activeColor: Color(0xff6d8aa1),
                        value: switchValue,
                        onChanged: (bool value) {
                          setState(() {
                            switchValue = !switchValue;
                          });
                        }),
                    SizedBox(width: 50)
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff6d8aa1),
                      borderRadius: BorderRadius.circular(55)),
                  child: Text("완료",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                )
              ],
            ),
          ],
        ));
  }
}
