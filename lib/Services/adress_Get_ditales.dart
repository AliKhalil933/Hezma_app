import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:http/http.dart' as http;

class AdressGetServes {
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<List<modelofAdress>> getProdects() async {
    String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/address'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print('Decoded Data: ${data['data']}');

        if (data['data'] != null && data['data'].isNotEmpty) {
          final List<dynamic> addressesJson = data['data'];
          print('Address List Length: ${addressesJson.length}');

          try {
            return addressesJson
                .map((json) => modelofAdress.fromJson(json))
                .toList();
          } catch (e) {
            print('Error parsing addresses: $e');
            return [];
          }
        } else {
          print('No addresses found in the response');
          return [];
        }
      } else {
        throw Exception('Failed to load addresses: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
      return [];
    }
  }
}
