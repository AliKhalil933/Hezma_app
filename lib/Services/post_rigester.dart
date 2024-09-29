import 'dart:convert';
import 'package:hezmaa/models/model_login/prodact_model_login.dart';
import 'package:http/http.dart' as http;

class ProdectServiceDitelsRigester {
  Future<ProdactModelLoginAndRegister> registerUser({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String fcm,
  }) async {
    final response = await http.post(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'fcm': fcm,
      }),
    );

    try {
      if (response.statusCode == 200) {
        final String responseBody = response.body;

        final Map<String, dynamic> data = jsonDecode(responseBody);

        final token = data['token'] as String?;

        final userData = data['data'];
        if (userData != null) {
          return ProdactModelLoginAndRegister.fromJson(userData)..token = token;
        } else {
          throw Exception('No user data found in response');
        }
      } else if (response.statusCode == 422) {
        final String responseBody = response.body;
        final data = jsonDecode(responseBody);
        throw Exception('Validation error: ${data['errors']}');
      } else {
        throw Exception(
            'Failed to register user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error parsing response: $e');
    }
  }
}
