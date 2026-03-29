import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_extra_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: AppFonts.mainFontName,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.lavender,
      surface: AppColors.whiteBackground,
      onPrimary: AppColors.whiteTextColor,
      onSecondary: AppColors.whiteTextColor,
      onSurface: AppColors.primaryTextColor,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryTextColor),
      displayMedium: TextStyle(color: AppColors.primaryTextColor),
      displaySmall: TextStyle(color: AppColors.primaryTextColor),
      headlineLarge: TextStyle(color: AppColors.primaryTextColor),
      headlineMedium: TextStyle(color: AppColors.primaryTextColor),
      headlineSmall: TextStyle(color: AppColors.primaryTextColor),
      titleLarge: TextStyle(color: AppColors.primaryTextColor),
      titleMedium: TextStyle(color: AppColors.primaryTextColor),
      titleSmall: TextStyle(color: AppColors.primaryTextColor),
      bodyLarge: TextStyle(color: AppColors.primaryTextColor),
      bodyMedium: TextStyle(color: AppColors.primaryTextColor),
      bodySmall: TextStyle(color: AppColors.secondaryTextColor),
      labelLarge: TextStyle(color: AppColors.primaryTextColor),
      labelMedium: TextStyle(color: AppColors.primaryTextColor),
      labelSmall: TextStyle(color: AppColors.greyTextColor),
    ),

    iconTheme: const IconThemeData(color: AppColors.primaryTextColor),

    cardColor: AppColors.whiteBackground,

    extensions: [
      AppExtraColors(
        primaryColor: AppColors.primary,
        primaryLightColor: AppColors.primaryLight,
        primaryDarkColor: AppColors.primaryDark,
        cardBackgroundColor: AppColors.cardBackground,
        surfaceColor: AppColors.whiteBackground,
        primaryTextColor: AppColors.primaryTextColor,
        secondaryTextColor: AppColors.secondaryTextColor,
        tertiaryTextColor: AppColors.greyTextColor,
        onPrimaryTextColor: AppColors.whiteTextColor,
        moodHappy: AppColors.moodHappy,
        moodSad: AppColors.moodSad,
        moodCalm: AppColors.moodCalm,
        moodExcited: AppColors.moodExcited,
        moodAnxious: AppColors.moodAnxious,
        moodNeutral: AppColors.moodNeutral,
        borderColor: AppColors.primaryLight,
        dividerColor: AppColors.dividerColor,
        shadowColor: AppColors.shadowColor,
      ),
    ],
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: AppFonts.mainFontName,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.lavender,
      surface: AppColors.deepIris,
      onPrimary: AppColors.whiteTextColor,
      onSecondary: AppColors.whiteTextColor,
      onSurface: AppColors.whiteTextColor,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.whiteTextColor),
      displayMedium: TextStyle(color: AppColors.whiteTextColor),
      displaySmall: TextStyle(color: AppColors.whiteTextColor),
      headlineLarge: TextStyle(color: AppColors.whiteTextColor),
      headlineMedium: TextStyle(color: AppColors.whiteTextColor),
      headlineSmall: TextStyle(color: AppColors.whiteTextColor),
      titleLarge: TextStyle(color: AppColors.whiteTextColor),
      titleMedium: TextStyle(color: AppColors.whiteTextColor),
      titleSmall: TextStyle(color: AppColors.whiteTextColor),
      bodyLarge: TextStyle(color: AppColors.whiteTextColor),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      bodySmall: TextStyle(color: Color(0xFFB0B0B0)),
      labelLarge: TextStyle(color: AppColors.whiteTextColor),
      labelMedium: TextStyle(color: AppColors.whiteTextColor),
      labelSmall: TextStyle(color: Color(0xFFB0B0B0)),
    ),

    iconTheme: const IconThemeData(color: AppColors.whiteTextColor),

    cardColor: AppColors.deepIris,

    extensions: [
      AppExtraColors(
        primaryColor: AppColors.primaryLight,
        primaryLightColor: AppColors.primary,
        primaryDarkColor: AppColors.primaryDark,
        cardBackgroundColor: AppColors.deepIris,
        surfaceColor: AppColors.midnight,
        primaryTextColor: AppColors.whiteTextColor,
        secondaryTextColor: const Color(0xFFB0B0B0),
        tertiaryTextColor: const Color(0xFF808080),
        onPrimaryTextColor: AppColors.whiteTextColor,
        moodHappy: const Color(0xFF66BB6A),
        moodSad: const Color(0xFFFFB74D),
        moodCalm: const Color(0xFF42A5F5),
        moodExcited: const Color(0xFFFFCA28),
        moodAnxious: const Color(0xFFEF5350),
        moodNeutral: const Color(0xFF9E9E9E),
        borderColor: AppColors.primaryDark,
        dividerColor: const Color(0xFF424242),
        shadowColor: const Color(0x1AFFFFFF),
      ),
    ],
  );
}
