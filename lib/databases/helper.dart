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
      final lastIdRef = _database.child("RecordDetails/$personName/lastId");
      final lastIdSnapshot = await lastIdRef.get();
      int lastId = lastIdSnapshot.exists ? lastIdSnapshot.value as int : 0;

      int newId = lastId + 1;
      final recordRef = _database.child('RecordDetails/$personName/$newId');

      await recordRef.set({
        "sentdate": date,
        "weight": weight,
        "granular": granular,
        "status": "sent"
      });

      await lastIdRef.set(newId);

      print('Record added successfully for $personName');
      return true;
    } catch (e) {
      print("Error adding record: $e");
      return false;
    }
  }
}
