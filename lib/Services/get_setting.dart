import 'dart:convert';
import 'package:http/http.dart' as http;

class SettingService {
  final String url = 'https://hezma-traning.eltamiuz.net/api/v1/setting_data';

  Future<List<dynamic>> fetchSettings() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load settings');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
