
import 'dart:convert';

import 'package:chicken_delight/model/common/CommonResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/ItemResponseModel.dart';
import '../model/OrderDetailResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class AddOrderScreen extends StatefulWidget {

  @override
  BaseState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends BaseState<AddOrderScreen> {
  TextEditingController remarksController = TextEditingController();

  bool isLoading = false;
  List<Records> listItem = [];



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
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(8),
                TextField(
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: black,
                  maxLength: 10, //Any specific length
                  maxLines: 2,
                  controller:remarksController,
                  onTap: (){
                    ItemDialog();
                  },
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: subTitle,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    // fillColor: grayForDetail,
                    // filled: true,
                    labelText: 'Remarks',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                    counterText: "",
                    labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: grayDividerDetail),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: grayDividerDetail),
                      borderRadius: BorderRadius.circular(16),
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
    widget is AddOrderScreen;
  }



  ItemDialog() async {
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
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: listItem.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      listItem[index].icon ?? "",
                                      fit: BoxFit.cover,
                                      height: 70,
                                      width:70,
                                    ),
                                  ),
                                  Text(listItem[index].name ?? "",
                                      style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                  ),
                                  Text(listItem[index].mrpPrice ?? "",
                                      style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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

  geItemList() async {

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
    print(response);
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = ItemResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1)
    {
      setState(() {
        listItem = dataResponse.records ?? [];
      });
    }
    else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

}