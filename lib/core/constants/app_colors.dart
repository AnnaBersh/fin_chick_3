import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();


  static const mainTextColor = Color(0xFFFBB500);  //main
  static const mainWhite =  Color(0xFFFFFFFF);
  static const mainBlack =  Color (0xFF000000);

  static const borderColor = Color (0xFFFFE97A);
  static const topBlue80 = Color (0xCC4171C8);  //80%
  static const topBlue100 = Color (0xFF4171C8); //100%
  static const topYellow80 = Color(0xCCFFFE17);  //80%
  static const topYellow100 = Color(0xFFFFFE17);
  static const mainOrange = Color(0xFFFBB500); //100
  static const shadowColor = Color(0xFF480202);
  static const chartBorder = Color(0xFF055781);


  // static const secondText =  Color(0xFFF3FF9E);
  // static const thirdText =  Color(0xFFFFF053);
  //
  // static const mainYellow =  Color(0xE5FBB500); //90%
  //
  // static const mainBLue = Color (0xFF09CED7);
  //
  // static const secondItemBg =  Color (0x80FFFF61); //50%
  // static const topBlueBg = Color(0xCC09CED7);  //80%
  // static const topOrangeBG = Color(0xCCFD911E); //80%
  // static const bottomNavBg = Color(0xB2B20500);  //70%
  // static const bottomNavBorder = Color(0xFFFFAC01);
  // static const progressBorder = Color(0xFFFE9F06);

  // static const popupYellowText = Color(0xFFFFCD00);
  // static const yellowBorder = Color (0xFF);
  //
  // static const goldenYellow =  Color(0xFFFFD700);

  static const LinearGradient loader = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFFF053),
      Color(0xFFF29517),
    ],
  );

  static const LinearGradient achievement = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF29517),
      Color(0xFFFFF053),
    ],
  );
}