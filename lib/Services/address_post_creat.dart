import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:http/http.dart' as http;

class AdressPostCreatService {
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<modelofAdress?> createAddress(String name, String address, String lat,
      String lng, int districtId, String distance) async {
    String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return null;
    }

    try {
      // بيانات الطلب
      final Map<String, dynamic> body = {
        'name': name,
        'district_id': districtId,
        'address': address,
        'lat': lat,
        'lng': lng,
        'distance': distance,
      };

      final response = await http.post(
        Uri.parse('https://hezma-traning.eltamiuz.net/api/v1/address/create'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == true) {
          print('Message: ${data['message']}');

          // تحويل البيانات المستلمة إلى كائن modelofAdress
          final addressData = modelofAdress.fromJson(data['data']);
          return addressData;
        } else {
          print('Failed to create address. Message: ${data['message']}');
          return null;
        }
      } else {
        print('Failed to create address: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}
