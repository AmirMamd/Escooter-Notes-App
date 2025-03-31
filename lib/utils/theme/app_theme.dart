import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(secondary: Colors.black),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'BebasNeue',
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        displayMedium: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        //used
        displaySmall: TextStyle(
          fontSize: 24.sp,
          color: Colors.white,
          fontFamily: 'BebasNeue',
        ),
        bodyLarge: TextStyle(
            fontSize: 18.sp,
            color: AppColors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        bodyMedium: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primary,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        //used
        bodySmall: TextStyle(
            fontSize: 14.sp,
            color: AppColors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        labelLarge: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        //used
        labelMedium: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5),
        //used
        headlineSmall: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'BebasNeue',
            letterSpacing: 1.5), //used
      ),
    );
  }
}
