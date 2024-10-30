import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/widgets/custom_snackbar.dart';
import '../constants/app_colors.dart';
import '../providers/staff_provider.dart';
import '../providers/subject_provider.dart';
import '../widgets/custom_popup.dart';

class StaffFAB extends StatelessWidget {
  const StaffFAB({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: AppTexts.addStaff,
              fields: [
                TextField(
                  controller: staffNameController,
                  decoration: const InputDecoration(
                    labelText: AppTexts.staffName,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Map<String, String>>>(
                  future: Provider.of<SubjectProvider>(context, listen: false)
                      .getSubjectSuggestions(''),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text(AppTexts.error);
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(AppTexts.noStaffAvailable);
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
                      title: const Text(AppTexts.selectSubject),
                      buttonText: const Text(AppTexts.selectSubject),
                      onConfirm: (values) {
                        selectedSubjectIds = List<String>.from(values);
                      },
                    );
                  },
                ),
              ],
              onSave: () {
                if (staffNameController.text.isNotEmpty &&
                    selectedSubjectIds.isNotEmpty) {
                  Provider.of<StaffProvider>(context, listen: false)
                      .addStaff(staffNameController.text, selectedSubjectIds);
                  log(staffNameController.text);
                }
                Navigator.of(context).pop();
                CustomSnackBar.show(
                  context: context,
                  message: 'New staff added',
                  backgroundColor: AppColors.success,
                );
              },
              onClose: () => Navigator.of(context).pop(),
            );
          },
        );
      },
      child: const FaIcon(
        FontAwesomeIcons.plus,
        color: AppColors.cardBackground,
      ),
    );
  }
}
