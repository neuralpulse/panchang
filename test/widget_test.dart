import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hindu_cal/main.dart';
import 'package:hindu_cal/services/panchang_service.dart';
import 'package:hindu_cal/widgets/calendar_widget.dart';
import 'package:hindu_cal/widgets/date_details_widget.dart';

void main() {
  late PanchangService service;

  setUp(() {
    service = PanchangService();
  });

  testWidgets('Calendar widget renders and selects a date', (
    WidgetTester tester,
  ) async {
    // Wrap MyApp with the PanchangService
    await tester.pumpWidget(
      MaterialApp(
        home: MyApp(), // PanchangService is injected inside MyApp
      ),
    );

    // Wait for initial build
    await tester.pumpAndSettle();

    // Verify that CalendarWidget is present
    expect(find.byType(CalendarWidget), findsOneWidget);

    // Tap on a date (e.g., 1st of current month)
    final firstDate = find.text('1').first;
    await tester.tap(firstDate);
    await tester.pumpAndSettle();

    // Since the Panchang is fetched dynamically, we can't check tithi/karna directly.
    // Instead, verify that DateDetailsWidget is displayed
    expect(find.byType(DateDetailsWidget), findsOneWidget);
  });
}
