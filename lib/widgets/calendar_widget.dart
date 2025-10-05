import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/panchang_day.dart';
import '../services/panchang_service.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedMonth;
  final Function(PanchangDay) onDateSelected;
  final PanchangService service;
  final PanchangDay? selectedDay;

  const CalendarWidget({
    super.key,
    required this.focusedMonth,
    required this.onDateSelected,
    required this.service,
    this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateUtils.getDaysInMonth(
      focusedMonth.year,
      focusedMonth.month,
    );
    DateTime firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    int startingWeekday = firstDay.weekday; // Monday = 1

    List<Widget> dayWidgets = [];

    // Add empty placeholders for start
    for (int i = 1; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Fill days
    for (int day = 1; day <= daysInMonth; day++) {
      String dateString =
          '${focusedMonth.year}-${focusedMonth.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      bool isSelected =
          selectedDay != null &&
          selectedDay!.year == focusedMonth.year &&
          selectedDay!.month == focusedMonth.month &&
          selectedDay!.dayNum == day;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            PanchangDay tempDay = PanchangDay(
              dateKey: dateString,
              day: '',
              year: focusedMonth.year,
              month: focusedMonth.month,
              dayNum: day,
            );

            onDateSelected(tempDay);
          },

          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors
                        .pennRed // highlight selected date
                  : AppColors.pumpkin.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }
}
