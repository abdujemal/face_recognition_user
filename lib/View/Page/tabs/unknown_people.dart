import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/Model/person.dart';
import 'package:face_recognition_user/View/Widget/my_btn.dart';
import 'package:face_recognition_user/View/Widget/person_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UnknownPeople extends StatefulWidget {
  const UnknownPeople({Key? key}) : super(key: key);

  @override
  State<UnknownPeople> createState() => _UnknownPeopleState();
}

class _UnknownPeopleState extends State<UnknownPeople> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("Persons");
  FirebaseService firebaseService = Get.put(FirebaseService());

  callNumber() async {
    const number = 'tel:991'; //set the number here
    if (await canLaunchUrl(Uri.parse(number))) {
      await launchUrl(Uri.parse(number));
    } else {
      print("Could not call");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
          stream: ref.onValue,
          builder: ((context, snapshot) {
            List<Person>? persons;
            if (snapshot.hasData) {
              persons = [];
              if ((snapshot.data as DatabaseEvent).snapshot.value != null) {
                Map<dynamic, dynamic> data = (snapshot.data as DatabaseEvent)
                    .snapshot
                    .value as Map<dynamic, dynamic>;
                for (var personData in data.entries) {
                  persons.add(Person(
                      personData.value["img_url"],
                      personData.value["date_time"],
                      personData.value["audio_url"],
                      personData.key));
                }
              }
              persons.sort(((a, b) => b.pid.compareTo(a.pid)));
            }
            return persons == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : persons.isEmpty
                    ? const Center(
                        child: Text("No one is recorded"),
                      )
                    : ListView.builder(
                        itemCount: persons.length,
                        itemBuilder: (context, index) => PersonItem(
                              person: persons![index],
                              index: index,
                              length: persons.length,
                            ));
          }),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyBtn(
                  text: "Open Door",
                  ontap: () {
                    firebaseService.openDoor();
                  }),
            )),
        Positioned(
          bottom: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyBtn(
                text: "Call Police",
                ontap: () {
                  callNumber();
                }),
          ),
        )
      ],
    );
  }
}
