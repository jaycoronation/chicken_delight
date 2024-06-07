
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
import 'LoginScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ChangePasswordScreen(this.email, this.otp,  {super.key});

  @override
  BaseState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseState<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;
  bool isLoading = false;
  String email = "";
  String otp = "";

  @override
  void initState(){
    email = (widget as ChangePasswordScreen).email;
    otp = (widget as ChangePasswordScreen).otp;
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
                  borderRadius: BorderRadius.all(Radius.circular(kContainerCornerRadius),) ,
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
                    Text('Set Password',
                      style: TextStyle(fontSize: titleFont, color: black,fontWeight: FontWeight.w600),
                    ),
                    Gap(4),
                    Text('Enter your new password',
                        style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                    ),
                    Gap(28),
                    TextField(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      cursorColor: black,
                      controller: passwordController,
                      obscureText: _passwordVisible ? true : false,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: subTitle,
                        color: black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: black,size: 20),
                        ),
                      ),
                    ),
                    Gap(18),
                    TextField(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      cursorColor: black,
                      controller: confirmController,
                      obscureText: _confirmPasswordVisible ? true : false,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: subTitle,
                        color: black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _confirmPasswordVisible = !_confirmPasswordVisible;
                            });
                          },
                          child: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: black,size: 20),
                        ),
                      ),
                    ),
                    Gap(28),
                    Container(
                      margin: const EdgeInsets.only(top: 30, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: getCommonButtonLoad("Submit", isLoading,  () {
                        {
                          if(passwordController.text.isEmpty)
                          {
                            showSnackBar("Please enter your password", context);
                          }
                          else if(confirmController.text.isEmpty)
                          {
                            showSnackBar("Please enter your confirm password", context);
                          }
                          else if (passwordController.text == confirmController.text)
                          {
                            showSnackBar("New and Confirm Password must be equal.", context);
                          }
                          else
                          {
                            resetPasswordApi();
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
    widget is ChangePasswordScreen;
  }


  resetPasswordApi() async {
    if (isOnline)
      {
        setState(() {
          isLoading = true;
        });

        HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
          HttpLogger(logLevel: LogLevel.BODY),
        ]);

        final url = Uri.parse(MAIN_URL + resetPw);

        Map<String, String> jsonBody = {
          'email':email,
          'password': passwordController.value.text,
          'confirm_password': confirmController.value.text,
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
          showSnackBar(loginResponse.message, context);
          startActivity(context,  LoginScreen());

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