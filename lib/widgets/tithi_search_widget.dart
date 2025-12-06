import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:alarm/alarm.dart';
import '../services/panchang_service.dart';
import '../services/transliteration_service.dart';
import '../models/tithi_search_result.dart';
import '../app_theme.dart';

class TithiSearchWidget extends StatefulWidget {
  final PanchangService service;
  final double? latitude;
  final double? longitude;
  final VoidCallback? onAlarmsUpdated;
  final Function(int alarmId, String tithi)? onAlarmSet;

  const TithiSearchWidget({
    super.key,
    required this.service,
    this.latitude,
    this.longitude,
    this.onAlarmsUpdated,
    this.onAlarmSet,
  });

  @override
  State<TithiSearchWidget> createState() => _TithiSearchWidgetState();
}

class _TithiSearchWidgetState extends State<TithiSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  TithiSearchResult? _searchResult;
  List<String> _availableTithis = [];
  bool _isLoading = false;
  bool _isSearching = false;

  // Tithi name variations mapping
  final Map<String, List<String>> tithiVariations = {
    'Padyami': ['Padyami', 'Pratipada', 'Pratipad'],
    'Vidhiya': ['Vidhiya', 'Dwitiya', 'Dwiteeya', 'Vidiya'],
    'Thadiya': ['Thadiya', 'Tritiya', 'Trutiya', 'Tadiya'],
    'Chavithi': ['Chavithi', 'Chaviti', 'Chaturthi', 'Chaturti'],
    'Panchami': ['Panchami', 'Panchami'],
    'Shasti': ['Shasti', 'Shashthi', 'Sashti'],
    'Sapthami': ['Sapthami', 'Saptami', 'Sapthmi'],
    'Ashtami': ['Ashtami', 'Astami'],
    'Navami': ['Navami', 'Navmi'],
    'Dasami': ['Dasami', 'Dashami', 'Dasmi'],
    'Ekadasi': ['Ekadasi', 'Ekadashi', 'Ekadshi'],
    'Dvadasi': ['Dvadasi', 'Dwadashi', 'Dvadshi'],
    'Trayodasi': ['Trayodasi', 'Trayodashi', 'Trayodshi'],
    'Chaturdasi': ['Chaturdasi', 'Chaturdashi', 'Chaturdshi'],
    'Punnami': ['Punnami', 'Purnima', 'Poornima'],
    'Amavasya': ['Amavasya', 'Amavasye', 'Amawasya'],
  };

  @override
  void initState() {
    super.initState();
    _loadAvailableTithis();
  }

  Future<void> _loadAvailableTithis() async {
    if (widget.latitude == null || widget.longitude == null) return;

    try {
      setState(() => _isLoading = true);
      final tithis = await widget.service.fetchAvailableTithis(
        widget.latitude!,
        widget.longitude!,
      );
      setState(() => _availableTithis = tithis);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading tithis: $e")));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Find the actual tithi name from server that matches user input
  String? _findMatchingTithi(String searchTerm) {
    final lowerSearch = searchTerm.toLowerCase().trim();

    // Direct match
    for (final tithi in _availableTithis) {
      if (tithi.toLowerCase() == lowerSearch) {
        return tithi;
      }
    }

    // Check variations
    for (final entry in tithiVariations.entries) {
      for (final variation in entry.value) {
        if (variation.toLowerCase() == lowerSearch) {
          // Find the actual tithi name in available tithis
          for (final availableTithi in _availableTithis) {
            if (entry.value.any(
              (v) => availableTithi.toLowerCase().contains(v.toLowerCase()),
            )) {
              return availableTithi;
            }
          }
        }
      }
    }

    // Partial match
    for (final tithi in _availableTithis) {
      if (tithi.toLowerCase().contains(lowerSearch)) {
        return tithi;
      }
    }

    return null;
  }

  Future<void> _searchTithi(String tithi) async {
    if (widget.latitude == null || widget.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a city first")),
      );
      return;
    }

    // Find the matching tithi from server
    final matchingTithi = _findMatchingTithi(tithi);

    if (matchingTithi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not find tithi matching '$tithi'")),
      );
      return;
    }

    try {
      setState(() => _isSearching = true);
      final result = await widget.service.searchTithiDates(
        matchingTithi,
        widget.latitude!,
        widget.longitude!,
      );
      setState(() => _searchResult = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error searching tithi: $e")));
      }
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _setAlarmForAllDates() async {
    if (_searchResult == null || _searchResult!.dates.isEmpty) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    int successCount = 0;

    for (final tithiDate in _searchResult!.dates) {
      try {
        final alarmDateTime = DateTime(
          tithiDate.dateTime.year,
          tithiDate.dateTime.month,
          tithiDate.dateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Skip past dates
        if (alarmDateTime.isBefore(DateTime.now())) continue;

        final id =
            tithiDate.dateTime.year * 10000 +
            tithiDate.dateTime.month * 100 +
            tithiDate.dateTime.day;

        final alarmSettings = AlarmSettings(
          id: id,
          dateTime: alarmDateTime,
          assetAudioPath: 'assets/alarm.mp3',
          loopAudio: true,
          vibrate: true,
          volume: 0.8,
          fadeDuration: 3.0,
          notificationTitle: 'Tithi Reminder',
          notificationBody:
              '${TransliterationService.toHindiTransliteration(_searchResult!.tithi)} on ${tithiDate.date}',
          enableNotificationOnKill: true,
        );

        await Alarm.set(alarmSettings: alarmSettings);

        // Save tithi info
        if (widget.onAlarmSet != null) {
          widget.onAlarmSet!(
            id,
            TransliterationService.toHindiTransliteration(_searchResult!.tithi),
          );
        }

        successCount++;
      } catch (e) {
        print("Error setting alarm for ${tithiDate.date}: $e");
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Set $successCount alarms for ${TransliterationService.toHindiTransliteration(_searchResult!.tithi)} at ${pickedTime.format(context)}",
          ),
        ),
      );

      // Notify HomePage to reload alarms
      if (widget.onAlarmsUpdated != null) {
        widget.onAlarmsUpdated!();
      }
    }
  }

  Future<void> _setAlarmForSpecificDate(TithiDate tithiDate) async {
    final dateTime = tithiDate.dateTime;

    // Check if date is in the past
    if (dateTime.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot set alarm for past dates")),
      );
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    try {
      final alarmDateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Double check alarm time is not in the past
      if (alarmDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot set alarm for past time")),
        );
        return;
      }

      final id = dateTime.year * 10000 + dateTime.month * 100 + dateTime.day;

      final alarmSettings = AlarmSettings(
        id: id,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationTitle: 'Tithi Reminder',
        notificationBody:
            '${TransliterationService.toHindiTransliteration(_searchResult!.tithi)} on ${tithiDate.date}',
        enableNotificationOnKill: true,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      // Save tithi info
      if (widget.onAlarmSet != null) {
        widget.onAlarmSet!(
          id,
          TransliterationService.toHindiTransliteration(_searchResult!.tithi),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Alarm set for ${pickedTime.format(context)} on ${tithiDate.date}",
            ),
          ),
        );

        // Notify HomePage to reload alarms
        if (widget.onAlarmsUpdated != null) {
          widget.onAlarmsUpdated!();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error setting alarm: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.search, color: AppColors.pumpkin),
                const SizedBox(width: 8),
                const Text(
                  "Search Tithi Dates",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tithi Search Input
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              TypeAheadField<String>(
                controller: _searchController,
                builder: (context, controller, focusNode) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: "Search for a Tithi",
                      hintText: "e.g., Purnima, Amavasya, Ekadashi, Chaturthi",
                      border: const OutlineInputBorder(),
                      suffixIcon: _isSearching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  _searchTithi(controller.text);
                                }
                              },
                            ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _searchTithi(value);
                      }
                    },
                  );
                },
                suggestionsCallback: (pattern) {
                  if (pattern.isEmpty) return [];

                  // Create a set of all variations and available tithis
                  Set<String> allSuggestions = {};

                  // Add available tithis
                  allSuggestions.addAll(_availableTithis);

                  // Add variations
                  for (final variations in tithiVariations.values) {
                    allSuggestions.addAll(variations);
                  }

                  return allSuggestions
                      .where(
                        (tithi) =>
                            tithi.toLowerCase().contains(pattern.toLowerCase()),
                      )
                      .take(8)
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                    leading: const Icon(Icons.calendar_today, size: 16),
                  );
                },
                onSelected: (suggestion) {
                  _searchController.text = suggestion;
                  _searchTithi(suggestion);
                },
              ),

            // Search Results
            if (_searchResult != null) ...[
              const SizedBox(height: 16),
              const Divider(),

              // Results Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "Results for \"${TransliterationService.toHindiTransliteration(_searchResult!.tithi)}\"",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.pennRed,
                      ),
                    ),
                  ),
                  Text(
                    "${_searchResult!.totalMatches} dates",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Set Alarm for All Button
              if (_searchResult!.dates.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.alarm_add),
                    label: const Text("Set Alarm for All Dates"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pumpkin,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _setAlarmForAllDates,
                  ),
                ),

              const SizedBox(height: 12),

              // Results List
              if (_searchResult!.dates.isEmpty)
                const Center(
                  child: Text(
                    "No dates found for this tithi in the current year.",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _searchResult!.dates.length,
                    itemBuilder: (context, index) {
                      final tithiDate = _searchResult!.dates[index];
                      final dateTime = tithiDate.dateTime;
                      final isPast = dateTime.isBefore(DateTime.now());

                      return ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: isPast
                              ? Colors.grey
                              : AppColors.pumpkin,
                          child: Text(
                            dateTime.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          tithiDate.date,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isPast ? Colors.grey : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "${TransliterationService.toHindiTransliteration(tithiDate.paksha)} • ${TransliterationService.toHindiTransliteration(tithiDate.nakshatra)}",
                          style: TextStyle(
                            fontSize: 12,
                            color: isPast ? Colors.grey : Colors.black54,
                          ),
                        ),
                        trailing: isPast
                            ? const Icon(
                                Icons.history,
                                color: Colors.grey,
                                size: 16,
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.alarm_add,
                                  color: AppColors.pumpkin,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _setAlarmForSpecificDate(tithiDate),
                                tooltip: 'Set alarm for this date',
                              ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
