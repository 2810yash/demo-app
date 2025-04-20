// import 'package:firebase_database/firebase_database.dart';
//
// class CrushServiceTwo {
//   final DatabaseReference _database = FirebaseDatabase.instance.ref();
//
//   // Add a crush with proper error handling
//   Future<bool> addCrush(String currentUserId, String crushName) async {
//     try {
//       // First check if the crush already exists
//       final existingCrushes = await getUserCrushesAsList(currentUserId);
//       if (existingCrushes.contains(crushName)) {
//         return false; // Already exists
//       }
//
//       // Add to current user's crush list
//       await _database
//           .child('users')
//           .child(currentUserId)
//           .child('crushList')
//           .push()
//           .set(crushName);
//
//       // Check for match
//       await checkForMatch(currentUserId, crushName);
//       return true;
//     } catch (e) {
//       print('Error adding crush: $e');
//       return false;
//     }
//   }
//
//   // Get crushes as a List for one-time checks
//   Future<List<String>> getUserCrushesAsList(String userId) async {
//     try {
//       final snapshot = await _database
//           .child('users')
//           .child(userId)
//           .child('crushList')
//           .get();
//
//       final Map<dynamic, dynamic>? values =
//       snapshot.value as Map<dynamic, dynamic>?;
//
//       if (values == null) return [];
//       return values.values.cast<String>().toList();
//     } catch (e) {
//       print('Error getting crushes: $e');
//       return [];
//     }
//   }
//
//   // Stream of crushes for real-time updates
//   Stream<Set<String>> getUserCrushes(String userId) {
//     return _database
//         .child('users')
//         .child(userId)
//         .child('crushList')
//         .onValue
//         .map((event) {
//       final Map<dynamic, dynamic>? values =
//       event.snapshot.value as Map<dynamic, dynamic>?;
//
//       if (values == null) return <String>{};
//       return values.values.cast<String>().toSet();
//     });
//   }
//
//   // Get number of users who have added current user as crush
//   Stream<int> getCrushOfCount(String currentUserName) {
//     return _database
//         .child('users')
//         .onValue
//         .map((event) {
//       final Map<dynamic, dynamic>? users =
//       event.snapshot.value as Map<dynamic, dynamic>?;
//
//       if (users == null) return 0;
//
//       return users.values.where((userData) {
//         if (userData is! Map || userData['crushList'] == null) return false;
//         return (userData['crushList'] as Map)
//             .values
//             .contains(currentUserName);
//       }).length;
//     });
//   }
//
//   // Check and update matches with improved error handling
//   Future<void> checkForMatch(String currentUserId, String crushName) async {
//     try {
//       final snapshot = await _database.child('users').get();
//       final Map<dynamic, dynamic>? users =
//       snapshot.value as Map<dynamic, dynamic>?;
//
//       if (users == null) return;
//
//       // Find crush's user ID and current user's name
//       String? crushUserId;
//       String? currentUserName;
//
//       users.forEach((userId, userData) {
//         if (userData['name'] == crushName) {
//           crushUserId = userId;
//         }
//         if (userId == currentUserId) {
//           currentUserName = userData['name'];
//         }
//       });
//
//       if (crushUserId == null || currentUserName == null) return;
//
//       // Check for mutual crush
//       final crushListSnapshot = await _database
//           .child('users')
//           .child(crushUserId!)
//           .child('crushList')
//           .get();
//
//       final Map<dynamic, dynamic>? crushList =
//       crushListSnapshot.value as Map<dynamic, dynamic>?;
//
//       if (crushList != null &&
//           crushList.values.contains(currentUserName)) {
//         // Create match entries for both users
//         await Future.wait([
//           _createMatchEntry(currentUserId, crushName),
//           _createMatchEntry(crushUserId!, currentUserName!),
//         ]);
//       }
//     } catch (e) {
//       print('Error checking match: $e');
//     }
//   }
//
//   // Helper method to create match entries
//   Future<void> _createMatchEntry(String userId, String matchName) async {
//     try {
//       // First check if match already exists
//       final existingMatches = await getMatchesAsList(userId);
//       if (!existingMatches.contains(matchName)) {
//         await _database
//             .child('users')
//             .child(userId)
//             .child('matches')
//             .push()
//             .set(matchName);
//       }
//     } catch (e) {
//       print('Error creating match entry: $e');
//     }
//   }
//
//   // Get matches as a list for one-time checks
//   Future<List<String>> getMatchesAsList(String userId) async {
//     try {
//       final snapshot = await _database
//           .child('users')
//           .child(userId)
//           .child('matches')
//           .get();
//
//       final Map<dynamic, dynamic>? matches =
//       snapshot.value as Map<dynamic, dynamic>?;
//
//       if (matches == null) return [];
//       return matches.values.cast<String>().toList();
//     } catch (e) {
//       print('Error getting matches: $e');
//       return [];
//     }
//   }
//
//   // Get number of matches as a stream
//   Stream<int> getMatchCount(String userId) {
//     return _database
//         .child('users')
//         .child(userId)
//         .child('matches')
//         .onValue
//         .map((event) {
//       final Map<dynamic, dynamic>? matches =
//       event.snapshot.value as Map<dynamic, dynamic>?;
//
//       return matches?.length ?? 0;
//     });
//   }
// }