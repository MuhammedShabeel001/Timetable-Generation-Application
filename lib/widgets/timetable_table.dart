import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/timetable_provider.dart';
import 'table_cell.dart';

class TimetableTable extends StatelessWidget {
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  final List<String> periods = ['Period 1', 'Period 2', 'Period 3', 'Period 4'];

  TimetableTable({super.key});

  @override
  Widget build(BuildContext context) {
    final timetableProvider = Provider.of<TimetableProvider>(context);

    return Table(
      border: TableBorder.all(),
      columnWidths: const {0: FixedColumnWidth(100.0)}, // Fixed width for the days column
      children: [
        // Top row with period labels
        TableRow(
          children: [
            const TableCell(child: Center(child: Text(''))), // Empty top-left cell
            ...periods.map((period) => Center(child: Text(period, style: const TextStyle(fontWeight: FontWeight.bold)))),
          ],
        ),
        // Rows for each day
        ...List.generate(5, (day) {
          return TableRow(
            children: [
              // Day label cell
              Center(child: Text(days[day], style: const TextStyle(fontWeight: FontWeight.bold))),
              // Cells for each period
              ...List.generate(4, (period) {
                final cell = timetableProvider.timetable[day][period];
                return TableCellWidget(day: day, period: period, cell: cell);
              }),
            ],
          );
        }),
      ],
    );
  }
}
