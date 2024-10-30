import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/widgets/subject_card.dart';
import 'package:timetable_generation_application/widgets/shimmer_loading.dart';
import 'package:timetable_generation_application/widgets/subject_fab.dart';
import '../constants/app_texts.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_appbar.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.subjectScreenTitle),
      ),
      floatingActionButton: const SubjectFAB(),
      body: Consumer<SubjectProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const CourseShimmer();
          } else if (provider.errorMessage != null) {
            return const Center(child: Text(AppTexts.error));
          } else if (provider.subjects.isEmpty) {
            return const Center(child: Text(AppTexts.noSubjectsAvailable));
          }

          return ListView.builder(
            itemCount: provider.subjects.length,
            itemBuilder: (context, index) {
              return SubjectCard(subject: provider.subjects[index]);
            },
          );
        },
      ),
    );
  }
}
