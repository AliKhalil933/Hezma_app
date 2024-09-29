import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hezmaa/helper/constants.dart';

// ignore: must_be_immutable
class CustomButon extends StatelessWidget {
  CustomButon({super.key, this.onTap, required this.text, required this.color});
  VoidCallback? onTap;
  String text;
  Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(backgroundcolor2),
            )),
        width: 100,
        height: 35,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontFamily: 'STVBold'),
          ),
        ),
      ),
    );
  }
}
