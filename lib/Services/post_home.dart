import 'dart:convert';
import 'package:hezmaa/home/home/home.dart';
import 'package:http/http.dart' as http;

Future<Home?> fetchHomeData() async {
  final url = 'https://hezma-traning.eltamiuz.net/api/v1/home?page=1';
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'category_id': 3,
    'car_model_year': 2016,
    'price_min': 1,
    'price_max': 1000,
    'search': 'مستعمله',
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Home.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}
