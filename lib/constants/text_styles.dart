import 'package:flutter/material.dart';

class ProjectTextStyles extends TextTheme {
  TextTheme get textTheme => const TextTheme(
        headline1: TextStyle(
          fontFamily: 'Lora',
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
        headline2: TextStyle(
          fontFamily: 'Lora',
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
        headline3: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
        ),
        headline4: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        headline5: TextStyle(
          fontFamily: 'Nunito',
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      );
}
