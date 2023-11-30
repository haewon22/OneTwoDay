import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';

class EnterRoom extends StatefulWidget {
  const EnterRoom({super.key});

  @override
  State<EnterRoom> createState() => _EnterRoomState();
}

class _EnterRoomState extends State<EnterRoom> {
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
                    "그룹 들어가기",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
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
                        labelText: 'Key',
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
                SizedBox(height: 20),
                Container(
                  width: mediaSize.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xff6d8aa1),
                      borderRadius: BorderRadius.circular(55)),
                  child: Text("들어가기",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                )
              ],
            ),
          ],
        ));
  }
}
