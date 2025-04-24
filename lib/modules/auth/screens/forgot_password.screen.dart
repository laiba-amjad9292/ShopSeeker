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
            appBar: AppBar(),
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hp,
                      Image.asset('assets/images/illustration.png'),
                      50.hp,
                      Text(
                        "We will send an email to the email address you\nregistered to regain your password"
                            .tr,
                        style: styleRegular(
                          size: 14,
                          color: AppColors.color888888,
                        ),
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
                      AppButton(
                        title: "Send".tr,
                        onTap: () {
                          logic.handleResetPassowrd();
                        },
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
