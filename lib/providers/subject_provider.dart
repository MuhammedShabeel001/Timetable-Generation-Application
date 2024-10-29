// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../constants/contants.dart';
// import '../models/subject_model.dart';

// class SubjectProvider with ChangeNotifier {
//   List<Subject> _subject = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Subject> get subject => _subject;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   /// Adds a new subject to Firestore.
//   void addSubject(String courseId) {
//     final String subjectName = subjectNameController.text;

//     Subject newSubject = Subject(
//       id: UniqueKey().toString(),
//       name: subjectName,
//       courseId: courseId,
//     );

//     firestore.collection('subjects').add(newSubject.toMap()).then((docRef) {
//       // Update the corresponding course with this subject's ID
//       addSubjectIdToCourse(courseId, docRef.id);
//       // Clear text fields after adding
//       clearControllers();
//     });

//     notifyListeners();
//   }

//   /// Updates the course document to include the new subject ID.
//   void addSubjectIdToCourse(String courseId, String subjectId) {
//     firestore.collection('courses').doc(courseId).update({
//       'subjectIds': FieldValue.arrayUnion([subjectId]),
//     });
//   }

//   Future<List<Map<String, String>>> getSubjectSuggestions(String query) async {
//     try {
//       QuerySnapshot snapshot = await firestore
//           .collection('subjects')
//           .where('name', isGreaterThanOrEqualTo: query)
//           .where('name', isLessThanOrEqualTo: '$query\uf8ff')
//           .get();

//       // Extract course IDs and names from the fetched documents
//       List<Map<String, String>> courseData = snapshot.docs.map((doc) {
//         return {
//           'id': doc.id,
//           'name': doc['name'] as String,
//         };
//       }).toList();

//       return courseData;
//     } catch (e) {
//       print("Error fetching subject suggestions: $e");
//       return [];
//     }
//   }

//   Future<void> fetchSubject() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       QuerySnapshot snapshot = await firestore.collection('subjects').get();
//       _subject = snapshot.docs.map((doc) {
//         return Subject.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//       }).toList();
//       log(_subject.length.toString());
//     } catch (e) {
//       log("Error fetching courses: $e");
//       _errorMessage = "Failed to fetch courses.";
//       _subject = []; // Reset courses on error
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> updateSubject(String subjectId, String newName) async {
//     try {
//       await firestore.collection('subjects').doc(subjectId).update({
//         'name': newName,
//       });
//       // Update the local list of subjects
//       final subjectIndex =
//           _subject.indexWhere((subject) => subject.id == subjectId);
//       if (subjectIndex >= 0) {
//         _subject[subjectIndex].name = newName; // Update the name locally
//         notifyListeners(); // Notify listeners to update the UI
//       }
//     } catch (error) {
//       print("Error updating subject: $error");
//       // Handle error appropriately (e.g., show a message)
//     }
//   }

//   Future<void> removeSubject(String subjectId) async {
//     try {
//       await firestore.collection('subjects').doc(subjectId).delete();
//       _subject.removeWhere((subject) => subject.id == subjectId);
//       notifyListeners();
//     } catch (error) {
//       print("Error removing subject: $error");
//       _errorMessage = "Failed to remove subject.";
//       notifyListeners();
//     }
//   }

//   /// Clears the input controllers after use.
//   void clearControllers() {
//     subjectNameController.clear();
//   }
// }



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
      DocumentReference docRef = await firestore.collection('subjects').add(newSubject.toMap());
      await addSubjectIdToCourse(courseId, docRef.id);
      await fetchSubjects();  // Refresh the list after adding
      clearControllers();
    } catch (e) {
      print("Error adding subject: $e");
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
      print("Error updating course with new subject ID: $e");
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
      await firestore.collection('subjects').doc(subjectId).update({'name': newName});
      await fetchSubjects();  // Refresh the list after updating
    } catch (e) {
      print("Error updating subject: $e");
      _errorMessage = "Failed to update subject.";
    }
    notifyListeners();
  }

  Future<void> removeSubject(String subjectId) async {
    try {
      await firestore.collection('subjects').doc(subjectId).delete();
      await fetchSubjects();  // Refresh the list after removing
    } catch (e) {
      print("Error removing subject: $e");
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

  void clearControllers() {
    subjectNameController.clear();
  }
}
