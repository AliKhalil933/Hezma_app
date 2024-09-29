import 'package:flutter/material.dart';
import 'package:hezmaa/helper/constants.dart';

class CustomButon2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;

  const CustomButon2({
    Key? key,
    required this.text,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make button take full width
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(backgroundcolor2)),
          ),
        ),
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
    );
  }
}
