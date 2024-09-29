import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error fetching data: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
      rethrow;
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
    String? token,
    required Map<String, String> headers,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Error posting data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
      rethrow;
    }
  }

  Future<dynamic> delete({
    required String url,
    dynamic body,
    String? token,
  }) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        body: body != null ? jsonEncode(body) : null,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isEmpty ? null : jsonDecode(response.body);
      } else {
        throw Exception(
            'Error deleting data: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Network error: $e');
      rethrow;
    }
  }
}
