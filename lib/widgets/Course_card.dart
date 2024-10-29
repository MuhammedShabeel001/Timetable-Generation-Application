import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_colors.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import 'package:provider/provider.dart';
import 'custom_popup.dart'; // Adjust the import according to your file structure

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controllers for the text fields in the dialog
    final TextEditingController nameController = TextEditingController(text: course.name);
    final TextEditingController descriptionController = TextEditingController(text: course.description);

    return Card(
      elevation: 0,
      color: AppColors.accent,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
            Text(
              '${course.subjectIds.length} subjects', // Displaying the subject count
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(course.description, maxLines: 3, overflow: TextOverflow.ellipsis,),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Show the custom popup for editing course details
              showDialog(
                context: context,
                builder: (context) {
                  return CustomPopup(
                    title: 'Edit Course',
                    fields: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Course Name'),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                    ],
                    onSave: () {
                      // Call the provider method to update the course
                      Provider.of<CourseProvider>(context, listen: false).updateCourse(
                        course.id,
                        nameController.text,
                        descriptionController.text,
                      );
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    onClose: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  );
                },
              );
            } else if (value == 'remove') {
              // Show confirmation dialog before removing the course
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text('Are you sure you want to delete this course?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the provider method to remove the course
                          Provider.of<CourseProvider>(context, listen: false).removeCourse(course.id);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Delete'),
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
              child: Text('Edit'),
            ),
            const PopupMenuItem<String>(
              value: 'remove',
              child: Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}