import 'package:hezmaa/helper/api.dart';
import 'package:hezmaa/models/prodect_of_prodects/prodect_model_forcard.dart';

class ProdectService {
  Future<List<ProdectModel>> getProdects() async {
    try {
      final response = await Api()
          .get(url: 'https://hezma-traning.eltamiuz.net/api/v1/products');

      if (response is Map<String, dynamic>) {
        final List<dynamic>? productDataList = response['data'];

        if (productDataList == null || productDataList.isEmpty) {
          return [];
        }

        return productDataList.map((json) {
          return ProdectModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<List<ProdectModel>> getFavoriteProducts() async {
    try {
      final response = await Api()
          .get(url: 'https://hezma-traning.eltamiuz.net/api/v1/favorites');

      if (response is Map<String, dynamic>) {
        final List<dynamic>? productDataList = response['data'];

        if (productDataList == null || productDataList.isEmpty) {
          return [];
        }

        return productDataList.map((json) {
          return ProdectModel.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching favorite products: $e');
      return [];
    }
  }
}
