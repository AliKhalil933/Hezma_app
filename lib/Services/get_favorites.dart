import 'dart:convert';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesServesGet {
  Future<List<ProdectModel>> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token =
        prefs.getString('authToken') ?? prefs.getString('register_token');

    if (token == null) {
      throw Exception('No auth token found');
    }

    // Send GET request with token in header
    final response = await http.get(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/favorites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Check response status
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        // Ensure 'data' is a list of favorite products
        final List<dynamic> favoritesJson = data['data'];
        return favoritesJson
            .map((json) => ProdectModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load favorites: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to load favorites. Status code: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
