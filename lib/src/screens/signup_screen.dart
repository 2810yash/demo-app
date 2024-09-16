import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loveioit/src/screens/welcome_screen.dart';
import '../constants/colors.dart';
import '../repository/controllers/signup_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

final signUpDataRef = FirebaseDatabase.instance.ref("Sign Up Data");

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;

  // for password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/form_bg_img.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: controller.email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Email-ID",
                      filled: true,
                      fillColor: SecondaryColor2.withOpacity(0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Add space between fields
                  TextFormField(
                    controller: controller.password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Password",
                      filled: true,
                      fillColor: SecondaryColor2.withOpacity(0.8),
                      suffixIcon: IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: controller.nickName,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "Nick Name",
                      filled: true,
                      fillColor: SecondaryColor2.withOpacity(0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nick name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Add space between fields
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          SignUpController.instance.registerUser(
                              controller.email.text.trim(),
                              controller.password.text.trim(),
                              controller.nickName.text.trim());
                        }
                      },
                      child: const Text("SignUp"),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () => Get.off(() => const LogInScreen()),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Already have an Account?'),
                        Text(' Login',
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PS:',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      Text(' Nickname will be helpful\n for accurate matching',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.white.withOpacity(0.8),
                          )),
                    ],
                  ),
                  const SizedBox(height: 35.0),
                  SizedBox(
                      height: 70.0,
                      child: ElevatedButton(
                          onPressed: () =>
                              Get.offAll(() => const WelComePage()),
                          child: const Icon(Icons.arrow_back_outlined))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
