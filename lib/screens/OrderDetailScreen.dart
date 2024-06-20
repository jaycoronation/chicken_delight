import 'dart:convert';

import 'package:chicken_delight/constant/global_context.dart';
import 'package:chicken_delight/model/common/CommonResponseModel.dart';
import 'package:chicken_delight/screens/save_file_mobile.dart';
import 'package:chicken_delight/tabs/tabnavigation.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/OrderDetailResponseModel.dart';
import '../utils/TextChanger.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';


//Local imports

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  final bool isFrom;
  const OrderDetailScreen(this.orderId, this.isFrom, {Key? key}) : super(key: key);

  @override
  BaseState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends BaseState<OrderDetailScreen> {
  TextEditingController remarksController = TextEditingController();
  TextEditingController cancelRemarksController = TextEditingController();

  bool isLoading = false;
  List<ItemsMainList> listItems = [];
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
  String shippingCharge = "";
  String orderId = "";
  bool isFrom = false;

  OrderDetailRecord orderDetailData = OrderDetailRecord();

  @override
  void initState() {
    NavigationService.notif_type = '';
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
    orderId = (widget as OrderDetailScreen).orderId.toString();
    isFrom = (widget as OrderDetailScreen).isFrom;

    getOrderDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop) {
          return;
        }
        if (isFrom)
        {
          startAndRemoveActivity(context, const TabNavigation(0));
        }
        else
        {
          if (Navigator.canPop(context))
          {
            Navigator.pop(context);
          }
          else
          {
            startAndRemoveActivity(context, const TabNavigation(0));
          }
        }
      },
        /*onWillPop: () {
         Navigator.pop(context);
         return Future.value(true);
        },*/
        child: Scaffold(
          backgroundColor: chicken_bg,
          appBar: AppBar(
            toolbarHeight: kToolbarHeight,
            automaticallyImplyLeading: false,
            title: getTitle("Order Detail"),
            centerTitle: false,
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  //Navigator.canPop(context);
                  if (isFrom)
                  {
                    startAndRemoveActivity(context, const TabNavigation(0));
                  }
                  else
                  {
                    if (Navigator.canPop(context))
                    {
                      Navigator.pop(context);
                    }
                    else
                    {
                      startAndRemoveActivity(context, const TabNavigation(0));
                    }
                  }
                },
                child: getBackArrowBlack()
            ),
            elevation: 0,
            backgroundColor: chicken_bg,
          ),
          body: isLoading ? const LoadingWidget()
              : Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Order #$orderNumber",
                              style: TextStyle(fontSize: medium, color: black,fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left
                          ),
                          FittedBox(
                            child: Container(
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                                color:  appBG,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6.0, bottom: 6, left: 8, right: 8),
                                child: Text(status,
                                    style: TextStyle(fontSize: 13, color: status == "Cancelled" ? Colors.red : Colors.green,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kContainerCornerRadius),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(listItems[index].category ?? "",
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                                const Gap(12),
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: listItems[index].itemsInnerList?.length,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (context, indexInner) {
                                      var getSetInner = listItems[index].itemsInnerList?[indexInner] ?? ItemsInnerList();
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: getSetInner.image!.isNotEmpty,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    getSetInner.image ?? "",
                                                    fit: BoxFit.cover,
                                                    height: 70,
                                                    width:70,
                                                  ),
                                                ),
                                              ),
                                              const Gap(12),
                                              Flexible(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(getSetInner.item ?? "",
                                                        style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                                        overflow: TextOverflow.clip
                                                    ),
                                                    const Gap(4),
                                                    Row(
                                                      children: [
                                                        Text(getSetInner.quantity ?? " ",
                                                            style: TextStyle(fontSize: description, color: gray_dark,fontWeight: FontWeight.w500),
                                                            textAlign: TextAlign.left
                                                        ),
                                                        Text(" x ${getPrice(getSetInner.basePrice ?? " ")}",
                                                            style: TextStyle(fontSize: description, color: gray_dark,fontWeight: FontWeight.w500),
                                                            textAlign: TextAlign.left
                                                        ),
                                                        const Spacer(),
                                                        Text(getPrice(getSetInner.amount.toString()) ?? "",
                                                            style: TextStyle(fontSize: description, color: gray_dark,fontWeight: FontWeight.w500, overflow: TextOverflow.clip,),
                                                            textAlign: TextAlign.left,
                                                            overflow: TextOverflow.clip
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Gap(10),
                                        ],
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Subtotal:",
                                      style: TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                                  ),
                                  Text(getPrice(subTotal),
                                      style: const TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                  ),
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                                  child: const Divider(indent: 0,height: 1,color: grayNew,)
                              ),
                            ],
                          ),
                          Visibility(
                            visible: shippingCharge != "0",
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Shipping:",
                                        style: TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                                    ),
                                    Text(getPrice("75"),
                                        style: TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                    ),
                                  ],
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 12,bottom: 12),
                                    child: const Divider(indent: 0,height: 1,color: grayNew,)
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Total Price:",
                                      style: TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                  ),
                                  Text(getPrice(grandTotal),
                                      style: const TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: warehouseName.isNotEmpty && wareAddressLine1.isNotEmpty,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shipping From",
                                style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                            ),
                            const Gap(10),
                            Text(warehouseName,
                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                            ),
                            Text(wareAddressLine1,
                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    //visible: franchiseName.isNotEmpty && addressLine1.isNotEmpty,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shipping To",
                                style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10, bottom: 5),
                              child: const Text("Franchise Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(franchiseName,
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 5),
                              child: const Text("Phone",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(orderDetailData.franchiseMobile.toString().isNotEmpty
                                ? orderDetailData.franchiseMobile?.toString() ?? "" : "-",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 5),
                              child: const Text("Email",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(orderDetailData.franchiseEmail == "" ? "-" : orderDetailData.franchiseEmail?.toString() ?? "",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 5),
                              child: const Text("Address",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text("${(orderDetailData.addressLine1?.toString() ?? "")}, ${(orderDetailData.addressLine2?.toString() ?? "")} "
                                "${(orderDetailData.addressLine3?.toString() ?? "")}" "${(orderDetailData.addressLine4?.toString() ?? "")}",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 5),
                              child: const Text("City",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(orderDetailData.city.toString().isNotEmpty ? orderDetailData.city?.toString() ?? "" : "-",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                           /* Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                              child: const Text("Landmark/Pincode",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                              child: Text(orderDetailData.d?.toString() ?? "",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                              ),
                            ),*/
                            Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 5),
                              child: const Text("State",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14, color: kTextLightGray, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(orderDetailData.state.toString().isNotEmpty ? orderDetailData.state?.toString() ?? "" : "-",
                              textAlign: TextAlign.start,
                              style: const TextStyle(fontSize: 14, color: black, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      /*Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Shipping To",
                              style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                          ),
                          const Gap(10),
                          Text(franchiseName,
                              style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                          ),
                          Text("$addressLine1,$addressLine2",
                              style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                          ),
                        ],
                      ),*/
                    ),
                  ),
                  Visibility(
                    visible: paymentStatus.isNotEmpty,
                    child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kContainerCornerRadius),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Status",
                                style: TextStyle(fontSize: subTitle, color: black, fontWeight: FontWeight.w600),textAlign: TextAlign.left
                            ),
                            const Gap(10),
                            Text(paymentStatus,
                                style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.left
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Visibility(
                    visible: status == "Accepted",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 60, right: 60),
                      child: getCommonButtonLoad("Cancel Order", false, () {
                        {
                          cancelOrder();
                        }
                      }),
                    ),
                  ),
                  Visibility(
                    visible: status == "Processed",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10, bottom: 20, left: 60, right: 60),
                      child: getCommonButtonLoad("Print Invoice", false, () {
                        {
                          _generatePDF();
                          //showSnackBar("Coming soon...", context);
                        }
                      }),
                    ),
                  ),
                  const Gap(40)
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

  void cancelOrder() {
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
                              child: Text('Cancel Order', style: TextStyle(fontSize: medium, fontWeight: FontWeight.w700, color: black))
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 15),
                            child: Text('Are you sure want to cancel this order?', style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w400, color: black)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                              readOnly: false,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: black,
                              maxLines: 3,
                              controller: cancelRemarksController,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: subTitle,
                                color: black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Remarks',
                                alignLabelWithHint: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                                counterText: "",
                                labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 20),
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
                                        orderDeleteRequest();

                                        Navigator.pop(context);
                                        setState(() {
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
            ),
          );
        }).then(
          (value) {},
    );
  }


  // API Call func...
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
        orderDetailData = dataResponse.orderDetailRecord ?? OrderDetailRecord();
        listItems = dataResponse.orderDetailRecord?.itemsMainList ?? [];

        subTotal = dataResponse.orderDetailRecord?.subTotal ?? "";
        grandTotal = dataResponse.orderDetailRecord?.grandTotal ?? "";
        wareAddressLine1 = dataResponse.orderDetailRecord?.wareAddressLine1 ?? "";
        warehouseName = dataResponse.orderDetailRecord?.warehouseName ?? "";
        addressLine1 = dataResponse.orderDetailRecord?.addressLine1 ?? "";
        addressLine2 = dataResponse.orderDetailRecord?.addressLine2 ?? "";
        franchiseName = dataResponse.orderDetailRecord?.franchiseName ?? "";
        paymentStatus = dataResponse.orderDetailRecord?.paymentStatus ?? "";
        orderNumber = dataResponse.orderDetailRecord?.orderNumber ?? "";
        status = dataResponse.orderDetailRecord?.status ?? "";
        shippingCharge = dataResponse.orderDetailRecord?.shippingCharge ?? "";
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

  orderDeleteRequest() async {
    if (isOnline) {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + orderDelete);
      Map<String, String> jsonBody = {
        'id': orderId,
        "remarks" : cancelRemarksController.value.text.toString()
      };

      final response = await http.post(url, body: jsonBody,
          headers:  {"Authorization": sessionManager.getToken() ?? ""});

      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = OrderDetailResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1)
      {
        context.read<TextChanger>().setAddOrder("add");
        context.read<TextChanger>().refreshProduct("refreshProduct");
        getOrderDetail();
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

  //PDF code...

  Future<void> _generatePDF() async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219, 255)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    _drawGrid(page, grid);

    final PdfGrid grid1 = _getGrid1();

    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(page, pageSize, grid1);
    //Draw grid
    _drawGrid1(page, grid1, result);
    //Add invoice footer
    // _drawFooter(page, pageSize);
    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    await saveAndLaunchFile(bytes, 'Invoice.pdf');

    //Launch file.
 //   await saveAndLaunchFile(bytes, 'Invoice.pdf');
    print("PDF downloaded....");

  }
    //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    /*   //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
    page.graphics.drawString(_getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));*/
  }
  void _drawGrid1(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;
    //Draw grand total.
    page.graphics.drawString('Grand Total',
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left,
            result.bounds.bottom + 10,
            quantityCellBounds!.width,
            quantityCellBounds!.height));
   /* page.graphics.drawString(_getTotalAmount(grid).toString(),
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left,
            result.bounds.bottom + 10,
            totalPriceCellBounds!.width,
            totalPriceCellBounds!.height));*/
  }

  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
    PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        '800 Interchange Blvd.\r\n\r\nSuite 2501, Austin, TX 78721\r\n\r\nAny Questions? support@adventure-works.com';
    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Draw the invoice header
  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    //Create data format and convert it to text.
    final String invoiceNumber = 'Invoice Number: $orderNumber\r\n\r\nDate: ' "${orderDetailData.timestamp?.toString() ?? " "}";

    final Size contentSize = contentFont.measureString(invoiceNumber);
    const String address = 'Melnex Enterprise Ltd. \r\n\r\n395 Berry Street \r\n\r\nWinnipeg Manitoba R3J 1N6';
    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 30,
            contentSize.width + 30, pageSize.height - 30));
    PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 30,
            pageSize.width - (contentSize.width + 30), pageSize.height - 30))!;

    // final String invoiceNumber = 'Invoice Number: $orderNumber\r\n\r\nDate: ' "${orderDetailData.timestamp?.toString() ?? " "}";

    String billAddress = 'Bill to:\r\n\r\n${franchiseName}\r\n\r\n${orderDetailData.addressLine1} ${orderDetailData.addressLine2}\r\n\r\n${orderDetailData.addressLine3} ${orderDetailData.addressLine4}';
    final Size contentSize1 = contentFont.measureString(billAddress);
    String shipAddress = 'Ship to:\r\n\r\n${franchiseName}\r\n\r\n${orderDetailData.addressLine1} ${orderDetailData.addressLine2}\r\n\r\n${orderDetailData.addressLine3} ${orderDetailData.addressLine4}';

    PdfTextElement(text: shipAddress, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize1.width + 30), 120,
            contentSize1.width + 30, pageSize.height - 120));
    return PdfTextElement(text: billAddress, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(30, 120,
            pageSize.width - (contentSize1.width), pageSize.height - 30))!;
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Set the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Purchase Order No.';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'Franchise Name';
    headerRow.cells[2].value = 'Shipping Method';
    headerRow.cells[3].value = 'Payment Terms';
    headerRow.cells[4].value = 'Req Ship Date';
    _add(orderNumber, franchiseName, "Local Delivery", "", orderDetailData.timestamp?.toString() ?? "",grid);


    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
//grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  PdfGrid _getGrid1() {
    //Create a PDF grid
    final PdfGrid grid1 = PdfGrid();

    grid1.columns.add(count: 6);

    final PdfGridRow headerRow1 = grid1.headers.add(1)[0];
    //Set style
    headerRow1.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow1.style.textBrush = PdfBrushes.white;

    headerRow1.cells[0].value = 'Ordered';
    headerRow1.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow1.cells[1].value = 'Item No.';
    headerRow1.cells[2].value = 'Description';
    headerRow1.cells[3].value = 'Unit';
    headerRow1.cells[4].value = 'Unit Price';
    headerRow1.cells[5].value = 'Ext. Price';
    for (int i = 0; i < orderDetailData.itemsMainList!.length; i++)
      {
        for (int j = 0; j < orderDetailData.itemsMainList![i].itemsInnerList!.length; j++)
          {
            _addItems("${orderDetailData.itemsMainList![i].itemsInnerList![j].category?.toString() ?? " "}\n"
                "${orderDetailData.itemsMainList![i].itemsInnerList![j].quantity?.toString() ?? ""}",
                orderDetailData.itemsMainList![i].itemsInnerList![j].skuCode?.toString() ?? "",
                orderDetailData.itemsMainList![i].itemsInnerList![j].item?.toString() ?? "",
                orderDetailData.itemsMainList![i].itemsInnerList![j].unit?.toString() ?? "",
                getPrice(orderDetailData.itemsMainList![i].itemsInnerList![j].amount?.toString() ?? ""),
                getPrice(orderDetailData.itemsMainList![i].itemsInnerList![j].amount?.toString() ?? "")
                ,grid1);
          }
      }

    grid1.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
//grid.columns[1].width = 200;

    for (int i = 0; i < headerRow1.cells.count; i++) {
      headerRow1.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid1.rows.count; i++) {
      final PdfGridRow row = grid1.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid1;
  }


  //Create row for the grid.
  void _add(String orderNo, String franchiseName, String shippingMethod, String paymentTerm, String reqShipDate, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = orderNo;
    row.cells[1].value = franchiseName;
    row.cells[2].value = shippingMethod;
    row.cells[3].value = paymentTerm;
    row.cells[4].value = reqShipDate;
  }

  //Create row for the grid.
  void _addItems(String ordered, String itemNo, String description, String unit, String unitPrice, String extPrice, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = ordered;
    row.cells[1].value = itemNo;
    row.cells[2].value = description.toString();
    row.cells[3].value = unit.toString();
    row.cells[4].value = unitPrice.toString();
    row.cells[5].value = extPrice.toString();
  }

  //Get the total amount.
  num _getTotalAmount(PdfGrid grid) {
    num total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
      grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += num.parse(value);
    }
    return total;
  }


}