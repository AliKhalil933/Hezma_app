import 'package:hezmaa/helper/api.dart';
import 'package:hezmaa/models/category/prodactofCategoryModel.dart';
import 'package:hezmaa/prodect/get_cart/prodact_of_carts.dart';

class categoryServeces {
  Future<List<prodactofCategory>> getcategory() async {
    try {
      final response = await Api()
          .get(url: 'https://hezma-traning.eltamiuz.net/api/v1/categories');
      print('Response: $response'); // Debugging line

      if (response is Map<String, dynamic>) {
        final List<dynamic>? categoryDatalist = response['data'];

        if (categoryDatalist == null || categoryDatalist.isEmpty) {
          return [];
        }

        return categoryDatalist.map((json) {
          return prodactofCategory.fromJson(json as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
