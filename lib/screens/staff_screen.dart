import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/providers/staff_provider.dart';
import 'package:timetable_generation_application/widgets/shimmer_loading.dart';
import 'package:timetable_generation_application/widgets/staff_card.dart';
import 'package:timetable_generation_application/widgets/staff_fab.dart';

import '../constants/app_texts.dart';
import '../widgets/custom_appbar.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final staffProvider = Provider.of<StaffProvider>(context);

    return  Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.staffScreenTitle),
      ),
      floatingActionButton: StaffFAB(),
      body: Consumer<StaffProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return CourseShimmer();
          } else if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.staff.isEmpty) {
            return const Center(child: Text('No subject available'));
          }

          return ListView.builder(
            itemCount: provider.staff.length,
            itemBuilder: (context, index) {
              return StaffCard(staff: provider.staff[index]);
            },
          );
        },
      ),
    );
  }
}
