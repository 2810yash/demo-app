import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../authentication_repository.dart';

class LogInController extends GetxController {
  static LogInController get instance => Get.find();

  // TextField Controllers to get data from textfield
  final email = TextEditingController();
  final password = TextEditingController();

  // Call function when submit button will press
  Future<void> logInUser(String email, String password) async {
    // Ensure this method doesn't return anything since the loginWithEmailAndPassword likely returns void
    await AuthenticationRepository.instance.loginWithEmailAndPassword(email, password);
  }
}
