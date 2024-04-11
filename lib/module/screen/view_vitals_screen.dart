import 'package:flutter/material.dart';

import '../utils/text_style.dart';
class ViewVitalScreen extends StatefulWidget {
  const ViewVitalScreen({super.key});

  @override
  State<ViewVitalScreen> createState() => _ViewVitalScreenState();
}
class _ViewVitalScreenState extends State<ViewVitalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(" View Vitals Screen",style: TextHelper.h3,))
        ],),
    );
  }
}
