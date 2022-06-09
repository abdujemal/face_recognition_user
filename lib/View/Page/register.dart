import 'dart:io';

import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/Controller/register_controller.dart';
import 'package:face_recognition_user/View/Widget/app_text_feild.dart';
import 'package:face_recognition_user/View/Widget/my_btn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
  String url;
  Register({ Key? key, this.url = ""}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseService firebaseService = Get.put(FirebaseService());
  TextEditingController _fullNameTc = TextEditingController();
  RegisterController registerController = Get.put(RegisterController());

  @override
  void initState() {
    super.initState();
    if(widget.url != ""){
      getImageUrl();
    }
  }

  getImageUrl() async{
    print(widget.url);
    registerController.imageUrl.value = await FirebaseStorage.instance.ref(widget.url).getDownloadURL();
    print(registerController.imageUrl.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("መመዝግቢያ")),
      body: Column(
        children: [
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.url == ""?
              Obx(() => 
                registerController.imagePath.value == "" ?
                const Icon(Icons.account_circle, size: 150,):
                Image.file(File(registerController.imagePath.value),height: 150,width: 150, fit: BoxFit.cover,),
              ):
              Obx(()=>
                registerController.imageUrl.value == ""?
                const Icon(Icons.account_circle, size: 150,):
                Image.network(registerController.imageUrl.value,height: 150,width: 150, fit: BoxFit.cover,)
              ),
              if (widget.url.isEmpty) Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: ()async{
                     XFile? xImage = await ImagePicker().pickImage(source: ImageSource.camera);
                    if(xImage == null){
                      print("image is null");
                    }else{
                      registerController.setImagePath(xImage.path);
                    }
                  }, child: Row(
                    children: const[
                      Icon(Icons.camera_enhance),
                      SizedBox(width: 4,),
                      Text("ፎቶ ያንሱ"),
                    ],
                  )),
                  TextButton(onPressed: ()async{
                    XFile? xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(xImage == null){
                      print("image is null");
                    }else{
                      registerController.setImagePath(xImage.path);
                    }
                  }, child: Row(
                    children: const [
                      Icon(Icons.image),
                      SizedBox(width: 4,),
                      Text("ፎቶ ይምረጡ"),
                    ],
                  )),
                ],
              ) else const SizedBox()
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppTextField(labelText: "ሙሉ ስም", controller: _fullNameTc),
          ),
          const SizedBox(height: 5,),

          Obx(()=>
          registerController.isLoading.value?
          const CircularProgressIndicator():
           MyBtn(text:"መዝግብ", ontap: (){
              if(_fullNameTc.text.isNotEmpty){
                if(widget.url == ""){
                  firebaseService.registerUser(File(registerController.imagePath.value),_fullNameTc.text, context);
                }else{
                  firebaseService.verifyUser(widget.url , _fullNameTc.text, context);
                }
              }
            }),
          )
      ],)
    );
  }
}