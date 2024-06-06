
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
import 'ForgotPwOtpScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen( {super.key});

  @override
  BaseState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseState<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;

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
                         "assets/images/ic_chicken_logo.jpg",
                         height: 120,
                         width: 160,
                         // fit: BoxFit.cover,
                       ),
                     ),
                     Text('Reset Password',
                       style: TextStyle(fontSize: titleFont, color: black,fontWeight: FontWeight.w600),
                     ),
                     const Gap(4),
                     Text('Enter your registered email',
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
   widget is ForgotPasswordScreen;
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

         final url = Uri.parse(MAIN_URL + forgotPw);

         Map<String, String> jsonBody = {
           'email':emailController.value.text,
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
           startActivity(context, ForgotPwOtpScreen(emailController.value.text));

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