import 'dart:async';

import 'package:chicken_delight/utils/app_utils.dart';
import 'package:chicken_delight/utils/base_class.dart';
import 'package:flutter/material.dart';

import 'constant/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chicken Delight',
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: black,
          platform: TargetPlatform.iOS,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 1, style: BorderStyle.solid, color: grayNew)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 1, style: BorderStyle.solid, color: lightBrandColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius), borderSide: const BorderSide(width: 1, color: grayNew)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius), borderSide: const BorderSide(width: 1, color: grayNew)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kEditTextCornerRadius),
                borderSide: const BorderSide(width: 1, style: BorderStyle.solid, color: grayNew)),
            labelStyle: const TextStyle(color: lightBrandColor, fontSize: 14, fontWeight: FontWeight.w400),
            hintStyle: const TextStyle(color: lightBrandColor, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          fontFamily: 'Inter',
          textSelectionTheme: TextSelectionThemeData(selectionColor: primaryColor.withOpacity(0.3)),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(white)).copyWith(secondary: white)),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  BaseState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseState<MyHomePage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (sessionManager.checkIsLoggedIn() ?? false)
      {
       // startActivityAnimationRemove(context, const DashboardNewScreen());
      }
      else
      {
        if (sessionManager.getIsDeviceRegistered() ?? false)
        {
          //startAndRemoveActivity(context, const LoginWithEmpCodeScreen());
        }
        else
        {
         // startAndRemoveActivity(context, const LoginWithOtpScreen());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        /*decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Image.asset('assets/images/ic_chicken_logo.jpg',
          height: 100,
          width: 100,
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is MyHomePage;
  }

}
