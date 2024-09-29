import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// نموذج استجابة للتخفيض
class DecrementResponse {
  final bool status;
  final String message;

  DecrementResponse({required this.status, required this.message});

  factory DecrementResponse.fromJson(Map<String, dynamic> json) {
    return DecrementResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error',
    );
  }
}

class DecrementService {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    return loginToken ?? registerToken;
  }

  Future<DecrementResponse> decrementProductCountInCart(int productId) async {
    final url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/cart/sub-product-count');
    String? token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      "product_id": productId.toString(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return DecrementResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(
            'Failed to decrement product count in cart: ${responseData['message']}');
      }
    } catch (error) {
      throw Exception('Error occurred: $error');
    }
  }
}
