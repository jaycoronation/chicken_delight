import 'dart:convert';
import 'dart:io';
import 'package:chicken_delight/screens/OrderDetailScreen.dart';
import 'package:chicken_delight/tabs/tabnavigation.dart';
import 'package:chicken_delight/utils/app_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:http/http.dart' as http;

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
    await FirebaseMessaging.instance.requestPermission();
    await enableIOSNotifications();
    await registerNotificationListeners();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    // Get any messages which caused the application to open from a terminated state.
    // If you want to handle a notification click when the app is terminated, you can use `getInitialMessage`
    // to get the initial message, and depending in the remoteMessage, you can decide to handle the click
    // This function can be called from anywhere in your app, there is an example in main file.
    // RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
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
      var id = "";
      var contentType = "";
      var image = "";
      var messageData = "";
      print('Data Payload:${message.data.toString()}');
      message.data.forEach((key, value) {
        if (key == "content_id") {
          id = value;
        }

        if (key == "content_type") {
          contentType = value;
        }

        if (key == "image") {
          image = value;
        }

        if (key == "message") {
          messageData = value;
        }
      });

      NavigationService.notif_id = id;
      NavigationService.notif_type = contentType;

      print('<><> onMessageOpenedApp id--->$id');
      print('<><> onMessageOpenedApp contentType--->$contentType');

      openPage(contentType);
    });
  }

  registerNotificationListeners() async {
    AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        SessionManager sessionManager = SessionManager();
        var isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
        if (title != null && isLoggedIn)
        {
          var idAPI = "";
          var contentType = "";
          var image = "";
          var titleAPI = "";
          var messageData = "";

          titleAPI = title.toString();
          idAPI = id.toString();
          messageData = body.toString();


          NavigationService.notif_id = idAPI;
          NavigationService.notif_type = contentType;
          print('<><> onMessage id--->$id');
          print('<><> onMessage contentType--->$contentType');
          print("<><> onMessage Image URL : $image <><>");
          print("<><> onMessage Payload : $payload <><>");
          const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: true, presentAlert: true);
         /* if (image != null)
          {
            if(image.toString().isNotEmpty)
            {
              String largeIconPath = await _downloadAndSaveFile(image.toString(), 'largeIcon');
              String bigPicturePath = await _downloadAndSaveFile(image.toString(), 'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
                  largeIcon: FilePathAndroidBitmap(largeIconPath),
                  contentTitle: title, //"<b>$title</b>"
                  htmlFormatContentTitle: true,
                  summaryText: messageData,
                  htmlFormatSummaryText: true);

              flutterLocalNotificationsPlugin.show(
                id.hashCode,
                title,
                messageData,
                NotificationDetails(
                    android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                        channelDescription: channel.description,
                        icon: payload,
                        playSound: true,
                        styleInformation: bigPictureStyleInformation,
                        importance: Importance.max,
                        priority: Priority.high),
                    iOS: iOSPlatformChannelSpecifics),
                payload: contentType,
              );
            }
            else
            {
              flutterLocalNotificationsPlugin.show(
                id.hashCode,
                title,
                messageData,
                NotificationDetails(
                    android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                        channelDescription: channel.description,
                        icon: payload,
                        playSound: true,
                        importance: Importance.max,
                        priority: Priority.high),
                    iOS: iOSPlatformChannelSpecifics),
                payload: contentType,
              );
            }
          }
          else
          {
            flutterLocalNotificationsPlugin.show(
              id.hashCode,
              title,
              messageData,
              payload: contentType,
              NotificationDetails(
                  android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                      channelDescription: channel.description,
                      icon: payload,
                      playSound: true,
                      importance: Importance.max,
                      priority: Priority.high),
                  iOS: iOSPlatformChannelSpecifics),
            );
          }*/

          flutterLocalNotificationsPlugin.show(
            id.hashCode,
            title,
            messageData,
            payload: contentType,
            NotificationDetails(
                android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                    channelDescription: channel.description,
                    icon: payload,
                    playSound: true,
                    importance: Importance.max,
                    styleInformation: BigTextStyleInformation(messageData),
                    priority: Priority.high),
                iOS: iOSPlatformChannelSpecifics),
          );
        }
        else
        {
          print("<><> CHECK DATA : " + " <><>");
        }
      },
    );

    var initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: (payload) {
      // This function handles the click in the notification when the app is in foreground
      // Get.toNamed(NOTIFICATIOINS_ROUTE);
      try {
        /*print('<><> TAP onMessage :' + payload.toString() + "  <><>");*/
        var contentType = payload.toString();
        openPage(contentType);
      } catch (e) {
        print(e);
      }
    });
    // onMessage is called when the app is in foreground and a notification is received
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      print('onMessage Notification Payload:${message?.notification!.toMap().toString()}');
      print('onMessage Data Payload:${message?.data.toString()}');
      RemoteNotification? notification = message?.notification;
      AndroidNotification? android = message?.notification?.android;
      AppleNotification? appleNotification = message?.notification?.apple;
      SessionManager sessionManager = SessionManager();
      var isLoggedIn = sessionManager.checkIsLoggedIn() ?? false;
      if (notification != null && isLoggedIn)
      {
        var id = "";
        var contentType = "";
        var image = "";
        var title = "";
        var messageData = "";

        message?.data.forEach((key, value) {
          if (key == "content_id") {
            id = value;
          }

          if (key == "content_type") {
            contentType = value;
          }

          if (key == "image") {
            image = value;
          }

          if (key == "title") {
            title = value;
          }

          if (key == "message") {
            messageData = value;
          }
        });

        NavigationService.notif_id = id;
        NavigationService.notif_type = contentType;
         print('<><> onMessage id--->$id');
        print('<><> onMessage contentType--->$contentType');
        print("<><> onMessage Image URL : $image <><>");
        const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(
            presentSound: true, presentAlert: true);
       /* if (image != null)
        {
            if(image.toString().isNotEmpty)
            {
              String largeIconPath = await _downloadAndSaveFile(image.toString(), 'largeIcon');
              String bigPicturePath = await _downloadAndSaveFile(image.toString(), 'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
                  largeIcon: FilePathAndroidBitmap(largeIconPath),
                  contentTitle: title, //"<b>$title</b>"
                  htmlFormatContentTitle: true,
                  summaryText: messageData,
                  htmlFormatSummaryText: true);

              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                messageData,
                NotificationDetails(
                    android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                        channelDescription: channel.description,
                        icon: android!.smallIcon,
                        playSound: true,
                        styleInformation: bigPictureStyleInformation,
                        importance: Importance.max,
                        priority: Priority.high),
                    iOS: iOSPlatformChannelSpecifics),
                    payload: contentType,
              );
            }
            else
            {
              flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                messageData,
                NotificationDetails(
                    android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                        channelDescription: channel.description,
                        icon: android!.smallIcon,
                        playSound: true,
                        importance: Importance.max,
                        priority: Priority.high),
                       iOS: iOSPlatformChannelSpecifics),
                     payload: contentType,
              );
            }
        }
        else
        {
            flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              messageData,
              payload: contentType,
              NotificationDetails(
                  android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                      channelDescription: channel.description,
                      icon: android!.smallIcon,
                      playSound: true,
                      importance: Importance.max,
                      priority: Priority.high),
                  iOS: iOSPlatformChannelSpecifics),
            );
        }*/

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          messageData,
          payload: contentType,
          NotificationDetails(
              android: AndroidNotificationDetails('Chicken Delight', 'Chicken Delight',
                  channelDescription: channel.description,
                  icon: android!.smallIcon,
                  playSound: true,
                  importance: Importance.max,
                  styleInformation: BigTextStyleInformation(messageData),
                  priority: Priority.high),
              iOS: iOSPlatformChannelSpecifics),
        );

      }
      else
      {
          print("<><> CHECK DATA : " + " <><>");
      }
      
    });
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true);
  }

  androidNotificationChannel() => const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound_tone.mp3'),
      );

  void openPage(String contentType) {
    NavigationService.notif_type = contentType;

    print("Is Going in side push");

    startActivity(NavigationService.navigatorKey.currentContext!, OrderDetailScreen(NavigationService.notif_id ?? '', false));

    /*Navigator.push(BuildContext,
        MaterialPageRoute(builder: (context) => OrderDetailScreen(NavigationService.notif_id ?? '', false))
    ).then((value) => print("value === $value")).onError((error, stackTrace) => print("error === $error"));*/
  }
}
