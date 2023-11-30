import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Firebase/firebase_options.dart';
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
import 'GridViewCount.dart';
import 'HomeBody.dart';
import 'HomeGridview.dart';
import 'HomePage.dart';
import 'ProfileDrawer.dart';
import 'test.dart';
import 'Stateful.dart';

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
        '/stateful': (BuildContext ctx) => Stateful(),
        '/accountsettings': (BuildContext ctx) => AccountSettings(),
        '/changeemail': (BuildContext ctx) => ChangeEmail(),
        '/changepw': (BuildContext ctx) => ChangePW(),
        '/createroom': (BuildContext ctx) => CreateRoom(),
        '/enterroom': (BuildContext ctx) => EnterRoom(),
        '/gridviewcount': (BuildContext ctx) => GridViewCount(),
        '/homebody': (BuildContext ctx) => HomeBody(),
        '/homegridview': (BuildContext ctx) => HomeGridView(),
        '/homepage': (BuildContext ctx) => HomePage(),
        '/profiledrawer': (BuildContext ctx) => ProfileDrawer(),
        '/test': (BuildContext ctx) => test(),
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
    print(user);
    return (user == null) ? false : true;
  }
}