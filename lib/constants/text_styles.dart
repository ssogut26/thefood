import 'package:flutter/material.dart';
import 'package:thefood/constants/colors.dart';

class ProjectTextStyles extends TextTheme {
  TextTheme get textTheme => const TextTheme(
        headline1: TextStyle(
          fontFamily: 'Roboto',
          color: ProjectColors.black,
          fontSize: 23,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        headline2: TextStyle(
          fontFamily: 'Roboto',
          color: ProjectColors.black50,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        bodyText1: TextStyle(
          fontFamily: 'Roboto',
          color: ProjectColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        bodyText2: TextStyle(
          fontFamily: 'Roboto',
          color: ProjectColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
        subtitle1: TextStyle(
          fontFamily: 'Roboto',
          color: ProjectColors.black50,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
        ),
      );
}
