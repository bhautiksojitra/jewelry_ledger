import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
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
    //fetchPersons();
    setState(() {
      list = ["hello"];
    });
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
      _showMyDialog("Success", "You are done!", Icons.check_box, Colors.green);
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
        if (isWidgetVisible) const SizedBox(height: 50),
        if (isWidgetVisible)
          SizedBox(
            width: 300,
            child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText: "Enter Date",
                  border: OutlineInputBorder(
                    // Border all around
                    borderRadius:
                        BorderRadius.circular(8.0), // Optional rounded corners
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is remove
                    setState(() {
                      dateController.text =
                          formattedDate; //set foratted date to TextField value.
                    });
                  }
                }),
          ),
        if (isWidgetVisible) const SizedBox(height: 20),
        if (isWidgetVisible)
          SizedBox(
              width: 340,
              child: TextField(
                controller: granularController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "How much Granular?",
                  border: OutlineInputBorder(
                    // Border all around
                    borderRadius:
                        BorderRadius.circular(8.0), // Optional rounded corners
                  ),
                ),
                inputFormatters: <TextInputFormatter>[
                  CustomRangeTextInputFormatter(0, 20),
                  FilteringTextInputFormatter.digitsOnly
                ],
              )),
        if (isWidgetVisible) const SizedBox(height: 20),
        if (isWidgetVisible)
          SizedBox(
              width: 340,
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Weight in Grams (Limit 4 Digits)",
                  border: OutlineInputBorder(
                    // Border all around
                    borderRadius:
                        BorderRadius.circular(8.0), // Optional rounded corners
                  ),
                ),
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly
                ],
              )),
        if (isWidgetVisible) const SizedBox(height: 30),
        if (isWidgetVisible)
          ElevatedButton(
              onPressed: onQueryDatabaseClicked,
              child: const Text('Query Database')),
      ],
    ));
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  CustomRangeTextInputFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null || value < min || value > max) {
      // If the value is invalid, revert to the old value
      return oldValue;
    }

    // Otherwise, allow the new value
    return newValue;
  }
}
