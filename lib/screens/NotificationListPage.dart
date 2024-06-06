import 'dart:convert';
import 'package:chicken_delight/constant/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/colors.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_internet.dart';

class NotificationListPage extends StatefulWidget {
  final bool isFromHome;
  const NotificationListPage(this.isFromHome, {Key? key}) : super(key: key);

  @override
  BaseState<NotificationListPage> createState() => _NotificationListPageState();

}

class _NotificationListPageState extends BaseState<NotificationListPage> {
 // var listNotification = List<Notifications>.empty(growable: true);
  bool _isLoading = false;
  late ScrollController _scrollViewController;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 15;
  bool _isLastPage = false;
  bool isScrollingDown = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBG,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        automaticallyImplyLeading: false,
        title: getTitle("Notifications"),
        leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child:getBackArrowBlack()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBG,
      ),
        body: isOnline
          ? _isLoading
          ? const LoadingWidget()
        //   : listNotification.isEmpty
        //   ? MyNoDataWidget(msg: 'No notices yet!', imageName: "ic-no-notification.png", colorCode: const Color(0xFF5586aa),
        // subMsg:"You have currently no notifications.\nWe'll notify you when something\nnew arrives!", onTap: refreshData, btnTitle: "Back to Home",)
          : Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollViewController,
                      child: _listLayout(),
                    )
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
            ),
          )
          : const NoInternetWidget()
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
                Expanded(child: //listNotification.isNotEmpty ?
                SingleChildScrollView(
                  controller: _scrollViewController,
                  child: _listLayout(),
                )
             /* : MyNoDataWidget(msg: 'No notices yet!', imageName: "ic-no-notification.png", colorCode: const Color(0xFF5586aa),
                  subMsg:"You have currently no notifications.\nWe'll notify you when something\nnew arrives!", onTap: refreshData, btnTitle: "Back to Home",)*/
      ),

              ],
            )),
      ),
    );
  }

  void refreshData() {
    if ((widget as NotificationListPage).isFromHome == true) {
      Navigator.pop(context);
    }else {
      Navigator.pop(context);
      final BottomNavigationBar bar = bottomWidgetKey.currentWidget as BottomNavigationBar;
      bar.onTap!(0);
    }
  }

  Future<bool> _refresh() {
    print("refresh......");

    getList(true);

    return Future.value(true);
  }

  AnimationLimiter _listLayout() {
       return AnimationLimiter(
         child: ListView.builder(
             scrollDirection: Axis.vertical,
             physics: const NeverScrollableScrollPhysics(),
             primary: false,
             shrinkWrap: true,
             itemCount: 5,//listNotification.length,
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
                       /*  if(listNotification[index].contentType == "product_inquiry") {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => InquiryDetailScreen(listNotification[index].contentId.toString())));
                         }else if(listNotification[index].contentType == "order_reciver") {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummaryScreen(checkValidString(listNotification[index].contentId), false)));
                         }else if(listNotification[index].contentType == "order") {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSummaryScreen(checkValidString(listNotification[index].contentId), false)));
                         }else {
                         }*/
                       },
                       child: Column(
                         children: [
                           Card(
                               color: white,
                               clipBehavior: Clip.antiAliasWithSaveLayer,
                               elevation: 0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                   side: const BorderSide(color: kLightGray, width: 0.5)
                               ),
                             child: Padding(
                               padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                               child: Row(
                                 children: [
                                  /* Card(
                                       clipBehavior: Clip.antiAlias,
                                       elevation: 0,
                                       shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                           side: const BorderSide(color: kLightGray, width: 0.5)
                                       ),
                                       child: FadeInImage.assetNetwork(
                                           image: "${listNotification[index].image.toString().trim()}&h=500&zc=2",
                                           fit: BoxFit.cover,
                                           width: 65,
                                           height: 65,
                                           placeholder: 'assets/images/ic_logo_bag.png')
                                       //Image.asset('assets/images/ic_logo_bag.png', width:60, height: 60, fit: BoxFit.contain,)
                                   ),
                                   const Gap(5),*/
                                   Expanded(
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("message",//checkValidString(listNotification[index].message),
                                           maxLines: 2,
                                           overflow: TextOverflow.ellipsis,
                                           textAlign: TextAlign.start,
                                           style: TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w600),
                                         ),
                                         Gap(2),
                                         Text("3 Jun,2024, 03:00pm",//checkValidString(listNotification[index].time),
                                           maxLines: 1,
                                           overflow: TextOverflow.ellipsis,
                                           textAlign: TextAlign.start,
                                           style: TextStyle(fontSize: 13, color: kTextDarkGray, fontWeight: FontWeight.w500),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           // Container(
                           //     margin: const EdgeInsets.only(top: 5),
                           //     height: index == listNotification.length-1 ? 0 : 0.8, color: kLightestGray),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             )),
       );
    // );
  }

  @override
  void initState() {
    super.initState();

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

    if (isOnline) {
      //_getList(true);
    }

  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getList(false);
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

  //API call func...

  getList(bool isFirstTime) async {
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

      final url = Uri.parse(MAIN_URL + notificationUrl);
      Map<String, String> jsonBody = {
        /*'user_id': sessionManager.getUserId().toString().trim(),
        'login_type': 'admin',
        'apiId' : API_KEY,
        'limit' : _pageResult.toString(),
        'page' : _pageIndex.toString(),*/
      };

      final response = await http.post(url, body: jsonBody);
      final statusCode = response.statusCode;
      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
/*
      if (isFirstTime) {
        if (listNotification.isNotEmpty) {
          listNotification = [];
        }
      }

      if (statusCode == 200 && NotificationListResponse.fromJson(user).success == 1)
      {
        var notificationListResponse = NotificationListResponse.fromJson(user);

        if (notificationListResponse.notifications != null) {
          if (isFirstTime) {
            if (listNotification.isNotEmpty) {
              listNotification = [];
            }
          }

          List<Notifications>? _tempList = [];
          _tempList = notificationListResponse.notifications;
          listNotification.addAll(_tempList!);

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
      }*/
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

}
