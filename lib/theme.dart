import 'package:flutter/material.dart';

/// Identité visuelle Pétote : marine profond, jaune chips, fond bleuté clair.
class PetoteColors {
  static const ardoise = Color(0xFF0F1B33);
  static const marine = Color(0xFF1F3560);
  static const jaune = Color(0xFFFFB800);
  static const brume = Color(0xFFF3F5F9);
  static const sale = Color(0xFF2F6FDE);
  static const sucre = Color(0xFFE4527A);
  static const promo = Color(0xFF0FA968);
}

ThemeData construireTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: PetoteColors.jaune,
    primary: PetoteColors.ardoise,
    onPrimary: Colors.white,
    secondary: PetoteColors.jaune,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: PetoteColors.brume,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PetoteColors.brume,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: PetoteColors.ardoise,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: PetoteColors.ardoise,
        side: BorderSide(color: PetoteColors.ardoise.withValues(alpha: 0.15)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}
