import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
import 'package:shop_seeker/modules/home/screen/add_update.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  _SignupSuccessScreenState createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/success_image.png",
                width: 160.w,
                height: 160.h,
              ),
              20.hp,
              Text(
                "success".tr,
                textAlign: TextAlign.center,
                style: stylew600(size: 28, color: AppColors.black),
              ),
              8.hp,
              Text(
                'account_created_successfully'.tr,
                textAlign: TextAlign.center,
                style: styleRegular(size: 16, color: AppColors.color888888),
              ),
              50.hp,
              AppButton(
                onTap: () {
                  Get.offAll(() => BottomNavigationScreen());
                },
                title: 'register_shop'.tr,
                color: AppColors.primary30,
                fontColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
              AppButton(
                onTap: () {
                  Get.offAll(() => BottomNavigationScreen());
                },
                title: 'find_shop'.tr,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
