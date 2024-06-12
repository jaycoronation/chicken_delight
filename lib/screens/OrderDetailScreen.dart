import 'dart:convert';

import 'package:chicken_delight/model/common/CommonResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/OrderDetailResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen(this.orderId, {Key? key}) : super(key: key);

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
                              const Gap(12),
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
                  Visibility(
                    visible: warehouseName.isNotEmpty && wareAddressLine1.isNotEmpty,
                    child: Container(
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
                  Visibility(
                    visible: franchiseName.isNotEmpty && addressLine1.isNotEmpty,
                    child: Container(
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
                  ),
                  Visibility(
                    visible: paymentStatus.isNotEmpty,
                    child: Container(
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