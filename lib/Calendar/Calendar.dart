import '../Tools/Color/Colors.dart';
import 'package:flutter/material.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget{
  String calKey;
  Calendar({required this.calKey});

  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "",
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(25, 5, 25, 5),
                child: Row(
                  children: [
                    Text(
                      widget.calKey == "my" ? "내 캘린더 " : "firebase",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: EdgeInsets.all(10),
                child: TableCalendar(
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
                    titleCentered: true,
                    leftChevronIcon: Icon(Icons.chevron_left, color: MainColors.blue),
                    rightChevronIcon: Icon(Icons.chevron_right, color: MainColors.blue),
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
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      spreadRadius: -4
                    )
                  ]
                ),
              ),
              Container(
                width: mediaSize.width,
                height: 500, // delete
                margin: EdgeInsets.fromLTRB(20, 5, 20, 20),
                padding: EdgeInsets.all(25),
                child: Text("여기에 일정들 표시, + 버튼"),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 8,
                      spreadRadius: -4
                    )
                  ]
                ),
              )
            ],
          ),
        )
      )
    );
  }
}