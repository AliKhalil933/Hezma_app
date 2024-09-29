import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesServesPost {
  Future<void> addFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token =
        prefs.getString('authToken') ?? prefs.getString('register_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    final Uri url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/favorites/$productId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Sending the token in the header
      },
      body: jsonEncode({
        'product_id': productId,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        print('Favorite added successfully');
      } else {
        throw Exception('Failed to add favorite: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to add favorite. Status code: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
