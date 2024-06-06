import 'dart:core';
import 'package:chicken_delight/screens/DashboardPage.dart';
import 'package:chicken_delight/screens/LoginScreen.dart';
import 'package:chicken_delight/utils/app_utils.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import '../common_widget/common_widget.dart';
import '../constant/colors.dart';
import '../model/ProfileScreen.dart';
import '../utils/base_class.dart';
import '../utils/session_manager.dart';
import '../utils/session_manager_methods.dart';
import 'MyProfileScreen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  BaseState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseState<ProfileScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  var strSubscriptionEnd = '';
  bool hideChangePassword = false;

  List<StoreMenuGetSet> useFullLinks = [];
  List<StoreMenuGetSet> listLogout = [];

  final SessionManagerMethods _sessionManagerMethods = SessionManagerMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key, // Assign the key to Scaffold.
      backgroundColor: appBG,
      appBar:AppBar(
        toolbarHeight: kToolbarHeight,
        automaticallyImplyLeading: false,
        title: getTitle("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: chicken_bg,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: Card(
                      color: white,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen()));
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Card(
                                        elevation: 5,
                                        clipBehavior: Clip.antiAlias,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                        ),
                                        child: sessionManager.getImagePic().toString().isNotEmpty ? FadeInImage.assetNetwork(
                                          image: sessionManager.getImagePic().toString(),
                                          fit: BoxFit.cover,
                                          width: 60,
                                          height: 60,
                                          placeholder: 'assets/images/ic_placeholder.png',
                                        ) : Image.asset('assets/images/ic_placeholder.png',  width: 60,
                                            height: 60)
                                    ),
                                  ),
                                  const Gap(4),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      sessionManager.getName().toString().isNotEmpty
                                          ? Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            child:RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                text: '',
                                                style: TextStyle(fontSize: medium, fontWeight: FontWeight.w500,color: hintDark, fontFamily: 'Switzer'),
                                                children: <TextSpan>[
                                                  TextSpan(text: "${toDisplayCase(sessionManager.getName().toString())}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: black, fontFamily: 'Switzer'),
                                                      recognizer: TapGestureRecognizer()..onTap = () => {
                                                      })
                                                ],
                                              ),
                                            ),
                                          )
                                          : const Text("Guest User", style: TextStyle(fontWeight: FontWeight.w800, color: black,fontSize: 18))
                                    ],
                                  )),
                                  const Gap(4),
                                  Image.asset('assets/images/ic_right_arrow_new.png', height: 12, width: 12, color: black),
                                  const Gap(10)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 18),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: white,
                      border: Border.all(
                        color: white,
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            logoutFromApp(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/ic_logout.png', height: 22, width: 22, color: black),
                              Gap(12),
                              Expanded(
                                child: Text("Logout",
                                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),textAlign: TextAlign.left
                                ),
                              ),
                              Image.asset('assets/images/ic_right_arrow_new.png', height: 14, width: 14, color: black)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  void castStatefulWidget() {
    widget is ProfileScreen;
  }

  void logoutFromApp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return Wrap(
          children: [

            Container(
              margin: const EdgeInsets.all(15),
              decoration:
              const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), color: white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 2,
                      width: 40,
                      color: black,
                      margin: const EdgeInsets.only(bottom: 18)
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: black))),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 12),
                    child: const Text('Are you sure want to Logout?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(
                              left: 12, right: 12, top: 30),
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
                                  borderRadius: BorderRadius.circular(22.0),
                                ),
                              ),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(white),
                            ),
                            child:  Padding(
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
                          margin: const EdgeInsets.only(left: 12, right: 12, top: 30),
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              SessionManagerMethods.clear();
                              await SessionManagerMethods.init();
                              var sessionManager = SessionManager();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: black,
                                        width: 1,
                                        style: BorderStyle.solid
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(black)
                            ),
                            child:   Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Logout",
                                style: TextStyle(
                                    color: white,
                                    fontSize: contentSize,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  void deactivateAccountFromApp() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  color: white),
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
                  Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: const Text('Delete Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only( bottom: 15, left: 10, right: 10),
                    child: const Text("All the data associated with it(including your profile,photo and subscriptions) will be permanently deleted in 30 days. this information can't be recovered once the account is deleted.",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: black), textAlign: TextAlign.center),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.4, color: primaryColor),
                                borderRadius:  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
                              ),
                              margin: const EdgeInsets.only(right: 10),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child:const Text('No', style:TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor,))
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kButtonCornerRadius),
                                color:primaryColor,
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                child:
                                const Text('Yes',style:TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: white)),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  //API call function...

}
