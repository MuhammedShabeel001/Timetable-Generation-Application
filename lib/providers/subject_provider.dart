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

  Future<List<Map<String, String>>> getSubjectSuggestions(String query) async {
  try {
    QuerySnapshot snapshot = await firestore
        .collection('subjects')
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
    print("Error fetching subject suggestions: $e");
    return [];
  }
}

  /// Clears the input controllers after use.
  void clearControllers() {
    subjectNameController.clear();
  }
}
