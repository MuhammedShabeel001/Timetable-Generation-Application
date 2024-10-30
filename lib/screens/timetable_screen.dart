import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_texts.dart';
import '../providers/timetable_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/timetable_table.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.timetableScreenTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: timetableProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : timetableProvider.timetable.isEmpty
                      ? const Center(child: Text(AppTexts.noTimetableGenerated))
                      : TimetableTable(), // Extracted the table as a separate widget
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => timetableProvider.generateTimetable(context),
                  child: const Text(AppTexts.generate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
