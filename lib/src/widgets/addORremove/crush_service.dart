import 'package:firebase_database/firebase_database.dart';
import '../../data/chrushData.dart';

class CrushService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Add a student to the crush list
  Future<void> addCrush(String userName, Student student) async {
    final crushListRef = _dbRef.child('users/$userName/crushList');
    try {
      await crushListRef.child(student.name).set({
        'name': student.name,
        'id': student.prn,
        // Add any additional fields from Student if needed
      });
      print("Crush added: ${student.name}");
    } catch (e) {
      print("Error adding crush: $e");
    }
  }

  // Remove a student from the crush list
  Future<void> removeCrush(String userName, Student student) async {
    final crushListRef = _dbRef.child('users/$userName/crushList');
    try {
      await crushListRef.child(student.name).remove();
      print("Crush removed: ${student.name}");
    } catch (e) {
      print("Error removing crush: $e");
    }
  }

  // Retrieve the crush list length
  Future<int> getCrushListLength(String userName) async {
    final crushListRef = _dbRef.child('users/$userName/crushList');
    final snapshot = await crushListRef.get();
    int len = (snapshot.value as Map).length;
    if (snapshot.exists) {
      return len;
    } else {
      return 0;
    }
  }

  // Retrieve the crush list (if needed)
  Future<List<Student>> fetchCrushList(String userName) async {
    final crushListRef = _dbRef.child('users/$userName/crushList');
    final snapshot = await crushListRef.get();
    if (snapshot.exists) {
      return snapshot.children.map((data) {
        return Student(
          prn: data.key!,
          name: data.child('name').value as String, seatNo: '', motherName: '',
        );
      }).toList();
    }
    return [];
  }
}
