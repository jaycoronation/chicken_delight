import 'dart:convert';

import 'package:chicken_delight/constant/api_end_point.dart';
import 'package:chicken_delight/model/OrderListResponseModel.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';

import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../common_widget/common_widget.dart';
import '../constant/colors.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/TextChanger.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import '../widget/no_internet.dart';
import 'OrderDetailScreen.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends BaseState<OrderListPage> {
  bool _isLoading = false;

  List<OrderList> listOrders = List<OrderList>.empty(growable: true);
  List<OrderList> listOrdersMain = List<OrderList>.empty(growable: true);

  List<CommonResponseModel> orderFilterOption = List<CommonResponseModel>.empty(growable: true);
  var orderStatus = "";
  TextEditingController searchController = TextEditingController();
  var searchText = "";
  late ScrollController _scrollViewController;
  late AutoScrollController controller;
  PageController pageController = PageController(viewportFraction: 1, keepPage: true);

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 8;
  bool _isLastPage = false;


  // bool _isSearchHideShow = false;
  bool isScrollingDown = false;
  final scrollDirection = Axis.horizontal;

  List<String> orderStatusDataMap = [
    "Accept Order",
    "Cancel Order",
    "Ship Order",
    "Print Bill"
  ];


  @override
  void initState() {
    orderFilterOption.add(CommonResponseModel(success: 0, message: 'All', isSelected: true));
    orderFilterOption.add(CommonResponseModel(message: "Accepted"));
    orderFilterOption.add(CommonResponseModel(message: "Processed"));
    orderFilterOption.add(CommonResponseModel(message: "Delivered"));
    orderFilterOption.add(CommonResponseModel(message: "Cancelled"));

    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);

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
      getOrderListData(true);
    } else {
      noInternetSnackBar(context);
    }

    isOrderListLoad = false;

    super.initState();
  }

/*  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var textRefresh = context.watch<TextChanger>().refreshListData.toString();

    print("Order History set data<<><><><><><>>" + textRefresh);

    if(textRefresh == "refreshOrderListData")
    {
      if (isOnline) {
        getOrderListData(true);
      } else {
        noInternetSnackBar(context);
      }

    }

  }*/

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getOrderListData(false);
        });
      }
    }
  }

  Future<bool> _refresh() {
    if (isOnline) {
      getOrderListData(true);
    } else {
      noInternetSnackBar(context);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBG,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: isOrderListSearch ? 110 : kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Order History"),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  isOrderListSearch = !isOrderListSearch;
                  searchController.text = "";
                  searchText = "";
                });

                getOrderListData(false);
                // showSnackBar("Show Filter Dialog", context);
              },
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                child: Icon(
                  isOrderListSearch ? Icons.search_off : Icons.search_rounded,
                  size: 26,
                  color: black,
                ),
              ),
            ),
            const Gap(15)
          ],
          bottom: _isLoading ? null : PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child:  Column(
              children: [
                Container(height: 36, width: double.infinity,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: false,
                      controller: controller,
                      itemCount: orderFilterOption.length,
                      itemBuilder: (ctx, index) =>
                          AutoScrollTag(
                            key: ValueKey(index),
                            controller: controller,
                            index: index,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              height: 36,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: black,
                                  backgroundColor: orderFilterOption[index].isSelected ?? false ? black : white,
                                  elevation: 0.0,
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                  side: const BorderSide(color: black, width: 0.5, style: BorderStyle.solid),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTextFieldCornerRadius),),
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                  animationDuration: const Duration(milliseconds: 100),
                                  enableFeedback: true,
                                  alignment: Alignment.center,
                                ),
                                onPressed: () {
                                  setState(() {
                                    for (var j = 0; j < orderFilterOption.length; j++) {
                                      if (index == j) {
                                        orderFilterOption[j].isSelected = true;
                                      } else {
                                        orderFilterOption[j].isSelected = false;
                                      }
                                    }
                                  });

                                  if (orderFilterOption[index].message == "All") {
                                    orderStatus = "";
                                  } else {
                                    orderStatus = checkValidString(orderFilterOption[index].message);
                                  }

                                  if (isOnline) {
                                    getOrderListData(true);
                                  } else {
                                    noInternetSnackBar(context);
                                  }
                                },
                                child: Text(orderFilterOption[index].message.toString(),
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: orderFilterOption[index].isSelected ?? false
                                      ? white : black),),
                              ),
                            ),
                          )
                  ),),
                const Gap(8),
                Visibility(
                  visible: isOrderListSearch,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kTextFieldCornerRadius), // if you need this
                          side: const BorderSide(
                            color: white,
                            width: 0,
                          ),
                        ),
                        elevation: 0,
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            textAlign: TextAlign.start,
                            controller: searchController,
                            cursorColor: black,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: black,
                            ),
                            decoration: InputDecoration(
                                hintText: "Search by order id...",
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                  const BorderSide(color: Colors.transparent, width: 0),
                                  borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                ),
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: black,
                                ),
                                suffixIcon: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child: const Icon(
                                    Icons.close,
                                    size: 26,
                                    color: black,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      isOrderListSearch = false;
                                      searchController.text = "";
                                      searchText = "";
                                    });

                                    getOrderListData(false);
                                  },
                                )
                            ),
                            onChanged: (text) {
                              searchController.text = text;
                              searchController.selection = TextSelection.fromPosition(TextPosition(offset: searchController.text.length));
                          /*    setState(() {
                                if (text.isNotEmpty) {
                                  listOrders = [];
                                  for (int i = 0; i < listOrdersMain.length; i++) {
                                    if (listOrdersMain[i].orderNumber.toString().toLowerCase().contains(text.toString().toLowerCase())) {
                                      listOrders.add(listOrdersMain[i]);
                                    }
                                  }
                                } else {
                                  listOrders = listOrdersMain;
                                }
                              });*/

                              if (text.isEmpty) {
                                setState(() {
                                  searchText = "";
                                });

                                getOrderListData(true);
                              }
                              else if (text.length > 1) {
                                setState(() {
                                  searchText = searchController.text.toString().trim();
                                });
                                getOrderListData(true);
                              }
                            },
                          ),
                        )),
                  ),
                ),
              ],
            ) ,
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: appBG,
        ),
        body: isOnline
            ? _isLoading
            ? const LoadingWidget()
            : listOrders.isEmpty
            ? MyNoDataWidget(
          msg: 'No order yet!',
          imageName: "ic-no-order.png",
          colorCode: Color(0xFF6a89ba),
          subMsg:"You have currently no orders.\nWe'll notify you when something\nnew arrives!",
          onTap: () {}, btnTitle: '',
        )
            : setData()
            : const NoInternetWidget()
    );
  }

  Widget setData() {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      controller: pageController,
      itemCount: orderFilterOption.length,
      onPageChanged: (index){
        controller.scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
        setState(() {
          for (var j = 0; j < orderFilterOption.length; j++) {
            if (index == j) {
              orderFilterOption[j].isSelected = true;
            } else {
              orderFilterOption[j].isSelected = false;
            }
          }
        });

        if (orderFilterOption[index].message == "All") {
          orderStatus = "";
        } else {
          orderStatus = checkValidString(orderFilterOption[index].message);
        }

        if (isOnline) {
          getOrderListData(true);
        } else {
          noInternetSnackBar(context);
        }
      },
      itemBuilder: (context, index) {
        return RefreshIndicator(
          color: primaryColor,
          onRefresh: _refresh,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollViewController,
                      child: AnimationLimiter(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: listOrders.length,
                            itemBuilder: (ctx, index) => AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      print( checkValidString(listOrders[index].id));
                                      showOrderSummery(context, checkValidString(listOrders[index].id), false);
                                      setState(() {
                                        isOrderListSearch = false;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: Card(
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                  visible: listOrders[index].status == "Payment Pending",
                                                  child: const Gap(8)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text("Order Number", textAlign: TextAlign.start,
                                                            style: TextStyle(fontSize: 12, color: kGray, fontWeight: FontWeight.w600),
                                                          ),
                                                          const Gap(8),
                                                          Text(checkValidString(listOrders[index].orderNumber), textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                     /* Text(checkValidString(listOrders[index].paymentMethod), textAlign: TextAlign.start,
                                                       style: const TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.w600),
                                                      ),*/
                                                      const Gap(5)
                                                    ],
                                                  ),
                                                  FittedBox(
                                                    child: Container(
                                                      margin: const EdgeInsets.only(bottom: 8,),
                                                      alignment: Alignment.topRight,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                                                        color:  kLightGray,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 6.0, bottom: 6, left: 8, right: 7),
                                                        child: Text(listOrders[index].status.toString(),
                                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: black),),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const DottedLine(dashLength: 1, dashGapLength: 6, lineThickness: 1, dashRadius: 3, dashColor: kTextDarkGray),
                                              const Gap(5),
                                              ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  itemCount: listOrders[index].items?.length,
                                                  itemBuilder: (ctx, i) =>
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                     /* Container(
                                                        margin: const EdgeInsets.only(left: 3, top: 8, bottom: 10, right: 10),
                                                        height: 60,
                                                        width: 60,
                                                        child: Card(
                                                          clipBehavior: Clip.antiAlias,
                                                          elevation: 0,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                                              side: const BorderSide(color: kLightGray, width: 0.5)
                                                          ),
                                                          child: FadeInImage.assetNetwork(
                                                            image: "${listOrders[index].items?[i].image.toString().trim()}&h=500&zc=2",
                                                            placeholder: 'assets/images/ic_logo_primaryColor.png',
                                                            fit: BoxFit.cover,
                                                            height: 60,
                                                            width: 60,
                                                          ),
                                                        ),
                                                      ),*/
                                                      Expanded(
                                                          child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(checkValidString(toDisplayCase(listOrders[index].items![i].item.toString().trim())),
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 13, color: black, fontWeight: FontWeight.bold),
                                                          ),
                                                          const Gap(2),
                                                          Text("${checkValidString(listOrders[index].items?[i].quantity)} X ${checkValidString(getPrice(listOrders[index].items![i].basePrice.toString()))}",
                                                            textAlign: TextAlign.start,
                                                            style: const TextStyle(fontSize: 13, color: kTextDarkGray, fontWeight: FontWeight.w600),
                                                          ),
                                                          /*Text(
                                                                "${checkValidString(toDisplayCase(listOrders[index].city.toString()))} ${(
                                                                    checkValidString(toDisplayCase(listOrders[index].state.toString())))}",
                                                                textAlign: TextAlign.start,
                                                                overflow: TextOverflow.clip,
                                                                style: const TextStyle(fontSize: 13, color: kTextDarkGray, fontWeight: FontWeight.w600),
                                                              ),*/
                                                        ],
                                                      )
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Card(
                                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                                elevation: 0,
                                                color: appBG,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(12),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(child: Container(
                                                        margin: const EdgeInsets.only(right: 12),
                                                        child: Text(checkValidString(listOrders[index].timestamp),
                                                          //(universalDateConverter('MMM d,yyyy h:mm:a', 'dd MMM yyyy', checkValidString(listOrders[index].orderDate)))
                                                          textAlign: TextAlign.start,
                                                          style: const TextStyle(fontSize: 12, color: hintDark, fontWeight: FontWeight.w300),
                                                        ),
                                                      )),
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 2),
                                                        child: Text(getPrice(listOrders[index].grandTotal.toString()),
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(fontSize: 12, color: black, fontWeight: FontWeight.w600),
                                                        ),
                                                      ),
                                                      Container(
                                                          margin: const EdgeInsets.only(left: 6),
                                                          alignment: Alignment.center,
                                                          child: Image.asset("assets/images/ic_right_arrow_new.png", width: 10, height: 10, color: Colors.black)),
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
                                ),
                              ),
                            )
                        ),
                      ),
                    )),
                if (_isLoadingMore == true)
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 30, height: 30,
                            child: Lottie.asset('assets/images/loader_new.json', repeat: true, animate: true, frameRate: FrameRate.max)),
                        const Text(
                            ' Loading more...',
                            style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: 16)
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void castStatefulWidget() {
    widget is OrderListPage;
  }

  Future<void> showOrderSummery(BuildContext context, String orderID, bool isFromList) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailScreen(orderID)),
    );
    print("result ===== $result");

    if (result == "success") {
      getOrderListData(true);
    }
  }


  //API call function...
  void getOrderListData(bool isFirstTime) async {
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

    final url = Uri.parse(MAIN_URL + orderListUrl);
    Map<String, String> jsonBody = {
      'limit': _pageResult.toString(),
      'page': _pageIndex.toString(),
      'status': orderStatus,
      'search': searchText,
      "total": "2"
    };

    final response = await http.post(url, body: jsonBody, headers: {
    "Authorization": sessionManager.getToken().toString(),
    });
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> order = jsonDecode(body);
    var dataResponse = OrderListResponseModel.fromJson(order);

    if (isFirstTime) {
      if (listOrders.isNotEmpty) {
        listOrders = [];
      }
    }

    if (statusCode == 200 && dataResponse.success == 1) {
      if (dataResponse.orderList != null) {
        if (isFirstTime) {
          if (listOrders.isNotEmpty) {
            listOrders = [];
          }
        }

        List<OrderList>? _tempList = [];
        _tempList = dataResponse.orderList;
        listOrders.addAll(_tempList!);

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
    } else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

}