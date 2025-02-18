import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:jewelry_ledger/datamodels/RecordModel.dart';
import 'package:quiver/strings.dart';

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
    print("Ia m here");
    if (isBlank(personName)) {
      print("No person selected");
      log("No person selected");
      return false;
    }

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

  Future<List<String>> getRecordsByUserName(String userName) async {
    try {
      final records = _database.child("RecordDetails/$userName");
      final recordsSnapshot = await records.get();

      if (recordsSnapshot.exists) {
        var recordsList =
            Map<String, dynamic>.from(recordsSnapshot.value as Map);
        List<String> retList = [];
        log(recordsList.toString());

        recordsList.forEach((key, value) {
          retList.add(value.toString());
        });

        return retList;
      }
    } catch (e) {
      log("Exception occured while getting records list");
    }

    return [];
  }
}
