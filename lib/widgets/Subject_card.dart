

import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_colors.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/models/subject_model.dart';
import 'package:timetable_generation_application/providers/subject_provider.dart';
import 'package:timetable_generation_application/providers/course_provider.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/widgets/custom_snackbar.dart';
import 'custom_popup.dart'; // Adjust the import according to your file structure

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    // Controllers for the text fields in the dialog
    final TextEditingController nameController =
        TextEditingController(text: subject.name);

    // Fetch the course name based on courseId
    final courseProvider = Provider.of<CourseProvider>(context);
    String courseName = courseProvider.getCourseNameById(
        subject.courseId); // Implement this method in CourseProvider

    return Card(
      elevation: 0,
      color: AppColors.accent,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(subject.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              courseName,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ), // Display the course name
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Show the custom popup for editing subject details
              showDialog(
                context: context,
                builder: (context) {
                  return CustomPopup(
                    title: AppTexts.editSubject,
                    fields: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            labelText: AppTexts.subjectName),
                      ),
                    ],
                    onSave: () {
                      // Call the provider method to update the subject
                      Provider.of<SubjectProvider>(context, listen: false)
                          .updateSubject(
                        subject.id,
                        nameController.text,
                      );
                      Navigator.of(context).pop();
                      CustomSnackBar.show(context: context, message: 'Updated subject',); // Close the dialog
                    },
                    onClose: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  );
                },
              );
            } else if (value == 'remove') {
              // Show confirmation dialog before removing the subject
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(AppTexts.confirmDelete),
                    content: const Text(AppTexts.confirmDeleteMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(AppTexts.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the provider method to remove the subject
                          Provider.of<SubjectProvider>(context, listen: false)
                              .removeSubject(subject.id);
                          Navigator.of(context).pop(); 
                          CustomSnackBar.show(context: context, message: 'Subject Removed',backgroundColor: AppColors.error);// Close the dialog
                        },
                        child: const Text(AppTexts.delete),
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text(AppTexts.edit),
            ),
            const PopupMenuItem<String>(
              value: 'remove',
              child: Text(AppTexts.delete),
            ),
          ],
        ),
      ),
    );
  }
}
