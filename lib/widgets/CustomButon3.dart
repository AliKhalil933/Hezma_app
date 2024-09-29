import 'package:flutter/material.dart';
import 'package:hezmaa/helper/constants.dart';

class CustomButon3 extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;

  const CustomButon3({
    super.key,
    this.onTap,
    required this.text,
    required this.color,
  });

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
          ),
        ),
        width: 380,
        height: 60,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'STVBold',
            ),
          ),
        ),
      ),
    );
  }
}
