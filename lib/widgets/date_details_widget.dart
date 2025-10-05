import 'package:flutter/material.dart';
import '../models/panchang_day.dart';
import '../app_theme.dart';

class DateDetailsWidget extends StatefulWidget {
  final PanchangDay? day;

  const DateDetailsWidget({super.key, required this.day});

  @override
  State<DateDetailsWidget> createState() => _DateDetailsWidgetState();
}

class _DateDetailsWidgetState extends State<DateDetailsWidget> {
  String currentLanguage = 'en';

  String _translate(String? text) {
    if (text == null || text.isEmpty) return '-';
    if (currentLanguage == 'en') return text;
    final Map<String, String> hindiTranslations = {
      // Tithis
      'Padyami': 'प्रतिपदा',
      'Pratipada': 'प्रतिपदा',
      'Vidhiya': 'द्वितीया',
      'Dwitiya': 'द्वितीया',
      'Thadiya': 'तृतीया',
      'Tritiya': 'तृतीया',
      'Chavithi': 'चतुर्थी',
      'Chaviti': 'चतुर्थी',
      'Chaturthi': 'चतुर्थी',
      'Panchami': 'पंचमी',
      'Shasti': 'षष्ठी',
      'Shashthi': 'षष्ठी',
      'Sapthami': 'सप्तमी',
      'Saptami': 'सप्तमी',
      'Ashtami': 'अष्टमी',
      'Navami': 'नवमी',
      'Dasami': 'दशमी',
      'Dashami': 'दशमी',
      'Ekadasi': 'एकादशी',
      'Ekadashi': 'एकादशी',
      'Dvadasi': 'द्वादशी',
      'Dwadashi': 'द्वादशी',
      'Trayodasi': 'त्रयोदशी',
      'Trayodashi': 'त्रयोदशी',
      'Chaturdasi': 'चतुर्दशी',
      'Chaturdashi': 'चतुर्दशी',
      'Punnami': 'पूर्णिमा',
      'Purnima': 'पूर्णिमा',
      'Amavasya': 'अमावस्या',

      // Nakshatras
      'Ashwini': 'अश्विनी',
      'Dwija': 'भरणी',
      'Bharani': 'भरणी',
      'Krittika': 'कृत्तिका',
      'Rohini': 'रोहिणी',
      'Mrigashirsha': 'मृगशिरा',
      'Ardra': 'आर्द्रा',
      'Punarvasu': 'पुनर्वसु',
      'Pushya': 'पुष्य',
      'Ashlesha': 'आश्लेषा',
      'Magha': 'मघा',
      'Purva Phalguni': 'पूर्वा फाल्गुनी',
      'Uttara Phalguni': 'उत्तरा फाल्गुनी',
      'Hasta': 'हस्त',
      'Chitra': 'चित्रा',
      'Swati': 'स्वाति',
      'Vishakha': 'विशाखा',
      'Anuradha': 'अनुराधा',
      'Jyeshtha': 'ज्येष्ठा',
      'Mula': 'मूल',
      'Purva Ashadha': 'पूर्वाषाढ़ा',
      'Uttara Ashadha': 'उत्तराषाढ़ा',
      'Sravana': 'श्रवण',
      'Dhanishta': 'धनिष्ठा',
      'Shatabhisha': 'शतभिषा',
      'Purva Bhadrapada': 'पूर्वभाद्रपद',
      'Uttara Bhadrapada': 'उत्तरभाद्रपद',
      'Rebati': 'रेवती',
      'Revati': 'रेवती',

      // Paksha
      'Shukla': 'शुक्ल',
      'Krishna': 'कृष्ण',
      'Waxing Moon': 'शुक्ल पक्ष',
      'Waning Moon': 'कृष्ण पक्ष',
      'Shukla Paksha': 'शुक्ल पक्ष',
      'Krishna Paksha': 'कृष्ण पक्ष',

      // Masa (Months)
      'Baisakha': 'वैशाख',
      'Vaishakha': 'वैशाख',
      'Jyestha': 'ज्येष्ठ',
      'Jyeshtha': 'ज्येष्ठ',
      'Asadha': 'आषाढ़',
      'Ashadha': 'आषाढ़',
      'Srabana': 'श्रावण',
      'Shravana': 'श्रावण',
      'Bhadraba': 'भाद्रपद',
      'Bhadrapada': 'भाद्रपद',
      'Aswina': 'आश्विन',
      'Ashwina': 'आश्विन',
      'Karttika': 'कार्तिक',
      'Kartika': 'कार्तिक',
      'Margasira': 'मार्गशीर्ष',
      'Margashirsha': 'मार्गशीर्ष',
      'Pausa': 'पौष',
      'Pausha': 'पौष',
      'Magha': 'माघ',
      'Phalguna': 'फाल्गुन',
      'Chaitra': 'चैत्र',

      // Raasi (Zodiac)
      'Mesha': 'मेष',
      'Vrishabha': 'वृषभ',
      'Mithuna': 'मिथुन',
      'Karka': 'कर्क',
      'Karkata': 'कर्क',
      'Simha': 'सिंह',
      'Kanya': 'कन्या',
      'Tula': 'तुला',
      'Vrishchika': 'वृश्चिक',
      'Dhanu': 'धनु',
      'Makara': 'मकर',
      'Kumbha': 'कुंभ',
      'Meena': 'मीन',
      'Aries': 'मेष',
      'Taurus': 'वृषभ',
      'Gemini': 'मिथुन',
      'Cancer': 'कर्क',
      'Leo': 'सिंह',
      'Virgo': 'कन्या',
      'Libra': 'तुला',
      'Scorpio': 'वृश्चिक',
      'Sagittarius': 'धनु',
      'Capricorn': 'मकर',
      'Aquarius': 'कुंभ',
      'Pisces': 'मीन',

      // Yogas (27 yogas)
      'Vishkambha': 'विष्कम्भ',
      'Prithi': 'प्रीति',
      'Priti': 'प्रीति',
      'Ayushman': 'आयुष्मान',
      'Saubhagya': 'सौभाग्य',
      'Sobhana': 'शोभन',
      'Shobhana': 'शोभन',
      'Atiganda': 'अतिगण्ड',
      'Sukarman': 'सुकर्मा',
      'Sukarma': 'सुकर्मा',
      'Dhrithi': 'धृति',
      'Dhriti': 'धृति',
      'Soola': 'शूल',
      'Shula': 'शूल',
      'Ganda': 'गण्ड',
      'Vridhi': 'वृद्धि',
      'Vriddhi': 'वृद्धि',
      'Dhruva': 'ध्रुव',
      'Vyaghata': 'व्याघात',
      'Harshana': 'हर्षण',
      'Vajra': 'वज्र',
      'Siddhi': 'सिद्धि',
      'Vyatipata': 'व्यतीपात',
      'Variyan': 'वरीयान',
      'Parigha': 'परिघ',
      'Siva': 'शिव',
      'Shiva': 'शिव',
      'Siddha': 'सिद्ध',
      'Sadhya': 'साध्य',
      'Subha': 'शुभ',
      'Shubha': 'शुभ',
      'Sukla': 'शुक्ल',
      'Bramha': 'ब्रह्म',
      'Brahma': 'ब्रह्म',
      'Indra': 'इन्द्र',
      'Vaidhruthi': 'वैधृति',
      'Vaidhriti': 'वैधृति',

      // Karanas (11 karanas)
      'Bawa': 'बव',
      'Bava': 'बव',
      'Balava': 'बालव',
      'Kaulava': 'कौलव',
      'Taitula': 'तैतिल',
      'Taitila': 'तैतिल',
      'Garaja': 'गरज',
      'Gara': 'गरज',
      'Vanija': 'वणिज',
      'Vishti': 'विष्टि',
      'Sakuna': 'शकुनि',
      'Shakuni': 'शकुनि',
      'Chatushpada': 'चतुष्पद',
      'Nagava': 'नाग',
      'Naga': 'नाग',
      'Kimstughana': 'किम्स्तुघ्न',
      'Kimstughna': 'किम्स्तुघ्न',
      'Bhadra': 'भद्रा',

      // Ritu (Seasons)
      'Spring': 'वसन्त',
      'Vasanta': 'वसन्त',
      'Summer': 'ग्रीष्म',
      'Grishma': 'ग्रीष्म',
      'Monsoon': 'वर्षा',
      'Varsha': 'वर्षा',
      'Autumn': 'शरद',
      'Sharad': 'शरद',
      'Pre-Winter': 'हेमन्त',
      'Hemanta': 'हेमन्त',
      'Winter': 'शिशिर',
      'Shishira': 'शिशिर',

      // Days
      'Sunday': 'रविवार',
      'Monday': 'सोमवार',
      'Tuesday': 'मंगलवार',
      'Wednesday': 'बुधवार',
      'Thursday': 'गुरुवार',
      'Friday': 'शुक्रवार',
      'Saturday': 'शनिवार',
    };
    // Try direct translation
    if (hindiTranslations.containsKey(text)) {
      return hindiTranslations[text]!;
    }

    // Try case-insensitive match
    final lowerText = text.toLowerCase();
    for (var entry in hindiTranslations.entries) {
      if (entry.key.toLowerCase() == lowerText) {
        return entry.value;
      }
    }

    // Return original if no translation found
    return text;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.day == null) return const SizedBox();

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

    final sunriseIST = convertToIST(widget.day!.sunrise);
    final sunsetIST = convertToIST(widget.day!.sunset);

    String getLabel(String key) {
      const labelTranslations = {
        'Tithi': {'en': 'Tithi', 'hi': 'तिथि'},
        'Nakshatra': {'en': 'Nakshatra', 'hi': 'नक्षत्र'},
        'Paksha': {'en': 'Paksha', 'hi': 'पक्ष'},
        'Masa': {'en': 'Masa', 'hi': 'मास'},
        'Raasi': {'en': 'Raasi', 'hi': 'राशि'},
        'Yoga': {'en': 'Yoga', 'hi': 'योग'},
        'Karna': {'en': 'Karna', 'hi': 'करण'},
        'Ritu': {'en': 'Ritu', 'hi': 'ऋतु'},
        'Sunrise': {'en': 'Sunrise', 'hi': 'सूर्योदय'},
        'Sunset': {'en': 'Sunset', 'hi': 'सूर्यास्त'},
      };
      return labelTranslations[key]?[currentLanguage] ?? key;
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.day!.dateKey,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.pennRed,
                  ),
                ),
                DropdownButton<String>(
                  value: currentLanguage,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentLanguage = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(height: 20),
            _buildRow(getLabel('Tithi'), _translate(widget.day!.tithi)),
            _buildRow(getLabel('Nakshatra'), _translate(widget.day!.nakshatra)),
            _buildRow(getLabel('Paksha'), _translate(widget.day!.paksha)),
            _buildRow(getLabel('Masa'), _translate(widget.day!.masa)),
            _buildRow(getLabel('Raasi'), _translate(widget.day!.raasi)),
            _buildRow(getLabel('Yoga'), _translate(widget.day!.yoga)),
            _buildRow(getLabel('Karna'), _translate(widget.day!.karna)),
            _buildRow(getLabel('Ritu'), _translate(widget.day!.ritu)),
            const Divider(height: 20),
            _buildRow(getLabel('Sunrise'), sunriseIST),
            _buildRow(getLabel('Sunset'), sunsetIST),
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
