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
      body: Stack(
        children: [
          Positioned(
            top: 30.h,
            right: 30.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colorD0D5DD.withOpacity(0.7),
                borderRadius: BorderRadius.circular(60),
              ),
              child: languageButton(
                bgColor: Colors.white,
                textColor: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  title: 'logout'.tr,
                  icon: Icon(Icons.logout, color: AppColors.white),
                  onTap: () {
                    GlobalFunctions.showBottomSheet(const LogoutBottomSheet());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
