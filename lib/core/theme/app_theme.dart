
import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonColor,
    ),
    brightness: Brightness.light,
  );
}