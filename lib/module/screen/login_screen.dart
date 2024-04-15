import 'dart:convert';

import 'package:final_bwf/module/screen/splash_screen.dart';
import 'package:final_bwf/module/widgets/common_button.dart';
import 'package:final_bwf/module/widgets/constant_widgets.dart';
import 'package:final_bwf/module/widgets/text_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../controller/login_controller.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formSignInKey = GlobalKey<FormState>();

  LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Padding(
                padding:EdgeInsets.symmetric(vertical: 17.sp,horizontal: 17.sp),
                child: Column(
                  children: [
                    Form(
                      key: _formSignInKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login Here !!',
                                    style: TextStyle(
                                      fontSize: 18.0.sp,
                                      fontWeight: FontWeight.w800,
                                      color:ColorsForApp.textColor2,
                                    ),
                                  ),
                                  SizedBox(height: 1.h,),
                                  Text(
                                    'Welcome Back You Have Been Missed.',
                                    style: TextStyle(
                                      fontSize: 11.0.sp,
                                      fontWeight: FontWeight.w500,
                                      color:ColorsForApp.textColor2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h,),
                          Container(
                            height: 20.h,
                            width: 33.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/AppLogo.png"))
                            ),
                          ),
                            SizedBox(
                            height: 1.0.h,
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: 5.sp),
                            child: CustomTextField(
                              controller:loginController.userEmailController,
                              hintText: 'Enter Your Email',
                              hintTextColor: Colors.black.withOpacity(0.8),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your mail';
                                }
                                return null;
                              },
                            ),
                          ),
                           Padding(
                            padding:  EdgeInsets.only(top: 30.sp),
                            child: CustomTextField(
                              controller: loginController.passwordController,
                              hintText: 'Enter Your Password',
                              hintTextColor: Colors.black.withOpacity(0.8),
                              obscureText: loginController.passwordObsecured.value,
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    loginController.passwordObsecured.value =! loginController.passwordObsecured.value;
                                  });
                                },
                                  child: loginController.passwordObsecured.value ?Icon(Icons.remove_red_eye,color: Colors.black,): Icon(Icons.visibility_off,color: Colors.black,)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                           SizedBox(
                            height: 1.5.h,
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: 18.sp),
                            child: CommonButton(
                                buttonText: "Login",
                                onpressed: () async {
                                  if(_formSignInKey.currentState!.validate())
                                    {
                                      try {
                                        final Map<String, dynamic> responseData =
                                        await loginController.signIn(
                                          loginController.userEmailController.text,
                                          loginController.passwordController.text,
                                        );
                                        print(responseData);
                                        if (responseData['status'] == true) {
                                          var sharedPref =
                                          await SharedPreferences.getInstance();
                                          sharedPref.setBool(
                                              SplashScreenState.KEYLOGIN, true);
                                          sharedPref.setString(
                                              'response_data', jsonEncode(responseData));
                                          print('Login successful: $responseData');
                                          // Credentials are valid
                                          print('Login successful: $responseData');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeScreen(
                                                  email: responseData["data"]["email"],
                                                  name: responseData["data"]['name'] ??
                                                      'Unknown',
                                                  doctor_id: responseData["data"]
                                                  ["doctorID"],
                                                )),
                                          );
                                        } else {
                                          setState(() {
                                            // Clear any previous error message
                                            loginController.errorMessage =
                                            'Invalid credentials. Please try again.';
                                          });
                                          // Credentials are invalid
                                          print(
                                              "Server message: ${responseData['message']}");
                                        }
                                      }
                                      catch (error) {
                                        // Handle registration error (e.g., show an error message)
                                        print('Error during login: $error');
                                      }
                                    }

                                  },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 30.h,
            width: 100.w,
            // color: Colors.pink,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/LoginScreenDesign.png"),fit: BoxFit.cover)
            ),
          )
        ],
      ),
    );
  }
}
