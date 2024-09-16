import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loveioit/src/screens/signup_screen.dart';
import 'package:loveioit/src/screens/welcome_screen.dart';
import '../constants/colors.dart';
import '../repository/controllers/login_controller.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogInScreen> {
  bool _obscureText = true;
  bool _isLoading = false;  // Loading state variable

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    final _LoginformKey = GlobalKey<FormState>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          image: const DecorationImage(
            image: AssetImage('assets/images/form_bg_img.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Form(
              key: _LoginformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "LogIn",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // Email field
                  TextFormField(
                    controller: controller.email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Email-ID",
                      filled: true,
                      fillColor: SecondaryColor2.withOpacity(0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Password field
                  TextFormField(
                    controller: controller.password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      labelText: "Password",
                      filled: true,
                      fillColor: SecondaryColor2.withOpacity(0.5),
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
                  // Login Button with CircularProgressIndicator
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () async {
                        if (_LoginformKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          await LogInController.instance.logInUser(
                              controller.email.text.trim(),
                              controller.password.text.trim());

                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
                      ))
                          : const Text("Login"),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  // SignUp button
                  TextButton(
                    onPressed: _isLoading ? null : () => Get.off(() => const SignupScreen()),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Don\'t have an Account?'),
                        Text(' SignUp',
                            style: TextStyle(
                              color: Colors.blue,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  // Back Button
                  SizedBox(
                    height: 70.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => Get.offAll(() => const WelComePage()),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
