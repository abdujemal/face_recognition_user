import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/Model/known_person.dart';
import 'package:face_recognition_user/Model/person.dart';
import 'package:face_recognition_user/View/Widget/known_person_item.dart';
import 'package:face_recognition_user/View/Widget/my_btn.dart';
import 'package:face_recognition_user/View/Widget/person_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class KnownPeople extends StatefulWidget {
  const KnownPeople({ Key? key }) : super(key: key);

  @override
  State<KnownPeople> createState() => _KnownPeopleState();
}

class _KnownPeopleState extends State<KnownPeople> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child("Owners");
  FirebaseService firebaseService = Get.put(FirebaseService());

  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.onValue,
      builder: ((context, snapshot){
        List<KnownPerson>? persons;
              if(snapshot.hasData){
                persons = [];
                if((snapshot.data as DatabaseEvent).snapshot.value != null){
                  Map<dynamic,dynamic> data = (snapshot.data as DatabaseEvent).snapshot.value as Map<dynamic, dynamic>;
                  for(var personData in data.entries){
                  
                    var person = KnownPerson(personData.key,personData.value["img_url"], personData.value["name"]);
                    persons.add(person);
                  }
                }
              }
              return 
                persons == null ?
                const Center(child: CircularProgressIndicator(),):
                persons.isEmpty?
                const Center(child: Text("No one is recorded"),):
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GridView.builder(
                    itemCount: persons.length,
                    itemBuilder: (context,index)=>KnownPersonItem(knownPerson: persons![index]),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6),
                    ),
                );
                
      })
    );
  }

  
}