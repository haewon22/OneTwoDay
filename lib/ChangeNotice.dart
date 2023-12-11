import 'dart:ffi';
import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onetwoday/MyAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Tools/Color/Colors.dart';

class ChangeNotice extends StatefulWidget {
  final String groupKey;
  final String noticeKey;
  ChangeNotice({required this.groupKey, required this.noticeKey});

  @override
  State<ChangeNotice> createState() => _ChangeNoticeState();
}

class _ChangeNoticeState extends State<ChangeNotice> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String textValue = '';
  String textValueForContent = '';
  
  bool isStartD = false;
  bool isDueD = false;

  Map<String, dynamic> origin = {
    'title': "",
    'content': "",
    'isStartD': false,
    'isDueD': false,
    'selectedYear': "",
    'selectedMonth': "",
    'selectedDay': "",
    'selectedHour': "",
    'selectedMinute': "",
    'selectedYear_e': "",
    'selectedMonth_e': "",
    'selectedDay_e': "",
    'selectedHour_e': "",
    'selectedMinute_e': "",
  };

  TextEditingController textController = TextEditingController(text: "");
  TextEditingController textControllerForContent = TextEditingController(text: "");
  final List<String> startYear = List.generate(10, (index) => '${index + 2020}년');
  final List<String> startMonth = List.generate(12, (index) => '${index + 1}월');
  final List<String> startDay = List.generate(31, (index) => '${index + 1}일');
  final List<String> startHour = List.generate(24, (index) => '${index}시');
  final List<String> startMinute = List.generate(60, (index) => '${index}분');
  final List<String> endYear = List.generate(10, (index) => '${index + 2020}년');
  final List<String> endMonth = List.generate(12, (index) => '${index + 1}월');
  final List<String> endDay = List.generate(31, (index) => '${index + 1}일');
  final List<String> endHour = List.generate(24, (index) => '${index}시');
  final List<String> endMinute = List.generate(60, (index) => '${index}분');

  String? selectedYear = DateTime.now().year.toString() + "년";
  String? selectedMonth = DateTime.now().month.toString() + "월";
  String? selectedDay = DateTime.now().day.toString() + "일";
  String? selectedHour = "0시";
  String? selectedMinute = "0분";
  String? selectedYear_e = DateTime.now().year.toString() + "년";
  String? selectedMonth_e = DateTime.now().month.toString() + "월";
  String? selectedDay_e = DateTime.now().day.toString() + "일";
  String? selectedHour_e = "0시";
  String? selectedMinute_e = "0분";

  @override
  void initState() {
    db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          textValue = data['title'];
          textValueForContent = data['content'];
          textController = TextEditingController(text: data['title']);
          textControllerForContent = TextEditingController(text: data['content']);
        });
        if (data['start'] != "") {
          String YMD = data['start'].split(' ')[0];
          String hms = data['start'].split(' ')[1].substring(0, data['start'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D = YMD.split('-');
          if (Y_M_D[1][0] == '0') Y_M_D[1] = Y_M_D[1][1];
          if (Y_M_D[2][0] == '0') Y_M_D[2] = Y_M_D[2][1];
          List<String> h_m_s = hms.split(':');
          if (h_m_s[0][0] == '0') h_m_s[0] = h_m_s[0][1];
          if (h_m_s[1][0] == '0') h_m_s[1] = h_m_s[1][1];
          setState(() {
            isStartD = true;
            origin['isStartD'] = true;
            selectedYear = Y_M_D[0] + "년";
            selectedMonth = Y_M_D[1] + "월";
            selectedDay = Y_M_D[2] + "일";
            selectedHour = h_m_s[0] + "시";
            selectedMinute = h_m_s[1] + "분";
          });
        }
        if (data['end'] != "") {
          String YMD = data['end'].split(' ')[0];
          String hms = data['end'].split(' ')[1].substring(0, data['end'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D = YMD.split('-');
          if (Y_M_D[1][0] == '0') Y_M_D[1] = Y_M_D[1][1];
          if (Y_M_D[2][0] == '0') Y_M_D[2] = Y_M_D[2][1];
          List<String> h_m_s = hms.split(':');
          if (h_m_s[0][0] == '0') h_m_s[0] = h_m_s[0][1];
          if (h_m_s[1][0] == '0') h_m_s[1] = h_m_s[1][1];
          setState(() {
            isDueD = true;
            origin['isDueD'] = true;
            selectedYear_e = Y_M_D[0] + "년";
            selectedMonth_e = Y_M_D[1] + "월";
            selectedDay_e = Y_M_D[2] + "일";
            selectedHour_e = h_m_s[0] + "시";
            selectedMinute_e = h_m_s[1] + "분";
          });
        }
        setState(() {
          origin['title'] = data['title'];
          origin['content'] = data['content'];
          origin['selectedYear'] = selectedYear;
          origin['selectedMonth'] = selectedMonth;
          origin['selectedDay'] = selectedDay;
          origin['selectedHour'] = selectedHour;
          origin['selectedMinute'] = selectedMinute;
          origin['selectedYear_e'] = selectedYear_e;
          origin['selectedMonth_e'] = selectedMonth_e;
          origin['selectedDay_e'] = selectedDay_e;
          origin['selectedHour_e'] = selectedHour_e;
          origin['selectedMinute_e'] = selectedMinute_e;
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(appBar: AppBar(), title: '게시글 수정', groupS: false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  autofocus: false,
                  minLines: 1,
                  maxLines: 2,
                  cursorColor: Color(0xff585551),
                  keyboardType: TextInputType.multiline,
                  controller: textController,
                  onChanged: (String? val) {
                    setState(() {
                      textValue = textController.text;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '제목',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: TextFormField(
                  autofocus: false,
                  minLines: 1,
                  maxLines: 10,
                  cursorColor: Color(0xff585551),
                  keyboardType: TextInputType.multiline,
                  controller: textControllerForContent,
                  onChanged: (String? val) {
                    setState(() {
                      textValueForContent = textControllerForContent.text;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '내용을 입력해주세요',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isStartD = !isStartD;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isStartD ? MainColors.blue : Colors.transparent,
                              border: Border.all(color: MainColors.blue),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  isStartD ? Icons.remove : Icons.add,
                                  size: 20,
                                  color: isStartD ? Colors.white : MainColors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.5, right: 5),
                                  child: Text(
                                    isStartD ? "시작일 삭제" : "시작일 추가",
                                    style: TextStyle(
                                      color: isStartD ? Colors.white : MainColors.blue,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isStartD ? Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDropdownButton(
                            startYear, selectedYear, '년', (value) {
                            setState(() {
                              selectedYear = value;
                            });
                          }, true),
                          buildDropdownButton(
                            startMonth, selectedMonth, '월', (value) {
                            setState(() {
                              selectedMonth = value;
                            });
                          }, false),
                          buildDropdownButton(
                            startDay, selectedDay, '일', (value) {
                            setState(() {
                              selectedDay = value;
                            });
                          }, false),
                          buildDropdownButton(
                            startHour, selectedHour, '시', (value) {
                            setState(() {
                              selectedHour = value;
                            });
                          }, false),
                          buildDropdownButton(
                            startMinute, selectedMinute, '분', (value) {
                            setState(() {
                              selectedMinute = value;
                            });
                          }, false),
                        ],
                      ),
                    ) : Container(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDueD = !isDueD;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDueD ? MainColors.blue : Colors.transparent,
                              border: Border.all(color: MainColors.blue),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  isDueD ? Icons.remove : Icons.add,
                                  size: 20,
                                  color: isDueD ? Colors.white : MainColors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 1.5, right: 5),
                                  child: Text(
                                    isDueD ? "마감일 삭제" : "마감일 추가",
                                    style: TextStyle(
                                      color: isDueD ? Colors.white : MainColors.blue,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    isDueD ? Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDropdownButton(
                            endYear, selectedYear_e, '년', (value) {
                            setState(() {
                              selectedYear_e = value;
                            });
                          }, true),
                          buildDropdownButton(
                            endMonth, selectedMonth_e, '월', (value) {
                            setState(() {
                              selectedMonth_e = value;
                            });
                          }, false),
                          buildDropdownButton(
                            endDay, selectedDay_e, '일', (value) {
                            setState(() {
                              selectedDay_e = value;
                            });
                          }, false),
                          buildDropdownButton(
                            endHour, selectedHour_e, '시', (value) {
                            setState(() {
                              selectedHour_e = value;
                            });
                          }, false),
                          buildDropdownButton(
                            endMinute, selectedMinute_e, '분', (value) {
                            setState(() {
                              selectedMinute_e = value;
                            });
                          }, false),
                        ],
                      ),
                    ) : Container()
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (textValueForContent.isNotEmpty && textValue.isNotEmpty) {
                    String startYear = selectedYear!.substring(0, selectedYear!.indexOf('년'));
                    String startMonth = '0' + selectedMonth!.substring(0, selectedMonth!.indexOf('월'));
                    startMonth = startMonth.substring(startMonth.length - 2, startMonth.length);
                    String startDay = '0' + selectedDay!.substring(0, selectedDay!.indexOf('일'));
                    startDay = startDay.substring(startDay.length - 2, startDay.length);
                    String startHour = '0' + selectedHour!.substring(0, selectedHour!.indexOf('시'));
                    startHour = startHour.substring(startHour.length - 2, startHour.length);
                    String startMinute = '0' + selectedMinute!.substring(0, selectedMinute!.indexOf('분'));
                    startMinute = startMinute.substring(startMinute.length - 2, startMinute.length);

                    String endYear = selectedYear_e!.substring(0, selectedYear_e!.indexOf('년'));
                    String endMonth = '0' + selectedMonth_e!.substring(0, selectedMonth_e!.indexOf('월'));
                    endMonth = endMonth.substring(endMonth.length - 2, endMonth.length);
                    String endDay = '0' + selectedDay_e!.substring(0, selectedDay_e!.indexOf('일'));
                    endDay = endDay.substring(endDay.length - 2, endDay.length);
                    String endHour = '0' + selectedHour_e!.substring(0, selectedHour_e!.indexOf('시'));
                    endHour = endHour.substring(endHour.length - 2, endHour.length);
                    String endMinute = '0' + selectedMinute_e!.substring(0, selectedMinute_e!.indexOf('분'));
                    endMinute = endMinute.substring(endMinute.length - 2, endMinute.length);

                    final data = {
                      'uid': user!.uid,
                      'title': textValue.replaceAll("\n", " "),
                      'content': textValueForContent,
                      'date': DateTime.now().toString(),
                      'start': isStartD ? "${startYear}-${startMonth}-${startDay} ${startHour}:${startMinute}:00.000000" : "",
                      'end': isDueD ? "${endYear}-${endMonth}-${endDay} ${endHour}:${endMinute}:00.000000" : "",
                    };
                    await db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).set(data, SetOptions(merge: true)).then((_) {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 30),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
// Map<String, dynamic> origin = {
//   'title': "",
//   'content': "",
//   'isStartD': false,
//   'isDueD': false,
//   'selectedYear': "",
//   'selectedMonth': "",
//   'selectedDay': "",
//   'selectedHour': "",
//   'selectedMinute': "",
//   'selectedYear_e': "",
//   'selectedMonth_e': "",
//   'selectedDay_e': "",
//   'selectedHour_e': "",
//   'selectedMinute_e': "",
// };
                    color: !(
                      origin['title'] == textValue && 
                      origin['content'] == textValueForContent && 
                      origin['isStartD'] == isStartD &&
                      origin['isDueD'] == isDueD &&
                      origin['selectedYear'] == selectedYear &&
                      origin['selectedMonth'] == selectedMonth &&
                      origin['selectedDay'] == selectedDay &&
                      origin['selectedHour'] == selectedHour &&
                      origin['selectedMinute'] == selectedMinute &&
                      origin['selectedYear_e'] == selectedYear_e &&
                      origin['selectedMonth_e'] == selectedMonth_e &&
                      origin['selectedDay_e'] == selectedDay_e &&
                      origin['selectedHour_e'] == selectedHour_e &&
                      origin['selectedMinute_e'] == selectedMinute_e
                    ) ? MainColors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(55),
                  ),
                  child: Text(
                    "수정",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdownButton(List<String> items, String? value, String hint, Function(String?) onChanged, bool isYear) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 17,
          )
        ),
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        value: value,
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )).toList(),
        menuItemStyleData: const MenuItemStyleData(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 15),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 150,
          width: isYear ? 75 : 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          offset: const Offset(0, 0),
        ),
        buttonStyleData: ButtonStyleData(
          height: 40,
          width: isYear ? 75 : 60,
          padding: EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
