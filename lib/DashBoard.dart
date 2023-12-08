import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Mychatting.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Calendar/Calendar.dart';

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

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

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
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: groupName),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30, 5, 30, 30),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "최근 공지",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
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
                margin: EdgeInsets.only(top: 10, bottom: 10),
                padding: EdgeInsets.all(25),
                height: 200,
                width: mediaSize.width,
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
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < 5; i++)
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: _index == i ? MainColors.blue : Colors.grey,
                    )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "그룹 일정",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                    ),
                    GestureDetector(
                      child: Text(
                        "더보기  >",
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar(groupKey: widget.groupKey)));
                      },
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: mediaSize.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: MainColors.blue)
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontFamily: 'NanumSquareRound'
                      ),
                      weekendTextStyle: TextStyle(
                        color: MainColors.blue,
                        fontFamily: 'NanumSquareRound'
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NanumSquareRound'
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'NanumSquareRound'
                      ),
                      rangeStartTextStyle: TextStyle(
                        fontFamily: 'NanumSquareRound'
                      ),
                      rangeEndTextStyle: TextStyle(
                        fontFamily: 'NanumSquareRound'
                      ),
                      outsideTextStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'NanumSquareRound'
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                    ),
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2029, 12, 31),
                    focusedDay: today,
                    calendarFormat: CalendarFormat.week,
                    daysOfWeekHeight: 40,
                    rowHeight: 40,
                    onDaySelected: _onDaySelected,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    headerVisible: false,
                  ),
                  Text("여기에 일정")
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, 
                    blurRadius: 8, 
                    spreadRadius: -4
                  ),
                ]
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Mychatting(groupKey: widget.groupKey)));
              },
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "채팅",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    padding: EdgeInsets.all(25),
                    width: mediaSize.width,
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
