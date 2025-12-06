import 'package:flutter/material.dart';
import '../models/panchang_day.dart';
import '../app_theme.dart';
import '../services/transliteration_service.dart';

class DateDetailsWidget extends StatelessWidget {
  final PanchangDay? day;

  const DateDetailsWidget({super.key, required this.day});

  String? convertToIST(String? utcTime) {
    if (utcTime == null) return null;
    try {
      final utcDate = DateTime.parse(utcTime).toUtc();
      final istDate = utcDate.add(const Duration(hours: 5, minutes: 30));
      return "${istDate.hour.toString().padLeft(2, '0')}:${istDate.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return utcTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (day == null) return const SizedBox();

    final sunriseIST = convertToIST(day!.sunrise);
    final sunsetIST = convertToIST(day!.sunset);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day!.dateKey,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.pennRed,
              ),
            ),
            const Divider(height: 20),
            _buildRow(
              'Tithi',
              TransliterationService.toHindiTransliteration(day!.tithi),
            ),
            _buildRow(
              'Nakshatra',
              TransliterationService.toHindiTransliteration(day!.nakshatra),
            ),
            _buildRow(
              'Paksha',
              TransliterationService.toHindiTransliteration(day!.paksha),
            ),
            _buildRow(
              'Masa',
              TransliterationService.toHindiTransliteration(day!.masa),
            ),
            _buildRow(
              'Raasi',
              TransliterationService.toHindiTransliteration(day!.raasi),
            ),
            _buildRow(
              'Yoga',
              TransliterationService.toHindiTransliteration(day!.yoga),
            ),
            _buildRow(
              'Karna',
              TransliterationService.toHindiTransliteration(day!.karna),
            ),
            _buildRow(
              'Ritu',
              TransliterationService.toHindiTransliteration(day!.ritu),
            ),
            const Divider(height: 20),
            _buildRow('Sunrise', sunriseIST),
            _buildRow('Sunset', sunsetIST),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
          Flexible(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
