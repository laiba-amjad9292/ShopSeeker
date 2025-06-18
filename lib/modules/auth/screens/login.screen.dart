import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/auth/controllers/auth_controller.dart';
import 'package:shop_seeker/modules/auth/screens/forgot_password.screen.dart';
import 'package:shop_seeker/modules/auth/screens/sign_up.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/textfield_validators.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SignUpController signupController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (logic) {
        return FormBuilder(
          key: logic.loginInitialKey,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Image.asset("assets/images/splah_logo.png"),
                      ),
                      Text(
                        "sign_in_your_account".tr,
                        style: stylew700(size: 30, color: AppColors.primary),
                      ),
                      10.hp,
                      Text(
                        "sign_in_subtitle".tr,
                        style: styleRegular(
                          size: 16,
                          color: AppColors.colorAAAAAA,
                        ),
                      ),
                      20.hp,
                      CustomTextField(
                        validator: ValidatorUtils.email,
                        heading: "email".tr,
                        hintText: 'enter_email'.tr,
                        keyName: 'email',
                        isRequired: true,
                      ),
                      20.hp,
                      CustomTextField(
                        heading: "password".tr,
                        hintText: 'enter_password'.tr,
                        keyName: 'password',
                        isRequired: true,
                        isPasswordField: true,
                        // prefixIcon: const Icon(Icons.lock),
                        validator: (val) {
                          if (val.toString().trim() == "" || val == null) {
                            return 'this_field_is_required'.tr;
                          }
                          if (val.toString().trim().length < 6) {
                            return 'password_must_be_of_6_characters'.tr;
                          }
                          return null;
                        },
                      ),
                      20.hp,
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ForgotPasswordScreen());
                        },
                        child: Text(
                          "forgot_password".tr,
                          style: styleRegularUnderline(),
                        ),
                      ),
                      30.hp,
                      AppButton(
                        title: "signin".tr,
                        onTap: () {
                          logic.handleLogin();
                        },
                      ),
                      20.hp,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "dont_have_an_account".tr,
                            style: styleRegular(
                              size: 14,
                              color: AppColors.colorAAAAAA,
                            ),
                          ),
                          5.wp,
                          GestureDetector(
                            onTap: () {
                              Get.off(() => SignUpScreen());
                            },
                            child: Text(
                              "signup".tr,
                              style: stylew500(
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
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
