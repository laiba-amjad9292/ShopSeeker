import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class NoItemFound extends StatelessWidget {
  final String? heading;
  final String? subheading;
  final Widget? image;
  final Function()? onPrimaryClick; // Updated to Function()? to handle nullable
  final String? primaryButtonTitle;
  final String? secondaryButtonTitle;
  final Function()?
  onSecondaryClick; // Updated to Function()? to handle nullable

  const NoItemFound({
    super.key,
    this.heading,
    this.subheading,
    this.image,
    this.onPrimaryClick,
    this.onSecondaryClick,
    this.primaryButtonTitle,
    this.secondaryButtonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        60.hp,
        image ??
            Image.asset(
              'assets/icons/ic_info.png',
              width: 70.w,
              color: AppColors.colorA8A8A8,
            ),
        // Text('⚠',
        //     textAlign: TextAlign.center,
        //     style: stylew700(size: 48, color: AppColors.disabledColor)),
        24.hp,
        Text(
          heading ?? "Not_found".tr,
          textAlign: TextAlign.center,
          style: stylew600(size: 18, color: AppColors.disabledColor),
        ),
        8.hp,
        Text(
          subheading ?? "Stay_tuned_for_updates".tr,
          textAlign: TextAlign.center,
          style: stylew400(size: 14, color: AppColors.disabledColor),
        ),
        16.hp,
        if (onPrimaryClick != null)
          AppButton(
            title: primaryButtonTitle ?? 'OK'.tr,
            onTap:
                onPrimaryClick ??
                () {}, // Provide a default empty function if null
          ),
        8.hp,
        if (onSecondaryClick != null)
          AppButton(
            title: secondaryButtonTitle ?? 'go_back'.tr,
            onTap:
                onSecondaryClick ??
                () {}, // Provide a default empty function if null
          ),
        96.hp,
      ],
    ).paddingSymmetric(horizontal: 16.w);
  }
}
