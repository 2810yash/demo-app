import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loveioit/src/screens/signup_screen.dart';

import 'login_screen.dart';

class WelComePage extends StatefulWidget {
  const WelComePage({super.key});

  @override
  State<WelComePage> createState() => _WelComePageState();
}

final dataRef = FirebaseDatabase.instance.ref('Data');
bool imagesLoaded = false;

class _WelComePageState extends State<WelComePage> {
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      imagesLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(27.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcom_screen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 20.0),
              Text(
                'Find Your Love ❤️',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0,color: Colors.pink[100]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => Get.to(() => const LogInScreen()),
                          child: const Text('LogIn'))),
                  const SizedBox(width: 20.0),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () => Get.to(() => const SignupScreen()),
                          child: const Text('SignUp'))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
