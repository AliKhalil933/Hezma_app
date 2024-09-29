import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hezmaa/models/orderDetales/order_detales/ModelOfCartDedails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDtailesServes {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? prefs.getString('register_token');
  }

  Future<ModelcartDetails> getOrderDetails(int orderId) async {
    String? token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token is not available');
    }

    final url =
        'https://hezma-traning.eltamiuz.net/api/v1/order/details/$orderId';
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
        final data = json.decode(response.body);

        // Ensure 'data' is present in the response
        if (data is! Map<String, dynamic> || !data.containsKey('data')) {
          throw Exception('Invalid response format: ${response.body}');
        }

        final orderData = data['data'] as Map<String, dynamic>;
        return ModelcartDetails.fromJson(orderData);
      } else {
        // Handle non-200 responses with detailed error messages
        print('Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'Failed to load order details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getOrderDetails: $e');
      rethrow;
    }
  }
}
