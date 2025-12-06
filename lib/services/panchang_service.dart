// services/panchang_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/panchang_day.dart';
import '../models/tithi_search_result.dart';

class PanchangService {
  final String baseUrl = "https://test-hvkg.onrender.com";

  Future<PanchangDay> fetchPanchang(String date, double lat, double lng) async {
    final url = Uri.parse('$baseUrl/panchang?date=$date&lat=$lat&lng=$lng');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PanchangDay.fromJson(data);
    } else {
      throw Exception('Failed to fetch Panchang data');
    }
  }

  Future<List<String>> fetchAvailableTithis(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/tithis?lat=$lat&lng=$lng');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['tithis']);
    } else {
      throw Exception('Failed to fetch available tithis');
    }
  }

  Future<TithiSearchResult> searchTithiDates(
    String tithi,
    double lat,
    double lng,
  ) async {
    final url = Uri.parse(
      '$baseUrl/search-tithi?tithi=${Uri.encodeComponent(tithi)}&lat=$lat&lng=$lng',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TithiSearchResult.fromJson(data);
    } else {
      throw Exception('Failed to search tithi dates');
    }
  }

  Future<void> cacheYearData(double lat, double lng) async {
    final url = Uri.parse('$baseUrl/cache-year');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'lat': lat, 'lng': lng}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cache year data');
    }
  }
}
