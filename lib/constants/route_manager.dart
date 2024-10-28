import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_routes.dart';
import 'package:timetable_generation_application/screens/cource_screen.dart';
import 'package:timetable_generation_application/screens/main_screen.dart';
import 'package:timetable_generation_application/screens/staff_screen.dart';
import 'package:timetable_generation_application/screens/subject_screen.dart';


class RouteManager {
  // This method generates the appropriate route based on the route name
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
      // case AppRoutes.timetableGeneration:
      //   return MaterialPageRoute(builder: (_) => TimetableGenerationScreen());
      // case AppRoutes.daysAndPeriodsSetup:
      //   return MaterialPageRoute(builder: (_) => DaysAndPeriodsSetupScreen());
      // case AppRoutes.staffAssignment:
      //   return MaterialPageRoute(builder: (_) => StaffAssignmentScreen());
      default:
        return _errorRoute();
    }
  }

  // Optional: Display an error page if an unknown route is accessed
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
