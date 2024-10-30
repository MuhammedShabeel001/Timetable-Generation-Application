
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/course_model.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  CourseProvider() {
    fetchCourses();
  }

  Future<void> addCourse() async {
    final String courseName = courseNameController.text;
    final String description = descriptionController.text;

    Course newCourse = Course(
      id: UniqueKey().toString(),
      name: courseName,
      subjectIds: [],
      description: description,
    );

    try {
      await firestore.collection('courses').add(newCourse.toMap());
      await fetchCourses();
      clearControllers();
    } catch (e) {
      log("Error adding course: $e");
      _errorMessage = "Failed to add course.";
    }
    notifyListeners();
  }

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await firestore.collection('courses').get();
      _courses = snapshot.docs.map((doc) {
        return Course.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      _errorMessage = "Failed to fetch courses.";
      _courses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(
      String courseId, String newName, String newDescription) async {
    try {
      await firestore.collection('courses').doc(courseId).update({
        'name': newName,
        'description': newDescription,
      });
      await fetchCourses();
    } catch (e) {
      log("Error updating course: $e");
      _errorMessage = "Failed to update course.";
    }
    notifyListeners();
  }

  Future<void> removeCourse(String courseId) async {
    try {
      await firestore.collection('courses').doc(courseId).delete();
      await fetchCourses();
    } catch (e) {
      log("Error removing course: $e");
      _errorMessage = "Failed to remove course.";
    }
    notifyListeners();
  }

  String getCourseNameById(String courseId) {
    final course = _courses.firstWhere(
      (course) => course.id == courseId,
      orElse: () => Course(
          id: 'unknown',
          name: 'Unknown Course',
          subjectIds: [],
          description: 'No description available.'),
    );
    return course.name;
  }

  Future<List<Map<String, String>>> getCourseSuggestions(String query) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('courses')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      List<Map<String, String>> courseData = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] as String,
        };
      }).toList();

      return courseData;
    } catch (e) {
      log("Error fetching course suggestions: $e");
      return [];
    }
  }

  void clearControllers() {
    courseNameController.clear();
    descriptionController.clear();
  }
}
