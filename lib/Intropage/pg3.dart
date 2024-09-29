import 'package:flutter/material.dart';
import 'package:hezmaa/helper/constants.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: const Alignment(0.5, -0.6),
            child: Image.asset(kimgPg3),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset(kUnion),
          ),
          Container(
            alignment: const Alignment(0.0, 0.4), // تعديل موضع النص قبل الأخير
            child: Image.asset(ktext1Pg3),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 5, left: 5),
            child: Container(
              alignment: const Alignment(0.0, 0.6), // تعديل موضع النص الأخير
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      ktxt2Pg1,
                      style: TextStyle(
                          color: Color(
                            backgroundcolor1,
                          ), // تأكد من أن backgroundcolor1 معرف بشكل صحيح
                          fontSize: 16,
                          fontFamily: 'STVBold'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              alignment: const Alignment(0.0, 0.6),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
