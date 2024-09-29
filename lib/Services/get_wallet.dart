import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hezmaa/wallet/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletFetchService {
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

  final String _baseUrl = 'https://hezma-traning.eltamiuz.net/api/v1/wallet';

  Future<Wallet?> fetchWallet(String token) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          return Wallet.fromJson(jsonResponse);
        } else {
          print('Received empty JSON response.');
          return null;
        }
      } else {
        print('Failed to load wallet. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred while fetching wallet data: $e');
      return null;
    }
  }
}
