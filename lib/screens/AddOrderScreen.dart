import 'dart:convert';

import 'package:chicken_delight/common_widget/CommonTextFiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/ItemResponseModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'SelectItemPage.dart';

class AddOrderScreen extends StatefulWidget {

  @override
  BaseState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends BaseState<AddOrderScreen> {
  TextEditingController remarksController = TextEditingController();

  bool isLoading = false;

  List<Records> listItemsAPI = [];
  List<Records> listItems = [];

  var subTotal = 0.0;
  var grandTotal = 0.0;

  @override
  void initState() {
    geItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: chicken_bg,
        appBar:AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Add Order"),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child:getBackArrowBlack()
          ),
          centerTitle: true,
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
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () async {

                        if (listItemsAPI.isNotEmpty) {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectItemPage(listItemsAPI)),
                          );
                          print("result ===== $result");
                          listItems = [];
                          if (result != null)
                          {
                            List<Records> listItemsTmp = [];
                            listItemsTmp = result;

                            setState(() {
                              for (int i = 0; i < listItemsTmp.length; i++)
                              {
                                if (listItemsTmp[i].isSelected == true)
                                {
                                  Records getSet = Records();

                                  getSet = Records(
                                      id: listItemsTmp[i].id,
                                      description: listItemsTmp[i].description,
                                      name: listItemsTmp[i].name,
                                      icon: listItemsTmp[i].icon,
                                      productCode: listItemsTmp[i].productCode,
                                      unit: listItemsTmp[i].unit,
                                      variationName: listItemsTmp[i].variationName,
                                      skuCode: listItemsTmp[i].skuCode,
                                      salePrice: listItemsTmp[i].salePrice,
                                      mrpPrice: listItemsTmp[i].mrpPrice,
                                      dpPrice: listItemsTmp[i].dpPrice,
                                      category: listItemsTmp[i].category,
                                      variationId: listItemsTmp[i].variationId,
                                      categoryId: listItemsTmp[i].categoryId,
                                      isSelected : listItemsTmp[i].isSelected,
                                      quantity: 1,
                                      amount: num.parse(listItemsTmp[i].salePrice.toString())
                                  );

                                  listItems.add(getSet);
                                }
                              }
                              getPriceCalculated();

                            });
                          }
                        }
                        else
                          {
                            showSnackBar("No items found", context);
                          }

                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(white),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.only(top: 5,bottom: 5),
                        child: Row(
                          children: [
                            Text("Add Item",
                              style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w500, color: primaryColor,),
                            ),
                            const Spacer(),
                            const Icon(Icons.add, color: black, size: 26,)
                          ],
                        ),
                      ),
                    )),
                const Gap(8),
                Visibility(
                  visible: listItems.isNotEmpty,
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
                      itemCount: listItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: white,
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  listItems[index].icon ?? "",
                                  fit: BoxFit.cover,
                                  height: 70,
                                  width:70,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listItems[index].name ?? "",
                                        style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                      maxLines: 3,
                                    ),
                                    const Gap(5),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.only(left: 10, right: 10),
                                          alignment: Alignment.center,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(
                                              color: grayDividerDetail,
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Text(listItems[index].salePrice ?? " ",
                                              style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center
                                          ),
                                        ),
                                        Text("*  ",
                                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center
                                        ),
                                        Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
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
                                                      if (listItems[index].quantity == 1) {
                                                        removeItem(index);
                                                      } else {
                                                        listItems[index].quantity = listItems[index].quantity! - 1;
                                                      }
                                
                                                      var total = num.parse(listItems[index].salePrice.toString()) * num.parse(listItems[index].quantity.toString());
                                                      listItems[index].amount = total;
                                                      getPriceCalculated();
                                                    }
                                                    else
                                                    {
                                                      noInternetSnackBar(context);
                                                    }
                                                  });
                                
                                                },
                                                icon:const Icon(Icons.remove)//Image.asset('assets/images/ic_blue_minus.png', height: 24, width: 24),
                                              ),
                                              Text(listItems[index].quantity.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.w400, color: black, fontSize: small)),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (isOnline)
                                                    {
                                                      listItems[index].quantity = (listItems[index].quantity! + 1)!;
                                                      var total = num.parse(listItems[index].salePrice.toString()) * num.parse(listItems[index].quantity.toString());
                                                      listItems[index].amount = total;
                                
                                                      getPriceCalculated();
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
                                        /*SizedBox(
                                            width: 100,
                                            height: 40,
                                            child: BottomLineDigitOnlyTextField(controller: listItems[index].quantityController,
                                              hintText: "Qty",
                                              onChanged: (text) {
                                              setState(() {
                                                if (text.isNotEmpty) {
                                                  var total = num.parse(listItems[index].salePrice.toString()) * num.parse(listItems[index].quantityController.text);
                                                  listItems[index].mrpPrice = total.toString();
                                                  print(getSubTotal());
                                                  //  print(getGrandTotal());
                                                }
                                                else
                                                {
                                                  var total = num.parse(listItems[index].salePrice.toString()) * 1;
                                                  listItems[index].mrpPrice = total.toString();
                                                  print(getSubTotal());
                                                }
                                
                                              });
                                            },
                                            )
                                        ),*/
                                        Text("/${listItems[index].unit ?? " "}",
                                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                                        ),
                                        Gap(20),
                                      ],
                                    ),
                                    Gap(5),
                                    Text(getPrice(listItems[index].amount.toString()) ,
                                      style: TextStyle(fontSize: description, color: black,
                                        fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(10),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (isOnline)
                                  {
                                    setState(() {
                                      /*for (int i = 0; i < listItemsAPI.length; i++)
                                      {
                                        if (listItemsAPI[i].id == listItems[index].id)
                                        {
                                          listItemsAPI[i].isSelected = false;
                                        }
                                      }
                                      listItems.removeAt(index);*/
                                      removeItem(index);
                                    });
                                  }
                                  else
                                  {
                                    noInternetSnackBar(context);
                                  }
                                },
                                child: const Icon(Icons.delete_outline, color: black, size: 26,),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
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
                          onTapClear: () {  },
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: listItems.isNotEmpty,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
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
                          child:Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Total Items", textAlign: TextAlign.start,
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                      ),
                                      Gap(6),
                                      Text("Sub Total", textAlign: TextAlign.start,
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                      ),
                                      Gap(6),
                                      Text("Shipping Charges", textAlign: TextAlign.start,
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(listItems.length.toString(), textAlign: TextAlign.start,
                                          style: TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                                      const Gap(6),
                                      Text(subTotal.toStringAsFixed(2),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                                      const Gap(6),
                                      Text(getPrice("75"), textAlign: TextAlign.start,
                                          style: TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: small)),
                                    ],
                                  ),
                                ],
                              ),
                              Gap(10),
                              const Divider(
                                height: 0.8,
                                color: grayNew,
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text("Grand Total",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: medium)),
                                  ),
                                  const Spacer(),
                                  Text(grandTotal.toStringAsFixed(2), textAlign: TextAlign.start,
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
                const Gap(20),
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 10, left: 60, right: 60),
                  width: MediaQuery.of(context).size.width,
                  child: getCommonButtonLoad("Proceed", isLoading,  () {
                    {
                      if (listItems.isEmpty)
                      {
                        showSnackBar("Please select item.", context);
                      }
                      else
                      {
                        _makeJsonData();
                        saveItem();
                      }
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

  @override
  void castStatefulWidget() {
    widget is AddOrderScreen;
  }

  void getPriceCalculated() {
    setState(() {
      subTotal = 0.0;

      for (var i = 0; i < listItems.length; i++) {
        if (listItems[i].quantity == 1) {
          subTotal = subTotal + checkValidDouble(listItems[i].amount.toString());
        } else {
          var total = checkValidDouble(listItems[i].amount.toString()) * listItems[i].quantity;
          subTotal = subTotal + total;
        }
      }

      print("subTotal ==== " + subTotal.toString());
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
                    color: primaryColor,
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
                              border: Border.all(width: 0.4, color: primaryColor),
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
                                      color: primaryColor,
                                    ))),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kButtonCornerRadius),
                              color: primaryColor,
                            ),
                            child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  for (int i = 0; i < listItemsAPI.length; i++)
                                  {
                                    if (listItemsAPI[i].id == listItems[index].id)
                                    {
                                      listItemsAPI[i].isSelected = false;
                                    }
                                  }
                                  listItems.removeAt(index);
                                  getPriceCalculated();

                                  if (listItems.isEmpty) {
                                  //  isValidProduct = false;
                                  }
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

  void _makeJsonData() async {
    List<Records> listItemsTemp = [];

    for (int i = 0; i < listItems.length; i++)
    {
      listItemsTemp.add(listItems[i]);
      // print("stockPrice---->" +checkValidString(listProductsTemp[i].stockPrice.toString()));
      print("quantity--->" + checkValidString(listItemsTemp[i].quantity.toString()));
    }

    if (listItemsTemp.isNotEmpty)
    {
      listItems.clear();
      listItems.addAll(listItemsTemp);
    }
    print("<><> Json Product ${jsonEncode(listItems).toString().trim()} END<><>");

  }

  // API Call func...
  geItemList() async {

    if (isOnline)
    {
      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + itemList);

      Map<String, String> jsonBody = {
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });

      final statusCode = response.statusCode;
      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = ItemResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1)
      {
        if (dataResponse.records != null)
          {
            if (dataResponse.records!.isNotEmpty) {
              listItemsAPI = dataResponse.records ?? [];
            }
          }
        setState(() {
          isLoading = false;
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(dataResponse.message, context);
      }
    }
    else
    {
      noInternetSnackBar(context);
    }

  }

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
        'items': listItems.isNotEmpty ? jsonEncode(listItems).toString().trim()  :"",
        'paymentMethod': "[]",
        'remarks': remarksController.value.text.toString().isNotEmpty ? remarksController.value.text.toString() : "",
        'shipping_charges': '75',
        'sub_total': subTotal.toString(),
        'warehouse': ""
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken() ?? "",
      });
      final statusCode = response.statusCode;
      print(response);
      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1) {
        setState(() {
          isLoading = false;
          listItems.clear();
          remarksController.clear();
          isOrderListLoad = true;

        });
        showSnackBar(dataResponse.message, context);
       // Navigator.pop(context,"success");
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