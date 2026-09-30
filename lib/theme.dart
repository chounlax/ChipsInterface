import 'package:flutter/material.dart';

/// Identité visuelle Pétote : ardoise du Nord, jaune chips, brume claire.
class PetoteColors {
  static const ardoise = Color(0xFF16243A);
  static const jaune = Color(0xFFFFC629);
  static const brume = Color(0xFFEDF1F5);
  static const sale = Color(0xFF2F6FDE);
  static const sucre = Color(0xFFE4527A);
  static const promo = Color(0xFF12A36B);
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
        borderRadius: BorderRadius.circular(12),
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
  );
}
