import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jishin/models/earthquake.dart';
import 'dart:developer'; // Import for log

class EarthquakeService {
  static const String _baseUrl = 'https://api.p2pquake.net/v2/history';

  Future<List<Earthquake>> fetchLatestEarthquakes() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=100'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<dynamic> earthquakeData = data.where((item) => item['code'] == 551).toList();
        return earthquakeData.map((json) => Earthquake.fromJson(json)).toList();
      } else {
        log('API Error: Status Code ${response.statusCode}');
        log('API Error: Response Body ${response.body}');
        throw Exception('Failed to load earthquakes: Status Code ${response.statusCode}');
      }
    } catch (e) {
      log('Network or Parsing Error: $e');
      throw Exception('Failed to load earthquakes: $e');
    }
  }
}