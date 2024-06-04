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

  var listItemsAPI = List<Records>.empty(growable: true);
  var listItems = List<Records>.empty(growable: true);
  String grandTotal = "";

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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectItemPage(listItemsAPI)),
                        );
                        print("result ===== $result");
                        listItems = [];
                        if (result != null)
                        {
                          var listItemsTmp = List<Records>.empty(growable: true);
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
                                  quantity: "1",
                                );

                                listItems.add(getSet);
                              }
                            }
                          });
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
                            Spacer(),
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
                    child: const Text("Items",
                        style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 20)),
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
                              Gap(12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(listItems[index].name ?? "",
                                      style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                  ),
                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("${listItems[index].salePrice ?? " "}  x ",
                                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                                      ),
                                      SizedBox(
                                          width: 100,
                                          height: 40,
                                          child: BottomLineDigitOnlyTextField(controller: listItems[index].quantityController,
                                            hintText: "Qty",
                                          onChanged: (text) {
                                            var total = double.parse(listItems[index].salePrice.toString()) * int.parse(listItems[index].quantityController.text);

                                            setState(() {
                                              listItems[index].mrpPrice = total.toString();
                                            });

                                            getSubTotal();
                                          },
                                          )),
                                      Text("/${listItems[index].unit ?? " "}",
                                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                                      ),
                                      Gap(20),

                                    ],
                                  ),
                                  Text(getPrice(listItems[index].mrpPrice.toString()) ?? "",
                                    style: TextStyle(fontSize: description, color: black,
                                      fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (isOnline)
                                  {
                                    setState(() {
                                      for (int i = 0; i < listItemsAPI.length; i++)
                                        {
                                          if (listItemsAPI[i].id == listItems[index].id)
                                            {
                                              listItemsAPI[i].isSelected = false;
                                            }
                                        }
                                      listItems.removeAt(index);

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
                        child: const Text("Remark",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 20)),
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
                          child: const Text("Order Summary",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 20)),
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
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)),
                                      Gap(6),
                                      Text("Sub Total", textAlign: TextAlign.start,
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)),
                                      Gap(6),
                                      Text("Shipping Charges", textAlign: TextAlign.start,
                                          style: TextStyle(color: hintDark, fontWeight: FontWeight.w400, fontSize: 14)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(listItems.length.toString(), textAlign: TextAlign.start, maxLines: 1,
                                          style: const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 13)),
                                      const Gap(6),
                                      Text(getSubTotal().isNotEmpty ? getPrice(getSubTotal()) : "",
                                          textAlign: TextAlign.start,maxLines: 1,
                                          style: const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 13)),
                                      const Gap(6),
                                      Text(getPrice("75"), textAlign: TextAlign.start, maxLines: 1,
                                          style:const TextStyle(color: black,fontWeight: FontWeight.w600, fontSize: 13)),

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
                                    child: const Text("Grand Total",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 18)),
                                  ),
                                  const Spacer(),
                                  Text(grandTotal.isNotEmpty ? getPrice(getGrandTotal()) : "", textAlign: TextAlign.start, maxLines: 1,
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
                  alignment: Alignment.center,
                  child: getCommonButtonWithoutFill("Proceed", isLoading, () {
                    if (listItems.isEmpty)
                    {
                      showSnackBar("Please select item.", context);
                    }
                    else
                      {

                      }

                  }),
                )
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

  getSubTotal() {

    var total = "";
    for (int i = 0; i < listItems.length; i++) {
      total = total + listItems[i].mrpPrice.toString();
    }
    //getGrandTotal();
    return total;
  }

  getGrandTotal() {
    var mainTotal = int.parse(getSubTotal()) + 75;
    return mainTotal;
  }


  // API Call func...
  geItemList() async {

    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + itemList);

      Map<String, String> jsonBody = {
      };

      final response = await http.post(url, body: jsonBody, headers: {
        "Authorization": sessionManager.getToken().toString(),
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

}