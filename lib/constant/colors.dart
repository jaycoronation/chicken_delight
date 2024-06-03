import 'package:flutter/material.dart';

var bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();


const Color white = Color(0xffffffff);
const Color black = Color(0xff000000);
const Color appBg = Color(0xffF5F5F7);
const Color lightBrandColor = Color(0xffb9e2f7);
const Color primaryColor = Color(0xffA9102A);
const Color brandDarkColor = Color(0xff0080c0);
const Color text_dark_gray = Color(0xff444444);
const Color text_semidark_gray = Color(0xff666666);
const Color text_light_gray = Color(0xff999999);
const Color text_disabled = Color(0xffBDBDBD);
const Color bg_gray = Color(0xff10666666);
const Color grayNew = Color(0xffECECEC);
const Color lableHint= Color(0xff3A3A3A);


const Color bg_sunday= Color(0xffb0e1df);
const Color bg_holiday= Color(0xff99ffcc);
const Color bg_leave= Color(0xffe7fbd2);
const Color bg_extra_tp_area= Color(0xff20a1d9);


double kEditTextCornerRadius = 6.0;
double kBorderRadius = 10.0;

double contentSize = 14.0;
double smallFontSize = 11.0;
double titleSize = 18.0;
double textSize = 15.0;
double textFiledSize = 16.0;
double largeTextSize = 26.0;

double kSearchBarCornerRadius = 8.0;


double largeFont = 28;
double title = 24;
double titleFont = 22;
double subTitleFont = 20;
double medium = 18;
double subTitle = 17;
double description = 14;
double discription = 16;
double small = 12;
double kTextFieldCornerRadius = 6;


getAppBarTitleStyle() {
  return const TextStyle(fontSize: 20, color: white, fontWeight: FontWeight.w800);
}
getAppBarBlackTitleStyle() {
  return const TextStyle(fontSize: 17, color: black, fontWeight: FontWeight.w600);
}

getLargeTitleStyle(Color color) {
  return TextStyle(fontWeight: FontWeight.w500, color: color, fontSize: largeTextSize);
}

getTextFiledStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: white, fontSize: contentSize);
}

getThinTextStyle() {
  return TextStyle(fontWeight: FontWeight.w300, color: black, fontSize: textSize);
}
getGreenTextStyle() {
  return TextStyle(fontWeight: FontWeight.w600, color: Colors.green, fontSize: textSize);
}
getRedTextStyle() {
  return TextStyle(fontWeight: FontWeight.w600, color: Colors.red, fontSize: textSize);
}

getBlackTextStyle() {
  return TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: textSize);
}

getTextFieldStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: contentSize);
}

getLightTextStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: text_light_gray, fontSize: textSize);
}

getTextFieldHintStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: text_dark_gray, fontSize: contentSize);
}

getDropDownWidget() {
  return Image.asset('assets/images/ic_dropdown.png', height: 14, width: 14, color: black,);
}
getBlueDropDownWidget() {
  return Image.asset('assets/images/ic_dropdown.png', height: 14, width: 14, color: primaryColor,);
}

getTextStyle() {
  return TextStyle(fontWeight: FontWeight.w600, color: brandDarkColor, fontSize: textSize);
}

getTextTitleStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: brandDarkColor, fontSize: contentSize);
}

getSmallTextStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: white, fontSize: smallFontSize);
}
getBlackSmallTextStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: smallFontSize);
}

getTitleTextStyle() {
  return TextStyle(fontWeight: FontWeight.w500, color: white, fontSize: textFiledSize);
}

getWhiteSmallTextStyle() {
  return const TextStyle(fontWeight: FontWeight.w500, color: white, fontSize: 13);
}

getBottomSheetTitleTextStyle() {
  return TextStyle(fontWeight: FontWeight.w500, color: primaryColor, fontSize: textFiledSize);
}

getBlueTextStyle() {
  return TextStyle(fontWeight: FontWeight.w400, color: primaryColor, fontSize: textSize);
}

getTableTitleTextStyle() {
  return TextStyle(fontWeight: FontWeight.w800, color: white, fontSize: textSize);
}



