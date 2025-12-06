import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import '../models/panchang_day.dart';
import '../services/panchang_service.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/date_details_widget.dart';
import '../widgets/tithi_search_widget.dart';
import '../app_theme.dart';
import 'alarm_ring_page.dart';

class HomePage extends StatefulWidget {
  final PanchangService service;

  const HomePage({super.key, required this.service});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime currentMonth = DateTime.now();
  PanchangDay? selectedDay;
  bool isLoading = false;
  List<AlarmSettings> _alarms = [];

  String? selectedCity;
  bool _isCachingYear = false;

  final List<String> months = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final Map<String, Map<String, double>> cities = {
    "Agartala": {"lat": 23.8315, "lng": 91.2868},
    "Agra": {"lat": 27.1767, "lng": 78.0081},
    "Ahmedabad": {"lat": 23.0225, "lng": 72.5714},
    "Bangalore": {"lat": 12.9716, "lng": 77.5946},
    "Haldwani": {"lat": 29.2180, "lng": 79.5120},
    "Howrah": {"lat": 22.5958, "lng": 88.2636},
    "Hubli": {"lat": 15.3647, "lng": 75.1240},
    "Hyderabad": {"lat": 17.3850, "lng": 78.4867},
    "Imphal": {"lat": 24.8170, "lng": 93.9368},
    "Indore": {"lat": 22.7196, "lng": 75.8577},
    "Itanagar": {"lat": 27.0940, "lng": 93.6098},
    "Jabalpur": {"lat": 23.1815, "lng": 79.9864},
    "Jaipur": {"lat": 26.9124, "lng": 75.7873},
    "Jalandhar": {"lat": 31.3260, "lng": 75.5762},
    "Jammu": {"lat": 32.7266, "lng": 74.8570},
    "Jamshedpur": {"lat": 22.8046, "lng": 86.2029},
    "Jhansi": {"lat": 25.4484, "lng": 78.5685},
    "Jodhpur": {"lat": 26.2389, "lng": 73.0243},
    "Jorhat": {"lat": 26.7575, "lng": 94.2037},
    "Kanpur": {"lat": 26.4499, "lng": 80.3319},
    "Kavaratti": {"lat": 10.5667, "lng": 72.6333},
    "Kochi": {"lat": 9.9312, "lng": 76.2673},
    "Kohima": {"lat": 25.6747, "lng": 94.1107},
    "Kolkata": {"lat": 22.5726, "lng": 88.3639},
    "Kota": {"lat": 25.2138, "lng": 75.8648},
    "Kozhikode": {"lat": 11.2588, "lng": 75.7804},
    "Leh": {"lat": 34.1526, "lng": 77.5770},
    "Lucknow": {"lat": 26.8467, "lng": 80.9462},
    "Ludhiana": {"lat": 30.9010, "lng": 75.8573},
    "Madurai": {"lat": 9.9252, "lng": 78.1198},
    "Mangalore": {"lat": 12.9141, "lng": 74.8560},
    "Meerut": {"lat": 28.9845, "lng": 77.7064},
    "Moradabad": {"lat": 28.8386, "lng": 78.7733},
    "Mumbai": {"lat": 19.0760, "lng": 72.8777},
    "Mysore": {"lat": 12.2958, "lng": 76.6394},
    "Nagpur": {"lat": 21.1458, "lng": 79.0882},
    "Nainital": {"lat": 29.3803, "lng": 79.4630},
    "Nashik": {"lat": 19.9975, "lng": 73.7898},
    "Noida": {"lat": 28.5355, "lng": 77.3910},
    "Panaji": {"lat": 15.4909, "lng": 73.8278},
    "Patna": {"lat": 25.5941, "lng": 85.1376},
    "Port Blair": {"lat": 11.6234, "lng": 92.7265},
    "Prayagraj": {"lat": 25.4358, "lng": 81.8463},
    "Puducherry": {"lat": 11.9161, "lng": 79.8123},
    "Pune": {"lat": 18.5204, "lng": 73.8567},
    "Raipur": {"lat": 21.2514, "lng": 81.6299},
    "Rajkot": {"lat": 22.3039, "lng": 70.8022},
    "Rampur": {"lat": 28.8090, "lng": 79.0290},
    "Ranchi": {"lat": 23.3441, "lng": 85.3096},
    "Rourkela": {"lat": 22.2608, "lng": 84.8536},
    "Salem": {"lat": 11.6643, "lng": 78.1460},
    "Shillong": {"lat": 25.5788, "lng": 91.8933},
    "Shimla": {"lat": 31.1048, "lng": 77.1734},
    "Siliguri": {"lat": 26.7271, "lng": 88.3953},
    "Silvassa": {"lat": 20.2757, "lng": 72.9957},
    "Srinagar": {"lat": 34.0837, "lng": 74.7973},
    "Surat": {"lat": 21.1702, "lng": 72.8311},
    "Thane": {"lat": 19.2183, "lng": 72.9781},
    "Thiruvananthapuram": {"lat": 8.5241, "lng": 76.9366},
    "Udaipur": {"lat": 24.5854, "lng": 73.7125},
    "Udupi": {"lat": 13.3409, "lng": 74.7421},
    "Vadodara": {"lat": 22.3072, "lng": 73.1812},
    "Varanasi": {"lat": 25.3176, "lng": 82.9739},
    "Vijayawada": {"lat": 16.5062, "lng": 80.6480},
    "Visakhapatnam": {"lat": 17.6868, "lng": 83.2185},
    "Vrindavan": {"lat": 27.5650, "lng": 77.6596},
  };

  @override
  void initState() {
    super.initState();
    _initializeAlarms();
  }

  Future<void> _initializeAlarms() async {
    _loadAlarms();

    Alarm.ringStream.stream.listen((alarmSettings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AlarmRingPage(alarmId: alarmSettings.id),
          fullscreenDialog: true,
        ),
      );
    });
  }

  void _loadAlarms() {
    setState(() {
      _alarms = Alarm.getAlarms() ?? [];
    });
  }

  Future<void> _fetchDayPanchang(DateTime date) async {
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a city first")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final coords = cities[selectedCity]!;
      final formattedDate =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final data = await widget.service.fetchPanchang(
        formattedDate,
        coords['lat']!,
        coords['lng']!,
      );

      setState(() {
        selectedDay = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching Panchang: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _setAlarmForDay(PanchangDay day, TimeOfDay time) async {
    final alarmDateTime = DateTime(
      day.year,
      day.month,
      day.dayNum,
      time.hour,
      time.minute,
    );

    final id = day.year * 10000 + day.month * 100 + day.dayNum;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: alarmDateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'Panchang Alarm',
      notificationBody: 'Reminder for ${day.dateKey} (${day.day})',
      enableNotificationOnKill: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);

    setState(() {
      _alarms.add(alarmSettings);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Alarm set for ${time.format(context)} on ${day.dateKey}",
        ),
      ),
    );
  }

  Future<void> _cacheYearData() async {
    if (selectedCity == null || _isCachingYear) return;

    final coords = cities[selectedCity]!;

    setState(() => _isCachingYear = true);

    try {
      await widget.service.cacheYearData(coords['lat']!, coords['lng']!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Started caching year data in background"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error caching data: $e")));
      }
    } finally {
      setState(() => _isCachingYear = false);
    }
  }

  void _showAlarmsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alarms"),
        content: SizedBox(
          width: double.maxFinite,
          child: _alarms.isEmpty
              ? const Text("No alarms set.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = _alarms[index];
                    return ListTile(
                      title: Text(
                        "${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')} on ${alarm.dateTime.day}-${alarm.dateTime.month}-${alarm.dateTime.year}",
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await Alarm.stop(alarm.id);
                          setState(() {
                            _alarms.removeAt(index);
                          });
                          Navigator.pop(context);
                          _showAlarmsDialog();
                        },
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  // ===================== Tithi Search Bottom Sheet =====================
  void _showTithiSearchDialog() {
    if (selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a city first")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TithiSearchWidget(
            service: widget.service,
            latitude: cities[selectedCity]!['lat'],
            longitude: cities[selectedCity]!['lng'],
            onAlarmsUpdated: _loadAlarms,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.pumpkin,
        title: const Text(
          "Panchang",
          style: TextStyle(
            color: AppColors.bgLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: AppColors.bgLight,
            onPressed: _showTithiSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _showAlarmsDialog,
            color: AppColors.bgLight,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // City Selector
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select a city",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return cities.keys.where(
                          (city) => city.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        );
                      },
                      onSelected: (city) {
                        setState(() {
                          selectedCity = city;
                          selectedDay = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("City set to $city. Select a date!"),
                          ),
                        );
                        _cacheYearData();
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelText: "Search City",
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Month and Year Selector
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month - 1,
                            1,
                          );
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: months[currentMonth.month - 1],
                        underline: const SizedBox(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        items: months
                            .map(
                              (m) => DropdownMenuItem(value: m, child: Text(m)),
                            )
                            .toList(),
                        onChanged: (newMonth) {
                          if (newMonth != null) {
                            setState(() {
                              int monthIndex = months.indexOf(newMonth) + 1;
                              currentMonth = DateTime(
                                currentMonth.year,
                                monthIndex,
                                1,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<int>(
                        value: currentMonth.year,
                        underline: const SizedBox(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        items: List.generate(100, (index) {
                          int year = DateTime.now().year - 15 + index;
                          return DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          );
                        }),
                        onChanged: (newYear) {
                          if (newYear != null) {
                            setState(() {
                              currentMonth = DateTime(
                                newYear,
                                currentMonth.month,
                                1,
                              );
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          currentMonth = DateTime(
                            currentMonth.year,
                            currentMonth.month + 1,
                            1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Calendar
            CalendarWidget(
              focusedMonth: currentMonth,
              service: widget.service,
              selectedDay: selectedDay,
              onDateSelected: (day) {
                _fetchDayPanchang(DateTime(day.year, day.month, day.dayNum));
              },
            ),

            const SizedBox(height: 12),

            // Panchang Details + Alarm
            if (isLoading)
              const CircularProgressIndicator()
            else if (selectedDay != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      DateDetailsWidget(day: selectedDay),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.alarm),
                        label: const Text("Set Alarm"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pumpkin,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            await _setAlarmForDay(selectedDay!, pickedTime);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                "Select a date to view Panchang",
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}
