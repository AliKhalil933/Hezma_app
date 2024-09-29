import 'dart:convert';
import 'package:hezmaa/payment_mesodes/payment/payment.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  final String url = 'https://hezma-traning.eltamiuz.net/api/v1/payment_method';

  Future<Payment?> getPaymentMethods() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonData = json.decode(response.body) as Map<String, dynamic>;

        // Convert the JSON to a Payment object
        return Payment.fromJson(jsonData);
      } else {
        // Handle errors here
        print('Failed to load payment methods');
        return null;
      }
    } catch (e) {
      // Handle exceptions here
      print('Error: $e');
      return null;
    }
  }
}
