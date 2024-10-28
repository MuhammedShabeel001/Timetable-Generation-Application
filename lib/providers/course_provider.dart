// providers/course_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/course.dart';
import '../models/course_model.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void addCourse() {
    final String courseName = courseNameController.text;
    final String description = descriptionController.text;

    // Here you can create a new Course instance if needed
    List<String> subjectIds = []; // Logic to collect subject IDs
    Course newCourse = Course(id: UniqueKey().toString(), name: courseName, subjectIds: subjectIds);

    // Add to Firestore
    _firestore.collection('courses').add(newCourse.toMap()).then((_) {
      // Clear text fields after adding
      clearControllers();
    });

    notifyListeners();
  }

  void clearControllers() {
    courseNameController.clear();
    descriptionController.clear();
  }
}
