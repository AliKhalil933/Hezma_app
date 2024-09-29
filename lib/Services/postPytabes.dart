import 'dart:convert';
import 'package:hezmaa/models/pytabes/pytabes.dart';
import 'package:http/http.dart' as http;

class PayTabsService {
  final String url = 'https://secure.paytabs.sa/payment/request';

  Future<void> sendPaymentRequest(Pytabes pytabes) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(pytabes.toJson()),
      );

      if (response.statusCode == 200) {
        print('الطلب تم بنجاح');
        print('الاستجابة: ${response.body}');
      } else {
        print('فشل الطلب. الحالة: ${response.statusCode}');
        print('الاستجابة: ${response.body}');
      }
    } catch (e) {
      print('خطأ: $e');
    }
  }
}
