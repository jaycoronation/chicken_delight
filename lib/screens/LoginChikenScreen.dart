import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/LoginResponseModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import 'ForgotPasswordScreen.dart';
import 'OrderDetailScreen.dart';

class LoginChikenScreen extends StatefulWidget {

  const LoginChikenScreen( {super.key});

  @override
  BaseState<LoginChikenScreen> createState() => _LoginChikenScreenState();
}

class _LoginChikenScreenState extends BaseState<LoginChikenScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool isLoading = false;
  bool _passwordVisible = true;

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
                  decoration:  BoxDecoration(
                    // border: Border.all(color: appBg, width: 0.5),
                    borderRadius:const BorderRadius.all(Radius.circular(18),) ,
                    color: white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/ic_chicken_logo.jpg",
                          height: 120,
                          width: 160,
                          // fit: BoxFit.cover,
                        ),
                      ),
                      Text('Login to account',
                          style: TextStyle(fontSize: titleFont, color: black,fontWeight: FontWeight.w600),
                      ),
                      Gap(4),
                      Text('Enter your email & password to login ',
                          style: TextStyle(fontSize: description, color: black,fontWeight: FontWeight.w400),textAlign: TextAlign.left
                      ),
                      Gap(28),
                      TextField(
                        readOnly: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        cursorColor: black,
                        controller:emailController,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: subTitle,
                          color: black,
                        ),
                        decoration: InputDecoration(
                          // fillColor: grayForDetail,
                          // filled: true,
                          labelText: 'Email Address',
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
                      Gap(12),
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
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: grayDividerDetail),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: grayDividerDetail),
                            borderRadius: BorderRadius.circular(16),
                          ),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                            startActivity(context, const OrderDetailScreen());
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
    widget is LoginChikenScreen;
  }

  loginApi() async {
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
        loginResponse.records?.name  ?? "",
        loginResponse.records?.profilePicture  ?? "",
        loginResponse.records?.token  ?? "",
      );
      startActivity(context, const OrderDetailScreen());

    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(loginResponse.message, context);
    }
  }


}