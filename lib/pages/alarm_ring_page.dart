import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class AlarmRingPage extends StatelessWidget {
  final int alarmId;

  const AlarmRingPage({super.key, required this.alarmId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.alarm, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Alarm Ringing!",
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await Alarm.stop(alarmId); // stop the alarm
                Navigator.pop(context); // close the full-screen page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
              ),
              child: const Text("Stop Alarm", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
