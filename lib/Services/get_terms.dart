import 'dart:convert';

import 'package:hezmaa/terms/terms/terms.dart';
import 'package:http/http.dart' as http;

class TermsService {
  final String _baseUrl = 'https://hezma-traning.eltamiuz.net/api/v1/terms';

  Future<prodectModelTerms?> fetchTerms() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return prodectModelTerms.fromJson(jsonResponse);
      } else {
        // يمكنك إضافة معالجة للأخطاء هنا
        print('Failed to load terms: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
