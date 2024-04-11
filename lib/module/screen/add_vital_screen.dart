import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class AddVitalScreen extends StatefulWidget {
  const AddVitalScreen({super.key});

  @override
  State<AddVitalScreen> createState() => _AddVitalScreenState();
}
class _AddVitalScreenState extends State<AddVitalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Add Vital Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
