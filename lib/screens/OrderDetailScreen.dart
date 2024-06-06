import 'dart:convert';

import 'package:chicken_delight/model/common/CommonResponseModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/OrderDetailResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen(this.orderId, {super.key});

  @override
  BaseState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends BaseState<OrderDetailScreen> {
  TextEditingController remarksController = TextEditingController();
  TextEditingController cancelRemarksController = TextEditingController();

  bool isLoading = false;
  List<ItemsList> listItems = [];
  String subTotal = "";
  String grandTotal = "";
  String wareAddressLine1 = "";
  String warehouseName = "";
  String addressLine1 = "";
  String addressLine2 = "";
  String franchiseName = "";
  String paymentStatus = "";
  String orderNumber = "";
  String status = "";
  String orderId = "";


  @override
  void initState() {
    orderId = (widget as OrderDetailScreen).orderId.toString();

    getOrderDetail();
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
            title: getTitle("Order Detail"),
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
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order #$orderNumber",
                          style: TextStyle(fontSize: medium, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                      ),
                      Text(status,
                          style: TextStyle(fontSize: subTitle, color: status == "Cancelled" ? Colors.red : Colors.green,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: status == "Accepted" || status == "Processed",
                        child: Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              showDialog("Processed");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: black,
                              ),
                             child: Text("Mark as\nProcessed",
                                 style: TextStyle(fontSize: small, color: white, fontWeight: FontWeight.w600),
                                 textAlign: TextAlign.center
                             ),
                            ),
                          ),
                        ),
                      ),
                      Gap(12),
                      Visibility(
                        visible: status == "Accepted" || status == "Processed",
                        child: Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              showDialog("Cancel");

                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: black,
                              ),
                              child: Text("Cancel\n Order",
                                  style: TextStyle(fontSize: small, color: white,fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(12),
                      Visibility(
                        visible: status == "Accepted" || status == "Processed",
                        child: Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              showDialog("Completed");
                              },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 20, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: black,
                              ),
                              child: Text("Mark Payment\nDone",
                                  style: TextStyle(fontSize: small, color: white,fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    removeTop: true,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listItems.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kContainerCornerRadius),
                              color: white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listItems[index].category ?? "",
                                  style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                              ),
                              Gap(12),
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: listItems[index].items?.length,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, indexInner) {
                                    var getSetInner = listItems[index].items?[indexInner] ?? Items();
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.network(
                                                getSetInner.image ?? "",
                                                fit: BoxFit.cover,
                                                height: 70,
                                                width:70,
                                              ),
                                            ),
                                            Gap(12),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(getSetInner.item ?? "",
                                                      style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                      overflow: TextOverflow.clip
                                                  ),
                                                  Gap(4),
                                                   Row(
                                                    children: [
                                                      Text("${getSetInner.quantity ?? " "}/${getSetInner.unit ?? " "}  x  CA\$${getSetInner.basePrice ?? " "}",
                                                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                                                      ),
                                                      Spacer(),
                                                      Text(getPrice(getSetInner.amount.toString()) ?? "",
                                                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                          overflow: TextOverflow.clip
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(10),
                                      ],
                                    );
                                  }
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top:10,bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: white,
                    ),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Subtotal:",
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                                ),
                                Text(getPrice(subTotal),
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 12, bottom: 12),
                                child: const Divider(indent: 0,height: 1,color: grayNew,)
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Shipping:",
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                                ),
                                Text(getPrice("75"),
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 12,bottom: 12),
                                child: const Divider(indent: 0,height: 1,color: grayNew,)
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Total Price:",
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                                Text(getPrice(grandTotal),
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shipping From",
                            style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                        ),
                        Gap(10),
                        Text(warehouseName,
                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                        ),
                        Text(wareAddressLine1,
                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10,bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shipping To",
                            style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                        ),
                        Gap(10),
                        Text(franchiseName,
                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                        ),
                        Text("$addressLine1,$addressLine2",
                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10,bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      color: white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Payment Status",
                            style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                        ),
                        Gap(10),
                        Text(paymentStatus,
                            style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                        ),
                      ],
                    ),
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
   widget is OrderDetailScreen;
  }

  showDialog(String isFor) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      elevation: 5,
      isDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, updateState) {
            return Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 16,
                    ),
                    Container(
                        height: 2,
                        width: 40,
                        color: black,
                        margin: const EdgeInsets.only(bottom: 18)
                    ),
                    Text(isFor == "Processed"
                        ? "Are you sure you want to mark as processed?"
                        : isFor == "Cancel"
                        ? "Are you sure want to cancel order?"
                        : "Are you sure you want to mark payment done?",
                        style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.w500,
                            fontSize: textFiledSize),
                        textAlign: TextAlign.center
                    ),
                    Visibility(
                      visible: isFor != "Completed",
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16, top: 22),
                        child: TextField(
                          readOnly: false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          cursorColor: black,
                          maxLines: 3,
                          controller:isFor == "Processed" ? remarksController : cancelRemarksController,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: subTitle,
                            color: black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Remarks',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                            counterText: "",
                            labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                            alignLabelWithHint: true
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 15, right: 12, bottom: 30, top: 20),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: black,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                  ),
                                ),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(white),
                              ),
                              child:   Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: contentSize,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(
                                left: 12, right: 15, bottom: 30, top: 30),
                            child: TextButton(
                              onPressed: () {
                                if (isFor == "Processed")
                                {
                                  saveOrder("Processed");
                                }
                                else if (isFor == "Cancel")
                                {
                                  deleteOrder();
                                }
                                else
                                {
                                  saveOrder("Completed");
                                }
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: black,
                                          width: 1,
                                          style: BorderStyle.solid
                                      ),
                                      borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all<Color>(black)
                              ),
                              child:  Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: white,
                                      fontSize: contentSize,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  // API Call func...
  saveOrder(String orderStatus) async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + orderSave);
      Map<String, String> jsonBody = {
      };

      if (orderStatus == "Completed")
      {
        jsonBody = {
          'id': orderId,
          'payment_status': orderStatus
        };
      }
      else
      {
        jsonBody = {
          'id': orderId,
          'order_stages': orderStatus,
          'remarks': remarksController.value.text,
        };
      }

      final response = await http.post(url, body: jsonBody);
      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context,"success");
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

  deleteOrder() async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + orderDelete);

      Map<String, String> jsonBody = {
        'id': orderId,
        'remarks': cancelRemarksController.value.text,
      };

      final response = await http.post(url, body: jsonBody);

      final statusCode = response.statusCode;
      print(response);
      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      }
      else {
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

  getOrderDetail() async {
    if (isOnline) {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + orderDetail);
      Map<String, String> jsonBody = {
        'id': orderId,
      };

      final response = await http.post(url, body: jsonBody,
          headers:  {"Authorization": sessionManager.getToken() ?? ""});

      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = OrderDetailResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1)
      {
        isLoading = false;
        listItems = dataResponse.record?.itemsList ?? [];
        subTotal = dataResponse.record?.subTotal ?? "";
        grandTotal = dataResponse.record?.grandTotal ?? "";
        wareAddressLine1 = dataResponse.record?.wareAddressLine1 ?? "";
        warehouseName = dataResponse.record?.warehouseName ?? "";
        addressLine1 = dataResponse.record?.addressLine1 ?? "";
        addressLine2 = dataResponse.record?.addressLine2 ?? "";
        franchiseName = dataResponse.record?.franchiseName ?? "";
        paymentStatus = dataResponse.record?.paymentStatus ?? "";
        orderNumber = dataResponse.record?.orderNumber ?? "";
        status = dataResponse.record?.status ?? "";
      }
      else
      {
        showSnackBar(dataResponse.message.toString(), context);
      }
      setState(() {
        isLoading = false;
      });
    }
    else
      {
        noInternetSnackBar(context);
      }

  }

}