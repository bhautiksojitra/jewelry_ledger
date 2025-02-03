import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RecordsEntryForm extends StatefulWidget {
  final TextEditingController dateFieldController;
  final TextEditingController weightFieldController;
  final TextEditingController granularFieldController;
  final Function() onQueryDatabase;

  const RecordsEntryForm(
      {super.key,
      required this.dateFieldController,
      required this.weightFieldController,
      required this.granularFieldController,
      required this.onQueryDatabase});

  @override
  State<RecordsEntryForm> createState() => _RecordsEntryFormState();
}

class _RecordsEntryFormState extends State<RecordsEntryForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        SizedBox(
          width: 300,
          child: TextField(
              controller: widget.dateFieldController,
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
                    widget.dateFieldController.text =
                        formattedDate; //set foratted date to TextField value.
                  });
                }
              }),
        ),
        const SizedBox(height: 20),
        SizedBox(
            width: 340,
            child: TextField(
              controller: widget.granularFieldController,
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
        const SizedBox(height: 20),
        SizedBox(
            width: 340,
            child: TextField(
              controller: widget.weightFieldController,
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
        const SizedBox(height: 30),
        ElevatedButton(
            onPressed: widget.onQueryDatabase,
            child: const Text('Validate Record')),
      ],
    );
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
