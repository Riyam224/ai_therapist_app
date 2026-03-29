import 'package:ai_therapist_app/core/styling/app_colors.dart';
import 'package:ai_therapist_app/core/styling/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // Headline Styles
  static TextStyle primaryHeadLinesStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
  );

  static TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryTextColor,
  );

  static TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryTextColor,
  );

  // Title Styles
  static TextStyle titleLarge = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackTextColor,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextColor,
  );

  static TextStyle titleSmall = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextColor,
  );

  // Body Styles
  static TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryTextColor,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryTextColor,
  );

  static TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyTextColor,
  );

  // Label Styles
  static TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
  );

  static TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryTextColor,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.greyTextColor,
  );

  // Caption Styles
  static TextStyle captionLarge = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyTextColor,
  );

  static TextStyle captionSmall = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyTextColor,
  );

  // White Text Styles (for dark backgrounds)
  static TextStyle whiteHeadline = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteTextColor,
  );

  static TextStyle whiteBody = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.whiteTextColor,
  );

  static TextStyle whiteCaption = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.whiteTextColor,
  );

  static TextStyle whiteButton = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteTextColor,
  );

  // Legacy styles (keeping for backwards compatibility)
  static TextStyle subtitlesStyles = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.secondaryColor,
  );

  static TextStyle black16w500Style = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  static TextStyle grey12MediumStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.greyColor,
  );

  static TextStyle black15BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );

  static TextStyle black18BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );
}
