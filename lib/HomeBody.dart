import 'package:flutter/material.dart';
import 'package:onetwoday/Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onetwoday/GroupItem.dart';
import 'package:onetwoday/ProfileDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Calendar/Calendar.dart';

enum SampleItem { create, enter }

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => HomeBodyState();
}

class HomeBodyState extends State<HomeBody> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  SampleItem? selectedMenu;
  var offsetValue = 50.0;
  bool isSearch = false;
  String textValue = '';
  bool isLoaded = false;
  TextEditingController textController = TextEditingController();

  Map<String, dynamic> _groovyroom = {};

  List<Widget> gridItem() {
    Map<String, dynamic> _groovy = {};
    bool isSearched = false;

    for (var entry in _groovyroom.entries) {
      if (entry.value['name'].contains(textValue) && textValue.isNotEmpty) _groovy[entry.key] = entry.value;
    }
    if (_groovy.isEmpty) {
      _groovy = _groovyroom;
    }
    return _groovy.entries.map((e) => GroupItem(groupKey: e.key, item: e.value, function: refreshGrid)).toList();
  }

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    db.collection("user").doc(user!.uid).collection("group").snapshots().listen(
      (event) {
        refreshGrid();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
          padding: EdgeInsets.all(10),
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
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileDrawer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calendar(groupKey: "my")));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                        child: Image.asset(
                          'assets/images/calendar_icon.png',
                          height: 45,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 12, 0),
                        child: Text(
                          DateTime.now().day.toString(),
                          style: TextStyle(
                            color: MainColors.blue,
                            fontFamily: "NPSfont",
                            fontSize: 20
                          )
                        )
                      )
                    ],
                  )
                )
              ],
            ),
          )
        ),
        Container(
          height: 60,
          padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  '그룹',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ),
              GestureDetector(
                child: SearchGroup(context),
                onTap: () {
                  setState(() {
                    isSearch = !isSearch;
                    textValue = '';
                  });
                },
              ),
              PopupMenuButton(
                clipBehavior: Clip.hardEdge,
                shadowColor: Colors.grey,
                elevation: 5,
                color: Colors.white,
                position: PopupMenuPosition.under,
                splashRadius: 1,
                tooltip: "",
                constraints: BoxConstraints(minWidth: 120, minHeight: 100),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                offset: Offset(-15, 5),
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                    if (selectedMenu == SampleItem.create) {
                      Navigator.of(context).pushNamed('/createroom').then((_) {
                        refreshGrid();
                      });
                    } else if (selectedMenu == SampleItem.enter) {
                      Navigator.of(context).pushNamed('/enterroom').then((_) {
                        refreshGrid();
                      });
                    }
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.create,
                    child: Center(
                      child: Text(
                        "그룹 생성하기",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.enter,
                    child: Center(
                      child: Text(
                        "그룹 참가하기",
                        style: TextStyle(fontWeight: FontWeight.w600)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: !isLoaded ? Container() : _groovyroom.length != 0 ? CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                fillOverscroll: true,
                child: GridView.count(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: gridItem()
                ),
              ),
            ]
          ) : Container(
            padding: EdgeInsets.only(bottom: 100),
            alignment: Alignment.center,
            child: Text(
              "아직 추가한 그룹이 없어요\n+ 버튼을 눌러 그룹을 추가해봐요",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget SearchGroup(BuildContext context) {
    if (isSearch) {
      return Row(
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 5),
            constraints: BoxConstraints(
              maxHeight: 40,
              maxWidth: 220
            ),
            child: TextFormField(
              controller: textController,
              autofocus: true,
              autovalidateMode: AutovalidateMode.always,
              cursorColor: Color(0xff585551),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(55),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(55),
                ),
              ),
              onChanged: (String val) {
                setState(() {
                  textValue = textController.text;
                });
              }
            ),
          ),
          Icon(Icons.close)
        ],
      );
    }
    return Icon(Icons.search);
  }

  void refreshGrid() async {
    Map<String, dynamic> _groovy = {};
    await db.collection("user").doc(user!.uid).collection("group").orderBy("open", descending: true).get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await db.collection("group").doc(docSnapshot.id).get().then(
            (DocumentSnapshot doc) async {
              final data = doc.data() as Map<String, dynamic>;
              setState(() {
                _groovy[docSnapshot.id] = data;
              });
            },
            onError: (e) => print("Error getting document: $e"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      _groovyroom = _groovy;
      isLoaded = true;
    });
  }
}
