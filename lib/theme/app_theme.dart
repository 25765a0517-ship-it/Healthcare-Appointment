import 'package:flutter/material.dart';

/// Clinical Clarity Design System
/// Implements Material 3 with empathetic clinical palette.
class ClinicalColors {
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);
  static const Color surfaceVariant = Color(0xFFDAE2FD);

  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF3F4850);
  static const Color inverseSurface = Color(0xFF283044);
  static const Color inverseOnSurface = Color(0xFFEEF0FF);

  static const Color outline = Color(0xFF707881);
  static const Color outlineVariant = Color(0xFFBFC7D2);
  static const Color surfaceTint = Color(0xFF006398);

  static const Color primary = Color(0xFF006194);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF007BB9);
  static const Color onPrimaryContainer = Color(0xFFFDFCFF);
  static const Color inversePrimary = Color(0xFF93CCFF);

  static const Color secondary = Color(0xFF00668A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF40C2FD);
  static const Color onSecondaryContainer = Color(0xFF004D6A);

  static const Color tertiary = Color(0xFF006860);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF248279);
  static const Color onTertiaryContainer = Color(0xFFF3FFFC);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color primaryFixed = Color(0xFFCCE5FF);
  static const Color primaryFixedDim = Color(0xFF93CCFF);
  static const Color onPrimaryFixed = Color(0xFF001D31);
  static const Color onPrimaryFixedVariant = Color(0xFF004B73);

  static const Color secondaryFixed = Color(0xFFC4E7FF);
  static const Color secondaryFixedDim = Color(0xFF7BD0FF);
  static const Color onSecondaryFixed = Color(0xFF001E2C);
  static const Color onSecondaryFixedVariant = Color(0xFF004C69);

  static const Color tertiaryFixed = Color(0xFF9CF2E8);
  static const Color tertiaryFixedDim = Color(0xFF80D5CB);
  static const Color onTertiaryFixed = Color(0xFF00201D);
  static const Color onTertiaryFixedVariant = Color(0xFF00504A);

  static const Color background = Color(0xFFFAF8FF);
  static const Color onBackground = Color(0xFF131B2E);
}

class ClinicalTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ClinicalColors.surface,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: ClinicalColors.primary,
        onPrimary: ClinicalColors.onPrimary,
        primaryContainer: ClinicalColors.primaryContainer,
        onPrimaryContainer: ClinicalColors.onPrimaryContainer,
        secondary: ClinicalColors.secondary,
        onSecondary: ClinicalColors.onSecondary,
        secondaryContainer: ClinicalColors.secondaryContainer,
        onSecondaryContainer: ClinicalColors.onSecondaryContainer,
        tertiary: ClinicalColors.tertiary,
        onTertiary: ClinicalColors.onTertiary,
        tertiaryContainer: ClinicalColors.tertiaryContainer,
        onTertiaryContainer: ClinicalColors.onTertiaryContainer,
        error: ClinicalColors.error,
        onError: ClinicalColors.onError,
        errorContainer: ClinicalColors.errorContainer,
        onErrorContainer: ClinicalColors.onErrorContainer,
        surface: ClinicalColors.surface,
        onSurface: ClinicalColors.onSurface,
        onSurfaceVariant: ClinicalColors.onSurfaceVariant,
        outline: ClinicalColors.outline,
        outlineVariant: ClinicalColors.outlineVariant,
      ),
      fontFamilyFallback: const ['Inter', 'SF Pro Text', 'Roboto', 'sans-serif'],
      appBarTheme: const AppBarTheme(
        backgroundColor: ClinicalColors.surface,
        foregroundColor: ClinicalColors.onSurface,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0.5,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ClinicalColors.primary,
          foregroundColor: ClinicalColors.onPrimary,
          elevation: 2,
          shadowColor: ClinicalColors.primary.withValues(alpha: 0.3),
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ClinicalColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClinicalColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ClinicalColors.error, width: 1.2),
        ),
        hintStyle: const TextStyle(
          color: ClinicalColors.outline,
          fontSize: 15,
        ),
        prefixIconColor: ClinicalColors.outline,
        suffixIconColor: ClinicalColors.outline,
      ),
    );
  }
}
