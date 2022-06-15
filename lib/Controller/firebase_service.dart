import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:face_recognition_user/Controller/register_controller.dart';
import 'package:face_recognition_user/View/Widget/msg_snack.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  RegisterController registerController = Get.put(RegisterController());

  registerUser(File file, String name, BuildContext context) async {
    try {
      registerController.setIsLoading(true);
      await FirebaseStorage.instance.ref("Owners/$name").putFile(file);
      await ref
          .child("Owners")
          .push()
          .update({"img_url": "Owners/$name", "name": name});
      registerController.setIsLoading(false);
      Navigator.pop(context);
    } catch (e) {
      registerController.setIsLoading(false);
      MSGSnack msgSnack =
          MSGSnack(title: "Error", msg: e.toString(), color: Colors.red);
      msgSnack.show();
    }
  }

  verifyUser(String url, String name, BuildContext context) async {
    try {
      registerController.setIsLoading(true);
      await ref.child("Owners").push().update({"img_url": url, "name": name});
      registerController.setIsLoading(false);
      Navigator.pop(context);
    } catch (e) {
      registerController.setIsLoading(false);
      MSGSnack msgSnack =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
      msgSnack.show();
    }
  }

  deleteEveryThing() async {
    try {
      await ref.child("Persons").remove();
      MSGSnack msgSnack = MSGSnack(
          title: "Success",
          msg: "You have successfully deleted every thing.",
          color: Colors.green);
      msgSnack.show();
    } catch (e) {
      MSGSnack msgSnack =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
      msgSnack.show();
    }
  }

  openDoor() async {
    Random random = Random();
    await ref.child("ring").set(random.nextInt(300));
  }

  deleteKnownPeople(String id, String path) async {
    try {
      await ref.child("Owners").child(id).remove();
      await FirebaseStorage.instance.ref(path).delete();
      MSGSnack msgSnack = MSGSnack(
          title: "Success",
          msg: "You have successfully deleted.",
          color: Colors.green);
      msgSnack.show();
    } catch (e) {
      MSGSnack msgSnack =
          MSGSnack(title: "Error!", msg: e.toString(), color: Colors.red);
      msgSnack.show();
    }
  }
}
