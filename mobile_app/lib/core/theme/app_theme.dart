import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_colors.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      await prefs.setBool('isDark', true);
    } else {
      state = ThemeMode.light;
      await prefs.setBool('isDark', false);
    }
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.text,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Sora', color: AppColors.text, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Sora', color: AppColors.text, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'DMSans', color: AppColors.text),
      bodyMedium: TextStyle(fontFamily: 'DMSans', color: AppColors.text2),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,
      surface: AppColors.darkSurface,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.darkText,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Sora', color: AppColors.darkText, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Sora', color: AppColors.darkText, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'DMSans', color: AppColors.darkText),
      bodyMedium: TextStyle(fontFamily: 'DMSans', color: AppColors.darkText2),
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
  );
}
