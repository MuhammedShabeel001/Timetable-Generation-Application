import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/models/subject_model.dart';
import 'package:timetable_generation_application/providers/subject_provider.dart';
import 'package:timetable_generation_application/widgets/Subject_card.dart';
import 'package:timetable_generation_application/widgets/subject_fab.dart';
import '../constants/app_texts.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_appbar.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectProvider = Provider.of<SubjectProvider>(context);

    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.subjectScreenTitle),
      ),
      floatingActionButton: SubjectFAB(),
      body: FutureBuilder<void>(
        future: subjectProvider.fetchSubject(), // Adjust the Future type here
        builder: (context, snapshot) {
          if (subjectProvider.isLoading) {
            // return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (subjectProvider.subject.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final subject = subjectProvider.subject;
          return ListView.builder(
            itemCount: subject.length,
            itemBuilder: (context, index) {
              return SubjectCard(subject: subject[index]) ;
              // return CourseCard(course: courses[index]);
            },
          );
        },
      ),
    );
  }
}
