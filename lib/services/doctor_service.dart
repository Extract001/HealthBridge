import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/doctor_model.dart';

class DoctorService {
  static Future<List<DoctorModel>> getDoctors() async {
    final String response = await rootBundle.loadString('assets/data/doctors.json');
    final List<dynamic> data = json.decode(response);
    final DateTime now = DateTime.now();

    return data.map((jsonItem) {
      final docMap = Map<String, dynamic>.from(jsonItem as Map);
      final String nextSlotStr = docMap['nextSlot'] as String? ?? "";

      // Extract target weekday and time from nextSlot string, e.g. "Available this Friday at 10:30 AM"
      String targetDayName = "";
      String targetTime = "09:00 AM";

      if (nextSlotStr.contains(" at ")) {
        final parts = nextSlotStr.split(" at ");
        targetTime = parts.last.trim();
        final dayPart = parts.first.replaceAll("Available", "").replaceAll("this", "").trim();
        targetDayName = dayPart;
      }

      // Map day name to target DateTime starting from today/tomorrow
      int daysAhead = 1;
      if (targetDayName.isNotEmpty) {
        final Map<String, int> weekdayMap = {
          "Monday": DateTime.monday,
          "Tuesday": DateTime.tuesday,
          "Wednesday": DateTime.wednesday,
          "Thursday": DateTime.thursday,
          "Friday": DateTime.friday,
          "Saturday": DateTime.saturday,
          "Sunday": DateTime.sunday,
        };

        final targetWeekday = weekdayMap[targetDayName];
        if (targetWeekday != null) {
          daysAhead = (targetWeekday - now.weekday + 7) % 7;
          if (daysAhead == 0) daysAhead = 7; // Next week if today
        }
      }

      final DateTime firstAvailableDate = now.add(Duration(days: daysAhead));

      final List<Map<String, dynamic>> dynamicDates = [];
      for (int i = 0; i < 3; i++) {
        final date = firstAvailableDate.add(Duration(days: i * 2)); // e.g. Fri, Sun, Tue
        final dayOfWeek = DateFormat('EEE').format(date).toUpperCase();
        final dateFormatted = DateFormat('MMM dd').format(date).toUpperCase();

        List<String> slots;
        if (i == 0) {
          // First date contains the exact nextSlot time as the first slot!
          slots = [targetTime, _addHours(targetTime, 2), _addHours(targetTime, 4)];
        } else if (i == 1) {
          slots = ["09:00 AM", "11:30 AM", "03:00 PM"];
        } else {
          slots = ["10:00 AM", "01:30 PM", "04:30 PM"];
        }

        dynamicDates.add({
          "dayOfWeek": dayOfWeek,
          "dateFormatted": dateFormatted,
          "slots": slots,
        });
      }

      docMap['availableDates'] = dynamicDates;
      return DoctorModel.fromJson(docMap);
    }).toList();
  }

  static String _addHours(String timeStr, int hoursToAdd) {
    try {
      final DateFormat format = DateFormat("hh:mm a");
      final DateTime parsed = format.parse(timeStr);
      final DateTime updated = parsed.add(Duration(hours: hoursToAdd));
      return format.format(updated);
    } catch (_) {
      return "02:00 PM";
    }
  }
}
