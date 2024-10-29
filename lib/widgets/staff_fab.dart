// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
// import '../constants/app_colors.dart';
// import '../constants/contants.dart';
// import '../providers/staff_provider.dart';
// import '../providers/subject_provider.dart';
// import '../widgets/custom_popup.dart';

// class StaffFAB extends StatelessWidget {
//   const StaffFAB({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//         backgroundColor: AppColors.primary,
//         onPressed: () {
//           // Fetch course suggestions and display them in the dialog
//           showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (_) {
//               List<String> selectedSubjectIds = [];

//               return CustomPopup(
//                 title: 'Add Staff',
//                 fields: [
//                   TextField(
//                     controller: staffNameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Staff Name',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   FutureBuilder<List<Map<String, String>>>(
//                     future: Provider.of<SubjectProvider>(context, listen: false)
//                         .getSubjectSuggestions(''), // Fetch all subjects
//                     builder: (context, snapshot) {
//                       // Handle loading state in the dropdown
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Subject',
//                           border: OutlineInputBorder(),
//                         ),
//                         value: null,
//                         items: const [],
//                         hint: const Text('Loading...'),
//                         onChanged: null, // Disable onChanged while loading
//                       ); // Show loading indicator
//                       } else if (snapshot.hasError) {
//                         return DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Subject',
//                           border: OutlineInputBorder(),
//                         ),
//                         value: null,
//                         items: const [],
//                         hint: const Text('Something went wrong'),
//                         onChanged: null, // Disable onChanged on error
//                       );
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Subject',
//                           border: OutlineInputBorder(),
//                         ),
//                         value: null,
//                         items: const [],
//                         hint: const Text('No subjects available'),
//                         onChanged: null, // Disable onChanged if no courses
//                       );
//                       }

//                       final subjects = snapshot.data!;

//                       return DropdownButtonFormField<String>(
//                         decoration: const InputDecoration(
//                           labelText: 'Select Subjects',
//                           border: OutlineInputBorder(),
//                         ),
//                         isExpanded: true,
//                         items: subjects.take(5).map((Map<String, String> subject) {
//                           return DropdownMenuItem<String>(
//                             value: subject['id'], // Use subject ID as the value
//                             child: Text(subject['name'] ?? ''),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           if (newValue != null) {
//                             if (!selectedSubjectIds.contains(newValue)) {
//                               selectedSubjectIds.add(newValue); // Add selected subject ID
//                             } else {
//                               selectedSubjectIds.remove(newValue); // Remove if already selected
//                             }
//                           }
//                         },
//                         hint: const Text('Select Subjects'),
//                       );
//                     },
//                   ),
//                 ],
//                 onSave: () {
//                   if (staffNameController.text.isNotEmpty && selectedSubjectIds.isNotEmpty) {
//                     Provider.of<StaffProvider>(context, listen: false)
//                         .addStaff(selectedSubjectIds); // Pass the selected subject IDs
//                     log(staffNameController.text);
//                   }
//                   Navigator.of(context).pop();
//                 },
//                 onClose: () => Navigator.of(context).pop(),
//               );
//             },
//           );
//         },
//         child: const FaIcon(
//           FontAwesomeIcons.plus,
//           color: Colors.white,
//         ),
//       );
//   }
// }











import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart'; // Import the multi_select_flutter package
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/staff_provider.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_popup.dart';

class StaffFAB extends StatelessWidget {
  const StaffFAB({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the staff name
    final TextEditingController staffNameController = TextEditingController();

    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            List<String> selectedSubjectIds = [];

            return CustomPopup(
              title: 'Add Staff',
              fields: [
                TextField(
                  controller: staffNameController,
                  decoration: const InputDecoration(
                    labelText: 'Staff Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, String>>>(
                  future: Provider.of<SubjectProvider>(context, listen: false)
                      .getSubjectSuggestions(''), // Fetch all subjects
                  builder: (context, snapshot) {
                    // Handle loading state in the dropdown
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show loading indicator
                    } else if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No subjects available');
                    }

                    final subjects = snapshot.data!;
                    final subjectItems = subjects.map((subject) {
                      return MultiSelectItem<String>(
                        subject['id']!,
                        subject['name'] ?? '',
                      );
                    }).toList();

                    return MultiSelectDialogField(
                      items: subjectItems,
                      title: const Text('Select Subjects'),
                      buttonText: const Text('Select Subjects'),
                      onConfirm: (values) {
                        selectedSubjectIds = List<String>.from(values);
                      },
                    );
                  },
                ),
              ],
              onSave: () {
                if (staffNameController.text.isNotEmpty && selectedSubjectIds.isNotEmpty) {
                  Provider.of<StaffProvider>(context, listen: false)
                      .addStaff(staffNameController.text, selectedSubjectIds); // Pass the selected subject IDs
                  log(staffNameController.text);
                }
                Navigator.of(context).pop();
              },
              onClose: () => Navigator.of(context).pop(),
            );
          },
        );
      },
      child: const FaIcon(
        FontAwesomeIcons.plus,
        color: Colors.white,
      ),
    );
  }
}
