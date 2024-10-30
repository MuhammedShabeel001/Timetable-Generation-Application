import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/staff_model.dart';

class StaffProvider with ChangeNotifier {
  List<Staff> _staff = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Staff> get staff => _staff;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  StaffProvider() {
    fetchStaff();
  }

  Future<void> addStaff(
      String staffName, List<String> selectedSubjectIds) async {
    Staff newStaff = Staff(
      id: UniqueKey().toString(),
      name: staffName,
      subjectIds: selectedSubjectIds,
    );

    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .add(newStaff.toMap());
      await fetchStaff();
    } catch (e) {
      log("Error adding staff: $e");
      _errorMessage = "Failed to add staff.";
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> fetchStaff() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('staff').get();
      _staff = snapshot.docs.map((doc) {
        return Staff.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      log("Fetched staff: ${_staff.length}");
    } catch (e) {
      log("Error fetching staff: $e");
      _errorMessage = "Failed to fetch staff.";
      _staff = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeStaff(String staffId) async {
    try {
      await FirebaseFirestore.instance
          .collection('staff')
          .doc(staffId)
          .delete();
      await fetchStaff();
    } catch (e) {
      log("Error removing staff: $e");
      _errorMessage = "Failed to remove staff.";
      notifyListeners();
    }
  }

  Future<void> updateStaff(
      String staffId, String newName, List<String> newSubjectIds) async {
    try {
      await FirebaseFirestore.instance.collection('staff').doc(staffId).update({
        'name': newName,
        'subjectIds': newSubjectIds,
      });

      final staffIndex = _staff.indexWhere((staff) => staff.id == staffId);
      if (staffIndex >= 0) {
        _staff[staffIndex].name = newName;
        _staff[staffIndex].subjectIds = newSubjectIds;
        notifyListeners();
      }
    } catch (error) {
      log("Error updating staff: $error");
      _errorMessage = "Failed to update staff details.";
      notifyListeners();
    }
  }
}
