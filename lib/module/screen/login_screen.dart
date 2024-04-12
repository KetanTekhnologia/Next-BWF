import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/login_controller.dart';
import '../utils/app_colors.dart';
import '../utils/text_style.dart';
import '../widgets/common_button.dart';
import '../widgets/text_fields.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginController loginController = Get.find();

  TextEditingController passwordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();

  String errorMessage = '';


  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Column(
          children: [
            SizedBox(height: 8.80.h,),
            Padding(
              padding: EdgeInsets.symmetric( horizontal: 6.w),
              child: Column(
                children: [
                  Form(
                    key: loginKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Login Here",
                                  style: TextHelper.size20.copyWith(fontSize: 28, fontWeight: FontWeight.w600, color:Color(0xff7E7E7E)),
                                ),
                                Text("Welcome back you’ve been missed",
                                  style: TextHelper.size20.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color:Color(0xff7E7E7E)),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0.h,),
                        Container(
                          height: 10.h,
                          width: 27.w,
                         decoration: BoxDecoration(
                           image: DecorationImage(
                               image:AssetImage("assets/images/BWFLogo.png",),fit:BoxFit.cover)
                         ),
                        ),
                        SizedBox(height: 4.h),

                        // const Row(
                        //   children: [
                        //     Text("Username",
                        //         style: TextStyle(fontWeight: FontWeight.w600)),
                        //   ],
                        // ),

                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: CustomTextField(
                            controller:userEmailController,
                            prefixIcon: Icon(Icons.person),
                            hintText: "Type Your Username",
                            hintTextColor: Colors.black.withOpacity(0.6),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Username";
                              }
                              return null;
                            }, hintTextstyle: TextStyle(),
                          ),
                        ),
                        SizedBox(height: 5.h),

                        // Row(
                        //   children: [
                        //     Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
                        //   ],
                        // ),

                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: CustomTextField(
                            controller: passwordController,
                            prefixIcon: Icon(Icons.lock_outline_sharp),
                            hintText: "Type Your password",
                            hintTextColor: Colors.black.withOpacity(0.6),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  loginController.passwordObsecured.value =! loginController.passwordObsecured.value;
                                });
                              },
                              icon: Icon(
                                loginController.passwordObsecured.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Password";
                              }
                              return null;
                            }, hintTextstyle: TextStyle(),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              child: Text(
                                "Forgot password",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, "forget_screen");
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.sp),
              child: CommonButton(
                buttonText: "Sign in",
                onpressed: () async {
                    try {
                      final Map<String, dynamic> responseData =
                          await loginController.signIn(
                        userEmailController.text,
                        passwordController.text,
                      );
                      print(responseData);
                      if (responseData['status'] == true) {
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
                          errorMessage =
                          'Invalid credentials. Please try again.';
                        });
                        // Credentials are invalid
                        print(
                            "Server message: ${responseData['message']}");
                      }
                    } catch (error) {
                      // Handle registration error (e.g., show an error message)
                      print('Error during login: $error');
                    }
                  },
              ),
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset("assets/images/LoginScreenDesign.png", height: 38.95.h, width: 100.w, fit: BoxFit.fill),
                ],
              ),
            ),
            ],

        ),
    );
  }
}
