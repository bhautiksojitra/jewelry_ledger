import 'package:firebase_database/firebase_database.dart';


class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void addPerson(String name, Map<int, int> prices) {
    final personRef = FirebaseDatabase.instance.ref("persons").push();
    personRef.set({
      "name": name,
      "prices": prices.map((key, value) => MapEntry(key.toString(), value)),
    });
  }

  Future<List<Map<String, dynamic>>> fetchPersons() async {
    try {
      final snapshot = await _database.child("persons").get();

      if(snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.values.map((person) => Map<String, dynamic>.from(person)).toList();
      } else {
        return [];
      }
    }
    catch (e) {
      print("Error fetching persons: $e");
      return [];
    }
  }
}
