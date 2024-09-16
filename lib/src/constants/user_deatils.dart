import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

String? globalUserName;
String? globalEmail;
String? globalPassword;
String? scanResult;

String? getCurrentUserEmail() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    globalEmail = user.email;
    return globalEmail;
  }
  return "Loading...";
}

Future<String?> getNickNameForEmail(String email) async {
  final databaseReference = FirebaseDatabase.instance.ref('Users'); // Adjust the path as needed

  // Convert email to a format suitable for querying if necessary
  final formattedEmail = email.replaceAll('.', ','); // Firebase doesn't allow dots in keys

  try {
    final snapshot = await databaseReference.child(formattedEmail).get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data['Nick Name'] as String?;
    } else {
      print("No data available for this email. Email: ${getCurrentUserEmail()}");
      return null;
    }
  } catch (e) {
    print("Error fetching nickname: $e");
    return null;
  }
}

Future<String?> fetchNickNameForCurrentUser(String email) async {
  final ref = FirebaseDatabase.instance.ref('SignUp Info'); // Use correct path

  // Convert email to a format suitable for querying if necessary
  // final formattedEmail = email.replaceAll('.', ','); // Firebase doesn't allow dots in keys

  try {
    // Retrieve all entries in the database
    final snapshot = await ref.orderByChild('E-mail').equalTo(email).once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;

      // Since data contains multiple entries, iterate to find the matching email
      for (var entry in data.entries) {
        final userData = entry.value as Map<dynamic, dynamic>;
        if (userData['E-mail'] == email) {
          return userData['Nick Name'] as String?;
        }
      }
    } else {
      print('No data available for this email. Email: $email');
      return null;
    }
  } catch (e) {
    print("Error fetching nickname: $e");
    return null;
  }
  return null;
}