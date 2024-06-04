import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../constant/colors.dart';

class MyNoDataWidget extends StatelessWidget {
  final String msg;
  final String imageName;
  final Color colorCode;
  final String subMsg;
  final void Function() onTap;
  final String btnTitle;

  const MyNoDataWidget({Key? key, required this.msg, required this.imageName, required this.colorCode, required this.subMsg, required this.onTap, required this.btnTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kNoDataViewCornerRadius))),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 22.0, bottom: 22, left: 40, right: 40),
                          child: Image.asset("assets/images/$imageName", width: 60,height: 60, color: black,),
                        )
                    ),
                    const Gap(6),
                    Text(msg, style: const TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.bold,),),
                    const Gap(6),
                    Text(subMsg, style: const TextStyle(color: black, fontSize: 18, fontWeight: FontWeight.w500,), textAlign: TextAlign.center,)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, left: 50, right: 50),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: primaryColor, backgroundColor: primaryColor,
                    elevation: 0.0,
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    side: const BorderSide(color: primaryColor, width: 0.5, style: BorderStyle.solid),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kButtonCornerRadius)),
                    tapTargetSize: MaterialTapTargetSize.padded,
                    animationDuration: const Duration(milliseconds: 100),
                    enableFeedback: true,
                    alignment: Alignment.center,
                  ),
                  onPressed: onTap,
                  child: Text(btnTitle, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        )
    );
  }
}
