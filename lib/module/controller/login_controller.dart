import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginController extends GetxController {

  RxBool passwordObsecured = false.obs;

  TextEditingController passwordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  String errorMessage = '';

  //*********************************************************************//

  static const String baseUrl =
      "http://103.239.171.133:8001/api/doctor/login";

  Future<Map<String, dynamic>> signIn(String userEmail, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': userEmail,
          'password': password,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print("test2");
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print('Failed to login user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to login user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Failed to login user. Exception: $e');
    }
  }
}
