import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jewelry_ledger/components/dropdown.dart';
import 'package:jewelry_ledger/databases/helper.dart';
import 'package:intl/intl.dart';

class AddRecordsPage extends StatefulWidget {

  const AddRecordsPage({super.key});
  
  @override
  State<AddRecordsPage> createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
    List<String> list = ["hello"];
    final FirebaseService _firebaseService = FirebaseService();
    bool isWidgetVisible = false;
    TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: DropdownMenuExample(items: list, label: "Select a name", onChanged: onDropdownChanged,)),
            
            if (isWidgetVisible)
              const SizedBox(height: 50),
            
            if (isWidgetVisible)
              SizedBox(
                width: 300,
                child: TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.calendar_today),
                    labelText: "Enter Date",
                    border: OutlineInputBorder( // Border all around
                        borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
                      ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), //get today's date
                        firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101)
                    );
                    if(pickedDate != null ){
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); // format date in required form here we use yyyy-MM-dd that means time is remove
                        setState(() {
                          dateController.text = formattedDate; //set foratted date to TextField value. 
                        });   
                    }
                  }
                ),
              ),

              if (isWidgetVisible)
                Center(child: DropdownMenuExample(items: const ["5", "6", "7", "8"], label: "How much granular?", onChanged: (value) {
                  
                },)),

              if(isWidgetVisible)
                const SizedBox(height : 20),

              if(isWidgetVisible)
                SizedBox(
                  width: 340,
                  child: TextField(
                    keyboardType: TextInputType.number, 
                    decoration: InputDecoration(
                      labelText: "Enter Weight in Grams (Limit 4 Digits)",
                      border: OutlineInputBorder( // Border all around
                        borderRadius: BorderRadius.circular(8.0), // Optional rounded corners
                      ),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly 
                    ],
                    
                  )
                )
            

          ],
      )
      
    );
  }
}
