import 'package:flutter/material.dart';
// Active Records Page
class ActiveRecordsPage extends StatelessWidget {
  const ActiveRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('List of active records', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}