import 'package:flutter/material.dart';
import 'package:timetable_generation_application/widgets/staff_fab.dart';

import '../constants/app_texts.dart';
import '../widgets/custom_appbar.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.staffScreenTitle),
      ),
      floatingActionButton: StaffFAB(),
      body: Center(
        child: Text('Staffs'),
      ),
    );
  }
}
