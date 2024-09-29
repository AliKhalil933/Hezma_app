import 'package:hezmaa/models/sliders/SlidersResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SliderService {
  final String baseUrl;
  String? _authToken;

  SliderService({required this.baseUrl}) {
    _initializeToken(); // يجب استخدام هذه الطريقة قبل القيام بأي طلب
  }

  Future<void> _initializeToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginToken = prefs.getString('authToken');
    final String? registerToken = prefs.getString('register_token');

    // التحقق من وجود التوكن
    if (loginToken != null) {
      _authToken = loginToken;
    } else if (registerToken != null) {
      _authToken = registerToken;
    } else {
      throw Exception('No auth token found');
    }
  }

  Future<SlidersResponse> fetchSliders() async {
    // تأكد من أن التوكن تم تحميله بشكل صحيح
    if (_authToken == null) {
      await _initializeToken(); // قم بتحميل التوكن إذا لم يكن موجودًا
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/sliders'),
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return SlidersResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load sliders');
    }
  }
}
