
import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class UpdatePatientScreen extends StatefulWidget {
  const UpdatePatientScreen({super.key});

  @override
  State<UpdatePatientScreen> createState() => _UpdatePatientScreenState();
}
class _UpdatePatientScreenState extends State<UpdatePatientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Update Patient Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
