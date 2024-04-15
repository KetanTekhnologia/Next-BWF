import 'package:final_bwf/module/binding/app_binding.dart';
import 'package:final_bwf/module/routes/routs.dart';
import 'package:final_bwf/module/screen/add_vital_screen.dart';
import 'package:final_bwf/module/screen/login_screen.dart';
import 'package:final_bwf/module/screen/splash_screen.dart';
import 'package:get/get.dart';
import '../screen/add_patient_screen.dart';
import '../screen/register_patient_screen.dart';

class AppPages {
  static String INITIAL_ROUTE = AppRouts.LOGIN_ROUTE;

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
      name: AppRouts.REGISTERATION_PATIENT_ROUTE,
      page: () => RegisterPatientScreen(name: "", doctor_id: 0),
      binding: AppBinding(),
    ),
    GetPage(
      name: AppRouts.ADD_PATIENT_VITAL_ROUTE,
      page: () => AddPatientVitalScreen(doctor_id: 0),
      binding: AppBinding(),
    ),
    //
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
    // GetPage(
    //   name: AppRouts.SPLASH_ROUTE,
    //   page: () => SplashScreen(),
    //   binding: AppBinding(),
    // ),
  ];
}
