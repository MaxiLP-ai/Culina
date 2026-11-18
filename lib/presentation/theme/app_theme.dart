import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Modo Claro
  static const Color background = Color(0xFFF9F7F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4EFEA);

  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF767069);
  static const Color textMuted = Color(0xFFA59E95);
  static const Color darkButton = Color(0xFF1E1E1E);

  static const Color border = Color(0xFFEAE5DC);
  static const Color borderLight = Color(0xFFF0EDE6);

  static const Color yellowBadgeBg = Color(0xFFFFFBEB);
  static const Color yellowBadgeBorder = Color(0xFFFDE68A);
  static const Color yellowBadgeText = Color(0xFF92400E);

  static const Color orangeAccent = Color(0xFFE06236);
  static const Color redHeart = Color(0xFFF04438);

  // Modo Oscuro
  static const Color backgroundDark = Color(0xFF141311);
  static const Color cardDark = Color(0xFF1E1C1A);
  static const Color surfaceDark = Color(0xFF282522);
  static const Color borderDark = Color(0xFF33302B);
  static const Color textPrimaryDark = Color(0xFFF8F6F2);
  static const Color textSecondaryDark = Color(0xFFA9A297);

  // Paleta de colores temáticos de recetas
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
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkButton,
        brightness: Brightness.light,
        surface: AppColors.card,
        primary: AppColors.darkButton,
      ),
      textTheme: _buildTextTheme(baseTextTheme, AppColors.textPrimary, AppColors.textSecondary),
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

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFDDA743),
        brightness: Brightness.dark,
        surface: AppColors.cardDark,
        primary: const Color(0xFFDDA743),
      ),
      textTheme: _buildTextTheme(baseTextTheme, AppColors.textPrimaryDark, AppColors.textSecondaryDark),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color primaryColor, Color secondaryColor) {
    return base.copyWith(
      headlineLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: secondaryColor,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
