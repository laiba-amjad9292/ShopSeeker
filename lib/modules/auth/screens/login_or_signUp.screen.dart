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
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          Positioned(
            top: 189,
            left: 0,
            right: 0,
            child: Image.asset("assets/images/map shadw.png"),
          ),
          Positioned(
            top: 236,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'logo'.tr,
                style: stylew700(size: 40, color: AppColors.white),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 30.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colorD0D5DD.withOpacity(0.7),
                borderRadius: BorderRadius.circular(60),
              ),
              child: languageButton(
                bgColor: Colors.white,
                textColor: Colors.black,
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
                  color: AppColors.white,
                  fontColor: AppColors.primary,
                  onTap: () {
                    Get.to(() => SignUpScreen());
                  },
                ),
                14.hp,
                AppButton(
                  title: 'login'.tr,
                  color: AppColors.white20,
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
                    style: stylew500(size: 16, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
