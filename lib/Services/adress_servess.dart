import 'dart:convert';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressGetService {
  Future<List<modelofAdress>> getProducts() async {
    String? token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final response = await http.get(
      Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/address'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        final List<dynamic> addressesJson = data['data'];
        return addressesJson
            .map((json) => modelofAdress.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load addresses: ${response.body}');
    }
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}

class AddressPostEditeService {
  Future<modelofAdress?> addOrUpdateAddress({
    required int addressId,
    required String name,
    required String address,
    required String lat,
    required String lng,
    required String distance,
  }) async {
    String? token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final url = addressId == 0
        ? 'https://hezma-traning.eltamiuz.net/api/v1/address/create'
        : 'https://hezma-traning.eltamiuz.net/api/v1/address/update/$addressId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'address': address,
        'lat': lat,
        'lng': lng,
        'distance': distance,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['status'] == true) {
        return modelofAdress.fromJson(data['data']);
      } else {
        throw Exception('Failed to add or update address: ${data['message']}');
      }
    } else {
      throw Exception('Failed to add or update address: ${response.body}');
    }
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}

class AddressDeletService {
  Future<bool> deleteAddress(int addressId) async {
    String? token = await _getAuthToken();

    if (token == null) {
      throw Exception('Auth token is not available.');
    }

    final response = await http.delete(
      Uri.parse(
          'https://hezma-traning.eltamiuz.net/api/v1/address/delete/$addressId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['status'] == true;
    } else {
      throw Exception('Failed to delete address: ${response.body}');
    }
  }

  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }
}
