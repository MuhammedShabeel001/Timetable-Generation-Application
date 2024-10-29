import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/course_model.dart';

class CourseProvider with ChangeNotifier {
  void addCourse() {
    final String courseName = courseNameController.text;
    final String description = descriptionController.text;

    // Create a new Course instance
    Course newCourse = Course(
      id: UniqueKey().toString(),
      name: courseName,
      subjectIds: [], // Initialize as empty; will be updated later
      description: description,
    );

    // Add course to Firestore
    firestore.collection('courses').add(newCourse.toMap()).then((docRef) {
      // Update course with current subject IDs that match the new course ID
      updateCourseWithSubjects(docRef.id);
      clearControllers();
    });

    notifyListeners();
  }

  /// Updates the course document to include the current subjects' IDs.
  void updateCourseWithSubjects(String courseId) async {
    QuerySnapshot subjectsSnapshot = await firestore
        .collection('subjects')
        .where('courseId', isEqualTo: courseId)
        .get();

    List<String> subjectIds = subjectsSnapshot.docs.map((doc) => doc.id).toList();

    firestore.collection('courses').doc(courseId).update({
      'subjectIds': subjectIds,
    });
  }

  // Fetch course suggestions based on the input pattern
Future<List<Map<String, String>>> getCourseSuggestions(String query) async {
  try {
    QuerySnapshot snapshot = await firestore
        .collection('courses')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    // Extract course IDs and names from the fetched documents
    List<Map<String, String>> courseData = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] as String,
      };
    }).toList();

    return courseData;
  } catch (e) {
    print("Error fetching course suggestions: $e");
    return [];
  }
}


  void clearControllers() {
    courseNameController.clear();
    descriptionController.clear();
  }
}
