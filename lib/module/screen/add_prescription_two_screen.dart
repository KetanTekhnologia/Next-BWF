import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class AddPrescriptionTwoScreen extends StatefulWidget {
  const AddPrescriptionTwoScreen({super.key});
  @override
  State<AddPrescriptionTwoScreen> createState() => _AddPrescriptionTwoScreenState();
}
class _AddPrescriptionTwoScreenState extends State<AddPrescriptionTwoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Add Prescription Two Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
