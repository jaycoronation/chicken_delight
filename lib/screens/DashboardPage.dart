import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:chicken_delight/constant/api_end_point.dart';
import 'package:chicken_delight/model/DashboardResponseModel.dart';
import 'package:chicken_delight/screens/OrderDetailScreen.dart';
import 'package:chicken_delight/utils/app_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';

import '../common_widget/common_widget.dart';
import '../constant/colors.dart';
import '../model/HomePageMenuModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/TextChanger.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_internet.dart';
import 'NotificationListPage.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  BaseState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends BaseState<DashboardPage> {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  List<Order> listOrders = [];
  List<HomePageMenuGetSet> analysisList = [];
  String deviceName = '';


  @override
  void initState() {

    getDeviceData();
    getDashboardData();

    isHomeLoad = false;
    super.initState();
  }

  Future<void> getDeviceData() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
      deviceName = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.utsname.machine ?? '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var textRefresh = context.watch<TextChanger>().addOrder;
    print("Chart data<<><><><><><>>${textRefresh}}");

    if (textRefresh != null && textRefresh.isNotEmpty) {
      //Future.delayed(const Duration(seconds: 5)).then((val) {
        getDashboardData();
     // });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        backgroundColor: appBG,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          title: Container(
            alignment: Alignment.topLeft,
            child: Image.asset('assets/images/ic_chicken_logo.png', height: 40, width: 100),
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                startActivity(context,  const NotificationListPage(true));
              },
              child:
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: primaryColor,
                    ),
                    height: 36,
                    width: 36,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                    child: Image.asset('assets/images/ic_notifications.png', color: white, height: 17, width: 17),
                  ),
                  Visibility(
                    //visible: sessionManager.getUnreadNotificationCount()! > 0,
                    child: Positioned(
                      right: 2,
                      top: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: white,
                        ),
                        height: 22,
                        width: 22,
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(left: 20),
                        child: Center(
                          child: Text("0",
                              style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: small)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
          ],
          centerTitle: false,
          elevation: 0,
          backgroundColor: appBG,
        ),
        body: isOnline
            ? _isLoading
            ? const LoadingWidget()
            : setData()
            : const NoInternetWidget()
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Padding setData() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: _refresh,
          child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: listOrders.isNotEmpty,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top:10, bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 22),
                                    child: Text("Orders",
                                        style: TextStyle(fontWeight: FontWeight.w800, color: black,fontSize: titleFont20)),
                                  ),
                                  const Gap(12),
                                  SizedBox(
                                    height: 140,
                                    child: _orderListView() ,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12,),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(top:10, bottom: 10, left: 10),
                                  child: Text("Activity", style: TextStyle(fontWeight: FontWeight.w800, color: black,fontSize: titleFont20)),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 280,
                                  child: Card(
                                      color: white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Padding(padding: const EdgeInsets.all(10), child: _topCountList())),
                                ),
                                const Gap(10),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          )
        ));
  }

  GridView _topCountList() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 120, crossAxisSpacing: 6, mainAxisSpacing: 10),
      controller: _scrollController,
      itemCount: analysisList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            if (analysisList[index].name == "Products") {
              final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
              bar.onTap!(1);
            } else if (analysisList[index].name == "Orders") {
             // _orderList(context);
              final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
              bar.onTap!(3);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Color(int.parse(analysisList[index].bgColor.replaceAll('#', '0x'))),
                borderRadius: const BorderRadius.all(Radius.circular(22))),
            padding: const EdgeInsets.only(left: 10, right: 6, bottom: 0,top: 10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(analysisList[index].itemIcon, height: 32, width: 32,),
                const Gap(12),
                analysisList[index].name == "Total Amount"
                ? Text(getPrice(analysisList[index].count ?? ""),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: subTitle))
                : Text(analysisList[index].count ?? "",
                    textAlign: TextAlign.center,
                    style:  TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: titleFont20)),
                const Gap(8),
                Row(
                  children: [
                    Expanded(
                        child: Text(analysisList[index].name ?? "", textAlign: TextAlign.start,
                        style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: small))
                    ),
                    Visibility(
                        visible: analysisList[index].name != "Total Amount",
                        child: Image.asset('assets/images/ic_right_arrow_new.png', height: 14, width: 14, color: black))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  ListView _orderListView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: listOrders.length > 5
            ? 5
            : listOrders.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              print(checkValidString(listOrders[index].id));
              orderDetailPage(context, checkValidString(listOrders[index].id));
            },
            child: Container(
                width:listOrders.length > 1 ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.only(right: 6, left: index == 0 ? 22.0 : 0.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(kTextFieldCornerRadius)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(6),
                    Container(
                      margin: const EdgeInsets.only(left: 2),
                      alignment: Alignment.center,
                      // width: 55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Order Number", textAlign: TextAlign.start,
                              style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: small)),
                          Gap(6),
                          Text("Grand Total", textAlign: TextAlign.start,
                              style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: small)),
                          Gap(6),
                          Text("Remark", textAlign: TextAlign.start,
                              style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: small)),
                          Gap(6),
                          Text("Order-Date", textAlign: TextAlign.start,
                              style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: small)),
                          Gap(6),
                          Text("Status", textAlign: TextAlign.start,
                              style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: small)),
                        ],
                      ),
                    ),
                    const Gap(4),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(":", textAlign: TextAlign.start, style: TextStyle(color: hintLight, fontWeight: FontWeight.w400, fontSize: small)),
                        Gap(6),
                        Text(":", textAlign: TextAlign.start, style: TextStyle(color: hintLight, fontWeight: FontWeight.w400, fontSize: small)),
                        Gap(6),
                        Text(":", textAlign: TextAlign.start, style: TextStyle(color: hintLight, fontWeight: FontWeight.w400, fontSize: small)),
                        Gap(6),
                        Text(":", textAlign: TextAlign.start, style: TextStyle(color: hintLight, fontWeight: FontWeight.w400, fontSize: small)),
                        Gap(6),
                        Text(":", textAlign: TextAlign.start, style: TextStyle(color: hintLight, fontWeight: FontWeight.w400, fontSize: small)),
                      ],
                    ),
                    const Gap(4),
                    Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(checkValidString(listOrders[index].orderNumber), textAlign: TextAlign.start, maxLines: 1,
                                  style:  TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                              const Gap(6),
                              Text(checkValidString(getPrice(listOrders[index].grandTotal ?? "")),
                                  textAlign: TextAlign.start,maxLines: 1,
                                  style:  TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                              const Gap(6),
                              Text(checkValidString(listOrders[index].remarks), textAlign: TextAlign.start, maxLines: 1,
                                  style: TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                              const Gap(6),
                              Text(getDateFromTimestamp(checkValidString(listOrders[index].timestamp)), textAlign: TextAlign.start, maxLines: 1,
                                  style:  TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: small)),
                              const Gap(6),
                              Text(checkValidString(listOrders[index].status), textAlign: TextAlign.start, maxLines: 1,
                                  style:  TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: small)),
    
                            ],
                          ),
                        )
                    ),
                    const Gap(6),
                  ],
                )),
          );
        },
    );
  }

  Future<void> orderDetailPage(BuildContext context, String orderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(orderId)),
    );
    print("result ===== $result");
    if (result == "success") {
      getDashboardData();
    }
  }

  Future<bool> _refresh() {
    getDashboardData();
    return Future.value(true);
  }

  @override
  void castStatefulWidget() {
    widget is DashboardPage;
  }


  // API call function...
  void getDashboardData() async {
    if (isOnline)
    {
      setState(() {
        _isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + dashboardUrl);
      Map<String, String> jsonBody = {
        'type': sessionManager.getType() ?? "",
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });

      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> dashboardData = jsonDecode(body);
      var dataResponse = DashboardResponseModel.fromJson(dashboardData);

      if (statusCode == 200 && dataResponse.success == 1) {
        var records = dataResponse.dashboardRecords;

        listOrders = records?.order ?? [];

        setState(() {
          _isLoading = false;
        });

        analysisList = [
          HomePageMenuGetSet(
              nameStatic: "Products",
              titleColorStatic: "#ff95b5ad",
              bgColorStatic: "#ffedf2f4",
              itemIconStatic: "assets/images/slicing-24.png",
              countStatic: "1",
              arrowColorStatic: "#ff95b5ad"),
          HomePageMenuGetSet(
              nameStatic: "Orders",
              titleColorStatic: "#ff809dd6",
              bgColorStatic: "#ffe7ebf7",
              itemIconStatic: "assets/images/slicing-27.png",
              countStatic: records?.totalOrders ?? "",
              arrowColorStatic: "#ff809dd6"),
          HomePageMenuGetSet(
              nameStatic: "Total Amount",
              titleColorStatic: "#ffedab7e",
              bgColorStatic: "#fff7eae2",
              itemIconStatic: "assets/images/slicing-28.png",
              countStatic:records?.totalValue?.toStringAsFixed(2) ?? "" ,
              arrowColorStatic: "#ffedab7e"),
        ];

      } else {
        showSnackBar(dataResponse.message, context);

        setState(() {
          _isLoading = false;
        });
      }

    }
    else
    {
      setState(() {
        _isLoading = false;
      });
      noInternetSnackBar(context);
    }

    var fcmToken = await FirebaseMessaging.instance.getToken();
    print("***************$fcmToken");
    updateDeviceTokenRequest(fcmToken ?? "");

  }

  void updateDeviceTokenRequest(String fcmToken) async {
    if (isOnline) {
      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + updateDeviceToken);

      var deviceType = "";
      if (Platform.isIOS)
      {
        deviceType = "ios";
      }
      else
      {
        deviceType = "android";
      }

      Map<String, String> jsonBody = {
        "user_id": sessionManager.getUserId() ?? "",
        "device_type": deviceType,
        "device_token": fcmToken,
        "device_name": deviceName
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });
      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var cardResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && cardResponse.success == 1) {
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      noInternetSnackBar(context);
    }

  }


}