import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../authentication_repository.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  // TextField Controllers to get data from textfield
  final nickName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  // Call function when SignUp button will press
  void registerUser(String email, String password, String nickName){
    AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password, nickName);
  }
}