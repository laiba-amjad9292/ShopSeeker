import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
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
              32.hp,
              Text(
                "Success!".tr,
                textAlign: TextAlign.center,
                style: stylew600(size: 18, color: AppColors.color101828),
              ),
              8.hp,
              Text(
                'your account has been\ncreated succesfully.'.tr,
                textAlign: TextAlign.center,
                style: stylew400(size: 14, color: AppColors.color98A2B3),
              ),
              40.hp,
              AppButton(
                onTap: () {
                  // Get.offAll(() => BottomNavigationScreen());
                },
                title: 'Register Shop'.tr,
              ),
              const SizedBox(height: 16),
              AppButton(
                onTap: () {
                  Get.offAll(() => BottomNavigationScreen());
                },
                title: 'Find Shop'.tr,
              ),
              const SizedBox(height: 16),
              // AppButton(
              //   onTap: () async {
              //     Get.offAll(() => BottomNavigationScreen());
              //   },
              //   title: "skip_verification".tr,
              //   disabledColor: AppColors.primary.withOpacity(0.1),
              //   disabledFontColor: AppColors.primary.withOpacity(0.6),
              //   elevation: 0,
              //   fontColor: AppColors.color2D6830,
              //   color: AppColors.colorF3FAF3,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
