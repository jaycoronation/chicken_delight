import 'package:chicken_delight/constant/colors.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../common_widget/CommonTextFiled.dart';
import '../../common_widget/common_widget.dart';
import '../../utils/app_utils.dart';
import '../../utils/base_class.dart';
import '../model/ItemResponseModel.dart';
import '../widget/no_data.dart';

class SelectItemPage extends StatefulWidget {
  List<Records> listItems;

  SelectItemPage(this.listItems, {super.key});

  @override
  BaseState<SelectItemPage> createState() => _SelectItemPageState();
}

class _SelectItemPageState extends BaseState<SelectItemPage> {
  bool isLoading = false;

  late ScrollController _scrollController;

  List<Records> listItems = [];
  List<Records> listItemsMain = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    listItems = (widget as SelectItemPage).listItems;
    listItemsMain = listItems;

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        },
        child: Scaffold(
          backgroundColor: appBG,
          appBar: AppBar(
            toolbarHeight: kToolbarHeight,
            automaticallyImplyLeading: false,
            title: getTitle("Select Items"),
            leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child:getBackArrowBlack()),
            centerTitle: true,
            elevation: 0,
            backgroundColor: appBG,
            actions: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Done", textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500, color: black, fontSize: 15))),
              const Gap(15)
            ],
          ),
          body: Column(
            children: [
              Visibility(
                visible: listItems.isNotEmpty,
                child: Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: SearchTextField(
                      controller: _searchController,
                      hintText: "Search...",
                      suffixIcon: 'assets/images/ic_close.png',
                      onTapClear: () async {
                        setState(() {
                          _searchController.text = "";
                          listItems = listItemsMain;
                        });
                      },
                      onChanged: (String text) {
                        _searchController.text = text;
                        _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));

                        setState(() {
                          if (text.isNotEmpty) {
                            listItems = [];
                            for (int i = 0; i < listItemsMain.length; i++) {
                              if (listItemsMain[i].name.toString().toLowerCase().contains(text.toString().toLowerCase())) {
                                listItems.add(listItemsMain[i]);
                              }
                            }
                          } else {
                            listItems = listItemsMain;
                          }
                        });
                      },
                    )),
              ),
              isLoading
                  ? const LoadingWidget()
                  : listItems.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: listItems.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    if (listItems[index].isSelected ?? false) {
                                      listItems[index].isSelected = false;
                                    } else {
                                      listItems[index].isSelected = true;
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(top: index == 0 ? 10 : 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Gap(20),
                                          Image.asset(listItems[index].isSelected ?? false
                                                  ? 'assets/images/ic_checkbox_selected.png'
                                                  : 'assets/images/ic_checkbox_unselected.png',
                                              color: listItems[index].isSelected ?? false ? primaryColor : black,
                                              height: 24,
                                              width: 24),
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                              child: RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: "${checkValidString(listItems[index].productCode)} ",
                                                  style: getBlackTextStyle(),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: checkValidString(listItems[index].name),
                                                      style: getThinTextStyle(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 0.8, color: grayNew,)
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(
                        child: MyNoDataWidget(msg: "No items found", imageName: 'ic-no-products.png', subMsg: '',
                                        onTap: () {  }, btnTitle: '', colorCode: const Color(0xFF6a89ba),),
                      ),
              const Gap(20)
            ],
          ),
        ));
  }

  @override
  void castStatefulWidget() {
    widget is SelectItemPage;
  }

  /*bool checkIsValid() {
    bool isAnySelected = true;
    for (int i = 0; i < listItems.length; i++) {
      if (listItems[i].isSelected == true) {
          isAnySelected = false;
          break;
      }
    }

    return isAnySelected;
  }*/

  bool isCheckAny() {
    bool isAnySelected = false;
    for (int i = 0; i < listItems.length; i++) {
      if (listItems[i].isSelected == true) {
        isAnySelected = true;
        break;
      }
    }
    return isAnySelected;
  }

}
