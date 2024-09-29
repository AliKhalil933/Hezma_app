import 'dart:convert';
import 'package:hezmaa/models/model_copoun/model_coboun/model_coboun.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CouponService {
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? prefs.getString('register_token');
  }

  Future<ModelCoboun?> verifyCoupon(String couponCode) async {
    final url = Uri.parse(
        'https://hezma-traning.eltamiuz.net/api/v1/cart/verify-coupon');
    final String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return null;
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({'coupon_code': couponCode});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}'); // طباعة الاستجابة كاملة
      final responseData = jsonDecode(response.body);

      final couponResponse = ModelCoboun.fromJson(responseData);
      print('Response status: ${couponResponse.status}');
      print('Response message: ${couponResponse.message}');

      if (couponResponse.status == true) {
        final couponData = couponResponse.data;
        print('Coupon ID: ${couponData?.id}');
        print('Coupon Code: ${couponData?.code}');
        print('Coupon Value: ${couponData?.value}');
        print('Is Value: ${couponData?.isValue}');
      } else {
        print('Failed to verify coupon. Status code: ${response.statusCode}');
        print('Response message: ${couponResponse.message}');
      }

      return couponResponse;
    } catch (error) {
      print('Error occurred: $error');
      return null;
    }
  }
}
