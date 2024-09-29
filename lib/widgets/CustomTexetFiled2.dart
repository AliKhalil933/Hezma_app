import 'package:flutter/material.dart';

class CustomTexetFiled2 extends StatelessWidget {
  final String text;
  final Icon? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType
      keyboardType; // إضافة هذه الخاصية لتحديد نوع لوحة المفاتيح

  CustomTexetFiled2({
    super.key,
    required this.text,
    this.icon,
    this.controller,
    this.validator,
    required this.obscureText,
    this.keyboardType = TextInputType.text, // تحديد القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.right,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType, // استخدام خاصية keyboardType
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: text,
        hintStyle: TextStyle(fontFamily: 'STVBold'),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(221, 10, 4, 4)),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
