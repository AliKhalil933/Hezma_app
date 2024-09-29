import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddProductService {
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

  Future<void> addProductToCart(
      int productId, int count, double totalPrice) async {
    final url =
        Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/cart/add-product');
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
      "product_id": productId.toString(),
      "count": count.toString(),
      "total_price": totalPrice.toString(),
      "details": [
        {
          "main_sector_id": "3",
          "sector_type_id": "4",
          "name": "Detail 1",
          "price": "10"
        },
        {
          "main_sector_id": "3",
          "sector_type_id": "4",
          "name": "Detail 2",
          "price": "20"
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response status: ${responseData['status']}');
        print('Response message: ${responseData['message']}');
      } else {
        print(
            'Failed to add product to cart. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }
}
