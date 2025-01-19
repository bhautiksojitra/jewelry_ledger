import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/components/record_entry_form.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  State<AddRecordsPage> createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  List<String> list = ["hello"];
  final FirebaseService _firebaseService = FirebaseService();
  bool isWidgetVisible = false;
  TextEditingController dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  TextEditingController weightController = TextEditingController();
  TextEditingController granularController = TextEditingController();

  void onDropdownChanged(String? value) {
    setState(() {
      isWidgetVisible = value != null;
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

  Future<void> _showMyDialog(String titleText, String contentText,
      IconData iconData, Color iconColor) async {
    return showDialog<void>(
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
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
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
          "At least one of the entries is empty or invalid",
          Icons.dangerous_rounded,
          Colors.red);
    } else {
      _firebaseService.addRecord("tempname", dateController.text,
          weightController.text, granularController.text);
      //_showMyDialog("Success", "You are done!", Icons.check_box, Colors.green);
      // TO DO : add to database
    }
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
