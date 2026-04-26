// utils/app_theme.dart
// Central theme and color constants for the app

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFF5F2ED);  // Warm off-white
  static const surface = Color(0xFFFFFFFF);
  static const dark = Color(0xFF0D0D0D);         // Near black
  static const darkCard = Color(0xFF111111);
  static const grey = Color(0xFF8A8A8A);
  static const lightGrey = Color(0xFFE8E4DF);
  static const accent = Color(0xFF0D0D0D);
  static const success = Color(0xFF2ECC71);
  static const tag = Color(0xFFF0EDE8);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.dark,
        secondary: AppColors.grey,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.dark,
          letterSpacing: -1,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.dark,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.dark,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.dark,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 15, color: AppColors.dark,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 13, color: AppColors.grey,
        ),
        labelSmall: GoogleFonts.spaceGrotesk(
          fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w600,
          color: AppColors.grey,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.dark, letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.dark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.dark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: GoogleFonts.dmSans(color: AppColors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      ),
    );
  }
}

/// Custom page transitions
class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;
  FadeSlideTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.04),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 380),
        );
}
