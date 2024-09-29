import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? prefs.getString('register_token');
  }

  Future<Map<String, dynamic>?> getOrders() async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token is not available');
    }

    final url = 'https://hezma-traning.eltamiuz.net/api/v1/orders';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (!data.containsKey('status') || !data.containsKey('data')) {
          throw Exception('Invalid response format');
        }
        return data; // إرجاع الاستجابة كاملة
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error in getOrders: $e');
      rethrow;
    }
  }
}
