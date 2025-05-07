import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/auth/screens/login.screen.dart';
import 'package:shop_seeker/modules/auth/screens/sign_up.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class AccountAccessRequired extends StatelessWidget {
  const AccountAccessRequired({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.hp,
                Text(
                  "Account Access Required".tr,
                  textAlign: TextAlign.center,
                  style: stylew700(size: 18, color: AppColors.primary),
                ),
                4.hp,
                Text(
                  "To proceed with this action, you need to be logged in. Please log in to your account, or if you don’t have one, you can register."
                      .tr,
                  textAlign: TextAlign.center,
                  style: stylew400(size: 14, color: AppColors.color888888),
                ),
                32.hp,
                AppButton(
                  title: "Login".tr,
                  color: AppColors.primary30,
                  fontColor: AppColors.primary,
                  fontSize: 16,
                  onTap: () async {
                    Get.back();

                    Get.offAll(() => LoginScreen());
                  },
                ),
                12.hp,
                AppButton(
                  onTap: () {
                    Get.offAll(() => SignUpScreen());
                  },
                  title: "Sign Up".tr,
                  color: AppColors.primary,
                  fontColor: AppColors.colorF2F4F7,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
