import 'package:flutter/material.dart';
import 'colors.dart';

class TextStyles {
  static TextStyle get normText => TextStyle(color: MyColors.darkBlue, fontSize: 15.0, fontFamily: 'montserrat'
      // fontWeight: FontWeight.w700,
      );
  static TextStyle get bigButtonText => TextStyle(
        color: MyColors.white,
        fontWeight: FontWeight.w600,
        fontSize: 25,
      );
  static TextStyle get boldText => TextStyle(
      color: MyColors.darkBlue,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'montserrat');
  static TextStyle get normalGreenText => TextStyle(
        color: MyColors.emeraldGreen,
        fontSize: 18,
      );
}
