import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFAB7BE8);
  static const Color primaryLight = Color(0xFFC8B4F8);
  static const Color primaryDark = Color(0xFF4A2A6A);

  // Accent Colors
  static const Color blushPink = Color(0xFFF8B4C8);
  static const Color lavender = Color(0xFFC8B4F8);
  static const Color lilac = Color(0xFFE8D8FF);

  // Background Colors
  static const Color lightBackground = Color(0xFFFFFAFF);
  static const Color darkBackground = Color(0xFF1A1124);
  static const Color cardBackground = Color(0xFFF3F0FC);
  static const Color whiteBackground = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color deepIris = Color(0xFF4A2A6A);
  static const Color midnight = Color(0xFF1A1124);

  // Text Colors
  static const Color primaryTextColor = Color(0xFF1A1124);
  static const Color secondaryTextColor = Color(0xFF7B6B8F);
  static const Color whiteTextColor = Color(0xFFFFFFFF);
  static const Color blackTextColor = Color(0xFF000000);
  static const Color greyTextColor = Color(0xFF9E9E9E);
  static const Color darkTextColor = Color(0xFF1E1E2D);

  // Mood Colors (for mood entry cards)
  static const Color moodHappy = Color(0xFF4CAF50);
  static const Color moodCalm = Color(0xFF2196F3);
  static const Color moodSad = Color(0xFFFF9800);
  static const Color moodExcited = Color(0xFFFFC107);
  static const Color moodAnxious = Color(0xFFF44336);
  static const Color moodNeutral = Color(0xFF9E9E9E);

  // Utility Colors
  static const Color shadowColor = Color(0x0D000000);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Legacy support (keeping old names for backwards compatibility)
  static const Color secondaryColor = secondaryTextColor;
  static const Color blackColor = blackTextColor;
  static const Color greyColor = greyTextColor;
}
