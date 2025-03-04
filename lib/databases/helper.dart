import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_ledger/models/AppSharedData.dart';
import 'package:jewelry_ledger/models/FirebaseDataModel.dart';
import 'package:provider/provider.dart';
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

  Future<void> queryEntireDatabase(BuildContext context) async {
    try {
      final snapshot = await _database.get();
      if (snapshot.exists) {
        var jsonObject = Map<String, dynamic>.from(snapshot.value as Map);
        var firebaseObject = FirebaseDataModel.fromJson(jsonObject);
        Provider.of<AppSharedData>(context, listen: false)
            .updateFirebaseDataValue(firebaseObject);
        log(firebaseObject.recordDetails.toString());
      }
    } catch (e, stackTrace) {
      log("Error quering the entire database $e, $stackTrace");
    }
  }

  Future<bool> addRecord(String personName, RecordEntry newValue) async {
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
      //newRecordRef.set(newValue.toJson());
      await lastIdRef.set(newId); // update last id ref

      // ADD LOG HERE
      return true;
    } catch (e) {
      // ADD LOGGER HERE
      print("Error adding record: $e");
      return false;
    }
  }

//   Future<List<Recordmodel>> getRecordsByUserName(String userName) async {
//     try {
//       final records = _database.child("RecordDetails/$userName");
//       final recordsSnapshot = await records.get();

//       if (recordsSnapshot.exists) {
//         var recordsList =
//             Map<String, dynamic>.from(recordsSnapshot.value as Map);
//         List<Recordmodel> recordsListToReturn = [];

//         recordsList.forEach((key, value) {
//           if (key != "lastId") {
//             try {
//               var record = Map<String, dynamic>.from(value as Map);
//               recordsListToReturn.add(Recordmodel.fromJson(record));
//             } catch (e) {
//               log("record $value is not valid for returned by getRecordsByUserName function");
//             }
//           }
//         });

//         return recordsListToReturn;
//       }
//     } catch (e) {
//       log("Exception occured while getting records list");
//     }

//     return [];
//   }
// }

  List<RecordEntry> getRecordsByUserName(
      String userName, BuildContext context) {
    var firebaseData =
        Provider.of<AppSharedData>(context, listen: false).FirebaseData;
    log(firebaseData.recordDetails.toString());
    log(userName);
    var tempValue = firebaseData.recordDetails[userName]?.records;
    log(tempValue.toString());

    var returnArray = List<RecordEntry>.empty(growable: true);

    tempValue?.forEach((key, value) {
      returnArray.add(value);
    });

    return returnArray;
  }
}
