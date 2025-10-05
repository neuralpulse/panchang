// models/panchang_day.dart
class PanchangDay {
  final String dateKey;
  final String day;
  final int year;
  final int month;
  final int dayNum;
  final String? tithi;
  final String? nakshatra;
  final String? paksha;
  final String? masa;
  final String? raasi;
  final String? yoga;
  final String? karna;
  final String? ritu;
  final String? sunrise;
  final String? sunset;

  PanchangDay({
    required this.dateKey,
    required this.day,
    required this.year,
    required this.month,
    required this.dayNum,
    this.tithi,
    this.nakshatra,
    this.paksha,
    this.masa,
    this.raasi,
    this.yoga,
    this.karna,
    this.ritu,
    this.sunrise,
    this.sunset,
  });

  factory PanchangDay.fromJson(Map<String, dynamic> json) {
    // Parse the date string from server: "2025-10-01"
    final dateParts = (json['date'] as String).split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final dayNum = int.parse(dateParts[2]);

    return PanchangDay(
      dateKey: json['date'] ?? '',
      day: json['day'] ?? '',
      year: year,
      month: month,
      dayNum: dayNum,
      tithi: json['tithi'],
      nakshatra: json['nakshatra'],
      paksha: json['paksha'],
      masa: json['masa'],
      raasi: json['raasi'],
      yoga: json['yoga'],
      karna: json['karna'],
      ritu: json['ritu'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}
