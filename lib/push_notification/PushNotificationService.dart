import 'package:chicken_delight/screens/OrderDetailScreen.dart';
import 'package:chicken_delight/tabs/tabnavigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../constant/global_context.dart';
import '../utils/session_manager.dart';
// ignore: slash_for_doc_comments
/**
 * Documents added by Alaa, enjoy ^-^:
 * There are 3 major things to consider when dealing with push notification :
 * - Creating the notification
 * - Hanldle notification click
 * - App status (foreground/background and killed(Terminated))
 *
 * Creating the notification:
 *
 * - When the app is killed or in background state, creating the notification is handled through the back-end services.
 *   When the app is in the foreground, we have full control of the notification. so in this case we build the notification from scratch.
 *
 * Handle notification click:
 *
 * - When the app is killed, there is a function called getInitialMessage which
 *   returns the remoteMessage in case we receive a notification otherwise returns null.
 *   It can be called at any point of the application (Preferred to be after defining GetMaterialApp so that we can go to any screen without getting any errors)
 * - When the app is in the background, there is a function called onMessageOpenedApp which is called when user clicks on the notification.
 *   It returns the remoteMessage.
 * - When the app is in the foreground, there is a function flutterLocalNotificationsPlugin, is passes a future function called onSelectNotification which
 *   is called when user clicks on the notification.
 *
 * */
class PushNotificationService {
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    // Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // RemoteMessage initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null && initialMessage.data['type'] == 'chat') {
    // Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(initialMessage));
    // }
// Also handle any interaction when the app is in the background via a
    // Stream listener
    // This function is called when the app is in the background and user clicks on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var orderId = "";
      var contentType = "";

      message.data.forEach((key, value) {
        if (key == "content_id")
        {
          orderId = value;
        }

        if (key == "content_type") {
          contentType = value;
        }
      });

      if(contentType == "order_details") {

        NavigationService.navigatorKey.currentState?.push(
          MaterialPageRoute(
              builder: (context) => OrderDetailScreen(orderId, true)),
        );


      } else {
        NavigationService.navigatorKey.currentState?.push(
          MaterialPageRoute(
              builder: (context) => const TabNavigation(0)),
        );
      }
    });

    await enableIOSNotifications();
    await registerNotificationListeners();
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSSettings = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: (payload) {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      try {
        print('<><> TAP onMessage :' + payload.toString() + "  <><>");
        var data = payload.toString().split("|");
        var orderId = data[0];
        var contentType = data[1];

        if(contentType == "order_details") {

          NavigationService.navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(orderId, false)),
          );

        }else {
          NavigationService.navigatorKey.currentState?.push(
            MaterialPageRoute(
                builder: (context) => const TabNavigation(0)),
          );
        }

      } catch (e) {
        print(e);
      }
    });
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print('Notification Payload:${message?.notification?.toMap().toString()}');
      print('Data Payload:${message?.data.toString()}');
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      AppleNotification? appleNotification = message?.notification?.apple;
      SessionManager sessionManager = SessionManager();
      var isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;

      if (notification != null && isLoggedIn && android !=null)
      {
        var orderId = "";
        var contentType = "";
         message?.data.forEach((key, value)
         {
          print("KEY=== " +  value);
            if (key == "content_id")
            {
              orderId = value;
            }

            if (key == "content_type") {
              contentType = value;
            }

            NavigationService.notif_type = contentType;
            NavigationService.orderID = orderId;

        });


        const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true,presentAlert: true, );

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'Chicken Delight',
              'Chicken Delight',
              channelDescription : channel.description,
              icon: android.smallIcon,
              playSound: true,
              importance: Importance.max,
              priority: Priority.high
            ),
              iOS: iOSPlatformChannelSpecifics),
          payload: "$orderId|$contentType",

        );
      }
    });
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true
    );
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description : 'This channel is used for important notifications.', // description
    importance : Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound_tone.mp3'),
  );

}