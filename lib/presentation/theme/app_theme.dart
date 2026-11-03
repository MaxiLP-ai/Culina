import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFF9F7F2); // Warm linen cream
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4EFEA);

  // Text & Dark elements
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF767069);
  static const Color textMuted = Color(0xFFA59E95);
  static const Color darkButton = Color(0xFF1E1E1E);

  // Borders & Dividers
  static const Color border = Color(0xFFEAE5DC);
  static const Color borderLight = Color(0xFFF0EDE6);

  // Brand Accents
  static const Color yellowBadgeBg = Color(0xFFFFFBEB);
  static const Color yellowBadgeBorder = Color(0xFFFDE68A);
  static const Color yellowBadgeText = Color(0xFF92400E);

  static const Color orangeAccent = Color(0xFFE06236); // Bookmark / Terracotta
  static const Color redHeart = Color(0xFFF04438);

  // Palette colors for recipe tags
  static const Map<String, Color> recipePalette = {
    'Olivo': Color(0xFF5B7052),
    'Trigo': Color(0xFFDDA743),
    'Trufa': Color(0xFF363333),
    'Terracota': Color(0xFFC2593F),
    'Cacao': Color(0xFF5D3A29),
    'Cúrcuma': Color(0xFFE59824),
  };

  static Color getThemeColor(String name) {
    return recipePalette[name] ?? const Color(0xFFDDA743);
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkButton,
        surface: AppColors.card,
        primary: AppColors.darkButton,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
