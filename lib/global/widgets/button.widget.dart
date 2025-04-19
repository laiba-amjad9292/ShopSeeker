import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/app_theme.utils.dart';

class AppButton extends StatelessWidget {
  final String title;
  final double height;
  final double? width;
  final double elevation;
  final double? borderRadius;
  final double fontSize;
  final Color? color;
  final BorderSide? borderSide;
  final Color fontColor;
  final Function onTap;
  final bool isLoading;
  final FontWeight fontWeight;
  final Widget? icon;
  final bool? isDisabled;
  final bool isIconLeading;
  final EdgeInsetsGeometry? padding;
  final Color? disabledColor;
  final Color? disabledFontColor;

  const AppButton({
    Key? key,
    this.color,
    this.padding,
    this.fontColor = Colors.white,
    this.borderSide,
    this.icon,
    this.height = 46,
    this.elevation = 0,
    this.fontWeight = FontWeight.w500,
    this.width,
    this.borderRadius = 8,
    this.fontSize = 16,
    this.isLoading = false,
    this.isIconLeading = false,
    required this.title,
    required this.onTap,
    this.isDisabled,
    this.disabledColor,
    this.disabledFontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled ?? false,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SizedBox(
          width: width?.toDouble().w ?? 1.sw,
          height: height.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              surfaceTintColor:
                  isDisabled == true
                      ? disabledColor ?? AppColors.disabledColor
                      : color ??
                          (isDisabled == true
                              ? disabledColor ?? AppColors.disabledColor
                              : AppColors.primary),

              padding: padding ?? EdgeInsets.zero,
              elevation: elevation,
              backgroundColor: backGroundColor,
              shape: RoundedRectangleBorder(
                side: borderSide ?? BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadius?.r ?? 8),
              ),
              minimumSize: Size(width?.toDouble().w ?? 1.sw, height.h),
              // width: width?.toDouble() ?? 1.sw,
              alignment: Alignment.center,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            onPressed:
                isDisabled == true
                    ? () {}
                    : () {
                      FocusScope.of(Get.context!).requestFocus(FocusNode());
                      onTap();
                    },
            child: Center(
              child:
                  icon == null
                      ? AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        style: stylew600(
                          size: height == 36 ? 12 : fontSize,
                          color: fontColor,
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isIconLeading) icon!,
                          AutoSizeText(
                            title,
                            textAlign: TextAlign.center,
                            style: stylew600(
                              size: height == 36 ? 12 : fontSize,
                              color: fontColor,
                            ),
                          ),
                          if (!isIconLeading) icon!,
                        ],
                      ),
            ),
          ),
        ),
      ),
    );
  }

  bool get buttonDisabled {
    // change color when making app
    return color == AppColors.colorAAAAAA || isDisabled == true;
  }

  Color get textButtonColor {
    if (buttonDisabled) {
      return AppColors.white;
    } else {
      return fontColor;
    }
  }

  Color get backGroundColor {
    if (buttonDisabled) {
      return disabledColor ?? AppColors.disabledColor;
    } else {
      return color ?? AppColors.primary;
    }
  }
}
