import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MSGSnack {
  String title, msg;
  Color color;
  MSGSnack({required this.title, required this.msg, required this.color});
  show() {
    var textStyle = TextStyle(color: color);
    Get.showSnackbar(GetSnackBar(
      titleText: Text(
        title,
        style: textStyle,
      ),
      messageText: Text(
        msg,
        style: textStyle,
      ),
      backgroundColor: const Color.fromARGB(255, 49, 49, 49),
      duration: const Duration(seconds: 3),
    ));
  }
}
