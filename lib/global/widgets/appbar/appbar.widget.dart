import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color titleColor;
  final Color appBarColor;
  final Color iconColor;
  final bool backButton;
  final List<Widget> actions;
  final bool centeredTitle;
  final double? logoHeight;
  final double? logoWidth;
  final bool showLogo;
  final Function? onPop;
  final bool useContainerForLeading;
  final Color? containerColor;

  CustomAppBar({
    this.title,
    this.titleColor = AppColors.primary,
    this.appBarColor = AppColors.scaffoldColor,
    this.iconColor = AppColors.colorAAAAAA,
    this.backButton = true,
    this.actions = const [],
    this.centeredTitle = false,
    this.logoWidth = 70,
    this.logoHeight = 70,
    this.showLogo = false,
    this.onPop,
    this.useContainerForLeading = false,
    this.containerColor = AppColors.colorDDDDDD,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: AppColors.scaffoldColor,
      backgroundColor: appBarColor,
      automaticallyImplyLeading: backButton,

      leading:
          backButton
              ? (useContainerForLeading
                  ? Padding(
                    padding: const EdgeInsets.only(top: 15, left: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.colorDDDDDD,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: iconColor,
                          size: 16.w,
                        ),
                        onPressed: () {
                          if (Get.currentRoute == '/MainNavigationPage') {
                            // Get.find<NavBarController>().changeTab(0);
                          } else {
                            if (onPop == null) {
                              Get.back();
                            } else {
                              onPop!();
                            }
                          }
                        },
                      ),
                    ),
                  )
                  : IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: iconColor,
                      size: 16.w,
                    ),
                    onPressed: () {
                      if (Get.currentRoute == '/MainNavigationPage') {
                        // Get.find<NavBarController>().changeTab(0);
                      } else {
                        if (onPop == null) {
                          Get.back();
                        } else {
                          onPop!();
                        }
                      }
                    },
                  ))
              : null,
      title:
          !showLogo
              ? Text(title ?? "", style: stylew600(color: titleColor, size: 16))
              : Image.asset("", width: logoWidth, height: logoHeight),
      actions: actions,
      centerTitle: centeredTitle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
