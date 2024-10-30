
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimetableGenerator {
  final Random _random = Random();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<List<Map<String, String>>>> generateTimetable() async {
    final subjects = await _fetchSubjects();
    final timetable = List.generate(5, (_) => List.generate(4, (_) => {'subject': '', 'staff': ''}));

    for (int day = 0; day < 5; day++) {
      for (int period = 0; period < 4; period++) {
        final subject = subjects[_random.nextInt(subjects.length)];
        final staff = await _fetchStaffForSubject(subject['id']);
        
        timetable[day][period] = {
          'subject': subject['name'],
          'staff': staff.isNotEmpty ? staff[_random.nextInt(staff.length)]['name'] : 'N/A',
        };
      }
    }

    // Log the generated timetable for debugging
   debugPrint("Generated Timetable: $timetable");
    
    return timetable;
  }

  Future<List<Map<String, dynamic>>> _fetchSubjects() async {
    final snapshot = await _firestore.collection('subjects').get();
    return snapshot.docs.map((doc) => {'id': doc.id, 'name': doc['name']}).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchStaffForSubject(String subjectId) async {
    final snapshot = await _firestore.collection('staff').where('subjectIds', arrayContains: subjectId).get();
    final staffList = snapshot.docs.map((doc) => {'id': doc.id, 'name': doc['name']}).toList();

    // Debugging log to check if staff are being fetched correctly
    debugPrint('Fetched staff for subject ID $subjectId: $staffList');

    return staffList;
  }
}
