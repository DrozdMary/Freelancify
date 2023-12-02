import 'package:flutter/material.dart';
import 'colors.dart';

class TextStyles {


//NORMAL
  static TextStyle get normText => TextStyle(color: MyColors.darkBlue, fontSize: 15.0, fontFamily: 'montserrat'
      // fontWeight: FontWeight.w700,
      );

  static TextStyle get normText13 => TextStyle(color: MyColors.darkBlue, fontSize: 13.0, fontFamily: 'montserrat'
      // fontWeight: FontWeight.w700,
      );

  static TextStyle get normText10 => TextStyle(color: MyColors.darkBlue, fontSize: 10.0, fontFamily: 'montserrat'
      // fontWeight: FontWeight.w700,
      );


  static TextStyle get boldText => TextStyle(color: MyColors.darkBlue, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'montserrat');


  static TextStyle get boldText22 => TextStyle(color: MyColors.darkBlue, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: 'montserrat');





//GREEN

  static TextStyle get boldGreenText18 => TextStyle(
          color: MyColors.emeraldGreen,
          fontSize: 18,
          fontWeight: FontWeight.w600, fontFamily: 'montserrat'
      );

  static TextStyle get normalGreenText => TextStyle(
        color: MyColors.emeraldGreen,
        fontSize: 18,
      );

  static TextStyle get normalGreenText14 => TextStyle(
        color: MyColors.emeraldGreen,
        fontSize: 14,
      );



//WHITE

  static TextStyle get boltWhiteText16 => TextStyle(
    color: MyColors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static TextStyle get normalWhiteText => TextStyle(
        color: MyColors.white,
        fontSize: 18,
      );

  static TextStyle get normalWhiteText15 => TextStyle(
        color: MyColors.white,
        fontSize: 15,
      );

  static TextStyle get bigButtonText => TextStyle(
    color: MyColors.white,
    fontWeight: FontWeight.w600,
    fontSize: 25,
  );

//RED

  static TextStyle get boldRedText18 => TextStyle(color: MyColors.red, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'montserrat');
}
