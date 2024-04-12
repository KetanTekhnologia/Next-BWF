import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:final_bwf/module/widgets/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../databasehelper/add_patient.dart';
import '../utils/app_colors.dart';
import '../utils/string_constants.dart';
import '../widgets/date_picker.dart';
import '../widgets/text_fields.dart';
import 'add_prescription_one_screen.dart';
import 'package:http/http.dart'as http;

class RegisterPatientScreen extends StatefulWidget {
  final String? name;
  final int doctor_id;
   RegisterPatientScreen({super.key, this.name, required this.doctor_id});

  static Future<void> syncDataWithServer() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      // Retrieve unsynced patients from the local database
      final unsyncedPatients = await DatabaseHelper.retrievePatients();
      bool allSuccess = true;
      // Send each unsynced patient data to the server
      for (final patient in unsyncedPatients) {
        print('local db data');
        print(unsyncedPatients);
        final success = await sendDataToServer(patient);
        print("data transfer to server");
        print(patient);
        print(success);
        if (success) {
          // Sync prescription data
          // await LocalDataPresVitalsListToServer.syncDataWithServerPresc(
          //     context, 1);
          //
          // // Sync vitals data
          // await LocalDataPresVitalsListToServer.syncVitalsDataWithServerVitals(
          //     widget.doctor_id, context);
          print(success);
          // If data is successfully synced, delete the patient from the local database
          await DatabaseHelper.deletePatient(patient['uuid']);
        } else {
          allSuccess = false;
        }
      }
      if (allSuccess) {
        await DatabaseHelper.deleteAllPatients();
      }
    } else {
      // No network connection, you may choose to handle this case differently
    }
  }
  static Future<bool> sendDataToServer(Map<String, dynamic> patient) async {
    final baseUrl = '${Api.url}api/register-patient';
    final uuid = patient['uuid'];
    final name = patient['name'];
    final email = patient['email'];
    final phone = patient['phoneNumber'];
    final doctor = patient['doctorName'];
    final address = patient['address'];
    final sex = patient['sex'];
    final birthdate = patient['birthDate'];
    final bloodgroup = patient['bloodGroup'];
    final adharNo = patient['adharNumber'];
    final abhaNo = patient['abhaNumber'];
    final insuranceCompany = patient['insurance'];
    final password = patient['password'];
    final city = patient['city'];
    final village = patient['village'];
    print(patient['uuid']);
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patientID': uuid,
          'name': name,
          'email': email,
          'password': password,
          'doctor': doctor,
          'address': address,
          'phone': phone,
          'sex': sex,
          'city': city,
          'birthdate': birthdate,
          'bloodgroup': bloodgroup,
          'adharNo': adharNo,
          'abhaNo': abhaNo,
          'insuranceCompany': insuranceCompany,
        }),
      );
      print(response.body);

      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == "true") {
        print('Data added on server successfully');
        print('Response body: ${response.body}');
        return responseBody['status'];
      } else {
        return responseBody['status'];
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}


class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _doctorNameController = TextEditingController();
  TextEditingController _adharNumberController = TextEditingController();
  TextEditingController _abhaNumberController = TextEditingController();
  TextEditingController _insuranceController = TextEditingController();
  TextEditingController _mmuIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _villageController = TextEditingController();


  void initState() {
    super.initState();
    _doctorNameController.text = widget.name ?? '';
    _cityListFuture = _fetchCityNames();
  }

  String? nameError;
  String? emailError;
  String? passwordError;
  String? phoneNumberError;
  String? abhaNumberError;
  String? adharNumberError;
  String? cityError;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null)
      setState(() {
        _birthdateController.text = picked
            .toLocal()
            .toString()
            .split(' ')[0];
      });
  }

  String? _selectedCity;

  late Future<List<String>> _cityListFuture;

  Future<List<String>> _fetchCityNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final cachedCityList = prefs.getStringList('cityList');
    if (cachedCityList != null) {
      return cachedCityList;
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    bool isNetworkAvailable = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;

    if (isNetworkAvailable) {
      final apiUrl = '${Api.url}getCities';
      final response = await http.get(Uri.parse(apiUrl));
      print("hh ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> mmuNamesData = responseData['cities'];
          final cityNames =
          mmuNamesData.map((item) => item['cityName'] as String).toList();
          prefs.setStringList('cityList', cityNames);
          return cityNames;
        } else {
          throw Exception('Failed to fetch cityName ');
        }
      } else {
        throw Exception('Failed to load cityName ');
      }
    }
    else {
      return [];
    }
  }

  Widget _buildCityropdown() {
    return FutureBuilder<List<String>>(
      future: _cityListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('No Network ');
        } else {
          return DropdownButtonFormField<String>(
            value: _selectedCity,
            itemHeight: 48,
            items: snapshot.data!.map((cityName) {
              return DropdownMenuItem<String>(
                value: cityName,
                child: Text(cityName),
              );
            }).toList(),
            onChanged: (selectedCity) {
              setState(() {
                _selectedCity = selectedCity;
                _cityController.text = selectedCity!;
              });
            },
            decoration: InputDecoration(labelText: 'City'),
          );
        }
      },
    );
  }

  String dob = '';
  void convertToDOB(int age) {
    DateTime now = DateTime.now();
    DateTime dobDate = DateTime(now.year - age, now.month, now.day);
    setState(() {
      _birthdateController.text = DateFormat('yyyy-MM-dd').format(dobDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF7F7F7),
          leading: const Icon(Icons.arrow_back),
          title: const Text("Patient Details"),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.search),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            child: Column(
              children: [
                CustomTextField(
                    controller: _nameController,
                    hintText: "Name",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    filled: true,
                    fillColor: ColorsForApp.backgroundTextField,
                    contentPadding: EdgeInsets.only(left: 18),
                    validator: (value){
                      if(value!.isEmpty)
                        {
                          return "Name must contains only alphabets";
                        }
                    },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _ageController,
                      hintText: "Age",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value) {
                        int age = int.tryParse(_ageController.text) ?? 0;
                        if (age > 0) {
                          convertToDOB(age);
                        } else {
                          setState(() {
                            dob = 'Invalid age';
                          });
                        }
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _emailController,
                      hintText: "Email",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value) {
                        setState(() {
                          emailError = !isValidEmail(value!) ? 'Invalid email ' : null;
                        });
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _passwordController,
                      hintText: "Password",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value) {
                        setState(() {
                          passwordError = !isValidPassword(value!)
                              ? 'Password must contain atleast,\n 1) 8 characters long,\n 2) 1 special character,\n 3) 1 digit. \n 4) 1 capital character'
                              : null;
                        });
                      }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CustomTextField(
                      controller: _phoneNumberController,
                      hintText: "Phone Number",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value) {
                        setState(() {
                          phoneNumberError = !isValidPhoneNumber(value!)
                              ? 'Invalid phone number '
                              : null;
                        });
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _addressController,
                      hintText: "Address",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value){
                        if(value!.isEmpty)
                          {
                            return "Please Enter Address";
                          }
                     },
                  ),
                ),


                _buildCityropdown(),


                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                    controller: _addressController,
                    hintText: "Gender",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    filled: true,
                    fillColor: ColorsForApp.backgroundTextField,
                    contentPadding: EdgeInsets.only(left: 18),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "Please Enter Gender";
                      }
                    },
                    suffixIcon: DropdownButton<String>(
                        value: _genderController.text.isNotEmpty &&
                            ['Male', 'Female'].contains(_genderController.text)
                            ? _genderController.text
                            : 'Select',
                        onChanged: (String? newValue) {
                          setState(() {
                            _genderController.text = newValue!;
                          });
                        },
                        items: <String>['Select', 'Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                    controller: _addressController,
                    hintText: "Blood Group",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    filled: true,
                    fillColor: ColorsForApp.backgroundTextField,
                    contentPadding: EdgeInsets.only(left: 18),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "Please Enter Blood Group";
                      }
                    },
                    suffixIcon: DropdownButton<String>(
                        value: _bloodGroupController.text.isNotEmpty &&
                            [
                              'Select',
                              'A+',
                              'A-',
                              'B+',
                              'B-',
                              'AB+',
                              'AB-',
                              'O+',
                              'O-'
                            ].contains(_bloodGroupController.text)
                            ? _bloodGroupController.text
                            : 'Select',
                        onChanged: (String? newValue) {
                          setState(() {
                            _bloodGroupController.text = newValue!;
                          });
                        },
                      items: <String>[
                        'Select',
                        'A+',
                        'A-',
                        'B+',
                        'B-',
                        'AB+',
                        'AB-',
                        'O+',
                        'O-'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 19, right: 10),
                        child: CustomTextField(
                          controller: _birthdateController,
                          hintText: "DOB",
                          readOnly: true,
                          hintTextColor: Colors.black.withOpacity(0.8),
                          filled: true,
                          fillColor: ColorsForApp.backgroundTextField,
                          contentPadding: EdgeInsets.only(left: 18),
                          suffixIcon: GestureDetector(
                            onTap: (){
                              _selectDate(context);
                            },
                              child: Icon(Icons.calendar_month_sharp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _doctorNameController,
                      enabled: false,
                      hintText: "Doctor Name",
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _adharNumberController,
                      hintText: "Aadhaar Number",
                      keyboardType: TextInputType.phone,
                      // inputFormatters: [
                      //   LengthLimitingTextInputFormatter(12),
                      //   FilteringTextInputFormatter.digitsOnly
                      // ],
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator: (value) {
                        setState(() {
                          adharNumberError = !isValidAadharNumber(value!)
                              ? 'Invalid Aadhar number format'
                              : null;
                        });
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                      controller: _abhaNumberController,
                      hintText: "Abha Number",
                      errorText: adharNumberError,
                      hintTextColor: Colors.black.withOpacity(0.8),
                      filled: true,
                      fillColor: ColorsForApp.backgroundTextField,
                      contentPadding: EdgeInsets.only(left: 18),
                      validator:  (value) {
                        setState(() {
                          abhaNumberError = !isValidAbhaNumber(value!)
                              ? 'Invalid Abha number format'
                              : null;
                        });
                      },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CustomTextField(
                    controller: _addressController,
                    hintText: "Insurance",
                    hintTextColor: Colors.black.withOpacity(0.8),
                    filled: true,
                    fillColor: ColorsForApp.backgroundTextField,
                    contentPadding: EdgeInsets.only(left: 18),
                    validator: (value){
                      if(value!.isEmpty)
                      {
                        return "Please Enter Confirmation";
                      }
                    },
                    suffixIcon: DropdownButton<String>(
                        value: _insuranceController.text.isNotEmpty &&
                            ['Select', 'YES', 'NO']
                                .contains(_insuranceController.text)
                            ? _insuranceController.text
                            : 'Select',
                        onChanged: (String? newValue) {
                          setState(() {
                            _insuranceController.text = newValue!;
                          });
                        },
                      items: <String>['Select', 'YES', 'NO']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 19),
                  child: CommonButton(onpressed: (){
                    _addPatient();
                  },),
                )
              ],
            ),
          ),
        )
        );
  }

  bool isValidEmail(String email) {
    RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(_emailController.text) ||
        !_emailController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidPassword(String password) {
    RegExp passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$');
    if (!passwordRegex.hasMatch(_passwordController.text) ||
        !_passwordController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }


  bool isValidPhoneNumber(String phoneNumber) {
    RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(_phoneNumberController.text) ||
        !_phoneNumberController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidAadharNumber(String aadharNumber) {
    RegExp adharRegex = RegExp(r'^[0-9]{12}$');
    if (!adharRegex.hasMatch(_adharNumberController.text) ||
        !_adharNumberController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
    // Your email validation logic, return true if valid, false otherwise
  }

  bool isCityNotEmpty(String city) {
    if (!_cityController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidAbhaNumber(String abhaNumber) {
    RegExp abhaRegex = RegExp(r'^[0-9]{14}$');
    return abhaRegex.hasMatch(abhaNumber);
  }

  void _addPatient() async {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _birthdateController.text.isEmpty ||
        _adharNumberController.text.isEmpty) {
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
    String uuid = 'm-' + Uuid().v4();
    Map<String, dynamic> patient = {
      'uuid': uuid,
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'email': _emailController.text.isNotEmpty ? _emailController.text : null,
      'address':
      _addressController.text.isNotEmpty ? _addressController.text : null,
      'phoneNumber': _phoneNumberController.text.isNotEmpty
          ? _phoneNumberController.text
          : null,
      'password':
      _passwordController.text.isNotEmpty ? _passwordController.text : null,
      'village':
      _villageController.text.isNotEmpty ? _villageController.text : null,
      'city': _cityController.text.isNotEmpty ? _cityController.text : null,
      'sex': _genderController.text,
      'bloodGroup': _bloodGroupController.text.isNotEmpty
          ? _bloodGroupController.text
          : null,
      'birthDate': _birthdateController.text.isNotEmpty
          ? _birthdateController.text
          : null,
      'doctorName': _doctorNameController.text,
      'adharNumber': _adharNumberController.text.isNotEmpty
          ? _adharNumberController.text
          : null,
      'abhaNumber': _abhaNumberController.text.isNotEmpty
          ? _abhaNumberController.text
          : null,
      'insurance': _insuranceController.text.isNotEmpty
          ? _insuranceController.text
          : null,
      'mmuId': _mmuIdController.text
      // Add other fields here
    };

    await DatabaseHelper.insertPatient(patient);
    print('Data Inserted');
    print(patient['name']);
    print(patient['birthDate']);
    print(patient);

// Call function to send data to server
    RegisterPatientScreen.syncDataWithServer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          backgroundColor: Color(0xffBFF6F7),
          title: Text('Success'),
          content: Text('Patient registered successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {

              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    setState(() {});
    _nameController.clear();
    _ageController.clear();
    _emailController.clear();
    _addressController.clear();
    _phoneNumberController.clear();
    _genderController.clear();
    _bloodGroupController.clear();
    _birthdateController.clear();
    _adharNumberController.clear();
    _abhaNumberController.clear();
    _insuranceController.clear();

    _cityController.clear();
    _villageController.clear();
    _passwordController.clear();
  }

}
