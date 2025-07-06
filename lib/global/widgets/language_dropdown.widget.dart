import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

Directionality languageButton({
  Color bgColor =
      AppColors.colorD0D5DD, // Default background color for the popup menu
  Color textColor =
      AppColors.color475467, // Default text color for the items and icon
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: PopupMenuButton(
      shadowColor: AppColors.clrF9F9FF,
      color: bgColor,
      elevation: 0,
      constraints: const BoxConstraints(maxWidth: 160),
      surfaceTintColor: AppColors.primary,
      splashRadius: 1,
      icon: GetBuilder<UserManager>(
        id: 'lang',
        builder: (logic) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/global.png',
                height: 20,
                color: textColor,
              ),
              8.wp,
              Text(
                logic.currentLang == 'de'
                    ? 'DEU'
                    : logic.currentLang == 'ar'
                    ? 'ARA'
                    : 'ENG',
                style: stylew500(color: textColor),
              ),
              8.wp,
            ],
          );
        },
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      position: PopupMenuPosition.under,
      onSelected: (value) async {
        await Future.delayed(Duration(seconds: 1));
        UserManager.instance.changeLanguage(value);
      },
      itemBuilder: (BuildContext bc) {
        return [
          PopupMenuItem(
            value: 'en',
            child: Row(
              children: [
                Image.asset('assets/icons/us_flag.png', height: 20, width: 20),
                12.wp,
                Expanded(
                  child: Text(
                    'English (US)',
                    style: stylew400(size: 14, color: textColor),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'de',
            child: Row(
              children: [
                Image.asset('assets/icons/de_flag.png', height: 20, width: 20),
                12.wp,
                Expanded(
                  child: Text(
                    'Deutsch',
                    style: stylew400(size: 14, color: textColor),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'ar',
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/Syria_flag.png',
                  height: 20,
                  width: 20,
                ),
                12.wp,
                Expanded(
                  child: Text(
                    'Arabic',
                    style: stylew400(size: 14, color: textColor),
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    ),
  );
}
