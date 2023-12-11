import 'package:flutter/material.dart';
import 'Firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Tools/Color/Colors.dart';
import 'Login/Tutorial.dart';
import 'Login/SignIn.dart';
import 'Login/forgotPW.dart';
import 'Login/SignUp.dart';
import 'Login/SignUpForm.dart';
import 'Login/ProfileForm.dart';
import 'HomePage.dart';
import 'AccountSettings.dart';
import 'ChangeEmail.dart';
import 'ChangePW.dart';
import 'ChangeProfile.dart';
import 'DeleteAccount.dart';
import 'CreateRoom.dart';
import 'EnterRoom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneTwoDay',
      initialRoute: isSignIn() ? '/homepage' : '/tutorial',
      routes: <String, WidgetBuilder>{
        '/tutorial': (BuildContext ctx) => Tutorial(),
        '/signin': (BuildContext ctx) => SignIn(),
        '/forgotpw': (BuildContext ctx) => ForgotPW(),
        '/signup': (BuildContext ctx) => SignUp(),
        '/signupform': (BuildContext ctx) => SignUpForm(),
        '/profileform': (BuildContext ctx) => ProfileForm(),
        '/homepage': (BuildContext ctx) => HomePage(),
        '/accountsettings': (BuildContext ctx) => AccountSettings(),
        '/changeemail': (BuildContext ctx) => ChangeEmail(),
        '/changepw': (BuildContext ctx) => ChangePW(),
        '/changeprofile': (BuildContext ctx) => ChangeProfile(),
        '/deleteaccount': (BuildContext ctx) => DeleteAccount(),
        '/createroom': (BuildContext ctx) => CreateRoom(),
        '/enterroom': (BuildContext ctx) => EnterRoom(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: MainColors.background,
      ),
    );
  }

  bool isSignIn() {
    final user = FirebaseAuth.instance.currentUser;
    return (user == null) ? false : true;
  }
}