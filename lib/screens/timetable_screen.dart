// lib/screens/timetable_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/subject_model.dart';
import '../providers/timetable_provider.dart';
// import '../models/timetable_provider.dart';
// import '../models/subject.dart';

class TimetableScreen extends StatelessWidget {
  final List<Subject> subjects = [
    Subject(id: '1', name: 'Math', courseId: 'course_001'),
    Subject(id: '2', name: 'Science', courseId: 'course_001'),
    Subject(id: '3', name: 'English', courseId: 'course_001'),
    Subject(id: '4', name: 'History', courseId: 'course_001'),
    Subject(id: '5', name: 'Geography', courseId: 'course_001'),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimetableProvider(subjects, '1', 'Weekly Timetable', 'course_001'),
      child: Scaffold(
        appBar: AppBar(title: const Text('Timetable')),
        body: Consumer<TimetableProvider>(
          builder: (context, timetableProvider, _) {
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: timetableProvider.periods.length,
                    ),
                    itemCount: timetableProvider.days.length * timetableProvider.periods.length,
                    itemBuilder: (context, index) {
                      int dayIndex = index ~/ timetableProvider.periods.length;
                      int periodIndex = index % timetableProvider.periods.length;
                      var cell = timetableProvider.timetable[dayIndex][periodIndex];

                      return GestureDetector(
                        onTap: () {
                          _showEditDialog(context, dayIndex, periodIndex);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cell.subject.isEmpty ? 'Empty' : cell.subject),
                              Text(cell.staff.isEmpty ? 'No Staff' : cell.staff),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        timetableProvider.generateTimetable(subjects);
                      },
                      child: const Text('Generate Timetable'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Save functionality can be implemented here
                      },
                      child: const Text('Save Timetable'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int dayIndex, int periodIndex) {
    final timetableProvider = Provider.of<TimetableProvider>(context, listen: false);
    TextEditingController subjectController = TextEditingController();
    TextEditingController staffController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Timetable Cell'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: staffController,
                decoration: const InputDecoration(labelText: 'Staff'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String subject = subjectController.text;
                String staff = staffController.text;
                timetableProvider.updateCell(dayIndex, periodIndex, subject, staff);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
