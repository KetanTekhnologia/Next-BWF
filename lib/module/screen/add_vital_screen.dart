import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../databasehelper/add_patient_vital.dart';
import '../utils/string_constants.dart';

class AddPatientVital extends StatefulWidget {
  final String? patient_vital_id;
  final int doctor_id;
  final String? name;
  const AddPatientVital(
      {super.key, this.patient_vital_id, required this.doctor_id, this.name});

  @override
  State<AddPatientVital> createState() => _AddPatientVitalState();
}

class _AddPatientVitalState extends State<AddPatientVital> {
  final TextEditingController _doctorIdController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _pulseRateController = TextEditingController();
  final TextEditingController _respiratoryRateController =
      TextEditingController();
  final TextEditingController _bloodOxygenController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _bmiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _doctorIdController.text = widget.name ?? '';
  }

  void calculateBMI() {
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi = weight /
          pow(height / 100, 2); // Formula: weight (kg) / (height (m))^2
      _bmiController.text =
          bmi.toStringAsFixed(2); // Set BMI value to controller

      // Determine BMI status
      String status;
      if (bmi < 18.5) {
        status = 'Underweight';
      } else if (bmi < 25) {
        status = 'Normal';
      } else if (bmi < 30) {
        status = 'Overweight';
      } else {
        status = 'Obesity';
      }

      // Update BMI status below the BMI text field
      setState(() {
        _bmiStatus = status;
      });
    } else {
      _bmiController.text =
          ''; // Clear BMI value if height or weight is invalid
      setState(() {
        _bmiStatus = ''; // Clear BMI status
      });
    }
  }

  String _bmiStatus = ''; // Variable to store BMI status

  Future<void> submitForm() async {
    if (_doctorIdController.text.isEmpty ||
        _bloodPressureController.text.isEmpty ||
        _pulseRateController.text.isEmpty ||
        _respiratoryRateController.text.isEmpty ||
        _bloodOxygenController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _bmiController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xffBFF6F6),
            title: Text('Error'),
            content: Text('Please fill in all mandatory fields.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
      return; // Stop execution if any mandatory field is empty
    }
    Map<String, dynamic> vital = {
      'doctorName': _doctorIdController.text,
      'bloodPressure': _bloodPressureController.text,
      'pulseRate': _pulseRateController.text,
      'respiratoryRate': _respiratoryRateController.text,
      'bloodOxygen': _bloodOxygenController.text,
      'height': _heightController.text,
      'weight': _weightController.text,
      'bmi': _bmiController.text,
      'patient_uuid': widget.patient_vital_id,
    };
    print('hello');
    await DatabaseHelperVital.insertPatientVital(vital);
    print('add vital');
    print('local $vital');
    // Show a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Vitals locally inserted successfully'),
        duration: Duration(seconds: 2), // Adjust duration as needed
      ),
    );
    syncVitalsDataWithServer(widget.doctor_id, context);
    _bloodOxygenController.clear();
    _bloodPressureController.clear();
    _pulseRateController.clear();
    _respiratoryRateController.clear();
    _heightController.clear();
    _weightController.clear();
    _bmiController.clear();
    // Add any further actions after inserting data, such as navigation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Vitals',
          style: TextStyle(
            fontSize: 20,
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _doctorIdController,
              enabled: false,
              decoration: InputDecoration(labelText: 'Doctor Name '),
            ),
            TextFormField(
              controller: _bloodPressureController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Blood Pressure (BP)'),
            ),
            TextFormField(
              controller: _pulseRateController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Pulse Rate (PR)'),
            ),
            TextFormField(
              controller: _respiratoryRateController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Respiratory Rate (RR)'),
            ),
            TextFormField(
              controller: _bloodOxygenController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Blood Oxygen(SpO2)'),
            ),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateBMI(),
            ),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => calculateBMI(),
            ),
            TextFormField(
              controller: _bmiController,
              decoration: InputDecoration(labelText: 'BMI'),
              readOnly: true,
            ),
            SizedBox(height: 8),
            Text(
              'BMI Status: $_bmiStatus',
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      0xffBFF6F7), // Set the background color of the button
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void syncVitalsDataWithServer(
      int doctorId, BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      // Retrieve unsynced patients from the local database
      final unsyncedPatients =
          await DatabaseHelperVital.retrievePatientsVital();
      bool allvitalsSuccess = true;
      // Send each unsynced patient data to the server
      for (final vitals in unsyncedPatients) {
        print(unsyncedPatients);
        final success =
            await _sendVitalsDataToServer(vitals, doctorId, context);
        print(success);
        if (success) {
          print(success);
          // If data is successfully synced, delete the patient from the local database
          await DatabaseHelperVital.deletePatientVital(
              vitals['patientVitalId']);
        } else {
          allvitalsSuccess = false;
        }
      }
      if (allvitalsSuccess) {
        await DatabaseHelperVital.deleteAllVitals();
      }
    } else {
      // No network connection, you may choose to handle this case differently
    }
  }

  static Future<bool> _sendVitalsDataToServer(
      Map<String, dynamic> vital, int doctorId, BuildContext context) async {
    final baseUrl = '${Api.url}api/addVitals';

    try {
      print(vital["patient_uuid"]);
      String patientID = vital["patient_uuid"];
      String BP = vital['bloodPressure'].toString();
      int PR = vital['pulseRate'];
      int RR = vital['respiratoryRate'];
      double Ht = double.parse(vital['height'].toString()); // Parse to double
      double Wt = double.parse(vital['weight'].toString()); // Parse to double
      double Bmi = double.parse(vital['bmi'].toString()); // Parse to double
      int Spo2 = vital['bloodOxygen'];
      print(BP);
      print(PR);
      print(RR);
      print(Ht);

      // Make POST request to server
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patientID': patientID,
          'doctorID': doctorId,
          'BP': BP,
          'PR': PR,
          'RR': RR,
          'Spo2': Spo2,
          'Ht': Ht,
          'Wt': Wt,
          'Bmi': Bmi,
        }),
      );
      print(vital["patient_uuid"]);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'true' || response.statusCode == 200) {
        // Data successfully added on the server
        print('Prescription Data added on server successfully');
        print(BP);
        print(PR);
        print(RR);
        print(Ht);

        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vitals inserted to server successfully'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
        print(responseBody);
        return responseBody['status'];
      } else {
        // Failed to add data on server
        print('Failed to add data on server');
        print(
            'Failed to add data on server. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return responseBody['status'];
      }
    } catch (e) {
      // Handle any exceptions
      print('Error: $e');
      return false;
    }
  }
}
