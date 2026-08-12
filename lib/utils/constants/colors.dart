import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand / Primary Colors ---
  static const Color primary = Color(0xFF4B68FF); // Vibrant Royal Blue (from CodingWithT style)
  static const Color secondary = Color(0xFFFFE24B); // Yellow Accent Line
  static const Color accent = Color(0xFFF0C2A0); // Soft Peach/Nude Accent

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // --- Background Colors ---
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // --- Surface & Container Colors ---
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Color(0x1AF6F6F6);

  // --- Button Colors ---
  static const Color buttonPrimary = Color(0xFF4B68FF);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // --- Border & Divider Colors ---
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // --- State & Status Colors ---
  static const Color error = Color(0xFFD32F2F);
  static const Color discount = Color(0xFFE53935); // For sale tags/percentages (-52%)
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // --- Neutral Shades ---
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);

  // --- Gradiants ---
  static const Gradient primaryHeaderGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xFF4B68FF),
      Color(0xFF687EFF),
      Color(0xFF8899FF),
    ],
  );

  /// Subtle background gradient for light-themed containers & cards
  static const Gradient primaryContainerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF3F5FF),
      Color(0xFFE8ECFF),
    ],
  );

  /// Warm accent gradient for special offer tags, badges, or sale banners
  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFE24B), // Secondary Yellow
      Color(0xFFF0C2A0), // Peach Accent
    ],
  );

  /// Discount & hot deal tags
  static const Gradient discountGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5252),
      Color(0xFFE53935),
    ],
  );

  /// Shimmer loading animation for product image placeholders
  static const Gradient shimmerGradient = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [
      Color(0xFFE0E0E0),
      Color(0xFFF4F4F4),
      Color(0xFFE0E0E0),
    ],
    stops: [0.1, 0.5, 0.9],
  );

  /// Dark mode hero card gradient
  static const Gradient darkContainerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3A3A3A),
      Color(0xFF272727),
    ],
  );
}