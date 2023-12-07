import 'package:flutter/material.dart';
import 'Tools/Color/Colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:onetwoday/MyAppBar.dart';

class Mychatting extends StatefulWidget {
  @override
  MychattingState createState() => MychattingState();
}

class MychattingState extends State<Mychatting> {
  String groupName = 'AI학과 2023-2';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  final String me = 'minseung';
  final _textEditingController = TextEditingController(text: '');

  final List<Map<String, dynamic>> chatpeople = [
    {
      'name': 'minseung',
      'content': 'Hi haahahaha!',
      'date': DateTime.now().subtract(Duration(days: 2, hours: 8, minutes: 25)),
    },
    {
      'name': 'haewon',
      'content': 'too sleepy... sleep comes...',
      'date': DateTime.now().subtract(Duration(days: 2, hours: 2)),
    },
    {
      'name': 'wonseok',
      'content': 'What?!',
      'date': DateTime.now().subtract(Duration(days: 1, hours: 6, minutes: 45)),
    }
  ];

  List<Widget> chatContent() {
    List<Widget> a = [];
    for (int i = 0; i < chatpeople.length; i++) {
      var name = chatpeople[i]['name'];
      var content = chatpeople[i]['content'];
      var date = chatpeople[i]['date'];
      if (i == 0) {
        a.add(Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 12),
          padding: EdgeInsets.all(3),
          alignment: Alignment.center,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black26,
          ),
          child: Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));
      } else if (DateFormat('yyyy-MM-dd').format(date) !=
          DateFormat('yyyy-MM-dd').format(chatpeople[i - 1]['date'])) {
        a.add(Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 12),
          padding: EdgeInsets.all(3),
          alignment: Alignment.center,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black26,
          ),
          child: Text(
            DateFormat('yyyy-MM-dd').format(date),
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
        ));
      }
      if (name != me) {
        a.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                      child: Text(
                        content,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18)
                      ),
                    ),
                    Text(
                      DateFormat('a hh:mm', 'ko').format(date),
                      style: TextStyle(
                        fontSize: 12
                      )
                    ),
                  ],
                )
              ],
            )
          ],
        ));
      } else {
        a.add(Container(
          alignment: Alignment.topRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("나"),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('a hh:mm', 'ko').format(date),
                    style: TextStyle(
                      fontSize: 12
                    )
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 200),
                    margin: EdgeInsets.only(left: 5),
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 7),
                    child: Text(
                      content,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                    decoration: BoxDecoration(
                      color: MainColors.blue,
                      borderRadius: BorderRadius.circular(18)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
      }
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        appBar: AppBar(),
        title: groupName + ' 채팅방',
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(children: chatContent()),
              ),
            ),
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey),
              ),
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _textEditingController,
                onChanged: (String? val) {
                  _textEditingController.text = val!;
                },
                decoration: InputDecoration(
                    hintText: '내용을 입력해주세요',
                    suffix: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_upward, color: Colors.white),
                        onPressed: () {
                          if (_textEditingController.text.replaceAll('\n', '') !=
                              '') {
                            for (int i = 0;
                                i < _textEditingController.text.length;
                                i++) {
                              if (_textEditingController.text
                                      .replaceAll('\n', '')[i] !=
                                  ' ') {
                                DateTime dt = DateTime.now();
        
                                setState(() {
                                  chatpeople.add({
                                    'name': me,
                                    'content': _textEditingController.text,
                                    'date': dt
                                  });
                                  _textEditingController.clear();
                                });
                                break;
                              }
                            }
                          }
                        },
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
