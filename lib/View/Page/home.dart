import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/Controller/home_controller.dart';
import 'package:face_recognition_user/Model/person.dart';
import 'package:face_recognition_user/View/Page/audio_call.dart';
import 'package:face_recognition_user/View/Page/register.dart';
import 'package:face_recognition_user/View/Page/tabs/known_people.dart';
import 'package:face_recognition_user/View/Page/tabs/unknown_people.dart';
import 'package:face_recognition_user/View/Widget/my_btn.dart';
import 'package:face_recognition_user/View/Widget/person_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService firebaseService = Get.put(FirebaseService());
  HomeController homeController = Get.put(HomeController());

  List<Widget> bodies = [
    
    const UnknownPeople(),
    const KnownPeople(),
  ];

  List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: "Unknown People" ),
    const BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: "Known People" )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic("userA");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Door"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
                child: const Icon(
                  Icons.more_vert,
                ),
                onSelected: (value) async{
                  switch (value) {
                    case 'ምዝገባ':
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>Register()));
                      break;
                    case "ዳታዎችን አጥፋ":
                      firebaseService.deleteEveryThing();
                      break;
                    case "ድምጽ ልውውጥ":
                      await FirebaseDatabase.instance.ref().child("openAudio").set(true);
                      Get.to(()=>const AudioCall());
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'ምዝገባ','ዳታዎችን አጥፋ',"ድምጽ ልውውጥ"}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(()=>
        BottomNavigationBar(
          items: navItems,
          currentIndex: homeController.currentTab.value,
          onTap: (v){
            homeController.setCurrentTab(v);
          },
          ),
      ),
      body: Obx(()=>bodies[homeController.currentTab.value])
    );
  }
}