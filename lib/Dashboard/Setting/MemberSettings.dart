import 'package:flutter/material.dart';
import '../../Tools/Appbar/MyAppBar.dart';
import '../../Tools/Color/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Tools/Dialog/DialogForm.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Granted {
  String uid;
  String name;
  String profileURL;
  bool isGranted;
  Granted(this.uid, {this.name = "Unknown", this.profileURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9", this.isGranted = true});
}

class NGranted {
  String uid;
  String name;
  String profileURL;
  bool isGranted;
  NGranted(this.uid, {this.name = "Unknown", this.profileURL = "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9", this.isGranted = false});
}

class MemberSettings extends StatefulWidget {
  final String groupKey;
  MemberSettings({required this.groupKey});

  @override
  State<MemberSettings> createState() => _MemberSettingsState();
}

class _MemberSettingsState extends State<MemberSettings> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  final _textEditingController = TextEditingController();
  bool isSearch = true;
  bool isChecked = true;
  String textValue = '';
  bool isAdmin = false;

  List<Granted> _grant = [];
  List<NGranted> _ngrant = [];

  @override
  void initState() {
    updateAdmin();
    updateList();
    db.collection("user").doc(user!.uid).collection("group").doc(widget.groupKey).snapshots().listen(
      (event) {
        if (event.data() == null) Future.delayed(Duration.zero, () {
          if (mounted) DialogForm.dialogQuit(context);
        });
      }
    );
  }

  void updateList() async {
    List<Granted> grant = [];
    List<NGranted> ngrant = [];
    List<Granted> grant_search = [];
    List<NGranted> ngrant_search = [];
    await db.collection('group').doc(widget.groupKey).collection('member').get().then(
      (querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await db.collection('user').doc(docSnapshot.id).get().then(
            (DocumentSnapshot doc) {
              final data = doc.data() as Map<String, dynamic>;
              print(data);
              if (docSnapshot.data()['isAdmin']) {
                if (docSnapshot.id == user!.uid) grant.insert(0, Granted(docSnapshot.id, name: data['name'], profileURL: data['profileURL']));
                else grant.add(Granted(docSnapshot.id, name: data['name'], profileURL: data['profileURL']));
              }
              else {
                if (docSnapshot.id == user!.uid) ngrant.insert(0, NGranted(docSnapshot.id, name: data['name'], profileURL: data['profileURL']));
                else ngrant.add(NGranted(docSnapshot.id, name: data['name'], profileURL: data['profileURL']));
              }
            },
            onError: (e) => print("Error getting document: $e"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    bool isSearched = false;
    for (int i = 0; i < grant.length; i++) {
      if (grant[i].name.contains(textValue)) {
        setState(() {
          isSearched = true;
        });
        grant_search.add(grant[i]);
      }
    }
    for (int i = 0; i < ngrant.length; i++) {
      if (ngrant[i].name.contains(textValue)) {
        setState(() {
          isSearched = true;
        });
        ngrant_search.add(ngrant[i]);
      }
    }

    if (!isSearched) setState(() {
      _grant = grant;
      _ngrant = ngrant;
    });
    else setState(() {
      _grant = grant_search;
      _ngrant = ngrant_search;
    });
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

  Widget listview_builder(double width) {
    return ListView.builder(
      itemCount: _grant.length + _ngrant.length + 3,
      itemBuilder: (BuildContext context, int index) {
        if (index == _grant.length + _ngrant.length + 2) return SizedBox(height: 80);
        else if (index == 0) return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Text(
            "권한이 부여된 멤버",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        );
        else if (1 <= index && index <= _grant.length) return Container(
          child: Slidable(
            enabled: !(_grant[index-1].uid == user!.uid),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: MainColors.background,
                          title: Column(
                            children: [
                              Text(
                                "멤버를 삭제할까요?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                          content: Text(
                            "멤버는 삭제 후 되돌릴 수 없어요",
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
                                    await db.collection("group").doc(widget.groupKey).collection("member").doc(_grant[index-1].uid).delete();
                                    await db.collection("user").doc(_grant[index-1].uid).collection("group").doc(widget.groupKey).delete();
                                    await db.collection("group").doc(widget.groupKey).collection("calendar").get().then(
                                      (querySnapshot) async {
                                        for (var docSnapshot in querySnapshot.docs) {
                                          await db.collection("user").doc(_grant[index-1].uid).collection("calendar").doc(docSnapshot.id).delete().then((_) {},
                                            onError: (e) => print("Error updating document $e"),
                                          );
                                        }
                                      },
                                      onError: (e) => print("Error completing: $e"),
                                    );
                                    updateList();
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
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                ),
              ]
            ),
            child: ListTile(
              trailing: GestureDetector(
                onTap: () async {
                  int count = 0;
                  await db.collection("group").doc(widget.groupKey).collection("member").where("isAdmin", isEqualTo: true).get().then(
                    (querySnapshot) {
                      for (var docSnapshot in querySnapshot.docs) {
                        count++;
                      }
                    },
                    onError: (e) => print("Error completing: $e"),
                  );
                  if (count <= 1) {
                    DialogForm.dialogForm(
                      context, width,
                      "권한 해제를 할 수 없어요",
                      "그룹에는 한 명 이상의\n권한자가 있어야 해요"
                    );
                  }
                  else {
                    final data = { 'isAdmin': false };
                    await db.collection("group").doc(widget.groupKey).collection("member").doc(_grant[index-1].uid).set(data, SetOptions(merge: true));
                    updateList();
                  }
                },
                child: Icon(
                  Icons.arrow_downward,
                  color: MainColors.blue
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(_grant[index-1].profileURL),
                      child: LoadingAnimationWidget.beat(
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                    width: 230,
                    child: Text(
                      _grant[index-1].name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        else if (index == _grant.length + 1) return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          child: Text(
            "권한이 부여되지 않은 멤버",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        );
        else return Container(
          child: Slidable(
            enabled: !(_ngrant[index-_grant.length-2].uid == user!.uid),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: MainColors.background,
                          title: Column(
                            children: [
                              Text(
                                "멤버를 삭제할까요?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                          content: Text(
                            "멤버는 삭제 후 되돌릴 수 없어요",
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
                                    await db.collection("group").doc(widget.groupKey).collection("member").doc(_ngrant[index-_grant.length-2].uid).delete();
                                    await db.collection("user").doc(_ngrant[index-_grant.length-2].uid).collection("group").doc(widget.groupKey).delete();
                                    await db.collection("group").doc(widget.groupKey).collection("calendar").get().then(
                                      (querySnapshot) async {
                                        for (var docSnapshot in querySnapshot.docs) {
                                          await db.collection("user").doc(_ngrant[index-_grant.length-2].uid).collection("calendar").doc(docSnapshot.id).delete().then((_) {},
                                            onError: (e) => print("Error updating document $e"),
                                          );
                                        }
                                      },
                                      onError: (e) => print("Error completing: $e"),
                                    );
                                    updateList();
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
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                ),
              ]
            ),
            child: ListTile(
              trailing: GestureDetector(
                onTap: () async {
                  final data = { 'isAdmin': true };
                  await db.collection("group").doc(widget.groupKey).collection("member").doc(_ngrant[index-_grant.length-2].uid).set(data, SetOptions(merge: true));
                  updateList();
                },
                child: Icon(
                  Icons.arrow_upward,
                  color: MainColors.blue
                ),
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      foregroundImage: CachedNetworkImageProvider(_ngrant[index-_grant.length-2].profileURL),
                      child: LoadingAnimationWidget.beat(
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                    width: 230,
                    child: Text(
                      _ngrant[index-_grant.length-2].name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        appBar: AppBar(),
        title: "멤버 설정",
        groupS: false
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: SearchMember(context),
          ),
          Expanded(
            child: listview_builder(mediaSize.width),
          ),
        ],
      ),
      floatingActionButton: isAdmin ? FloatingActionButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.groupKey));
          DialogForm.dialogForm(
            context, mediaSize.width,
            "그룹 키가 복사되었어요",
            '그룹 키: "${widget.groupKey}"\n초대할 사람에게 공유하세요'
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: MainColors.blue,
        shape: CircleBorder()
      ) : Container()
    );
  }

  Widget SearchMember(BuildContext context) {
    if (isSearch) {
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxHeight: 50, maxWidth: MediaQuery.of(context).size.width - 50
        ),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          cursorColor: Color(0xff585551),
          controller: _textEditingController,
          decoration: InputDecoration(
            labelText: '멤버 검색',
            labelStyle: TextStyle(color: Colors.grey),
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
              textValue = _textEditingController.text;
            });
            updateList();
          }
        ),
      );
    }
    return Icon(Icons.search);
  }
}
