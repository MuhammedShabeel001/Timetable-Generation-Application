import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timetable_provider.dart';

void showEditDialog(BuildContext context, int day, int period, Map<String, String> cell) {
  final subjectController = TextEditingController(text: cell['subject']);
  final staffController = TextEditingController(text: cell['staff']);

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
              Provider.of<TimetableProvider>(context, listen: false).editCell(
                day,
                period,
                subjectController.text,
                staffController.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
