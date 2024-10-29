import 'package:flutter/material.dart';
import 'package:timetable_generation_application/widgets/subject_fab.dart';
import '../constants/app_texts.dart';
import '../widgets/custom_appbar.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.subjectScreenTitle),
      ),
      floatingActionButton: SubjectFAB(),
      body: Center(
        child: Text('Subjects'),
      ),
    );
  }
}
