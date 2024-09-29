import 'dart:convert';
import 'package:hezmaa/models/model_login/prodact_model_login.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ProfileServiceget {
  Future<ProdactModelLoginAndRegister> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token =
        prefs.getString('authToken') ?? prefs.getString('register_token');

    if (token == null) throw Exception('No auth token found');

    final response = await http.get(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/get_profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        return ProdactModelLoginAndRegister.fromJson(data['data']);
      } else {
        throw Exception('Failed to load profile: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
