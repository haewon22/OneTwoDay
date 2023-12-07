import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashBoard extends StatefulWidget {
  final String groupKey;
  DashBoard({required this.groupKey});
  
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var _index = 0;
  String groupName = "";

  double startX = 0.0;
  String direction = '';
  var gongji = ['오늘', '내', '세상이', '무너졌어', 'ㅎr..'];

  @override
  void initState() {
    db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          groupName = data['name'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    var MediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: groupName),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 5, 30, 30),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "최근공지",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  GestureDetector(
                    child: Text(
                      "더보기  >",
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed('/Myboard');
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print(gongji[_index]);
                //TODO:
                Navigator.of(context).pushNamed('/calendar');
              },
              onHorizontalDragStart: (DragStartDetails e) {
                startX = e.globalPosition.dx;
              },
              onHorizontalDragUpdate: (DragUpdateDetails e) {
                direction = e.globalPosition.dx > startX ? 'right' : 'left';
              },
              onHorizontalDragEnd: (DragEndDetails e) {
                setState(() {
                  if (direction == 'right') {
                    setState(() {
                      _index = (_index - 1) % 5;
                    });
                  } else if (direction == 'left') {
                    setState(() {
                      _index = (_index + 1) % 5;
                    });
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                padding: EdgeInsets.all(30),
                height: 200,
                width: MediaSize.width,
                child: Text(gongji[_index]),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey, 
                        blurRadius: 8, 
                        spreadRadius: -4
                      ),
                    ]),
              ),
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: _index == i ? MainColors.blue : Colors.grey,
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "나의 일정",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/calendar');
                      },
                      child: Image.asset(
                        'assets/images/calendar_icon.png',
                        height: 33,
                      ),
                    )
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 30),
              padding: EdgeInsets.all(30),
              height: 100,
              width: MediaSize.width,
              child: Text("달력자리"),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, 
                      blurRadius: 8, 
                      spreadRadius: -4
                    ),
                  ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/Mychatting');
              },
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "채팅",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(30),
                    height: 100,
                    width: MediaSize.width,
                    child: Text("최근 채팅 자리"),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 8,
                            spreadRadius: -4
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
