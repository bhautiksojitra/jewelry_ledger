import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void addPerson(String name, Map<int, int> prices) {
    final personRef = FirebaseDatabase.instance.ref("UsersList").push();
    personRef.set({"name": name});
  }

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    try {
      final snapshot = await _database.child("UsersList").get();

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.values
            .map((person) => Map<String, dynamic>.from(person))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching persons: $e");
      return [];
    }
  }

  Future<bool> addRecord(
      String personName, String date, String weight, String granular) async {
    try {
      final usersListSnapshot = await _database.child('UsersList').get();

      // if (usersListSnapshot.exists) {
      //   final data = Map<String, dynamic>.from(usersListSnapshot.value as Map);
      //   var usersList = data.values
      //       .map((person) => Map<String, dynamic>.from(person))
      //       .toList();
      //   if (!usersList.contains(personName)) {
      //     throw Exception('Person "$personName" does not exist in UsersList.');
      //   }
      // } else {
      //   throw Exception('UsersList does not exist.');
      // }

      final personRecordsRef = _database.child('RecordDetails/$personName');
      final newRecordRef =
          personRecordsRef.push(); // Generates a unique key for the new record

      await newRecordRef.set({
        "sentdate": date,
        "weight": weight,
        "granular": granular,
        "status": "sent"
      });

      print('Record added successfully for $personName');
    } catch (e) {
      print("Error adding record: $e");
    }
    return false;
  }
}
