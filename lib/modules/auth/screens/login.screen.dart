import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              70.hp,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("LOGO".tr, style: stylew700(size: 40))],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
