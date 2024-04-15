import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static final String KEYLOGIN = "login";
  static final String KEYRESPONSEDATA = "response_data";
  Map<String, dynamic>? responseData;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/AppLogo.png',
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
  void checkLogin() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    // email = sharedPref.getString(KEYEMAIL) ?? '';
    // password = sharedPref.getString(KEYPASSWORD) ?? '';
    String responseDataString = sharedPref.getString(KEYRESPONSEDATA) ?? '';
    if (responseDataString.isNotEmpty) {
      responseData = jsonDecode(responseDataString);
    }
    print("stored pro $responseData");
    Timer(Duration(seconds: 2), () {
      print(isLoggedIn);
      if (isLoggedIn != null) {
        print(isLoggedIn);
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                  email: responseData?["data"]?["email"] ?? "Unknown",
                  name: responseData?["data"]?['name'] ?? 'Unknown',
                  doctor_id:
                  responseData?["data"]?["doctorID"] ?? "Unknown",
                )),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }
}
