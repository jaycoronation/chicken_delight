import 'dart:convert';

import 'package:chicken_delight/common_widget/CommonTextFiled.dart';
import 'package:chicken_delight/model/OrderAddResponseModel.dart';
import 'package:chicken_delight/model/common/drop_down_model.dart';
import 'package:chicken_delight/screens/OrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../constant/global_context.dart';
import '../model/ItemResponseModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/TextChanger.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class AddOrderScreen extends StatefulWidget {

  @override
  BaseState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends BaseState<AddOrderScreen> {
  TextEditingController remarksController = TextEditingController();
  TextEditingController selectRepeatController = TextEditingController();

  bool isLoading = false;

  var subTotal = 0.0;
  var grandTotal = 0.0;

  bool isRepeat = false;
  String repeatDays = "";
  List<DropDownModel> orderRepeatOption = [];


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

    orderRepeatOption.add(DropDownModel(idParam: "15", nameParam: 'Repeat in every 15 days', isSelectedParam: false));
    orderRepeatOption.add(DropDownModel(idParam: "30", nameParam: "Repeat in every 30 days", isSelectedParam: false));
    orderRepeatOption.add(DropDownModel(idParam: "45", nameParam: "Repeat in every 45 days", isSelectedParam: false));
    orderRepeatOption.add(DropDownModel(idParam: "60", nameParam: "Repeat in every 60 days", isSelectedParam: false));

    for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
    {
      var total = num.parse(NavigationService.listItemsTmp[i].salePrice.toString()) * num.parse(NavigationService.listItemsTmp[i].quantity.toString());
      NavigationService.listItemsTmp[i].amount = total;
    }

    getPriceCalculated();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: chicken_bg,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: getTitle("Add Order"),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context); //"1"
              },
              child: getBackArrowBlack()
          ),
          elevation: 0,
          backgroundColor: chicken_bg,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: NavigationService.listItems.isNotEmpty,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 5),
                    child: Text("Items",
                        style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: titleFont20)),
                  ),
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: NavigationService.listItemsTmp.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                          margin: const EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kContainerCornerRadius),
                            color: white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        NavigationService.listItemsTmp[index].icon ?? "",
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width:70,
                                      ),
                                    ),
                                    const Gap(12),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text((NavigationService.listItemsTmp[index].name ?? ""),
                                            style: const TextStyle(fontSize: 13, color: black,fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.clip,
                                            ),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.clip,
                                            maxLines: 3,
                                          ),
                                          const Gap(18),
                                          Text(getPrice(NavigationService.listItemsTmp[index].salePrice ?? " "),
                                              style: const TextStyle(fontSize: 13, color: black,fontWeight: FontWeight.w400),
                                              textAlign: TextAlign.center
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(10),
                              Column(
                                children: [
                                  const Gap(12),
                                  Container(
                                    height: 35 ,
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
                                              setState(() {
                                                if (isOnline)
                                                {
                                                  if (NavigationService.listItemsTmp[index].quantity == 1) {
                                                    removeItem(index);
                                                  } else {
                                                    NavigationService.listItemsTmp[index].quantity = (NavigationService.listItemsTmp[index].quantity ?? 0) - 1;
                                                  //  NavigationService.listItemsTmp[index].updateCartCount = (NavigationService.listItemsTmp[index].updateCartCount ?? 0) - 1;                                                    // cartCount -= 1;
                                                  }

                                                  var total = num.parse(NavigationService.listItemsTmp[index].salePrice.toString()) * num.parse(NavigationService.listItemsTmp[index].quantity.toString());
                                                  NavigationService.listItemsTmp[index].amount = total;

                                                  getPriceCalculated();
                                                }
                                                else
                                                {
                                                  noInternetSnackBar(context);
                                                }
                                              });
                                            },
                                            icon:const Icon(Icons.remove, color: white,size: 20,)//Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                        ),
                                        Text(NavigationService.listItemsTmp[index].quantity.toString(),
                                            style: TextStyle(fontWeight: FontWeight.w600, color: white, fontSize: description)),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (isOnline)
                                                {
                                                  NavigationService.listItemsTmp[index].quantity = ((NavigationService.listItemsTmp[index].quantity ?? 0)  + 1);
                                                 // NavigationService.listItemsTmp[index].updateCartCount  = (NavigationService.listItemsTmp[index].updateCartCount ?? 0) + 1;                                                    // cartCount -= 1;

                                                  var total = num.parse(NavigationService.listItemsTmp[index].salePrice.toString()) * num.parse(NavigationService.listItemsTmp[index].quantity.toString());
                                                  NavigationService.listItemsTmp[index].amount = total;

                                                  getPriceCalculated();
                                                }
                                                else
                                                {
                                                  noInternetSnackBar(context);
                                                }
                                              });
                                            },
                                            icon: const Icon(Icons.add,color: white,size: 20)
                                          //Image.asset('assets/images/ic_blue_add.png', height: 24, width: 24),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Gap(12),
                                  Text(getPrice(NavigationService.listItemsTmp[index].amount?.toStringAsFixed(2) ?? "") ,
                                    style: TextStyle(fontSize: description, color: black,
                                      fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kContainerCornerRadius),
                    color: white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                        child: Text("Repeat Order",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: titleFont20)),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                isRepeat = true;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 10, right: 5,left: 20),
                                    child: !isRepeat ? Image.asset("assets/images/ic_radio_unselected.png", width: 20, height: 20, color: black) :
                                    Image.asset("assets/images/ic_radio_selected.png",  width: 20, height: 20,)
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 10, right: 16),
                                  child: const Text("Yes", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: black),),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                isRepeat = false;
                                selectRepeatController.text = "";
                                repeatDays = "";
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(top: 10, right: 5),
                                    child: isRepeat ? Image.asset("assets/images/ic_radio_unselected.png", width: 20, height: 20,)
                                        : Image.asset("assets/images/ic_radio_selected.png", width: 20, height: 20)
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 10, right: 16),
                                  child: const Text("No", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600, color: black),),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Gap(5),
                      Visibility(
                        visible: isRepeat,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CommonTextFieldForBottomSheet(
                              controller: selectRepeatController,
                              suffixIcon: 'assets/images/ic_dropdown.png',
                              hintText: "Select repeat interval (e.g. every 15 days)*",
                              onTap: () {
                                openBottomSheet();
                              }),
                        ),
                      ),
                      const Gap(5),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kContainerCornerRadius),
                    color: white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: Text("Remark",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: titleFont20)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: OutlineTextField(
                          controller: remarksController,
                          hintText: "Enter Remark",
                          onTapClear: () {

                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: NavigationService.listItemsTmp.isNotEmpty,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                          child: Text("Order Summary",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: titleFont20)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Total Items",
                                      style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                  ),
                                  Text(NavigationService.listItemsTmp.length.toString(),
                                      style: const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Sub Total",
                                      style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                  ),
                                  Text(getPrice(subTotal.toStringAsFixed(2)),
                                      style: const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 15)
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Visibility(
                               visible: sessionManager.getShippingCharge().toString() == "1",
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Shipping",
                                        style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                    ),
                                    Text(getPrice("75"),
                                      style: const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(5),
                              const Divider(
                                height: 0.8,
                                color: grayNew,
                              ),
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Grand Total",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: medium)),
                                  Text(getPrice(grandTotal.toStringAsFixed(2)), textAlign: TextAlign.start,
                                      style:const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 30, left: 60, right: 60),
                  width: MediaQuery.of(context).size.width,
                  child: getCommonButtonLoad("Proceed", isLoading,() {

                      if (NavigationService.listItemsTmp.isEmpty)
                      {
                        showSnackBar("Please select item.", context);
                      }
                      else if (isRepeat)
                      {
                        if (selectRepeatController.text.isEmpty)
                        {
                          showSnackBar("Please select days option.", context);
                        }
                        else
                        {
                          _makeJsonData();
                          saveItem();
                        }
                      }
                      else
                      {
                        _makeJsonData();
                        print("Place order");
                        saveItem();
                      }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openBottomSheet() {
    showModalBottomSheet<String>(
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter updateState) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.88,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 2,
                          width: 40,
                          alignment: Alignment.center,
                          color: primaryColor,
                          margin: const EdgeInsets.only(top: 10, bottom: 6),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                          child: const Text("Select Option",
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: [
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                                  child: ListView.builder(
                                    itemCount: orderRepeatOption.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return IntrinsicHeight(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            updateState(() {
                                             selectRepeatController.text = orderRepeatOption[index].name.toString() ?? "";
                                             repeatDays = orderRepeatOption[index].id.toString() ?? "";
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            color: white,
                                            child: setOptionList(index),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }).then(
          (value) {},
    );
  }

  Column setOptionList(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 15),
          child: Text(orderRepeatOption[index].name.toString(),
            style: TextStyle(fontWeight: selectRepeatController.text == orderRepeatOption[index].name ? FontWeight.w600 : FontWeight.w400,
                color: black,
                fontSize: 15),
          ),
        ),
        Container(
          height: 0.5,
          color: (index == orderRepeatOption.length - 1) ? white : primaryColor,
        ),
      ],
    );
  }


  @override
  void castStatefulWidget() {
    widget is AddOrderScreen;
  }

  void getPriceCalculated() {
    setState(() {
      subTotal = 0.0;

      for (var i = 0; i < NavigationService.listItemsTmp.length; i++) {
        if (NavigationService.listItemsTmp[i].quantity == 1) {
          subTotal = subTotal + checkValidDouble(NavigationService.listItemsTmp[i].amount.toString());
        } else {
          var total = checkValidDouble(NavigationService.listItemsTmp[i].amount.toString()) * NavigationService.listItemsTmp[i].quantity;
          subTotal = subTotal + total;
        }
      }

      grandTotal = subTotal + 75;
    });
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
                                  if (NavigationService.listItemsTmp.length == 1)
                                  {
                                    for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
                                    {
                                      if (NavigationService.listItemsTmp[i].id == NavigationService.listItemsTmp[index].id)
                                      {
                                        NavigationService.listItemsTmp[i].isSelected = false;
                                      }
                                    }

                                   // NavigationService.listItemsTmp[index].updateCartCount = (NavigationService.listItemsTmp[index].updateCartCount ?? 0) - 1;                                                    // cartCount -= 1;

                                    NavigationService.listItemsTmp.removeAt(index);
                                    getPriceCalculated();
                                    context.read<TextChanger>().refreshProduct("refreshProduct");
                                    NavigationService.listItems[index].quantity = 0;
                                    NavigationService.listItems[index].isSelected = false;
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                  }
                                  else
                                    {
                                      for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
                                      {
                                        if (NavigationService.listItemsTmp[i].id == NavigationService.listItemsTmp[index].id)
                                        {
                                          NavigationService.listItemsTmp[i].isSelected = false;
                                        }
                                      }

                                      NavigationService.listItemsTmp.removeAt(index);
                                      getPriceCalculated();

                                     // NavigationService.listItemsTmp[index].updateCartCount = (NavigationService.listItemsTmp[index].updateCartCount ?? 0) - 1;                                                    // cartCount -= 1;

                                      NavigationService.listItems[index].quantity = 0;
                                      NavigationService.listItems[index].isSelected = false;

                                      Navigator.pop(context);
                                    }

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

  void _makeJsonData() async {
    List<Records> listItemsTemp = [];

    for (int i = 0; i < NavigationService.listItemsTmp.length; i++)
    {
      listItemsTemp.add(NavigationService.listItemsTmp[i]);
    }

    if (listItemsTemp.isNotEmpty)
    {
      NavigationService.listItemsTmp.clear();
      NavigationService.listItemsTmp.addAll(listItemsTemp);
    }
    print("<><> Json Product ${jsonEncode(NavigationService.listItemsTmp).toString().trim()} END<><>");
  }

  // API Call func...
  saveItem() async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + itemSave);
      Map<String, String> jsonBody = {
        'couponCode': "",
        'created_for': sessionManager.getUserId() ?? "",
        'grand_total': grandTotal.toString(),
        'items': NavigationService.listItemsTmp.isNotEmpty ? jsonEncode(NavigationService.listItemsTmp).toString().trim() : "",
        'paymentMethod': "[]",
        'remarks': remarksController.value.text.toString().isNotEmpty ? remarksController.value.text.toString() : "",
        'shipping_charges': sessionManager.getShippingCharge().toString(),
        'sub_total': subTotal.toString(),
        'repeat_date': repeatDays,
        'repeat_order': isRepeat ? "1" : "0"
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });
      final statusCode = response.statusCode;
      print(response);
      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = OrderAddResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1) {
        setState(() {
          isLoading = false;
          NavigationService.listItemsTmp.clear();
          remarksController.clear();
          // isOrderListLoad = true;
        });

        context.read<TextChanger>().setAddOrder("add");
        context.read<TextChanger>().refreshProduct("refreshProduct");

        startActivity(context, OrderDetailScreen(dataResponse.orderId?.toString() ?? "", true));
      //  Navigator.pop(context);

        showSnackBar(dataResponse.message, context);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
    else
    {
      noInternetSnackBar(context);
    }

  }

}