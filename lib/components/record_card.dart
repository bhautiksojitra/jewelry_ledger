import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final String weightText;
  final String dateText;
  final String granularText;

  const RecordCard(
      {Key? key,
      required this.weightText,
      required this.dateText,
      required this.granularText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the screen width and thresholds
    double screenWidth = MediaQuery.of(context).size.width;
    double minWidth = 200; // Minimum width
    double maxWidth = 400; // Maximum width

    // Calculate dynamic width within the thresholds
    double dynamicWidth = screenWidth * 0.8; // 80% of screen width
    double finalWidth = dynamicWidth.clamp(minWidth, maxWidth);
    return Card(
      margin: const EdgeInsets.only(top: 25.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              weightText,
            ),
            Text(granularText),
            SizedBox(
              height: 5,
              width: finalWidth,
            ),
          ],
        ),
      ),
    );
  }
}
