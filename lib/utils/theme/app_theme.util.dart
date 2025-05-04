import 'package:flutter/material.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';

// All rights reserved by Healer

class AppTheme {
  static ColorScheme lightcolorScheme = const ColorScheme.light(
    primary: AppColors.primary,
  );
  static ThemeData lightTheme() => ThemeData(
    colorScheme: lightcolorScheme,
    scaffoldBackgroundColor:
        AppColors.scaffoldColor, //This is necessary for bottomSheet to work.
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.color98A2B3),
    ),
  );
}
