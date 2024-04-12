import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/app_colors.dart';
import '../utils/text_style.dart';


SizedBox height(double h) => SizedBox(height: h);

SizedBox width(double w) => SizedBox(width: w);

class CommonButton extends StatelessWidget {

  final void Function() onpressed;
  final String? buttonText;
  final double? height;
  final double? width;
  final TextStyle? style;
  final Color? buttonColor;
  final Color? buttonTextColor;
  const CommonButton({
     super.key,
     required this.onpressed,
     this.buttonText,
     this.height,
     this.width,
     this.style,
     this.buttonColor,
     this.buttonTextColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onpressed,
        child: Container(
          height:height?? 5.5.h,
          width: width?? 100.w,
          decoration: BoxDecoration(
            color: buttonColor?? ColorsForApp.buttonBackgroundColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: Colors.white,
              width: 1,
              //strokeAlign: BorderSide.strokeAlignCenter
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsForApp.greyColor.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(1, 1)
              )
            ]
          ),
          child: Center(child: Text(buttonText ?? "Common Button", style: style?? TextHelper.h7.copyWith(color: Colors.white,fontWeight: FontWeight.w600),))
        ),
    );
  }
}
