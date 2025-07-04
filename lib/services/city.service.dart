import 'dart:convert';
import 'package:http/http.dart' as http;

class CityService {
  static Future<List<String>> fetchGermanCities() async {
    final uri = Uri.parse(
      'https://countriesnow.space/api/v0.1/countries/cities/q?country=Germany',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['data']);
    } else {
      throw Exception('Failed to load German cities');
    }
  }
}
