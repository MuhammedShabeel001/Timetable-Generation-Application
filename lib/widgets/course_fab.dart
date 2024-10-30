import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import '../constants/app_colors.dart';
import '../constants/contants.dart';
import '../providers/course_provider.dart';
import '../widgets/custom_popup.dart';
import 'custom_snackbar.dart';

class CourseFAB extends StatelessWidget {
  const CourseFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => CustomPopup(
            title: AppTexts.addCourse,
            fields: [
              TextField(
                controller: courseNameController,
                decoration: const InputDecoration(
                  labelText: AppTexts.courseName,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: AppTexts.courseDescription,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
            onSave: () {
              if (courseNameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                Provider.of<CourseProvider>(context, listen: false).addCourse();
                log(courseNameController.text);
              }
              Navigator.of(context).pop();
              CustomSnackBar.show(
                  context: context,
                  message: 'New course added',
                  backgroundColor:
                      AppColors.success // Optional custom background color
                  );
            },
            onClose: () => Navigator.of(context).pop(),
          ),
        );
      },
      child: const FaIcon(
        FontAwesomeIcons.plus,
        color: AppColors.background,
      ),
    );
  }
}
