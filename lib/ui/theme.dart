import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thefood/core/constants/colors.dart';
import 'package:thefood/core/constants/text_styles.dart';

class ProjectTheme {
  ThemeData lightTheme = ThemeData(
    primaryTextTheme: ProjectTextStyles().textTheme,
    scaffoldBackgroundColor: ProjectColors.mainWhite,
    useMaterial3: true,
    textTheme: ProjectTextStyles().textTheme,
    appBarTheme: const AppBarTheme(
      shadowColor: Colors.black,
      elevation: 0,
      backgroundColor: ProjectColors.mainWhite,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(cardAndTextButtonBorderValue)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: ProjectColors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardAndTextButtonBorderValue),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: ProjectTextStyles().textTheme.headline3,
        backgroundColor: ProjectColors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(elevatedButtonBorderValue),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderValue),
        borderSide: const BorderSide(
          width: 1.5,
          color: ProjectColors.black,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderValue),
        borderSide: const BorderSide(
          width: 2,
          color: ProjectColors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderValue),
        borderSide: const BorderSide(
          width: 1.5,
          color: ProjectColors.black,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderValue),
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderValue),
        borderSide: const BorderSide(
          width: 1.5,
          color: Colors.red,
        ),
      ),
      labelStyle: ProjectTextStyles().textTheme.bodyText2,
      hintStyle: ProjectTextStyles().textTheme.bodyText1,
      errorStyle: ProjectTextStyles().textTheme.bodyText1,
    ),
  );
}

double get cardAndTextButtonBorderValue => 10;

double get elevatedButtonBorderValue => 15;

double get inputBorderValue => 5;
