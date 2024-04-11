import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/string_constants.dart';
class PatientRegisterationController extends GetxController
{

     Future<RxBool> sendDataToServer(Map<String, dynamic> patient) async {
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
      return false.obs;
    }
  }

}