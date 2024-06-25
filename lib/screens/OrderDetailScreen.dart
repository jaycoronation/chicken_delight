import 'dart:convert';

import 'package:chicken_delight/constant/global_context.dart';
import 'package:chicken_delight/model/common/CommonResponseModel.dart';
import 'package:chicken_delight/screens/AddOrderScreen.dart';
import 'package:chicken_delight/screens/save_file_mobile.dart';
import 'package:chicken_delight/tabs/tabnavigation.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/ItemResponseModel.dart';
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
  List<Selecteditems> listSelectedItems = [];
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
  String dateTime = "";
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Order #$orderNumber",
                                  style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),
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
                                        style: TextStyle(fontSize: 13, color: status == "Cancelled" ? Colors.red : Colors.green,fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.left
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(dateTime,
                              style: const TextStyle(fontSize: 13, color: text_light_gray,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left
                          ),
                          const Gap(2),
                          Text(paymentStatus,
                              style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left
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
                                                visible: getSetInner.image?.isNotEmpty ?? false,
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
                                          Gap(5),
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
                                        style: const TextStyle(fontSize: 15, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
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
                  /*Visibility(
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
                  const Gap(10),*/
                  Visibility(
                    visible: status == "Placed" || status == "Accepted",
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
                    visible: status == "Processed" || status == "Delivered",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                          child: getCommonButtonLoad("Print Invoice", false, () {
                            {
                              _generatePDF();
                            }
                          }),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20, right: 20),
                          child: getCommonButtonLoad("Repeat Order", false, () {
                            {
                              redirectToCart();
                            }
                          }),
                        ),
                      ],
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

  Future<void> redirectToCart() async {
    NavigationService.listItemsTmp = [];

    setState(() {
      for (int i = 0; i < listSelectedItems.length; i++)
      {

          Records getSet = Records();

          getSet = Records(
            id: listSelectedItems[i].id?.toString() ?? "",
            description:  "",
            name: listSelectedItems[i].item?.toString() ?? "",
            icon: listSelectedItems[i].icon?.toString() ?? "",
            productCode: "",
            unit: listSelectedItems[i].unit?.toString() ?? "",
            variationName: "",//listSelectedItems[i].variationId?.toString() ?? "",
            skuCode: listSelectedItems[i].skuCode?.toString() ?? "",
            salePrice: listSelectedItems[i].salePrice?.toString() ?? "",
            mrpPrice: "",
            dpPrice: "",// listItems[i].itemsInnerList?[n].dpPrice,
            category: listSelectedItems[i].category?.toString() ?? "",
            variationId: listSelectedItems[i].variationId?.toString() ?? "",
            categoryId: listSelectedItems[i].categoryId?.toString() ?? "",
            isSelected: true,//listSelectedItems[i].is?.toString() ?? "",
            quantity: num.parse(listSelectedItems[i].quantity?.toString() ?? ""),
            amount: num.parse(listSelectedItems[i].amount?.toString() ?? ""),
            // updateCartCount: cartCount
          );

         NavigationService.listItemsTmp.add(getSet);
        }


    });

    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderScreen()));
    /*setState(() {
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
                    amount: num.parse( NavigationService.listItemsTmp[i].salePrice.toString()),
                    // updateCartCount: cartCount
                );

                NavigationService.listItems[n] = getSet;
              }
            }
          }
        }
      });*/


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
        listSelectedItems = dataResponse.orderDetailRecord?.selecteditems ?? [];
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
        dateTime = dataResponse.orderDetailRecord?.timestamp ?? "";

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
    print("PDF Start....");
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    print("PDF Page Add....");
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    print("PDF Add Data....");
  //  page.graphics.drawRectangle(bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),pen: PdfPen(PdfColor(142, 170, 219, 255)));

    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(page, pageSize);
    //_getGridBillTo(page, result);
    _getGrid(page,result);
    _getGridBottom(page,result);
    print("PDF Aft6er Data....");
    //Draw grid
    //Save and dispose the document.
    print("PDF Aft6er Data....");
    final List<int> bytes = await document.save().onError((error, stackTrace) {
      print("error === $error");
      print("stackTrace === $stackTrace");
      return [];
    },);
    await saveAndLaunchFile(bytes, 'Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf');
    document.dispose();
    //Launch file.

  }

  //Draw the invoice header
  _drawHeader(PdfPage page, Size pageSize)
  {
    //Draw rectangle
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

  /*  final PdfGrid grid = PdfGrid();
    //Set the columns count to the grid.
    grid.columns.add(count: 2);
    //Create the header row of the grid.


    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Invoice Number:';
    row.cells[1].value = 'Date';

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = orderNumber;
    row1.cells[1].value = orderDetailData.timestamp?.toString() ?? " ";*/

    //Create data format and convert it to text.
    final String invoiceNumber = 'Invoice Number : $orderNumber'
        '\r\nDate : '"${universalDateConverter("MMM dd, yyyy hh:mm a", "MMM dd, yyyy", orderDetailData.timestamp?.toString() ?? "")}";
        //"\r\nPage: ${page.getClientSize()}";

    final Size contentSize = contentFont.measureString(invoiceNumber);

    const String address = 'Melnex Enterprise Ltd.\r\n395 Berry Street\r\nWinnipeg Manitoba R3J 1N6';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width), 10,
            contentSize.width, pageSize.height));

    PdfTextElement(text: address, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 10, pageSize.width - (contentSize.width), pageSize.height)
     );

    String shipAddress = 'Ship to:\r\n\r\n$franchiseName\r\n${orderDetailData.addressLine1}\n${orderDetailData.addressLine2}\r\n${orderDetailData.addressLine3}\n${orderDetailData.addressLine4}';
    final Size contentSize1 = contentFont.measureString(shipAddress);

    String billAddress = 'Bill to:\r\n\r\n$franchiseName\r\n${orderDetailData.addressLine1}\n${orderDetailData.addressLine2}\r\n${orderDetailData.addressLine3}\n${orderDetailData.addressLine4}';

    PdfTextElement(text: shipAddress, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize1.width), 80,
            contentSize1.width, pageSize.height - 80));

    return PdfTextElement(text: billAddress, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 80,
            contentSize1.width, pageSize.height - 80));
  }

  PdfGrid _getGridBillTo(PdfPage page, PdfLayoutResult result) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Set the columns count to the grid.
    grid.columns.add(count: 1);
    //Create the header row of the grid.

    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Bill to';
//
    String billAddress = 'Bill to:\r\n$franchiseName\r\n${orderDetailData.addressLine1}\n${orderDetailData.addressLine2}\r\n${orderDetailData.addressLine3}\n${orderDetailData.addressLine4}';
    PdfGridRow row1 = grid.rows.add();

    row1.style = cellStyle;
    row1.cells[0].value = billAddress;

    for (int i = 0; i < grid.columns.count; i++) {
      row.cells[i].style = cellStyle;
    }

    grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 10, 0, 0));

    return grid;
  }

  //Create PDF grid and return
  PdfGrid _getGrid(PdfPage page, PdfLayoutResult result) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Set the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.

    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Purchase Order No.';
    row.cells[1].value = 'Franchise Name';
    row.cells[2].value = 'Shipping Method';
    row.cells[3].value = 'Payment Terms';
    row.cells[4].value = 'Req Ship Date';


    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = orderNumber;
    row1.cells[1].value = franchiseName;
    row1.cells[2].value = "Local Delivery";
    row1.cells[3].value = "";
    row1.cells[4].value = universalDateConverter("MMM dd, yyyy hh:mm a", "MMM dd, yyyy", orderDetailData.timestamp?.toString() ?? "");


    for (int i = 0; i < grid.columns.count; i++) {
      row.cells[i].style = cellStyle;
      row1.cells[i].style = cellStyle;
    }
    grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 30, 0, 0));

    return grid;
  }

  PdfGrid _getGridBottom(PdfPage page, PdfLayoutResult result) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Set the columns count to the grid.
    grid.columns.add(count: 6);
    //Create the header row of the grid.

    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'Ordered';
    row.cells[1].value = 'Item No.';
    row.cells[2].value = 'Description';
    row.cells[3].value = 'Unit';
    row.cells[4].value = 'Unit Price';
    row.cells[5].value = 'Ext. Price';

    List<PdfGridRow> item = List<PdfGridRow>.empty(growable: true);
    for (int i = 0; i < (orderDetailData.itemsMainList?.length ?? 0); i++)
    {
      for (int j = 0; j < (orderDetailData.itemsMainList?[i].itemsInnerList?.length ?? 0); j++)
      {
        PdfGridRow row1 = grid.rows.add();
        row1.style = cellStyle;
        row1.cells[0].value = "${orderDetailData.itemsMainList?[i].itemsInnerList?[j].category?.toString() ?? " "}\n"
            "${orderDetailData.itemsMainList?[i].itemsInnerList?[j].quantity?.toString() ?? ""}";
        row1.cells[1].value = orderDetailData.itemsMainList?[i].itemsInnerList?[j].skuCode?.toString() ?? "";
        row1.cells[2].value = orderDetailData.itemsMainList?[i].itemsInnerList?[j].item?.toString().toUpperCase() ?? "";
        row1.cells[3].value = orderDetailData.itemsMainList?[i].itemsInnerList?[j].unit?.toString().toUpperCase() ?? "";
        row1.cells[4].value = getPrice(orderDetailData.itemsMainList?[i].itemsInnerList?[j].amount?.toString() ?? "");
        row1.cells[5].value = getPrice(orderDetailData.itemsMainList?[i].itemsInnerList?[j].amount?.toString() ?? "");

        item.add(row1);
      }
    }

    if (subTotal != grandTotal)
    {
      final PdfGridRow row3 = grid.rows.add();
      row3.cells[0].value = 'FREIGHT';
      row3.cells[1].value = '';
      row3.cells[2].value = 'EACH ${getPrice("75.00")} DELIVERY CHARGES';
      row3.cells[3].value = '';
      row3.cells[4].value = getPrice("75.00");
      row3.cells[5].value = getPrice("75.00");

      for (int i = 0; i < grid.columns.count; i++) {
        row3.cells[i].style = cellStyle;
      }
    }

    final PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = '';
    row4.cells[1].value = '';
    row4.cells[2].value = '';
    row4.cells[3].value = 'GRAND TOTAL';
    row4.cells[4].value = 'Total';
    row4.cells[5].value = getPrice(grandTotal);


    for (int i = 0; i < grid.columns.count; i++) {
      row.cells[i].style = cellStyle;
      row4.cells[i].style = cellStyle;
    }


    for (int i = 0; i < grid.columns.count; i++) {
      for (int p = 0; p < item.length; p++) {
        item[p].cells[i].style = cellStyle;
      }
    }

    grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 70, 0, 0));

    return grid;
  }

  //create a new pdf font

  PdfGridCellStyle cellStyle = PdfGridCellStyle(
    backgroundBrush: PdfBrushes.white,
    borders: PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0), width: 1),
        top: PdfPen(PdfColor(0, 0, 0), width: 1),
        bottom: PdfPen(PdfColor(0, 0, 0), width: 1),
        right: PdfPen(PdfColor(0, 0, 0), width: 1)),
    cellPadding: PdfPaddings(left: 3, right: 3, top: 3, bottom: 3),
    font: PdfStandardFont(PdfFontFamily.helvetica, 9),
   format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle, wordSpacing: 4),
   textBrush: PdfBrushes.black,
  );

}