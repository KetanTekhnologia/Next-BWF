import 'package:final_bwf/module/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'demo/stack_demo_screen.dart';
import 'module/screen/add_vital_screen.dart';
import 'module/screen/register_patient_screen.dart';
import 'module/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return  GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Border World Foundation',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          // initialRoute: AppPages.INITIAL_ROUTE,
          // getPages:AppPages.pages,
          home: StackScreen(),
         // home: SplashScreen(),
        );
      },

    );
  }
}

