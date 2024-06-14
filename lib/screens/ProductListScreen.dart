import 'dart:convert';
import 'dart:io';

import 'package:chicken_delight/constant/global_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/ItemResponseModel.dart';
import '../model/StoreMenuModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/TextChanger.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/loading.dart';
import '../widget/no_data.dart';
import '../widget/no_internet.dart';
import 'AddOrderScreen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  BaseState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseState<ProductListScreen> {
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
  bool isListLayout = true;

  late AutoScrollController controller;
  var _currentPosi = 0;
  List<CategoryMenu> listCategory = [];
  int cartCount = 0;
  final shakeKey = GlobalKey<ShakeWidgetState>();

  String catId = "";

  @override
  void initState() {

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

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.removeListener(() {});
    _scrollViewController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var textRefresh = context.watch<TextChanger>().refreshProductList;
    print("Chart data<<><><><><><>>$textRefresh}");

    if (textRefresh.isNotEmpty) {
      getItemListData(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: chicken_bg,
        appBar: AppBar(
          toolbarHeight: _isSearchHideShow ? 110 : kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Items"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: chicken_bg,
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (NavigationService.listItems.isNotEmpty) {
                  if (isListLayout) {
                    isListLayout = false;
                  } else {
                    isListLayout = true;
                  }

                  setState(() {
                    _isSearchHideShow = false;
                  });

                }else {
                  showSnackBar("Products not found.", context);
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(6),
                child: isListLayout
                    ? Image.asset('assets/images/ic_grid.png', height: 22, width: 22)
                    : Image.asset('assets/images/ic_list.png', height: 22, width: 22),
              ),
            ),
            const Gap(10),
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
                height: 30,
                alignment: Alignment.center,
                child: Icon(
                  _isSearchHideShow ? Icons.search_off : Icons.search_rounded,
                  size: 24,
                  color: black,
                ),
              ),
            ),
            const Gap(10),
            ShakeMe(
              key: shakeKey,
              shakeCount: 2,
              shakeOffset: 5,
              shakeDuration: const Duration(milliseconds: 500),
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    redirectToCart();
                  },
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                        child: Image.asset('assets/images/ic_cart.png', height: 28, width: 28),
                      ),
                      Visibility(
                        visible: cartCount > 0,
                        child: Positioned(
                          right: 2,
                          top: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: lightPrimaryColor,
                            ),
                            height: 22,
                            width: 22,
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(left: 20),
                            child: Center(
                              child: Text(cartCount.toString(),
                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: small)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Image.asset("assets/images/ic_cart.png",width: 28,height: 28,),
              ),
            ),
            const Gap(20)
          ],
          bottom: _isLoading ? null : PreferredSize(
            preferredSize: const Size.fromHeight(36),
            child:  Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 36,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: scrollDirection,
                    controller: controller,
                    shrinkWrap: false,
                    itemCount: listCategory.length,
                    itemBuilder:(context, index) {
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: controller,
                        index: index,
                        child: Container(
                          margin: const EdgeInsets.only(left: 5,right: 5),
                          child:ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: black,
                              backgroundColor: listCategory[index].isSelected ? black : white,
                              elevation: 0.0,
                              padding: const EdgeInsets.only(left: 15,right: 15),
                              side: const BorderSide(color: black, width: 0.5, style: BorderStyle.solid),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kTextFieldCornerRadius),),
                              tapTargetSize: MaterialTapTargetSize.padded,
                              animationDuration: const Duration(milliseconds: 100),
                              enableFeedback: true,
                              alignment: Alignment.center,
                            ),
                            onPressed: () {
                              setState(() {
                                for (var j = 0; j < listCategory.length; j++) {
                                  if (index == j) {
                                    listCategory[j].isSelected = true;
                                  } else {
                                    listCategory[j].isSelected = false;
                                  }
                                }

                              });

                              if (listCategory[index].id == "all") {
                                catId = "";
                              } else {
                                catId = checkValidString(listCategory[index].id);
                              }
                              print("catId-----" +catId);
                              getItemListData(true);
                            },
                            child: Text(listCategory[index].name,
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,
                                    color: listCategory[index].isSelected ? white : black)),
                          ),
                        ),
                      );
                    },

                  ),
                ) ,
                const Gap(6),
                Visibility(
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

                                    getItemListData(true,true);
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
                ),
              ],
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
            : const NoInternetWidget(),
      floatingActionButton: isCheckAny()
          ? FloatingActionButton.extended(
        onPressed: () {
          redirectToCart();
        },
        backgroundColor: black,
        label: Text("Proceed", style: getWhiteSmallTextStyle(),)
        //child: const Icon(Icons.navigate_next_outlined, color: white,),
      ) : null,
      );
  }

  Widget setData() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                controller: _scrollViewController,
                child: isListLayout ? _listLayout() : _gridLayout(),
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
    );
  }

  AnimationLimiter _listLayout() {
    return AnimationLimiter(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ListView.builder(
          itemCount: NavigationService.listItems.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 80),
          itemBuilder: (context, index) {
            var getSet = NavigationService.listItems[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(getSet.name ?? "",
                                    style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip
                                ),
                                const Gap(8),
                                Text(getSet.productCode ?? "",
                                    style: TextStyle(fontSize: small, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                    overflow: TextOverflow.clip
                                ),
                                const Gap(8),
                                Row(
                                  children: [
                                    Text(getPrice(getSet.salePrice ?? ""),
                                        style: TextStyle(fontSize: small, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip
                                    ),
                                    const Gap(5),
                                    Text(getPrice(getSet.mrpPrice ?? ""),
                                      style: TextStyle(fontSize: small, color: gray_dark,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,decoration: TextDecoration.lineThrough),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                // Visibility(
                                //   visible:getSet.quantity != null && getSet.quantity.toString() != "0",
                                //   child: Text(getPrice(getSet.amount?.toStringAsFixed(2) ?? "") ,
                                //     style: TextStyle(fontSize: description, color: black,
                                //       fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),
                                //     textAlign: TextAlign.right,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          const Gap(18),
                          Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(getSet.icon ?? "",
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width:70,
                                ),
                              ),
                              const Gap(18),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible:getSet.quantity == null || getSet.quantity.toString() == "0",
                                    child: InkWell(
                                      //behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        if (Platform.isAndroid)
                                        {
                                          HapticFeedback.vibrate();
                                        }
                                        else
                                        {
                                          HapticFeedback.lightImpact();
                                        }

                                        setState(() {
                                          getSet.quantity = 1;
                                          cartCount = 1;

                                          var total = num.parse(getSet.salePrice.toString()) * num.parse((getSet.quantity ?? "").toString());
                                          getSet.amount = total;

                                          if (NavigationService.listItems[index].isSelected ?? false) {
                                            NavigationService.listItems[index].isSelected = false;
                                          } else {
                                            NavigationService.listItems[index].isSelected = true;
                                          }
                                        });
                                        shakeKey.currentState?.shake();

                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: black, width: 0.8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("ADD",
                                            style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: description)),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: getSet.quantity != null && getSet.quantity.toString() != "0",
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: black, width: 0.8),
                                        color: black,
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                if (Platform.isAndroid)
                                                {
                                                  HapticFeedback.vibrate();
                                                }
                                                else
                                                {
                                                  HapticFeedback.lightImpact();
                                                }
                                                setState(() {
                                                  if (isOnline)
                                                  {
                                                    if (getSet.quantity == 1) {
                                                      removeItem(index);
                                                      cartCount = 1;

                                                    } else {
                                                      getSet.quantity = getSet.quantity! - 1;
                                                      cartCount = cartCount - 1;

                                                    }

                                                    var total = num.parse(getSet.salePrice.toString()) * num.parse((getSet.quantity ?? "").toString());
                                                    getSet.amount = total;
                                                    shakeKey.currentState?.shake();

                                                  }
                                                  else
                                                  {
                                                    noInternetSnackBar(context);
                                                  }
                                                });

                                              },
                                              icon:const Icon(Icons.remove, color: white,)//Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                          ),
                                          Text((getSet.quantity ?? 0).toString(),
                                              style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: description)),
                                          IconButton(
                                              onPressed: () {
                                                if (Platform.isAndroid)
                                                {
                                                  HapticFeedback.vibrate();
                                                }
                                                else
                                                {
                                                  HapticFeedback.lightImpact();
                                                }
                                                setState(() {
                                                  if (isOnline)
                                                  {
                                                    getSet.quantity = ((getSet.quantity ?? 0) + 1);
                                                    cartCount = cartCount + 1;

                                                    var total = num.parse(getSet.salePrice.toString()) * num.parse(getSet.quantity.toString());
                                                    getSet.amount = total;

                                                    shakeKey.currentState?.shake();

                                                  }
                                                  else
                                                  {
                                                    noInternetSnackBar(context);
                                                  }
                                                });
                                              },
                                              icon: const Icon(Icons.add,color: white,)//Image.asset('assets/images/ic_blue_add.png', height: 24, width: 24),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  AnimationLimiter _gridLayout() {
    return AnimationLimiter(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: NavigationService.listItems.length,
          controller: _scrollViewController,
          itemBuilder: (BuildContext context, int index) {
            var getSet = NavigationService.listItems[index];

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 375),
              columnCount: 2,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child:Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(kTextFieldCornerRadius),
                      side: const BorderSide(
                        color: white,
                        width: 0,
                      ),
                    ),
                    color: white,
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(getSet.icon ?? "",
                              fit: BoxFit.cover,
                              height: 70,
                              width:70,
                            ),
                          ),
                          const Gap(8),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(getSet.name ?? "",
                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                overflow: TextOverflow.clip
                            ),
                          ),
                          const Gap(8),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(getSet.productCode ?? "",
                                style: TextStyle(fontSize: small, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                overflow: TextOverflow.clip
                            ),
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text(getPrice(getSet.salePrice ?? ""),
                                  style: TextStyle(fontSize: small, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip
                              ),
                              const Gap(5),
                              Text(getPrice(getSet.mrpPrice ?? ""),
                                style: TextStyle(fontSize: small, color: gray_dark,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,decoration: TextDecoration.lineThrough),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                visible:getSet.quantity == null || getSet.quantity.toString() == "0",
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (Platform.isAndroid)
                                    {
                                      HapticFeedback.vibrate();
                                    }
                                    else
                                    {
                                      HapticFeedback.lightImpact();
                                    }
                                    setState(() {
                                      getSet.quantity = 1;
                                      cartCount = 1;

                                      var total = num.parse(getSet.salePrice.toString()) * num.parse((getSet.quantity ?? "").toString());
                                      getSet.amount = total;

                                      if (NavigationService.listItems[index].isSelected ?? false) {
                                        NavigationService.listItems[index].isSelected = false;
                                      } else {
                                        NavigationService.listItems[index].isSelected = true;
                                      }
                                    });
                                    shakeKey.currentState?.shake();

                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: black, width: 0.8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text("ADD",
                                        style: TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: description)),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: getSet.quantity != null && getSet.quantity.toString() != "0",
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: black, width: 0.8),
                                    color: black,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (Platform.isAndroid)
                                            {
                                              HapticFeedback.vibrate();
                                            }
                                            else
                                            {
                                              HapticFeedback.lightImpact();
                                            }
                                            setState(() {
                                              if (isOnline)
                                              {
                                                if (getSet.quantity == 1) {
                                                  removeItem(index);
                                                  cartCount = 1;

                                                } else {
                                                  getSet.quantity = getSet.quantity! - 1;
                                                  cartCount = cartCount - 1;
                                                }

                                                var total = num.parse(getSet.salePrice.toString()) * num.parse((getSet.quantity ?? "").toString());
                                                getSet.amount = total;
                                                shakeKey.currentState?.shake();

                                              }
                                              else
                                              {
                                                noInternetSnackBar(context);
                                              }
                                            });

                                          },
                                          icon:const Icon(Icons.remove, color: white,)//Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                      ),
                                      Text((getSet.quantity ?? 0).toString(),
                                          style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: description)),
                                      IconButton(
                                          onPressed: () {
                                            if (Platform.isAndroid)
                                            {
                                              HapticFeedback.vibrate();
                                            }
                                            else
                                            {
                                              HapticFeedback.lightImpact();
                                            }
                                            setState(() {
                                              if (isOnline)
                                              {
                                                getSet.quantity = ((getSet.quantity ?? 0) + 1);
                                                cartCount = cartCount + 1;

                                                var total = num.parse(getSet.salePrice.toString()) * num.parse(getSet.quantity.toString());
                                                getSet.amount = total;

                                                shakeKey.currentState?.shake();
                                              }
                                              else
                                              {
                                                noInternetSnackBar(context);
                                              }
                                            });

                                          },
                                          icon: const Icon(Icons.add,color: white,)//Image.asset('assets/images/ic_blue_add.png', height: 24, width: 24),
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
              ),
            );
          },
        ),
      ),
    );
  }

  isCheckAny() {
    bool isAnySelected = false;
    for (int i = 0; i < NavigationService.listItems.length; i++) {
      if (NavigationService.listItems[i].isSelected == true) {
        isAnySelected = true;
        break;
      }
    }

    return isAnySelected;
  }

  Future<void> redirectToCart()
  async {
    NavigationService.listItemsTmp = [];

    setState(() {
      for (int i = 0; i < NavigationService.listItems.length; i++)
      {
        if (NavigationService.listItems[i].isSelected == true)
        {
          Records getSet = Records();

          getSet = Records(
              id:  NavigationService.listItems[i].id,
              description:  NavigationService.listItems[i].description,
              name:  NavigationService.listItems[i].name,
              icon:  NavigationService.listItems[i].icon,
              productCode:  NavigationService.listItems[i].productCode,
              unit:  NavigationService.listItems[i].unit,
              variationName:  NavigationService.listItems[i].variationName,
              skuCode:  NavigationService.listItems[i].skuCode,
              salePrice:  NavigationService.listItems[i].salePrice,
              mrpPrice:  NavigationService.listItems[i].mrpPrice,
              dpPrice:  NavigationService.listItems[i].dpPrice,
              category:  NavigationService.listItems[i].category,
              variationId:  NavigationService.listItems[i].variationId,
              categoryId:  NavigationService.listItems[i].categoryId,
              isSelected :  NavigationService.listItems[i].isSelected,
              quantity: NavigationService.listItems[i].quantity,
              amount: num.parse( NavigationService.listItems[i].salePrice.toString())
          );

          NavigationService.listItemsTmp.add(getSet);

        }
      }
    });

    if (NavigationService.listItemsTmp.isNotEmpty)
    {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderScreen()));
      setState(() {
        for (int n = 0; n < NavigationService.listItems.length; n++)
        {
          for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
          {
            if (NavigationService.listItems[n].id == NavigationService.listItemsTmp[i].id)
            {
              if (NavigationService.listItems[n].isSelected == true)
              {
                Records getSet = Records();

                getSet = Records(
                    id:  NavigationService.listItemsTmp[i].id,
                    description:  NavigationService.listItemsTmp[i].description,
                    name:  NavigationService.listItemsTmp[i].name,
                    icon:  NavigationService.listItemsTmp[i].icon,
                    productCode:  NavigationService.listItemsTmp[i].productCode,
                    unit:  NavigationService.listItemsTmp[i].unit,
                    variationName:  NavigationService.listItemsTmp[i].variationName,
                    skuCode:  NavigationService.listItemsTmp[i].skuCode,
                    salePrice:  NavigationService.listItemsTmp[i].salePrice,
                    mrpPrice:  NavigationService.listItemsTmp[i].mrpPrice,
                    dpPrice:  NavigationService.listItemsTmp[i].dpPrice,
                    category:  NavigationService.listItemsTmp[i].category,
                    variationId:  NavigationService.listItemsTmp[i].variationId,
                    categoryId:  NavigationService.listItemsTmp[i].categoryId,
                    isSelected :  NavigationService.listItemsTmp[i].isSelected,
                    quantity: NavigationService.listItemsTmp[i].quantity,
                    amount: num.parse( NavigationService.listItemsTmp[i].salePrice.toString())
                );

                NavigationService.listItems[n] = getSet;
              }
            }
          }
        }
      });
    }
    else
    {
      showSnackBar("Please add at least one Product.", context);
    }
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
                                  shakeKey.currentState?.shake();

                                  NavigationService.listItems[index].quantity = 0;
                                  NavigationService.listItems[index].isSelected = false;

                                  // for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
                                  // {
                                  //   if (NavigationService.listItemsTmp[i].id == NavigationService.listItems[index].id)
                                  //   {
                                  //     NavigationService.listItemsTmp[i].isSelected = false;
                                  //   }
                                  // }

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
        'category_id': catId,
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
          _tempList = dataResponse.records ?? [];
          NavigationService.listItems.addAll(_tempList);

          if (listCategory.isEmpty)
          {
            listCategory = [];

            listCategory.add(CategoryMenu(idStatic: "all", nameStatic: "All", isSelectedStatic: true));
            for (int i = 0; i < NavigationService.listItems.length; i++)
            {
              listCategory.add(CategoryMenu(idStatic: NavigationService.listItems[i].categoryId.toString(),
                  nameStatic: NavigationService.listItems[i].category.toString(), isSelectedStatic: false));
            }

            final ids = listCategory.map((e) => e.id).toSet();
            listCategory.retainWhere((x) => ids.remove(x.id));
            print("listCategoryTmp.length====>" + listCategory.length.toString());
          }


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