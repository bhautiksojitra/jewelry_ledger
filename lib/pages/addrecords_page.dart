import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/components/record_entry_form.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:intl/intl.dart';
import 'package:jewelry_ledger/models/AppSharedData.dart';
import 'package:jewelry_ledger/models/FirebaseDataModel.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  State<AddRecordsPage> createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController weightController = TextEditingController();
  TextEditingController granularController = TextEditingController();

  void onDropdownChanged(String? value) {
    Provider.of<AppSharedData>(context, listen: false)
        .updateSelectedUser(value!);
    //var firebaseService = FirebaseService();
    //firebaseService.queryEntireDatabase(context);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _showMyDialog(
      String titleText,
      String contentText,
      IconData iconData,
      Color iconColor,
      String option1,
      String option2) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(iconData, color: iconColor, size: 35),
              const SizedBox(width: 10),
              Text(titleText)
            ],
          ),
          content: Text(contentText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(option1);
              },
              child: Text(option1),
            ),
            ElevatedButton(
              child: Text(option2),
              onPressed: () {
                Navigator.of(context).pop(option2);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> onQueryDatabaseClicked() async {
    if (isBlank(dateController.text) ||
        isBlank(weightController.text) ||
        isBlank(granularController.text)) {
      _showMyDialog(
          "Empty Field",
          "At least one of the entries is empty or invalid.",
          Icons.dangerous_rounded,
          Colors.red,
          "",
          "Ok");
    } else {
      var returnValue = await _showMyDialog("Success", "All entries are valid.",
          Icons.check_box, Colors.green, "Cancel", "Add");

      log("Hello World");
      var selectedUser =
          Provider.of<AppSharedData>(context, listen: false).SelectedUserName;

      if (returnValue == "Add" && !isBlank(selectedUser)) {
        try {
          log("Hello World");
          var recordToAdd = RecordEntry(
              granular: granularController.text,
              sentDate: dateController.text,
              status: "Sent",
              weight: int.parse(weightController.text));

          var firebaseService = FirebaseService();

          bool isRecordAdded = await firebaseService.addRecord(
              selectedUser, recordToAdd, context);

          if (isRecordAdded) {
            resetEntryFields();
            Fluttertoast.showToast(
              msg: "SUCCESS!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM_LEFT,
              timeInSecForIosWeb: 2,
              backgroundColor: const Color.fromARGB(168, 187, 234, 166),
              textColor: Colors.black,
              fontSize: 16.0,
            );
            return;
          }
        } catch (e) {
          print("Exception occured.. this should not happen ever ");
        }
      }

      Fluttertoast.showToast(
        msg: "FAILURE!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_LEFT,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(168, 247, 210, 210),
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  void resetEntryFields() {
    weightController.text = "";
    granularController.text = "";
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
        RecordsEntryForm(
            dateFieldController: dateController,
            weightFieldController: weightController,
            granularFieldController: granularController,
            onQueryDatabase: onQueryDatabaseClicked)
      ],
    ));
  }
}
