import 'package:flutter/material.dart';

import '../constant/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          alignment: Alignment.center,
          height: 100,
          child: Column(
            children: [
              Expanded(child: Stack(
                children: [
                  Center(child: Image.asset('assets/images/ic_chicken_logo.png', height: 32, width: 32,fit : BoxFit.fitWidth,alignment: Alignment.center)),
                  const Center(
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(color: primaryColor, strokeWidth: 1.5)),
                  ),
                ],
              )),
              const Center(
                  child: Text("Please wait a moment...",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: primaryColor))
              )
            ],
          ),
        ));
  }
}
