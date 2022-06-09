import 'package:get/get.dart';

class HomeController extends GetxController{
  var currentTab = 0.obs;

  setCurrentTab(int val){
    currentTab.value = val;
  }
}