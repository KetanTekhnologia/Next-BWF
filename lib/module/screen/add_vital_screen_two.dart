import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_bwf/module/utils/app_colors.dart';
import 'package:final_bwf/module/widgets/common_button.dart';
import 'package:final_bwf/module/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../databasehelper/add_patient_vital.dart';
import '../utils/string_constants.dart';

class AddVitalTwo extends StatefulWidget {
  final String? patient_vital_id;
  final int doctor_id;
  final String? name;
  const AddVitalTwo(
      {super.key, this.patient_vital_id, required this.doctor_id, this.name});

  @override
  State<AddVitalTwo> createState() => _AddVitalTwoState();
}

class _AddVitalTwoState extends State<AddVitalTwo> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17,horizontal: 20),
          child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CustomTextField(
                    controller: _doctorIdController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Doctor Name",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                    enabled: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _bloodPressureController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Blood Pressure (BP)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _pulseRateController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Pulse Rate (PR)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _respiratoryRateController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Respiratory Rate (RR)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _bloodOxygenController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Blood Oxygen (Sp02)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _heightController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Height (cm)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                    onChange:(_) => calculateBMI(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _weightController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "Weight (kg)",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                    onChange:(_) => calculateBMI(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                    controller: _bmiController,
                    contentPadding: EdgeInsets.only(left: 18),
                    hintText: "BMI",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    fillColor: ColorsForApp.backgroundTextField,
                    filled: true,
                    readOnly: true,
                  ),
                ),
                SizedBox(height: 9,),
                Row(
                  children: [
                    Text("BMI Status:",style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(height: 22,),
                CommonButton(onpressed: (){
                  submitForm();
                })
              ],
            ),
        ),
      )
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
