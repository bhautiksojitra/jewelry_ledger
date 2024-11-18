import 'package:flutter/material.dart';
// History Page
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('View past records here', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}