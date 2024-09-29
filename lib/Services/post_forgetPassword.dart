import 'dart:convert';
import 'package:hezmaa/models/prodect_of_prodects/prodect_forgetPasswoed.dart';
import 'package:http/http.dart' as http;

class ProductModelServesPassword {
  final String _baseUrl = 'https://hezma-traning.eltamiuz.net/api/v1';
  final String _token = '92|dTHdJvXL1CGxeXSkZLXjDCVTB8tZJo21gI0G7Llha0c1b3fc';

  Future<ForgetPasswordResponse> forgetPassword(String phoneNumber) async {
    final url = Uri.parse('$_baseUrl/forget_password');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      return ForgetPasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to send forget password request');
    }
  }
}
