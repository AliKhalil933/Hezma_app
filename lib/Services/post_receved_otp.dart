import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpServicesReceived {
  Future<Map<String, dynamic>> verifyOtp(String otp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('register_token');
      if (token == null) {
        return {'error': 'Token not found'};
      }

      final url =
          Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/received_otp');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'otp': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        return {'error': data['message']};
      }
    } catch (e) {
      return {'error': 'Error: $e'};
    }
  }
}
