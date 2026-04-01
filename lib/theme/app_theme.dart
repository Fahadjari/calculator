// lib/theme/app_theme.dart
// Centralized theme — Material 3, dark-first design

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic color roles for calculator buttons
class CalcColors {
  // ── Dark Theme ─────────────────────────────────────────────────────────
  static const Color darkBackground    = Color(0xFF0D0D0F);
  static const Color darkSurface       = Color(0xFF1A1A1E);
  static const Color darkSurfaceHigh   = Color(0xFF242428);

  /// Number buttons
  static const Color darkNumBg         = Color(0xFF1E1E24);
  static const Color darkNumFg         = Color(0xFFE8E8EE);

  /// Operator buttons (÷, ×, −, +)
  static const Color darkOpBg          = Color(0xFF2A2A35);
  static const Color darkOpFg          = Color(0xFF9D9EFF);

  /// Equals button — the hero
  static const Color darkEqBg          = Color(0xFF5E5CE6);
  static const Color darkEqFg          = Color(0xFFFFFFFF);

  /// Function buttons (C, ⌫, %)
  static const Color darkFnBg          = Color(0xFF252530);
  static const Color darkFnFg          = Color(0xFFB0B0C8);

  /// Display
  static const Color darkDisplayBg     = Color(0xFF0D0D0F);
  static const Color darkDisplayFg     = Color(0xFFF5F5FA);
  static const Color darkExprFg        = Color(0xFF6B6B88);

  // ── Light Theme ────────────────────────────────────────────────────────
  static const Color lightBackground   = Color(0xFFF2F2F7);
  static const Color lightSurface      = Color(0xFFFFFFFF);

  static const Color lightNumBg        = Color(0xFFFFFFFF);
  static const Color lightNumFg        = Color(0xFF1C1C1E);

  static const Color lightOpBg         = Color(0xFFECECF8);
  static const Color lightOpFg         = Color(0xFF4B4BE8);

  static const Color lightEqBg         = Color(0xFF5E5CE6);
  static const Color lightEqFg         = Color(0xFFFFFFFF);

  static const Color lightFnBg         = Color(0xFFE8E8F0);
  static const Color lightFnFg         = Color(0xFF3C3C55);

  static const Color lightDisplayBg    = Color(0xFFF2F2F7);
  static const Color lightDisplayFg    = Color(0xFF1C1C1E);
  static const Color lightExprFg       = Color(0xFF8E8EA0);
}

/// Button visual category
enum ButtonType { number, operator, equals, function }

class AppTheme {
  /// Build the full MaterialApp theme data
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CalcColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: CalcColors.darkEqBg,
        surface: CalcColors.darkSurface,
        background: CalcColors.darkBackground,
        onBackground: CalcColors.darkDisplayFg,
      ),
      textTheme: _textTheme(CalcColors.darkDisplayFg),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: CalcColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: CalcColors.lightEqBg,
        surface: CalcColors.lightSurface,
        background: CalcColors.lightBackground,
        onBackground: CalcColors.lightDisplayFg,
      ),
      textTheme: _textTheme(CalcColors.lightDisplayFg),
    );
  }

  static TextTheme _textTheme(Color base) {
    return GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.dmSans(
        fontSize: 72,
        fontWeight: FontWeight.w200,
        color: base,
        letterSpacing: -2,
      ),
      displayMedium: GoogleFonts.dmSans(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        color: base,
        letterSpacing: -1,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: base.withOpacity(0.5),
      ),
    );
  }

  /// Returns the correct colors for a button type in the given brightness
  static ({Color bg, Color fg}) buttonColors(
      ButtonType type, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (type) {
      case ButtonType.number:
        return (
          bg: isDark ? CalcColors.darkNumBg : CalcColors.lightNumBg,
          fg: isDark ? CalcColors.darkNumFg : CalcColors.lightNumFg,
        );
      case ButtonType.operator:
        return (
          bg: isDark ? CalcColors.darkOpBg : CalcColors.lightOpBg,
          fg: isDark ? CalcColors.darkOpFg : CalcColors.lightOpFg,
        );
      case ButtonType.equals:
        return (
          bg: isDark ? CalcColors.darkEqBg : CalcColors.lightEqBg,
          fg: isDark ? CalcColors.darkEqFg : CalcColors.lightEqFg,
        );
      case ButtonType.function:
        return (
          bg: isDark ? CalcColors.darkFnBg : CalcColors.lightFnBg,
          fg: isDark ? CalcColors.darkFnFg : CalcColors.lightFnFg,
        );
    }
  }
}
