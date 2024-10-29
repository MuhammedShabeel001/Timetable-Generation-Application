import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/models/subject_model.dart';
import 'package:timetable_generation_application/providers/subject_provider.dart';
import 'package:timetable_generation_application/widgets/Subject_card.dart';
import 'package:timetable_generation_application/widgets/shimmer_loading.dart';
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
      body: Consumer<SubjectProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return CourseShimmer();
          } else if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.subjects.isEmpty) {
            return const Center(child: Text('No subject available'));
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
