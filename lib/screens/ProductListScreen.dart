import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/ItemResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import '../widget/no_internet.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  BaseState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseState<ProductListScreen> {
  bool isLoading = false;
  List<Records> listItems = [];
  bool _isLoading = false;


  late ScrollController _scrollViewController;
  bool isScrollingDown = false;
  final scrollDirection = Axis.horizontal;

  bool _isLoadingMore = false;
  int _pageIndex = 0;
  final int _pageResult = 10;
  bool _isLastPage = false;
  TextEditingController searchController = TextEditingController();
  var searchText = "";
  bool _isSearchHideShow = false;


  @override
  void initState() {
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

    getItemListData(true);

    super.initState();
  }

  void pagination() {
    if (!_isLastPage && !_isLoadingMore) {
      if ((_scrollViewController.position.pixels == _scrollViewController.position.maxScrollExtent)) {
        setState(() {
          _isLoadingMore = true;
          getItemListData(false);
        });
      }
    }
  }

  Future<bool> _refresh() {
    getItemListData(true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          backgroundColor: chicken_bg,
          appBar: AppBar(
            toolbarHeight: _isSearchHideShow ? 110 : kToolbarHeight,
            automaticallyImplyLeading: false,
            title: getTitle("Products"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: chicken_bg,
            actions: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _isSearchHideShow = !_isSearchHideShow;
                    searchController.text = "";
                    searchText = "";
                  });

                  if (!_isSearchHideShow)
                  {
                    getItemListData(false,true);
                  }

                },
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: Icon(
                    _isSearchHideShow ? Icons.search_off : Icons.search_rounded,
                    size: 26,
                    color: black,
                  ),
                ),
              ),
              const Gap(15)
            ],
            bottom: _isLoading ? null : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child:  Visibility(
                visible: _isSearchHideShow,
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
                      child: SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: TextField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.start,
                          controller: searchController,
                          cursorColor: black,
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: subTitle, color: black),
                          decoration: InputDecoration(
                              hintText: "Search by name...",
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent, width: 0),
                                borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                              ),
                              hintStyle: const TextStyle(fontWeight: FontWeight.w300, color: black),
                              suffixIcon: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                child: const Icon(Icons.close, size: 26, color: black),
                                onTap: () {
                                  setState(() {
                                    _isSearchHideShow = false;
                                    searchController.text = "";
                                    searchText = "";
                                  });

                                  getItemListData(false,true);
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
                              getItemListData(true,true);
                            }
                            else if (text.length > 2) {
                              setState(() {
                                searchText = searchController.text ?? "";
                              });
                              getItemListData(true,true);
                            }
                          },
                        ),
                      )),
                ),
              ) ,
            ),
          ),
          body: isOnline
              ? _isLoading
              ? const LoadingWidget()
              : listItems.isEmpty
              ? MyNoDataWidget(
            msg: 'No product yet!',
            imageName: "ic-no-order.png",
            colorCode: const Color(0xFF6a89ba),
            subMsg:"You have currently no products.\nWe'll notify you when something\nnew arrives!",
            onTap: () {}, btnTitle: '')
              : setData()
              : const NoInternetWidget()
        ),
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
    );
  }

  Widget setData() {
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
                      itemCount: listItems.length,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(listItems[index].icon ?? "",
                                          fit: BoxFit.cover,
                                          height: 70,
                                          width:70,
                                        ),
                                      ),
                                      const Gap(12),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(listItems[index].name ?? "",
                                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip
                                            ),
                                            Text(listItems[index].productCode ?? "",
                                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip
                                            ),
                                            Text(getPrice(listItems[index].mrpPrice ?? ""),
                                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                overflow: TextOverflow.clip
                                            ),
                                          ],
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
                    Text(' Loading more...',
                        style: TextStyle(color: black, fontWeight: FontWeight.w400, fontSize: subTitle)
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }


  @override
  void castStatefulWidget() {
   widget is ProductListScreen;
  }

  //API call function...
  void getItemListData(bool isFirstTime, [bool isFromSearch = false]) async {
    if (isOnline) {
      if (isFirstTime) {
        setState(() {
          if (isFromSearch)
          {
            _isLoadingMore = false;
            _pageIndex = 0;
            _isLastPage = false;
          }
          else
          {
            _isLoading = true;
            _isLoadingMore = false;
            _pageIndex = 0;
            _isLastPage = false;
          }
        });
      }

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + itemList);
      Map<String, String> jsonBody = {
        'category_id': "",
        'limit': _pageResult.toString(),
        'page': _pageIndex.toString(),
        'search': searchText,
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });
      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> order = jsonDecode(body);
      var dataResponse = ItemResponseModel.fromJson(order);

      if (isFirstTime) {
        if (listItems.isNotEmpty) {
          listItems = [];
        }
      }

      if (statusCode == 200 && dataResponse.success == 1) {
        if (dataResponse.records != null) {
          if (isFirstTime) {
            if (listItems.isNotEmpty) {
              listItems = [];
            }
          }

          List<Records>? _tempList = [];
          _tempList = dataResponse.records;
          listItems.addAll(_tempList!);

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

    } else {
      noInternetSnackBar(context);
    }

  }

}