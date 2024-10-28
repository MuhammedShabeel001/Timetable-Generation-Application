// widgets/custom_bottomsheet.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';

class CustomBottomsheet extends StatelessWidget {
  final Function() onClose;

  const CustomBottomsheet({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Course',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: courseProvider.courseNameController,
                decoration: InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                minLines: 1,
                controller: courseProvider.descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (courseProvider.courseNameController.text.isNotEmpty &&
                      courseProvider.descriptionController.text.isNotEmpty) {
                    courseProvider.addCourse();
                    log(courseProvider.courseNameController.text);
                    onClose(); // Close the bottom sheet
                  }
                },
                child: const Text('ADD COURSE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
