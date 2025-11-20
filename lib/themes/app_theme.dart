import 'package:flutter/material.dart';

class AppTheme {
  // Dark theme colors - music-inspired, non-bright
  static const Color darkBackground = Color(0xFF0A0E27);
  static const Color cardBackground = Color(0xFF1A1F3A);
  static const Color accentTeal = Color(0xFF4ECDC4);
  static const Color accentPurple = Color(0xFF9B6B9E);
  static const Color textPrimary = Color(0xFFE8E9ED);
  static const Color textSecondary = Color(0xFFB0B3C1);
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: accentTeal,
    colorScheme: const ColorScheme.dark(
      primary: accentTeal,
      secondary: accentPurple,
      surface: cardBackground,
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        letterSpacing: -2,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: textSecondary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textSecondary,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
  );
}