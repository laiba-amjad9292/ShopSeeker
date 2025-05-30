import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/language_dropdown.widget.dart';
import 'package:shop_seeker/modules/profile/widgets/logout_confirmation.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "profile".tr,
        backButton: false,
        centeredTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 30.h,
              right: 30.w,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary30,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: languageButton(
                  bgColor: AppColors.colorEAECF0,
                  textColor: Colors.black,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: FirebaseAuth.instance.currentUser != null,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppButton(
                    title: 'logout'.tr,
                    icon: Icon(Icons.logout, color: AppColors.white),
                    color: AppColors.primary,
                    onTap: () {
                      GlobalFunctions.showBottomSheet(
                        const LogoutBottomSheet(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
