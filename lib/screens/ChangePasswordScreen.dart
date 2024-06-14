
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key});

  @override
  BaseState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends BaseState<ChangePasswordScreen> {

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _passwordVisible = true;
  bool _newPasswordVisible = true;
  bool _confirmPasswordVisible = true;
  bool isLoading = false;


  @override
  void initState() {
    ApiService.fetchData().then((response) {
      var data = response as CommonResponseModel;
      if (data.success == 1)
      {
      }
      else
      {
        invalidTokenRedirection(context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
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
          title: Text("Change Password", style: getAppBarTitleStyle(),),
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
        body: Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kContainerCornerRadius),
            color: white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(18),
                TextField(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  cursorColor: black,
                  controller: currentPasswordController,
                  obscureText: _passwordVisible ? true : false,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: subTitle,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Current Password',
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
                const Gap(28),
                TextField(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  cursorColor: black,
                  controller: newPasswordController,
                  obscureText: _newPasswordVisible ? true : false,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: subTitle,
                    color: black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                      child: Icon(_newPasswordVisible ? Icons.visibility : Icons.visibility_off, color: black,size: 20),
                    ),
                  ),
                ),
                const Gap(18),
                TextField(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  cursorColor: black,
                  controller: confirmPasswordController,
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
                Container(
                  margin: const EdgeInsets.only(top: 40, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  child: getCommonButtonLoad("Submit", isLoading, () {
                    {
                      if (currentPasswordController.text.isEmpty)
                      {
                        showSnackBar("Please enter your current password", context);
                      }
                      else if(newPasswordController.text.isEmpty)
                      {
                        showSnackBar("Please enter your new password", context);
                      }
                      else if(confirmPasswordController.text.isEmpty)
                      {
                        showSnackBar("Please enter your confirm password", context);
                      }
                      else if (newPasswordController.text == confirmPasswordController.text)
                      {
                        showSnackBar("New and Confirm Password must be equal.", context);
                      }
                      else
                      {
                        changePasswordApi();
                      }
                    }
                  }),
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
    widget is ChangePasswordScreen;
  }

  void changePasswordApi() async {
    if (isOnline)
    {
      setState(() {
        isLoading = true;
      });

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      final url = Uri.parse(MAIN_URL + changePw);

      Map<String, String> jsonBody = {
        "confirm_password": confirmPasswordController.value.text.trim(),
        "current_password": currentPasswordController.value.text.trim(),
        "password": currentPasswordController.value.text.trim(),
      };

      final response = await http.post(url, body: jsonBody);
      final statusCode = response.statusCode;

      final body = response.body;
      Map<String, dynamic> user = jsonDecode(body);
      var dataResponse = CommonResponseModel.fromJson(user);

      if (statusCode == 200 && dataResponse.success == 1) {
        setState(() {
          isLoading = false;
        });

      } else {
        setState(() {
          isLoading = false;
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