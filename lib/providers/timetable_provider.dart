import 'package:flutter/material.dart';
import '../repositories/timetable_generator.dart';
// import 'timetable_generator.dart'; // Ensure to import your generator

class TimetableProvider with ChangeNotifier {
  List<List<Map<String, String>>> _timetable = [];
  bool _loading = false;

  List<List<Map<String, String>>> get timetable => _timetable;
  bool get loading => _loading;

  Future<void> generateTimetable() async {
    _loading = true; // Set loading to true
    notifyListeners(); // Notify listeners to rebuild the UI

    TimetableGenerator generator = TimetableGenerator();
    _timetable = await generator.generateTimetable();

    _loading = false; // Set loading to false
    notifyListeners(); // Notify listeners again to update the UI
  }

  void editCell(int day, int period, String subject, String staff) {
    _timetable[day][period] = {
      'subject': subject,
      'staff': staff,
    };
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
