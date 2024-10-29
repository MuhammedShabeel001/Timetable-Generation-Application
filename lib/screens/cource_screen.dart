import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/widgets/course_fab.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/transition_card.dart';

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
    body: 
    FutureBuilder<void>(
        future: courseProvider.fetchCourses(), // Adjust the Future type here
        builder: (context, snapshot) {
          if (courseProvider.isLoading) {
            // return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (courseProvider.courses.isEmpty) {
            return const Center(child: Text('No courses available'));
          }

          final courses = courseProvider.courses;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: courses[index]);
            },
          );
        },
      ),
    );
  
}
}
