import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProdectServiceDetailsLogout {
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    String? token;
    if (loginToken != null) {
      token = loginToken;
    } else if (registerToken != null) {
      token = registerToken;
    } else {
      throw Exception('No auth token found');
    }

    final response = await http.post(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/logout'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (loginToken != null) {
        await prefs.remove('login_token');
      } else if (registerToken != null) {
        await prefs.remove('register_token');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid token');
    } else {
      throw Exception(
          'Failed to logout user. Status code: ${response.statusCode}');
    }
  }
}
