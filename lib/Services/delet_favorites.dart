import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesServesDelete {
  Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token =
        prefs.getString('authToken') ?? prefs.getString('register_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final Uri url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/favorites/$productId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Sending the token in the header
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        print('Favorite removed successfully');
      } else {
        throw Exception('Failed to remove favorite: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to remove favorite. Status code: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
