import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:onetwoday/Mychatting.dart';
import 'package:onetwoday/Mywriting.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'Calendar/Calendar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'Myboard.dart';
import 'package:onetwoday/AddNewNotice.dart';

class DashBoard extends StatefulWidget {
  final String groupKey;
  DashBoard({required this.groupKey});
  
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  var maxIndex = 0;
  var _index = 0;
  String groupName = "";
  String message = "";
  String noticeMessage = "";
  bool isAdmin = false;
  bool isNoticeLoad = false;
  bool isChatLoad = false;

  double startX = 0.0;
  String direction = '';

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void initState() {
    updateGroup();
    updateNotice();
    db.collection("group").doc(widget.groupKey).collection("chat").snapshots().listen(
      (event) {
        updateChat();
      }
    );
  }

  void updateGroup() {
    updateName();
    updateAdmin();
  }

  void updateName() async {
    await db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          groupName = data['name'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
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

  List<Map<String, String>> gongji = [];

  void updateNotice() async {
    List<Map<String, String>> gongjiUpdater = [];
    await db.collection("group").doc(widget.groupKey).collection("board").orderBy("date", descending: true).limit(5).get().then(
      (querySnapshot) async {
        setState(() {
          maxIndex = querySnapshot.docs.length;
        });
        for (var docSnapshot in querySnapshot.docs) {
          setState(() {
            gongjiUpdater.add({
              'uid': docSnapshot.id,
              'title': docSnapshot.data()['title'],
              'content': docSnapshot.data()['content']
            });
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      gongji = gongjiUpdater;
      isNoticeLoad = true;
      noticeMessage = "아직 게시글이 없어요";
    });
  }

  Map<String, String> recentChat = {'name': "", 'profileURL': "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Ftransparent.png?alt=media&token=8f6724fb-0983-480d-bf95-ec3a1bf7a503", 'content': "", 'date': ""};

  void updateChat() async {
    await db.collection("group").doc(widget.groupKey).collection("chat").orderBy("date", descending: true).limit(1).get().then(
      (querySnapshot) async {
        if (querySnapshot.docs.length == 0) {
          setState(() {
            recentChat['name'] = "";
          });
        }
        for (var docSnapshot in querySnapshot.docs) {
          String name = "";
          String profileURL = "";
          String content = docSnapshot.data()['content'];
          String date = docSnapshot.data()['date'];
          await db.collection("user").doc(docSnapshot.data()['uid']).get().then(
            (DocumentSnapshot doc) {
              if (doc.data() == null) {
                setState(() {
                  name = "탈퇴 계정";
                  profileURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9";
                });
              } else {
                final data = doc.data() as Map<String, dynamic>;
                setState(() {
                  name = data['name'];
                  profileURL = data['profileURL'];
                });
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
          if (DateFormat('yyyy-MM-dd').parse(date) == DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())) {
            setState(() {
              date = DateFormat('a hh:mm', 'ko').format(DateTime.parse(date));
            });
          } else {
            setState(() {
              date = DateFormat('MM월 dd일').format(DateTime.parse(date));
            });
          }
          setState(() {
            recentChat['name'] = name;
            recentChat['profileURL'] = profileURL;
            recentChat['content'] = content.replaceAll("\n", " ");
            recentChat['date'] = date;
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      isChatLoad = true;
      message = "아직 채팅이 없어요\n새로운 채팅을 시작해봐요";
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(appBar: AppBar(), title: groupName, groupS: true, groupKey: widget.groupKey, function: updateGroup),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "최근 게시판",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                    ),
                    GestureDetector(
                      child: Text(
                        "더보기  >",
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Myboard(groupKey: widget.groupKey)
                        )).then((_) {
                          updateNotice();
                        });
                      },
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (maxIndex != 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Mywriting(groupKey: widget.groupKey, noticeKey: gongji[_index]['uid']!))).then((_) {
                      updateNotice();
                    });
                  }
                },
                onHorizontalDragStart: (DragStartDetails e) {
                  startX = e.globalPosition.dx;
                },
                onHorizontalDragUpdate: (DragUpdateDetails e) {
                  direction = e.globalPosition.dx > startX ? 'right' : 'left';
                },
                onHorizontalDragEnd: (DragEndDetails e) {
                  setState(() {
                    if (maxIndex != 0) {
                      if (direction == 'right') {
                        setState(() {
                          _index = (_index - 1) % maxIndex;
                        });
                      } else if (direction == 'left') {
                        setState(() {
                          _index = (_index + 1) % maxIndex;
                        });
                      }
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  height: 200,
                  width: mediaSize.width,
                  child: isNoticeLoad ? maxIndex != 0 ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gongji[_index]['title']!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 7),
                        child: Text(
                          gongji[_index]['content']!,
                          overflow: TextOverflow.fade,
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ) : Container(
                    margin: EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          noticeMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                          ),
                        ),
                        isAdmin ? Column(
                          children: [
                            Text(
                              "새로운 게시글을 추가해봐요",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewNotice(groupKey: widget.groupKey))).then((_) {
                                    updateNotice();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: MainColors.blue,
                                  child: Icon(Icons.add, color: Colors.white)
                                ),
                              ),
                            ),
                          ],
                        ) : Container()
                      ],
                    ),
                  ) : Container(),
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
                width: (20 * maxIndex).toDouble(),
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < maxIndex; i++)
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
                  ]
                ),
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
                          fontSize: 12,
                          fontFamily: 'NanumSquareRound'
                        ),
                        weekendTextStyle: TextStyle(
                          fontSize: 12,
                          color: MainColors.blue,
                          fontFamily: 'NanumSquareRound'
                        ),
                        todayTextStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'NanumSquareRound'
                        ),
                        todayDecoration: BoxDecoration(
                          color: Color(0x804169e1),
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: 'NanumSquareRound'
                        ),
                        selectedDecoration: BoxDecoration(
                          color: MainColors.blue,
                          shape: BoxShape.circle,
                        ),
                        rangeStartTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'NanumSquareRound'
                        ),
                        rangeEndTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'NanumSquareRound'
                        ),
                        outsideTextStyle: TextStyle(
                          fontSize: 12,
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Mychatting(groupKey: widget.groupKey))).then((_) {
                    updateChat();
                  });
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      width: mediaSize.width,
                      height: 75,
                      child: isChatLoad ? recentChat['name'] != "" ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(2),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  foregroundImage: CachedNetworkImageProvider(recentChat['profileURL']!),
                                  child: LoadingAnimationWidget.beat(
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recentChat['name']!,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    Container(
                                      width: 170,
                                      child: Text(
                                        recentChat['content']!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Text(
                            recentChat['date']!,
                            style: TextStyle(fontSize: 12)
                          ),
                        ],
                      ) : Container(
                        alignment: Alignment.center,
                        width: mediaSize.width,
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                          ),
                        ),
                      ) : Container(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
