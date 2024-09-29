import 'package:flutter/material.dart';

class CustomTexetFiled3 extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;

  CustomTexetFiled3({
    super.key,
    required this.text,
    this.controller,
    this.validator,
    required this.obscureText,
    this.keyboardType = TextInputType.text,
    required Null Function() onTapIcon,
    required bool isPasswordVisible,
  });

  @override
  _CustomTexetFiled3State createState() => _CustomTexetFiled3State();
}

class _CustomTexetFiled3State extends State<CustomTexetFiled3> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.obscureText; // عكس الحالة الأولية
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.right,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.obscureText &&
          !_isPasswordVisible, // عكس حالة رؤية كلمة المرور
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        hintText: widget.text,
        hintStyle: TextStyle(fontFamily: 'STVBold'),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(221, 10, 4, 4)),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
