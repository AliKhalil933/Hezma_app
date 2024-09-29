import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hezmaa/adress/adress/modelAdress.dart';
import 'package:http/http.dart' as http;

class AdressPostEditeService {
  Future<String?> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<modelofAdress?> editeAddress({
    required int addressId,
    required String name,
    required String address,
    required String lat,
    required String lng,
    required String distance,
    required int districtId, // Add this parameter
  }) async {
    String? token = await _getAuthToken();

    if (token == null) {
      print('Auth token is not available.');
      return null;
    }

    try {
      // إعداد بيانات الطلب
      final Map<String, dynamic> body = {
        'address_id': addressId.toString(),
        'name': name,
        'address': address,
        'lat': lat,
        'lng': lng,
        'distance': distance,
        'district_id': districtId.toString(), // Include the district_id
      };

      final response = await http.put(
        Uri.parse(
            'https://hezma-traning.eltamiuz.net/api/v1/address/update/$addressId'),
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
          print('Failed to update address. Message: ${data['message']}');
          return null;
        }
      } else {
        print('Failed to update address: ${response.statusCode}');
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}
