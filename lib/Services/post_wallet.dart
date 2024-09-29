import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
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

  static Future<String> chargeWallet({
    required String amount,
    required String paymentMethodId,
    required String token,
  }) async {
    final String url =
        'https://hezma-traning.eltamiuz.net/api/v1/charge_wallet';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        return 'فشل في استرجاع التوكن. الرجاء تسجيل الدخول أولاً.';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, String>{
          'amount': amount,
          'payment_method_id': paymentMethodId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return 'تم شحن المحفظة بنجاح: ${data['message']}';
      } else {
        final data = jsonDecode(response.body);
        return 'فشلت عملية الشحن: ${data['message']}';
      }
    } catch (e) {
      return 'حدث خطأ أثناء شحن المحفظة: $e';
    }
  }
}
