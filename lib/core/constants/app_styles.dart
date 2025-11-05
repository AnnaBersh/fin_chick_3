import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppStyles {
  // Text styles
  static final titleAppBarYel = GoogleFonts.knewave(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.mainTextColor,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.shadowColor, blurRadius: 4),
    ],
  );

  static final onboardingMainTextYel = GoogleFonts.knewave(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: AppColors.mainTextColor,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.shadowColor, blurRadius: 4),
    ],
  );

  static final bigButtonYel = GoogleFonts.knewave(
    fontSize: 43,
    fontWeight: FontWeight.w400,
    color: AppColors.mainTextColor,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.shadowColor, blurRadius: 4),
    ],
  );

  static final mediumYel = GoogleFonts.knewave(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.mainTextColor,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.shadowColor, blurRadius: 4),
    ],
  );

  static final smallYel = GoogleFonts.knewave(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.mainTextColor,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.shadowColor, blurRadius: 4),
    ],
  );

  static final mediumWhite = GoogleFonts.knewave(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(2, 2), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

  static final smallSecondWhite = GoogleFonts.laila(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final smallSecondYel = GoogleFonts.laila(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mainTextColor,
  );

  static final mediumSecondBlue = GoogleFonts.laila(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.topBlue100,
  );

  static final mediumSecondWhite = GoogleFonts.laila(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final achievementDescription = GoogleFonts.laila(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
  );

  static final statListWhite = GoogleFonts.laila(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.mainWhite,
  );

  static final statListYel = GoogleFonts.laila(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.mainTextColor,
  );

  static final statListBlue = GoogleFonts.laila(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.topBlue100,
  );

  static final chartDescription = GoogleFonts.laila(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mainWhite,
    shadows: [
      Shadow(offset: Offset(1, 1), color: AppColors.mainBlack, blurRadius: 4),
    ],
  );

}
