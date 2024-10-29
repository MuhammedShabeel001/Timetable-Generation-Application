import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../constants/app_colors.dart';
import '../models/staff_model.dart';
import '../providers/staff_provider.dart';
import '../providers/subject_provider.dart';

class StaffCard extends StatelessWidget {
  final Staff staff;

  const StaffCard({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: staff.name);

    return Card(
      elevation: 0,
      color: AppColors.accent,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(staff.subjectIds.length.toString(), maxLines: 3, overflow: TextOverflow.ellipsis),
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
                    title: const Text('Edit Staff Details'),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(labelText: 'Staff Name'),
                            ),
                            const SizedBox(height: 10),
                            Consumer<SubjectProvider>(
                              builder: (context, subjectProvider, _) {
                                return MultiSelectDialogField(
                                  items: subjectProvider.subjects
                                      .map((subject) => MultiSelectItem<String>(subject.id, subject.name))
                                      .toList(),
                                  title: const Text("Select Subjects"),
                                  buttonText: const Text("Select Subjects"),
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
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Staff name cannot be empty')),
                            );
                            return;
                          }
                          Provider.of<StaffProvider>(context, listen: false).updateStaff(
                            staff.id,
                            nameController.text,
                            selectedSubjectIds,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
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
                    title: const Text('Confirm Deletion'),
                    content: const Text('Are you sure you want to delete this Staff?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Provider.of<StaffProvider>(context, listen: false).removeStaff(staff.id);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete'),
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
              child: Text('Edit'),
            ),
            const PopupMenuItem<String>(
              value: 'remove',
              child: Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
