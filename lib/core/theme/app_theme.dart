import 'package:flutter/material.dart';

/// Paleta extraída del ícono de Vitali (`lib/resources/icons/image.png`):
/// mano y mitad izquierda de la cápsula en cian, mitad derecha en naranja,
/// fondo crema y corazón blanco.
class AppColors {
  AppColors._();

  static const cyan = Color(0xFF00B4D8);
  static const cyanDeep = Color(0xFF007A94);
  static const orange = Color(0xFFF4843A);
  static const orangeDeep = Color(0xFFC85A18);
  static const cream = Color(0xFFF7F5F2);
  static const creamCard = Color(0xFFFFFCF9);
  static const ink = Color(0xFF0E2A33);
  static const inkSoft = Color(0xFF3D5A64);

  static const night = Color(0xFF071418);
  static const nightCard = Color(0xFF10262C);
  static const cyanBright = Color(0xFF3ECDEC);
  static const orangeBright = Color(0xFFFF9A55);
  static const mist = Color(0xFFE4F4F8);
}

/// Tres tamaños fijos para lectura accesible (baja visión).
class AppFontSize {
  AppFontSize._();

  static const body = 18.0;
  static const title = 20.0;
  static const headline = 24.0;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    background: AppColors.cream,
    surface: AppColors.creamCard,
    primary: AppColors.cyanDeep,
    onPrimary: Colors.white,
    primaryContainer: AppColors.cyan,
    onPrimaryContainer: AppColors.ink,
    secondary: AppColors.orangeDeep,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.orange,
    onSecondaryContainer: Colors.white,
    ink: AppColors.ink,
    inkSoft: AppColors.inkSoft,
    outline: const Color(0xFFC5D5DA),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    background: AppColors.night,
    surface: AppColors.nightCard,
    primary: AppColors.cyanBright,
    onPrimary: AppColors.night,
    primaryContainer: AppColors.cyanDeep,
    onPrimaryContainer: AppColors.mist,
    secondary: AppColors.orangeBright,
    onSecondary: AppColors.night,
    secondaryContainer: AppColors.orangeDeep,
    onSecondaryContainer: Colors.white,
    ink: AppColors.mist,
    inkSoft: const Color(0xFFB7D0D6),
    outline: const Color(0xFF2A4A52),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color onPrimary,
    required Color primaryContainer,
    required Color onPrimaryContainer,
    required Color secondary,
    required Color onSecondary,
    required Color secondaryContainer,
    required Color onSecondaryContainer,
    required Color ink,
    required Color inkSoft,
    required Color outline,
  }) {
    final textTheme = _accessibleTextTheme(ink, inkSoft);
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: primaryContainer,
        onTertiary: onPrimaryContainer,
        error: const Color(0xFFC1553D),
        onError: Colors.white,
        surface: surface,
        onSurface: ink,
        onSurfaceVariant: inkSoft,
        outline: outline,
        outlineVariant: outline,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: isDark ? AppColors.cream : AppColors.ink,
        onInverseSurface: isDark ? AppColors.ink : AppColors.cream,
        inversePrimary: isDark ? AppColors.cyanDeep : AppColors.cyanBright,
      ),
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      iconTheme: IconThemeData(color: primary, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: onPrimary, size: 24),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: onSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(48, 48),
          side: BorderSide(color: primary, width: 1.5),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: textTheme.bodyLarge?.copyWith(color: inkSoft),
        hintStyle: textTheme.bodyLarge?.copyWith(color: inkSoft),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(color: outline, thickness: 1),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outline),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: onPrimary),
      ),
    );
  }

  static TextTheme _accessibleTextTheme(Color ink, Color inkSoft) {
    TextStyle base({
      required double size,
      required FontWeight weight,
      required Color color,
    }) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.4,
        letterSpacing: 0.15,
      );
    }

    final body = base(
      size: AppFontSize.body,
      weight: FontWeight.w500,
      color: ink,
    );
    final title = base(
      size: AppFontSize.title,
      weight: FontWeight.w600,
      color: ink,
    );
    final headline = base(
      size: AppFontSize.headline,
      weight: FontWeight.w700,
      color: ink,
    );
    final bodyMuted = body.copyWith(color: inkSoft);

    return TextTheme(
      displayLarge: headline,
      displayMedium: headline,
      displaySmall: headline,
      headlineLarge: headline,
      headlineMedium: headline,
      headlineSmall: headline,
      titleLarge: title,
      titleMedium: title,
      titleSmall: title,
      bodyLarge: body,
      bodyMedium: body,
      bodySmall: bodyMuted,
      labelLarge: title,
      labelMedium: body,
      labelSmall: bodyMuted,
    );
  }
}
