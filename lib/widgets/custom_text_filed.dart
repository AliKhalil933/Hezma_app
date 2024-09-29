import 'package:flutter/material.dart';

class customTexetFiled extends StatelessWidget {
  customTexetFiled({super.key, required this.text, required this.icon});
  String text;
  var icon;
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: text,
        hintStyle: const TextStyle(fontFamily: 'STVBold'),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(221, 10, 4, 4)),
            borderRadius: BorderRadius.circular(25)),
      ),
    );
  }
}
