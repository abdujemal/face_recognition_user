import 'package:face_recognition_user/Model/person.dart';
import 'package:face_recognition_user/View/Page/register.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PersonItem extends StatefulWidget {
  Person person;
  PersonItem({ Key? key,required this.person}) : super(key: key);

  @override
  State<PersonItem> createState() => _PersonItemState();
}

class _PersonItemState extends State<PersonItem> {
  String imageUrl = "";

  @override
  initState(){
    super.initState();
    getImageUrl();
  }

 getImageUrl(){
    imageUrl = widget.person.img_url.replaceAll("https://firebasestorage.googleapis.com/v0/b/faceiddoorlock.appspot.com/o/","").replaceAll("?alt=media","").replaceAll("%2F","/");
    if (!mounted) return;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(top: 15,right: 10, left: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(121, 210, 208, 208),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: getImageNet(widget.person.img_url,),fit: BoxFit.cover)),
              ),
              const SizedBox(width: 10,),
              const SizedBox(
                height: 150,
                width: 170,
                child: Text("ይህ ሰው ደጃፍዎ ላይ ቆሞ ነበር።",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,))
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(widget.person.date_time),
                  const SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      imageUrl == "" ?
                      null:
                      Navigator.push(context,MaterialPageRoute(builder: (_)=> Register(url: imageUrl)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: Text("መዝግበው", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

ImageProvider<Object> getImageNet(img_url){
  ImageProvider<Object> img = AssetImage("asssets/image_not_found.png");
  try{
    print(img_url);
    img =  NetworkImage(img_url);
  }catch(e){
    print(e.toString());
  }
  return img;
}