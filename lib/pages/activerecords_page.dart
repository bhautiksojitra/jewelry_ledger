import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/components/record_card.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:jewelry_ledger/models/AppSharedData.dart';
import 'package:jewelry_ledger/models/FirebaseDataModel.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';

// Active Records Page
class ActiveRecordsPage extends StatefulWidget {
  const ActiveRecordsPage({super.key});

  @override
  _ActiveRecordsPageState createState() => _ActiveRecordsPageState();
}

class _ActiveRecordsPageState extends State<ActiveRecordsPage> {
  final FirebaseService _firebaseService = FirebaseService();
  List<RecordEntry> list = [];
  @override
  void initState() {
    super.initState();
    var currentUser =
        Provider.of<AppSharedData>(context, listen: false).SelectedUserName;
    fectchRecords(currentUser);
  }

  // put fetch records in init state and onDropDownChanged.. however have a local variable to track if there is a change in values or Not

  // this is to ensure the number of db calls are reduced via init state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onDropdownChanged(String? value) {
    Provider.of<AppSharedData>(context, listen: false)
        .updateSelectedUser(value!);
    fectchRecords(value);
  }

  void fectchRecords(String userName) async {
    if (isBlank(userName)) return;

    var tempList = _firebaseService.getRecordsByUserName(userName, context);

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
            child: Consumer<AppSharedData>(
          builder: (context, value, child) => DropdownMenuExample(
            label: "Select a name",
            items: value.FirebaseData.usersList,
            initSelect: value.SelectedUserName,
            onChanged: onDropdownChanged,
          ),
        )),

        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (content, index) {
              return RecordCard(
                dateText: list[index].sentDate.toString(),
                weightText: list[index].weight.toString(),
                granularText: list[index].granular.toString(),
              );
            },
          ),
        )

        //const RecordCard(placeholderText: "placeholderText"),
      ],
    ));
  }
}
