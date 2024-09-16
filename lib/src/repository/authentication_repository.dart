import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:loveioit/src/screens/profile_screen.dart';
import '../constants/user_deatils.dart';
import '../screens/onBording/onbording_screens.dart';
import 'exceptions/login_email_password_failure.dart';
import 'exceptions/signup_email_password_failure.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final signUpDataRef = FirebaseDatabase.instance.ref('SignUp Info');

  // Firebase Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationID = ''.obs;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const OnboardingPage())
        : Get.offAll(() => const ProfilePage());
  }

  void saveInfo(String email, String password, String nickName) {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd-MM-yyyy | hh:mm a').format(now);
    signUpDataRef.child(formattedDateTime).set({
      'E-mail': email,
      'Password': password,
      'Nick Name': nickName
    });
    Get.offAll(() => const ProfilePage());
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String nickName) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? saveInfo(email, password, nickName)
          : Get.to(() => const OnboardingPage());
      globalUserName = nickName;
      globalEmail = email;
      globalPassword = password;
    } on FirebaseAuthException catch (e) {
      final exception = SignUpWithEmailAndPasswordFailure.code(e.code);
      final error = "Firebase Auth Exception: ${exception.message}";
      print("${error}******************************************\n");
      print("**********************${e.toString()}");
      Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;
    } catch (_) {
      const exception = SignUpWithEmailAndPasswordFailure();
      print("Exception: ${exception.message}");
      Fluttertoast.showToast(
        msg: exception.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      globalEmail = email;
      globalPassword = password;

      Get.offAll(() => const ProfilePage());
    } on FirebaseAuthException catch (e) {
      final exception = LoginWithEmailAndPasswordFailure.code(e.code);
      final error = "Firebase Auth Exception: ${exception.message}";
      print(error);
      Fluttertoast.showToast(
        msg: e.code.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      throw exception;
    } catch (e) {
      const exception = LoginWithEmailAndPasswordFailure();
      print("Exception: ${exception.message}");
      print("******************${e.toString()}");
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.black87,
      );
      Get.snackbar(
        "Exception",
        exception.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.black87,
      );
      throw exception;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
