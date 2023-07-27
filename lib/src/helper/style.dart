import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//Colors
const black = Color(0xff000000);
const containerBorderLight = Color(0xffededed);
const containerBorderDark = Color(0xff555555);
const darkGrey= Color.fromARGB(255, 58, 58, 58);
final grey100 =Colors.grey[100];
final grey200 =Colors.grey[200];
final grey300 =Colors.grey[300];
final grey500 =Colors.grey[500];
final grey600 =Colors.grey[600];
final grey700 =Colors.grey[700];
final grey800 =Colors.grey[800];
const scaffoldBg = Color(0xffffffff);
const black1 = Color(0xff111111);
const appBarColor = Color(0xffFFFBFE);
const appBarIconCol = Color(0xff49454F);
const violet = Color(0xff6E41E2);
const violetWeb = Color(0xff6750A4);
const lightGrey = Color.fromARGB(255, 163, 163, 163);
const red = Color(0xffFF565E);
const blackColor = Colors.black;
const lightGreyColor = Color(0xffA4B8D0);
const greytextColor = Color(0xffBCA4A4);
const formBgColor =Color(0xffF9F7FF);
const brown =Color(0xffD18450);
const sideNavExpansionBg =Color.fromARGB(255, 235, 237, 240);
const sideNavYellow =Color(0xffEFC11E);
const appbarWebFontColor =  Color.fromARGB(255, 153, 150, 150);

const white = Color(0xffffffff);
const grey= Color(0xffb8b8b8);
const greyShade2= Color(0xffd1d1d1);
const greyShade3= Color(0xff3d3d3d);
const blue = Color(0xff2A98F8);
const green = Color(0xff0cb41d);
const lightGreen = Color(0xffcef8c7);
const yellow = Color(0xffdfba01);
const lighrYellow = Color(0xfffff8d6);
const pink = Color(0xfffc3465);
const lightBlack = Color(0xff3e3e3e);
const lightPink = Color(0xfffff0f0);
const textFormFieldColorLight = Color.fromARGB(255, 241, 241, 241);
const textFormFieldColorDark = Color(0xff484848);


//Fonts
robotoWithColor(color, double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.roboto(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, color: color, letterSpacing: letterSpacing,);
notoSans(color, double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.notoSans(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, color: color, letterSpacing: letterSpacing,);
montserrat(color, double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.montserrat(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, color: color, letterSpacing: letterSpacing,);
poppins(double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.poppins(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, letterSpacing: letterSpacing,);
poppins1(color, double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.poppins(color : color, fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, letterSpacing: letterSpacing,);
roboto(double fontsize, double letterSpacing, [fontWeight, lineHeight]) => GoogleFonts.roboto(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, letterSpacing: letterSpacing, height: lineHeight);
lato(double fontsize, double letterSpacing, [fontWeight]) => GoogleFonts.lato(fontSize: fontsize.sp, fontWeight: fontWeight ?? FontWeight.normal, letterSpacing: letterSpacing,);