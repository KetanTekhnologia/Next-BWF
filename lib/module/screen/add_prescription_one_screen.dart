import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class AddPrescriptionOneScreen extends StatefulWidget {
  const AddPrescriptionOneScreen({super.key});

  @override
  State<AddPrescriptionOneScreen> createState() => _AddPrescriptionOneScreenState();
}
class _AddPrescriptionOneScreenState extends State<AddPrescriptionOneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Add Prescription One Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
