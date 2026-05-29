import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF9B30D9);
  static const Color primaryDark = Color(0xFF7B1FB5);
  static const Color primaryLight = Color(0xFFD4A8F5);
  static const Color accent = Color(0xFFF0D9FF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color darkGrey = Color(0xFF424242);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
        ),
        textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
          bodyLarge: GoogleFonts.lato(fontSize: 16),
          bodyMedium: GoogleFonts.lato(fontSize: 14),
          bodySmall: GoogleFonts.lato(fontSize: 12),
          labelLarge:
              GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: GoogleFonts.lato(color: AppColors.grey, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
        scaffoldBackgroundColor: AppColors.background,
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primaryLight,
          secondary: AppColors.primary,
          surface: const Color(0xFF1E1E1E),
        ),
        textTheme:
            GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme)
                .copyWith(
          bodyLarge: GoogleFonts.lato(fontSize: 16),
          bodyMedium: GoogleFonts.lato(fontSize: 14),
          bodySmall: GoogleFonts.lato(fontSize: 12),
          labelLarge:
              GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryLight,
            letterSpacing: 2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.darkGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          hintStyle: GoogleFonts.lato(color: AppColors.grey, fontSize: 14),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: AppColors.primaryLight,
          unselectedItemColor: AppColors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 12,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      );
}
