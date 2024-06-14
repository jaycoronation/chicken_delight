import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'SetPasswordScreen.dart';

class ForgotPwOtpScreen extends StatefulWidget {
  final String email;
  const ForgotPwOtpScreen(this.email, {super.key});

  @override
  BaseState<ForgotPwOtpScreen> createState() => _ForgotPwOtpScreenState();
}

class _ForgotPwOtpScreenState extends BaseState<ForgotPwOtpScreen> {
  TextEditingController otpController = TextEditingController();
  String email = "";
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    email = (widget as ForgotPwOtpScreen).email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop){
        if(didPop){
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: chicken_bg,
        appBar: AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child:getBackArrowBlack()),
          centerTitle: true,
          elevation: 0,
          backgroundColor: appBG,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width : MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(22),
                decoration:  BoxDecoration(
                  // border: Border.all(color: appBg, width: 0.5),
                  borderRadius:BorderRadius.all(Radius.circular(kContainerCornerRadius),) ,
                  color: white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/ic_chicken_logo.png",
                        height: 120,
                        width: 160,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    Text('Reset Password',
                      style: TextStyle(fontSize: titleFont, color: black,fontWeight: FontWeight.w600),
                    ),
                    Gap(4),
                    Text('Enter your 6 digit code to reset your password',
                        style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                    ),
                    Gap(28),
                    TextField(
                      readOnly: false,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      cursorColor: black,
                      controller:otpController,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: subTitle,
                        color: black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter code',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                        counterText: "",
                        labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: getCommonButtonLoad("Submit", isLoading,  () {
                        {
                          if(otpController.text.isEmpty)
                          {
                            showSnackBar("Please enter code", context);
                          }
                          else
                          {
                            forgotPasswordApi();
                          }
                        }
                      }),
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
  void castStatefulWidget() {
    widget is ForgotPwOtpScreen;
  }


  forgotPasswordApi() async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + forgotPwOtp);

      Map<String, String> jsonBody = {
        'email':email,
        'code': otpController.value.text,
      };

      final response = await http.post(url, body: jsonBody);

      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var loginResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && loginResponse.success == 1) {
        setState(() {
          isLoading = false;
        });
        //showSnackBar(loginResponse.message, context);
        startActivity(context, SetPasswordScreen(email, otpController.value.text));

      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(loginResponse.message, context);
      }
    }
    else
      {
        noInternetSnackBar(context);
      }

  }

}