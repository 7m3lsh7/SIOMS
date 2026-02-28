import 'package:flutter/material.dart';

class AppColors {
  // --- Futuristic Premium Palette ---

  // Backgrounds
  static const Color bgDark = Color(0xFF020408);
  static const Color bgLight = Color(0xFFF2F5F9);

  // Accent & Brand
  static const Color primary = Color(0xFF007AFF); // Apple Blue
  static const Color secondary = Color(0xFF5856D6); // Premium Purple
  static const Color accent = Color(0xFF32ADE6); // Cyan

  // Status
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color danger = Color(0xFFFF3B30);

  // Glass Surface Tokens (Dark Mode)
  static const Color glassBG = Color(0x1AFFFFFF); // 10% White
  static const Color glassBorder = Color(0x33FFFFFF); // 20% White
  static const Color glassShadow = Color(0x40000000); // 25% Black

  // Glass Surface Tokens (Light Mode)
  static const Color glassBGLight = Color(0x66FFFFFF); // 40% White
  static const Color glassBorderLight = Color(0x4D007AFF); // 30% Primary

  // Typography
  static const Color textMain = Color(0xFFF2F2F7);
  static const Color textSub = Color(0xFF8E8E93);
  static const Color textDark = Color(0xFF1C1C1E);

  // Legacy compatibility members (if needed by older screens)
  static const Color text = Color(0xFF1C1C1E);
  static const Color text2 = Color(0xFF8E8E93);
  static const Color text3 = Color(0xFF8E8E93);
  static const Color bg = Color(0xFFF2F5F9);
}
