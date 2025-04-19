import "package:flutter/material.dart";
import "package:shop_seeker/global/widgets/button.widget.dart";
import "package:shop_seeker/utils/constants/app_colors.utils.dart";
import "package:shop_seeker/utils/extensions/size_extension.util.dart";
import "package:shop_seeker/utils/theme/app_theme.utils.dart";

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
          Stack(
            children: [
              Positioned(
                top: 236,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'LOGO',
                    style: stylew700(size: 40, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  title: 'Create Account',
                  color: AppColors.white,
                  fontColor: AppColors.primary,
                  onTap: () {},
                ),
                16.hp,
                AppButton(
                  title: 'Sign in',
                  color: AppColors.white20,
                  onTap: () {},
                ),
                30.hp,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
