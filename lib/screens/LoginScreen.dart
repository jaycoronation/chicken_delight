import 'dart:convert';

import 'package:chicken_delight/tabs/tabnavigation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/LoginResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen( {super.key});

  @override
  BaseState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _passwordVisible = true;

  @override
  void initState(){
     super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: chicken_bg,
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width : MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
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
                      Text('Login to account',
                          style: TextStyle(fontSize: titleFont, color: black,fontWeight: FontWeight.w600),
                      ),
                      const Gap(4),
                      Text('Enter your email & password to login ',
                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                      ),
                      const Gap(28),
                      TextField(
                        readOnly: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: black,
                        controller:emailController,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: subTitle,
                          color: black,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                          counterText: "",
                          labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                        ),
                      ),
                      const Gap(12),
                      TextField(
                        readOnly: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
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
                      const Gap(18),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            startActivity(context, const ForgotPasswordScreen());
                          },
                          child: Text('Forgot Password ?',
                              style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w500),textAlign: TextAlign.right
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: getCommonButtonLoad("Submit", isLoading,  () {
                          {
                            if(emailController.text.isEmpty)
                            {
                              showSnackBar("Please enter your email address", context);
                            }
                            else if (!isValidEmail(emailController.text))
                            {
                              showSnackBar("Please enter valid email address", context);
                            }
                            else if(passwordController.text.isEmpty)
                            {
                              showSnackBar("Please enter your password", context);
                            }
                            else
                            {
                              loginApi();
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
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is LoginScreen;
  }

  loginApi() async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + login);

      Map<String, String> jsonBody = {
        'email':emailController.value.text,
        'password':passwordController.value.text,
      };

      final response = await http.post(url, body: jsonBody);

      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var loginResponse = LoginResponseModel.fromJson(user);

      if (statusCode == 200 && loginResponse.success == 1) {
        setState(() {
          isLoading = false;
        });

        await sessionManager.createLoginSession(
          loginResponse.records?.id  ?? "",
          loginResponse.records?.token  ?? "",
          loginResponse.records?.type  ?? "",
          loginResponse.records?.name  ?? "",
          loginResponse.records?.profilePicture  ?? "",
          loginResponse.records?.shippingCharge  ?? "",

        );
        startActivity(context, const TabNavigation(0));

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