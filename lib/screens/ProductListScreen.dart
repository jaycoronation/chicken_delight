import 'dart:convert';

import 'package:chicken_delight/constant/global_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  var subTotal = 0.0;
  var grandTotal = 0.0;
  List<Records> listItemsAPI = [];



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
              : NavigationService.listItems.isEmpty
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
                      itemCount: NavigationService.listItems.length,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        
                        var getSet = NavigationService.listItems[index];

                        return AnimationConfiguration.staggeredList(
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
                                  borderRadius: BorderRadius.circular(kContainerCornerRadius),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(getSet.icon ?? "",
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
                                              Text(getSet.name ?? "",
                                                  style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                  overflow: TextOverflow.clip
                                              ),
                                              Text(getSet.productCode ?? "",
                                                  style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                  overflow: TextOverflow.clip
                                              ),
                                              Text(getPrice(getSet.mrpPrice ?? ""),
                                                  style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                  overflow: TextOverflow.clip
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                    Gap(8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Visibility(
                                          visible:getSet.quantity == null || getSet.quantity.toString() == "0",
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              setState(() {
                                                getSet.quantity = 1;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(kContainerCornerRadius),
                                                border: Border.all(color: grayDividerDetail, width: 0.8),
                                              ),
                                              alignment: Alignment.center,
                                              child:  Text("Add",
                                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: small)),
                                            ),
                                          ),
                                        ),
                                        Gap(12),
                                        Visibility(
                                          visible: getSet.quantity != null && getSet.quantity.toString() != "0",
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(kContainerCornerRadius),
                                              border: Border.all(color: grayDividerDetail, width: 0.8),
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (isOnline)
                                                        {
                                                          if (getSet.quantity == 1) {
                                                            removeItem(index);
                                                          } else {
                                                            getSet.quantity = getSet.quantity! - 1;
                                                          }

                                                          var total = num.parse(getSet.salePrice.toString()) * num.parse((getSet.quantity ?? "").toString());
                                                          getSet.amount = total;
                                                        }
                                                        else
                                                        {
                                                          noInternetSnackBar(context);
                                                        }
                                                      });

                                                    },
                                                    icon:const Icon(Icons.remove)//Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                                ),
                                                Text((getSet.quantity ?? 0).toString(),
                                                    style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: small)),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (isOnline)
                                                        {
                                                          getSet.quantity = ((getSet.quantity ?? 0) + 1);
                                                          var total = num.parse(getSet.salePrice.toString()) * num.parse(getSet.quantity.toString());
                                                          getSet.amount = total;

                                                        }
                                                        else
                                                        {
                                                          noInternetSnackBar(context);
                                                        }
                                                      });

                                                    },
                                                    icon: const Icon(Icons.add)//Image.asset('assets/images/ic_blue_add.png', height: 24, width: 24),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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


  void removeItem(int index) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 2,
                    width: 40,
                    alignment: Alignment.center,
                    color: black,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('Remove Product', style: TextStyle(fontSize: medium, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: Text('Are you sure want to remove this product?', style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.4, color: black),
                              borderRadius: BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                            ),
                            margin: const EdgeInsets.only(right: 10),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No',
                                    style: TextStyle(
                                      fontSize: subTitle,
                                      fontWeight: FontWeight.w600,
                                      color: black,
                                    ))),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kButtonCornerRadius),
                              color: black,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  for (int i = 0; i < listItemsAPI.length; i++)
                                  {
                                    if (listItemsAPI[i].id == NavigationService.listItems[index].id)
                                    {
                                      listItemsAPI[i].isSelected = false;
                                    }
                                  }

                                  NavigationService.listItems.removeAt(index);

                                  Navigator.pop(context);

                                });
                              },
                              child: Text('Yes', style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w600, color: white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
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
        if (NavigationService.listItems.isNotEmpty) {
          NavigationService.listItems = [];
        }
      }

      if (statusCode == 200 && dataResponse.success == 1) {
        if (dataResponse.records != null) {
          if (isFirstTime) {
            if (NavigationService.listItems.isNotEmpty) {
              NavigationService.listItems = [];
            }
          }

          List<Records>? _tempList = [];
          _tempList = dataResponse.records;
          NavigationService.listItems.addAll(_tempList!);

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