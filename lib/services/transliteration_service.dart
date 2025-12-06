// services/transliteration_service.dart
class TransliterationService {
  static final Map<String, String> _transliterationMap = {
    // Tithis
    'Padyami': 'Pratipada',
    'Pratipada': 'Pratipada',
    'Vidhiya': 'Dwitiya',
    'Dwitiya': 'Dwitiya',
    'Thadiya': 'Tritiya',
    'Tritiya': 'Tritiya',
    'Chavithi': 'Chaturthi',
    'Chaviti': 'Chaturthi',
    'Chaturthi': 'Chaturthi',
    'Panchami': 'Panchami',
    'Shasti': 'Shashthi',
    'Shashthi': 'Shashthi',
    'Sapthami': 'Saptami',
    'Saptami': 'Saptami',
    'Ashtami': 'Ashtami',
    'Navami': 'Navami',
    'Dasami': 'Dashami',
    'Dashami': 'Dashami',
    'Ekadasi': 'Ekadashi',
    'Ekadashi': 'Ekadashi',
    'Dvadasi': 'Dwadashi',
    'Dwadashi': 'Dwadashi',
    'Trayodasi': 'Trayodashi',
    'Trayodashi': 'Trayodashi',
    'Chaturdasi': 'Chaturdashi',
    'Chaturdashi': 'Chaturdashi',
    'Punnami': 'Purnima',
    'Purnima': 'Purnima',
    'Amavasya': 'Amavasya',

    // Nakshatras
    'Ashwini': 'Ashwini',
    'Dwija': 'Bharani',
    'Bharani': 'Bharani',
    'Krittika': 'Krittika',
    'Rohini': 'Rohini',
    'Mrigashirsha': 'Mrigashira',
    'Mrigashira': 'Mrigashira',
    'Ardra': 'Ardra',
    'Punarvasu': 'Punarvasu',
    'Pushya': 'Pushya',
    'Ashlesha': 'Ashlesha',
    'Magha': 'Magha',
    'Purva Phalguni': 'Purva Phalguni',
    'Uttara Phalguni': 'Uttara Phalguni',
    'Hasta': 'Hasta',
    'Chitra': 'Chitra',
    'Swati': 'Swati',
    'Vishakha': 'Vishakha',
    'Anuradha': 'Anuradha',
    'Jyeshtha': 'Jyeshtha',
    'Mula': 'Mula',
    'Purva Ashadha': 'Purva Ashadha',
    'Uttara Ashadha': 'Uttara Ashadha',
    'Sravana': 'Shravana',
    'Shravana': 'Shravana',
    'Dhanishta': 'Dhanishtha',
    'Dhanishtha': 'Dhanishtha',
    'Shatabhisha': 'Shatabhisha',
    'Purva Bhadrapada': 'Purva Bhadrapada',
    'Uttara Bhadrapada': 'Uttara Bhadrapada',
    'Rebati': 'Revati',
    'Revati': 'Revati',

    // Paksha
    'Shukla': 'Shukla Paksha',
    'Krishna': 'Krishna Paksha',
    'Waxing Moon': 'Shukla Paksha',
    'Waning Moon': 'Krishna Paksha',
    'Shukla Paksha': 'Shukla Paksha',
    'Krishna Paksha': 'Krishna Paksha',

    // Masa (Months)
    'Baisakha': 'Vaishakha',
    'Vaishakha': 'Vaishakha',
    'Jyestha': 'Jyeshtha',
    'Jyeshtha': 'Jyeshtha',
    'Asadha': 'Ashadha',
    'Ashadha': 'Ashadha',
    'Srabana': 'Shravana',
    'Shravana': 'Shravana',
    'Bhadraba': 'Bhadrapada',
    'Bhadrapada': 'Bhadrapada',
    'Aswina': 'Ashwina',
    'Ashwina': 'Ashwina',
    'Karttika': 'Kartika',
    'Kartika': 'Kartika',
    'Margasira': 'Margashirsha',
    'Margashirsha': 'Margashirsha',
    'Pausa': 'Pausha',
    'Pausha': 'Pausha',
    'Magha': 'Magha',
    'Phalguna': 'Phalguna',
    'Chaitra': 'Chaitra',

    // Raasi (Zodiac)
    'Mesha': 'Mesha',
    'Vrishabha': 'Vrishabha',
    'Mithuna': 'Mithuna',
    'Karka': 'Karka',
    'Karkata': 'Karka',
    'Simha': 'Simha',
    'Kanya': 'Kanya',
    'Tula': 'Tula',
    'Vrishchika': 'Vrishchika',
    'Dhanu': 'Dhanu',
    'Makara': 'Makara',
    'Kumbha': 'Kumbha',
    'Meena': 'Meena',
    'Aries': 'Mesha',
    'Taurus': 'Vrishabha',
    'Gemini': 'Mithuna',
    'Cancer': 'Karka',
    'Leo': 'Simha',
    'Virgo': 'Kanya',
    'Libra': 'Tula',
    'Scorpio': 'Vrishchika',
    'Sagittarius': 'Dhanu',
    'Capricorn': 'Makara',
    'Aquarius': 'Kumbha',
    'Pisces': 'Meena',

    // Yogas (27 yogas)
    'Vishkambha': 'Vishkambha',
    'Prithi': 'Priti',
    'Priti': 'Priti',
    'Ayushman': 'Ayushman',
    'Saubhagya': 'Saubhagya',
    'Sobhana': 'Shobhana',
    'Shobhana': 'Shobhana',
    'Atiganda': 'Atiganda',
    'Sukarman': 'Sukarma',
    'Sukarma': 'Sukarma',
    'Dhrithi': 'Dhriti',
    'Dhriti': 'Dhriti',
    'Soola': 'Shula',
    'Shula': 'Shula',
    'Ganda': 'Ganda',
    'Vridhi': 'Vriddhi',
    'Vriddhi': 'Vriddhi',
    'Dhruva': 'Dhruva',
    'Vyaghata': 'Vyaghata',
    'Harshana': 'Harshana',
    'Vajra': 'Vajra',
    'Siddhi': 'Siddhi',
    'Vyatipata': 'Vyatipata',
    'Variyan': 'Variyan',
    'Parigha': 'Parigha',
    'Siva': 'Shiva',
    'Shiva': 'Shiva',
    'Siddha': 'Siddha',
    'Sadhya': 'Sadhya',
    'Subha': 'Shubha',
    'Shubha': 'Shubha',
    'Sukla': 'Shukla',
    'Bramha': 'Brahma',
    'Brahma': 'Brahma',
    'Indra': 'Indra',
    'Vaidhruthi': 'Vaidhriti',
    'Vaidhriti': 'Vaidhriti',

    // Karanas (11 karanas)
    'Bawa': 'Bava',
    'Bava': 'Bava',
    'Balava': 'Balava',
    'Kaulava': 'Kaulava',
    'Taitula': 'Taitila',
    'Taitila': 'Taitila',
    'Garaja': 'Garaja',
    'Gara': 'Garaja',
    'Vanija': 'Vanija',
    'Vishti': 'Vishti',
    'Sakuna': 'Shakuni',
    'Shakuni': 'Shakuni',
    'Chatushpada': 'Chatushpada',
    'Nagava': 'Naga',
    'Naga': 'Naga',
    'Kimstughana': 'Kimstughna',
    'Kimstughna': 'Kimstughna',
    'Bhadra': 'Bhadra',

    // Ritu (Seasons)
    'Spring': 'Vasanta',
    'Vasanta': 'Vasanta',
    'Summer': 'Grishma',
    'Grishma': 'Grishma',
    'Monsoon': 'Varsha',
    'Varsha': 'Varsha',
    'Autumn': 'Sharad',
    'Sharad': 'Sharad',
    'Pre-Winter': 'Hemanta',
    'Hemanta': 'Hemanta',
    'Winter': 'Shishira',
    'Shishira': 'Shishira',

    // Days
    'Sunday': 'Ravivaar',
    'Monday': 'Somvaar',
    'Tuesday': 'Mangalvaar',
    'Wednesday': 'Budhvaar',
    'Thursday': 'Guruvaar',
    'Friday': 'Shukravaar',
    'Saturday': 'Shanivaar',
  };

  /// Convert any text to proper Hindi transliteration
  static String toHindiTransliteration(String? text) {
    if (text == null || text.isEmpty) return '-';

    // Try direct match
    if (_transliterationMap.containsKey(text)) {
      return _transliterationMap[text]!;
    }

    // Try case-insensitive match
    final lowerText = text.toLowerCase();
    for (var entry in _transliterationMap.entries) {
      if (entry.key.toLowerCase() == lowerText) {
        return entry.value;
      }
    }

    return text;
  }

  static List<String> getAllVariations() {
    return _transliterationMap.keys.toList();
  }

  static List<String> findVariations(String searchTerm) {
    final lowerSearch = searchTerm.toLowerCase();
    return _transliterationMap.entries
        .where(
          (entry) =>
              entry.key.toLowerCase().contains(lowerSearch) ||
              entry.value.toLowerCase().contains(lowerSearch),
        )
        .map((entry) => entry.value)
        .toSet()
        .toList();
  }
}
