// services/panchang_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/panchang_day.dart';

class PanchangService {
  final String baseUrl = "https://test-hvkg.onrender.com/panchang";

  Future<PanchangDay> fetchPanchang(String date, double lat, double lng) async {
    final url = Uri.parse('$baseUrl?date=$date&lat=$lat&lng=$lng');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PanchangDay.fromJson(data);
    } else {
      throw Exception('Failed to fetch Panchang data');
    }
  }
}
