import 'package:flutter/material.dart';

class AppColors {
  static const Color citrine = Color(0xFFF3DE2C);
  static const Color pumpkin = Color(0xFFF17105);
  static const Color black = Color(0xFF000000);
  static const Color pennRed = Color(0xFF95190C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color bgLight = Color.fromARGB(255, 255, 247, 237);

  static const LinearGradient gradientTop = LinearGradient(
    colors: [citrine, pumpkin, black, pennRed, white],
  );
}

ThemeData appTheme = ThemeData(
  primaryColor: AppColors.citrine,
  scaffoldBackgroundColor: AppColors.white,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.black),
    bodyMedium: TextStyle(color: AppColors.black),
  ),
);
