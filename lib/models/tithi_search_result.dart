// models/tithi_search_result.dart
class TithiSearchResult {
  final String tithi;
  final String location;
  final int totalMatches;
  final List<TithiDate> dates;

  TithiSearchResult({
    required this.tithi,
    required this.location,
    required this.totalMatches,
    required this.dates,
  });

  factory TithiSearchResult.fromJson(Map<String, dynamic> json) {
    return TithiSearchResult(
      tithi: json['tithi'] ?? '',
      location: json['location'] ?? '',
      totalMatches: json['totalMatches'] ?? 0,
      dates:
          (json['dates'] as List?)
              ?.map((dateJson) => TithiDate.fromJson(dateJson))
              .toList() ??
          [],
    );
  }
}

class TithiDate {
  final String date;
  final String tithi;
  final String paksha;
  final String nakshatra;
  final String sunrise;
  final String sunset;

  TithiDate({
    required this.date,
    required this.tithi,
    required this.paksha,
    required this.nakshatra,
    required this.sunrise,
    required this.sunset,
  });

  factory TithiDate.fromJson(Map<String, dynamic> json) {
    return TithiDate(
      date: json['date'] ?? '',
      tithi: json['tithi'] ?? '',
      paksha: json['paksha'] ?? '',
      nakshatra: json['nakshatra'] ?? '',
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
    );
  }

  DateTime get dateTime {
    final parts = date.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
