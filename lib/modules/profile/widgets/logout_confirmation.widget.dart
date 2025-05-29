import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/auth/screens/login.screen.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({super.key});

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
                  "confirm_logout_bottomsheet_title".tr,
                  textAlign: TextAlign.center,
                  style: stylew700(size: 20),
                ),
                8.hp,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "confirm_logout_bottomsheet_subtitle".tr,
                    textAlign: TextAlign.center,
                    style: stylew400(size: 14, color: AppColors.color667085),
                  ),
                ),
                32.hp,
                AppButton(
                  title: "confirm_logout_bottomsheet_yes_button".tr,
                  color: AppColors.colorF04438,
                  fontSize: 16,
                  onTap: () async {
                    Get.back();
                    UserManager.instance.logout();
                    Get.offAll(() => LoginScreen());
                  },
                ),
                12.hp,
                AppButton(
                  onTap: () {
                    Get.back();
                  },
                  title: "confirm_logout_bottomsheet_cancel_button".tr,
                  color: AppColors.colorF2F4F7,
                  fontColor: AppColors.color1D2939,
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
