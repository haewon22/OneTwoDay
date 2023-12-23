import 'package:flutter/material.dart';
import '../../Home/Calendar/ChangeSchedule.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Home/Calendar/AddNewSchedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../Tools/Color/Colors.dart';

enum SampleItem { change, delete }

class Calendar extends StatefulWidget {
  String groupKey;
  Calendar({required this.groupKey});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  bool isAdmin = true;
  String groupName = "";
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
    updateShow();
  }
  
  List<Map<String, String>> schedule_show = [];
  
  Map<DateTime, List<String>> event = {};

  List<String> _getEventsForDay(DateTime day) {
    return event[day] ?? [];
  }

  List<PopupMenuItem<String>> groupPopup = [];

  @override
  void initState() {
    updateGroupName();
    updateAdmin();
    updateSchedule();
    updateShow();
    updateGroupPopup();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  void updateGroupPopup() {
    setState(() {
      groupPopup.add(PopupMenuItem<String>(
        value: "my",
        child: Center(
          child: Text(
            "내 캘린더",
            style: TextStyle(
              fontWeight: FontWeight.w600
            )
          ),
        ),
      ));
    });
    db.collection('user').doc(user!.uid).collection('group').orderBy("open", descending: true).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          db.collection('group').doc(docSnapshot.id).get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              setState(() {
                groupPopup.add(PopupMenuItem<String>(
                  value: docSnapshot.id,
                  child: Center(
                    child: Text(
                      data['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                ));
              });
            },
            onError: (e) => print("Error getting document: $e"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void updateGroupName() {
    if (widget.groupKey == "my") {
      setState(() {
        groupName = "내 캘린더";
      });
    } else {
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
  }

  void updateSchedule() async {
    List<Map<String, String>> schedules = [];
    Map<DateTime, List<String>> events = {};
    if (widget.groupKey == "my") {
      await db.collection('user').doc(user!.uid).collection('calendar').get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            schedules.add({
              "id": docSnapshot.id,
              "title": docSnapshot.data()['title'],
              "start": docSnapshot.data()['start'],
              "end": docSnapshot.data()['end'],
            });
            int start_year = int.parse(DateFormat('yyyy').format(DateTime.parse(docSnapshot.data()['start'])));
            int start_month = int.parse(DateFormat('MM').format(DateTime.parse(docSnapshot.data()['start'])));
            int start_day = int.parse(DateFormat('dd').format(DateTime.parse(docSnapshot.data()['start'])));
            int end_year = int.parse(DateFormat('yyyy').format(DateTime.parse(docSnapshot.data()['end'])));
            int end_month = int.parse(DateFormat('MM').format(DateTime.parse(docSnapshot.data()['end'])));
            int end_day = int.parse(DateFormat('dd').format(DateTime.parse(docSnapshot.data()['end'])));
            if (events[DateTime.utc(start_year,start_month,start_day)] == null) events[DateTime.utc(start_year,start_month,start_day)] = [docSnapshot.data()['title']];
            else events[DateTime.utc(start_year,start_month,start_day)]?.add(docSnapshot.data()['title']);
            if (events[DateTime.utc(end_year,end_month,end_day)] == null) events[DateTime.utc(end_year,end_month,end_day)] = [docSnapshot.data()['title']];
            else if (DateTime.utc(start_year,start_month,start_day) != DateTime.utc(end_year,end_month,end_day)) events[DateTime.utc(end_year,end_month,end_day)]?.add(docSnapshot.data()['title']);
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    } else {
      await db.collection('group').doc(widget.groupKey).collection('calendar').get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            schedules.add({
              "id": docSnapshot.id,
              "title": docSnapshot.data()['title'],
              "start": docSnapshot.data()['start'],
              "end": docSnapshot.data()['end'],
            });
            int start_year = int.parse(DateFormat('yyyy').format(DateTime.parse(docSnapshot.data()['start'])));
            int start_month = int.parse(DateFormat('MM').format(DateTime.parse(docSnapshot.data()['start'])));
            int start_day = int.parse(DateFormat('dd').format(DateTime.parse(docSnapshot.data()['start'])));
            int end_year = int.parse(DateFormat('yyyy').format(DateTime.parse(docSnapshot.data()['end'])));
            int end_month = int.parse(DateFormat('MM').format(DateTime.parse(docSnapshot.data()['end'])));
            int end_day = int.parse(DateFormat('dd').format(DateTime.parse(docSnapshot.data()['end'])));
            if (events[DateTime.utc(start_year,start_month,start_day)] == null) events[DateTime.utc(start_year,start_month,start_day)] = [docSnapshot.data()['title']];
            else events[DateTime.utc(start_year,start_month,start_day)]?.add(docSnapshot.data()['title']);
            if (events[DateTime.utc(end_year,end_month,end_day)] == null) events[DateTime.utc(end_year,end_month,end_day)] = [docSnapshot.data()['title']];
            else if (DateTime.utc(start_year,start_month,start_day) != DateTime.utc(end_year,end_month,end_day)) events[DateTime.utc(end_year,end_month,end_day)]?.add(docSnapshot.data()['title']);
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    setState(() {
      event = events;
    });
  }

  void updateShow() async {
    List<Map<String, String>> schedules = [];
    if (widget.groupKey == "my") {
      await db.collection('user').doc(user!.uid).collection('calendar').orderBy("start").get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            if (DateFormat('yyyy-MM-dd').parse(docSnapshot.data()['start']) == DateFormat('yyyy-MM-dd').parse(today.toString())
            || DateFormat('yyyy-MM-dd').parse(docSnapshot.data()['end']) == DateFormat('yyyy-MM-dd').parse(today.toString()))
            schedules.add({
              "id": docSnapshot.id,
              "title": docSnapshot.data()['title'],
              "start": docSnapshot.data()['start'],
              "end": docSnapshot.data()['end'],
            });
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    } else {
      await db.collection('group').doc(widget.groupKey).collection('calendar').orderBy("start").get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            if (DateFormat('yyyy-MM-dd').parse(docSnapshot.data()['start']) == DateFormat('yyyy-MM-dd').parse(today.toString())
            || DateFormat('yyyy-MM-dd').parse(docSnapshot.data()['end']) == DateFormat('yyyy-MM-dd').parse(today.toString()))
            schedules.add({
              "id": docSnapshot.id,
              "title": docSnapshot.data()['title'],
              "start": docSnapshot.data()['start'],
              "end": docSnapshot.data()['end'],
            });
          }
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
    setState(() {
      schedule_show = schedules;
    });
  }

  void updateAdmin() async {
    if (widget.groupKey != "my") await db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = data['isAdmin'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    else setState(() {
      isAdmin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: "", groupS: false),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Row(
                  children: [
                    Text(
                      groupName,
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    PopupMenuButton(
                      clipBehavior: Clip.hardEdge,
                      shadowColor: Colors.grey,
                      elevation: 5,
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      position: PopupMenuPosition.under,
                      splashRadius: 1,
                      tooltip: "",
                      constraints: BoxConstraints(
                        minWidth: 100, minHeight: 50,
                        maxHeight: 200
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      offset: Offset(0, 5),
                      icon: Icon(Icons.keyboard_arrow_down),
                      onSelected: (String id) {
                        setState(() {
                          if (id == "my") {
                            widget.groupKey = "my";
                            updateGroupName();
                            updateAdmin();
                            updateSchedule();
                            updateShow();
                          } else {
                            widget.groupKey = id;
                            updateGroupName();
                            updateAdmin();
                            updateSchedule();
                            updateShow();
                          }
                        });
                      },
                      itemBuilder: (context) => groupPopup
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                child: TableCalendar(
                  daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: MainColors.blue)),
                  calendarStyle: CalendarStyle(
                    markerSize: 5,
                    markerMargin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    markerDecoration: BoxDecoration(
                      color: MainColors.blue,
                      shape: BoxShape.circle
                    ),
                    defaultTextStyle: TextStyle(fontFamily: 'NanumSquareRound'),
                    weekendTextStyle: TextStyle(
                        color: MainColors.blue, fontFamily: 'NanumSquareRound'),
                    todayTextStyle: TextStyle(
                        color: Colors.white, fontFamily: 'NanumSquareRound'),
                    todayDecoration: BoxDecoration(
                      color: Color(0x804169e1),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                        color: Colors.white, fontFamily: 'NanumSquareRound'),
                    selectedDecoration: BoxDecoration(
                      color: MainColors.blue,
                      shape: BoxShape.circle,
                    ),
                    rangeStartTextStyle:
                        TextStyle(fontFamily: 'NanumSquareRound'),
                    rangeEndTextStyle:
                        TextStyle(fontFamily: 'NanumSquareRound'),
                    outsideTextStyle: TextStyle(
                        color: Colors.grey, fontFamily: 'NanumSquareRound'),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: MainColors.blue),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: MainColors.blue),
                  ),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2029, 12, 31),
                  focusedDay: today,
                  availableGestures: AvailableGestures.all,
                  calendarFormat: CalendarFormat.month,
                  daysOfWeekHeight: 60,
                  rowHeight: 60,
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  eventLoader: _getEventsForDay,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 8, spreadRadius: -4)
                  ]
                ),
              ),
              Container(
                width: mediaSize.width,
                margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: scheduleList()
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      spreadRadius: -4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> scheduleList() {
    List<Widget> schedules = [];
    for (int i = 0 ; i < schedule_show.length ; i++) {
      schedules.add(GestureDetector(
        onTap: () async {
          if (isAdmin) await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeSchedule(groupKey: widget.groupKey, ScheduleKey: schedule_show[i]["id"]!))).then((_) {
          updateSchedule();
          updateShow();
        });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: MainColors.blue,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 270,
                    child: Text(
                      '${schedule_show[i]["title"]}',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${DateFormat('MM월 dd일 ').format(DateTime.parse(schedule_show[i]["start"]!)) + DateFormat('a hh:mm', 'ko').format(DateTime.parse(schedule_show[i]["start"]!))} 시작 · ${DateFormat('MM월 dd일 ').format(DateTime.parse(schedule_show[i]["end"]!)) + DateFormat('a hh:mm', 'ko').format(DateTime.parse(schedule_show[i]["end"]!))} 마감',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 90, 90, 90),
                    ),
                  ),
                ],
              )
            ],
          )
        ),
      ));
    }
    if (isAdmin) schedules.add(GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewSchedule(groupKey: widget.groupKey,))).then((_) {
          updateSchedule();
          updateShow();
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: MainColors.blue,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    ));
    else if (schedule_show.isEmpty) schedules.add(Padding(
      padding: EdgeInsets.all(22),
      child: Text(
        "아직 공지가 없어요",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12
        ),
      ),
    ));
    return schedules;
  }
}