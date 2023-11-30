import '../Tools/Color/Colors.dart';
import './Login/Tutorial.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Stateful extends StatefulWidget{
  @override
  StatefulState createState() => StatefulState();
}

class StatefulState extends State<Stateful> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Stateful"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: MainColors.background,
                foregroundImage: NetworkImage(user?.photoURL ?? "https://firebasestorage.googleapis.com/v0/b/onetwoday-12d.appspot.com/o/profileImage%2Fdefault_profile.png?alt=media&token=43f4fbbd-6a2a-48e9-a9e9-dbce114cf4c9"),
                foregroundColor: MainColors.background,
                radius: 100,
              ),
              Text(user?.displayName ?? "Unknown"),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil('/signin', (route) => false);
                },
                child: Text("로그아웃")
              )
            ],
          ),
        )
      )
    );
  }
}