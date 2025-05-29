import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/checkbox.widget.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.hp,
                    Image.asset(
                      "assets/images/app_logo.png",
                      width: 120,
                      height: 120,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.hp,
                          Text(
                            "create_your_new_account".tr,
                            style: stylew700(
                              size: 30,
                              color: AppColors.primary,
                            ),
                          ),
                          10.hp,
                          Text(
                            "sign_up_subtitle".tr,
                            style: styleRegular(
                              size: 16,
                              color: AppColors.colorAAAAAA,
                            ),
                          ),
                          16.hp,
                          CustomTextField(
                            validator: ValidatorUtils.req,
                            heading: "full_name".tr,
                            hintText: 'enter_full_name'.tr,
                            keyName: 'name',
                            isRequired: true,
                          ),
                          16.hp,
                          CustomTextField(
                            validator: ValidatorUtils.email,
                            heading: "email".tr,
                            hintText: 'enter_email'.tr,
                            keyName: 'email',
                            isRequired: true,
                          ),
                          16.hp,
                          CustomTextField(
                            heading: "password".tr,
                            hintText: 'enter_password'.tr,
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
                          16.hp,
                          CustomTextField(
                            heading: "confirm_password".tr,
                            hintText: 'confirm_your_password'.tr,
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
                                  logic.signupInitialKey.currentState
                                      ?.getRawValue('password')) {
                                return 'password_does_not_match'.tr;
                              }

                              return null;
                            },
                          ),
                          8.hp,
                          FormBuilderField<bool?>(
                            name: 'terms',
                            validator: (value) {
                              if (value == false || value == null) {
                                return 'you_need_to_agree_to_our_terms_and_condition'
                                    .tr;
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            builder: (field) {
                              return InputDecorator(
                                decoration: customInputDecoration(
                                  field.errorText ?? '',
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7.0),
                                      child: CheckBoxNew(
                                        value: logic.terms,
                                        hasError: field.hasError,
                                        onChanged: (val) {
                                          logic.changeTerms(val);
                                          field.didChange(val);
                                        },
                                        isDisabled: false,
                                      ),
                                    ),
                                    10.wp,
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'selecting_term_policy'.tr,
                                          style: styleRegular(
                                            lineHeight: 1.5,
                                            size: 14,
                                            color: AppColors.color667085,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'terms_of_services'.tr,
                                              style: stylew500(
                                                lineHeight: 1.5,
                                                size: 14,
                                                color: AppColors.primary,
                                              ),
                                              recognizer:
                                                  TapGestureRecognizer(),
                                              // ..onTap = () {
                                              //   Get.to(TermsScreen());
                                              // },
                                            ),
                                            TextSpan(
                                              text: 'and'.tr,
                                              style: styleRegular(
                                                lineHeight: 1.5,
                                                size: 14,
                                                color: AppColors.color667085,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'privacy_policy'.tr,
                                              style: stylew500(
                                                lineHeight: 1.5,
                                                size: 14,
                                                color: AppColors.primary,
                                              ),
                                              recognizer:
                                                  TapGestureRecognizer(),
                                              // ..onTap = () {
                                              //   Get.to(() => PrivacyPolicyPage());
                                              // },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          16.hp,
                          AppButton(
                            title: "signup".tr,
                            onTap: () {
                              logic.handleSignup();
                            },
                          ),
                          10.hp,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "already_have_an_account".tr,
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
                                  "signin".tr,
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
