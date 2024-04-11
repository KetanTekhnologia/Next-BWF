import 'package:final_bwf/module/binding/app_binding.dart';
import 'package:final_bwf/module/routes/routs.dart';
import 'package:final_bwf/module/screen/login_screen.dart';
import 'package:final_bwf/module/screen/register_patient_screen.dart';
import 'package:final_bwf/module/screen/splash_screen.dart';
import 'package:get/get.dart';

import '../screen/add_patient_screen.dart';

class AppPages {
  static String INITIAL_ROUTE = AppRouts.PATIENT_REGISTERATION_ROUTE;

  static final pages = [
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.ADD_PATIENT_ROUTE,
      page: () => AddPatientScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.LOGIN_ROUTE,
      page: () => LoginScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.PATIENT_REGISTERATION_ROUTE,
      page: () => PatientRegistrationScreen(name: "", doctor_id: 0),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.SPLASH_ROUTE,
      page: () => SplashScreen(),
      binding: AppBinding(),
    ),
  ];
}
