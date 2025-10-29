import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: 'Ubuntu',
  primaryColor: const Color(0xFF5D2E95),           // Purple
  primaryColorLight: const Color(0xFF5D2E95),      // Purple
  primaryColorDark: const Color(0xFF43206B),       // Darker Purple
  secondaryHeaderColor: const Color(0xFFB38937),   // Gold
  cardColor: const Color(0xFFFFFFFF),
  disabledColor: const Color(0xFF9E9E9E),
  scaffoldBackgroundColor: const Color(0xFFF7F9FC),
  brightness: Brightness.light,
  hintColor: const Color(0xFF838383),
  focusColor: const Color(0xFFFFFFFF),
  hoverColor: const Color(0xFF5D2E95),             // Purple
  shadowColor: const Color(0xFFD1D5DB),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF5D2E95),                    // Purple
    secondary: Color(0xFFB38937),                  // Gold
    tertiary: Color(0xFFFF6767),
    onTertiary: Color(0xFFffda6d),
    surfaceTint: Color(0xFF5D2E95),                // Purple
  ).copyWith(
    surface: const Color(0xFFF7F9FC),
    error: const Color(0xFFFF6767),
  ),
);