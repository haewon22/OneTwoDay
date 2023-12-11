import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onetwoday/DashBoard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupItem extends StatefulWidget {
  final String groupKey;
  final Map<String, dynamic> item;
  final Function() function;
  GroupItem({required this.groupKey, required this.item, required this.function});

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var MediaSize = MediaQuery.of(context).size;
    var width = MediaSize.width / 2;
    return GestureDetector(
      onTap: () async {
        final userData = {
          "open": DateTime.now().toString(),
        };
        await db.collection("user").doc(user!.uid).collection('group').doc(widget.groupKey).set(userData, SetOptions(merge: true));
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => DashBoard(groupKey: widget.groupKey))).then((_) {
          widget.function();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 8,
              spreadRadius: -4
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
        ),
        height: width - 100,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30)
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.item['groupURL']!),
                  fit: BoxFit.cover
                )
              ),
              height: width - 90,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              margin: EdgeInsets.all(5),
              child: Text(
                widget.item['name']!,
                style: TextStyle(
                  fontSize: 14.5,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
