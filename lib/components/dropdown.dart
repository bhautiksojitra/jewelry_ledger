import 'package:flutter/material.dart';
import 'package:jewelry_ledger/databases/helper.dart';

class DropdownMenuExample extends StatefulWidget {
  
  final List<String> items;
  final String label;
  final ValueChanged<String?> onChanged;
  
  DropdownMenuExample({super.key, required this.items, required this.label, required this.onChanged});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample>
{
  late String selectedValue;

   @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Define the screen width and thresholds
    double screenWidth = MediaQuery.of(context).size.width;
    double minWidth = 200; // Minimum width
    double maxWidth = 400; // Maximum width

    // Calculate dynamic width within the thresholds
    double dynamicWidth = screenWidth * 0.8; // 80% of screen width
    double finalWidth = dynamicWidth.clamp(minWidth, maxWidth);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SizedBox(child: DropdownMenu<String>(
                label: Text(widget.label),
                width: finalWidth,
                onSelected: (String? value) {
                  setState(() {
                    selectedValue = value!;
                  });
                  widget.onChanged(value);
                },
                dropdownMenuEntries: widget.items.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
    ),
    )
      ],
    )
      ;
  }
}