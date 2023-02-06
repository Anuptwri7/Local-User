import 'dart:developer';
import 'dart:io' show Platform, stdout;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local/Auth/Login/userLoginScreen.dart';

import 'Auth/Login/lognRiderPage.dart';
import 'tabPage.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  runApp(
     MyApp(),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Soori RFID',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home:  LoginScreen(toggle: false,),
    );
  }
}


