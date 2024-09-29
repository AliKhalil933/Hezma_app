import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hezmaa/models/districts/model_of_distractis.dart';

class DistrictService {
  final String apiUrl = "https://hezma-traning.eltamiuz.net/api/v1/districts";

  Future<List<modelOfDistractis>> fetchDistricts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        List<dynamic> body = jsonResponse['data'];
        List<modelOfDistractis> districts = body
            .map((dynamic item) => modelOfDistractis.fromJson(item))
            .toList();
        return districts;
      } else {
        throw Exception('Failed to load districts');
      }
    } else {
      throw Exception('Failed to load districts');
    }
  }
}
