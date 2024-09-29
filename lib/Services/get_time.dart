import 'package:http/http.dart' as http;
import 'dart:convert';

class TimeService {
  Future<List<dynamic>> fetchTime(String date) async {
    final url = 'https://hezma-traning.eltamiuz.net/api/v1/times?date=$date';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status']) {
          return data['data'];
        } else {
          print('Status false: ${data['message']}');
          return [];
        }
      } else {
        print('Failed to load data');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
