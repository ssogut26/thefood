import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ProjectColors {
  static const mainWhite = Color(0xFFF4F9F9);
  static const secondWhite = Color(0xFFFFFFFF);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF1A1A1A);
  static const lightGrey = Color(0xFFC7C7C7);
  static const darkGrey = Color(0XFF444941);
  static const yellow = Color(0xFFFFCC29);
  static const containerYellow = Color(0xFFFFF59D);
  static const actionsBgColor = Color.fromARGB(200, 199, 199, 199);

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1, -0.3),
    end: Alignment(1, 0.3),
  );
}
