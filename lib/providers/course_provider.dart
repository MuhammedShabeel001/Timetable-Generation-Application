import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/course_model.dart';
// import '../constants/constants.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Add a course to Firestore
  Future<void> addCourse() async {
    final String courseName = courseNameController.text;
    final String description = descriptionController.text;

    // Create a new Course instance
    Course newCourse = Course(
      id: UniqueKey().toString(),
      name: courseName,
      subjectIds: [],
      description: description,
    );

    try {
      // Add course to Firestore
      DocumentReference docRef = await firestore.collection('courses').add(newCourse.toMap());
      await updateCourseWithSubjects(docRef.id);
      clearControllers();
    } catch (e) {
      print("Error adding course: $e");
      _errorMessage = "Failed to add course.";
      notifyListeners();
    }
    notifyListeners();
  }

  /// Updates the course document to include the current subjects' IDs.
  Future<void> updateCourseWithSubjects(String courseId) async {
    try {
      QuerySnapshot subjectsSnapshot = await firestore
          .collection('subjects')
          .where('courseId', isEqualTo: courseId)
          .get();

      List<String> subjectIds = subjectsSnapshot.docs.map((doc) => doc.id).toList();

      await firestore.collection('courses').doc(courseId).update({
        'subjectIds': subjectIds,
      });
    } catch (e) {
      print("Error updating course with subjects: $e");
      _errorMessage = "Failed to update course with subjects.";
      notifyListeners();
    }
  }

  // Fetch all courses from Firestore
  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await firestore.collection('courses').get();
      _courses = snapshot.docs.map((doc) {
        return Course.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      log(_courses.length.toString());
    } catch (e) {
      log("Error fetching courses: $e");
      _errorMessage = "Failed to fetch courses.";
      _courses = []; // Reset courses on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  // Remove a course by ID
  Future<void> removeCourse(String courseId) async {
    try {
      await firestore.collection('courses').doc(courseId).delete();
      _courses.removeWhere((course) => course.id == courseId);
      notifyListeners();
    } catch (error) {
      print("Error removing course: $error");
      _errorMessage = "Failed to remove course.";
      notifyListeners();
    }
  }

  void clearControllers() {
    courseNameController.clear();
    descriptionController.clear();
  }
}
