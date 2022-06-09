import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:face_recognition_user/Controller/firebase_service.dart';
import 'package:face_recognition_user/View/Widget/my_btn.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../contstants.dart';

class AudioCall extends StatefulWidget {
  const AudioCall({ Key? key }) : super(key: key);

  @override
  State<AudioCall> createState() => _AudioCallState();
}

class _AudioCallState extends State<AudioCall> {

  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  RtcEngine? engine;
  bool itJoined = false;

  FirebaseService firebaseService = Get.put(FirebaseService());

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try{
      // Get microphone permission
      await [Permission.microphone].request();

      // Create RTC client instance
      RtcEngineContext context = RtcEngineContext(APP_ID);
      engine = await RtcEngine.createWithContext(context);
      // Define event handling logic
      engine!.setEventHandler(RtcEngineEventHandler(
          joinChannelSuccess: (String channel, int uid, int elapsed) {
            print('joinChannelSuccess ${channel} ${uid}');
            setState(() {
              _joined = true;
            });
          }, userJoined: (int uid, int elapsed) {
        print('userJoined ${uid}');
        setState(() {
          _remoteUid = uid;
        });
      }, userOffline: (int uid, UserOfflineReason reason) {
        print('userOffline ${uid}');
        setState(() {
          _remoteUid = 0;
        });
      }));
      // String token = await getToken("123");
      // print(token);
      // Join channel with channel name as 123
      
      await engine!.joinChannel(await getToken("123"), '123', null, 0);

      await engine!.setEnableSpeakerphone(true);

      FirebaseDatabase.instance.ref().child("openAudio").onValue.listen((event) {
          if(event.snapshot.value == true){
            setState(() {
              itJoined = true;
            });
          }
      });
      
    }catch(e){
      print(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if(engine != null){
      engine!.leaveChannel();
      engine!.destroy();
      FirebaseDatabase.instance.ref().child("openAudio").set(false);
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                  title: const Text('Audio Conference'),
              ),
              body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30,),
                      Text(itJoined? "Audio call started...":_joined?'waiting...':'Joining...'),
                      const SizedBox(height: 30,),
                      InkWell(
                        onTap: (){}, 
                        child: Ink(
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.call_end, color: Colors.white,),
                          ),
                          ),
                      ),
                      const SizedBox(height: 30,),
                      MyBtn(text: "Open Door", ontap: (){
                          firebaseService.openDoor();
                      }),
                    ],
                  ),
              ),
          );
  }
}