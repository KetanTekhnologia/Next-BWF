import 'package:final_bwf/module/widgets/text_fields.dart';
import 'package:flutter/material.dart';
// Assuming you have defined CustomTextField

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1988),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomTextField(
        hintText: "DOB",hintTextstyle: TextStyle(fontSize: 18),
        suffixIcon: Icon(Icons.calendar_month, color: Colors.blue),
        borderColor: Colors.white,
      //  readOnly: true,
        onTap: (){
          _selectDate();
        },
      ),
    );
  }
}