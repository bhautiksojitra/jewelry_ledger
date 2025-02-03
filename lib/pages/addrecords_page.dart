import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/components/record_entry_form.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  State<AddRecordsPage> createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  List<String> list = ["hello"];
  final FirebaseService _firebaseService = FirebaseService();
  bool isWidgetVisible = false;
  String selectedName = "";
  TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController weightController = TextEditingController();
  TextEditingController granularController = TextEditingController();

  void onDropdownChanged(String? value) {
    setState(() {
      isWidgetVisible = value != null;
      selectedName = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPersons();
    setState(() {});
  }

  Future<void> fetchPersons() async {
    final fetchedPersons = await _firebaseService.fetchPersons();

    setState(() {
      var persons = fetchedPersons;
      list = persons.map((person) => person['name'] as String).toList();
    });
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

      if (returnValue == "Add" && !isBlank(selectedName)) {
        bool isRecordAdded = await _firebaseService.addRecord(
            selectedName,
            dateController.text,
            weightController.text,
            granularController.text);

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
            child: DropdownMenuExample(
          items: list,
          label: "Select a name",
          onChanged: onDropdownChanged,
        )),
        if (isWidgetVisible)
          RecordsEntryForm(
              dateFieldController: dateController,
              weightFieldController: weightController,
              granularFieldController: granularController,
              onQueryDatabase: onQueryDatabaseClicked)
      ],
    ));
  }
}
