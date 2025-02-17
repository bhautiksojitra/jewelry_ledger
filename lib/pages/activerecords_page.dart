import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/datamodels/UsersModel.dart';
import 'package:provider/provider.dart';

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
    //listenOnDBChange();
  }

  List<String> _items = [];

  void onDropdownChanged(String? value) {
    print("Hello world");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
            child: Consumer<UsersModel>(
          builder: (context, value, child) => DropdownMenuExample(
            label: "Select a name",
            items: value.Users,
            initSelect: value.SelectedUser,
            onChanged: onDropdownChanged,
          ),
        )),
      ],
    ));
  }
}
