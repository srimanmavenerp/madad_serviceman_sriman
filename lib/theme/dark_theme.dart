import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Ubuntu',
  primaryColor: const Color(0xFF5D2E95),           // Purple
  primaryColorLight: const Color(0xFFB38937),      // Gold (for contrast in dark mode)
  primaryColorDark: const Color(0xFF43206B),       // Darker Purple
  secondaryHeaderColor: const Color(0xFFB38937),   // Gold
  cardColor: const Color(0xFF1A1333),              // Dark purple background
  disabledColor: const Color(0xFF484848),
  scaffoldBackgroundColor: const Color(0xFF010d15),
  brightness: Brightness.dark,
  hintColor: const Color(0xFFB38937),              // Gold hint
  focusColor: const Color(0xFF5D2E95),             // Purple
  hoverColor: const Color(0xFFB38937),             // Gold
  shadowColor: const Color(0xFF4a5361),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF5D2E95),                    // Purple
    secondary: Color(0xFFB38937),                  // Gold
    tertiary: Color(0xFFFF6767),
    onTertiary: Color(0xFFffda6d),
    surfaceTint: Color(0xFF5D2E95),                // Purple
  ).copyWith(
    surface: const Color(0xFF010d15),
    error: const Color(0xFFdd3135),
  ),
);
