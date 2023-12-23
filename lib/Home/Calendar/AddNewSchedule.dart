import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import '../../Tools/Color/Colors.dart';

class AddNewSchedule extends StatefulWidget {
  String groupKey;
  AddNewSchedule({required this.groupKey});

  @override
  State<AddNewSchedule> createState() => _AddNewScheduleState();
}

class _AddNewScheduleState extends State<AddNewSchedule> {
  TextEditingController textController = TextEditingController();

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
        appBar: MyAppBar(appBar: AppBar(), title: '일정 추가', groupS: false),
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
                if (textValue.isNotEmpty) {
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

                  if (widget.groupKey == "my") await db.collection("user").doc(user!.uid).collection("calendar").add(data).then((_) {
                    Navigator.of(context).pop();
                  });
                  else await db.collection("group").doc(widget.groupKey).collection("calendar").add(data).then((documentSnapshot) async {
                    await db.collection("group").doc(widget.groupKey).collection("member").get().then(
                      (querySnapshot) async {
                        for (var docSnapshot in querySnapshot.docs) {
                          await db.collection("user").doc(docSnapshot.id).collection("calendar").doc(documentSnapshot.id).set(data, SetOptions(merge: true));
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
                  color: textController.text.isNotEmpty
                      ? MainColors.blue
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(55),
                ),
                child: Text(
                  "추가",
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
