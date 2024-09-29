import 'package:flutter/material.dart';
import 'package:hezmaa/Services/post_forgetPassword.dart';
import 'package:hezmaa/helper/constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(PhoneNumber number) {
    setState(() {
      if (number.completeNumber.isEmpty) {
        _errorMessage = 'يرجى إدخال رقم الجوال';
      } else {
        _errorMessage = null;
      }
    });
  }

  Future<void> _handleSubmit() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _errorMessage = 'يرجى إدخال رقم الجوال';
      });
      return;
    }

    final productModelServesPassword = ProductModelServesPassword();
    try {
      await productModelServesPassword.forgetPassword(phoneNumber);
      // Show a success message or navigate to another page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال طلب إعادة تعيين كلمة السر.')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في إرسال الطلب. يرجى المحاولة مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('نسيت كلمة السر'),
        backgroundColor: const Color(backgroundcolor2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            IntlPhoneField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الجوال',
                errorText: _errorMessage,
              ),
              initialCountryCode: 'SA',
              onChanged: _validatePhoneNumber,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }
}
