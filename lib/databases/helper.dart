import 'package:firebase_database/firebase_database.dart';

void addPerson(String name, Map<int, int> prices) {
  final personRef = FirebaseDatabase.instance.ref("persons").push();
  personRef.set({
    "name": name,
    "prices": prices.map((key, value) => MapEntry(key.toString(), value)),
  });

}