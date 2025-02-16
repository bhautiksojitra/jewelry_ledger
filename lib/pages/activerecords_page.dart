import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// Active Records Page
class ActiveRecordsPage extends StatefulWidget {
  const ActiveRecordsPage({super.key});

  @override
  _ActiveRecordsPageState createState() => _ActiveRecordsPageState();
}

class _ActiveRecordsPageState extends State<ActiveRecordsPage> {
  listenOnDBChange() {
    DatabaseReference _usersListRef =
        FirebaseDatabase.instance.ref("UsersList");

    _usersListRef.onValue.listen((event) {
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);

      print(data);
      setState(() {
        var x =
            data.values.map((item) => Map<String, dynamic>.from(item)).toList();
        _items = x.map((person) => person['name'] as String).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    listenOnDBChange();
  }

  List<String> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: _items.length, // Number of items in the list
          itemBuilder: (context, index) {
            return Container(
              color: index % 2 == 0 ? Colors.red : Colors.blue,
              height: 100,
              child: Center(
                child: Text(_items[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
