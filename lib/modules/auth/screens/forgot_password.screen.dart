import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/auth/controllers/auth_controller.dart';
import 'package:shop_seeker/modules/auth/screens/login.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/textfield_validators.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  SignUpController signupController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (logic) {
        return FormBuilder(
          key: logic.forgotPasswordInitialKey,
          child: Scaffold(
            appBar: CustomAppBar(
              title: "password_recovery".tr,
              titleColor: AppColors.primary,
              backButton: false,
              centeredTitle: true,
              appBarColor: AppColors.white,
              useContainerForLeading: true,
            ),
            backgroundColor: AppColors.white,
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      title: "reset_password".tr,
                      onTap: () {
                        logic.handleResetPassowrd();
                      },
                    ),
                    10.hp,
                    AppButton(
                      title: "back_to_login".tr,
                      color: AppColors.primary30,
                      fontColor: AppColors.primary,
                      onTap: () {
                        Get.back();
                        Get.off(() => LoginScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hp,
                      Image.asset('assets/images/illustration.png'),
                      30.hp,
                      Text(
                        "forgot_password_subheading".tr,
                        style: styleRegular(
                          size: 14,
                          color: AppColors.color888888,
                        ),
                      ),
                      20.hp,
                      CustomTextField(
                        validator: ValidatorUtils.email,
                        heading: "Email".tr,
                        hintText: 'enter_email'.tr,
                        keyName: 'email',
                        isRequired: true,
                      ),
                      10.hp,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
