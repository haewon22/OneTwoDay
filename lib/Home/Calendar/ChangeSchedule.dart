import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import '../../Tools/Color/Colors.dart';

class ChangeSchedule extends StatefulWidget {
  String groupKey;
  final String ScheduleKey;
  ChangeSchedule({required this.groupKey, required this.ScheduleKey});

  @override
  State<ChangeSchedule> createState() => _ChangeScheduleState();
}

class _ChangeScheduleState extends State<ChangeSchedule> {
  TextEditingController textController = TextEditingController(text: "");

  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  String textValue = '';

  final List<String> startYear =
      List.generate(10, (index) => '${index + 2020}년');
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

  Map<String, dynamic> origin = {
    'title': "",
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

  @override
  void initState() {
    if (widget.groupKey == "my") {
      db.collection("user").doc(user!.uid).collection("calendar").doc(widget.ScheduleKey).get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            textValue = data['title'];
            textController = TextEditingController(text: data['title']);
          });
          String YMD = data['start'].split(' ')[0];
          String hms = data['start'].split(' ')[1].substring(0, data['start'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D = YMD.split('-');
          if (Y_M_D[1][0] == '0') Y_M_D[1] = Y_M_D[1][1];
          if (Y_M_D[2][0] == '0') Y_M_D[2] = Y_M_D[2][1];
          List<String> h_m_s = hms.split(':');
          if (h_m_s[0][0] == '0') h_m_s[0] = h_m_s[0][1];
          if (h_m_s[1][0] == '0') h_m_s[1] = h_m_s[1][1];
          setState(() {
            selectedYear = Y_M_D[0] + "년";
            selectedMonth = Y_M_D[1] + "월";
            selectedDay = Y_M_D[2] + "일";
            selectedHour = h_m_s[0] + "시";
            selectedMinute = h_m_s[1] + "분";
          });
          String YMD_e = data['end'].split(' ')[0];
          String hms_e = data['end'].split(' ')[1].substring(0, data['end'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D_e = YMD_e.split('-');
          if (Y_M_D_e[1][0] == '0') Y_M_D_e[1] = Y_M_D_e[1][1];
          if (Y_M_D_e[2][0] == '0') Y_M_D_e[2] = Y_M_D_e[2][1];
          List<String> h_m_s_e = hms_e.split(':');
          if (h_m_s_e[0][0] == '0') h_m_s_e[0] = h_m_s_e[0][1];
          if (h_m_s_e[1][0] == '0') h_m_s_e[1] = h_m_s_e[1][1];
          setState(() {
            selectedYear_e = Y_M_D_e[0] + "년";
            selectedMonth_e = Y_M_D_e[1] + "월";
            selectedDay_e = Y_M_D_e[2] + "일";
            selectedHour_e = h_m_s_e[0] + "시";
            selectedMinute_e = h_m_s_e[1] + "분";
          });
          setState(() {
            origin['title'] = data['title'];
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
    } else {
      db.collection("group").doc(widget.groupKey).collection("calendar").doc(widget.ScheduleKey).get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            textValue = data['title'];
            textController = TextEditingController(text: data['title']);
          });
          String YMD = data['start'].split(' ')[0];
          String hms = data['start'].split(' ')[1].substring(0, data['start'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D = YMD.split('-');
          if (Y_M_D[1][0] == '0') Y_M_D[1] = Y_M_D[1][1];
          if (Y_M_D[2][0] == '0') Y_M_D[2] = Y_M_D[2][1];
          List<String> h_m_s = hms.split(':');
          if (h_m_s[0][0] == '0') h_m_s[0] = h_m_s[0][1];
          if (h_m_s[1][0] == '0') h_m_s[1] = h_m_s[1][1];
          setState(() {
            selectedYear = Y_M_D[0] + "년";
            selectedMonth = Y_M_D[1] + "월";
            selectedDay = Y_M_D[2] + "일";
            selectedHour = h_m_s[0] + "시";
            selectedMinute = h_m_s[1] + "분";
          });
          String YMD_e = data['end'].split(' ')[0];
          String hms_e = data['end'].split(' ')[1].substring(0, data['end'].split(' ')[1].indexOf('.'));
          List<String> Y_M_D_e = YMD_e.split('-');
          if (Y_M_D_e[1][0] == '0') Y_M_D_e[1] = Y_M_D_e[1][1];
          if (Y_M_D_e[2][0] == '0') Y_M_D_e[2] = Y_M_D_e[2][1];
          List<String> h_m_s_e = hms_e.split(':');
          if (h_m_s_e[0][0] == '0') h_m_s_e[0] = h_m_s_e[0][1];
          if (h_m_s_e[1][0] == '0') h_m_s_e[1] = h_m_s_e[1][1];
          setState(() {
            selectedYear_e = Y_M_D_e[0] + "년";
            selectedMonth_e = Y_M_D_e[1] + "월";
            selectedDay_e = Y_M_D_e[2] + "일";
            selectedHour_e = h_m_s_e[0] + "시";
            selectedMinute_e = h_m_s_e[1] + "분";
          });
          setState(() {
            origin['title'] = data['title'];
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
        appBar: MyAppBar(appBar: AppBar(), title: '일정 수정', groupS: false),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextFormField(
                autofocus: false,
                minLines: 1,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MainColors.blue,
                          border: Border.all(color: MainColors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.5, left: 10, right: 10),
                          child: Text(
                            "시작일",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDropdownButton(startYear, selectedYear, '년',
                            (value) {
                          setState(() {
                            selectedYear = value;
                          });
                        }, true),
                        buildDropdownButton(startMonth, selectedMonth, '월',
                            (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        }, false),
                        buildDropdownButton(startDay, selectedDay, '일',
                            (value) {
                          setState(() {
                            selectedDay = value;
                          });
                        }, false),
                        buildDropdownButton(startHour, selectedHour, '시',
                            (value) {
                          setState(() {
                            selectedHour = value;
                          });
                        }, false),
                        buildDropdownButton(startMinute, selectedMinute, '분',
                            (value) {
                          setState(() {
                            selectedMinute = value;
                          });
                        }, false),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: MainColors.blue,
                          border: Border.all(color: MainColors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.5, left: 10, right: 10),
                          child: Text(
                            "마감일",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDropdownButton(endYear, selectedYear_e, '년',
                            (value) {
                          setState(() {
                            selectedYear_e = value;
                          });
                        }, true),
                        buildDropdownButton(endMonth, selectedMonth_e, '월',
                            (value) {
                          setState(() {
                            selectedMonth_e = value;
                          });
                        }, false),
                        buildDropdownButton(endDay, selectedDay_e, '일',
                            (value) {
                          setState(() {
                            selectedDay_e = value;
                          });
                        }, false),
                        buildDropdownButton(endHour, selectedHour_e, '시',
                            (value) {
                          setState(() {
                            selectedHour_e = value;
                          });
                        }, false),
                        buildDropdownButton(endMinute, selectedMinute_e, '분',
                            (value) {
                          setState(() {
                            selectedMinute_e = value;
                          });
                        }, false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!(
                      origin['title'] == textValue && 
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
                    )) {
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
                    'title': textValue,
                    'start': "${startYear}-${startMonth}-${startDay} ${startHour}:${startMinute}:00.000000",
                    'end': "${endYear}-${endMonth}-${endDay} ${endHour}:${endMinute}:00.000000",
                  };

                  if (widget.groupKey == "my") await db.collection("user").doc(user!.uid).collection("calendar").doc(widget.ScheduleKey).set(data, SetOptions(merge: true)).then((_) {
                    Navigator.of(context).pop();
                  });
                  else await db.collection("group").doc(widget.groupKey).collection("calendar").doc(widget.ScheduleKey).set(data, SetOptions(merge: true)).then((_) async {
                    await db.collection("group").doc(widget.groupKey).collection("member").get().then(
                      (querySnapshot) async {
                        for (var docSnapshot in querySnapshot.docs) {
                          await db.collection("user").doc(docSnapshot.id).collection("calendar").doc(widget.ScheduleKey).set(data, SetOptions(merge: true));
                        }
                      },
                      onError: (e) => print("Error completing: $e"),
                    );
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
                  color: !(
                      origin['title'] == textValue && 
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
                    ) ? MainColors.blue
                      : Colors.grey,
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: MainColors.background,
                      title: Column(
                        children: [
                          Text(
                            "일정을 삭제할까요?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      content: Text(
                        "일정은 삭제 후 되돌릴 수 없어요",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                margin: EdgeInsets.only(right: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(55)
                                ),
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                              )
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (widget.groupKey == "my") {
                                  await db.collection('user').doc(user!.uid).collection('calendar').doc(widget.ScheduleKey).delete().then(
                                    (doc) {
                                      int count = 0;
                                      Navigator.of(context).popUntil((_) => count++ >= 2);
                                    },
                                    onError: (e) => print("Error updating document $e"),
                                  );
                                } else {
                                  await db.collection('group').doc(widget.groupKey).collection('calendar').doc(widget.ScheduleKey).delete().then(
                                    (doc) async {
                                      await db.collection("group").doc(widget.groupKey).collection("member").get().then(
                                        (querySnapshot) async {
                                          for (var docSnapshot in querySnapshot.docs) {
                                            await db.collection("user").doc(docSnapshot.id).collection("calendar").doc(widget.ScheduleKey).delete().then((_) {},
                                              onError: (e) => print("Error updating document $e"),
                                            );
                                          }
                                        },
                                        onError: (e) => print("Error completing: $e"),
                                      );
                                      int count = 0;
                                      Navigator.of(context).popUntil((_) => count++ >= 2);
                                    },
                                    onError: (e) => print("Error updating document $e"),
                                  );
                                }
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                margin: EdgeInsets.only(left: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(55)
                                ),
                                child: Text(
                                  "삭제",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                              )
                            ),
                          ],
                        )
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)
                      ),
                    );
                  },
                );
              },
              child: Text(
                "일정 삭제",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDropdownButton(List<String> items, String? value, String hint,
      Function(String?) onChanged, bool isYear) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        iconStyleData: IconStyleData(
            icon: Icon(
          Icons.keyboard_arrow_down,
          size: 17,
        )),
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
