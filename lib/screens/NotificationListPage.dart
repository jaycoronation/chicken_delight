import 'dart:convert';
import 'package:chicken_delight/constant/api_end_point.dart';
import 'package:chicken_delight/model/NotificationsResponseModel.dart';
import 'package:chicken_delight/screens/OrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/colors.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import '../widget/no_internet.dart';

class NotificationListPage extends StatefulWidget {
  final bool isFromHome;
  const NotificationListPage(this.isFromHome, {Key? key}) : super(key: key);

  @override
  BaseState<NotificationListPage> createState() => _NotificationListPageState();

}

class _NotificationListPageState extends BaseState<NotificationListPage> {
  List<NotificationRecords> listNotification = [];
  bool _isLoading = false;
  late ScrollController _scrollViewController;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.pop(context, "success");
      },
      child: Scaffold(
        backgroundColor: appBG,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Notifications"),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context, "success");
              },
              child:getBackArrowBlack()),
          elevation: 0,
          backgroundColor: appBG,
          centerTitle: false,
          actions: [
            Visibility(
              visible: listNotification.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 10,bottom: 10, right: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: white, backgroundColor: white,
                      elevation: 0.0,
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0,left: 15,right: 15),
                      side: const BorderSide(color: black, width: 1.0, style: BorderStyle.solid),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      tapTargetSize: MaterialTapTargetSize.padded,
                      animationDuration: const Duration(milliseconds: 100),
                      enableFeedback: true,
                      alignment: Alignment.center,
                    ),
                    onPressed: () async {
                      _openBottomSheetForRemove();
                    },
                    child: const Text("Mark All Read",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w500),
                    )
                ),
              ),
            )
          ],

        ),
          body: isOnline
            ? _isLoading
            ? const LoadingWidget()
            : _setData()
            : const NoInternetWidget()
      ),
    );
  }

  SafeArea _setData() {
    return SafeArea(
      child: RefreshIndicator(
        color: primaryColor,
        onRefresh: _refresh,
        child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Column(
              children: [
                Expanded(child: listNotification.isNotEmpty ?
                SingleChildScrollView(
                  controller: _scrollViewController,
                  child: _listLayout(),
                )
              : MyNoDataWidget(msg: 'No notices yet!', imageName: "ic-no-notification.png", colorCode: const Color(0xFF5586aa),
                  subMsg:"You have currently no notifications.\nWe'll notify you when something\nnew arrives!", onTap: refreshData, btnTitle: "Back to Home",)
                ),
                if (_isLoadingMore == true)
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 30, height: 30,
                            child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                        const Text(' Loading more...',
                            style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                        )
                      ],
                    ),
                  ),
              ],
            )),
      ),
    );
  }

  void refreshData() {
    if ((widget as NotificationListPage).isFromHome == true)
    {
      Navigator.pop(context);
    }
    else
    {
      Navigator.pop(context);
      final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
      bar.onTap!(0);
    }
  }

  Future<bool> _refresh() {
    print("refresh......");

    getNotificationList(true);

    return Future.value(true);
  }

  AnimationLimiter _listLayout() {
    return AnimationLimiter(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          itemCount: listNotification.length,
          itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Container(
                  color: appBG,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      notificationRead(listNotification[index].id ?? "", listNotification[index].link ?? "");
                    },
                    child: Column(
                      children: [
                        Card(
                          color: listNotification[index].readTimestamp!.isNotEmpty ? white : grayNew,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                              side: const BorderSide(color: kLightGray, width: 0.5)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(listNotification[index].title ?? "",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 15, color: black, fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    Text(listNotification[index].timestamp ?? "",
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 14, color: kTextDarkGray, fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Text(listNotification[index].message ?? "",
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    ApiService.fetchData().then((response) {
      var data = response as CommonResponseModel;
      if (data.success == 1)
      {
      }
      else
      {
        invalidTokenRedirection(context);
      }
    });

    _scrollViewController = ScrollController();
    _scrollViewController.addListener(() {

      if (_scrollViewController.position.userScrollDirection == ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }
      if (_scrollViewController.position.userScrollDirection == ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }

      pagination();

    });

    getNotificationList(true);

  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getNotificationList(false);
        });
      }
    }
  }

  @override
  void castStatefulWidget() {
    widget is NotificationListPage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> orderDetailPage(BuildContext context, String orderID) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(orderID, false)),
    );
    print("result ===== $result");

    if (result == "success") {
      getNotificationList(true);
    }
  }

  void _openBottomSheetForRemove() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(height: 16,),
                Container(height: 2, width: 40, color: black, margin: const EdgeInsets.only(bottom: 12)),
                const Text("Mark All Read Notifications?",
                    style: TextStyle(color: black, fontWeight: FontWeight.w500, fontSize: 18)),
                Container(height: 20,),
                const Text("Are you sure want to mark as read all Notifications?",
                    style: TextStyle(color: black, fontWeight: FontWeight.normal, fontSize: 16),
                    textAlign: TextAlign.center),
                Container(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 22, right: 22),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: black, backgroundColor: black,
                        elevation: 0.0,
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonCornerRadius)),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        animationDuration: const Duration(milliseconds: 100),
                        enableFeedback: true,
                        alignment:
                        Alignment.center,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        notificationClearRequest();
                      },
                      child: const Text("Clear",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600),
                      )),
                ),
                Container(height: 22,),
              ],
            )
          ],
        );
      },
    );
  }


  //API call func...
  void getNotificationList(bool isFirstTime) async {
    if (isOnline)
    {
      if (isFirstTime) {
        setState(() {
          _isLoading = true;
          _isLoadingMore = false;
          _pageIndex = 0;
          _isLastPage = false;
        });
      }

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + notificationList);
      Map<String, String> jsonBody = {
        'limit' : _pageResult.toString(),
        'page' : _pageIndex.toString(),
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });
      final statusCode = response.statusCode;
      final body = response.body;
      Map<String, dynamic> notificationData = jsonDecode(body);
      var dataResponse = NotificationsResponseModel.fromJson(notificationData);

      if (isFirstTime) {
        if (listNotification.isNotEmpty) {
          listNotification = [];
        }
      }

      if (statusCode == 200 && dataResponse.success == 1)
      {
        if (dataResponse.notificationRecords != null) {
          if (isFirstTime) {
            if (listNotification.isNotEmpty) {
              listNotification = [];
            }
          }

          List<NotificationRecords>? _tempList = [];
          _tempList = dataResponse.notificationRecords ?? [];
          listNotification.addAll(_tempList);

          if (_tempList.isNotEmpty) {
            _pageIndex += 1;
            if (_tempList.isEmpty || _tempList.length % _pageResult != 0) {
              _isLastPage = true;
            }
          }
        }

        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });

      }
      else
      {
        setState(()
        {
          _isLoading = false;
          _isLoadingMore = false;

        });
      }
    }
    else
    {
      noInternetSnackBar(context);
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void notificationRead(String notificationId, String orderID) async {
    if (isOnline)
      {
        HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
          HttpLogger(logLevel: LogLevel.BODY),
        ]);

        final url = Uri.parse(MAIN_URL + notificationSave);

        Map<String, String> jsonBody = {'id': notificationId};

        final response = await http.post(url, body: jsonBody, headers: {
          "Authorization": sessionManager.getToken().toString(),
        });

        final statusCode = response.statusCode;
        final body = response.body;
        Map<String, dynamic> apiResponse = jsonDecode(body);
        var dataResponse = CommonResponseModel.fromJson(apiResponse);

        if (statusCode == 200 && dataResponse.success == 1) {
          if (orderID.isNotEmpty)
          {
            orderDetailPage(context, orderID);
          }
          else
          {
            //showSnackBar("No order Id found", context);
          }
        } else {
          showSnackBar(dataResponse.message, context);
        }
      }
    else
    {
      noInternetSnackBar(context);
    }

  }

  void notificationClearRequest() async {
    if (isOnline)
      {
        setState(() {
          _isLoading = true;
        });
        HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
          HttpLogger(logLevel: LogLevel.BODY),
        ]);

        final url = Uri.parse(MAIN_URL + notificationClear);

        Map<String, String> jsonBody = {
          //'id': notificationId
        };

        final response = await http.post(url, body: jsonBody, headers: {
          "Authorization": sessionManager.getToken().toString(),
        });

        final statusCode = response.statusCode;
        final body = response.body;
        Map<String, dynamic> apiResponse = jsonDecode(body);
        var dataResponse = CommonResponseModel.fromJson(apiResponse);

        if (statusCode == 200 && dataResponse.success == 1) {
          setState(() {
            _isLoading = false;
          });
          listNotification.clear();

          getNotificationList(true);

        } else {
          setState(() {
            _isLoading = false;
          });
          showSnackBar(dataResponse.message, context);
        }
      }
    else
      {
        noInternetSnackBar(context);
      }
  }

}
