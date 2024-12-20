import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/shared/styles/colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColorOfLight),
  textTheme: TextTheme(
    displayMedium: GoogleFonts.lato(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.lato(
      color: Colors.black,
      fontSize: 25,
    ),
  ),
);
ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    displayMedium: GoogleFonts.lato(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColorOfDark),
);
