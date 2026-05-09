// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Primary Colors
const Color primaryColor = Color(0xFFF97316); // Orange
const Color secondaryColor = Color(0xFF0F172A); // Dark Slate
const Color backgroundColor = Color(0xFFF8FAFC); // Light Gray
const Color surfaceColor = Colors.white;
const Color unselectedColor = Color(0xFF94A3B8); // Gray

const List<BoxShadow> postShadow = [
  BoxShadow(
    color: Color(0x29000000),
    offset: Offset(
      0.0,
      3.0,
    ),
    blurRadius: 6,
    spreadRadius: 0,
  ), //BoxShadow
  BoxShadow(
    color: Colors.white,
    offset: Offset(0.0, 0.0),
    blurRadius: 0.0,
    spreadRadius: 0.0,
  ),
];

// Modern bottom nav shadow
const List<BoxShadow> bottomNavShadow = [
  BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 20,
    offset: Offset(0, -5),
  ),
];

ThemeData appTheme = ThemeData(
  useMaterial3: true,
  textTheme: GoogleFonts.tajawalTextTheme(),
  appBarTheme: AppBarTheme(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.tajawal(
          color: Colors.white, fontSize: 15)),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    secondary: secondaryColor,
    surface: surfaceColor,
  ),
  scaffoldBackgroundColor: backgroundColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: unselectedColor,
  ),
);
