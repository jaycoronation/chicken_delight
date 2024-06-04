import 'package:flutter/material.dart';

class HomePageMenuGetSet {
  String name = "";
  String titleColor = "";
  String count = "";
  String bgColor = "";
  String arrowColor = "";
  String itemIcon = "";

  HomePageMenuGetSet({required String nameStatic, required String titleColorStatic, required String bgColorStatic, required String itemIconStatic,
    required String countStatic, required String arrowColorStatic}) {
    name = nameStatic;
    titleColor = titleColorStatic;
    bgColor = bgColorStatic;
    itemIcon = itemIconStatic;
    count = countStatic;
    arrowColor = arrowColorStatic;
  }
}
