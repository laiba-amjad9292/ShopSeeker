import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:get/get.dart';
import "package:shop_seeker/global/widgets/button.widget.dart";
import "package:shop_seeker/global/widgets/language_dropdown.widget.dart";
import "package:shop_seeker/modules/auth/screens/login.screen.dart";
import "package:shop_seeker/modules/auth/screens/sign_up.screen.dart";
import "package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart";
import "package:shop_seeker/utils/constants/app_colors.utils.dart";
import "package:shop_seeker/utils/extensions/size_extension.util.dart";
import "package:shop_seeker/utils/theme/textStyles.utils.dart";

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({super.key});

  @override
  State<LoginOrSignupScreen> createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Image.asset('assets/images/splah_logo.png'),
            ),
            Positioned(
              top: 50.h,
              right: 30.w,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary30,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: languageButton(
                  bgColor: AppColors.colorEAECF0,
                  textColor: AppColors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    title: 'create_account'.tr,
                    color: AppColors.primary,
                    fontColor: AppColors.white,
                    onTap: () {
                      Get.to(() => SignUpScreen());
                    },
                  ),
                  14.hp,
                  AppButton(
                    title: 'signin'.tr,
                    color: AppColors.primary30,
                    fontColor: AppColors.primary,
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                  ),
                  14.hp,

                  GestureDetector(
                    onTap: () {
                      Get.off(() => BottomNavigationScreen());
                    },
                    child: Text(
                      "continue_without_login".tr,
                      style: stylew500(size: 16, color: AppColors.primary),
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
