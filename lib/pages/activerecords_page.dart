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
  @override
  void initState() {
    super.initState();
  }

  void onDropdownChanged(String? value) {
    Provider.of<UsersModel>(context, listen: false).updateSelectedUser(value!);
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
