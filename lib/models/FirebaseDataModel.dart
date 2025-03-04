import 'dart:developer';

class FirebaseDataModel {
  List<String> usersList;
  Map<dynamic, RecordDetails> recordDetails;

  FirebaseDataModel({required this.usersList, required this.recordDetails});

  factory FirebaseDataModel.fromJson(Map<String, dynamic> json) {
    return FirebaseDataModel(
        usersList: List<String>.from(json['UsersList']),
        recordDetails: json['RecordDetails'] != null
            ? json['RecordDetails'].map<dynamic, RecordDetails>((key, value) =>
                MapEntry(key,
                    RecordDetails.fromJson(Map<String, dynamic>.from(value))))
            : {});
  }
}

class RecordDetails {
  Map<String, RecordEntry> records;
  int lastId;

  RecordDetails({required this.records, required this.lastId});

  factory RecordDetails.fromJson(Map<String, dynamic> json) {
    log("hello");
    var recordsMap = json.map<String, RecordEntry>((key, value) {
      if (key == 'lastId') return MapEntry(key, RecordEntry(lastId: value));
      return MapEntry(
          key, RecordEntry.fromJson(Map<String, dynamic>.from(value)));
    });

    return RecordDetails(
      records: recordsMap,
      lastId: json['lastId'],
    );
  }
}

class RecordEntry {
  String? sentDate;
  dynamic weight; // Handle cases where weight is missing or null
  dynamic granular;
  String? status;
  dynamic lastId; // This is only for "lastId" cases

  RecordEntry(
      {this.sentDate, this.weight, this.granular, this.status, this.lastId});

  factory RecordEntry.fromJson(Map<String, dynamic> json) {
    return RecordEntry(
      sentDate: json['sentdate'],
      weight: json['weight'] ?? 0, // Default weight to 0 if missing
      granular: json['granular'],
      status: json['status'],
    );
  }
}
