// // import 'dart:developer';

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import '../constants/contants.dart';
// // import '../models/staff_model.dart';

// // class StaffProvider with ChangeNotifier {
// //   List<Staff> _staff = [];
// //   bool _isLoading = false;
// //   String? _errorMessage;

// //   List<Staff> get staff => _staff;
// //   bool get isLoading => _isLoading;
// //   String? get errorMessage => _errorMessage;

// //   /// Adds a new staff member to Firestore.
// //   void addStaff(List<String> selectedSubjectIds) {
// //     final String staffName = staffNameController.text;

// //     // Create a new Staff instance
// //     Staff newStaff = Staff(
// //       id: UniqueKey().toString(),
// //       name: staffName,
// //       subjectIds: selectedSubjectIds, // Pass the selected subject IDs
// //     );

// //     // Add staff to Firestore
// //     firestore.collection('staff').add(newStaff.toMap()).then((docRef) {
// //       // Optionally, update staff with current subject IDs if necessary
// //       // updateStaffWithSubjects(docRef.id, selectedSubjectIds);
// //       clearControllers();
// //     });

// //     notifyListeners();
// //   }

// //   Future<void> fetchStaff() async {
// //     _isLoading = true;
// //     notifyListeners();

// //     try {
// //       QuerySnapshot snapshot = await firestore.collection('staff').get();
// //       _staff = snapshot.docs.map((doc) {
// //         return Staff.fromMap(doc.data() as Map<String, dynamic>, doc.id);
// //       }).toList();
// //       log(_staff.length.toString());
// //     } catch (e) {
// //       log("Error fetching courses: $e");
// //       _errorMessage = "Failed to fetch courses.";
// //       _staff = []; // Reset courses on error
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   Future<void> removeStaff(String staffId) async {
// //     try {
// //       await firestore.collection('staff').doc(staffId).delete();
// //       _staff.removeWhere((staff) => staff.id == staffId);
// //       notifyListeners();
// //     } catch (error) {
// //       print("Error removing staff: $error");
// //       _errorMessage = "Failed to remove staff.";
// //       notifyListeners();
// //     }
// //   }

// //   void clearControllers() {
// //     staffNameController
// //         .clear(); // Make sure to have this controller defined in your constants
// //   }
// // }


// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import '../constants/contants.dart';
// import '../models/staff_model.dart';

// class StaffProvider with ChangeNotifier {
//   List<Staff> _staff = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Staff> get staff => _staff;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   StaffProvider() {
//     fetchStaff();
//   }

//   Future<void> addStaff(List<String> selectedSubjectIds) async {
//     final String staffName = staffNameController.text;

//     Staff newStaff = Staff(
//       id: UniqueKey().toString(),
//       name: staffName,
//       subjectIds: selectedSubjectIds,
//     );

//     try {
//       await firestore.collection('staff').add(newStaff.toMap());
//       await fetchStaff();  // Refresh the list after adding
//       clearControllers();
//     } catch (e) {
//       print("Error adding staff: $e");
//       _errorMessage = "Failed to add staff.";
//     }
//     notifyListeners();
//   }

//   Future<void> fetchStaff() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       QuerySnapshot snapshot = await firestore.collection('staff').get();
//       _staff = snapshot.docs.map((doc) {
//         return Staff.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//       }).toList();
//       log(_staff.length.toString());
//     } catch (e) {
//       log("Error fetching staff: $e");
//       _errorMessage = "Failed to fetch staff.";
//       _staff = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> removeStaff(String staffId) async {
//     try {
//       await firestore.collection('staff').doc(staffId).delete();
//       await fetchStaff();  // Refresh the list after removing
//     } catch (e) {
//       print("Error removing staff: $e");
//       _errorMessage = "Failed to remove staff.";
//     }
//     notifyListeners();
//   }

//   Future<void> updateStaff(String staffId, String newName, List<String> newSubjectIds) async {
//   try {
//     await firestore.collection('staff').doc(staffId).update({
//       'name': newName,
//       'subjectIds': newSubjectIds,
//     });

//     // Update the local _staff list to reflect the changes
//     final staffIndex = _staff.indexWhere((staff) => staff.id == staffId);
//     if (staffIndex >= 0) {
//       _staff[staffIndex].name = newName;
//       _staff[staffIndex].subjectIds = newSubjectIds;
//       notifyListeners(); // Notify listeners to refresh the UI
//     }
//   } catch (error) {
//     print("Error updating staff: $error");
//     _errorMessage = "Failed to update staff details.";
//     notifyListeners();
//   }
// }


//   void clearControllers() {
//     staffNameController.clear();
//   }
// }












// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// // import '../constants/constants.dart'; // Ensure the path is correct
// import '../models/staff_model.dart';

// class StaffProvider with ChangeNotifier {
//   List<Staff> _staff = [];
//   bool _isLoading = false;
//   String? _errorMessage;

//   List<Staff> get staff => _staff;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   StaffProvider() {
//     fetchStaff();
//   }

//   Future<void> addStaff(String staffName, List<String> selectedSubjectIds) async {
//     Staff newStaff = Staff(
//       id: UniqueKey().toString(),
//       name: staffName,
//       subjectIds: selectedSubjectIds,
//     );

//     try {
//       await FirebaseFirestore.instance.collection('staff').add(newStaff.toMap());
//       await fetchStaff(); // Refresh the list after adding
//     } catch (e) {
//       log("Error adding staff: $e");
//       _errorMessage = "Failed to add staff.";
//       notifyListeners(); // Notify to update UI with error
//     }
//     notifyListeners();
//   }

//   Future<void> fetchStaff() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('staff').get();
//       _staff = snapshot.docs.map((doc) {
//         return Staff.fromMap(doc.data() as Map<String, dynamic>, doc.id);
//       }).toList();
//       log("Fetched staff: ${_staff.length}");
//     } catch (e) {
//       log("Error fetching staff: $e");
//       _errorMessage = "Failed to fetch staff.";
//       _staff = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<void> removeStaff(String staffId) async {
//     try {
//       await FirebaseFirestore.instance.collection('staff').doc(staffId).delete();
//       await fetchStaff(); // Refresh the list after removing
//     } catch (e) {
//       log("Error removing staff: $e");
//       _errorMessage = "Failed to remove staff.";
//       notifyListeners(); // Notify to update UI with error
//     }
//   }

//   Future<void> updateStaff(String staffId, String newName, List<String> newSubjectIds) async {
//     try {
//       await FirebaseFirestore.instance.collection('staff').doc(staffId).update({
//         'name': newName,
//         'subjectIds': newSubjectIds,
//       });

//       // Update the local _staff list to reflect the changes
//       final staffIndex = _staff.indexWhere((staff) => staff.id == staffId);
//       if (staffIndex >= 0) {
//         _staff[staffIndex].name = newName;
//         _staff[staffIndex].subjectIds = newSubjectIds;
//         notifyListeners(); // Notify listeners to refresh the UI
//       }
//     } catch (error) {
//       log("Error updating staff: $error");
//       _errorMessage = "Failed to update staff details.";
//       notifyListeners(); // Notify to update UI with error
//     }
//   }
// }









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

  Future<void> addStaff(String staffName, List<String> selectedSubjectIds) async {
    Staff newStaff = Staff(
      id: UniqueKey().toString(),
      name: staffName,
      subjectIds: selectedSubjectIds,
    );

    try {
      await FirebaseFirestore.instance.collection('staff').add(newStaff.toMap());
      await fetchStaff(); // Refresh the list after adding
    } catch (e) {
      log("Error adding staff: $e");
      _errorMessage = "Failed to add staff.";
      notifyListeners(); // Notify to update UI with error
    }
    notifyListeners();
  }

  Future<void> fetchStaff() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('staff').get();
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
      await FirebaseFirestore.instance.collection('staff').doc(staffId).delete();
      await fetchStaff(); // Refresh the list after removing
    } catch (e) {
      log("Error removing staff: $e");
      _errorMessage = "Failed to remove staff.";
      notifyListeners(); // Notify to update UI with error
    }
  }

  Future<void> updateStaff(String staffId, String newName, List<String> newSubjectIds) async {
    try {
      await FirebaseFirestore.instance.collection('staff').doc(staffId).update({
        'name': newName,
        'subjectIds': newSubjectIds,
      });

      // Update the local _staff list to reflect the changes
      final staffIndex = _staff.indexWhere((staff) => staff.id == staffId);
      if (staffIndex >= 0) {
        _staff[staffIndex].name = newName;
        _staff[staffIndex].subjectIds = newSubjectIds;
        notifyListeners(); // Notify listeners to refresh the UI
      }
    } catch (error) {
      log("Error updating staff: $error");
      _errorMessage = "Failed to update staff details.";
      notifyListeners(); // Notify to update UI with error
    }
  }
}
