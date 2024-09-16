import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loveioit/src/constants/user_deatils.dart';
import '../widgets/profile/profile.dart';

final ref = FirebaseDatabase.instance.ref('Scanned Data');

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userEmail = "Loading...";
  String _userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _userEmail = getCurrentUserEmail() ?? "Loading...";
    fetchNickNameForCurrentUser(_userEmail).then((nickname) {
      setState(() {
        _userName = nickname ?? _userEmail;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/home_bg_img.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const Expanded(flex: 1, child: TopPortion()),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        _userName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'Crush-List',
                            elevation: 0,
                            label: const Text("Crush List"),
                            icon: const Icon(Icons.add),
                          ),
                          const SizedBox(width: 16.0),
                          FloatingActionButton.extended(
                            onPressed: () {},
                            heroTag: 'message',
                            elevation: 0,
                            backgroundColor: Colors.red,
                            label: const Text("Message"),
                            icon: const Icon(Icons.message_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      const ProfileInfoRow()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
