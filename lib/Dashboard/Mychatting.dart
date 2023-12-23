import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Tools/Appbar/MyAppBar.dart';
import '../Tools/Color/Colors.dart';
import '../Tools/Loading/Loading.dart';
import '../Tools/Dialog/DialogForm.dart';
import 'package:lottie/lottie.dart';

class Mychatting extends StatefulWidget {
  final String groupKey;
  Mychatting({required this.groupKey});

  @override
  MychattingState createState() => MychattingState();
}

class MychattingState extends State<Mychatting> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String groupName = "";
  List<Widget> chattings = [];
  bool isLoaded = false;
  String message = "";

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    db.collection('group').doc(widget.groupKey).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          groupName = data['name'] + " 채팅방";
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
    db.collection("group").doc(widget.groupKey).collection("chat").snapshots().listen(
      (event) {
        updateChat();
      }
    );
    db.collection("user").doc(user!.uid).collection("group").doc(widget.groupKey).snapshots().listen(
      (event) {
        if (event.data() == null) Future.delayed(Duration.zero, () {
          if (mounted) DialogForm.dialogQuit(context);
        });
      }
    );
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  final _textEditingController = TextEditingController(text: '');
  String textContent = '';

  void updateChat() async {
    List<Widget> chat = [];
    String previousUid = "";
    String previousDate = "";
    await db.collection("group").doc(widget.groupKey).collection("chat").orderBy("date").get().then(
      (querySnapshot) async {
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
          if (previousDate == "") {
            chat.add(Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              alignment: Alignment.center,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black26,
              ),
              child: Text(
                DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(date)),
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ));
          } else if (DateFormat('yyyy-MM-dd').parse(date) != DateFormat('yyyy-MM-dd').parse(previousDate)) {
            chat.add(Container(
              margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              alignment: Alignment.center,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.black26,
              ),
              child: Text(
                DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(date)),
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ));
          }
          if (docSnapshot.data()['uid'] != user!.uid) {
            if (previousUid == docSnapshot.data()['uid'] && DateFormat('yyyy-MM-dd').format(DateTime.parse(previousDate)) == DateFormat('yyyy-MM-dd').format(DateTime.parse(date))) {
              chat.add(Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 230),
                          margin: EdgeInsets.only(top: 5, right: 5),
                          padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
                          child: Text(
                            content,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18)),
                        ),
                        Text(
                          DateFormat('a hh:mm', 'ko').format(DateTime.parse(date)),
                          style: TextStyle(fontSize: 12)
                        ),
                      ],
                    )
                  )
                ],
              ));
            } else {
              chat.add(Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: CircleAvatar(
                        radius: 20,
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
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: 230),
                                margin: EdgeInsets.only(top: 5, right: 5),
                                padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
                                child: Text(
                                  content,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18)),
                              ),
                              Text(
                                DateFormat('a hh:mm', 'ko').format(DateTime.parse(date)),
                                style: TextStyle(fontSize: 12)
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ));
            }
          } else {
            if (previousUid == docSnapshot.data()['uid']) {
              chat.add(Container(
                padding: EdgeInsets.only(top: 5),
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('a hh:mm', 'ko').format(DateTime.parse(date)),
                      style: TextStyle(fontSize: 12)
                    ),
                    GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: MainColors.background,
                              title: Column(
                                children: [
                                  Text(
                                    "채팅을 삭제할까요?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
                                    child: Text(
                                      content.replaceAll("\n", " "),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: MainColors.blue,
                                      borderRadius: BorderRadius.circular(18)
                                    ),
                                  ),
                                  Text(
                                    "채팅은 삭제 후 되돌릴 수 없어요",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
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
                                        await db.collection('group').doc(widget.groupKey).collection('chat').doc(docSnapshot.id).delete();
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
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 230),
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
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
                    ),
                  ],
                ),
              ));
            } else {
              chat.add(Container(
                padding: EdgeInsets.only(top: 5),
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('a hh:mm', 'ko').format(DateTime.parse(date)),
                      style: TextStyle(fontSize: 12)
                    ),
                    GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: MainColors.background,
                              title: Column(
                                children: [
                                  Text(
                                    "채팅을 삭제할까요?",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 200),
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
                                    child: Text(
                                      content.replaceAll("\n", " "),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: MainColors.blue,
                                      borderRadius: BorderRadius.circular(18)
                                    ),
                                  ),
                                  Text(
                                    "채팅은 삭제 후 되돌릴 수 없어요",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
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
                                        await db.collection('group').doc(widget.groupKey).collection('chat').doc(docSnapshot.id).delete();
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
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 230),
                        margin: EdgeInsets.only(left: 5, top: 10),
                        padding: EdgeInsets.fromLTRB(12, 5, 12, 7),
                        child: Text(
                          content,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: MainColors.blue,
                          borderRadius: BorderRadius.circular(18)
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }
          previousUid = docSnapshot.data()['uid'];
          previousDate = date;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    setState(() {
      chattings = chat;
      isLoaded = true;
      message = "아직 채팅이 없어요\n새로운 채팅을 시작해봐요";
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MyAppBar(
        appBar: AppBar(),
        title: groupName,
        groupS: false
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
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
                  reverse: true,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 90),
                  child: Column(
                    children: !isLoaded ? [Container(
                      alignment: Alignment.center,
                      width: mediaSize.width,
                      height: mediaSize.height - 250,
                      child: Lottie.asset(
                        'assets/lotties/loading.json',
                        frameRate: FrameRate.max,
                        width: 70,
                        height: 70
                      ),
                    )] : chattings.length != 0 ? chattings : [Container(
                      alignment: Alignment.center,
                      width: mediaSize.width,
                      height: mediaSize.height - 250,
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12
                        ),
                      ),
                    )]
                  )
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
                                db.collection("group").doc(widget.groupKey).collection("chat").add(data).then((_) {
                                  _textEditingController.clear();
                                });
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
