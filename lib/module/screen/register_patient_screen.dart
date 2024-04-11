import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../databasehelper/add_patient.dart';
import '../utils/string_constants.dart';


class PatientRegistrationScreen extends StatefulWidget {
  final String? name;
  final int doctor_id;

  const PatientRegistrationScreen(
      {super.key, required this.name, required this.doctor_id});

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
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _sexController = TextEditingController();
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
  // Add controllers for other fields
  @override
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
            .split(' ')[0]; // Format to display only date
      });
  }

  // final cities = [
  //   {"cityID": "3", "cityName": "Sakegaon"},
  //   {"cityID": "4", "cityName": "Malegaon"},
  //   {"cityID": "5", "cityName": "Babhulgaon"},
  //   {"cityID": "6", "cityName": "Sudamwadi"},
  //   {"cityID": "7", "cityName": "Hajipurwadi"},
  //   {"cityID": "8", "cityName": "Nalegaon"},
  //   {"cityID": "9", "cityName": "Achalgaon"},
  //   {"cityID": "10", "cityName": "Wawifi"},
  //   {"cityID": "11", "cityName": "Kavitkheda"},
  //   {"cityID": "12", "cityName": "Rahegaon"},
  //   {"cityID": "13", "cityName": "Bhayegaon"},
  //   {"cityID": "14", "cityName": "Undirwadi"},
  //   {"cityID": "15", "cityName": "Biloni"},
  //   {"cityID": "16", "cityName": "Wadji"},
  //   {"cityID": "17", "cityName": "Parala"},
  //   {"cityID": "18", "cityName": "Wakla"},
  //   {"cityID": "19", "cityName": "Talwada"},
  //   {"cityID": "20", "cityName": "Gangapur"},
  //   {"cityID": "21", "cityName": "Nimgaon"},
  //   {"cityID": "22", "cityName": "Kharaj"},
  //   {"cityID": "23", "cityName": "Pendephal"},
  //   {"cityID": "24", "cityName": "Ragunathpurwadi"},
  //   {"cityID": "25", "cityName": "Hajipurwadi"},
  //   {"cityID": "26", "cityName": "Talyachiwadi"},
  //   {"cityID": "27", "cityName": "Shekhapuri"},
  //   {"cityID": "28", "cityName": "Palaswadi"},
  //   {"cityID": "29", "cityName": "Aakhadwada tanda"},
  //   {"cityID": "30", "cityName": "Chincholi"},
  //   {"cityID": "31", "cityName": "Nirdudi"},
  //   {"cityID": "32", "cityName": "Lamangaon"},
  //   {"cityID": "33", "cityName": "Mhaishmal"},
  //   {"cityID": "34", "cityName": "Bhadji"},
  //   {"cityID": "35", "cityName": "Mamnapur"},
  //   {"cityID": "36", "cityName": "Sonkheda"},@@@@@
  //   {"cityID": "37", "cityName": "Loni"},
  //   {"cityID": "38", "cityName": "Gandheshwar"},
  //   {"cityID": "39", "cityName": "Bodkha"},
  //   {"cityID": "40", "cityName": "Mawsala"},
  //   {"cityID": "41", "cityName": "Salukheda"},
  //   {"cityID": "42", "cityName": "Khirdi"},
  //   {"cityID": "43", "cityName": "Dhamangaon"},
  //   {"cityID": "44", "cityName": "Tisggaon"},
  //   {"cityID": "45", "cityName": "Viramgaon"},
  //   {"cityID": "46", "cityName": "Matargaon"},
  //   {"cityID": "47", "cityName": "Devwifia"},
  //   {"cityID": "48", "cityName": "Zari"},
  //   {"cityID": "49", "cityName": "Wadgaon"},
  //   {"cityID": "50", "cityName": "Padali"},
  //   {"cityID": "51", "cityName": "Dhule"},
  //   {"cityID": "52", "cityName": "Nagpur"},
  //   {"cityID": "53", "cityName": "Nashik"}
  // ];
  String? _selectedCity;
  // Future<List<String>> _fetchCityNames() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   bool isNetworkAvailable = connectivityResult == ConnectivityResult.mobile ||
  //       connectivityResult == ConnectivityResult.wifi;
  //
  //   if (isNetworkAvailable) {
  //     final apiUrl = '${Api.url_wifi_con}getCities';
  //     final response = await http.get(Uri.parse(apiUrl));
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseData = jsonDecode(response.body);
  //       if (responseData['status'] == true) {
  //         final List<dynamic> mmuNamesData = responseData['cities'];
  //         return mmuNamesData
  //             .map((item) => item['cityName'] as String)
  //             .toList();
  //       } else {
  //         throw Exception('Failed to fetch cityName ');
  //       }
  //     } else {
  //       throw Exception('Failed to load cityName ');
  //     }
  //   } else {
  //     final List<String> CityList =
  //         cities.map((item) => item['cityName'] as String).toList();
  //     return CityList;
  //   }
  // }

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
      future: _cityListFuture, // Pass the city name
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
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
        title: Text(
          'Patients',
          style: TextStyle(
            fontSize: 20,
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Patient',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration:
              InputDecoration(labelText: 'Name', errorText: nameError),
              onChanged: (value) {
                setState(() {
                  nameError = !isValidName(value)
                      ? 'Name must contains only alphabets'
                      : null;
                });
              },
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(labelText: 'Age'),
              onChanged: (value) {
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
            TextField(
              controller: _emailController,
              decoration:
              InputDecoration(labelText: 'Email', errorText: emailError),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  emailError = !isValidEmail(value) ? 'Invalid email ' : null;
                });
              },
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password', errorText: passwordError),
              keyboardType: TextInputType.visiblePassword,
              onChanged: (value) {
                setState(() {
                  passwordError = !isValidPassword(value)
                      ? 'Password must contain atleast,\n 1) 8 characters long,\n 2) 1 special character,\n 3) 1 digit. \n 4) 1 capital character'
                      : null;
                });
              },
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                  labelText: 'Phone Number', errorText: phoneNumberError),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                setState(() {
                  phoneNumberError = !isValidPhoneNumber(value)
                      ? 'Invalid phone number '
                      : null;
                });
              },
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),

            // TextField(
            //   controller: _villageController,
            //   decoration: const InputDecoration(labelText: 'Village'),
            // ),
            // TextField(
            //   controller: _cityController,
            //   decoration: const InputDecoration(labelText: 'City'),
            //   onChanged: (value) {
            //     setState(() {
            //       cityError =
            //           !isCityNotEmpty(value) ? 'City Cannot be Empty ' : null;
            //     });
            //   },
            // ),
            _buildCityropdown(),
            DropdownButtonFormField<String>(
                value: _sexController.text.isNotEmpty &&
                    ['Male', 'Female'].contains(_sexController.text)
                    ? _sexController.text
                    : 'Select',
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (String? newValue) {
                  setState(() {
                    _sexController.text = newValue!;
                  });
                },
                items: <String>['Select', 'Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
            DropdownButtonFormField<String>(
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
              decoration: const InputDecoration(labelText: 'Blood Group'),
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

            TextField(
              controller: _birthdateController,
              readOnly: true,
              decoration: InputDecoration(
                // labelText: '$dob',
                  labelText: "Date",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Icon(Icons.calendar_month),
                  )),
            ),
            TextField(
              controller: _doctorNameController,
              enabled: false,
              decoration: const InputDecoration(labelText: 'Doctor Name'),
            ),
            TextField(
              controller: _adharNumberController,
              decoration: InputDecoration(
                  labelText: 'Adhar Number', errorText: adharNumberError),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                setState(() {
                  adharNumberError = !isValidAadharNumber(value)
                      ? 'Invalid Aadhar number format'
                      : null;
                });
              },
            ),

            TextField(
              controller: _abhaNumberController,
              decoration: InputDecoration(
                  labelText: 'Abha Number', errorText: abhaNumberError),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(14),
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (value) {
                setState(() {
                  abhaNumberError = !isValidAbhaNumber(value)
                      ? 'Invalid Abha number format'
                      : null;
                });
              },
            ),

            DropdownButtonFormField<String>(
              value: _insuranceController.text.isNotEmpty &&
                  ['Select', 'YES', 'NO']
                      .contains(_insuranceController.text)
                  ? _insuranceController.text
                  : 'Select',
              decoration: const InputDecoration(labelText: 'Insurance'),
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

            // Add fields for other data
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ElevatedButton(
                onPressed: _addPatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                      0xffBFF6F7), // Set the background color of the button
                ),
                child: Text(
                  'Add Patient',
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

  // void _onSavePressed() async {
  //   // Call the syncDataWithServer() method from DatabaseHelper
  //   await DatabaseHelper.syncDataWithServer();
  // }
  // bool isValidAadharNumber(String aadharNumber) {
  //   RegExp aadharRegex = RegExp(r'^[0-9]{12}$');
  //   return aadharRegex.hasMatch(aadharNumber);
  // }
  //

  bool isValidName(String name) {
    RegExp nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(_nameController.text) ||
        !_nameController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isValidAbhaNumber(String abhaNumber) {
    RegExp abhaRegex = RegExp(r'^[0-9]{14}$');
    return abhaRegex.hasMatch(abhaNumber);
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
    // Your email validation logic, return true if valid, false otherwise
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

  bool isValidPassword(String password) {
    RegExp passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$');
    if (!passwordRegex.hasMatch(_passwordController.text) ||
        !_passwordController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
    // Your password validation logic, return true if valid, false otherwise
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

  bool isCityNotEmpty(String city) {
    if (!_cityController.text.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void _addPatient() async {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _sexController.text.isEmpty ||
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
      'sex': _sexController.text,
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
    PatientRegistrationScreen.syncDataWithServer();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true); // Close the dialog after 2 seconds
        });
        return AlertDialog(
          backgroundColor: Color(0xffBFF6F7),
          title: Text('Success'),
          content: Text('Patient registered successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>HomeScreenDoctor()),
                // );
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
    _sexController.clear();
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
