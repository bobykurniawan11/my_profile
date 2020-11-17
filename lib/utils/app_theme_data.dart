import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeData {
  BuildContext context;
  AppThemeData({this.context});
  final BorderRadius borderRadius = BorderRadius.circular(8);

  final Color colorYellow = Color(0xffffff00);
  final Color colorPrimary = Colors.green;
  final Color colorSecondary = Colors.greenAccent;

  TextTheme get myTextTheme {
    return GoogleFonts.latoTextTheme().copyWith(
      button: GoogleFonts.lato(
        textStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      headline1: GoogleFonts.lato(
        textStyle: TextStyle(fontSize: 28),
      ),
      headline2: GoogleFonts.lato(
        textStyle: TextStyle(fontSize: 22),
      ),
      headline3: GoogleFonts.lato(
        textStyle: TextStyle(fontSize: 16),
      ),
      caption: GoogleFonts.lato(
        textStyle: TextStyle(color: Colors.black45, fontSize: 18),
      ),
    );
  }

  ThemeData get myCustomTheme {
    return ThemeData(
        primaryColor: colorPrimary, accentColor: colorSecondary, textTheme: myTextTheme);
  }
}
