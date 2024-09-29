import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeletProdectCartService {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    if (loginToken != null) {
      return loginToken;
    } else if (registerToken != null) {
      return registerToken;
    } else {
      return null;
    }
  }

  Future<void> deleteProductFromCart(int cartId) async {
    final url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/cart/delete-product/$cartId');
    String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      "cart_id": cartId.toString(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response status: ${responseData['status']}');
        print('Response message: ${responseData['message']}');
      } else {
        final responseData = jsonDecode(response.body);
        print(
            'Failed to delete product from cart. Status code: ${response.statusCode}');
        print('Response message: ${responseData['message']}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }
}
