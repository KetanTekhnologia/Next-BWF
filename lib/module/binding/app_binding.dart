
import 'package:final_bwf/module/controller/add_patient_controller.dart';
import 'package:final_bwf/module/controller/add_prescription_controller_one.dart';
import 'package:final_bwf/module/controller/add_prescription_controller_two.dart';
import 'package:final_bwf/module/controller/add_vital_controller.dart';
import 'package:final_bwf/module/controller/home_controller.dart';
import 'package:final_bwf/module/controller/login_controller.dart';
import 'package:final_bwf/module/controller/my_profile_controller.dart';
import 'package:final_bwf/module/controller/patient_details_controller.dart';
import 'package:final_bwf/module/controller/patient_list_controller.dart';
import 'package:final_bwf/module/controller/prescription_details_controller.dart';
import 'package:final_bwf/module/controller/update_patient_controller.dart';
import 'package:final_bwf/module/controller/view_vital_controller.dart';
import 'package:final_bwf/module/screen/add_vital_screen.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class AppBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut(() => SpashController());
    Get.lazyPut(() => AddPatientController());
    Get.lazyPut(() => AddPrescriptionControllerOne());
    Get.lazyPut(() => AddPrescriptionControllerTwo());
    Get.lazyPut(() => AddVitalController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => MyProfileController());
    Get.lazyPut(() => PatientDetailsController());
    Get.lazyPut(() => PatientListController());
    Get.lazyPut(() => PrescriptionDetailsController());
    Get.lazyPut(() => UpdatePatientController());
    Get.lazyPut(() => ViewVitalController());
  }
}