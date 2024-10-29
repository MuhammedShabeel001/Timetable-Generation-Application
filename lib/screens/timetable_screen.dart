import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timetable_provider.dart';

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Timetable Generation')),
      body: Column(
        children: [
          Expanded(
            child: timetableProvider.loading // Check the loading state
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : timetableProvider.timetable.isEmpty
                    ? Center(child: Text('No timetable generated.'))
                    : Table(
                        border: TableBorder.all(),
                        children: List.generate(5, (day) {
                          return TableRow(
                            children: List.generate(4, (period) {
                              final cell = timetableProvider.timetable[day][period];
                              return GestureDetector(
                                onTap: () => _showEditDialog(context, day, period, cell),
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        cell['subject'] ?? 'No Subject',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        cell['staff'] ?? 'No Staff',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => timetableProvider.generateTimetable(),
                child: Text('Generate Timetable'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement save functionality here
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Timetable Saved!')));
                },
                child: Text('Save Timetable'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, int day, int period, Map<String, String> cell) {
    final subjectController = TextEditingController(text: cell['subject']);
    final staffController = TextEditingController(text: cell['staff']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Timetable Cell'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextField(
                controller: staffController,
                decoration: InputDecoration(labelText: 'Staff'),
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
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
