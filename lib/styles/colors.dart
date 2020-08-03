import 'package:flutter/material.dart';

Color primaryGreenColor = Color(0xFF00a36f);
Color primaryGreenColorDark = Color(0xFF06614d);

class CustomColors {
  Color backgroundColorPrimary;
  Color backgroundColorSecondary;
  Color shadowColor;
  Color textColorPrimary;
  Color textColorSecondary;

  CustomColors({bool dark = false}) {
    if (!dark) {
      backgroundColorPrimary = Colors.white;
      backgroundColorSecondary = Color(0xFFf7f9f9);
      shadowColor = Color(0xFF003a4d).withOpacity(0.15);
      textColorPrimary = Color(0xFF212b2b);
      textColorSecondary = Colors.grey[500];
    } else {
      backgroundColorPrimary = Color(0xFF313436);
      backgroundColorSecondary = Color(0xFF16191a);
      shadowColor = Colors.black45;
      textColorPrimary = Colors.white;
      textColorSecondary = Colors.grey[500];
    }
  }

  // factory CustomColors.light() {
  //   return CustomColors(
  //     backgroundColorPrimary: Colors.white,
  //     backgroundColorSecondary: Color(0xFFFCFEFF),
  //     shadowColor: Colors.teal[900].withOpacity(0.15),
  //     textColorPrimary: Colors.teal[900],
  //     textColorSecondary: Colors.grey[500],
  //   );
  // }

  // factory CustomColors.dark() {
  //   return CustomColors(
  //     backgroundColorPrimary: Colors.grey[800],
  //     backgroundColorSecondary: Colors.grey[900],
  //     shadowColor: Colors.teal[900].withOpacity(0.15),
  //     textColorPrimary: Colors.white,
  //     textColorSecondary: Colors.grey[500],
  //   );
  // }
}
