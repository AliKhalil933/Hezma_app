import 'package:flutter/material.dart';
import 'package:hezmaa/helper/constants.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0.5, -0.6),
            child: Image.asset(kimgPg1),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(kUnion),
          ),
          Align(
            alignment: const Alignment(0.0, 0.4),
            child: Image.asset(ktext1Pg1),
          ),
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 150, left: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'يعمل الخضار على صحة الإنسان، وتخلصه من مرض السكري وخاصة انواع السكري الثاني بالاضافة الي انها لها دور فعال في الحفاظ علي صحة الانسان',
                style: TextStyle(
                    color: Color(
                      backgroundcolor1,
                    ),
                    fontSize: 16,
                    fontFamily: 'STVBold'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
