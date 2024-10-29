// screens/course_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_colors.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/widgets/custom_popup.dart';
import '../constants/contants.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_appbar.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.courseScreenTitle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => CustomPopup(
              title: 'Add Course',
              fields: [
                TextField(
                  controller: courseNameController,
                  decoration: const InputDecoration(
                    labelText: 'Course Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
              onSave: () {
                if (courseNameController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  Provider.of<CourseProvider>(context, listen: false)
                      .addCourse();
                  log(courseNameController.text);
                }
                Navigator.of(context).pop();
              },
              onClose: () => Navigator.of(context).pop(),
            ),
          );
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: const Center(
        child: Text('Courses'),
      ),
    );
  }
}
