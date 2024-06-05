import 'dart:convert';

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
import '../widget/loading.dart';
import '../widget/no_internet.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  BaseState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseState<ProductListScreen> {
  bool isLoading = false;
  List<Records> listItems = [];
  bool _isLoading = false;


  @override
  void initState() {
    geItemList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          backgroundColor: chicken_bg,
          appBar:AppBar(
            toolbarHeight: kToolbarHeight,
            automaticallyImplyLeading: false,
            title: getTitle("Product List"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: chicken_bg,
          ),
          body: isOnline
              ? _isLoading
              ? const LoadingWidget()
              : ListView.builder(
                  itemCount: listItems.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
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
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(listItems[index].name ?? "",
                                      style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip
                                    ),
                                    Text(listItems[index].productCode ?? "",
                                        style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip
                                    ),
                                    Text(getPrice(listItems[index].mrpPrice ?? ""),
                                      style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w600, overflow: TextOverflow.clip,),textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(16),
                      ],
                    );
                  },
                )
              : const NoInternetWidget()
        ),
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(true);
      },
    );
  }

  @override
  void castStatefulWidget() {
   widget is ProductListScreen;
  }

  geItemList() async {

    if (isOnline)
    {
      setState(() {
        _isLoading = true;
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
            listItems = dataResponse.records ?? [];
          }
        }
        setState(() {
          _isLoading = false;
        });
      }
      else {
        setState(() {
          _isLoading = false;
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