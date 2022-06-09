import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyBtn extends StatefulWidget {
  String text;
  void Function() ontap;
  MyBtn({ Key? key, required this.text, required this.ontap}) : super(key: key);

  @override
  State<MyBtn> createState() => _MyBtnState();
}

class _MyBtnState extends State<MyBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>widget.ontap(),
      child: Ink(
        decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text(widget.text, style: const TextStyle(color: Colors.white,fontSize: 18),),
        ),
      ),
    );
  }
}