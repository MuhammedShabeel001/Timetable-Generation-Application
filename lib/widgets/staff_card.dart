import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';
import 'package:timetable_generation_application/widgets/custom_snackbar.dart';

import '../constants/app_colors.dart';
import '../models/staff_model.dart';
import '../providers/staff_provider.dart';
import '../providers/subject_provider.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;

  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: staff.name);

    return Card(
      elevation: 0,
      color: AppColors.accent,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(staff.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('${staff.subjectIds.length.toString()} Subjects',
                maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              showDialog(
                context: context,
                builder: (context) {
                  List<String> selectedSubjectIds = List.from(staff.subjectIds);

                  return AlertDialog(
                    title: const Text(AppTexts.editStaff),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: AppTexts.staffName),
                            ),
                            const SizedBox(height: 10),
                            Consumer<SubjectProvider>(
                              builder: (context, subjectProvider, _) {
                                return MultiSelectDialogField(
                                  items: subjectProvider.subjects
                                      .map((subject) => MultiSelectItem<String>(
                                          subject.id, subject.name))
                                      .toList(),
                                  title: const Text(AppTexts.selectSubject),
                                  buttonText:
                                      const Text(AppTexts.selectSubject),
                                  initialValue: selectedSubjectIds,
                                  onConfirm: (values) {
                                    selectedSubjectIds = List.from(values);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(AppTexts.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Staff name cannot be empty')),
                            );
                            return;
                          }
                          Provider.of<StaffProvider>(context, listen: false)
                              .updateStaff(
                            staff.id,
                            nameController.text,
                            selectedSubjectIds,
                          );
                          Navigator.of(context).pop();
                          CustomSnackBar.show(context: context, message: 'Staff updated',);
                        },
                        child: const Text(AppTexts.save),
                      ),
                    ],
                  );
                },
              );
            } else if (value == 'remove') {
              // Show confirmation dialog before removing the staff
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(AppTexts.confirmDelete),
                    content: const Text(AppTexts.confirmDeleteMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(AppTexts.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<StaffProvider>(context, listen: false)
                              .removeStaff(staff.id);
                          Navigator.of(context).pop();
                          CustomSnackBar.show(
                            context: context,
                            message: 'Staff removed',
                            backgroundColor: AppColors.error,
                          );
                        },
                        child: const Text(AppTexts.delete),
                      ),
                    ],
                  );
                },
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text(AppTexts.edit),
            ),
            const PopupMenuItem<String>(
              value: 'remove',
              child: Text(AppTexts.delete),
            ),
          ],
        ),
      ),
    );
  }
}
