import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:jewelry_ledger/models/FirebaseDataModel.dart';

class AppSharedData extends ChangeNotifier {
  // private fields that are shared across the app
  String _selectedUserName = "";
  FirebaseDataModel _firebaseData =
      FirebaseDataModel(usersList: [], recordDetails: {});

  // public getter of the shared fields
  String get SelectedUserName => _selectedUserName;

  FirebaseDataModel get FirebaseData => _firebaseData;

  // update methods
  void updateSelectedUser(String value) {
    if (_selectedUserName != value) {
      _selectedUserName = value;
      log(_selectedUserName);
      notifyListeners();
    }
  }

  void addRecordToSelectedUser(String key, RecordEntry entry, String userName) {
    _firebaseData.recordDetails[userName]?.records[key] = entry;
    notifyListeners();
  }

  void updateFirebaseDataValue(FirebaseDataModel value) {
    if (_firebaseData != value) {
      _firebaseData = value;
      notifyListeners();
    }
  }
}
