import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_texts.dart';
import '../constants/contants.dart';
import '../providers/course_provider.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_popup.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.subjectScreenTitle),
      ),
      floatingActionButton: FloatingActionButton(
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
                title: 'Add Subject',
                fields: [
                  TextField(
                    controller: subjectNameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
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
                            labelText: 'Select Course',
                            border: OutlineInputBorder(),
                          ),
                          value: null,
                          items: [],
                          hint: const Text('Loading...'),
                          onChanged: null, // Disable onChanged while loading
                        );
                      } else if (snapshot.hasError) {
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Course',
                            border: OutlineInputBorder(),
                          ),
                          value: null,
                          items: [],
                          hint: Text('Error: ${snapshot.error}'),
                          onChanged: null, // Disable onChanged on error
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select Course',
                            border: OutlineInputBorder(),
                          ),
                          value: null,
                          items: [],
                          hint: const Text('No courses available'),
                          onChanged: null, // Disable onChanged if no courses
                        );
                      }

                      final courses = snapshot.data!;

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Course',
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
                          selectedCourseName = courses
                              .firstWhere((course) => course['id'] == newValue)['name']; // Get the name of the selected course
                        },
                      );
                    },
                  ),
                ],
                onSave: () {
                  if (subjectNameController.text.isNotEmpty && selectedCourseId != null) {
                    Provider.of<SubjectProvider>(context, listen: false)
                        .addSubject(selectedCourseId!); // Pass the selected course ID
                    log(subjectNameController.text);
                  }
                  Navigator.of(context).pop();
                },
                onClose: () => Navigator.of(context).pop(),
              );
            },
          );
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          color: Colors.white,
        ),
      ),
      body: const Center(
        child: Text('Subjects'),
      ),
    );
  }
}
