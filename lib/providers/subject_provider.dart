import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/subject_model.dart';

class SubjectProvider with ChangeNotifier {
  /// Adds a new subject to Firestore.
  void addSubject(String courseId) {
    final String subjectName = subjectNameController.text;

    Subject newSubject = Subject(
      id: UniqueKey().toString(),
      name: subjectName,
      courseId: courseId,
    );

    firestore.collection('subjects').add(newSubject.toMap()).then((docRef) {
      // Update the corresponding course with this subject's ID
      addSubjectIdToCourse(courseId, docRef.id);
      // Clear text fields after adding
      clearControllers();
    });

    notifyListeners();
  }

  /// Updates the course document to include the new subject ID.
  void addSubjectIdToCourse(String courseId, String subjectId) {
    firestore.collection('courses').doc(courseId).update({
      'subjectIds': FieldValue.arrayUnion([subjectId]),
    });
  }

  /// Clears the input controllers after use.
  void clearControllers() {
    subjectNameController.clear();
  }
}
