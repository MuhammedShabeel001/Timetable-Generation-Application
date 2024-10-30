import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import '../constants/app_colors.dart';
import '../constants/contants.dart';
import '../providers/course_provider.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_popup.dart';
import 'custom_snackbar.dart';

class SubjectFAB extends StatelessWidget {
  const SubjectFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        // Fetch course suggestions and display them in the dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            // Create a local state for the selected course
            String? selectedCourseId;
            String? selectedCourseName;

            return CustomPopup(
              title: AppTexts.addSubject,
              fields: [
                TextField(
                  controller: subjectNameController,
                  decoration: const InputDecoration(
                    labelText: AppTexts.subjectName,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, String>>>(
                  future: Provider.of<CourseProvider>(context, listen: false)
                      .getCourseSuggestions(''), // Fetch all courses
                  builder: (context, snapshot) {
                    // Handle loading state in the dropdown
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: AppTexts.selectCourse,
                          border: OutlineInputBorder(),
                        ),
                        value: null,
                        items: const [],
                        hint: const Text(AppTexts.loading),
                        onChanged: null, // Disable onChanged while loading
                      );
                    } else if (snapshot.hasError) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: AppTexts.selectCourse,
                          border: OutlineInputBorder(),
                        ),
                        value: null,
                        items: const [],
                        hint: const Text(AppTexts.errorOccurred),
                        onChanged: null, // Disable onChanged on error
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: AppTexts.selectCourse,
                          border: OutlineInputBorder(),
                        ),
                        value: null,
                        items: const [],
                        hint: const Text(AppTexts.noCoursesAvailable),
                        onChanged: null, // Disable onChanged if no courses
                      );
                    }

                    final courses = snapshot.data!;

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: AppTexts.selectCourse,
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCourseName,
                      items: courses.take(5).map((Map<String, String> course) {
                        return DropdownMenuItem<String>(
                          value: course['id'], // Use course ID as the value
                          child: Text(course['name'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCourseId = newValue;
                        selectedCourseName = courses.firstWhere(
                                (course) => course['id'] == newValue)[
                            'name']; // Get the name of the selected course
                      },
                    );
                  },
                ),
              ],
              onSave: () {
                if (subjectNameController.text.isNotEmpty &&
                    selectedCourseId != null) {
                  Provider.of<SubjectProvider>(context, listen: false)
                      .addSubject(
                          selectedCourseId!); // Pass the selected course ID
                  log(subjectNameController.text);
                }
                Navigator.of(context).pop();
                CustomSnackBar.show(
                  context: context,
                  message: 'New Subject Added',
                  backgroundColor: AppColors.success // Optional custom background color
                );
              },
              onClose: () => Navigator.of(context).pop(),
            );
          },
        );
      },
      child: const FaIcon(
        FontAwesomeIcons.plus,
        color: AppColors.cardBackground,
      ),
    );
  }
}
