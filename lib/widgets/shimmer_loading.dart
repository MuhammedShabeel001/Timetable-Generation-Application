import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timetable_generation_application/constants/app_colors.dart';

class CourseShimmer extends StatelessWidget {
  const CourseShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.textThird,
          highlightColor: AppColors.textLight,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Container(
                height: 20,
                width: double.infinity,
                color: AppColors.background,
              ),
              subtitle: Container(
                height: 14,
                width: double.infinity,
                color: AppColors.background,
              ),
            ),
          ),
        );
      },
    );
  }
}
