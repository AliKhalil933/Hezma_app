import 'dart:convert';
import 'package:hezmaa/models/model_login/prodact_model_login.dart';
import 'package:http/http.dart' as http;

class ProdectServiceslogin {
  Future<ProdactModelLoginAndRegister> loginuser({
    required String emailOrPhone,
    required String password,
    required bool isEmail,
  }) async {
    final response = await http.post(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': isEmail ? null : emailOrPhone,
        'login_by': isEmail ? 'email' : 'phone',
        'email': isEmail ? emailOrPhone : null,
        'password': password,
        'fcm': 'your_fcm_token',
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['data'] != null) {
        return ProdactModelLoginAndRegister.fromJson(data['data']);
      } else {
        throw Exception('No user data found in response');
      }
    } else if (response.statusCode == 422) {
      final data = jsonDecode(response.body);
      throw Exception('Validation error: ${data['errors']}');
    } else {
      throw Exception(
          'Failed to login user. Status code: ${response.statusCode}');
    }
  }
}
