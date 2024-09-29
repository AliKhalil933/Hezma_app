import 'dart:convert';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProdectServiceDitels {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? prefs.getString('register_token');
  }

  Future<List<ProdactModelsForCart>> getProdects() async {
    String? token = await _getAuthToken();
    final response = await http.get(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/cart'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> productsJson = data['data'];
      print('Fetched cart items: $productsJson'); // Debug print
      return productsJson
          .map((json) => ProdactModelsForCart.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load products');
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
      'cart_id': cartId.toString(),
      'count': newCount.toString(), // Ensure newCount is sent as a string
    });

    print('Request URL: $url');
    print('Request Body: $body');

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
