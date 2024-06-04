import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:chicken_delight/utils/session_manager.dart';
import 'package:chicken_delight/utils/session_manager_methods.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:url_launcher/url_launcher.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';

import 'package:path_provider/path_provider.dart';

Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) { // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // Unique ID on Android
  }
}

String greetUser() {
  final currentTime = DateTime.now();
  final hour = currentTime.hour;
  if (hour < 12)
    {
      return 'morning!';
    }
  else if (hour < 17)
    {
      return 'afternoon!';
    }
  else
    {
      return 'evening!';
    }
}

void invalidTokenRedirection(BuildContext? context){
  // showSnackBar('Access Token is expired please login again', context);
  // SessionManagerMethods.clear();
 // Navigator.of(context!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginWithEmpCodeScreen()), (Route<dynamic> route) => false);
}

/*show message to user*/
showSnackBar(String? message,BuildContext? context) {
  try {
    return ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message!),
          duration: const Duration(seconds: 1),
        ),
      );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

void noInternetSnackBar(BuildContext? context){
  showToast("Please check your Network Connection", context);
}

showToast(String? message,BuildContext? context){
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: brandDarkColor,
      textColor: white,
      fontSize: 16.0
  );
}

checkValidString (String? value) {
  if (value == null || value == "null" || value == "<null>")
  {
    value = "";
  }
  return value.trim();
}

/*check email validation*/
bool isValidEmail(String? input) {
  try {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input!);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}

isValidPhoneNumber(String? input)
{
  try {
    return RegExp(r'^\+?[0-9\s\(\)-]+$').hasMatch(input!);
  } catch (e) {
    if(kDebugMode){

      print(e);
    }
    return false;
  }
}

/*convert string to CamelCase*/
toDisplayCase (String str) {
  print("str === $str");

  if(checkValidString(str).toString().isNotEmpty)
    {
      try {
        return str.toLowerCase().split(' ').map((word) {
          String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
          return word[0].toUpperCase() + leftText;
        }).join(' ');
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  else
    {
      return "";
    }
}

startActivityAnimation(BuildContext context, Widget screen){
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, a1, a2) {
        return screen;
      },
      transitionsBuilder: (context, a1, a2, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: a1.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    ),
  );
}

startActivityAnimationRemove(BuildContext context, Widget screen){
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, a1, a2) {
        return screen;
      },
      transitionsBuilder: (context, a1, a2, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: a1.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    ), (route) => false);
}

startAndRemoveActivity(BuildContext context, Widget screen){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => screen),(route) => false,);
}

startActivity(BuildContext context, Widget screen){
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

/*generate hex color into material color*/
MaterialColor createMaterialColor(Color color) {
  try {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return const MaterialColor(0xFFFFFFFF, <int, Color>{});
  }
}

getRandomCartSession () {
  try {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(8, (index) => _chars[r.nextInt(_chars.length)]).join();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

String universalDateConverter(String inputDateFormat,String outputDateFormat, String date) {
  var outputDate = "";
  try {
    var inputFormat = DateFormat(inputDateFormat);
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat(outputDateFormat);
    outputDate = outputFormat.format(inputDate);
    print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format
  } catch (e)
  {
    print(e);
  }
  return outputDate;
}

String getPrice(String str) {
  return "₹ $str";
}

String getPriceComma(String text) {
  if(text.isNotEmpty)
  {
    try {
      var formatter = NumberFormat("#,##,##0", "en_US"); //'#,##,###0.00', "en_US"
      return "₹ ${formatter.format(double.parse(text))}";
    } catch (e) {
      return "₹ $text";
    }
  }
  else
  {
    return "₹ $text";
  }
}

 void showLoadingToast(BuildContext activity)
{
  showToast("Loading Please Wait...",activity);
}

bool validateDateRange(String startDate, String endDate) {
  DateFormat dfDate = DateFormat("dd MMM,yyyy");
  bool b = false;

  try {
    try {
      if (dfDate.parse(startDate).isBefore(dfDate.parse(endDate))) {
        b = true; // If start date is before end date.
      } else if (dfDate.parse(startDate).compareTo(dfDate.parse(endDate)) == 0) {
        b = true; // If two dates are equal.
      } else {
        b = false; // If start date is after the end date.
      }
    } on FormatException catch (e) {
      print(e);
    }
  } on FormatException catch (e) {
    print(e);
  }

  return b;
}

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('HH:mm a');
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = '${diff.inDays}DAY AGO';
    } else {
      time = '${diff.inDays}DAYS AGO';
    }
  }

  return time;
}

int getTimeStampFromDate (String value,String dateFormat) {
  int timestamp = 0;
  if(value.isNotEmpty)
  {
    DateTime datetime = DateFormat(dateFormat).parse(value);
    timestamp = datetime.millisecondsSinceEpoch ~/ 1000;
  }

  return timestamp;
}

int currentTimeInSec() {
  final totalMicroseconds = DateTime.now().microsecondsSinceEpoch;
  return totalMicroseconds ~/ (1000 * 1000);
}

String convertTimetoDateTimestamp(String timestamp, String format) {
  print(timestamp);
  var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  String fdatetime = DateFormat(format).format(date);
  print(fdatetime);

  return fdatetime;
}

String getDateFromTimestamp(String timeStamp){
  int timestamp = int.parse(timeStamp); // example timestamp
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000); // convert timestamp to DateTime object

  String formattedDate = DateFormat('dd MMM, yyyy').format(date); // format DateTime object to desired date format

  print(formattedDate); // output: 2022-03-09
  return formattedDate;
}

String removeLastComma(String str) {
  if (str.isEmpty) {
    return '';
  } else {
    if (str != null && str.isNotEmpty && str[str.length - 1] == ',') {
      str = str.substring(0, str.length - 1);
    }
    return str;
  }
}

Future<void> writeLogToFile(String logData) async {
  // Get the directory for storing files
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  // Define the file path

}


/*Future<void> storeJsonResponse(String response, String filenameTemp) async {

  String TAG = "Unison Logs : ";

  FlutterLogs.logThis(
      tag: 'Unison Pan India',
      subTag: filenameTemp,
      logMessage:response,
      level: LogLevel.INFO
  );

  FlutterLogs.exportLogs(
      exportType: ExportType.ALL);

  FlutterLogs.channel.setMethodCallHandler((call) async {
    if (call.method == 'logsExported') {
      var zipName = "${call.arguments.toString()}";

      Directory? externalDirectory;

      if (Platform.isIOS) {
        externalDirectory = await getApplicationDocumentsDirectory();
      } else {
        externalDirectory = await getLibraryDirectory();
      }

      FlutterLogs.logInfo(TAG, "found", 'External Storage:$externalDirectory');

      File file = File("${externalDirectory?.path}/$zipName");

      FlutterLogs.logInfo(
          TAG, "path", 'Path: \n${file.path.toString()}');

      if (file.existsSync()) {
        FlutterLogs.logInfo(
            TAG, "existsSync", 'Logs found and ready to export!');
      } else {
        FlutterLogs.logError(
            TAG, "existsSync", "File not found in storage.");
      }

    } else if (call.method == 'logsPrinted') {
      //TODO Get results of logs print here

      FlutterLogs.logThis(
          tag: 'Unison Pan India',
          subTag: filenameTemp,
          logMessage:response,
          level: LogLevel.INFO);
    }
  });

  // Write to the file
 *//* File logFile = File(logFilePath ?? '');

  print("logFile ==== ${logFile.path}");

  await logFile.writeAsString(response, mode: FileMode.write);

  File file = File('${logFile.path}/$fileName');*//**//*

  try {
    if (await file.exists()) {
      print("File already exists: ${file.path}");
      return;
    }
    await file.writeAsString(response);
    print("File created: ${file.path}");
  } catch (e) {
    print("Failed to create file: $e");
  }*//*
  print("Store Response: Successfully Stored.");
}*/

void storeJsonResponse(String response, String filenameTemp) async {
  try {

    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }

    print("status.isGranted ===== ${status.isGranted}");
    print("status.isDenied ===== ${status.isDenied}");
    print("status.isPermanentlyDenied ===== ${status.isPermanentlyDenied}");

    String folderName = "Unison";
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    // String fileName = '$filename$time.txt';
    String fileName = "${filenameTemp}_$time.txt";
    print("File Name: $fileName");

    Directory appDocDir = await getDownloadsDirectory() ??Directory('');

    String folderPath = '${appDocDir.absolute.path}/$folderName';
    Directory folder = Directory(folderPath);

    if (!await folder.exists()) {
      folder = await folder.create(recursive: true);
      print("Folder created: ${folder.path}");
    }

    File file = File('${folder.path}/$fileName');

    try {
      if (await file.exists()) {
        print("File already exists: ${file.path}");
        return;
      }
      await file.writeAsString(response);
      print("File created: ${file.path}");
    } catch (e) {
      print("Failed to create file: $e");
    }
    print("Store Response: Successfully Stored.");
  } catch (e) {
    print("Failed to store response: $e");
  }
}

String getInitials({required String string, required int limitTo}) {
  var returnString = '';

  if (string.isNotEmpty)
    {
      var buffer = StringBuffer();
      var split = string.split(' ');
      for (var i = 0; i < (limitTo ?? split.length); i++) {
        buffer.write(split[i][0]);
      }
      returnString = buffer.toString();
    }

  return returnString;
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Future<void> sendEmail(String email) async {
  String mail = "mailto:$email?subject=&body=${Uri.encodeFull("")}";
  if (await canLaunchUrl(Uri.parse(mail)))
  {
    await launchUrl(Uri.parse(mail));
  }
  else
  {
    throw Exception("Unable to open the email");
  }
}

void onOpenMailClicked(String email) async {
  try {
    await sendEmail(email);
  } catch (e) {
    debugPrint("sendEmail failed $e");
  }
}

void launchPhoneURL(String phoneNumber) async {
  String url = 'tel:$phoneNumber';

  if (await canLaunchUrl(Uri.parse(url)))
  {
    await launchUrl(Uri.parse(url));
  }
  else
  {
    throw 'Could not launch $url';
  }
}

void logoutFromApp(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: white,
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
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor))),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10, bottom: 15, left: 12),
                  child: const Text('Are you sure want to Logout?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: black)),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, bottom: 12, top: 10),
                  child: Row(
                    children: [
                      Expanded(
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
                                },
                                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: primaryColor)),
                              ))),
                      const Gap(15),
                      Expanded(
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
                            onPressed: () async {
                              Navigator.pop(context);
                              // SessionManagerMethods.clear();
                              await SessionManagerMethods.init();
                              var sessionManager = SessionManager();
                              // sessionManager.setIsDeviceRegistered(true);
                           //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginWithEmpCodeScreen()), (Route<dynamic> route) => false);
                            },
                            child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: primaryColor)),
                          ),
                        ),
                      ),
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
  );
}

void otherDeviceMsg(BuildContext context,String msg) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: white,
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
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: const Text('Access Denied', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryColor))),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10, bottom: 15, left: 12),
                  child: Text(msg, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: black)),
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
                                },
                                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: primaryColor)),
                              )),
                      ),
                      Expanded(flex: 1, child: Container())
                    ],
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showToast("Your request has been sent successfully you will get notified once done.", context);
                    // startAndRemoveActivity(context, const LoginWithOtpScreen());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 0, bottom: 15, left: 12),
                    child: const Text("Do you want to change your current device?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: primaryColor),textAlign: TextAlign.center,),
                  ),
                ),
                const Gap(30)
              ],
            ),
          ),
        ],
      );
    },
  );
}

String getTodayDate(){
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  print(formattedDate); // 2024-04-22
  return formattedDate;
}

int getCurrentMonth() {
  return DateTime.now().month;
}

int getCurrentYear() {
  return DateTime.now().year;
}

