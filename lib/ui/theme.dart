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
    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
          color: ProjectColors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
