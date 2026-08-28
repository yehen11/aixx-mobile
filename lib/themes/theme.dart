/*
@Author - yehenSamarasinghe
@Date - 2026/08/27
*/

import 'package:flutter/material.dart';
import 'utils.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: canvasBase,
      colorScheme: ColorScheme.dark(
        surface: canvasBase,
        primary: actionHighlight,
        onPrimary: Colors.white,
        secondary: successColor,
        error: errorColor,
        onError: Colors.white,
        outline: glossOutline,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: onSurfaceColor),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: onSurfaceColor),
        headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onSurfaceColor),
        bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: onSurfaceColor, height: 1.6),
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: onSurfaceColor, height: 1.5),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurfaceColor),
        labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: mutedTextColor),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: canvasBase,
        foregroundColor: onSurfaceColor,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCards,
        hintStyle: TextStyle(color: mutedTextColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardRadius),
          borderSide: BorderSide(color: glossOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardRadius),
          borderSide: BorderSide(color: glossOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCardRadius),
          borderSide: BorderSide(color: actionHighlight, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: surfaceCards,
        indicatorColor: actionHighlight.withOpacity(0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: actionHighlight,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCards,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardRadius),
          side: BorderSide(color: glossOutline),
        ),
      ),
      iconTheme: IconThemeData(color: onSurfaceColor),
    );
  }

  static ThemeMode get themeMode => ThemeMode.dark;
}