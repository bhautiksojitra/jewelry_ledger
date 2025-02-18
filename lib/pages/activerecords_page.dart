import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/components/record_card.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:jewelry_ledger/datamodels/UsersModel.dart';
import 'package:provider/provider.dart';

// Active Records Page
class ActiveRecordsPage extends StatefulWidget {
  const ActiveRecordsPage({super.key});

  @override
  _ActiveRecordsPageState createState() => _ActiveRecordsPageState();
}

class _ActiveRecordsPageState extends State<ActiveRecordsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> list = [];
  @override
  void initState() {
    super.initState();
    log("Hi there, it's me bhautik");
  }

  // put fetch records in init state and onDropDownChanged.. however have a local variable to track if there is a change in values or Not

  // this is to ensure the number of db calls are reduced via init state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onDropdownChanged(String? value) {
    Provider.of<UsersModel>(context, listen: false).updateSelectedUser(value!);
    fectchRecords(value);
  }

  void fectchRecords(String userName) async {
    var tempList = await _firebaseService.getRecordsByUserName(userName);

    setState(() {
      list = tempList;
    });
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
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (content, index) {
              return RecordCard(placeholderText: list[index]);
            },
          ),
        )

        //const RecordCard(placeholderText: "placeholderText"),
      ],
    ));
  }
}
