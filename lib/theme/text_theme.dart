import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w500)
        .copyWith(fontFamily: 'poppins'),
    displayMedium: GoogleFonts.poppins(
            fontSize: 28,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w500)
        .copyWith(fontFamily: 'poppins'),
    displaySmall: GoogleFonts.poppins(
            fontSize: 24,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w500,
            height: 1.5)
        .copyWith(fontFamily : 'poppins'),

    // Headline styles
    headlineLarge: GoogleFonts.poppins(
            fontSize: 22,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400)
        .copyWith(fontFamily: 'poppins'),
    headlineMedium: GoogleFonts.roboto(
            fontSize: 20,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400)
        .copyWith(fontFamily: 'poppins'),
    headlineSmall: GoogleFonts.poppins(
            fontSize: 18,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400)
        .copyWith(fontFamily: 'poppins'),

    // Title styles
    titleLarge:
        GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF111827), fontWeight: FontWeight.w400)
            .copyWith(fontFamily: 'poppins'),
    titleMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF111827),
            fontWeight: FontWeight.w400)
        .copyWith(fontFamily: 'poppins'),
    titleSmall:
        GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF111827), fontWeight: FontWeight.w400)
            .copyWith(fontFamily: 'poppins'),

    // Label styles
    labelLarge:
        GoogleFonts.poppins(fontSize: 18, color: const Color(0xFF111827))
            .copyWith(fontFamily: 'poppins'),
    labelMedium:
        GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF111827))
            .copyWith(fontFamily: 'poppins'),
    labelSmall:
        GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827))
            .copyWith(fontFamily: 'poppins'),

    // Body styles
    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF111827))
        .copyWith(fontFamily: 'poppins'),
    bodyMedium:
        GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF111827))
            .copyWith(fontFamily: 'poppins'),
    bodySmall: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF111827))
        .copyWith(fontFamily: 'poppins'),
  );
}