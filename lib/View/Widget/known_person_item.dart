import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/Model/known_person.dart';
import 'package:face_recognition_user/View/Widget/person_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KnownPersonItem extends StatefulWidget {
  KnownPerson knownPerson;
  KnownPersonItem({ Key? key, required this.knownPerson }) : super(key: key);

  @override
  State<KnownPersonItem> createState() => _KnownPersonItemState();
}

class _KnownPersonItemState extends State<KnownPersonItem> {
  String url = "";
  FirebaseService firebaseService = Get.put(FirebaseService());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getUrl(widget.knownPerson.img_path);
  }

  getUrl(img_path)async{
    String _url = await FirebaseStorage.instance.ref(img_path).getDownloadURL();
    if (!mounted) return;
    setState(() {
      url = _url;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: url != "" ? DecorationImage(image: getImageNet(url),fit: BoxFit.cover) : null
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child:IconButton(onPressed: (){
               
               firebaseService.deleteKnownPeople(widget.knownPerson.id, widget.knownPerson.img_path);
               
             }, 
              icon: const Icon(Icons.delete_outline,color: Colors.red,))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(126, 0, 0, 0),
                borderRadius: BorderRadius.circular(5)
              ),
              padding: const EdgeInsets.all(5),
              child: Text(widget.knownPerson.name, style: const TextStyle(color: Colors.white),))),
        ],
      ),
    );
  }
}