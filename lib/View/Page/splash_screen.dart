import 'dart:async';

import 'package:face_recognition_user/View/Page/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splash();
  }

  splash() async {
    await FirebaseMessaging.instance.subscribeToTopic("userA");
    await Future.delayed(const Duration(seconds: 9));
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/icon.gif"),
            const Text(
              "Smart Door",
              style: TextStyle(fontSize: 20),
            )
          ]),
    );
  }
}
