import 'package:flutter/material.dart';
import '../constant/colors.dart';

class MyNoDataNewWidget extends StatelessWidget {
  final String msg;
  final String titleMSG;
  final String icon;

  const MyNoDataNewWidget({Key? key, required this.msg,required this.icon,required this.titleMSG}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22)
        ),
        width: 330,
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(52),
                ),
                child: Image.asset(icon, width: 28, height: 28,color: black)
            ),
            Container(height: 22),
            Text(
              titleMSG,
              style: const TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            Container(height: 12),
            Text(
              msg,
              style: const TextStyle(
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class MyNoDataWidget extends StatelessWidget {
  final String msg;
  final String titleMSG;

  const MyNoDataWidget({Key? key, required this.msg,required this.titleMSG}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 100),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22)
        ),
        width: 330,
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleMSG,
              style: const TextStyle(
                  color: black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,
            ),
            Container(height: 12),
            Text(
              msg,
              style: const TextStyle(
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
