import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';

Widget getBackArrow() {
  return Container(
    alignment: Alignment.centerLeft,
    margin: const EdgeInsets.only(top: 4,bottom: 4),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Image.asset('assets/images/ic_back_white.png', width: 22, height: 22,color: black,),
    ),
  );
}

Widget getBackArrowBlack() {
  return Container(
    alignment: Alignment.center,
    child: Image.asset('assets/images/ic_back_white.png', color: black, height: 28, width: 28),
  );
}

Widget getTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: getAppBarTitleStyle(),
  );
}

PreferredSizeWidget getMyAppBar(BuildContext context,{String title = '', bool isLeadingVisible = true}) {
  return AppBar(
    backgroundColor: appBG,
    titleSpacing: 0,
    centerTitle: true,
    leading: isLeadingVisible ? GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
      },
      child: getBackArrow(),
    ) : null,
    title: getTitle(title),
    toolbarHeight: kToolbarHeight,
    automaticallyImplyLeading: false,
  );
}

BoxDecoration getCommonCard() {
  return BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), //color of shadow
        spreadRadius: 2, //spread radius
        blurRadius: 4, // blur radius
        offset: const Offset(0, 2), // changes position of shadow
      )
    ],
  );
}

Widget getCommonButton(String title, Color backgroundColor, bool isLoading, void Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: const BorderSide(color: white,width: 0.6)
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
    ),
    child: isLoading
        ? const Padding(
          padding: EdgeInsets.only(top: 8,bottom: 8),
          child: SizedBox(width: 16,height: 16,child: CircularProgressIndicator(color: white,strokeWidth: 2)),
        )
        : Padding(
          padding: const EdgeInsets.only(top: 5,bottom: 5,),
          child: Text(title,
            style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w500, color: white,),
          ),
        ),
  );
}

Widget getCommonButtonWhite(String title, bool isLoading, void Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(white),
    ),
    child: isLoading
        ? const Padding(
      padding: EdgeInsets.only(top: 8,bottom: 8),
      child: SizedBox(width: 16,height: 16,child: CircularProgressIndicator(color: primaryColor,strokeWidth: 2)),
    )
        : Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w500, color: primaryColor,),
      ),
    ),
  );
}

Widget getCommonButtonWithoutFill(String title, bool isLoading, void Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0),
          side:  const BorderSide(color: black),),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(white),
    ),
    child: isLoading
        ? const Padding(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child: SizedBox(width: 16,height: 16,child: CircularProgressIndicator(color: primaryColor,strokeWidth: 2)),
    )
        : Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 6, left: 12, right: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w500, color:black, ),
      ),
    ),
  );
}

Widget getSmallButtonWithoutFill(String title, bool isLoading, void Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0),
          side: const BorderSide(color: black),),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(white),
    ),
    child: isLoading
        ? const Padding(
      padding: EdgeInsets.only(top: 8,bottom: 8),
      child: SizedBox(width: 10,height: 10,child: CircularProgressIndicator(color: black,strokeWidth: 2)),
    )
        : Text(
      title,
      style: TextStyle(fontSize: description, fontWeight: FontWeight.w500, color:black,),
    ),
  );
}

double largeFont = 28;
double titleFont = 22;
double medium = 18;
double subTitle = 16;
double description = 14;
double small = 12;


Widget getCommonButtonLoad(String title, bool _isLoading, void Function() onPressed){
  return TextButton(
    onPressed: onPressed,
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(black),
    ),
    child: _isLoading
        ? const Padding(
      padding: EdgeInsets.only(top: 8,bottom: 8),
      child: SizedBox(width: 16,height: 16,child: CircularProgressIndicator(color: white,strokeWidth: 2)),
    )
        : Padding(
      padding: const EdgeInsets.only(top: 5,bottom: 5),
      child: Text(
        title,
        style: TextStyle(fontSize: subTitle, fontWeight: FontWeight.w500, color: white,),
      ),
    ),
  );
}
