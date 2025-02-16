import 'package:firebase_database/firebase_database.dart';
import 'package:jewelry_ledger/datamodels/RecordModel.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<List<String>> fetchUsers() async {
    try {
      final snapshot = await _database.child("UsersList").get();
      if (snapshot.exists) {
        return List<String>.from(snapshot.value as List);
      } else {
        print("No data available to print");
        return [];
      }
    } catch (e) {
      print("Exception while reading from the users list database");
      return [];
    }
  }

  Future<bool> addRecord(String personName, Recordmodel newValue) async {
    try {
      // reference to last id info
      final lastIdRef = _database.child("RecordDetails/$personName/lastId");
      final lastIdSnapshot = await lastIdRef.get();
      int lastId = lastIdSnapshot.exists ? lastIdSnapshot.value as int : 0;
      int newId = lastId + 1; // create new id
      // create new id ref
      final newRecordRef = _database.child('RecordDetails/$personName/$newId');

      // add record to new id
      newRecordRef.set(newValue.toJson());
      await lastIdRef.set(newId); // update last id ref

      // ADD LOG HERE
      return true;
    } catch (e) {
      // ADD LOGGER HERE
      print("Error adding record: $e");
      return false;
    }
  }
}
