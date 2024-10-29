import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/widgets/course_fab.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/Course_card.dart';
import '../widgets/shimmer_loading.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.courseScreenTitle),
      ),
      floatingActionButton: const CourseFAB(),
      body: Consumer<CourseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return CourseShimmer();
          } else if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.courses.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          return ListView.builder(
            itemCount: provider.courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: provider.courses[index]);
            },
          );
        },
      ),
    );
  }
}
