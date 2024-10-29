import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/contants.dart';
import '../models/staff_model.dart';

class StaffProvider with ChangeNotifier {
  /// Adds a new staff member to Firestore.
  void addStaff(List<String> selectedSubjectIds) {
    final String staffName = staffNameController.text;

    // Create a new Staff instance
    Staff newStaff = Staff(
      id: UniqueKey().toString(),
      name: staffName,
      subjectIds: selectedSubjectIds, // Pass the selected subject IDs
    );

    // Add staff to Firestore
    firestore.collection('staff').add(newStaff.toMap()).then((docRef) {
      // Optionally, update staff with current subject IDs if necessary
      // updateStaffWithSubjects(docRef.id, selectedSubjectIds);
      clearControllers();
    });

    notifyListeners();
  }

  void clearControllers() {
    staffNameController.clear(); // Make sure to have this controller defined in your constants
  }
}
