import 'package:flutter/widgets.dart';

class ProjectPaddings {
  ProjectPaddings._();
  static const pageSmall = EdgeInsets.all(4);
  static const pageMedium = EdgeInsets.all(8);
  static const pageLarge = EdgeInsets.all(24);

  static const cardSmall = EdgeInsets.only(bottom: 4);
  static const cardMedium = EdgeInsets.only(bottom: 8);
  static const cardLarge = EdgeInsets.only(bottom: 12);

  static const textHorizontalSmall = EdgeInsets.symmetric(horizontal: 4, vertical: 2);
  static const textHorizontalMedium = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const textHorizontalLarge = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  static const textVerticalSmall = EdgeInsets.symmetric(vertical: 4);
  static const textVerticalMedium = EdgeInsets.only(top: 8);
  static const textVerticalLarge = EdgeInsets.symmetric(vertical: 12);

  static const cardImagePadding = EdgeInsets.only(
    top: 80,
    left: 20,
    right: 10,
  );

  static const cardImagePaddingSmall = EdgeInsets.only(
    top: 30,
  );
}
