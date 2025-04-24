import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/auth/controllers/auth_controller.dart';
import 'package:shop_seeker/modules/auth/screens/login.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/textfield_validators.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpController signupController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (logic) {
        return FormBuilder(
          key: logic.signupInitialKey,
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      70.hp,
                      Text(
                        "Create your\nnew account",
                        style: stylew700(size: 30, color: AppColors.primary),
                      ),
                      10.hp,
                      Text(
                        "Lorem Ipsum has been the industry's\nstandard dummy text ever since the 1500s",
                        style: styleRegular(
                          size: 16,
                          color: AppColors.colorAAAAAA,
                        ),
                      ),
                      20.hp,
                      CustomTextField(
                        validator: ValidatorUtils.req,
                        heading: "Full name".tr,
                        hintText: 'Enter your full_name'.tr,
                        keyName: 'name',
                        isRequired: true,
                      ),
                      20.hp,
                      CustomTextField(
                        validator: ValidatorUtils.email,
                        heading: "Email".tr,
                        hintText: 'Enter your email'.tr,
                        keyName: 'email',
                        isRequired: true,
                      ),
                      20.hp,
                      CustomTextField(
                        heading: "Password".tr,
                        hintText: 'Enter your password'.tr,
                        keyName: 'password',
                        isRequired: true,
                        isPasswordField: true,
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
                      CustomTextField(
                        heading: "Confirm password".tr,
                        hintText: 'Confirm your password'.tr,
                        keyName: 'confirmPassword',
                        isRequired: true,
                        isPasswordField: true,
                        validator: (val) {
                          if (val.toString().trim() == "" || val == null) {
                            return 'this_field_is_required'.tr;
                          }
                          if (val.toString().trim().length < 6) {
                            return 'password_must_be_of_6_characters'.tr;
                          }
                          if (val !=
                              logic.signupInitialKey.currentState?.getRawValue(
                                'password',
                              )) {
                            return 'password_does_not_match'.tr;
                          }

                          return null;
                        },
                      ),
                      20.hp,
                      AppButton(
                        title: "Sign Up",
                        onTap: () {
                          logic.handleSignup();
                        },
                      ),
                      20.hp,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: styleRegular(
                              size: 14,
                              color: AppColors.colorAAAAAA,
                            ),
                          ),
                          5.wp,
                          GestureDetector(
                            onTap: () {
                              Get.off(() => LoginScreen());
                            },
                            child: Text(
                              "Sign In",
                              style: stylew500(
                                size: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
