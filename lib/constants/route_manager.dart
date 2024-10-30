import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_routes.dart';
import 'package:timetable_generation_application/screens/cource_screen.dart';
import 'package:timetable_generation_application/screens/main_screen.dart';
import 'package:timetable_generation_application/screens/staff_screen.dart';
import 'package:timetable_generation_application/screens/subject_screen.dart';

class RouteManager {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRoutes.courseManagement:
        return MaterialPageRoute(builder: (_) => const CourseScreen());
      case AppRoutes.subjectManagement:
        return MaterialPageRoute(builder: (_) => const SubjectScreen());
      case AppRoutes.staffManagement:
        return MaterialPageRoute(builder: (_) => const StaffScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
