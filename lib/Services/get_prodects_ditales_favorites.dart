import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class ProdectServiceDitels {
  final String _baseUrl = 'https://hezma-traning.eltamiuz.net/api/v1/favorites';
  final String _authToken =
      '92|dTHdJvXL1CGxeXSkZLXjDCVTB8tZJo21gI0G7Llha0c1b3fc';

  Future<List<ProdectModel>> getFavoriteProducts() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final productsJson = data['data'] as List;
      return productsJson.map((json) => ProdectModel.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load favorite products. Status code: ${response.statusCode}');
    }
  }

  Future<void> addProdectToFavorites(int productId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$productId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add product to favorites. Status code: ${response.statusCode}');
    }
  }

  Future<void> removeProdectFromFavorites(int productId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$productId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to remove product from favorites. Status code: ${response.statusCode}');
    }
  }
}
