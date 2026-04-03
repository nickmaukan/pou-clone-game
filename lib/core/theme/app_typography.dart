import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle get displayLarge => GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get displayMedium => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get displaySmall => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get headlineMedium => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get labelLarge => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get coinText => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(0xFFFFD700),
      );
}
