import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/subject_model.dart';

class SubjectProvider with ChangeNotifier {
  List<Subject> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Subject> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SubjectProvider() {
    fetchSubjects();
  }

  Future<void> addSubject(String courseId) async {
    final String subjectName = subjectNameController.text;

    Subject newSubject = Subject(
      id: UniqueKey().toString(),
      name: subjectName,
      courseId: courseId,
    );

    try {
      DocumentReference docRef =
          await firestore.collection('subjects').add(newSubject.toMap());
      await addSubjectIdToCourse(courseId, docRef.id);
      await fetchSubjects();
      clearControllers();
    } catch (e) {
      log("Error adding subject: $e");
      _errorMessage = "Failed to add subject.";
    }
    notifyListeners();
  }

  Future<void> addSubjectIdToCourse(String courseId, String subjectId) async {
    try {
      await firestore.collection('courses').doc(courseId).update({
        'subjectIds': FieldValue.arrayUnion([subjectId]),
      });
    } catch (e) {
      log("Error updating course with new subject ID: $e");
      _errorMessage = "Failed to update course with new subject ID.";
      notifyListeners();
    }
  }

  Future<void> fetchSubjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await firestore.collection('subjects').get();
      _subjects = snapshot.docs.map((doc) {
        return Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      log(_subjects.length.toString());
    } catch (e) {
      log("Error fetching subjects: $e");
      _errorMessage = "Failed to fetch subjects.";
      _subjects = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSubject(String subjectId, String newName) async {
    try {
      await firestore
          .collection('subjects')
          .doc(subjectId)
          .update({'name': newName});
      await fetchSubjects();
    } catch (e) {
      log("Error updating subject: $e");
      _errorMessage = "Failed to update subject.";
    }
    notifyListeners();
  }

  Future<void> removeSubject(String subjectId) async {
    try {
      await firestore.collection('subjects').doc(subjectId).delete();
      await fetchSubjects();
    } catch (e) {
      log("Error removing subject: $e");
      _errorMessage = "Failed to remove subject.";
    }
    notifyListeners();
  }

  Future<List<Map<String, String>>> getSubjectSuggestions(String query) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('subjects')
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
      log("Error fetching subject suggestions: $e");
      return [];
    }
  }

  void clearControllers() {
    subjectNameController.clear();
  }
}
