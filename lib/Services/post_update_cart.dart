import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';

class UpdateCartService {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');
    return loginToken ?? registerToken;
  }

  Future<List<ProdactModelsForCart>> fetchCartItems() async {
    final url = Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/cart');
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['data'];
      return productsJson
          .map((json) => ProdactModelsForCart.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<Map<String, dynamic>> updateProductCountInCart(
      int cartId, int newCount) async {
    final url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/cart/update-count/$cartId');
    final token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'cart_id': cartId.toString(), // تأكد من أن cartId هو الرقم الصحيح
      'count': newCount.toString(), // تأكد من أن newCount هو عدد صحيح وليس نص
    });

    print('Request URL: $url');
    print('Request Body: $body');
    print('Cart ID passed for update: $cartId');

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);

      print('Response Data: $responseData');

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(
          'Failed to update product count. Status code: ${response.statusCode}, Message: ${responseData['message']}',
        );
      }
    } catch (error) {
      if (error is http.Response) {
        final responseData = jsonDecode(error.body);
        throw Exception(
          'HTTP error occurred: Status code: ${error.statusCode}, Message: ${responseData['message']}',
        );
      } else {
        throw Exception('Error occurred: $error');
      }
    }
  }
}
