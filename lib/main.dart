import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/constants/app_routes.dart';
import 'package:timetable_generation_application/constants/route_manager.dart';
import 'package:timetable_generation_application/providers/staff_provider.dart';
import 'package:timetable_generation_application/providers/subject_provider.dart';
import 'package:timetable_generation_application/providers/timetable_provider.dart';
import 'package:timetable_generation_application/services/firebase_options.dart';
import 'package:timetable_generation_application/providers/course_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Create a dummy TimetableProvider with placeholder values
  // final timetableProvider = TimetableProvider('1', 'Weekly Timetable', 'course_001');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CourseProvider()),
      ChangeNotifierProvider(create: (context) => SubjectProvider()),
      ChangeNotifierProvider(create: (context) => StaffProvider()),
      ChangeNotifierProvider(create: (context) => TimetableProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Timetable Generator',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
