import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/panchang_day.dart';
import '../services/panchang_service.dart';
import '../services/transliteration_service.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime focusedMonth;
  final Function(PanchangDay) onDateSelected;
  final PanchangService service;
  final PanchangDay? selectedDay;
  final double latitude;
  final double longitude;

  const CalendarWidget({
    super.key,
    required this.focusedMonth,
    required this.onDateSelected,
    required this.service,
    required this.latitude,
    required this.longitude,
    this.selectedDay,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  Map<String, String> _tithiCache = {};
  bool _isLoadingTithis = false;

  @override
  void initState() {
    super.initState();
    _loadMonthTithis();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusedMonth != widget.focusedMonth ||
        oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _tithiCache.clear();
      _loadMonthTithis();
    }
  }

  Future<void> _loadMonthTithis() async {
    if (_isLoadingTithis) return;

    setState(() => _isLoadingTithis = true);

    int daysInMonth = DateUtils.getDaysInMonth(
      widget.focusedMonth.year,
      widget.focusedMonth.month,
    );

    // Load tithis for all days in background
    for (int day = 1; day <= daysInMonth; day++) {
      String dateString =
          '${widget.focusedMonth.year}-${widget.focusedMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      try {
        final data = await widget.service.fetchPanchang(
          dateString,
          widget.latitude,
          widget.longitude,
        );

        if (mounted) {
          setState(() {
            _tithiCache[dateString] =
                TransliterationService.toHindiTransliteration(data.tithi ?? '');
          });
        }
      } catch (e) {
        // Silently fail for individual dates
        print("Error loading tithi for $dateString: $e");
      }
    }

    setState(() => _isLoadingTithis = false);
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateUtils.getDaysInMonth(
      widget.focusedMonth.year,
      widget.focusedMonth.month,
    );
    DateTime firstDay = DateTime(
      widget.focusedMonth.year,
      widget.focusedMonth.month,
      1,
    );
    int startingWeekday = firstDay.weekday; // Monday = 1

    List<Widget> dayWidgets = [];

    // Day headers
    const dayHeaders = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<Widget> headerWidgets = dayHeaders
        .map(
          (day) => Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: AppColors.pennRed,
              ),
            ),
          ),
        )
        .toList();

    // Add empty placeholders for start
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Fill days
    for (int day = 1; day <= daysInMonth; day++) {
      String dateString =
          '${widget.focusedMonth.year}-${widget.focusedMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      bool isSelected =
          widget.selectedDay != null &&
          widget.selectedDay!.year == widget.focusedMonth.year &&
          widget.selectedDay!.month == widget.focusedMonth.month &&
          widget.selectedDay!.dayNum == day;

      final tithi = _tithiCache[dateString] ?? '';

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            PanchangDay tempDay = PanchangDay(
              dateKey: dateString,
              day: '',
              year: widget.focusedMonth.year,
              month: widget.focusedMonth.month,
              dayNum: day,
            );
            widget.onDateSelected(tempDay);
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.pennRed
                  : AppColors.pumpkin.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (tithi.isNotEmpty)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        tithi,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.white.withOpacity(0.9)
                              : AppColors.black.withOpacity(0.7),
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                else if (_isLoadingTithis)
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: SizedBox(
                        width: 8,
                        height: 8,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Day headers
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: headerWidgets,
        ),
        // Calendar grid
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.75,
          children: dayWidgets,
        ),
      ],
    );
  }
}
