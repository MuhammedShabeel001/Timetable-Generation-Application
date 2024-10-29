import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';
import 'package:provider/provider.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(course.description),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              // Implement your edit logic here
            } else if (value == 'remove') {
              Provider.of<CourseProvider>(context, listen: false).removeCourse(course.id);
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
