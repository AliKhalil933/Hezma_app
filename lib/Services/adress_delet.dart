import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddressDeletService {
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<bool> deleteAddress(int addressId) async {
    String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return false;
    }

    try {
      // إجراء طلب DELETE بدون جسم طلب
      final response = await http.delete(
        Uri.parse(
            'https://hezma-traning.eltamiuz.net/api/v1/address/delete/$addressId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == true) {
          print('Message: ${data['message']}');
          return true; // Successful deletion
        } else {
          print('Failed to delete address. Message: ${data['message']}');
          return false; // Failed deletion
        }
      } else {
        print('Failed to delete address: ${response.statusCode}');
        print('Error: ${response.body}');
        return false; // Failed deletion
      }
    } catch (e) {
      print('An error occurred: $e');
      return false; // Failed deletion
    }
  }
}
