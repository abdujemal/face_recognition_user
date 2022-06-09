import 'package:get/get.dart';

class RegisterController extends GetxController{
  RxString imagePath = "".obs, imageUrl = "".obs;
  RxBool isLoading = false.obs;
  
  setImagePath(String val){
    imagePath.value = val;
  }

  setImageUrl(String val){
    imageUrl.value = val;
  }

  setIsLoading(bool val){
    isLoading.value = val;
  }
}