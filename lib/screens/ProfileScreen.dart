import 'dart:core';
import 'package:chicken_delight/screens/LoginScreen.dart';
import 'package:chicken_delight/utils/app_utils.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../common_widget/common_widget.dart';
import '../constant/colors.dart';
import '../model/StoreMenuModel.dart';
import '../utils/base_class.dart';
import '../utils/session_manager.dart';
import '../utils/session_manager_methods.dart';
import 'ChangePasswordScreen.dart';
import 'ForgotPasswordScreen.dart';
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
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
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
                            startActivity(context,  ForgotPasswordScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/ic_logout.png', height: 22, width: 22, color: black),
                              const Gap(12),
                              Expanded(
                                child: Text("Change Password",
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
                  Container(
                    margin: const EdgeInsets.only(top: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kContainerCornerRadius),
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
                              const Gap(12),
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
                    color: black,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  Container(margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('Logout', style: TextStyle(fontSize: medium, fontWeight: FontWeight.w700, color: black))
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 15),
                    child: Text('Are you sure want to Logout?', style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
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
                                child: Text('Cancel',
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
                                Navigator.pop(context);
                                SessionManagerMethods.clear();
                                await SessionManagerMethods.init();
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
                              },
                              child: Text('Logout', style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w600, color: white)),
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
