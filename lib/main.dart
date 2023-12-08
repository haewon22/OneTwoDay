import 'package:flutter/material.dart';
import 'Firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Tools/Color/Colors.dart';
import 'Login/Tutorial.dart';
import 'Login/SignIn.dart';
import 'Login/SignUp.dart';
import 'Login/SignUpForm.dart';
import 'Login/ProfileForm.dart';
import 'Login/forgotPW.dart';
import 'AccountSettings.dart';
import 'ChangeEmail.dart';
import 'ChangePW.dart';
import 'CreateRoom.dart';
import 'EnterRoom.dart';
import 'HomeBody.dart';
import 'HomePage.dart';
import 'ChangeProfile.dart';

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
        '/signup': (BuildContext ctx) => SignUp(),
        '/signupform': (BuildContext ctx) => SignUpForm(),
        '/profileform': (BuildContext ctx) => ProfileForm(),
        '/forgotpw': (BuildContext ctx) => ForgotPW(),
        '/accountsettings': (BuildContext ctx) => AccountSettings(),
        '/changeemail': (BuildContext ctx) => ChangeEmail(),
        '/changepw': (BuildContext ctx) => ChangePW(),
        '/createroom': (BuildContext ctx) => CreateRoom(),
        '/enterroom': (BuildContext ctx) => EnterRoom(),
        '/homebody': (BuildContext ctx) => HomeBody(),
        '/homepage': (BuildContext ctx) => HomePage(),
        '/changeprofile': (BuildContext ctx) => ChangeProfile(),
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