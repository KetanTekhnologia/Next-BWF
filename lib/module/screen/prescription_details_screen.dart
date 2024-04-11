
import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class PrescriptionDetailsScreen extends StatefulWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  State<PrescriptionDetailsScreen> createState() => _PrescriptionDetailsScreenState();
}
class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text("Prescription Details Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
