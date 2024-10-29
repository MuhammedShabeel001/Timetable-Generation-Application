import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/providers/staff_provider.dart';
import 'package:timetable_generation_application/providers/subject_provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_texts.dart';
import '../constants/contants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_popup.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.staffScreenTitle),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          // Fetch course suggestions and display them in the dialog
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
                        return CircularProgressIndicator(); // Show loading indicator
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No subjects available');
                      }

                      final subjects = snapshot.data!;

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Subjects',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        items: subjects.take(5).map((Map<String, String> subject) {
                          return DropdownMenuItem<String>(
                            value: subject['id'], // Use subject ID as the value
                            child: Text(subject['name'] ?? ''),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            if (!selectedSubjectIds.contains(newValue)) {
                              selectedSubjectIds.add(newValue); // Add selected subject ID
                            } else {
                              selectedSubjectIds.remove(newValue); // Remove if already selected
                            }
                          }
                        },
                        hint: const Text('Select Subjects'),
                      );
                    },
                  ),
                ],
                onSave: () {
                  if (staffNameController.text.isNotEmpty && selectedSubjectIds.isNotEmpty) {
                    Provider.of<StaffProvider>(context, listen: false)
                        .addStaff(selectedSubjectIds); // Pass the selected subject IDs
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
      ),
      body: const Center(
        child: Text('Staffs'),
      ),
    );
  }
}
