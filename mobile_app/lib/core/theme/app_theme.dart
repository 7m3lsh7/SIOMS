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
    scaffoldBackgroundColor: AppColors.bgLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.textDark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Sora', color: AppColors.textDark, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleLarge: TextStyle(fontFamily: 'Sora', color: AppColors.textDark, fontWeight: FontWeight.w700, fontSize: 24),
      bodyLarge: TextStyle(fontFamily: 'DMSans', color: AppColors.textDark, fontSize: 16),
      bodyMedium: TextStyle(fontFamily: 'DMSans', color: AppColors.textSub, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: 'Sora', color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppColors.textDark),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.bgDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Color(0xFF1C1C1E),
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSurface: AppColors.textMain,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Sora', color: AppColors.textMain, fontWeight: FontWeight.bold, letterSpacing: -0.5),
      titleLarge: TextStyle(fontFamily: 'Sora', color: AppColors.textMain, fontWeight: FontWeight.w700, fontSize: 24),
      bodyLarge: TextStyle(fontFamily: 'DMSans', color: AppColors.textMain, fontSize: 16),
      bodyMedium: TextStyle(fontFamily: 'DMSans', color: AppColors.textSub, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontFamily: 'Sora', color: AppColors.textMain, fontSize: 20, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: AppColors.textMain),
    ),
  );
}
