import 'package:final_bwf/module/utils/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class StackScreen extends StatefulWidget {
  @override
  State<StackScreen> createState() => _StackScreenState();
}

class _StackScreenState extends State<StackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical:20.sp,horizontal: 20.sp ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 320.sp,
                    child: Container(
                      width:100.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.sp),
                          image: DecorationImage(
                            image: AssetImage("assets/images/HomeDoctorBackground.png"),
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 178.sp,
                    right: 120.sp,
                    child: Container(
                      width: 50.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/DoctorImage.png"))
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 248.sp,
                    left: 83.sp,
                    child: Container(
                      width: 80.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage("assets/images/DoctorThaughts.png"))
                      ),
                    ),
                  ),
                  Positioned(
                    top: 270.sp,
                    left: 15.sp,
                    child: Container(
                      height:13.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                          color:Color(0xff489CF8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 2.h,),
                          Text("Your AchieveMent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15.sp),),
                          Text("20",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18.sp)),
                          Text("Total Patients",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15.sp)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50.sp,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.sp, horizontal: 8.sp),
                      child: Container(
                        height:15.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                            color:Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5.h,),
                            // Text("Your AchieveMent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),
                            //  Container(
                            //    height: 45,
                            //    width: 45,
                            //  decoration: BoxDecoration(
                            //    image: DecorationImage(
                            //        image: AssetImage("assets/images/NewRegistration.png"))
                            //  ),
                            //  ),
                            Text("Patient",style: TextHelper.h2.copyWith(color: Colors.red)),
                            Text("List",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50.sp,
                    left: 120.sp,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.sp, horizontal: 8.sp),
                      child: Container(
                        height:15.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                            color:Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 2,
                                spreadRadius: 2,
                              )
                            ]
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5.h,),
                            // Text("Your AchieveMent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20),),
                            //  Container(
                            //    height: 45,
                            //    width: 45,
                            //  decoration: BoxDecoration(
                            //    image: DecorationImage(
                            //        image: AssetImage("assets/images/NewRegistration.png"))
                            //  ),
                            //  ),
                            Text("Patient",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15.sp)),
                            Text("List",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
