import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyle {
  static const TextStyle bigPlusPlus = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 50,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle bigPlus = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle big = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle bigLight = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static const TextStyle h1Bold = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle h2Bold = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle h2Normal = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 18,
    fontWeight: FontWeight.w200,
    color: whiteColor,
  );
  static const TextStyle h3Bold = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle h3Normal = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static const TextStyle h4Bold = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle h4Normal = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static const TextStyle h5Normal = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static const TextStyle thinSmall = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static const TextStyle boldSmall = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );
  static const TextStyle verySmall = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 9,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );
  static TextStyle customizable({
    required Color color,
    required FontWeight fontWeight,
    required double size,
  }) =>
      TextStyle(
        fontFamily: 'Montserrat',
        color: color,
        fontSize: 9.0,
        fontWeight: fontWeight,
      );

  static withColor({
    required Color color,
    required TextStyle style,
  }) =>
      style.copyWith(color: color);

  static withSize({
    required TextStyle style,
    required FontWeight weight,
    Color? color,
  }) =>
      style.copyWith(fontWeight: weight, color: color);
}
