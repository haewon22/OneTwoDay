import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:onetwoday/Mywriting.dart';

class Myboard extends StatefulWidget {
  @override
  MyboardState createState() => MyboardState();
}

class MyboardState extends State<Myboard> {
  int _counter = 0;
  double startX = 0;
  bool dragtoLeft = false;

  removeData(index) {
    notice.removeAt(index);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  final List<Map<String, dynamic>> notice = [
    {
      'icon': Icon(Icons.check_box_outlined, size: 40),
      'title': '[MT 날짜]',
      'writer': '김대현',
      'startday': '2023.10.14',
      'endday': '2023.10.17'
    },
    {
      'icon': Icon(Icons.check_box_outlined, size: 40),
      'title': '[회식 날짜]',
      'writer': '홍예선',
      'startday': '2023.10.11',
      'endday': '2023.10.13'
    },
    {
      'icon': Icon(Icons.article_outlined, size: 40),
      'title': '[학생회실 이용 규칙]',
      'writer': '김대현',
      'startday': '2023.10.10',
      'endday': null
    },
    {
      'icon': Icon(
        Icons.check_box_outlined,
        size: 40,
      ),
      'title': '[돕바 수요조사]',
      'writer': '이정민',
      'startday': '2023.10.01',
      'endday': '2023.10.03'
    },
    {
      'icon': Icon(Icons.check_box_outlined, size: 40),
      'title': '[가을 농활 가수요조사]',
      'writer': '홍예선',
      'startday': '2023.09.27',
      'endday': '2023.09.29'
    },
    {
      'icon': Icon(Icons.article_outlined, size: 40),
      'title': '[사물함 공지]',
      'writer': '김대현',
      'startday': '2023.09.23',
      'endday': null
    },
    {
      'icon': Icon(Icons.article_outlined, size: 40),
      'title': '[소모임 등록 심사 결과 공포]',
      'writer': '김대현',
      'startday': '2023.08.29',
      'endday': null
    },
    {
      'icon': Icon(Icons.article_outlined, size: 40),
      'title': '[AI의 밤 부스 운영 공지]',
      'writer': '홍예선',
      'startday': '2023.08.21',
      'endday': null
    },
    {
      'icon': Icon(Icons.check_box_outlined, size: 40),
      'title': '[우당탕탕 릴레이]',
      'writer': '김대현',
      'startday': '2023.08.04',
      'endday': '2023.08.10'
    }
  ];

//삭제 구현 필요함
  Widget listview_builder() {
    return ListView.builder(
        itemCount: notice.length,
        itemBuilder: (BuildContext context, int index) {
          dynamic icon = notice[index]['icon'];
          String title = notice[index]['title'];
          String writer = notice[index]['writer'];
          String startday = notice[index]['startday'];
          String? endday = notice[index]['endday'];
          if (endday != null) {
            return Slidable(
              endActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          removeData(index);
                        });
                      },
                      label: '삭제',
                      backgroundColor: Colors.red,
                    ),
                  ]),
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Mywriting()));
                },
                leading: icon,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(
                      writer + '  게시일 ' + startday + '  마감일 ' + endday,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Slidable(
              endActionPane: ActionPane(
                  extentRatio: 0.2,
                  motion: StretchMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          removeData(index);
                        });
                      },
                      label: '삭제',
                      backgroundColor: Colors.red,
                    ),
                  ]),
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Mywriting()));
                },
                leading: icon,
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(
                      writer + '  게시일 ' + startday,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.grey,
        title: Text(
          "공지",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: listview_builder(),
      floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.black,
          shape:
              CircleBorder()),
    );
  }
}
