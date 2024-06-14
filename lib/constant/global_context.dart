import 'package:flutter/material.dart';

import '../model/ItemResponseModel.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> navigatorKeyHome = GlobalKey<NavigatorState>();
  static  List<Records> listItems = [];
  static  List<Records> listItemsTmp = [];
  static String? notif_type = "";
  static String? notif_id = "";
  static bool isBottomSheetOpen = false;
  static bool isDataDownloading = false;
  static bool isNoInternetOpen = false;

}