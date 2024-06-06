import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../constant/colors.dart';
import '../constant/global_context.dart';
import 'session_manager.dart';

/// a base class for any stateful widget for checking internet connectivity
abstract class BaseState<T extends StatefulWidget> extends State with WidgetsBindingObserver {

  void castStatefulWidget();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  SessionManager sessionManager = SessionManager();

  /// the internet connectivity status
  bool isOnline = true;
  /// initialize connectivity checking
  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
      print("isOnline === $isOnline");
      print("isConnected === $isConnected");
    }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {

      await _updateConnectionStatus().then((isConnected) {
        setState(() {
          isOnline = isConnected;
        });
      },);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) async {

        await _updateConnectionStatus().then((isConnected) {
          setState(() {
            isOnline = isConnected;
            print("isOnline didChangeAppLifecycleState === $isOnline");
            print("isConnected didChangeAppLifecycleState === $isConnected");
          });
        },);
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<bool> _updateConnectionStatus() async {
    bool isConnected = false;
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        {
          isConnected = true;
        }
    }
    on SocketException catch (_)
    {
      isConnected = false;
      return false;
    }
    return isConnected;
  }

  void openNoInternetBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: white,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: false,
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
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10, bottom: 15, left: 12),
                    child: const Text("Your device smeems not connected to internet please try to connect again", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: black)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12, top: 10),
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                              height: 42,
                              child: TextButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side: const BorderSide(width: 1, color: primaryColor),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                 // startActivity(context, const DailyCallBottomNavigationScreen(0));
                                },
                                child: const Text("Go To Daily Call", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: primaryColor)),
                              )),
                        ),
                        Expanded(flex: 1, child: Container())
                      ],
                    ),
                  ),
                  const Gap(30)
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) => setState(() {
      NavigationService.isBottomSheetOpen = false;
    }));
  }

}