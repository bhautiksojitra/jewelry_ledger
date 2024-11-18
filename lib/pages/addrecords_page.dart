import 'package:flutter/material.dart';
import 'package:jewelry_ledger/components/dropdown.dart';

// Add Record Page
class AddRecordPage extends StatelessWidget {
  const AddRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DropdownMenuExample(),
      ),
    );
  }
}