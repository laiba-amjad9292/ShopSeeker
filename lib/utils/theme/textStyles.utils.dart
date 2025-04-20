import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';

TextStyle stylew700({double size = 16, color}) {
  return TextStyle(
    color: color ?? AppColors.primary,
    fontSize: size.sp,
    fontWeight: FontWeight.w700,
  );
}

TextStyle stylew600({double size = 16, color}) {
  return TextStyle(
    color: color ?? AppColors.color1C1B1B,
    fontSize: size.sp,
    fontWeight: FontWeight.w600,
  );
}

TextStyle stylew500({double size = 16, color}) {
  return TextStyle(
    color: color ?? AppColors.color263238,
    fontSize: size.sp,
    fontWeight: FontWeight.w500,
  );
}

TextStyle styleRegular({double size = 16, color}) {
  return TextStyle(
    fontFamily: "jakarta-regular",
    color: color ?? AppColors.black,
    fontSize: size.sp,
    fontWeight: FontWeight.normal,
  );
}

TextStyle stylew400({double size = 16, Color? color}) {
  return TextStyle(
    fontFamily: "jakarta-light",
    fontSize: size.sp,
    color: color ?? AppColors.white,
    fontWeight: FontWeight.w400,
  );
}

TextStyle styleRegularUnderline({double size = 13, color}) {
  final effectiveColor = color ?? AppColors.colorAAAAAA;
  return TextStyle(
    fontFamily: "jakarta-regular",
    color: effectiveColor,
    fontSize: size.sp,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.underline,
    decorationColor: effectiveColor,
  );
}
