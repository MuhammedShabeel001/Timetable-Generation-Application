import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CourseShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
