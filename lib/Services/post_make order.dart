import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MakeOrderService {
  // الحصول على رمز المصادقة من SharedPreferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    if (loginToken != null) {
      return loginToken;
    } else if (registerToken != null) {
      return registerToken;
    } else {
      throw Exception('No auth token found');
    }
  }

  // إرسال الطلب
  Future<void> makeOrder({
    required String couponCode,
    required int paymentMethodId,
    required int addressId,
    required int timeId,
    required String date,
    required double shipping,
    required String userName,
    required String bankName,
    required File? image,
  }) async {
    String? token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token is not available');
    }

    final url = 'https://hezma-traning.eltamiuz.net/api/v1/cart/make-order';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // إعداد الهيدرات
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    // إعداد البيانات
    request.fields['coupon_code'] = couponCode;
    request.fields['payment_method_id'] = paymentMethodId.toString();
    request.fields['address_id'] = addressId.toString();
    request.fields['time_id'] = timeId.toString();
    request.fields['date'] = date;
    request.fields['shipping'] = shipping.toString();
    request.fields['user_name'] = userName;
    request.fields['bank_name'] = bankName;

    // إضافة صورة الإيصال إذا كانت موجودة
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    try {
      // إرسال الطلب واستقبال الاستجابة
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      // طباعة معلومات الطلب
      print('Request URL: $url');
      print('Response Status: ${responseBody.statusCode}');
      print('Response Body: ${responseBody.body}');

      // معالجة الاستجابة
      if (responseBody.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody.body);
        print('Full Response: $jsonResponse');

        // تحقق من وجود المفتاح status
        if (jsonResponse['status'] == true) {
          print('Response message: ${jsonResponse['message']}');
          print('Current orders: ${jsonResponse['data']}');

          // تحقق إذا كانت extra_data تحتوي على معلومات الطلبات الملغاة
          if (jsonResponse['extra_data'] != null &&
              jsonResponse['extra_data']['Canceled'] != null) {
            print('Canceled orders: ${jsonResponse['extra_data']['Canceled']}');
          } else {
            print('No canceled orders found.');
          }
        } else {
          print('Request failed: ${jsonResponse['message']}');
        }
      } else {
        print('Error: ${responseBody.body}');
      }
    } catch (e) {
      print('Error in makeOrder: $e');
      rethrow; // إعادة طرح الخطأ لمزيد من المعالجة إذا لزم الأمر
    }
  }
}
