import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderCanceledService {
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

  // Method to cancel the order
  Future<void> cancelOrder(int orderId) async {
    final String? token = await _getAuthToken();

    if (token == null) {
      throw Exception('توكن المصادقة غير متاح');
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://hezma-traning.eltamiuz.net/api/v1/order/cancel/$orderId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          print('Message: ${data['message']}');
        } else {
          throw Exception('فشل في إلغاء الطلب: ${data['message']}');
        }
      } else {
        throw Exception('فشل في إلغاء الطلب: ${response.body}');
      }
    } catch (e) {
      throw Exception('فشل في إلغاء الطلب: $e');
    }
  }
}
