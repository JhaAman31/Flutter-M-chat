import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_chat/Screens/complete_profile_screen.dart';
import 'package:m_chat/Screens/home_screen.dart';
import 'package:m_chat/Screens/login_screen.dart';
import 'package:m_chat/Screens/splash_screen.dart';
import 'package:m_chat/Utils/GetFirebaseData.dart';
import 'package:m_chat/firebase_options.dart';
import 'package:uuid/uuid.dart';

import '../Models/user_model.dart';

var uuid = Uuid();

void main()  {
  _initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          titleTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Colors.black,
          textTheme: CupertinoTextThemeData(
            primaryColor: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

void _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
}
