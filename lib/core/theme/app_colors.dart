import 'package:flutter/material.dart';

/// Semantic color palette for the template.
class AppColors {
  AppColors._();

  // Primary brand seed
  static const Color primarySeed = Color(0xFF2563EB); // Royal Blue
  static const Color secondarySeed = Color(0xFF0EA5E9); // Sky

  // Dark Theme Foundations
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceContainer = Color(0xFF243248);
  static const Color darkSurfaceHigh = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextTertiary = Color(0xFF64748B);

  // Light Theme Foundations
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFF1F5F9); // Slate 100
  static const Color lightSurfaceHigh = Color(0xFFE2E8F0); // Slate 200
  static const Color lightBorder = Color(0xFFCBD5E1); // Slate 300
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextTertiary = Color(0xFF94A3B8);

  // Status & Semantic Tokens
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF0284C7);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Deterministic Avatar Palette
  static const List<Color> avatarPalette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF06B6D4), // Cyan
    Color(0xFF14B8A6), // Teal
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFF97316), // Orange
    Color(0xFFF43F5E), // Rose
    Color(0xFF8B5CF6), // Violet
  ];
}
