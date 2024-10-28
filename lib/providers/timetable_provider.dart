// lib/models/timetable_provider.dart
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/subject_model.dart';
import '../models/timetable_cell_model.dart';
import '../models/timetable_model.dart';
// import 'subject.dart';
// import 'staff.dart';
// import 'timetable_cell.dart';
// import 'timetable.dart';

class TimetableGenerator {
  final Random _random = Random();

  List<List<String>> generateTimetable(List<Subject> subjects) {
    List<List<String>> timetable = List.generate(5, (_) => List.filled(4, '', growable: false));

    for (int day = 0; day < 5; day++) {
      for (int period = 0; period < 4; period++) {
        final subject = subjects[_random.nextInt(subjects.length)];
        timetable[day][period] = subject.name;
      }
    }

    return timetable;
  }
}

class TimetableProvider with ChangeNotifier {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
  final List<String> periods = ["Period 1", "Period 2", "Period 3", "Period 4"];
  late List<List<TimetableCell>> timetable;
  final TimetableGenerator generator = TimetableGenerator();
  late Timetable timetableModel;

  TimetableProvider(List<Subject> subjects, String id, String name, String courseId) {
    timetable = List.generate(
      days.length,
      (_) => List.generate(periods.length, (_) => TimetableCell(subject: '', staff: '')),
    );

    timetableModel = Timetable(id: id, name: name, courseId: courseId);
    generateTimetable(subjects);
  }

  void generateTimetable(List<Subject> subjects) {
    List<List<String>> generatedTimetable = generator.generateTimetable(subjects);

    for (int day = 0; day < days.length; day++) {
      for (int period = 0; period < periods.length; period++) {
        timetable[day][period] = TimetableCell(subject: generatedTimetable[day][period], staff: '');
      }
    }
    notifyListeners();
  }

  void updateCell(int dayIndex, int periodIndex, String subject, String staff) {
    timetable[dayIndex][periodIndex] = TimetableCell(subject: subject, staff: staff);
    notifyListeners();
  }

  Timetable getTimetable() {
    return timetableModel;
  }
}
