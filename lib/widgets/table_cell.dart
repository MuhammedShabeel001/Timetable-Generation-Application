import 'package:flutter/material.dart';

import 'edit_dialog.dart';

class TableCellWidget extends StatelessWidget {
  final int day;
  final int period;
  final Map<String, String> cell;

  const TableCellWidget({
    required this.day,
    required this.period,
    required this.cell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showEditDialog(context, day, period, cell),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cell['subject'] ?? 'No Subject',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              cell['staff'] ?? 'No Staff',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
