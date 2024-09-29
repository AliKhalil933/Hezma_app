import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hezmaa/models/model_login/prodact_model_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileServicepost {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    if (loginToken != null) {
      return loginToken;
    } else if (registerToken != null) {
      return registerToken;
    } else {
      throw Exception('No auth token found');
    }
  }

  Future<ProdactModelLoginAndRegister> updateProfile({
    required String name,
    required String phone,
    required String email,
    required String password,
    File? image,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/update_profile'),
    );

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = password;

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );
    }

    String? token = await _getAuthToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return ProdactModelLoginAndRegister.fromJson(jsonData['data']);
    } else {
      throw Exception('فشل في تحديث الملف الشخصي: ${response.reasonPhrase}');
    }
  }
}
