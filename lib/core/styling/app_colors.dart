import 'package:flutter/material.dart';

class AppColors {
  // ── MindEase Breathing/Affirmation Palette ───────────────────────────────
  static const Color scaffoldBg = Color(0xFFFFF8F2);
  static const Color cardBg = Color(0xFFFFF0E8);
  static const Color cardBorder = Color(0xFFFFD4B0);
  static const Color mintBg = Color(0xFFC8EDD8);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFFA0785A);
  static const Color breathInColor = Color(0xFFE8621A);
  static const Color breathHoldColor = Color(0xFF2D6A4F);
  static const Color breathOutColor = Color(0xFF85B7EB);
  static const Color secondary = breathHoldColor;

  // ── Light Theme ──────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFFFF8F5);    // Scaffold
  static const Color lightSurface = Color(0xFFFFF0E8);       // Cards
  static const Color primary = Color(0xFFE8621A);            // CTA buttons
  static const Color primaryContainer = Color(0xFF5BBFA0);   // AI bubble, mint
  static const Color lightOnBackground = Color(0xFF2D2016);  // Headings
  static const Color lightSecondaryText = Color(0xFF7A5038); // Labels, hints
  static const Color lightBorder = Color(0xFFFFD4B8);        // Card borders
  static const Color accent = Color(0xFFFF7096);             // "Great" mood

  // ── Dark Theme ───────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF16132A);     // Scaffold
  static const Color darkSurface = Color(0xFF1E1A35);        // Cards
  static const Color primaryDark = Color(0xFF7C5CDB);        // Buttons, accents
  static const Color darkPrimaryContainer = Color(0xFF221D3E); // AI bubble bg
  static const Color darkOnBackground = Color(0xFFEDE9FE);   // Primary text
  static const Color darkSecondaryText = Color(0xFF6B6490);  // Labels, hints
  static const Color darkBorder = Color(0xFF2D2850);         // Card borders

  // ── Aliases (keep existing usages compiling) ─────────────────────────────
  static const Color primaryLight = Color(0xFFFFB89A);       // lighter peach tint
  static const Color cardBackground = lightSurface;
  static const Color whiteBackground = lightSurface;

  // Text
  static const Color primaryTextColor = lightOnBackground;
  static const Color secondaryTextColor = lightSecondaryText;
  static const Color whiteTextColor = Color(0xFFFFFFFF);
  static const Color blackTextColor = Color(0xFF000000);
  static const Color greyTextColor = Color(0xFF9E9E9E);
  static const Color darkTextColor = lightOnBackground;

  // Accent
  static const Color blushPink = accent;
  static const Color lavender = Color(0xFFC8B4F8);
  static const Color lilac = Color(0xFFE8D8FF);

  // Mood Colors
  static const Color moodHappy = Color(0xFF4CAF50);
  static const Color moodCalm = Color(0xFF2196F3);
  static const Color moodSad = Color(0xFFFF9800);
  static const Color moodExcited = Color(0xFFFFC107);
  static const Color moodAnxious = Color(0xFFF44336);
  static const Color moodNeutral = Color(0xFF9E9E9E);

  // Utility
  static const Color shadowColor = Color(0x0D000000);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Legacy
  static const Color secondaryColor = secondaryTextColor;
  static const Color blackColor = blackTextColor;
  static const Color greyColor = greyTextColor;
  static const Color deepIris = darkSurface;
  static const Color midnight = darkBackground;
}
