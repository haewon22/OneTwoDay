import 'package:flutter/material.dart';
import '../../Dashboard/Notice/ChangeNotice.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Myboard.dart';
import '../../Tools/Color/Colors.dart';
import 'package:lottie/lottie.dart';
import '../../Tools/Dialog/DialogForm.dart';

enum SampleItem { change, delete }

class Mywriting extends StatefulWidget {
  final String groupKey;
  final String noticeKey;
  Mywriting({required this.groupKey, required this.noticeKey});

  @override
  MywritingState createState() => MywritingState();
}

class MywritingState extends State<Mywriting> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final _textEditingController = TextEditingController(text: '');
  String textContent = '';
  SampleItem? selectedMenu;
  var offsetValue = 50.0;
  String message = "";
  bool isLoaded = false;
  bool isAdmin = false;

  Map<String, dynamic> notice = {'uid': "", 'title': "", 'name': "", 'content': "", 'date': "", 'start': "", 'end': ""};

  List<Widget> chat = [];

  void updateNotice() async {
    await db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).get().then(
      (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        String uid = data['uid'];
        String title = data['title'];
        String name = "";
        String content = data['content'];
        String date = DateFormat('yyyy.MM.dd').format(DateTime.parse(data['date']));
        String start = data['start'] == "" ? "" : DateFormat('yyyy.MM.dd hh:mm').format(DateTime.parse(data['start']));
        String end = data['end'] == "" ? "" : DateFormat('yyyy.MM.dd hh:mm').format(DateTime.parse(data['end']));
        await db.collection("user").doc(data['uid']).get().then(
          (DocumentSnapshot doc) {
            if (doc.data() == null) {
              setState(() {
                name = "탈퇴 계정";
              });
            } else {
              final data = doc.data() as Map<String, dynamic>;
              setState(() {
                name = data['name'];
              });
            }
          },
          onError: (e) => print("Error getting document: $e"),
        );
        setState(() {
          notice['uid'] = uid;
          notice['title'] = title;
          notice['name'] = name;
          notice['date'] = date;
          notice['content'] = content;
          notice['start'] = start;
          notice['end'] = end;
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void updateChat() async {
    List<Widget> chatUpdater = [];
    await db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).collection("chat").orderBy("date").get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          var name = "";
          var profileURL = "";
          var content = docSnapshot.data()['content'];
          var date = docSnapshot.data()['date'];
          if (DateFormat('yyyy-MM-dd').parse(date) == DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())) {
            setState(() {
              date = DateFormat('a hh:mm', 'ko').format(DateTime.parse(date));
            });
          } else {
            setState(() {
              date = DateFormat('MM월 dd일').format(DateTime.parse(date));
            });
          }
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
          chatUpdater.add(
            GestureDetector(
              onLongPress: () {
                if (user!.uid == docSnapshot.data()['uid'])
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: MainColors.background,
                      title: Column(
                        children: [
                          Text(
                            "댓글을 삭제할까요?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        ],
                      ),
                      content: Text(
                        "댓글은 삭제 후 되돌릴 수 없어요",
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
                                await db.collection('group').doc(widget.groupKey).collection('board').doc(widget.noticeKey).collection('chat').doc(docSnapshot.id).delete();
                                updateChat();
                                Navigator.of(context).pop();
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            foregroundImage: CachedNetworkImageProvider(profileURL),
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
                                name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              Container(
                                width: 230,
                                child: Text(content),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Color.fromARGB(255, 90, 90, 90),
                        fontSize: 10
                      )
                    ),
                  ],
                ),
              ),
            )
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      chat = chatUpdater;
      message = "아직 댓글이 없어요\n새로운 댓글을 달아보세요";
      isLoaded = true;
    });
  }

  @override
  void initState() {
    updateNotice();
    updateChat();
    db.collection('group').doc(widget.groupKey).collection('member').doc(user!.uid).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          isAdmin = data['isAdmin'];
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    db.collection("user").doc(user!.uid).collection("group").doc(widget.groupKey).snapshots().listen(
      (event) {
        if (event.data() == null) Future.delayed(Duration.zero, () {
          if (mounted) DialogForm.dialogQuit(context);
        });
      }
    );
  }

  bool reverse = false;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        appBar: AppBar(),
        groupS: false,
        title: ""
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            setState(() {
              reverse = false;
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  reverse: reverse,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 90),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5, bottom: 10),
                                  width: mediaSize.width - 100,
                                  child: Text(
                                    notice['title'],
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800
                                    ),
                                  ),
                                ),
                                Text(
                                  '   ' + notice['name'] + ' · ' + notice['date'],
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 90, 90, 90),
                                    fontSize: 12
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      notice['start'] == "" ? Container() : Text('   ' + notice['start'] + ' 시작',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 90, 90, 90),
                                          fontSize: 12
                                        ),
                                      ),
                                      notice['end'] == "" ? Container() : Text('   ' + notice['end'] + ' 마감',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 90, 90, 90),
                                          fontSize: 12
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isAdmin ? PopupMenuButton(
                            clipBehavior: Clip.hardEdge,
                            shadowColor: Colors.grey,
                            elevation: 5,
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            position: PopupMenuPosition.under,
                            splashRadius: 1,
                            tooltip: "",
                            constraints: BoxConstraints(
                              minWidth: 100, minHeight: 50
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            offset: Offset(-15, 5),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            ),
                            onSelected: (SampleItem item) {
                              setState(() {
                                selectedMenu = item;
                                if (selectedMenu == SampleItem.change) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotice(groupKey: widget.groupKey, noticeKey: widget.noticeKey))).then((_) {
                                    updateNotice();
                                  });
                                } else if (selectedMenu == SampleItem.delete) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: MainColors.background,
                                        title: Column(
                                          children: [
                                            Text(
                                              "게시글을 삭제할까요?",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            )
                                          ],
                                        ),
                                        content: Text(
                                          "게시글은 삭제 후 되돌릴 수 없어요",
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
                                                  await db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).delete();
                                                  int count = 0;
                                                  Navigator.of(context).popUntil((_) => count++ >= 2);
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
                                }
                              });
                            },
                            itemBuilder: (context) => notice['uid'] == user!.uid ? <PopupMenuEntry<SampleItem>>[
                              PopupMenuItem<SampleItem>(
                                value: SampleItem.change,
                                child: Center(
                                  child: Text(
                                    "수정하기",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ),
                              ),
                              PopupMenuItem<SampleItem>(
                                value: SampleItem.delete,
                                child: Center(
                                  child: Text(
                                    "삭제하기",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )
                            ] : <PopupMenuEntry<SampleItem>>[
                              PopupMenuItem<SampleItem>(
                                value: SampleItem.delete,
                                child: Center(
                                  child: Text(
                                    "삭제하기",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ) : Container()
                        ],
                      ),
                      Container(
                        width: mediaSize.width,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.symmetric(vertical: 23, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              spreadRadius: -4
                            )
                          ],
                        ),
                        child: Text(notice['content'])
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                        child: Text(
                          "댓글",
                          style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold
                          ),
                        )
                      ),
                      Column(
                        children: !isLoaded ? [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            width: mediaSize.width,
                            child: Lottie.asset(
                              'assets/lotties/loading.json',
                              frameRate: FrameRate.max,
                              width: 40,
                              height: 40
                            ),
                          )
                        ] : (chat.length != 0) ? chat : [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                alignment: Alignment.bottomCenter,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextFormField(
                      autofocus: false,
                      minLines: 1,
                      maxLines: 4,
                      cursorColor: Color(0xff585551),
                      keyboardType: TextInputType.multiline,
                      controller: _textEditingController,
                      onChanged: (String? val) {
                        setState(() {
                          textContent = _textEditingController.text;
                        });
                      },
                      onTap: () {
                        setState(() {
                          reverse = true;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '내용을 입력해주세요',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(12),
                      height: 37,
                      width: 37,
                      decoration: BoxDecoration(
                          color: MainColors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                        iconSize: 20,
                        splashRadius: 0.1,
                        icon: Icon(Icons.arrow_upward, color: Colors.white),
                        onPressed: () {
                          if (_textEditingController.text.replaceAll('\n', '') != '') {
                            for (int i = 0; i < _textEditingController.text.length; i++) {
                              if (_textEditingController.text.replaceAll('\n', '')[i] != ' ') {
                                String dt = DateTime.now().toString();
                                final data = {
                                  "uid": user!.uid,
                                  "content": textContent,
                                  "date": dt
                                };
                                db.collection("group").doc(widget.groupKey).collection("board").doc(widget.noticeKey).collection("chat").add(data).then((_) {
                                  _textEditingController.clear();
                                });
                                updateChat();
                                break;
                              }
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
